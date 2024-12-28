import LeanCourse.Project.defs
import LeanCourse.Project.lemmata_for_O
import LeanCourse.Project.important_lines_and_points_in_O
import LeanCourse.Project.two_folding_lemmata
import Mathlib.Algebra.Field.Defs
open Classical
open Construction
open ComplexConjugate

lemma conj_in_𝕆 {z : ℂ} (hz : z ∈ 𝕆) : conj z ∈ 𝕆 := by
  -- Use E2 on the real axis
  have : conj z = E2 z reAxis := by
    simp [E2, reAxis, O1, line.vec]
    simp [Complex.ext_iff]
    ring
  rw [this]
  exact E2_in_𝕆 z reAxis hz reAxis_in_𝕆


/- **Field Operations** -/

section add

theorem 𝕆_neg {z : ℂ} (hz : z ∈ 𝕆) : -z ∈ 𝕆 := by
  -- W.l.o.g. z ≠ 0
  by_cases z_ne_zero : z = 0; simp [z_ne_zero]; exact zero_in_𝕆

  -- Idea: Mirror z across the perpendicular line sitting at 0.
  let l₁ := O1 z 0 z_ne_zero
  have hl₁ : l₁ ∈ 𝕆.lines := O1_in_𝕆 hz zero_in_𝕆

  let l₂ := O4 0 l₁
  have hl₂ : l₂ ∈ 𝕆.lines := O4_in_𝕆 zero_in_𝕆 hl₁
  have hl₂_z₁ : l₂.z₁ = 0 := by simp [l₂, O4]
  have hl₂_z₂ : l₂.z₂ = -Complex.I * z / Complex.abs z := by
    simp [l₂, O4, line.vec, l₁, O1]
    ring
  have hl₂_vec : l₂.vec = -Complex.I * z / Complex.abs z := by
    have : (Complex.abs z : ℂ) ≠ 0 := by norm_cast; exact (AbsoluteValue.ne_zero_iff Complex.abs).mpr z_ne_zero
    simp [line.vec, hl₂_z₁, hl₂_z₂, div_self this, neg_div]

  apply in_𝕆_if_eq (E2 z l₂)
  · exact E2_in_𝕆 z l₂ hz hl₂
  simp [E2, hl₂_z₁, hl₂_vec]
  ring_nf

lemma 𝕆_double {z : ℂ} (hz : z ∈ 𝕆) : 2 * z ∈ 𝕆 := by
  -- W.l.o.g. z ≠ 0
  by_cases z_ne_zero : z = 0; simp [z_ne_zero]; exact zero_in_𝕆

  -- Idea: Mirror the 0 across the perpendicular line sitting at z.
  let l₁ := O1 z 0 z_ne_zero
  have hl₁ : l₁ ∈ 𝕆.lines := O1_in_𝕆 hz zero_in_𝕆

  let l₂ := O4 z l₁
  have hl₂ : l₂ ∈ 𝕆.lines := O4_in_𝕆 hz hl₁
  have hl₂_z₁ : l₂.z₁ = z := by simp [l₂, O4]
  have hl₂_z₂ : l₂.z₂ = z - Complex.I * z / Complex.abs z := by
    simp [l₂, O4, line.vec, l₁, O1]
    ring
  have hl₂_vec : l₂.vec = -Complex.I * z / Complex.abs z := by
    have : (Complex.abs z : ℂ) ≠ 0 := by norm_cast; exact (AbsoluteValue.ne_zero_iff Complex.abs).mpr z_ne_zero
    simp [line.vec, hl₂_z₁, hl₂_z₂, div_self this, neg_div]

  apply in_𝕆_if_eq (E2 0 l₂)
  · exact E2_in_𝕆 0 l₂ zero_in_𝕆 hl₂
  simp [E2, hl₂_z₁, hl₂_vec, z_ne_zero]
  ring_nf

