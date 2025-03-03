Return-Path: <io-uring+bounces-6915-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F936A4CCEA
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 21:50:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B02DF3AAFDC
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 20:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7742E236A63;
	Mon,  3 Mar 2025 20:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="d/f4Do8p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480682356B7
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 20:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741034993; cv=none; b=hOq8ymGYlfLvgqWO3apx9J+k5VBdddFqVGJKy9rB7+3CLsVy/YJosTNQpQRcvBE6dBSk9oTe6hH1NU2YgiyAalA0UWpE3Y3bJVGzhcKGpAaBwLdLeTrnWvrzhpcuzZnH7U88xgtQR8hsOPCJf6kYkF8LIbZHY3DUaw15Msjeoqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741034993; c=relaxed/simple;
	bh=36PucfbY1Ep2ipYXPc5DKu91nioDevuT/1MfucrSWN8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iGMbQ1LopMV1By3eVDwXXD+R7JOqjvwf1zDfodbB4tHwVwORUXafrbNCw6NZo+vz721RaQz5uWGms+l+30VgLXOi8nNVSZa24MPsnuYY/6fezdvwudYdMzt29kzKyJh8cGEq3alJnfkL6xcTJF/R/7CpVszzVaYqr7KG4kKZ4YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=d/f4Do8p; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2fee688b474so426553a91.3
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 12:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1741034990; x=1741639790; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pfGeneDc6yQg8xF5AINQ+CJEqnP6CPpWcFJI0yuStzc=;
        b=d/f4Do8pzRSI4vN0qSF1wAEloTuc2ZpbWxV7Jy2ctQgyC9CHLWg5MNVso9vOvJIb+x
         n1KuP3maPhPNah6sy5ufXeHFxzcHbPUeXMUKTeLysEtPHRcxmmTcW4oH7XmaGZdpLD6b
         lW4wD6el8zBsDGHEOunLdfmY44c7/a63tCAlbyje0+ketSllUmbiV+AJCXAZU4Bq9qjD
         Vmh8mwnVORT9THlow49A6IPQrPRDMadLIDSKXyR7Zmx3Of4/y0dLVobNFWOrsOv9EtwO
         UUYFnIqGQ94e+O8cF1PvPmSdduag8rqDMpELY2uYFxPeZOLLVzr3yhutKXSiYM5v6aHe
         ChnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741034990; x=1741639790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pfGeneDc6yQg8xF5AINQ+CJEqnP6CPpWcFJI0yuStzc=;
        b=Tl2MHsbgrhNhiMNjqTmcCIIl/NbuXbFil9SothW7JL034dByR0jFtovFvjxQjQ5oxg
         CG9UCpxezeHWtTYRmUwYQg3ZXQIWCA3wY/MiGaFcIPByRb3nmyg3PVL42KUGjS/2YW9L
         IsaB7Y8p/8tR1NFSBH23Fz4RdAQFpiKCezYHmB9PT/ThEMuPQ1dLjhw3CFJbTYsnwJeW
         u8p5dfG0kFqjl00vLb/hPDxSX21j+NSoObbMClO9tJAtN/khkcG0bTW+Zf6GMC06oer2
         lNiHipaIedOUfFTSMdPv/SbZtKZcFajzIDCjZ+7XX0rYJYb5AiVXXjXeJBO21ImRADSJ
         F4GQ==
X-Gm-Message-State: AOJu0YzAHRSKToaGIud6Co8Qj/lj2achFAgkCmCi9QFlYPzGOnxnPsqj
	44fhaTfu/HkxuR1T2DNEmvxA6xpnQ1wY25+jp1skKZcQYgZECVub4G9q9Mm1XEIVt5Y4FEh32Hs
	mGKG9jDTdSdM0NtDmyhhsRZTNyeYVsrmknFtGT3sdLWpPIsyUrgU=
X-Gm-Gg: ASbGnctvtmUX+H6+6GhepHdixRWP3mYzzChiv1H1J+eVUok50idDwYcjd3ecm48MGsv
	PqJUReKuo6oVjxhgoPT7skVuVLrIaAj8UTTfeABEh+I2SiBWXmmjyBefFyOLbmf+ph5NVZln8l6
	juXXo2KIFVx/t8/ITI8I2A8p4j
