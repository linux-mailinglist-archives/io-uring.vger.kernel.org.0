Return-Path: <io-uring+bounces-11536-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0223AD061D6
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 21:37:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7A1FC30339B7
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 20:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D4732ABFF;
	Thu,  8 Jan 2026 20:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="eHxPwdQR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6D72F8BF0
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 20:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904666; cv=none; b=cJIKnBvBlPaHeLAJO1ZgYE/EdD9QkahG4C8I44n/2CeItWcDHR8kpSJJ2rKsFmZNCmjGIr8pOB0No6vCkSgcpBobZegk8oANm/M75g+sZa7FGZKaZQRemJPzx/n9s7KMEubqNO/fGXi1bw3ppmIRaP+p88hcVk+fTpGmgyicF6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904666; c=relaxed/simple;
	bh=NdOE8msjLm3KVhmDL6raJoIMfhOY2SzmPVUotdY4lDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ED9pZ274ndS4u00wJiYQ0MdAd0KUWVjuFmz+5z0n+C9hJHtK7qiFwIgKb1hbpODTpiEx/jhJQ6VTCNfPT/8RxUeCb4QeBnvbWUuGuweyHVZncysK9Qd9Vx3swb4WizrmMvZpWC5JJ8KfnJiEFdMHVw1/s+yAlRN4oLKeOpxb4MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=eHxPwdQR; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-11ddccf4afdso264403c88.3
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 12:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767904663; x=1768509463; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0/xgfnmJH9UTPhx0+B4DTUkdQWKIyCwuiK37YXEj5g=;
        b=eHxPwdQRflHFlRbEenkO6BAO2M4AvCKLVZ+WB+fbtLtVAtxn2TtUXzw/wNDOrAP3US
         Ki7nCE49Hcm21zE17Hk8J0Sgyr17r1KNgKziG/leh/o5M4819uz2/IwomVSbw66Fi1mA
         cttUxNMYrSa+gnRXxSBdpWa3yS1hmw7T/ittwBNz0T3EBHedvd4K14bkmZF+XdyJKKKt
         IaxMR4F6XyytiKx5qQBTCk7/c5Ysb2/pS6Qaax9l88W7WwTqXPnUmvymtI9RRH+7d/o6
         Zw43JGGg1umFj+eeN/70lqcjBgIzXW8UBzDTDAms+FzJTZubtyYYx+baw7WZaFo+IM6U
         NdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904663; x=1768509463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y0/xgfnmJH9UTPhx0+B4DTUkdQWKIyCwuiK37YXEj5g=;
        b=vUyxDSQCkNZyWNltCfMmyxlskfXZO4D85UuExj+Y99xHNPO4UCKfeiPb4kp7+5YHxo
         jUrTuVhUsAyLwY7NREVwxTO8BFYuAVLBOMbyjT9XQhxkWUl08RQW2QaVn/JNGPv/6e5M
         0/h0xkeoutoJTd5mKbHcOIFZcr46ZPz2htl2MQgvtY59f496gnMzqDAhodw3JTeByHlx
         J+6JCUaNpcdUETNwzQ1GL7ZOqyfuZFT7Y8hXXseorhZMx7qjmUsdYujAf8SdTtuk5zSG
         /TvwuqF0FyMM6xKtVleFdkKy1F4E2LVtKAwNV9g7TXZxA5nRMz6k886+kd0d8ORij23s
         T8iw==
X-Forwarded-Encrypted: i=1; AJvYcCV0i9eKlVL/BevCoXqaCxdYPAAkoMkLTlbbPK3QFr8TYrFNcb5iLlp3vtx0M35NBMhBUow2GuPV8A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEW98Apw6kDFcrcbXi5Z3uZ//unIAsJE1i4LT4CIgT9KysQK8k
	Rw4mrO2tlSJXf0KCqUb8T8veKdJi5vJtkz7lm/fhhXV7dXb5aslvKnRnwvbTE9JfrUpk5/HrIe7
	Wis46n9mTZ9k3q+YodivRWgCf79tvOy78ZIyqYHcJ5g==
X-Gm-Gg: AY/fxX66d6IDKFz1FT1Vbzbb4PWoJjRiHUXMIQ0IiMZgrxU4kSamjYVEU9U/564dfTE
	RbhTxe3Lwp0hr+YG0l0yEMPdHV4kLnQWxUHs1scRM8maoKQPsXc4RpoR2q9a9idrdyTjI2xfYSO
	cSmGMQWkr4/WPrGwIpK+t38PTZiOeT9VK427OkWVdxqPXdTUc4UE317OE+TTOCKgmPLfVIjMMTj
	p4CS2bfoFt4ysitEEnRuLz80TawNfzyBxPbM6lMioot4rT2BrZq6nZi06irI5P3Oq/fUUCR
