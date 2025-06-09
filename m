Return-Path: <io-uring+bounces-8288-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9E5AD28F9
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 23:54:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1394C16BDCA
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 21:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091BE21D587;
	Mon,  9 Jun 2025 21:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="XSD6dqyJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05CB21CC41
	for <io-uring@vger.kernel.org>; Mon,  9 Jun 2025 21:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749506059; cv=none; b=X6+DqxVQuVwz/ArpuySzvxl6cuy+Ymnc5Vgdl7hHR0a/RA2he5oTHd3kjkG95V2TNRczabsMn/8HHczjxgi/6hKP0NyxNKsXzvVYRfDw6g6KLQaF4/pCOYc9oARappkiP7mxgw87fOSyJg3xkr7ZfqUr5BQQ0QCU5TrGqkc+/88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749506059; c=relaxed/simple;
	bh=FfHanvez5PPeqVSd+Z+RzhrQHes3KAG5qLPf6D5DTCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iDLfhjozwOVRcjXjD5pT2wYc3T8V6ZvCP6MqfMMKI8FFd+eOSWPLNwOi+KNS9VQgukOuHURBRt4L5wtjn0qze68ifLxKGCLlNzc7lhKEJxmp4T3/gv5FKvFx3k8Y4E+sxzf64dLr2zHa5WPjHCumhHq6xPeVUU0QwMh6WEsN+rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=XSD6dqyJ; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-31373948e08so342414a91.0
        for <io-uring@vger.kernel.org>; Mon, 09 Jun 2025 14:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749506057; x=1750110857; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o4P8a+pFwxCRct16yZiX5gDLBA0VULdfPATURCPL9ac=;
        b=XSD6dqyJW/yuPBYZX0RIrO6LGPMqquZqYQoyqdzVM8cTrImnrSFvCGrc0bJt4+X3RT
         KnpGEPMwOeiLipFNhEiqlIsULPVaLHfTxIloI1sD98MILdDrwPWD8P/dT0vKnZlvlbBS
         szsZ/g465o5oj4Vvlb9ZZffYqG2N+eSvGJ9Kyw/NdYNIK+b9+zS0cCPcQLh4mDko5n/B
         07AnyB4BdR2nAyHBBYGqpA78lLt3KPIaqqXdeR4hcdu7h0zEJa7vZBm4zAaR6eMEKQ0B
         +i7KJWmTD3ipaz0K1KHm5++hHfHpziXK2XdIFr9nc357Z93j8KteE+u3334zeZ2rUW+H
         sbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749506057; x=1750110857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o4P8a+pFwxCRct16yZiX5gDLBA0VULdfPATURCPL9ac=;
        b=nwu1wayJBnLl/yz52H8kkKT+V9ISn5lUogt6cl+ePDk2APkG9aTkJsn2654rT2fWV2
         7rmI2EUvDrYHPB77IEIwZWwwc9mo/W7/XdlUm8LcBc6A374FWedA1oIYYs3Xc+3kuXwC
         uN8jDQ18fCklVU10MG715gCj0w7llQ5F6qtN0ddOAkNnVr/Kqt2nyFr9OQvJoXv/4j2d
         rlWKFltODeVW5anDOwQWTABcfkHcYlW11YA8JzhmEKXwhBTLLb1S8Xe8VQ+Ise0edPfJ
         f4vWPHtjVEwcZmeVVLU5u7aPYM4ww6/DeQf7zaCKSV00ACSLcJtroErTiGfJ9J8kMcfH
         91rw==
X-Gm-Message-State: AOJu0Yy30XKB0tXKip6EDLTNirWlA/kastIr9kSPP4iWn6G3eMg7A9R1
	89wBobK/8kk0bNlXiPQaWNhzpvzQSLZVm7o1w8PcGFKjKzO+i5kcrjZ0GNfhbQVbyXKdOD7CQPC
	z/QmsfjoOKuCdsR2z+N+fnmrS70xG7B1gK8XB8OOhCFFHligeGiHZ
X-Gm-Gg: ASbGncvdCnEd74oQtfb051r5ZjVT1rXC3vrEgLfPxfpA/gtGOQvaRApn2T3y478PNMv
	5G5Q++OzDny0yWfTdV05bKypEEAGzrHasEBmYLB6FkAMChVZ/HCHPstTRYkx0AIQ7+Z48iio/xs
	LNTo72ecCxlBjFT+uGUk4EJVYP5sP0njOBGbH9YsEazIU=
X-Google-Smtp-Source: AGHT+IFSxFOUItZDpqUWvSezmPzMNwzxjcxKm5BcmXzuqWNDq3WyHa10H+Die2hyA29ONB2LzsaYr736zyOjDsv9Gn0=
X-Received: by 2002:a17:90b:3a87:b0:312:db8:dbd3 with SMTP id
 98e67ed59e1d1-3134e422457mr6630561a91.6.1749506056929; Mon, 09 Jun 2025
 14:54:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250609173904.62854-1-axboe@kernel.dk> <20250609173904.62854-3-axboe@kernel.dk>
