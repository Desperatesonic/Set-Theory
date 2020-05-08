(** Solutions to "Elements of Set Theory" Chapter 1 & 2 **)
(** Coq coding by choukh, May 2020 **)

Require Import ZFC.TG_full.

Example ex1_3: ∀ B C, B ⊆ C → 𝒫 B ⊆ 𝒫 C.
Proof.
  intros B C H x HB. apply PowerAx in HB.
  pose proof (sub_tran HB H) as HC.
  apply PowerAx. apply HC.
Qed.

Example ex1_4: ∀ B, ∀ x y ∈ B, {⎨x⎬, {x, y}} ∈ 𝒫 𝒫 B.
Proof.
  intros B b Hb a Ha. apply PowerAx. intros p Hp.
  apply PowerAx. intros x Hx.
  apply PairE in Hp. destruct Hp; subst p.
  - apply SingE in Hx. subst x. apply Hb.
  - apply PairE in Hx. destruct Hx; subst x.
    + apply Hb.
    + apply Ha.
Qed.

Example ex2_3: ∀A, ∀a ∈ A, a ⊆ ⋃A.
Proof.
  intros A a Ha x Hx.
  apply UnionAx. unfoldq.
  exists a. auto.
Qed.

Example ex2_4: ∀ A B, A ⊆ B → ⋃A ⊆ ⋃B.
Proof.
  intros A B H x Hx.
  apply UnionAx in Hx. destruct Hx as [b [Hb Hx]].
  eapply UnionI.
  - apply H in Hb. apply Hb.
  - apply Hx.
Qed.

Example ex2_5: ∀ A B, (∀a ∈ A, a ⊆ B) → ⋃A ⊆ B.
Proof.
  intros A B H x Hx.
  apply UnionAx in Hx. destruct Hx as [b [Hb Hx]].
  exact (H b Hb x Hx).
Qed.

Example ex_2_6_a: ∀ A, ⋃𝒫(A) = A.
Proof.
  intros. apply ExtAx. split; intros.
  - apply UnionAx in H. destruct H as [y [H1 H2]].
    apply PowerAx in H1. unfold Sub in H1.
    apply H1 in H2. apply H2.
  - eapply UnionI; [|apply H].
    apply PowerAx. apply sub_refl.
Qed.

Example ex_2_6_b: ∀ A, A ⊆ 𝒫(⋃A).
Proof.
  intros A x H. apply PowerAx.
  apply ex2_3. apply H.
Qed.

Example ex_2_7_a: ∀ A B, 𝒫(A) ∩ 𝒫(B) = 𝒫(A ∩ B).
Proof.
  intros. apply ExtAx. split; intros.
  - apply PowerAx. unfold Sub. unfoldq. intros y Hy.
    apply BInterE in H. destruct H as [H1 H2].
    apply PowerAx in H1. apply H1 in Hy as HA.
    apply PowerAx in H2. apply H2 in Hy as HB.
    apply BInterI. apply HA. apply HB.
  - apply PowerAx in H. unfold Sub in H. unfoldq.
    apply BInterI.
    + apply PowerAx. unfold Sub. unfoldq. intros y Hy.
      apply H in Hy. apply BInterE in Hy. tauto.
    + apply PowerAx. unfold Sub. unfoldq. intros y Hy.
      apply H in Hy. apply BInterE in Hy. tauto.
Qed.

Example ex_2_7_b: ∀A B, 𝒫(A) ∪ 𝒫(B) ⊆ 𝒫(A ∪ B).
Proof.
  intros A B x H. apply BUnionE in H. destruct H.
  - apply PowerAx in H. apply PowerAx. unfold Sub. introq.
    apply BUnionI1. apply H in H0. apply H0.
  - apply PowerAx in H. apply PowerAx. unfold Sub. introq.
    apply BUnionI2. apply H in H0. apply H0.
Qed.

Example ex_2_8: ¬∃A, ∀a, ⎨a⎬ ∈ A.
  intros H. destruct H as [A H].
  apply (well_founded_2 A ⎨A⎬).
  - apply SingI.
  - apply H.
Qed.

Example ex_2_10: ∀ A, ∀a ∈ A, 𝒫 a ∈ 𝒫 𝒫 ⋃A.
Proof.
  intros A x H. pose proof (ex_2_6_b A).
  apply H0 in H. apply PowerAx in H.
  apply ex1_3 in H.
  apply PowerAx. apply H.
Qed.

