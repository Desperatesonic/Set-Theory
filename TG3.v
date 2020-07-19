(*** Formal Construction of a Set Theory in Coq ***)
(** based on the thesis by Jonas Kaiser, November 23, 2012 **)
(** Coq coding by choukh, April 2020 **)

Require Export ZFC.TG2.
Require Import Setoid.

(*** TG集合论3：选择公理，正则公理，笛卡尔积 ***)

(** 希尔伯特ε算子等效于选择公理 **)

(* 选择函数 *)
Definition cho : set → set := λ s, ε (inhabits ∅) (λ x, x ∈ s).

(* “答案确实是在题目选项里选的” *)
Lemma chosen_contained : ∀ s, ⦿s → cho s ∈ s.
Proof. intros s. exact (ε_spec (inhabits ∅) (λ x, x ∈ s)). Qed.

(* “答案集包含在问题集的并集里” *)
Theorem chosen_included : ∀ S, (∀s ∈ S, ⦿s) → {cho | s ∊ S} ⊆ ⋃S.
Proof.
  unfold Sub. unfoldq. intros.
  apply ReplE in H0. unfoldq.
  destruct H0 as [s [H1 H2]].
  specialize H with s.
  eapply UnionI. apply H1.
  apply H in H1. subst.
  apply chosen_contained. apply H1.
Qed.

(* “单选题” *)
Theorem one_chosen : ∀ S, (∀s ∈ S, ⦿s) →
  (∀ s t ∈ S, s ≠ t → s ∩ t = ∅) →
  ∀s ∈ S, ∃ x, s ∩ {cho | s ∊ S} = ⎨x⎬.
Proof.
  unfoldq. intros S Hi Hdj s Hs.
  exists (cho s).
  apply sub_asym.
  - unfold Sub. introq. apply BInterE in H as [Hx1 Hx2].
    cut (x = cho s).
    + intros. subst. apply SingI.
    + apply ReplE in Hx2.
      destruct Hx2 as [t [Ht Hteq]].
      destruct (classic (s = t)).
      * subst. reflexivity.
      * pose proof (Hdj s Hs t Ht H).
        pose proof ((EmptyE H0) x).
        exfalso. apply H1. apply BInterI. apply Hx1.
        pose proof (chosen_contained t (Hi t Ht)).
        rewrite Hteq in H2. apply H2.
  - apply in_impl_sing_sub. apply BInterI.
    + apply chosen_contained. apply Hi. apply Hs.
    + apply ReplI. apply Hs.
Qed.

(** 更多经典逻辑引理 **)

Lemma double_negation : ∀ P : Prop, ¬¬P ↔ P.
Proof.
  split; intros.
  - destruct (classic P) as [HP | HF]; firstorder.
  - destruct (classic (¬P)) as [HF | HFF]; firstorder.
Qed.

Lemma classic_neg_all_1 : ∀ P : set → Prop, ¬ (∀ X, ¬ P X) ↔ (∃ X, P X).
Proof.
  split; intros.
  - destruct (classic (∃ X, P X)); firstorder.
  - firstorder.
Qed.

Lemma classic_neg_all_2 : ∀ P : set → Prop, ¬ (∀ X, P X) ↔ (∃ X, ¬ P X).
Proof.
  intros. pose proof (classic_neg_all_1 (λ x, ¬ P x)).
  simpl in H. rewrite <- H. clear H.
  split; intros.
  - intros H1. apply H. intros. specialize H1 with X.
    rewrite double_negation in H1. apply H1.
  - firstorder.
Qed.

(** ∈归纳原理等效于正则公理模式 **)
Theorem reg_schema : ∀ P,
  (∃ X, P X) → ∃ X, P X ∧ ¬∃x ∈ X, P x.
Proof.
  intros P. pose proof (ε_ind (λ x, ¬ P x)). simpl in H.
  remember (∀ X, (∀x ∈ X, ¬ P x) → ¬ P X) as A.
  remember (∀ X, ¬ P X) as B.
  assert (∀ P Q: Prop, (P → Q) → (¬ Q → ¬ P)) by auto.
  pose proof (H0 A B H). subst. clear H H0.
  rewrite classic_neg_all_1 in H1.
  rewrite classic_neg_all_2 in H1.
  intros. apply H1 in H. destruct H as [X H].
  exists X. clear H1.
  assert (∀ A B : Prop, ¬ (A → ¬ B) ↔ ¬¬B ∧ ¬¬A) by firstorder.
  rewrite H0 in H. clear H0.
  repeat rewrite double_negation in H. firstorder.
Qed.

(* 由正则公理模式导出原始正则公理：
  所有非空集合X中至少有一个成员x，它与X的交集为空集。*)