In-Reply-To: <20250609173904.62854-3-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 9 Jun 2025 14:54:05 -0700
X-Gm-Features: AX0GCFsCRD8vJ5oiS-6P5jY_dU-fT2ccX-75Cw4SLWQfGpOIpIfgqXsCoI73rJA
Message-ID: <CADUfDZp=yhbfDcHJxDsP9gbBJ90sE0cxqsM8rRueU5qsYmN=ww@mail.gmail.com>
Subject: Re: [PATCH 2/4] io_uring: add struct io_cold_def->sqe_copy() method
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 9, 2025 at 10:39=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Will be called by the core of io_uring, if inline issue is not going
> to be tried for a request. Opcodes can define this handler to defer
> copying of SQE data that should remain stable.
>
> Only called if IO_URING_F_INLINE is set. If it isn't set, then there's a
> bug in the core handling of this, and -EFAULT will be returned instead
> to terminate the request. This will trigger a WARN_ON_ONCE(). Don't
> expect this to ever trigger, and down the line this can be removed.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |  3 +++
>  io_uring/io_uring.c            | 27 +++++++++++++++++++++++++--
>  io_uring/opdef.h               |  1 +
>  3 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 054c43c02c96..a0331ab80b2d 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -504,6 +504,7 @@ enum {
>         REQ_F_BUF_NODE_BIT,
>         REQ_F_HAS_METADATA_BIT,
>         REQ_F_IMPORT_BUFFER_BIT,
> +       REQ_F_SQE_COPY_BIT,

naming nit: I would interpret "copy" as "needs copy", which is the
opposite of what the bit represents. How about changing "COPY" to
"COPIED"?

>
>         /* not a real bit, just to check we're not overflowing the space =
*/
>         __REQ_F_LAST_BIT,
> @@ -593,6 +594,8 @@ enum {
>          * For SEND_ZC, whether to import buffers (i.e. the first issue).
>          */
>         REQ_F_IMPORT_BUFFER     =3D IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
> +       /* ->sqe_copy() has been called, if necessary */
> +       REQ_F_SQE_COPY          =3D IO_REQ_FLAG(REQ_F_SQE_COPY_BIT),
>  };
>
>  typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw)=
;
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 0f9f6a173e66..3768d426c2ad 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1935,14 +1935,34 @@ struct file *io_file_get_normal(struct io_kiocb *=
req, int fd)
>         return file;
>  }
>
> -static void io_queue_async(struct io_kiocb *req, int ret)
> +static int io_req_sqe_copy(struct io_kiocb *req, unsigned int issue_flag=
s)
> +{
> +       const struct io_cold_def *def =3D &io_cold_defs[req->opcode];
> +
> +       if (req->flags & REQ_F_SQE_COPY)
> +               return 0;
> +       req->flags |=3D REQ_F_SQE_COPY;
> +       if (!def->sqe_copy)
> +               return 0;
> +       if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_INLINE)))
> +               return -EFAULT;
> +       def->sqe_copy(req);
> +       return 0;
> +}
> +
> +static void io_queue_async(struct io_kiocb *req, unsigned int issue_flag=
s, int ret)
>         __must_hold(&req->ctx->uring_lock)
>  {
>         if (ret !=3D -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
> +fail:
>                 io_req_defer_failed(req, ret);
>                 return;
>         }
>
> +       ret =3D io_req_sqe_copy(req, issue_flags);
> +       if (unlikely(ret))
> +               goto fail;
> +
>         switch (io_arm_poll_handler(req, 0)) {
>         case IO_APOLL_READY:
>                 io_kbuf_recycle(req, 0);
> @@ -1971,7 +1991,7 @@ static inline void io_queue_sqe(struct io_kiocb *re=
q, unsigned int extra_flags)
>          * doesn't support non-blocking read/write attempts
>          */
>         if (unlikely(ret))
> -               io_queue_async(req, ret);
> +               io_queue_async(req, issue_flags, ret);
>  }
>
>  static void io_queue_sqe_fallback(struct io_kiocb *req)
> @@ -1986,6 +2006,8 @@ static void io_queue_sqe_fallback(struct io_kiocb *=
req)
>                 req->flags |=3D REQ_F_LINK;
>                 io_req_defer_failed(req, req->cqe.res);
>         } else {
> +               /* can't fail with IO_URING_F_INLINE */
> +               io_req_sqe_copy(req, IO_URING_F_INLINE);

I think this is currently correct. I would mildly prefer for the
callers to explicitly pass IO_URING_F_INLINE to make it harder for
non-inline callers to be added in the future. But maybe it's not worth
the effort to pass issue_flags through multiple layers of function
calls.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>



>                 if (unlikely(req->ctx->drain_active))
>                         io_drain_req(req);
>                 else
> @@ -2197,6 +2219,7 @@ static inline int io_submit_sqe(struct io_ring_ctx =
*ctx, struct io_kiocb *req,
>          */
>         if (unlikely(link->head)) {
>                 trace_io_uring_link(req, link->last);
> +               io_req_sqe_copy(req, IO_URING_F_INLINE);
>                 link->last->link =3D req;
>                 link->last =3D req;
>
> diff --git a/io_uring/opdef.h b/io_uring/opdef.h
> index 719a52104abe..c2f0907ed78c 100644
> --- a/io_uring/opdef.h
> +++ b/io_uring/opdef.h
> @@ -38,6 +38,7 @@ struct io_issue_def {
>  struct io_cold_def {
>         const char              *name;
>
> +       void (*sqe_copy)(struct io_kiocb *);
>         void (*cleanup)(struct io_kiocb *);
>         void (*fail)(struct io_kiocb *);
>  };
> --
> 2.49.0
>

