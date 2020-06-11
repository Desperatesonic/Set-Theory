(** Solutions to "Elements of Set Theory" Chapter 3 Part 2 **)
(** Coq coding by choukh, May 2020 **)

Require Export ZFC.CH3_1.

Example ch3_32_a: ∀ R, symm R ↔ R⁻¹ ⊆ R.
Proof with congruence.
  split; intros.
  - intros x Hx. apply SepE in Hx as [_ [Hpp Hp]].
    apply H in Hp. apply op_η in Hpp...
  - intros x y Hp. apply inv_op in Hp. apply H...
Qed.

Example ch3_32_b: ∀ R, tranr R ↔ R ∘ R ⊆ R.
Proof with eauto.
  split; intros.
  - intros p Hp. apply SepE in Hp as [_ [Hpp [y [H1 H2]]]].
    apply op_η in Hpp. rewrite Hpp. eapply H...
  - intros x y z H1 H2. apply H. eapply compoI...
Qed.

Example ch3_33: ∀ R, is_relation R ∧ symm R ∧ tranr R ↔ R = R⁻¹ ∘ R.
Proof with eauto.
  split.
  - intros [Hr [Hsy Htr]]. apply ExtAx. intros p. split; intros Hp.
    + apply rel_pair in Hp as Heq... rewrite Heq in *.
      eapply compoI. split... rewrite <- inv_op...
    + apply SepE in Hp as [_ [Hpp [y [H1 H2]]]].
      apply op_η in Hpp. rewrite Hpp. apply inv_op in H2...
  - intros H.
    assert (Hr: is_relation R). {
      intros p Hp. rewrite ExtAx in H. apply H in Hp.
      apply SepE in Hp as [_ []]...
    }
    assert (Hsy: symm R). {
      intros x y Hp. rewrite H in *.
      apply compoE in Hp as [t [H1 H2]].
      rewrite inv_op in H1. rewrite <- inv_op in H2.
      eapply compoI. split...
    }
    repeat split... intros x y z H1 H2.
    rewrite H. rewrite H in H1, H2.
    apply compoE in H1 as [s [H11 H12]].
    apply compoE in H2 as [t [H21 H22]].
    apply Hsy in H21. rewrite inv_op in H21.
    rewrite <- inv_op in H12. apply Hsy in H12.
    assert (Hst: <s, t> ∈ R ⁻¹ ∘ R) by (eapply compoI; eauto).
    rewrite <- H in Hst. apply Hsy in Hst. rewrite inv_op in Hst.
    assert (Hxt: <x, t> ∈ R ⁻¹ ∘ R) by (eapply compoI; eauto).
    rewrite <- H in Hxt. eapply compoI. split...
Qed.

Example ch3_34: ∀ 𝒜, (∀A ∈ 𝒜, tranr A) → tranr (⋂𝒜).
Proof with eauto.
  intros 𝒜 H. intros x y z H1 H2.
  apply InterE in H1 as [Hi H1]. apply InterE in H2 as [_ H2]. 
  apply InterI... intros A HA.
  apply H1 in HA as Hp1. apply H2 in HA as Hp2.
  apply H in HA. eapply HA...
Qed.

Example ch3_35: ∀ R x, [x]R = R⟦⎨x⎬⟧.
Proof with eauto.
  intros. apply ExtAx. intros y. split; intros Hy.
  - apply eqvcE in Hy. eapply imgI... apply SingI.
  - apply imgE in Hy as [w [Hw Hp]].
    apply SingE in Hw. subst w. apply eqvcI...
Qed.

Example ch3_36: ∀ f A B R, f: A ⇒ B → equiv R B →
  let Q := {p ∊ A × A | λ p, <f[π1 p], f[π2 p]> ∈ R} in
  equiv Q A.