lemma 𝕆_add_multiples {z₁ z₂ : ℂ} (hz₁ : z₁ ∈ 𝕆) (hz₂ : z₂ ∈ 𝕆) (h_multiple : ∃ a : ℝ, z₁ = a * z₂) : z₁ + z₂ ∈ 𝕆 := by
  -- Here is the proof why we can assume w.l.o.g. that |z₁| < |z₂| holds.
  by_cases h_abs_ne : z₁ = z₂ ∨ z₁ = -z₂
  · -- The case that z₁ = ±z₂,
    -- therefore their sum equals 0 or 2 * z₁. Apply zero_in_𝕆 or 𝕆_double.
    obtain ⟨a,ha⟩ := h_multiple
    simp [ha] at h_abs_ne
    rcases h_abs_ne with a_one|a_neg_one
    · -- a = 1
      simp [ha, a_one, ← two_mul]
      exact 𝕆_double hz₂
    · -- a = -1
      simp [ha, a_neg_one, ← two_mul]
      exact zero_in_𝕆
  · -- The case that z₁ ≠ ±z.
    have hz₁_ne_z₂ : z₁ ≠ z₂ := by
      by_contra h
      simp [h] at h_abs_ne
    have hz₁_ne_neg_z₂ : z₁ ≠ -z₂ := by
      by_contra h
      simp [h] at h_abs_ne
    by_cases hz₁_ne_zero : z₁ = 0; simp [hz₁_ne_zero, hz₂]
    by_cases hz₂_ne_zero : z₂ = 0; simp [hz₂_ne_zero, hz₁]
    by_cases hz₁_ne_h₂ : z₁ = z₂; rw [← hz₁_ne_h₂,← two_mul]; apply 𝕆_double hz₁
    push_neg at hz₁_ne_zero hz₂_ne_zero
    obtain ⟨a,ha⟩ := h_multiple

    -- First mark the line l₁ passing through 0, z₁ and z₂.
    let l₁ := O1 z₁ 0 hz₁_ne_zero
    have hl₁ : l₁ ∈ 𝕆.lines := O1_in_𝕆 hz₁ zero_in_𝕆

    -- Next, we fold z₂ onto z₁ using O2.
    let l₂ := O2 z₁ z₂ hz₁_ne_z₂
    have hl₂ : l₂ ∈ 𝕆.lines := O2_in_𝕆 hz₁ hz₂

    -- Now, let's mirror 0 across l₂ and get z₁+z₂
    apply in_𝕆_if_eq (E2 0 l₂)
    · exact E2_in_𝕆 0 l₂ zero_in_𝕆 hl₂
    simp [E2, l₂, O2, line.vec, ha]
    ring_nf

/--𝕆 is closed under addition.-/
theorem 𝕆_add {z₁ z₂ : ℂ} (hz₁ : z₁ ∈ 𝕆) (hz₂ : z₂ ∈ 𝕆) : z₁ + z₂ ∈ 𝕆 := by
  -- Wlog we can assume that z₁ and z₂ are not equal to 0 or to a multiple (by a real number) of each other
  by_cases hz₁_ne_zero : z₁ = 0; simp [hz₁_ne_zero, hz₂]
  by_cases hz₂_ne_zero : z₂ = 0; simp [hz₂_ne_zero, hz₁]
  by_cases hz₁_ne_real_mult_z₂ : ∃ a : ℝ, z₁ = a * z₂
  · exact 𝕆_add_multiples hz₁ hz₂ hz₁_ne_real_mult_z₂
  push_neg at hz₁_ne_zero hz₂_ne_zero hz₁_ne_real_mult_z₂

  -- ToDo: Wollen wir noch den folgenden Fall per oBdA annehmen?
  --hz₁_ne_z₂_normalised : z₁/(Complex.abs z₁) ≠ z₂/(Complex.abs z₂)

  -- First step: create two lines from 0 to z₁ resp. z₂.
  let l₁ := O1 0 z₁ hz₁_ne_zero.symm
  let l₂ := O1 0 z₂ hz₂_ne_zero.symm
  have hl₁ : l₁ ∈ 𝕆.lines := O1_in_𝕆 zero_in_𝕆 hz₁
  have hl₂ : l₂ ∈ 𝕆.lines := O1_in_𝕆 zero_in_𝕆 hz₂

  -- Second step: fold a line parallel to l₁ that goes through z₂
  -- and a line parallel to l₂ that goes through z₁.
  let l₃ := E1 z₂ l₁
  let l₄ := E1 z₁ l₂
  have hl₃ : l₃ ∈ 𝕆.lines := E1_in_𝕆 z₂ l₁ hz₂ hl₁
  have hl₄ : l₄ ∈ 𝕆.lines := E1_in_𝕆 z₁ l₂ hz₁ hl₂
  have hl₃_z₁ : l₃.z₁ = z₂                       := by simp [l₃, E1]
  have hl₃_z₂ : l₃.z₂ = z₂ - z₁ / Complex.abs z₁ := by simp [l₃, E1, l₁, O1, line.vec]
  have hl₄_z₁ : l₄.z₁ = z₁                       := by simp [l₄, E1]
  have hl₄_z₂ : l₄.z₂ = z₁ - z₂ / Complex.abs z₂ := by simp [l₄, E1, l₂, O1, line.vec]

  have hl₃_l₄_not_parallel : ¬AreParallel l₃ l₄ := by
    simp_rw [AreParallel, line.vec, hl₃_z₁, hl₃_z₂, hl₄_z₁, hl₄_z₂]
    simp [div_self, hz₁_ne_zero, hz₂_ne_zero]
    constructor
    · specialize hz₁_ne_real_mult_z₂ ((Complex.abs z₁)/Complex.abs z₂)
      by_contra h
      simp [div_mul_comm, ← h, div_mul, div_self, hz₁_ne_zero] at hz₁_ne_real_mult_z₂
    · specialize hz₁_ne_real_mult_z₂ (-(Complex.abs z₁)/Complex.abs z₂)
      by_contra h
      simp [div_mul_comm, ← h, div_mul, div_self, hz₁_ne_zero] at hz₁_ne_real_mult_z₂

  -- Last step: take the intersectioon of l₃ and l₄.
  apply in_𝕆_if_eq (Isect l₃ l₄ hl₃_l₄_not_parallel)
  · exact Isect_in_𝕆 hl₃ hl₄
  · -- to show: this intersection really is the searched sum
    simp [Isect, line.vec, l₃, l₄, E1, l₂, l₁, O1]
    -- Very ugly, but whatever...
    field_simp
    simp [← neg_mul, ← div_mul_div_comm, ← div_mul_div_comm, mul_div_assoc, div_self, mul_div_assoc, sub_eq_add_neg, ← mul_assoc, ← neg_div, neg_sub]
    field_simp
    ring_nf
    simp
    symm
    have : -((z₂.re : ℂ) * (z₁.im : ℂ)) + (z₂.im : ℂ) * (z₁.re : ℂ) ≠ 0 := by
      norm_cast
      -- Why is it important for z₁ and z₂ to be non-orthogonal?
      sorry
    calc
      _ = z₁ * (-(↑z₂.re * ↑z₁.im) + ↑z₂.im * ↑z₁.re)
          * ↑(Complex.abs z₂) * ↑(Complex.abs z₁) ^ 2 / (↑(Complex.abs z₁) ^ 2 * ↑(Complex.abs z₂) *
          (-(↑z₂.re * ↑z₁.im) + ↑z₂.im * ↑z₁.re)) := by ring
      _ = z₁ * (-(↑z₂.re * ↑z₁.im) + ↑z₂.im * ↑z₁.re)
          * ↑(Complex.abs z₂) * ↑(Complex.abs z₁) ^ 2 / ↑(Complex.abs z₁) ^ 2 / ↑(Complex.abs z₂)
          / (-(↑z₂.re * ↑z₁.im) + ↑z₂.im * ↑z₁.re) := by simp [← div_div]
      _ = z₁ * ((-(↑z₂.re * ↑z₁.im) + ↑z₂.im * ↑z₁.re)
          * (↑(Complex.abs z₁) ^ 2 / ↑(Complex.abs z₁) ^ 2) * (↑(Complex.abs z₂) / ↑(Complex.abs z₂))
          / (-(↑z₂.re * ↑z₁.im) + ↑z₂.im * ↑z₁.re)) := by ring
      _ = z₁ := by
            simp [div_self, hz₁_ne_zero, hz₂_ne_zero, this]

