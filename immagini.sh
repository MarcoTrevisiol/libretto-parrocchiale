output_dir="../immagini-std/"

for i in *jpg
do
  mv "$i" "${output_dir}${i}"
done

for i in *png
do
  convert "$i" "${output_dir}${i%png}jpg"
done

for i in "${output_dir}"*jpg
do
  convert "$i" -resize 1440x1440 -colorspace Gray "output.jpg"
  mv "output.jpg" "$i"
done