Proof with eauto.
  intros * [Hf [Hd Hr]] [_ [Hrf [Hsy Htr]]] Q. repeat split.
  - intros p Hp. apply SepE in Hp as []...
  - intros x Hx. apply SepI. apply CProdI...
    rewrite π1_correct, π2_correct. apply Hrf. apply Hr.
    eapply ranI... apply func_correct... rewrite Hd...
  - intros x y Hp. apply SepE in Hp as [Hcp Hp].
    apply CProdE1 in Hcp as [Hx Hy].
    rewrite π1_correct, π2_correct in *.
    apply SepI. apply CProdI...
    rewrite π1_correct, π2_correct...
  - intros x y z H1 H2.
    apply SepE in H1 as [Hxy H1]. apply CProdE1 in Hxy as [Hx _].
    apply SepE in H2 as [Hyz H2]. apply CProdE1 in Hyz as [_ Hz].
    rewrite π1_correct, π2_correct in *.
    apply SepI. apply CProdI...
    rewrite π1_correct, π2_correct...
Qed.

Example ch3_37: ∀ Π A, partition Π A →
  let R := Relation A A (λ x y, ∃B ∈ Π, x ∈ B ∧ y ∈ B) in
  equiv R A.
Proof with eauto.
  intros * [Hsub [Hdj Hxh]] R. repeat split.
  - intros p Hp. apply SepE in Hp as []...
  - intros x Hx. apply SepI. apply CProdI...
    apply Hxh in Hx as [B [HB Hx]].
    exists B. split... rewrite π1_correct, π2_correct...
  - intros x y Hp. apply SepE in Hp as [Hcp [B [HB [H1 H2]]]].
    apply CProdE1 in Hcp as [Hx Hy].
    rewrite π1_correct, π2_correct in *.
    apply SepI. apply CProdI...
    exists B. split... rewrite π1_correct, π2_correct...
  - intros x y z H1 H2.
    apply SepE in H1 as [Hbp [B [HB [Hbx Hby]]]].
    apply SepE in H2 as [Hcp [C [HC [Hcy Hcz]]]].
    rewrite π1_correct, π2_correct in *.
    destruct (classic (B = C)).
    + subst C. apply SepI.
      apply CProdE1 in Hbp as [Hax _].
      apply CProdE1 in Hcp as [_ Hay].
      rewrite π1_correct, π2_correct in *. apply CProdI...
      exists B. split... rewrite π1_correct, π2_correct...
    + exfalso. eapply (disjointE B C)... apply Hdj...
Qed.

Example ch3_38: ∀ Π A, partition Π A →
  let R := Relation A A (λ x y, ∃B ∈ Π, x ∈ B ∧ y ∈ B) in
  A/R = Π.
Proof with eauto; try congruence.
  intros. destruct H as [Hsub [Hdj Hxh]].
  apply ExtAx. intros X. split; intros HX.
  - apply quotE in HX as [a [Ha Heq]]. subst X.
    assert (Hab := Ha). apply Hxh in Hab as [B [HB Hab]].
    cut (B = [a]R)... apply ExtAx. split; intros Hx.
    + apply eqvcI. apply SepI.
      * apply CProdI... eapply Hsub...
      * exists B. split...
        rewrite π1_correct, π2_correct in *. split...
    + apply eqvcE in Hx. apply SepE in Hx as [_ [C [HC [Hac Hx]]]].
      rewrite π1_correct, π2_correct in *.
      destruct (classic (B = C))... exfalso.
      eapply (disjointE B C)... apply Hdj...
  - assert (HXs := HX). apply Hsub in HXs as [[a Ha] HXs].
    apply HXs in Ha as Ha'. apply ReplAx. exists a. split...
    apply ExtAx. split; intros Hx.
    + apply eqvcE in Hx. apply SepE in Hx as [_ [B [HB [H1 H2]]]].
      rewrite π1_correct, π2_correct in *.
      destruct (classic (X = B))... exfalso.
      eapply (disjointE X B)... apply Hdj...
    + apply eqvcI. apply HXs in Hx as Hx'.
      apply SepI. apply CProdI... exists X. split...
      rewrite π1_correct, π2_correct...
Qed.

Example ch3_39: ∀ R A, equiv R A →
  let Π := A/R in
  let Rπ := Relation A A (λ x y, ∃B ∈ Π, x ∈ B ∧ y ∈ B) in
  Rπ = R.