X-Google-Smtp-Source: AGHT+IHOHJa1rIAxXbMzW4zEWFmr33Ofp/FpDXTQqv4yaLnanifD4NUeSgvLpZ8+XrTycGYU90NmEmazd96MgDFvFss=
X-Received: by 2002:a05:7022:238b:b0:119:e56b:46ba with SMTP id
 a92af1059eb24-121f8b45a84mr3692691c88.4.1767904662915; Thu, 08 Jan 2026
 12:37:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com> <20251223003522.3055912-8-joannelkoong@gmail.com>
In-Reply-To: <20251223003522.3055912-8-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 8 Jan 2026 12:37:31 -0800
X-Gm-Features: AQt7F2rSwTj_koiC9i_IPU-zGvJv4eiPmnNwJINBC-18brRzfkxnev60VQ5XRys
Message-ID: <CADUfDZqOsoBGAfkyj1BO2MqyjMxVnYxfim-szAXNsGwW29XrYA@mail.gmail.com>
Subject: Re: [PATCH v3 07/25] io_uring/kbuf: add recycling for kernel managed
 buffer rings
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Add an interface for buffers to be recycled back into a kernel-managed
> buffer ring.
>
> This is a preparatory patch for fuse over io-uring.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/cmd.h | 13 +++++++++++
>  io_uring/kbuf.c              | 42 ++++++++++++++++++++++++++++++++++++
>  io_uring/kbuf.h              |  3 +++
>  io_uring/uring_cmd.c         | 11 ++++++++++
>  4 files changed, 69 insertions(+)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 424f071f42e5..7169a2a9a744 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -88,6 +88,11 @@ int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *iou=
cmd, unsigned buf_group,
>                               unsigned issue_flags, struct io_buffer_list=
 **bl);
>  int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned bu=
f_group,
>                                 unsigned issue_flags);
> +
> +int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
> +                                 unsigned int buf_group, u64 addr,
> +                                 unsigned int len, unsigned int bid,
> +                                 unsigned int issue_flags);
>  #else
>  static inline int
>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> @@ -143,6 +148,14 @@ static inline int io_uring_cmd_buf_ring_unpin(struct=
 io_uring_cmd *ioucmd,
>  {
>         return -EOPNOTSUPP;
>  }
> +static inline int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd=
,
> +                                               unsigned int buf_group,
> +                                               u64 addr, unsigned int le=
n,
> +                                               unsigned int bid,
> +                                               unsigned int issue_flags)
> +{
> +       return -EOPNOTSUPP;
> +}
>  #endif
>
>  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req=
 tw_req)
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 03e05bab023a..f12d000b71c5 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -101,6 +101,48 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
>         req->kbuf =3D NULL;
>  }
>
> +int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr,
> +                    unsigned int len, unsigned int bid,
> +                    unsigned int issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D req->ctx;
> +       struct io_uring_buf_ring *br;
> +       struct io_uring_buf *buf;
> +       struct io_buffer_list *bl;
> +       int ret =3D -EINVAL;
> +
> +       if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
> +               return ret;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       bl =3D io_buffer_get_list(ctx, bgid);
> +
> +       if (WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
> +           WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
> +               goto done;
> +
> +       br =3D bl->buf_ring;
> +
> +       if (WARN_ON_ONCE((br->tail - bl->head) >=3D bl->nr_entries))
> +               goto done;
> +
> +       buf =3D &br->bufs[(br->tail) & bl->mask];
> +
> +       buf->addr =3D addr;
> +       buf->len =3D len;
> +       buf->bid =3D bid;
> +
> +       req->flags &=3D ~REQ_F_BUFFER_RING;
> +
> +       br->tail++;
> +       ret =3D 0;
> +
> +done:
> +       io_ring_submit_unlock(ctx, issue_flags);
> +       return ret;
> +}
> +
>  bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
>  {
>         struct io_ring_ctx *ctx =3D req->ctx;
> diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> index c4368f35cf11..4d8b7491628e 100644
> --- a/io_uring/kbuf.h
> +++ b/io_uring/kbuf.h
> @@ -146,4 +146,7 @@ int io_kbuf_ring_pin(struct io_kiocb *req, unsigned b=
uf_group,
>                      unsigned issue_flags, struct io_buffer_list **bl);
>  int io_kbuf_ring_unpin(struct io_kiocb *req, unsigned buf_group,
>                        unsigned issue_flags);
> +int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr,
> +                    unsigned int len, unsigned int bid,
> +                    unsigned int issue_flags);
>  #endif
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 8ac79ead4158..b6b675010bfd 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -416,3 +416,14 @@ int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd =
*ioucmd, unsigned buf_group,
>         return io_kbuf_ring_unpin(req, buf_group, issue_flags);
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_buf_ring_unpin);
> +
> +int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *ioucmd,
> +                                 unsigned int buf_group, u64 addr,
> +                                 unsigned int len, unsigned int bid,
> +                                 unsigned int issue_flags)
> +{
> +       struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> +
> +       return io_kmbuf_recycle(req, buf_group, addr, len, bid, issue_fla=
gs);

Total nit, but is there a reason for the inconsistency between
"kmbuffer" and "kmbuf"? I would prefer to use a single name for the
concept.

Best,
Caleb

> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_kmbuffer_recycle);
> --
> 2.47.3
>

