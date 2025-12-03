Return-Path: <io-uring+bounces-10940-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B91CA1C51
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 23:06:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B7270304D0F7
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 22:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0EB330BF52;
	Wed,  3 Dec 2025 21:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Dcvz6tv7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D663A2253EF
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 21:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764798850; cv=none; b=mWrhGJ4c+BwlBPMoEAgjPxc3LVUnsh2y6fQcx2nXg6wsk0I3v9Zrt4x25yFb4GYDys3AZeulQeHNWN6cptu02d388Zla06JTDEM60XbZEDF1dXdY+zONrI9F7oQp2xYrQMdRTJbbSHsflIt/gkTsZ0Lr0HTi6JjCzitMehibZYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764798850; c=relaxed/simple;
	bh=qcJFPyaOH0oDmtQ8gBNn+OmZhs8yDCgNd35ZDEbGD0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bf1c0CunN0zoGYZ+FA/ZGqcOyVleETStd7bOB5UlnmlmG7LZ4kRFAooYhxIF73OYzDbG82Q9ZxTKSgzGhVQBmRhORi+A/Z86Y7QcLB4Z6AzrAxcBmXR4fLmP1BN6zt9pfnW0MUGii51UHuqWkVlogSETpCFaHGSsQwWfn/C4mRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Dcvz6tv7; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-299e43c1adbso366835ad.3
        for <io-uring@vger.kernel.org>; Wed, 03 Dec 2025 13:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764798846; x=1765403646; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cNqO1AOktfiC8ElyrsXdFe7FkjysK5RRpMpW3lmsUhg=;
        b=Dcvz6tv76Qm6/lQYRLtBnJXB/UTVfLiQIez5SWJtgqtQtQApzwhQLXQaZTiSf24itg
         uLZs1XaDtXoGgbKgLAhuukrJMVYyQr8i/EIwDwgkv2JZEkkP7S9ETP2lcikqvYB/MaQQ
         YH4H1n78WqYZm9xf3t5jeDvOnznbJ5EshZVO8njFNAqPKngol2JtLw0R19P6bc/rMdq6
         1S/XgeuU0pqZgOfKR+1yf+w9xYuQ/4+6qj+MqMOue3r5pd1Zs+NVeEVKKmi4i+ENruci
         7z8SMUgKjFlDul+zfJiGcWClNQ43Mp8cdr9YvG4rY1HnhZ8WQ+klgPIcPWpPRmnhenuR
         QHWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764798846; x=1765403646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cNqO1AOktfiC8ElyrsXdFe7FkjysK5RRpMpW3lmsUhg=;
        b=VzF87AxXU6ABIWb8iX7Q3QIj5gn/YSHSejk4ahLc5tB03jA+8FZAOhaxcgDT8YcbSv
         +ZtTscaa1iu7JMQWNk1nnlJCpxxWLnRv1o1CfcGFF88IU7ElmjgbsLW/UHgO8GRihBYR
         tajM0TSeuxgOaaMweOCoFbAQEW81tcWkb1SS/pI8gDtjlVooz+ztn7zZ0T4s16aj4J3v
         ToUYGSCjUzPK1piMLkBNK7Q7C/9cMgTGnFxSd/1Y6LepveO7Un/YbwJtNb2crmSgN5tj
         +ElMQXNl7E5kdMuY7DqT8scjphPOFZpHoLWrDrtXoi7x9Rkle9zaFCwc0Q6CQgx4CGfS
         BQIw==
X-Forwarded-Encrypted: i=1; AJvYcCXNN3AyWeqE0QXEESgqFg51SFS0u8OoMbzIn+zQcl/KFSPos5DcWbfKAgGGldl3fY1SHwh8rJlx6w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7bOQJ52GQsmy1m8bie+Ba2Z2+sXI07s9z+0EkhxzmoWfmcnJI
	i9CiwRvQ/YtzOf9U3XjmJVDcVc//6ltZyVRwWuh5P7KQhDpU7eJOij6rlQ5s6FFLDgBp2WUpbTE
	zdXKha3KmQxpQgg70nA6OwEa0QYhb/qcfVBvQFF4I/Q==