Proof with eauto.
  intros * [Hr [Hrf [Hsy Hhx]]] Π Rπ.
  assert (Hrr: is_relation R) by (eapply relI; eauto).
  apply ExtAx. split; intros Hx.
  - apply SepE in Hx as [Hp [B [HB [H1 H2]]]].
    apply CProdE2 in Hp. apply op_η in Hp. rewrite Hp.
    apply quotE in HB as [a [Ha Heq]]. subst.
    apply eqvcE in H1. apply eqvcE in H2. eapply Hhx...
  - apply rel_pair in Hx as Heq... rewrite Heq in *.
    apply domI in Hx as Hdx. eapply rel_dom in Hdx...
    apply ranI in Hx as Hrx. eapply rel_ran in Hrx...
    apply SepI. apply CProdI...
    exists ([π1 x]R). split. apply quotI...
    rewrite π1_correct, π2_correct. split.
    apply eqvcI... apply eqvcI...
Qed.

(* TODO: ch3_41 wait for real number *)

Example ch3_42_e0: ∀ R A F, equiv R A → F: A × A ⇒ A →
  (∀ x y u v ∈ A, <x, u> ∈ R → <y, v> ∈ R →
    <F[<x, y>], F[<u, v>]> ∈ R) →
  ∃F', F': (A/R) × (A/R) ⇒ A/R ∧ ∀ x y ∈ A,
    F'[<[x]R, [y]R>] = [F[<x, y>]]R.