X-Google-Smtp-Source: AGHT+IEJ8SXKyzoOH97c+A5Nrd2JFvvvpvsTpXBFEU3eZbSg4/xkHjOYLykNSBF+8fbQA8PASRegE9y2FIfoi//SezI=
X-Received: by 2002:a17:90b:3a85:b0:2fe:afef:b706 with SMTP id
 98e67ed59e1d1-2ff3535443emr76214a91.7.1741034990208; Mon, 03 Mar 2025
 12:49:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1741014186.git.asml.silence@gmail.com> <841b4d5b039b9db84aa1e1415a6d249ea57646f6.1741014186.git.asml.silence@gmail.com>
In-Reply-To: <841b4d5b039b9db84aa1e1415a6d249ea57646f6.1741014186.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 3 Mar 2025 12:49:38 -0800
X-Gm-Features: AQ5f1JpRgADWOHITjW1DRkrvGMVI7DC1VHN8XFcWbgXMTxI9TVHuRHYto8ajj1A
Message-ID: <CADUfDZobvM1V38qSizh=WqAv1o5-pTOSZ+PUDMgEhgY3OVAssg@mail.gmail.com>
Subject: Re: [PATCH 2/8] io_uring: add infra for importing vectored reg buffers
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 7:51=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> Add io_import_reg_vec(), which will be responsible for importing
> vectored registered buffers. iovecs are overlapped with the resulting
> bvec in memory, which is why the iovec is expected to be padded in
> iou_vec.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/io_uring_types.h |   5 +-
>  io_uring/rsrc.c                | 124 +++++++++++++++++++++++++++++++++
>  io_uring/rsrc.h                |   5 ++
>  3 files changed, 133 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 9101f12d21ef..b770a2b12da6 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -111,7 +111,10 @@ struct io_uring_task {
>  };
>
>  struct iou_vec {
> -       struct iovec            *iovec;
> +       union {
> +               struct iovec    *iovec;
> +               struct bio_vec  *bvec;
> +       };

If I understand correctly, io_import_reg_vec() converts the iovecs to
bio_vecs in place. If an iovec expands to more than one bio_vec (i.e.
crosses a folio boundary), wouldn't the bio_vecs overwrite iovecs that
hadn't been processed yet?

>         unsigned                nr;
>  };
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 9b05e614819e..1ec1f5b3e385 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1267,9 +1267,133 @@ int io_register_clone_buffers(struct io_ring_ctx =
*ctx, void __user *arg)
>
>  void io_vec_free(struct iou_vec *iv)
>  {
> +       BUILD_BUG_ON(sizeof(struct bio_vec) > sizeof(struct iovec));
> +
>         if (!iv->iovec)
>                 return;
>         kfree(iv->iovec);
>         iv->iovec =3D NULL;
>         iv->nr =3D 0;
>  }
> +
> +int io_vec_realloc(struct iou_vec *iv, unsigned nr_entries)
> +{
> +       struct iovec *iov;
> +
> +       WARN_ON_ONCE(nr_entries <=3D 0);
> +
> +       iov =3D kmalloc_array(nr_entries, sizeof(iov[0]), GFP_KERNEL);
> +       if (!iov)
> +               return -ENOMEM;
> +
> +       io_vec_free(iv);
> +       iv->iovec =3D iov;
> +       iv->nr =3D nr_entries;
> +       return 0;
> +}
> +
> +static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
> +                               struct io_mapped_ubuf *imu,
> +                               struct iovec *iovec, int nr_iovs,
> +                               struct iou_vec *vec)
> +{
> +       unsigned long folio_size =3D (1 << imu->folio_shift);
> +       unsigned long folio_mask =3D folio_size - 1;
> +       struct bio_vec *res_bvec =3D vec->bvec;
> +       size_t total_len =3D 0;
> +       int bvec_idx =3D 0;
> +       int iov_idx;
> +
> +       for (iov_idx =3D 0; iov_idx < nr_iovs; iov_idx++) {
> +               size_t iov_len =3D iovec[iov_idx].iov_len;
> +               u64 buf_addr =3D (u64)iovec[iov_idx].iov_base;
> +               u64 folio_addr =3D imu->ubuf & ~folio_mask;

The computation of folio_addr could be moved out of the loop.

> +               struct bio_vec *src_bvec;
> +               size_t offset;
> +               u64 buf_end;
> +
> +               if (unlikely(check_add_overflow(buf_addr, (u64)iov_len, &=
buf_end)))
> +                       return -EFAULT;
> +               if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf=
 + imu->len)))
