(*** Formal Construction of a Set Theory in Coq ***)
(** based on the thesis by Jonas Kaiser, November 23, 2012 **)
(** Coq coding by choukh, April 2020 **)

Require Export ZFC.TG1.

(*** TG集合论2：二元并，集族并，建构式，任意交，二元交，有序对 ***)

(** 二元并 **)
Definition BUnion : set → set → set := λ X Y, ⋃{X, Y}.
Notation "X ∪ Y" := (BUnion X Y) (at level 50).

Lemma BUnionI1 : ∀ w X Y, w∈X → w ∈ X∪Y.
Proof.
  intros. apply UnionI with X.
  - apply PairI1.
  - apply H.
Qed.

Lemma BUnionI2 : ∀ w X Y, w∈Y → w ∈ X∪Y.
Proof.
  intros. apply UnionI with Y.
  - apply PairI2.
  - apply H.
Qed.

Lemma BUnionE : ∀ w X Y, w ∈ X∪Y → w∈X ∨ w∈Y.
Proof.
  intros. apply UnionAx in H.
  destruct H as [z [H1 H2]].
  apply PairE in H1.
  destruct H1 ; subst; auto.
Qed.

Lemma GUBUnion : ∀ N X Y, X ∈ 𝒰(N) → Y ∈ 𝒰(N) → X∪Y ∈ 𝒰(N).
Proof. intros. apply GUUnion. apply GUPair. apply H. apply H0. Qed.

(** 集族的并 **)
Definition FUnion : set → (set → set) → set := λ X F, ⋃{F|x ∊ X}.

Lemma FUnionI : ∀ X F, ∀x ∈ X, ∀y ∈ F x, y ∈ ⋃{F|x ∊ X}.
Proof.
  introq. eapply UnionI.
  - apply ReplI. apply H.
  - apply H0.
Qed.

Lemma FUnionE : ∀ X F, ∀y ∈ ⋃{F|x ∊ X}, ∃x ∈ X, y ∈ F x.
Proof.
  introq.
  apply UnionAx in H.
  destruct H as [y [H1 H2]].
  apply ReplE in H1.
  destruct H1 as [z [H3 H4]].
  exists z. subst. auto.
Qed. 

Lemma GUFUnion : ∀ N F, ∀X ∈ 𝒰(N),
  (∀x ∈ X, F x ∈ 𝒰(N)) → ⋃{F|x ∊ X} ∈ 𝒰(N).
Proof with unfoldq.
  introq.
  apply GUUnion, GURepl...
  apply H. apply H0.
Qed.

Example funion_0 : ∀ F, ⋃{F|x ∊ ∅} = ∅.
Proof. intros. rewrite repl0I. apply union_0_0. Qed.

Example funion_1 : ∀ X F,
  (∀x ∈ X, F x ∈ 2) → (∃x ∈ X, F x = 1) → ⋃{F|x ∊ X} = 1.
Proof.
  introq.
  assert (∀ x ∈ ⋃{F | x ∊ X}, x = ∅). {
    introq. apply FUnionE in H1.
    destruct H1 as [y [H1 H2]].
    apply H in H1.
    eapply empty_1_2_0. apply H2. apply H1.
  }
  apply ExtAx. split; intros.
  - apply H1 in H2. subst. apply OneI1.
  - apply UnionAx. exists 1. split.
    + apply ReplAx in H0. apply H0. 
    + apply H2.
Qed.

Example funion_const : ∀ X F C,
  ⦿ X → (∀x ∈ X, F x = C) → ⋃{F|x ∊ X} = C.
Proof.
  introq. apply ExtAx. split; intros.
  - apply FUnionE in H1. destruct H1 as [y [H1 H2]].
    apply H0 in H1. subst. auto.
  - destruct H as [y H]. eapply FUnionI.
    apply H. apply H0 in H. subst. auto.
Qed.

Example funion_const_0 : ∀ X F, 
  (∀x ∈ X, F x = ∅) → ⋃{F|x ∊ X} = ∅.
Proof.
  introq. destruct (empty_or_inh X).
  - subst. apply funion_0.
  - exact (funion_const X F ∅ H0 H).