X-Gm-Gg: ASbGnct/jYIRW67dOzGV+ooXKzDBIRY1WJXIDNARAtzeI+WUx6d03AGhDHYkcgLuPHO
	+hHEIFvjtNTk0TlZRsoqxhtfPG3ln7Cx9QatR3rcneHVuw3NlduH1iBSJYbBR+Hz/mjtWhI2Dvs
	uMRCU5ZJWvXE1Vc1W1bz+pRRLyLfGtLcw7UNCJqpK4P2yh/KviRXVBuafz32WUllx3NhQ7gaEIV
	90vOcnFOyryCcsliCFRM8umWotXOQ==
X-Google-Smtp-Source: AGHT+IGo4rk2z3qITjUHjmzT74C8yUrNTvE4/mUjuUkdwPqjvYE0jxAXVSt1ovTOalvhiBDxbHC8Le18N48vfr9kgEQ=
X-Received: by 2002:a05:7300:df4a:b0:2a4:3593:5fc6 with SMTP id
 5a478bee46e88-2ab97895aeamr2241627eec.0.1764798845818; Wed, 03 Dec 2025
 13:54:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com> <20251203003526.2889477-12-joannelkoong@gmail.com>
In-Reply-To: <20251203003526.2889477-12-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 3 Dec 2025 13:53:54 -0800
X-Gm-Features: AWmQ_bnRKN2DJsYkd-18LskwFUzAFXKwgZ1sSlNV8ChDsShyP9GxhinWLmBTy_A
Message-ID: <CADUfDZoHCf4qHE1i7S4-Ya9WgGY0q6SmN4NVRgeGu347oZ6zJA@mail.gmail.com>
Subject: Re: [PATCH v1 11/30] io_uring/kbuf: return buffer id in buffer selection
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> Return the id of the selected buffer in io_buffer_select(). This is
> needed for kernel-managed buffer rings to later recycle the selected
> buffer.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/cmd.h   | 2 +-
>  include/linux/io_uring_types.h | 2 ++
>  io_uring/kbuf.c                | 7 +++++--
>  3 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index a4b5eae2e5d1..795b846d1e11 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -74,7 +74,7 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *i=
oucmd);
>
>  /*
>   * Select a buffer from the provided buffer group for multishot uring_cm=
d.
> - * Returns the selected buffer address and size.
> + * Returns the selected buffer address, size, and id.
>   */
>  struct io_br_sel io_uring_cmd_buffer_select(struct io_uring_cmd *ioucmd,
>                                             unsigned buf_group, size_t *l=
en,
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index e1a75cfe57d9..dcc95e73f12f 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -109,6 +109,8 @@ struct io_br_sel {
>                 void *kaddr;
>         };
>         ssize_t val;
> +       /* id of the selected buffer */
> +       unsigned buf_id;

Looks like this could be unioned with val? I think val's size can be
reduced to an int since only int values are assigned to it.

>  };
>
>
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 8a94de6e530f..3ecb6494adea 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -239,6 +239,7 @@ static struct io_br_sel io_ring_buffer_select(struct =
io_kiocb *req, size_t *len,
>         req->flags |=3D REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
>         req->buf_index =3D buf->bid;
>         sel.buf_list =3D bl;
> +       sel.buf_id =3D buf->bid;

This is userspace mapped, so probably should be using READ_ONCE() and
reusing the value between req->buf_index and buf->bid? Looks like an
existing bug that the reads of buf->bid and buf->addr aren't using
READ_ONCE().

>         if (bl->flags & IOBL_KERNEL_MANAGED)
>                 sel.kaddr =3D (void *)buf->addr;
>         else
> @@ -262,10 +263,12 @@ struct io_br_sel io_buffer_select(struct io_kiocb *=
req, size_t *len,
>
>         bl =3D io_buffer_get_list(ctx, buf_group);
>         if (likely(bl)) {
> -               if (bl->flags & IOBL_BUF_RING)
> +               if (bl->flags & IOBL_BUF_RING) {
>                         sel =3D io_ring_buffer_select(req, len, bl, issue=
_flags);
> -               else
> +               } else {
>                         sel.addr =3D io_provided_buffer_select(req, len, =
bl);
> +                       sel.buf_id =3D req->buf_index;

Could this cover both IOBL_BUF_RING and !IOBL_BUF_RING cases to avoid
the additional logic in io_ring_buffer_select()?

Best,
Caleb

> +               }
>         }
>         io_ring_submit_unlock(req->ctx, issue_flags);
>         return sel;
> --
> 2.47.3
>

