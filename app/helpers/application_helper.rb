module ApplicationHelper
  def cedis(amount)
    "GH₵#{number_with_precision(amount, precision: 2, strip_insignificant_zeros: true, delimiter: ',')}"
  end
end
