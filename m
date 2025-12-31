Return-Path: <io-uring+bounces-11336-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D71CEB023
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 02:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1147D3015EFF
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 01:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2932D7DDE;
	Wed, 31 Dec 2025 01:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="EFi4Dizv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8202B2D781B
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 01:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767145369; cv=none; b=UPnDITBpSzEQ+F2pxPxHgNExEOZhf+0WS5tlKU319BVF5voWTE9vBLHGwT+HjIyfjzs9HfS8GKJ5RdMuwPu7sZGUEbZvfaJoy8jS4Sfev4+YywUK2aG9aOM4DL+fH7a/THzQEiN8DbImcEWLuygqn6JXAuEN0p6eTtOpP9SA8VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767145369; c=relaxed/simple;
	bh=Q7d7lAJyrKqmN7K21tuACjBtdRi2G9XwTwcsTZqkDME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P7rHoy/iiha4Bt2okDGeBudD9yYXLCpDslSYlvA883LQw0YQM9uljSSSk0/4vgOiBWYhzznnWbyC6RskppnKyB37/b78ul7jXuMa23o1boJA6fewO1LcSvYUbbNom4MINOyX/cuRKAjkAv7RQ69J7ERRxTrnfSp12p6do0C9bgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=EFi4Dizv; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29f08b909aeso22742735ad.2
        for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 17:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767145367; x=1767750167; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cerbiFeIbisMpA9u2GRN2S+lVKIR7pRt0+ivCw3dgzI=;
        b=EFi4DizvZKD9S+VJntu3m6lsedO/XimDRvGrHNvQrlEdfnf8JfV2CXHppVo3Agc7hB
         jYuzzRNFvg+FSBZDu/Lwun/wu+IiIC4rK7Ovht+mgpj07rdySljxtxuMTFHptRBqDd3h
         DHbYFG75Y1doACg8GnxhOkFk2g6ZwpBENlLEGS1XPKqnKgT6URf27bTYBYF/NUGQ9QSL
         0epg5Eh+zPeQQRvSjN9kkUMRFb555WzJ00OfWAYrv+Zbr3LT3hseOSWdcj+6BfuKIgj8
         TKKJ+rQGxwRX6Y/N5rLWKAfiewWH6+ORE2ps6ARvy/t5+0ECKVx9c43cuCL48V+YaB9+
         78BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767145367; x=1767750167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cerbiFeIbisMpA9u2GRN2S+lVKIR7pRt0+ivCw3dgzI=;
        b=MZdxuqIsWS8j0xhMNXhUBR2tUMQP+cmG/3mV6K0VyuT0N+zwfcmXc0QmBAOQ2Qe6fc
         43fA47z4COu4TQQsp8NCzi/IYBesCYydy/KRpok4C+24FFICVPuS0io/8j7XJAa/PS3l
         OM+kGRkizKe3fBJppVR2srtjrT000isxk2EAVWWwG8+w051kzVP7EsPwBSTrPT6uXh/Q
         5BvWVPDglxDrnnIkglBzMwl4Xjxz15FWF5++mt0wWYfwxYgMjgbybgZrmUBo0RRdL76x
         bW4ERpXJbxhEFzhVKcDNm1CZK4uUVd/IrTAFwCK6+/J+PdzgglTBc3Rmd7RVz86eGPgi
         sfmg==
X-Forwarded-Encrypted: i=1; AJvYcCV5G+TtiMOPgz3KKpxqtF2C7kKqi3U7k2VpmltVbWAVoThzkHyb/rRGTWoSrNTm9L0MMhUYCX/o9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyboiiTwrCJ1gSXZHhR79a9SY1DrmTnFnczQx7XraFkA27JSMS9
	oSW1o+lEMskUlpz+k8223hswMP70ndCAuSKtyuz39bMIg6SmA7tzacIqpFVORApQoIYJt/VLseg
	gPo/rs7SHyCH2y3Yc5SuEpU86j76YBytmnlQiPNbvq1oRhcuq/5GY