Theorem regularity : ∀ X, ⦿ X → ∃x ∈ X, x ∩ X = ∅.
Proof.
  introq.
  pose proof (reg_schema (λ x, x ∈ X)).
  simpl in H0. apply H0 in H.
  destruct H as [x [H1 H2]].
  exists x. split. apply H1.
  apply EmptyI. intros y H3.
  apply H2. apply BInterE in H3. unfoldq.
  exists y. apply H3.
Qed.

(* 不存在以自身为元素的集合 *)
Theorem not_self_contained : ¬ ∃ x, x ∈ x.
Proof.
  intros H.
  pose proof (reg_schema (λ x, x ∈ x)).
  simpl in H0. apply H0 in H.
  destruct H as [x [H1 H2]].
  apply H2. unfoldq. exists x; auto.
Qed.

(* 没有循环单链 *)
Lemma well_founded_1 : ∀ X, X ∉ X.
Proof.
  intros X. pose proof (ε_ind (λ X, X ∉ X)). simpl in H.
  apply H. introq. intros Ht. apply H0 in Ht as Hf. auto.
Qed.

(* 没有循环双链 *)
Lemma well_founded_2 : ∀ X Y, X ∈ Y → Y ∉ X.
Proof.
  intros X Y H. pose proof (ε_ind (λ X, ∀ Y, X ∈ Y → Y ∉ X)).
  apply H0; [|apply H]. clear X Y H H0. unfoldq.
  intros X H Y H1 H2.
  pose proof (H Y H2 X H2). auto.
Qed.

(** 笛卡儿积 **)
Definition CProd : set → set → set := λ A B,
  ⋃ {λ a, {λ b, <a, b> | x∊B} | x∊A}.
Notation "A × B" := (CProd A B) (at level 40).

Lemma CProdI : ∀ A B, ∀a ∈ A, ∀b ∈ B, <a, b> ∈ A × B.
Proof.
  introq. eapply UnionI.
  - apply ReplI. apply H.
  - apply ReplI. apply H0.
Qed.

Lemma CProdE1 : ∀ p A B, p ∈ A × B → π1 p ∈ A ∧ π2 p ∈ B.
Proof.
  intros. apply UnionAx in H. destruct H as [x [H1 H2]].
  apply ReplE in H1. destruct H1 as [a [H3 H4]].
  subst x. apply ReplE in H2. destruct H2 as [b [H1 H2]].
  symmetry in H2. split.
  - rewrite H2. rewrite π1_correct. apply H3.
  - rewrite H2. rewrite π2_correct. apply H1.
Qed.

Lemma CProdE2 : ∀ p A B, p ∈ A × B → is_pair p.
Proof.
  intros. apply UnionAx in H. destruct H as [x [H1 H2]].
  apply ReplE in H1. destruct H1 as [a [H3 H4]].
  subst x. apply ReplE in H2. destruct H2 as [b [H1 H2]].
  exists a, b. auto.
Qed.

Lemma CProd_correct : ∀ p A B, p ∈ A × B ↔ ∃a ∈ A, ∃b ∈ B, p = <a, b>.
Proof.
  unfoldq. split; intros.
  - apply CProdE1 in H as H0. destruct H0 as [H1 H2].
    apply CProdE2 in H. destruct H as [a [b H]].
    rewrite H in *. rewrite π1_correct in H1.
    rewrite π2_correct in H2. firstorder.
  - destruct H as [a [H1 H2]]. destruct H2 as [b [H2 H3]].
    subst. apply CProdI. apply H1. apply H2.
Qed.

Example cprod_0_x : ∀ B, ∅ × B = ∅.
Proof. unfold CProd. intros. rewrite funion_0. reflexivity. Qed.

Example cprod_x_0 : ∀ A, A × ∅ = ∅.
Proof.
  intros. apply sub_0_iff_0. unfold CProd, Sub. introq.
  apply CProdE1 in H. destruct H as [_ H]. exfalso0.
Qed.

Lemma GUCProd : ∀ N, ∀X ∈ 𝒰(N), ∀Y ∈ 𝒰(N), X × Y ∈ 𝒰(N).
Proof.
  introq. apply GUFUnion. apply H.
  introq. apply GURepl. apply H0.
  introq. apply GUOPair.
  - eapply GUTrans. apply H1. apply H.
  - eapply GUTrans. apply H2. apply H0.
Qed.

(* 对x迭代n次f：特别地，有 iter n S O = n *)
Fixpoint iter (n : nat) {X : Type} (f : X → X) (x : X) :=
  match n with
  | O => x
  | S n' => f (iter n' f x)
  end.