Example ex_2_11_1: ∀ A B, A = (A ∩ B) ∪ (A - B).
Proof.  
  intros. apply ExtAx. split; intros.
  - destruct (classic (x ∈ B)).
    + apply BUnionI1. apply BInterI; assumption.
    + apply BUnionI2. apply CompI; assumption.
  - apply BUnionE in H as [].
    + apply BInterE in H as [H _]. apply H.
    + apply CompE in H as [H _]. apply H.
Qed.

Example ex_2_11_2: ∀ A B, A ∪ (B - A) = A ∪ B.
Proof.
  intros. apply ExtAx. split; intros.
  - apply BUnionE in H as [].
    + apply BUnionI1. apply H.
    + apply CompE in H as [H _]. apply BUnionI2. apply H.
  - apply BUnionE in H as [].
    + apply BUnionI1. apply H.
    + destruct (classic (x ∈ A)).
      * apply BUnionI1. apply H0.
      * apply BUnionI2. apply CompI; assumption.
Qed.

Example ex_2_13: ∀ A B C, A ⊆ B → C - B ⊆ C - A.
Proof.
  intros. intros x Hcb. apply CompE in Hcb as [Hc Hb].
  apply CompI. apply Hc. intros Ha.
  apply Hb. apply H. apply Ha.
Qed.

Definition SymDiff : set → set → set := λ A B, (A - B) ∪ (B - A).
Notation "A + B" := (SymDiff A B).

Example ex_2_15_a_0: ∀ A B C, A ∩ (B + C) = (A ∩ B) + (A ∩ C).
Proof.
  intros. apply ExtAx. split; intros.
  - apply BInterE in H as [H1 H2]. apply BUnionE in H2 as [].
    + apply CompE in H as [H2 H3]. apply BUnionI1. apply CompI.
      * apply BInterI; assumption.
      * intros H4. apply BInterE in H4 as [_ H4]. auto.
    + apply CompE in H as [H2 H3]. apply BUnionI2. apply CompI.
      * apply BInterI; assumption.
      * intros H4. apply BInterE in H4 as [_ H4]. auto.
  - apply BUnionE in H as [].
    + apply CompE in H as [H1 H2]. apply BInterE in H1 as [H0 H1].
      apply BInterI. apply H0.
      apply BUnionI1. apply CompI. apply H1.
      intros H3. apply H2. apply BInterI; assumption.
    + apply CompE in H as [H1 H2]. apply BInterE in H1 as [H0 H1].
      apply BInterI. apply H0.
      apply BUnionI2. apply CompI. apply H1.
      intros H3. apply H2. apply BInterI; assumption.
Qed.

Example ex_2_15_a_1: ∀ A B C, A ∩ (B + C) = (A ∩ B) + (A ∩ C).
Proof.
  intros. unfold SymDiff.
  rewrite binter_bunion_distr.
  do 2 rewrite binter_comp_distr. reflexivity.
Qed.

Example ex_2_15_b: ∀ A B C, A + (B + C) = (A + B) + C.
Proof.
  intros. apply ExtAx. split; intros.
  - apply BUnionE in H as [].
    + apply CompE in H as [H1 H2]. destruct (classic (x ∈ C)).
      * apply BUnionI2. apply CompI. apply H.
        intros H3. apply H2. apply BUnionE in H3 as [].
        -- apply CompE in H0 as [H3 H4].
           apply BUnionI2. apply CompI; assumption.
        -- apply CompE in H0 as [H3 H4]. exfalso. auto.
      * apply BUnionI1. apply CompI.
        apply BUnionI1. apply CompI. apply H1.
        intros H3. apply H2.
        apply BUnionI1. apply CompI; assumption. apply H.
    + apply CompE in H as [H1 H2]. apply BUnionE in H1 as [].
      * apply CompE in H as [H0 H1].
        apply BUnionI1. apply CompI.
        apply BUnionI2. apply CompI; assumption. apply H1.
      * apply CompE in H as [H0 H1].
        apply BUnionI2. apply CompI. apply H0.
        intros H3. apply BUnionE in H3 as [].
        -- apply CompE in H as [H3 H4]. auto.
        -- apply CompE in H as [H3 H4]. auto.
  - apply BUnionE in H as [].
    + apply CompE in H as [H1 H2]. apply BUnionE in H1 as [].
      * apply CompE in H as [H0 H1].
        apply BUnionI1. apply CompI. apply H0.
        intros H3. apply BUnionE in H3 as [].
        -- apply CompE in H as [H3 _]. auto.
        -- apply CompE in H as [H3 _]. auto.
      * apply CompE in H as [H0 H1].
        apply BUnionI2. apply CompI.
        apply BUnionI1. apply CompI; assumption. apply H1.
    + apply CompE in H as [H1 H2]. destruct (classic (x ∈ A)).
      * apply BUnionI1. apply CompI. apply H.
        intros H3. apply BUnionE in H3 as [].
        -- apply CompE in H0 as [_ H3]. auto.
        -- apply CompE in H0 as [_ H3].
           apply H2. apply BUnionI1. apply CompI; assumption.
      * apply BUnionI2. apply CompI.
        apply BUnionI2. apply CompI. apply H1.
        intros H3. apply H2. apply BUnionI2.
        apply CompI; assumption. apply H.