X-Gm-Gg: AY/fxX5HFBykPqCDKecLmpelJaFCK4EU2B3MK4h2kXK/1LIARKcmmSffdS1dAW26PNp
	TU4D5aErhCYae6I0J5AdqPOH5Pn3QN89nDBoVsxgUZaJ2k2tdskUIDdHfExKmyIW0600yB+7zDY
	j5oBl+xXr2Dyoiy+/ssDyMi6IPGbnW9VZ8W9dm1OyuaprjjVxK2v2A1DAJTF85brwPaUP36c9Qj
	CJAOrwNQqJgiB7zYHRMHb19x7Ocyp55N1A917MEPJFqYPSkWMCWjUz/4lts+wCoslFkxkLfh1+4
	9L4PlqY=
X-Google-Smtp-Source: AGHT+IEP4mtES43Oft57DxAtE9Og+KnxiZ7rZ6g7IdqEEa055mh1V/c/54VR2OpE05Pzt1s9MuaKdG/6k1djNaTwNX8=
X-Received: by 2002:a05:7022:42a4:b0:11a:2020:ac85 with SMTP id
 a92af1059eb24-121722ecd23mr19159708c88.4.1767145366585; Tue, 30 Dec 2025
 17:42:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104162123.1086035-1-ming.lei@redhat.com> <20251104162123.1086035-6-ming.lei@redhat.com>
