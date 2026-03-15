input_dir="${1:-immagini-originali}/"
output_dir="immagini-std/"
conversion="-resize 1440x1440 -colorspace Gray"

mkdir -p "${output_dir}"
rm -f "${output_dir}"/*

for i in "${input_dir}"*jpg
do
  j="${i#${input_dir}}"
  # $conversion should be splitted into different arguments, do not quote
  convert "${i}" ${conversion} "${output_dir}${j}"
done

for i in "${input_dir}"*png
do
  j="${i#${input_dir}}"
  # $conversion should be splitted into different arguments, do not quote
  convert "${i}" ${conversion} "${output_dir}${j%png}jpg"
done