Qed.

Example ex_2_16: ∀ A B C, ((A∪B∪C)∩(A∪B)) - ((A∪(B-C))∩A) = B - A.
Proof.
  intros.
  rewrite (binter_comm (A∪B∪C) (A∪B)).
  rewrite (binter_parent (A∪B) (A∪B∪C)).
  rewrite (binter_comm (A∪(B-C)) (A)).
  rewrite (binter_parent (A) (A∪(B-C))).
  - apply ExtAx. split; intros.
    + apply CompE in H as [H1 H2]. apply BUnionE in H1 as [].
      * exfalso. auto.
      * apply CompI; assumption.
    + apply CompE in H as [H1 H2]. apply CompI.
    apply BUnionI2. apply H1. apply H2.
  - intros x H. apply BUnionI1. apply H.
  - intros x H. apply BUnionI1. apply H.
Qed.

Example ex_2_17_1_2: ∀ A B, A ⊆ B ↔ A - B = ∅.
Proof.
  split; intros.
  - apply EmptyI. intros x Hx. apply CompE in Hx as [H1 H2].
    apply H2. apply H. apply H1.
  - intros x Hx. apply EmptyE with (A - B) x in H.
    destruct (classic (x ∈ B)). apply H0.
    exfalso. apply H. apply CompI; assumption.
Qed.

Example ex_2_17_1_3: ∀ A B, A ⊆ B ↔ A ∪ B = B.
Proof.
  split; intros.
  - apply bunion_parent. apply H.
  - rewrite <- H. intros x Hx. apply BUnionI1. apply Hx.
Qed.

Example ex_2_17_1_4: ∀ A B, A ⊆ B ↔ A ∩ B = A.
Proof.
  split; intros.
  - apply binter_parent. apply H.
  - rewrite <- H. intros x Hx.
    apply BInterE in Hx as [_ Hx]. apply Hx.
Qed.

Example ex_2_19: ∀ A B, 𝒫(A - B) ≠ 𝒫 A - 𝒫 B.
Proof.
  intros. intros H.
  assert (∅ ∈ 𝒫 (A - B)) by apply empty_in_all_power.
  assert (∅ ∈ 𝒫 B) by apply empty_in_all_power.
  rewrite H in H0. apply CompE in H0 as [_ H0]. auto.
Qed.

Example ex_2_20: ∀ A B C, A ∪ B = A ∪ C → A ∩ B = A ∩ C → B = C.
Proof.
  intros. apply ExtAx. split; intros.
  - destruct (classic (x ∈ A)).
    * assert (x ∈ A ∩ B) by (apply BInterI; assumption).
      rewrite H0 in H3. apply BInterE in H3 as [_ H3]. apply H3.
    * assert (x ∈ A ∪ B) by (apply BUnionI2; assumption).
      rewrite H in H3. apply BUnionE in H3 as [].
      -- exfalso. auto.
      -- apply H3.
  - destruct (classic (x ∈ A)).
    * assert (x ∈ A ∩ C) by (apply BInterI; assumption).
      rewrite <- H0 in H3. apply BInterE in H3 as [_ H3]. apply H3.
    * assert (x ∈ A ∪ C) by (apply BUnionI2; assumption).
      rewrite <- H in H3. apply BUnionE in H3 as [].
      -- exfalso. auto.
      -- apply H3.
Qed.

Example ex_2_21: ∀ A B, ⋃(A ∪ B) = ⋃A ∪ ⋃B.
Proof.
  intros. apply ExtAx. split; intros.
  - apply UnionAx in H as [y [H1 H2]]. apply BUnionE in H1 as [].
    + apply BUnionI1. exact (UnionI H H2).
    + apply BUnionI2. exact (UnionI H H2).
  - apply BUnionE in H as [].
    + apply UnionAx in H as [y [H1 H2]]. apply UnionAx. unfoldq.
      exists y. split. apply BUnionI1. apply H1. apply H2.
    + apply UnionAx in H as [y [H1 H2]]. apply UnionAx. unfoldq.
      exists y. split. apply BUnionI2. apply H1. apply H2.