In-Reply-To: <20251104162123.1086035-6-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 30 Dec 2025 20:42:35 -0500
X-Gm-Features: AQt7F2pgz3u-V5xJ9TSWrd1Wm5eK7uKc053x_McfMMzQSM4EFEWDpwduSAE5KNc
Message-ID: <CADUfDZqsqiZkSZrkDacviO3sJ61KHmgZ5-BNm2+s6=Sb4yVV7Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] io_uring: bpf: add io_uring_bpf_req_memcpy() kfunc
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 8:22=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrote=
:
>
> Add io_uring_bpf_req_memcpy() kfunc to enable BPF programs to copy
> data between buffers associated with IORING_OP_BPF requests.
>
> The kfunc supports copying between:
> - Plain user buffers (using import_ubuf())
> - Fixed/registered buffers (using io_import_reg_buf())
> - Mixed combinations (plain-to-fixed, fixed-to-plain)
>
> This enables BPF programs to implement data transformation and
> processing operations directly within io_uring's request context,
> avoiding additional userspace copies.
>
> Implementation details:
>
> 1. Add issue_flags tracking in struct uring_bpf_data:
>    - Replace __pad field with issue_flags (bytes 36-39)
>    - Initialized to 0 before ops->prep_fn()
>    - Saved from issue_flags parameter before ops->issue_fn()
>    - Required by io_import_reg_buf() for proper async handling
>
> 2. Add buffer preparation infrastructure:
>    - io_bpf_prep_buffers() extracts buffer metadata from SQE
>    - Buffer 1: plain (addr/len) or fixed (buf_index/addr/len)
>    - Buffer 2: plain only (addr3/optlen)
>    - Buffer types encoded in sqe->bpf_op_flags bits 23-18
>
> 3. io_uring_bpf_req_memcpy() implementation:
>    - Validates buffer IDs (1 or 2) and prevents same-buffer copies
>    - Extracts buffer metadata based on buffer ID
>    - Sets up iov_iters using import_ubuf() or io_import_reg_buf()
>    - Performs page-sized chunked copying via temporary buffer
>    - Returns bytes copied or negative error code
>
> Buffer encoding in sqe->bpf_op_flags (32 bits):
>   Bits 31-24: BPF operation ID (8 bits)
>   Bits 23-21: Buffer 1 type (0=3Dnone, 1=3Dplain, 2=3Dfixed)
>   Bits 20-18: Buffer 2 type (0=3Dnone, 1=3Dplain)
>   Bits 17-0:  Custom BPF flags (18 bits)
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  io_uring/bpf.c       | 187 +++++++++++++++++++++++++++++++++++++++++++
>  io_uring/uring_bpf.h |  11 ++-
>  2 files changed, 197 insertions(+), 1 deletion(-)
>
> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> index e837c3d57b96..ee4c617e3904 100644
> --- a/io_uring/bpf.c
> +++ b/io_uring/bpf.c
> @@ -109,6 +109,8 @@ int io_uring_bpf_prep(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe)
>         if (ret)
>                 return ret;
>
> +       /* ctx->uring_lock is held */
> +       data->issue_flags =3D 0;
>         if (ops->prep_fn)
>                 return ops->prep_fn(data, sqe);
>         return -EOPNOTSUPP;
> @@ -126,6 +128,9 @@ static int __io_uring_bpf_issue(struct io_kiocb *req)
>
>  int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
>  {
> +       struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct uring=
_bpf_data);
> +
> +       data->issue_flags =3D issue_flags;
>         if (issue_flags & IO_URING_F_UNLOCKED) {
>                 int idx, ret;
>
> @@ -143,6 +148,8 @@ void io_uring_bpf_fail(struct io_kiocb *req)
>         struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct uring=
_bpf_data);
>         struct uring_bpf_ops *ops =3D uring_bpf_get_ops(data);
>
> +       /* ctx->uring_lock is held */
> +       data->issue_flags =3D 0;
>         if (ops->fail_fn)
>                 ops->fail_fn(data);
>  }
> @@ -152,6 +159,8 @@ void io_uring_bpf_cleanup(struct io_kiocb *req)
>         struct uring_bpf_data *data =3D io_kiocb_to_cmd(req, struct uring=
_bpf_data);
>         struct uring_bpf_ops *ops =3D uring_bpf_get_ops(data);
>
> +       /* ctx->uring_lock is held */
> +       data->issue_flags =3D 0;
>         if (ops->cleanup_fn)
>                 ops->cleanup_fn(data);
>  }
> @@ -324,6 +333,104 @@ static struct bpf_struct_ops bpf_uring_bpf_ops =3D =
{
>         .owner =3D THIS_MODULE,
>  };
>
> +/*
> + * Helper to copy data between two iov_iters using page extraction.
> + * Extracts pages from source iterator and copies them to destination.
> + * Returns number of bytes copied or negative error code.
> + */
> +static ssize_t io_bpf_copy_iters(struct iov_iter *src, struct iov_iter *=
dst,
> +                                size_t len)
> +{
> +#define MAX_PAGES_PER_LOOP 32
> +       struct page *pages[MAX_PAGES_PER_LOOP];
> +       size_t total_copied =3D 0;
> +       bool need_unpin;
> +
> +       /* Determine if we'll need to unpin pages later */
> +       need_unpin =3D user_backed_iter(src);

Use iov_iter_extract_will_pin() for clarity?

> +
> +       /* Process pages in chunks */
> +       while (len > 0) {
> +               struct page **page_array =3D pages;
> +               size_t offset, copied =3D 0;
> +               ssize_t extracted;
> +               unsigned int nr_pages;
> +               size_t chunk_len;
> +               int i;
> +
> +               /* Extract up to MAX_PAGES_PER_LOOP pages */
> +               chunk_len =3D min_t(size_t, len, MAX_PAGES_PER_LOOP * PAG=
E_SIZE);
> +               extracted =3D iov_iter_extract_pages(src, &page_array, ch=
unk_len,
> +                                                  MAX_PAGES_PER_LOOP, 0,=
 &offset);
> +               if (extracted <=3D 0) {
> +                       if (total_copied > 0)
> +                               break;
> +                       return extracted < 0 ? extracted : -EFAULT;
> +               }
> +
> +               nr_pages =3D DIV_ROUND_UP(offset + extracted, PAGE_SIZE);
> +
> +               /* Copy pages to destination iterator */
> +               for (i =3D 0; i < nr_pages && copied < extracted; i++) {
> +                       size_t page_offset =3D (i =3D=3D 0) ? offset : 0;
> +                       size_t page_len =3D min_t(size_t, extracted - cop=
ied,
> +                                               PAGE_SIZE - page_offset);
> +                       size_t n;
> +
> +                       n =3D copy_page_to_iter(pages[i], page_offset, pa=
ge_len, dst);
> +                       copied +=3D n;
> +                       if (n < page_len)
> +                               break;
> +               }
> +
> +               /* Clean up extracted pages */
> +               if (need_unpin)
> +                       unpin_user_pages(pages, nr_pages);

Could avoid the page pinning and unpinning cost when copying from a
user iov_iter to a bvec iov_iter by using iov_iter_extract_pages(dst)
and copy_page_from_iter(src). But this optimization could be
implemented later.

> +
> +               total_copied +=3D copied;
> +               len -=3D copied;
> +
> +               /* Stop if we didn't copy all extracted data */
> +               if (copied < extracted)
> +                       break;
> +       }
> +
> +       return total_copied;
> +#undef MAX_PAGES_PER_LOOP
> +}
> +
> +/*
> + * Helper to import a buffer into an iov_iter for BPF memcpy operations.
> + * Handles both plain user buffers and fixed/registered buffers.
> + *
> + * @req: io_kiocb request
> + * @iter: output iterator
> + * @buf_type: buffer type (plain or fixed)
> + * @addr: buffer address
> + * @offset: offset into buffer
> + * @len: length from offset
> + * @direction: ITER_SOURCE for source buffer, ITER_DEST for destination
> + * @issue_flags: io_uring issue flags
> + *
> + * Returns 0 on success, negative error code on failure.
> + */
> +static int io_bpf_import_buffer(struct io_kiocb *req, struct iov_iter *i=
ter,
> +                               u8 buf_type, u64 addr, unsigned int offse=
t,
> +                               u32 len, int direction, unsigned int issu=
e_flags)
> +{
> +       if (buf_type =3D=3D IORING_BPF_BUF_TYPE_PLAIN) {
> +               /* Plain user buffer */
> +               return import_ubuf(direction, (void __user *)(addr + offs=
et),
> +                                  len - offset, iter);
> +       } else if (buf_type =3D=3D IORING_BPF_BUF_TYPE_FIXED) {
> +               /* Fixed buffer */
> +               return io_import_reg_buf(req, iter, addr + offset,
> +                                        len - offset, direction, issue_f=
lags);
> +       }
> +
> +       return -EINVAL;
> +}
> +
>  __bpf_kfunc_start_defs();
>  __bpf_kfunc void uring_bpf_set_result(struct uring_bpf_data *data, int r=
es)
>  {
> @@ -339,11 +446,91 @@ __bpf_kfunc struct io_kiocb *uring_bpf_data_to_req(=
struct uring_bpf_data *data)
>  {
>         return cmd_to_io_kiocb(data);
>  }
> +
> +/**
> + * io_uring_bpf_req_memcpy - Copy data between io_uring BPF request buff=
ers
> + * @data: BPF request data containing buffer metadata
> + * @dest: Destination buffer descriptor (with buf_id and offset)
> + * @src: Source buffer descriptor (with buf_id and offset)
> + * @len: Number of bytes to copy
> + *
> + * Copies data between two different io_uring BPF request buffers (buf_i=
d 1 and 2).
> + * Supports: plain-to-plain, fixed-to-plain, and plain-to-fixed.
> + * Does not support copying within the same buffer (src and dest must be=
 different).
> + *
> + * Returns: Number of bytes copied on success, negative error code on fa=
ilure
> + */
> +__bpf_kfunc int io_uring_bpf_req_memcpy(struct uring_bpf_data *data,
> +                                       struct bpf_req_mem_desc *dest,
> +                                       struct bpf_req_mem_desc *src,

Curious, does struct bpf_req_mem_desc need to be registered anywhere
for use as a kfunc argument? Or is any type automatically allowed to
be used with a kfunc since BTF is generated for it?

Best,
Caleb


> +                                       unsigned int len)
> +{
> +       struct io_kiocb *req =3D cmd_to_io_kiocb(data);
> +       struct iov_iter dst_iter, src_iter;
> +       u8 dst_type, src_type;
> +       u64 dst_addr, src_addr;
> +       u32 dst_len, src_len;
> +       int ret;
> +
> +       /* Validate buffer IDs */
> +       if (dest->buf_id < 1 || dest->buf_id > 2 ||
> +           src->buf_id < 1 || src->buf_id > 2)
> +               return -EINVAL;
> +
> +       /* Don't allow copying within the same buffer */
> +       if (src->buf_id =3D=3D dest->buf_id)
> +               return -EINVAL;
> +
> +       /* Extract source buffer metadata */
> +       if (src->buf_id =3D=3D 1) {
> +               src_type =3D IORING_BPF_BUF1_TYPE(data->opf);
> +               src_addr =3D data->buf1_addr;
> +               src_len =3D data->buf1_len;
> +       } else {
> +               src_type =3D IORING_BPF_BUF2_TYPE(data->opf);
> +               src_addr =3D data->buf2_addr;
> +               src_len =3D data->buf2_len;
> +       }
> +
> +       /* Extract destination buffer metadata */
> +       if (dest->buf_id =3D=3D 1) {
> +               dst_type =3D IORING_BPF_BUF1_TYPE(data->opf);
> +               dst_addr =3D data->buf1_addr;
> +               dst_len =3D data->buf1_len;
> +       } else {
> +               dst_type =3D IORING_BPF_BUF2_TYPE(data->opf);
> +               dst_addr =3D data->buf2_addr;
> +               dst_len =3D data->buf2_len;
> +       }
> +
> +       /* Validate offsets and lengths */
> +       if (src->offset + len > src_len || dest->offset + len > dst_len)
> +               return -EINVAL;
> +
> +       /* Initialize source iterator */
> +       ret =3D io_bpf_import_buffer(req, &src_iter, src_type,
> +                                  src_addr, src->offset, src_len,
> +                                  ITER_SOURCE, data->issue_flags);
> +       if (ret)
> +               return ret;
> +
> +       /* Initialize destination iterator */
> +       ret =3D io_bpf_import_buffer(req, &dst_iter, dst_type,
> +                                  dst_addr, dest->offset, dst_len,
> +                                  ITER_DEST, data->issue_flags);
> +       if (ret)
> +               return ret;
> +
> +       /* Extract pages from source iterator and copy to destination */
> +       return io_bpf_copy_iters(&src_iter, &dst_iter, len);
> +}
> +
>  __bpf_kfunc_end_defs();
>
>  BTF_KFUNCS_START(uring_bpf_kfuncs)
>  BTF_ID_FLAGS(func, uring_bpf_set_result)
>  BTF_ID_FLAGS(func, uring_bpf_data_to_req)
> +BTF_ID_FLAGS(func, io_uring_bpf_req_memcpy)
>  BTF_KFUNCS_END(uring_bpf_kfuncs)
>
>  static const struct btf_kfunc_id_set uring_kfunc_set =3D {
> diff --git a/io_uring/uring_bpf.h b/io_uring/uring_bpf.h
> index c919931cb4b0..d6e0d6dff82e 100644
> --- a/io_uring/uring_bpf.h
> +++ b/io_uring/uring_bpf.h
> @@ -14,13 +14,22 @@ struct uring_bpf_data {
>         /* Buffer 2 metadata - readable for bpf prog (plain only) */
>         u64             buf2_addr;              /* buffer 2 address, byte=
s 24-31 */
>         u32             buf2_len;               /* buffer 2 length, bytes=
 32-35 */
> -       u32             __pad;                  /* padding, bytes 36-39 *=
/
> +       u32             issue_flags;            /* issue_flags from io_ur=
ing, bytes 36-39 */
>
>         /* writeable for bpf prog */
>         u8              pdu[64 - sizeof(struct file *) - 4 * sizeof(u32) =
-
>                 2 * sizeof(u64)];
>  };
>
> +/*
> + * Descriptor for io_uring BPF request buffer.
> + * Used by io_uring_bpf_req_memcpy() to identify which buffer to copy fr=
om/to.
> + */
> +struct bpf_req_mem_desc {
> +       u8              buf_id;         /* Buffer ID: 1 or 2 */
> +       unsigned int    offset;         /* Offset into buffer */
> +};
> +
>  typedef int (*uring_io_prep_t)(struct uring_bpf_data *data,
>                                const struct io_uring_sqe *sqe);
>  typedef int (*uring_io_issue_t)(struct uring_bpf_data *data);
> --
> 2.47.0
>