Qed.

Set Firstorder Solver unfoldq.
Print Firstorder Solver.

Example funion_2 : ∀ X F, 
  (∀x ∈ X, F x ∈ 2) → ⋃{F|x ∊ X} ∈ 2.
Proof with firstorder.
  introq. destruct (classic (∃x ∈ X, F x = 1)); unfoldq. 
  - pose proof (funion_1 X F H H0).
    rewrite H1. apply TwoI2.
  - assert (∀x ∈ X, F x = ∅). {
      introq. apply H in H1 as H2.
      apply TwoE in H2. destruct H2... 
    }
    pose proof (funion_const_0 X F H1).
    rewrite H2. apply TwoI1.
Qed.

(** 集合建构式 **)
Definition Sep : set → (set → Prop) → set := λ X P,
  ε (inhabits ∅) (λ Z, ∀ x, x ∈ Z ↔ x ∈ X ∧ P x).
Notation "{ x ∊ X | P }" := (Sep X (λ x, P x)).

(* 用ε算子，从替代公理和空集公理导出Zermelo分类公理 *)
Theorem sep_correct : ∀ X P x, x ∈ {x ∊ X | P} ↔ x ∈ X ∧ P x.
Proof with unfoldq.
  intros X P. unfold Sep. apply ε_spec.
  destruct (classic (∃x ∈ X, P x)).
  - destruct H as [x0 [H1 H2]].
    set (F_spec := λ x y, (P x ∧ x = y) ∨ (~ P x ∧ x0 = y)).
    set (F := λ x, ε (inhabits ∅) (F_spec x)).
    assert (F_tauto: ∀ x, F_spec x (F x)). {
      intros. unfold F. apply ε_spec.
      unfold F_spec. destruct (classic (P x)).
      - exists x. left. auto.
      - exists x0. right. auto.
    }
    assert (A: ∀ x,   P x → x  = F x) by firstorder.
    assert (B: ∀ x, ~ P x → x0 = F x) by firstorder.
    exists {F | x ∊ X}. split; intros.
    + apply ReplE in H... destruct H as [x' [H3 H4]].
      destruct (classic (P x')).
      * apply A in H as H5. rewrite H4 in H5.
        rewrite <- H5. auto.
      * apply B in H as H5. rewrite H4 in H5.
        rewrite <- H5. auto.
    + apply ReplAx... destruct H as [H3 H4].
      apply A in H4. exists x. auto.
  - exists ∅. firstorder using EmptyE.
Qed.

Lemma SepI : ∀ X (P : set → Prop), ∀x ∈ X, P x → x ∈ {x ∊ X | P}.
Proof. introq. apply sep_correct. auto. Qed.

Lemma SepE1 : ∀ X P, ∀x ∈ {x ∊ X | P}, x ∈ X.
Proof. introq. apply sep_correct in H. firstorder. Qed.

Lemma SepE2 : ∀ X P, ∀x ∈ {x ∊ X | P}, P x.
Proof. introq. apply sep_correct in H. firstorder. Qed.

Lemma SepE : ∀ X P, ∀x ∈ {x ∊ X | P}, x ∈ X ∧ P x.
Proof. introq. apply sep_correct in H. apply H. Qed.

Lemma sep_sub : ∀ X P, {x ∊ X | P} ⊆ X.
Proof. unfold Sub. exact SepE1. Qed.

Lemma sep_power : ∀ X P, {x ∊ X | P} ∈ 𝒫(X).
Proof. intros. apply PowerAx. apply sep_sub. Qed.

Lemma GUSep : ∀ N P, ∀X ∈ 𝒰(N), {x ∊ X | P} ∈ 𝒰(N).
Proof.
  introq. eapply GUTrans. apply sep_power.
  apply GUPower. apply H.
Qed.

Lemma sep_0 : ∀ P, {x ∊ ∅ | P} = ∅.
Proof. intros. apply sub_0_iff_0. apply sep_sub. Qed.

Lemma sep_0_inv : ∀ X P, {x ∊ X | P} = ∅ -> ∀x ∈ X, ~ P x.
Proof.
  unfold not. introq.
  cut (x ∈ ∅). intros. exfalso0.
  rewrite <- H. apply SepI; auto.
Qed.

Lemma sep_1 : ∀ P, {x ∊ 1 | P} = ∅ ∨ {x ∊ 1 | P} = 1.
Proof. intros. apply sub_1. apply sep_sub. Qed.

Lemma sep_sing : ∀ x P,
  ( P x ∧ {x ∊ ⎨x⎬ | P} = ⎨x⎬) ∨
  (¬P x ∧ {x ∊ ⎨x⎬ | P} = ∅).
Proof with auto.
  intros. pose proof (sep_sub ⎨x⎬ P).
  apply sub_sing in H. destruct H.
  - rewrite H. right. split...
    eapply sep_0_inv. apply H. apply SingI.
  - rewrite H. left. split...
    apply (SepE2 ⎨x⎬). rewrite H. apply SingI.
Qed.

(** 任意交 **)
Definition Inter : set -> set :=
  λ Y, {x ∊ ⋃Y | (λ x, ∀y ∈ Y, x ∈ y)}.
Notation "⋂ X" := (Inter X) (at level 9, right associativity).

Lemma InterI : ∀ x Y, ⦿ Y → (∀y ∈ Y, x ∈ y) → x ∈ ⋂Y.
Proof.
  unfold Inter. introq.
  destruct H as [y H]. apply SepI.
  - eapply UnionI. apply H. apply H0. apply H.
  - apply H0.
Qed.

Lemma InterE : ∀ Y, ∀x ∈ ⋂Y, ⦿Y ∧ ∀y ∈ Y, x ∈ y.
Proof.
  introq. apply SepE in H as [H1 H2].
  unfoldq. apply UnionE1 in H1. auto.
Qed.

Lemma GUInter : ∀ N, ∀X ∈ 𝒰(N), ⋂X ∈ 𝒰(N).
Proof. introq. apply GUSep. apply GUUnion. apply H. Qed.

Fact inter_0 : ⋂ ∅ = ∅.
Proof.
  unfold Inter. unfoldq.
  rewrite union_0_0. rewrite sep_0. reflexivity.
Qed.

(** 二元交 **)
Definition BInter : set → set → set := λ X Y, ⋂{X, Y}.
Notation "X ∩ Y" := (BInter X Y) (at level 49).

Lemma BInterI : ∀ x X Y, x ∈ X → x ∈ Y → x ∈ X ∩ Y.
Proof.
  intros. apply InterI.
  - exists X. apply PairI1.
  - introq. apply PairE in H1. destruct H1.
    + subst. apply H.
    + subst. apply H0.
Qed.

Lemma BInterE : ∀ X Y, ∀x ∈ X ∩ Y, x ∈ X ∧ x ∈ Y.
Proof.
  introq. apply InterE in H as [_ H]. unfoldq. split.
  - apply H. apply PairI1.
  - apply H. apply PairI2.
Qed.

Example inter_self_0 : ∀ a, a ∩ a = ∅ → a = ∅.
Proof.
  intros. apply EmptyI. intros x H1.
  pose proof ((EmptyE H) x).
  apply H0. apply BInterI; apply H1.
Qed.

Example inter_eq_0_e : ∀ a b, ⦿a → a ∩ b = ∅ → a ≠ b.
Proof.
  unfold not. intros. subst.
  apply inter_self_0 in H0.
  destruct H as [x H]. subst. exfalso0.
Qed.

(** 有序对 **)
Definition OPair : set → set → set := λ x y, {⎨x⎬, {x, y}}.
Notation "< x , y , .. , z >" :=
  ( OPair .. ( OPair x y ) .. z ) (z at level 69).

Definition π1 : set → set := λ p, ⋃ ⋂ p.
Definition π2 : set → set := λ p,
  ⋃ {x ∊ ⋃p | λ x, x ∈ ⋂p → ⋃p = ⋂p}.

Lemma op_union : ∀ x y, ⋃<x, y> = {x, y}.
Proof.
  intros. apply ExtAx. intros a. split; intros.
  - apply UnionAx in H. unfoldq.
    destruct H as [A [H1 H2]].
    apply PairE in H1. destruct H1.
    + rewrite H in H2. apply SingE in H2.
      subst. apply PairI1.
    + rewrite H in H2. apply H2.
  - unfold OPair. apply PairE in H. destruct H.
    + subst. apply BUnionI1. apply SingI.
    + subst. apply BUnionI2. apply PairI2.
Qed.

Lemma op_inter : ∀ x y, ⋂<x, y> = ⎨x⎬.
Proof.
  intros. apply ExtAx. intros a. split; intros.
  - apply InterE in H as [_ H]. unfoldq.
    apply H. apply PairI1.
  - apply SingE in H. subst. apply InterI.
    + exists ⎨x⎬. apply PairI1.
    + introq. apply PairE in H. destruct H.
      * subst. apply SingI.
      * subst. apply PairI1.
Qed.

Lemma π1_correct : ∀ x y, π1 <x, y> = x.
Proof.
  unfold π1. intros. rewrite op_inter.
  rewrite union_sing_x_x. reflexivity. 
Qed.

Lemma pair_eq_pair_i : ∀ a b c d, {a, b} = {c, d} ->
  (a = c ∧ b = d) ∨ (a = d ∧ b = c).
Proof.
  intros.
  assert (a ∈ {c, d}). rewrite <- H. apply PairI1.
  assert (b ∈ {c, d}). rewrite <- H. apply PairI2.
  assert (c ∈ {a, b}). rewrite H. apply PairI1.
  assert (d ∈ {a, b}). rewrite H. apply PairI2.
  apply PairE in H0. apply PairE in H1.
  apply PairE in H2. apply PairE in H3.
  destruct H0, H1, H2, H3; auto.
Qed.

Lemma sing_eq_pair_i : ∀ a b c, ⎨a⎬ = {b, c} → a = b ∧ a = c.
Proof. intros. apply pair_eq_pair_i in H. firstorder. Qed.

Lemma pair_eq_sing_i : ∀ a b c, {b, c} = ⎨a⎬ → a = b ∧ a = c.
Proof.
  intros. apply eq_sym in H.
  apply sing_eq_pair_i. apply H.
Qed.

Lemma sing_eq_sing_i : ∀ a b, ⎨a⎬ = ⎨b⎬ → a = b.
Proof. intros. apply sing_eq_pair_i in H. firstorder. Qed.

Lemma π2_correct : ∀ x y, π2 <x, y> = y.
Proof with unfoldq.
  unfold π2. intros.
  rewrite op_union in *.
  rewrite op_inter in *.
  apply ExtAx. intros a. split; intros.
  - apply UnionAx in H... destruct H as [A [H1 H2]].
    apply SepE in H1 as [H3 H4].
    apply PairE in H3. destruct H3.
    + subst. pose proof (H4 (SingI x)).
      apply pair_eq_sing_i in H as [_ H].
      subst. apply H2.
    + subst. apply H2.
  - eapply UnionI; [|apply H].
    apply SepI. apply PairI2.
    intros. apply SingE in H0. subst. reflexivity.
Qed.

Lemma op_correct : ∀ a b c d, <a, b> = <c, d> ↔ a = c ∧ b = d.
Proof.
  split; intros.
  - pose proof (π1_correct a b).
    rewrite H in H0. rewrite π1_correct in H0.
    pose proof (π2_correct a b).
    rewrite H in H1. rewrite π2_correct in H1. auto.
  - destruct H. subst. reflexivity.
Qed.

Definition is_pair : set -> Prop := λ p, ∃ x y, p = <x, y>.

Lemma op_η : ∀ p, is_pair p ↔ p = <π1 p, π2 p>.
Proof.
  split; intros.
  - destruct H as [a [b H]]. rewrite H.
    rewrite π1_correct. rewrite π2_correct. reflexivity.
  - exists (π1 p), (π2 p). apply H.
Qed.

Lemma GUOPair : ∀ N, ∀X ∈ 𝒰(N), ∀Y ∈ 𝒰(N), <X, Y> ∈ 𝒰(N).
Proof.
  introq. apply GUPair.
  - apply GUSing. apply H.
  - apply GUPair; assumption.
Qed.

Close Scope TG1_scope.