Qed.

Example ex_2_22: ∀ A B, ⦿ A → ⦿ B → ⋂(A ∪ B) = ⋂A ∩ ⋂B.
Proof.
  intros. apply ExtAx. split; intros.
  - apply InterE in H1 as [_ H1]. apply BInterI.
    + apply InterI. apply H. introq.
      apply H1. apply BUnionI1. apply H2.
    + apply InterI. apply H0. introq.
      apply H1. apply BUnionI2. apply H2.
  - apply BInterE in H1 as [H1 H2]. apply InterI.
    + destruct H as [a Ha]. exists a. apply BUnionI1. apply Ha.
    + introq. apply BUnionE in H3 as [].
      * apply InterE in H1 as [_ H1]. apply H1. apply H3.
      * apply InterE in H2 as [_ H2]. apply H2. apply H3.
Qed.

Example ex_2_23: ∀ A ℬ, ⦿ ℬ → A ∪ ⋂ℬ = ⋂{λ X, A ∪ X | X ∊ ℬ}.
Proof. exact bunion_inter_distr. Qed.

Example ex_2_24_a: ∀ 𝒜, ⦿ 𝒜 → 𝒫(⋂𝒜) = ⋂{λ X, 𝒫 X | X ∊ 𝒜}.
Proof.
  intros 𝒜 Hi. apply ExtAx. split; intros.
  - apply InterI.
    + destruct Hi as [y Hy]. exists (𝒫 y).
      apply ReplI. apply Hy.
    + unfoldq. intros y Hy. apply ReplE in Hy as [z [Hz Heq]].
      subst y. apply PowerAx. apply PowerAx in H.
      unfold Sub. unfoldq. intros y Hy. apply H in Hy.
      apply InterE in Hy as [_ Hy]. apply Hy. apply Hz.
  - apply PowerAx. unfold Sub. unfoldq. intros y Hy.
    apply InterI. apply Hi. unfoldq. intros z Hz. cut (x ⊆ z).
    + intros. apply H0. apply Hy.
    + apply PowerAx. apply InterE in H as [_ H].
      apply H. apply ReplI. apply Hz.
Qed.

Example ex_2_24_b: ∀ 𝒜, ⋃{λ X, 𝒫 X | X ∊ 𝒜} ⊆ 𝒫(⋃𝒜).
Proof with unfoldq.
  unfold Sub... intros. 
  apply FUnionE in H as [A [HA Hp]].
  apply PowerAx in Hp. apply PowerAx. unfold Sub...
  intros z Hz. apply UnionAx... exists A.
  split. apply HA. apply Hp. apply Hz.
Qed.

Example ex_2_25: ∀ A ℬ, ⦿ ℬ → A ∪ ⋃ℬ = ⋃{λ X, A ∪ X | X ∊ ℬ}.
Proof.
  intros A ℬ [B HB]. apply ExtAx. split; intros.
  - apply BUnionE in H as [].
    + eapply FUnionI. apply HB. apply BUnionI1. apply H.
    + apply UnionAx in H as [X [HX Hx]].
      eapply FUnionI. apply HX. apply BUnionI2. apply Hx.
  - apply FUnionE in H as [X [HX Hx]].
    apply BUnionE in Hx as [].
    + apply BUnionI1. apply H.
    + apply BUnionI2. apply UnionAx.
      exists X. split. apply HX. apply H.
Qed.

Example ex_2_32: ∀ a b, (a ∩ b) ∪ (b - a) = b.
Proof.
  intros. apply ExtAx. split; intros.
  - apply BUnionE in H as [].
    + apply BInterE in H as [_ H]. apply H.
    + apply CompE in H as [H _]. apply H.
  - destruct (classic (x ∈ a)).
    + apply BUnionI1. apply BInterI; assumption.
    + apply BUnionI2. apply CompI; assumption.
Qed.

Example ex_2_34: ∀ S, {∅, ⎨∅⎬} ∈ 𝒫 𝒫 𝒫 S.
Proof.
  intros. pose proof (empty_sub_all S). apply PowerAx in H.
  assert (⎨∅⎬ ⊆ 𝒫 S). {
    intros x Hx. apply SingE in Hx. subst x. apply H.
  }
  pose proof (empty_sub_all (𝒫 S)).
  apply PowerAx in H0. apply PowerAx in H1.
  assert ({∅, ⎨∅⎬} ⊆ 𝒫 𝒫 S). {
    intros x Hx. apply PairE in Hx as []; subst; assumption.
  }
  apply PowerAx in H2. apply H2.