> +                       return -EFAULT;
> +
> +               total_len +=3D iov_len;
> +               /* by using folio address it also accounts for bvec offse=
t */
> +               offset =3D buf_addr - folio_addr;
> +               src_bvec =3D imu->bvec + (offset >> imu->folio_shift);
> +               offset &=3D folio_mask;
> +
> +               for (; iov_len; offset =3D 0, bvec_idx++, src_bvec++) {
> +                       size_t seg_size =3D min_t(size_t, iov_len,
> +                                               folio_size - offset);
> +
> +                       res_bvec[bvec_idx].bv_page =3D src_bvec->bv_page;
> +                       res_bvec[bvec_idx].bv_offset =3D offset;
> +                       res_bvec[bvec_idx].bv_len =3D seg_size;

Could just increment res_bvec to avoid the variable bvec_idx?

> +                       iov_len -=3D seg_size;
> +               }
> +       }
> +       if (total_len > MAX_RW_COUNT)
> +               return -EINVAL;
> +
> +       iov_iter_bvec(iter, ddir, res_bvec, bvec_idx, total_len);
> +       return 0;
> +}
> +
> +static int io_estimate_bvec_size(struct iovec *iov, unsigned nr_iovs,
> +                                struct io_mapped_ubuf *imu)
> +{
> +       unsigned shift =3D imu->folio_shift;
> +       size_t max_segs =3D 0;
> +       unsigned i;
> +
> +       for (i =3D 0; i < nr_iovs; i++)
> +               max_segs +=3D (iov[i].iov_len >> shift) + 2;

Sees like this may overestimate a bit. I think something like this
would give the exact number of segments for each iovec?
(((u64)iov_base & folio_mask) + iov_len + folio_mask) >> folio_shift

> +       return max_segs;
> +}
> +
> +int io_import_reg_vec(int ddir, struct iov_iter *iter,
> +                       struct io_kiocb *req, struct iou_vec *vec,
> +                       int nr_iovs, unsigned iovec_off,
> +                       unsigned issue_flags)
> +{
> +       struct io_rsrc_node *node;
> +       struct io_mapped_ubuf *imu;
> +       unsigned cache_nr;
> +       struct iovec *iov;
> +       unsigned nr_segs;
> +       int ret;
> +
> +       node =3D io_find_buf_node(req, issue_flags);
> +       if (!node)
> +               return -EFAULT;
> +       imu =3D node->buf;
> +       if (imu->is_kbuf)
> +               return -EOPNOTSUPP;
> +
> +       iov =3D vec->iovec + iovec_off;
> +       ret =3D io_estimate_bvec_size(iov, nr_iovs, imu);
> +       if (ret < 0)
> +               return ret;

io_estimate_bvec_size() doesn't (intentionally) return an error code,
just an unsigned value cast to an int.

Best,
Caleb

> +       nr_segs =3D ret;
> +       cache_nr =3D vec->nr;
> +
> +       if (WARN_ON_ONCE(iovec_off + nr_iovs !=3D cache_nr) ||
> +           nr_segs > cache_nr) {
> +               struct iou_vec tmp_vec =3D {};
> +
> +               ret =3D io_vec_realloc(&tmp_vec, nr_segs);
> +               if (ret)
> +                       return ret;
> +
> +               iovec_off =3D tmp_vec.nr - nr_iovs;
> +               memcpy(tmp_vec.iovec + iovec_off, iov, sizeof(*iov) * nr_=
iovs);
> +               io_vec_free(vec);
> +
> +               *vec =3D tmp_vec;
> +               iov =3D vec->iovec + iovec_off;
> +               req->flags |=3D REQ_F_NEED_CLEANUP;
> +       }
> +
> +       return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
> +}
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index e3f1cfb2ff7b..769ef5d76a4b 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -61,6 +61,10 @@ struct io_rsrc_node *io_find_buf_node(struct io_kiocb =
*req,
>  int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
>                         u64 buf_addr, size_t len, int ddir,
>                         unsigned issue_flags);
> +int io_import_reg_vec(int ddir, struct iov_iter *iter,
> +                       struct io_kiocb *req, struct iou_vec *vec,
> +                       int nr_iovs, unsigned iovec_off,
> +                       unsigned issue_flags);
>
>  int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)=
;
>  int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
> @@ -146,6 +150,7 @@ static inline void __io_unaccount_mem(struct user_str=
uct *user,
>  }
>
>  void io_vec_free(struct iou_vec *iv);
> +int io_vec_realloc(struct iou_vec *iv, unsigned nr_entries);
>
>  static inline void io_vec_reset_iovec(struct iou_vec *iv,
>                                       struct iovec *iovec, unsigned nr)
> --
> 2.48.1
>
>