Proof with eauto.
  intros * Hqv [Hf [Hdf Hrf]] Hc.
  set ({λ p, <<[π1 p]R, [π2 p]R>, [F[<π1 p, π2 p>]]R> | p ∊ A × A}) as F'.
  assert (Hf': is_function F'). {
    repeat split.
    (* is_relation *)
    - intros p Hp. apply ReplE in Hp as [x []]. subst p. eexists...
    - apply domE in H...
    (* single value *)
    - intros y1 y2 Hy1 Hy2. apply domE in H as [y0 Hy0].
      apply ReplE in Hy0 as [a0 [_ Heq0]].
      apply ReplE in Hy1 as [a1 [Ha1 Heq1]].
      apply ReplE in Hy2 as [a2 [Ha2 Heq2]].
      apply op_correct in Heq0 as [Heq0 _].
      apply op_correct in Heq1 as [Heq1 Hy1].
      apply op_correct in Heq2 as [Heq2 Hy2].
      subst x y1 y2. rewrite <- Heq2 in Heq1. clear Heq2.
      apply op_correct in Heq1 as [H1 H2].
      apply CProdE1 in Ha1 as [Ha11 Ha12].
      apply CProdE1 in Ha2 as [Ha21 Ha22].
      eapply eqvc_ident in H1...
      eapply eqvc_ident in H2...
      assert (<F[<π1 a1, π2 a1>], F[<π1 a2, π2 a2>]> ∈ R)
        by (apply Hc; eauto).
      assert (Hd1: <π1 a1, π2 a1> ∈ A × A) by (apply CProdI; eauto).
      assert (Hd2: <π1 a2, π2 a2> ∈ A × A) by (apply CProdI; eauto).
      rewrite <- Hdf in Hd1, Hd2.
      apply func_correct in Hd1... apply func_correct in Hd2...
      eapply eqvc_ident; eauto + apply Hrf; eapply ranI...
  }
  assert (Hdf': dom F' = (A/R) × (A/R)). {
    apply ExtAx. split; intros Hx.
    - apply domE in Hx as [y Hp]. apply ReplE in Hp as [a [Hp Heq]].
      apply op_correct in Heq as [Heq _]. subst x.
      apply CProdE1 in Hp as [H1 H2]. apply CProdI; apply quotI...
    - apply CProdE2 in Hx as Hxp. apply op_η in Hxp.
      apply CProdE1 in Hx as [H1 H2].
      apply quotE in H1 as [a [Ha Heqa]].
      apply quotE in H2 as [b [Hb Heqb]].
      eapply domI. apply ReplAx. exists <a, b>. split.
      apply CProdI... rewrite π1_correct, π2_correct.
      apply op_correct... split. rewrite Hxp.
      apply op_correct... reflexivity.
  }
  assert (Hrf': ran F' ⊆ A/R). {
    intros y Hy. apply ranE in Hy as [].
    apply ReplE in H as [a [Ha Heq]].
    apply CProdE2 in Ha as Hap. apply op_η in Hap.
    apply op_correct in Heq as [_ Hy]. subst y. rewrite <- Hap.
    rewrite <- Hdf in Ha. apply func_correct in Ha as Hp...
    apply ranI in Hp as Hr. apply Hrf in Hr. apply quotI...
  }
  exists F'. split. split... intros x Hx y Hy.
  (* F'[[x]R] = [F[x]]R *)
  assert (Hdx: [x]R ∈ A/R) by (apply quotI; auto).
  assert (Hdy: [y]R ∈ A/R) by (apply quotI; auto).
  assert (Hd: <[x]R, [y]R> ∈ (A/R) × (A/R)) by (apply CProdI; auto).
  rewrite <- Hdf' in Hd. apply func_correct in Hd...
  apply ReplE in Hd as [b [Hb Heq]].
  apply op_correct in Heq as [H1 H2].
  rewrite <- H2. eapply eqvc_ident...
  - apply Hrf. eapply ranI... apply func_correct...
    rewrite Hdf. apply CProdE1 in Hb as []. apply CProdI...
  - apply Hrf. eapply ranI... apply func_correct...
    rewrite Hdf. apply CProdI...
  - apply op_correct in H1 as [H11 H12].
    apply CProdE1 in Hb as [Hb1 Hb2].
    eapply eqvc_ident in H11...
    eapply eqvc_ident in H12... apply Hc...
Qed.

Example ch3_42_e: ∀ R A F, equiv R A → F: A × A ⇒ A →
  (∀ x y u v ∈ A, <x, u> ∈ R → <y, v> ∈ R →
    <F[<x, y>], F[<u, v>]> ∈ R) →
  ∃!F', F': (A/R) × (A/R) ⇒ A/R ∧ ∀ x y ∈ A,
    F'[<[x]R, [y]R>] = [F[<x, y>]]R.
Proof with eauto.
  intros * Hqv Hf Hc. split. apply ch3_42_e0...
  intros F1 F2 [[HF1 [Hd1 Hr1]] H1] [[HF2 [Hd2 Hr2]] H2].
  apply func_ext... rewrite Hd1, Hd2...
  intros x Hx. rewrite Hd1 in Hx.
  apply CProdE2 in Hx as Hxp. apply op_η in Hxp.
  apply CProdE1 in Hx as [Hx1 Hx2].
  apply quotE in Hx1 as [a [Ha Haeq]].
  apply quotE in Hx2 as [b [Hb Hbeq]].
  pose proof (H1 a Ha b Hb) as H3.
  pose proof (H2 a Ha b Hb) as H4. simpl in *. congruence.
Qed.

Example ch3_42_i: ∀ R A F, equiv R A → F: A × A ⇒ A →
  (∃F', F': (A/R) × (A/R) ⇒ A/R ∧ ∀ x y ∈ A,
    F'[<[x]R, [y]R>] = [F[<x, y>]]R) →
  ∀ x y u v ∈ A, <x, u> ∈ R → <y, v> ∈ R →
    <F[<x, y>], F[<u, v>]> ∈ R.
Proof with eauto.
  intros * Hqv [HF [Hd Hr]] [F' [[HF' [Hd' Hr']] H]].
  intros x Hx y Hy u Hu v Hv Hp1 Hp2.
  eapply eqvc_ident...
  - apply Hr. eapply ranI. apply func_correct...
    rewrite Hd. apply CProdI...
  - apply Hr. eapply ranI. apply func_correct...
    rewrite Hd. apply CProdI...
  - assert (F'[<[x]R, [y]R>] = [F[<x, y>]]R) by (apply H; auto).
    assert (F'[<[u]R, [v]R>] = [F[<u, v>]]R) by (apply H; auto).
    apply (eqvc_ident R A) in Hp1...
    apply (eqvc_ident R A) in Hp2... congruence.
Qed.

Example ch3_43: ∀ R A, totalOrd R A → totalOrd R⁻¹ A.
Proof with eauto.
  intros * [Hrl [Htr Htri]].
  assert (Hrl': rel R ⁻¹ A). {
    intros x Hx. apply SepE in Hx as [_ [Hpp Hp]].
    apply op_η in Hpp. rewrite Hpp.
    apply Hrl in Hp. apply CProdE1 in Hp as [].
    rewrite π1_correct, π2_correct in *. apply CProdI...
  }
  assert (Htr': tranr R⁻¹). {
    intros x y z H1 H2. rewrite <- inv_op in *...
  }
  repeat split... apply trich_iff...
  apply trich_iff in Htri as [Hir Hco]... split.
  - intros [x [Hx Hp]]. apply Hir.
    apply inv_op in Hp. exists x. split...
  - intros x Hx y Hy Hnq. apply Hco in Hnq as []...
    + right. apply inv_op in H...
    + left. apply inv_op in H...
Qed.

Example ch3_44: ∀ R A f, totalOrd R A → f: A ⇒ A →
  (∀ x y ∈ A, <x, y> ∈ R → <f[x], f[y]> ∈ R) →
  injective f ∧ ∀ x y ∈ A, <f[x], f[y]> ∈ R → <x, y> ∈ R.
Proof with eauto.
  intros * [Hrl [Htr Htri]] [Hf [Hd Hr]] H.
  apply trich_iff in Htri as [Hir Hco]... split. split...
  - intros y Hy. split. apply ranE in Hy...
    intros x1 x2 H1 H2.
    apply domI in H1 as Hd1. apply domI in H2 as Hd2.
    rewrite Hd in Hd1, Hd2. apply Hr in Hy.
    apply func_ap in H1... apply func_ap in H2... subst y.
    destruct (classic (x1 = x2))... exfalso.
    apply Hco in H0 as []...
    + apply H in H0... rewrite H2 in H0. apply Hir.
      exists (f[x1]). split...
    + apply H in H0... rewrite H2 in H0. apply Hir.
      exists (f[x1]). split...
  - intros x1 Hx1 x2 Hx2 Hpf. destruct (classic (x1 = x2)).
    + exfalso. apply Hir. exists (f[x2]). split.
      apply Hr. eapply ranI. apply func_correct... rewrite Hd...
      rewrite H0 in Hpf...
    + apply Hco in H0 as []...
      exfalso. apply Hir. exists (f[x1]). split.
      apply Hr. eapply ranI. apply func_correct... rewrite Hd...
      apply H in H0...
Qed.

(* 字典序 *)
Example ch3_45: ∀ Rᵃ A Rᵇ B, totalOrd Rᵃ A → totalOrd Rᵇ B →
  let Rˡ := {p ∊ (A × B) × (A × B) | λ p,
    let a1 := π1 (π1 p) in let b1 := π2 (π1 p) in
    let a2 := π1 (π2 p) in let b2 := π2 (π2 p) in
    <a1, a2> ∈ Rᵃ ∨ a1 = a2 ∧ <b1, b2> ∈ Rᵇ
  } in
  totalOrd Rˡ (A × B).
Proof with eauto; try congruence.
  intros * [Hrla [Htra Htria]] [Hrlb [Htrb Htrib]] Rˡ.
  assert (Hrl: rel Rˡ (A × B)). {
    intros p Hp. apply SepE in Hp as [Hp _]...
  }
  assert (Htr: tranr Rˡ). {
    intros x y z H1 H2.
    apply SepE in H1 as [Hp1 H1].
    apply SepE in H2 as [Hp2 H2].
    apply SepI. apply CProdI.
    apply CProdE1 in Hp1 as [Hx _]. rewrite π1_correct in Hx...
    apply CProdE1 in Hp2 as [_ Hz]. rewrite π2_correct in Hz...
    destruct H1; destruct H2; rewrite π1_correct, π2_correct in *...
    + left. destruct H0 as [Heq _]...
    + left. destruct H as [Heq _]...
    + right. destruct H. destruct H0. split...
  }
  repeat split... intros x Hx y Hy. eapply trich_iff...
  apply trich_iff in Htria as [Hira Hcoa]...
  apply trich_iff in Htrib as [Hirb Hcob]... split.
  - intros [p [Hp Hpp]]. apply CProdE1 in Hp as [Hp1 Hp2].
    apply SepE in Hpp as [_ []]; rewrite π1_correct, π2_correct in H.
    + apply Hira. exists (π1 p). split...
    + apply Hirb. exists (π2 p). split... destruct H as []...
  - intros p1 Hp1 p2 Hp2 Hnq.
    apply CProd_correct in Hp1 as [a1 [Ha1 [b1 [Hb1 Heq1]]]].
    apply CProd_correct in Hp2 as [a2 [Ha2 [b2 [Hb2 Heq2]]]].
    subst p1 p2.
    assert (a1 ≠ a2 ∨ a1 = a2 ∧ b1 ≠ b2). {
      destruct (classic (a1 = a2)). right. split... left...
    }
    destruct H as [H|[H1 H2]].
    + apply Hcoa in H... destruct H.
      * left. apply SepI. apply CProdI; apply CProdI; auto. 
        do 3 rewrite π1_correct, π2_correct. left...
      * right. apply SepI. apply CProdI; apply CProdI; auto.  
        do 3 rewrite π1_correct, π2_correct. left...
    + apply Hcob in H2... destruct H2.
      * left. apply SepI. apply CProdI; apply CProdI; auto. 
        do 3 rewrite π1_correct, π2_correct. right...
      * right. apply SepI. apply CProdI; apply CProdI; auto. 
        do 3 rewrite π1_correct, π2_correct. right...
Qed.

Example ch3_46_a: ∀ x y, ⋂⋂<x, y> = x.
Proof with eauto.
  intros. apply ExtAx. intros a. split; intros Ha.
  - apply InterE in Ha as [[b Hb] Ha]. apply Ha in Hb as Hab.
    apply InterE in Hb as [[c Hc] Hb]. apply Hb in Hc as Hbc.
    apply PairE in Hc as []; subst c.
    + apply SingE in Hbc. subst...
    + apply PairE in Hbc as []. subst... subst.
      assert (⎨x⎬ ∈ <x, y>) by apply PairI1.
      apply Hb in H. apply SingE in H. subst...
  - apply InterI.
    + exists x. apply InterI.
      * exists ⎨x⎬. apply PairI1.
      * intros b Hb. apply PairE in Hb as []; subst.
        apply SingI. apply PairI1.
    + intros b Hb. apply InterE in Hb as [[c Hc] Hb].
      apply Hb in Hc as Hbc.
      apply PairE in Hc as []; subst c.
      * apply SingE in Hbc. subst...
      * apply PairE in Hbc as []. subst... subst.
        assert (⎨x⎬ ∈ <x, y>) by apply PairI1.
        apply Hb in H. apply SingE in H. subst...
Qed.

Example ch3_46_b: ∀ x y, ⋂⋂⋂⎨<x, y>⎬⁻¹ = y.
Proof with eauto.
  intros. set (⎨<x, y>⎬) as R.
  cut (⋂R⁻¹ = <y, x>). intros. rewrite H. apply ch3_46_a.
  apply ExtAx. intros a. split; intros Ha.
  - apply InterE in Ha as [_ Ha].
    assert (<x, y> ∈ R) by apply SingI.
    apply inv_op in H. apply Ha in H...
  - apply InterI.
    + exists (<y, x>). rewrite <- inv_op. apply SingI.
    + intros b Hb. apply SepE in Hb as [_ [Hp Hb]].
      apply SingE in Hb. apply op_correct in Hb as []. subst.
      apply op_η in Hp. rewrite Hp...
Qed.

Example ch3_52: ∀ A B C D, ⦿ A → ⦿ B → ⦿ C → ⦿ D →
  A × B = C × D → A = C ∧ B = D.
Proof with eauto.
  intros * [a Ha] [b Hb] [c Hc] [d Hd] H.
  rewrite ExtAx in H. split.
  - apply ExtAx. split; intros.
    + assert (Hab: <x, b> ∈ A × B) by (apply CProdI; auto).
      apply H in Hab as Hcd. apply CProdE1 in Hcd as [].
      rewrite π1_correct in H1...
    + assert (Hab: <x, d> ∈ C × D) by (apply CProdI; auto).
      apply H in Hab as Hcd. apply CProdE1 in Hcd as [].
      rewrite π1_correct in H1...
  - apply ExtAx. split; intros.
    + assert (Hab: <a, x> ∈ A × B) by (apply CProdI; auto).
      apply H in Hab as Hcd. apply CProdE1 in Hcd as [].
      rewrite π2_correct in H2...
    + assert (Hab: <c, x> ∈ C × D) by (apply CProdI; auto).
      apply H in Hab as Hcd. apply CProdE1 in Hcd as [].
      rewrite π2_correct in H2...
Qed.

Example ch3_53_a: ∀ R S, (R ∪ S)⁻¹ = R⁻¹ ∪ S ⁻¹.
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply SepE in Hx as [_ [Hp Hx]]. apply op_η in Hp.
    rewrite Hp. apply BUnionE in Hx as [].
    + apply BUnionI1. rewrite <- inv_op...
    + apply BUnionI2. rewrite <- inv_op...
  - apply BUnionE in Hx as [].
    + apply SepE in H as [_ [Hp Hx]]. apply op_η in Hp.
      rewrite Hp. rewrite <- inv_op. apply BUnionI1...
    + apply SepE in H as [_ [Hp Hx]]. apply op_η in Hp.
      rewrite Hp. rewrite <- inv_op. apply BUnionI2...
Qed.

Example ch3_53_b: ∀ R S, (R ∩ S)⁻¹ = R⁻¹ ∩ S ⁻¹.
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply SepE in Hx as [_ [Hp Hx]]. apply op_η in Hp.
    rewrite Hp. apply BInterE in Hx as [H1 H2].
    apply BInterI; rewrite <- inv_op; auto.
  - apply BInterE in Hx as [H1 H2].
    apply SepE in H1 as [_ [Hp Hx]]. apply op_η in Hp.
    rewrite Hp. rewrite Hp in H2. rewrite <- inv_op in H2.
    rewrite <- inv_op. apply BInterI...
Qed.

Example ch3_53_c: ∀ R S, (R - S)⁻¹ = R⁻¹ - S ⁻¹.
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply SepE in Hx as [_ [Hp Hx]]. apply op_η in Hp.
    rewrite Hp. apply CompE in Hx as [H1 H2].
    apply CompI. rewrite <- inv_op...
    intros Hc. apply H2. rewrite inv_op...
  - apply CompE in Hx as [H1 H2].
    apply SepE in H1 as [_ [Hp Hx]]. apply op_η in Hp.
    rewrite Hp. rewrite Hp in H2. rewrite <- inv_op in H2.
    rewrite <- inv_op. apply CompI...
Qed.

Example ch3_54_a: ∀ A B C, A × (B ∩ C) = (A × B) ∩ (A × C).
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply CProd_correct in Hx as [a [Ha [b [Hb Heq]]]]. subst.
    apply BInterE in Hb as [Hb1 Hb2].
    apply BInterI; apply CProdI; auto.
  - apply BInterE in Hx as [H1 H2].
    apply CProd_correct in H1 as [a [Ha [b [Hb Heq]]]]. subst.
    apply CProdE1 in H2 as [_ Hc]. rewrite π2_correct in Hc.
    apply CProdI... apply BInterI...
Qed.

Example ch3_54_b: ∀ A B C, A × (B ∪ C) = (A × B) ∪ (A × C).
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply CProd_correct in Hx as [a [Ha [b [Hb Heq]]]]. subst.
    apply BUnionE in Hb as [].
    + apply BUnionI1. apply CProdI...
    + apply BUnionI2. apply CProdI...
  - apply BUnionE in Hx as [].
    + apply CProd_correct in H as [a [Ha [b [Hb Heq]]]]. subst.
      apply CProdI... apply BUnionI1...
    + apply CProd_correct in H as [a [Ha [b [Hb Heq]]]]. subst.
      apply CProdI... apply BUnionI2...
Qed.

Example ch3_54_c: ∀ A B C, A × (B - C) = (A × B) - (A × C).
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply CProd_correct in Hx as [a [Ha [b [Hb Heq]]]]. subst.
    apply CompE in Hb as [Hb Hc].
    apply CompI. apply CProdI... intros H. apply Hc.
    apply CProdE1 in H as [_ H]. rewrite π2_correct in H...
  - apply CompE in Hx as [H1 H2].
    apply CProd_correct in H1 as [a [Ha [b [Hb Heq]]]]. subst.
    apply CProdI... apply CompI... intros H. apply H2. apply CProdI...
Qed.

Example ch3_55: ∀ A B C, (A × A) ∩ (B × C) = (A ∩ B) × (A ∩ C).
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply BInterE in Hx as [H1 H2].
    apply CProd_correct in H1 as [a [Ha [b [Hb Heq]]]]. subst.
    apply CProdE1 in H2 as [Hab Hbc].
    rewrite π1_correct, π2_correct in *...
    apply CProdI; apply BInterI...
  - apply CProd_correct in Hx as [a [Ha [b [Hb Heq]]]]. subst.
    apply BInterE in Ha as [Haa Hab].
    apply BInterE in Hb as [Hba Hbc].
    apply BInterI; apply CProdI...
Qed.

Example ch3_56: ∀ R S, dom (R ∪ S) = dom R ∪ dom S.
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply domE in Hx as [y Hp]. apply BUnionE in Hp as [].
    + apply BUnionI1. eapply domI...
    + apply BUnionI2. eapply domI...
  - apply BUnionE in Hx as []; apply domE in H as [y Hp].
    + eapply domI. apply BUnionI1...
    + eapply domI. apply BUnionI2...
Qed.

Example ch3_57: ∀ R S T, R ∘ (S ∪ T) = (R ∘ S) ∪ (R ∘ T).
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply compo_rel in Hx as Hp. apply op_η in Hp.
    rewrite Hp in *. apply compoE in Hx as [t [H1 H2]].
    apply BUnionE in H1 as [].
    + apply BUnionI1. eapply compoI...
    + apply BUnionI2. eapply compoI...
  - apply BUnionE in Hx as []; apply compo_rel in H as Hp;
      apply op_η in Hp; rewrite Hp in *;
      apply compoE in H as [t [H1 H2]].
    + eapply compoI. split... apply BUnionI1...
    + eapply compoI. split... apply BUnionI2...
Qed.

Example ch3_59_a: ∀ Q A B, Q ↾ (A ∩ B) = (Q ↾ A) ∩ (Q ↾ B).
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply restrE in Hx as [a [b [Ha [Hp Heq]]]]. subst x.
    apply BInterE in Ha as [Ha1 Ha2].
    apply BInterI; apply restrI...
  - apply BInterE in Hx as [H1 H2].
    apply restrE in H1 as [a [b [Ha [Hp1 Heq1]]]].
    apply restrE in H2 as [c [d [Hc [Hp2 Heq2]]]]. subst x.
    apply op_correct in Heq2 as []; subst.
    apply restrI... apply BInterI...
Qed.

Example ch3_59_b: ∀ Q A B, Q ↾ (A - B) = (Q ↾ A) - (Q ↾ B).
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply restrE in Hx as [a [b [Ha [Hp Heq]]]]. subst.
    apply CompE in Ha as [Ha1 Ha2].
    apply CompI. apply restrI... intros H. apply Ha2.
    apply restrE in H as [c [d [Hc [Hp' Heq]]]].
    apply op_correct in Heq as []; subst...
  - apply CompE in Hx as [H1 H2].
    apply restrE in H1 as [a [b [Ha [Hp Heq]]]]. subst.
    apply restrI... apply CompI... intros H. apply H2.
    apply restrI...
Qed.

Example ch3_60: ∀ R S A, (R ∘ S) ↾ A = R ∘ (S ↾ A).
Proof with eauto.
  intros. apply ExtAx. split; intros Hx.
  - apply restrE in Hx as [a [b [Ha [Hp Heq]]]]. subst.
    apply compoE in Hp as [t [H1 H2]].
    eapply compoI. split... apply restrI...
  - apply compo_rel in Hx as Hxeq. apply op_η in Hxeq.
    rewrite Hxeq in *. apply compoE in Hx as [t [H1 H2]].
    apply restrE in H1 as [a [b [Ha [Hp Heq]]]].
    apply op_correct in Heq as []; subst...
    apply restrI... eapply compoI...
Qed.