end add
section mul

theorem 𝕆_inv {z : ℂ} (hz : z ∈ 𝕆) : z⁻¹ ∈ 𝕆 := by sorry
lemma 𝕆_real_mul {z : ℂ} {a : ℝ} (hz : z ∈ 𝕆) : a * z ∈ 𝕆 := by sorry
lemma 𝕆_i_mul {z : ℂ} (hz : z ∈ 𝕆) : Complex.I * z ∈ 𝕆 := by sorry
theorem 𝕆_mul {z₁ z₂ : ℂ} (hz₁ : z₁ ∈ 𝕆) (hz₂ : z₂ ∈ 𝕆) : z₁ * z₂ ∈ 𝕆 := by sorry

end mul


-- **Here comes the theorem stating that 𝕆 is a field.**

noncomputable def 𝕆Field : Subfield ℂ where
  carrier := 𝕆
  mul_mem' := 𝕆_mul
  one_mem' := one_in_𝕆
  add_mem' := 𝕆_add
  zero_mem' := zero_in_𝕆
  neg_mem' := 𝕆_neg
  inv_mem' := by
    intro z
    exact 𝕆_inv

theorem 𝕆_isField : IsField 𝕆Field := by
  exact Field.toIsField 𝕆Field


-- **𝕆 is closed under taking square and cube roots**

section square_root
lemma 𝕆_square_roots_pos_real {z : ℝ} {hz_pos : z > 0} (hz : (z : ℂ) ∈ 𝕆) : ∃ z' ∈ 𝕆, z = z' * z' := by sorry
theorem 𝕆_square_roots {z : ℂ} (hz : z ∈ 𝕆) : ∃ z' ∈ 𝕆, z = z' * z' := by sorry
end square_root

section cube_root
theorem 𝕆_cube_roots {z : ℂ} (hz : z ∈ 𝕆) : ∃ z' ∈ 𝕆, z = z' * z' * z' := by sorry
end cube_root