Qed.

Example ex_2_35: ∀ A B, 𝒫 A = 𝒫 B → A = B.
Proof.
  intros. rewrite ExtAx in H. apply ExtAx. split; intros.
  - assert (⎨x⎬ ⊆ A). {
      intros y Hy. apply SingE in Hy. subst. assumption.
    }
    apply PowerAx in H1. apply H in H1.
    apply PowerAx in H1. apply H1. apply SingI.
  - assert (⎨x⎬ ⊆ B). {
      intros y Hy. apply SingE in Hy. subst. assumption.
    }
    apply PowerAx in H1. apply H in H1.
    apply PowerAx in H1. apply H1. apply SingI.
Qed.

Example ex_2_36_a: ∀ A B, A - (A ∩ B) = A - B.
Proof.
  intros. apply ExtAx. split; intros.
  - apply CompE in H as [H1 H2]. apply CompI. apply H1.
    intros H3. apply H2. apply BInterI; assumption.
  - apply CompE in H as [H1 H2]. apply CompI. apply H1.
    intros H3. apply BInterE in H3 as [_ H3]. auto.
Qed.

Example ex_2_36_b: ∀ A B, A - (A - B) = A ∩ B.
Proof.
  intros. apply ExtAx. split; intros.
  - apply CompE in H as [H1 H2]. apply CompNE in H2 as [].
    + exfalso. auto.
    + apply BInterI; assumption.
  - apply BInterE in H as [H1 H2]. apply CompI. apply H1.
    intros H3. apply CompE in H3 as [_ H3]. auto.
Qed.

Example ex_2_37_a: ∀ A B C, (A ∪ B) - C = (A - C) ∪ (B - C).
Proof.
  intros. apply ExtAx. split; intros.
  - apply CompE in H as [H1 H2]. apply BUnionE in H1 as [].
    + apply BUnionI1. apply CompI; assumption.
    + apply BUnionI2. apply CompI; assumption.
  - apply BUnionE in H as []; apply CompE in H as [H1 H2].
    + apply CompI. apply BUnionI1. apply H1. apply H2.
    + apply CompI. apply BUnionI2. apply H1. apply H2.
Qed.

Example ex_2_37_b: ∀ A B C, A - (B - C) = (A - B) ∪ (A ∩ C).
Proof.
  intros. apply ExtAx. split; intros.
  - apply CompE in H as [H1 H2]. apply CompNE in H2 as [].
    + apply BUnionI1. apply CompI; assumption.
    + apply BUnionI2. apply BInterI; assumption.
  - apply BUnionE in H as [].
    + apply CompE in H as [H1 H2]. apply CompI. apply H1.
      intros H3. apply CompE in H3 as [H3 _]. auto.
    + apply BInterE in H as [H1 H2]. apply CompI. apply H1.
      intros H3. apply CompE in H3 as [_ H3]. auto.
Qed.

Example ex_2_37_c: ∀ A B C, (A - B) - C = A - (B ∪ C).
Proof.
  intros. apply ExtAx. split; intros.
  - apply CompE in H as [H1 H2]. apply CompE in H1 as [H0 H1].
    apply CompI. apply H0. intros H3.
    apply BUnionE in H3 as []; auto.
  - apply CompE in H as [H1 H2]. apply CompI. apply CompI.
    * apply H1.
    * intros H3. apply H2. apply BUnionI1. apply H3.
    * intros H3. apply H2. apply BUnionI2. apply H3.
Qed.

Example ex_2_38_a: ∀ A B C, A ⊆ C ∧ B ⊆ C ↔ A ∪ B ⊆ C.
Proof.
  unfold Sub. unfoldq. split.
  - intros [H1 H2] x Hx. apply BUnionE in Hx as [].
    apply H1, H. apply H2, H.
  - split; intros; apply H.
    apply BUnionI1, H0. apply BUnionI2, H0.
Qed.

Example ex_2_38_b: ∀ A B C, C ⊆ A ∧ C ⊆ B ↔ C ⊆ A ∩ B.
Proof.
  unfold Sub. unfoldq. split; intros.
  - destruct H as [H1 H2]. apply BInterI.
    apply H1, H0. apply H2, H0.
  - split; intros; apply H in H0;
      apply BInterE in H0 as [H1 H2]; assumption.
Qed.
