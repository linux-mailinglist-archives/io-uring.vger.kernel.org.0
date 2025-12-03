Return-Path: <io-uring+bounces-10941-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD73CA1D0F
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 23:26:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1F52D3002480
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 22:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0B0B398FAA;
	Wed,  3 Dec 2025 22:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="SUAImkyS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45DF2DEA70
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 22:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764800757; cv=none; b=bJtCSP2zWVBIyRoKDHsGh2F1keDS37QOLFoBdaX50XUmB7SQVjJEABUDdyZRFLfb+ksen3Qt7N5p0fshdwzG/MhBzr1v0750ij7brluibC0x80vQQVxCmn8RS3PXgnElb7f++wVHoaxwfiO8XR55LXrYsMnS8yj2DG5mXNlol/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764800757; c=relaxed/simple;
	bh=YQXhVUe0L+tOA4fu/XHgr+fHu/T/dlj76fmdZd1du3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V+Si6lMVTi4lvDIXFgkXHMcWE+Z9dxSDku+hoYzp3mVEyTEuawpKwpZ3ZHO2s9XMT0VLVNwgBpuLBNbcinWKxiFaC8KKn2sV4ammYgUCQsGgI0wkDlBIFhmPqHzfpJCJqVWkzFr0f25QM+Cwj+TYmeO7MjpkG0uvFUGWQvKx0bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=SUAImkyS; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3436b2dbff6so22284a91.2
        for <io-uring@vger.kernel.org>; Wed, 03 Dec 2025 14:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764800755; x=1765405555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kDH7My4rx/In3/xcnH/dcDsYWgPdffGLcWo5ws0ruf4=;
        b=SUAImkySoXi+jOduWdlMH/JXyF+3+aauli459cvV4XM6/yKy+IXs1YRs3J6/k9puJk
         K7rViy8R3wq6FdA//HVTWMSzXqAd1DaB7UUdOY/5x4DhRnK8hatd/dEyNeYvE3FDvxpC
         zNWw3ov6AERiGhox7nzep0wYUgsmUVKc0T6gAk40z9VHsTKa6Kg3ia8OMNc9jDKA/+8h
         /AGAUpwBdCR5+VHNMkHSNtRuFuQn6x0yOGjCzNPrNu7lRcrXhFBK0ibSha9UYZE1kN96
         0i5i4BFLUxiIchdAfhPof+dUXOApj0cyF7PPs2Y1BuMVdQM84cfaD+7LY2N5Wl8vzVjV
         07Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764800755; x=1765405555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kDH7My4rx/In3/xcnH/dcDsYWgPdffGLcWo5ws0ruf4=;
        b=s8aPIcvRgOGD+j5FS7XQ2xLhrIWhT9DPmVZBb0rlrQ5/6WqvBOYE5zrMnwO13vmuP9
         41PHCGEdg96lLVhbeVGaN0OIIRknPipt6CC0TtqQT1qXezaBjwS0eJcG7VaAAWDqMo39
         T2S2t3GDBxSHsRQDeOosYhWjwz9tR4PyNYWaQa5Fu2UkB6OeHBEEU9riFqmRC5h7eAAw
         G5OjPTnZLXyoshNFRkVXz/WC9sxBoXkpvAFhAURgdf55c8v0U0kvoF7XXEOv2aAmrk3H
         7NhjnxUp4ZYWoHWKWfe3GVNbzejkwQG1mujhB+5KBKueIHjHA1epqCAU4Uts6o58H5nY
         1D+w==
X-Forwarded-Encrypted: i=1; AJvYcCWIsB9w6XCBOmSapEmW9azwxfgKBLLQHZWRrSXRImbH2x3KIwtL9kHj8a1uxlEg311FG2OVIQ3dbw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjH0X7x9z7fIEgHp8EQxv9Tnd6jN7zxoeLqyN7CPjB+AfKadfg
	lOtZ6g07C8LRrXNpaLQMIuwP6dIhxRZUOXUdptSUIiWxIDsivRukrFgFg5ZYJ5FMB5J03jCTyoa
	Uos3jRTzZc/qUQbX9xrW3HYwaA6F2QpMOBnr6MFSG6g==
X-Gm-Gg: ASbGncuDFC0jaZQj7h7hsFFXDoya4ZsNXm8q06CGNhhLN2hXZ2Thu7LdRRLMrQzSPRR
	hfeiEokoiyitNZPZYdJUFxIT9DZ1sH7KT2aR2hur4xd/03TDye9WkXqA3jn4SlFQr0uZceCZjmB
	TAxXziN7bFyeKWcxQhRospoUV6GOUbeEKKnxf1Uzai2o9l7QTCXJkGNIbZr9x5ENBaso5IGaPD3
	Yro9U1aHBV97vLQZZs0reqRPKw1Dg==
X-Google-Smtp-Source: AGHT+IFTZg7E037XkY4/Z59jB0U1cVulY8GObWp+OgzRutX1bjO2xkkoVYL9OHI6fkvcxe9nFGXyWWJksuEl3/6SHR0=
X-Received: by 2002:a05:7022:405:b0:119:e56a:4fff with SMTP id
 a92af1059eb24-11df25c1a60mr2166637c88.4.1764800754757; Wed, 03 Dec 2025
 14:25:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com> <20251203003526.2889477-15-joannelkoong@gmail.com>
In-Reply-To: <20251203003526.2889477-15-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 3 Dec 2025 14:25:43 -0800
X-Gm-Features: AWmQ_bktfVnfFBluf136XJ2r6CNl6nOGDxx5_Pf26zEJoTMJf486lYme7ljRMAA
Message-ID: <CADUfDZrtOdabnxd5x70gN5ZLWj=nQNhwezTfs_0XN9kuDAVsQg@mail.gmail.com>
Subject: Re: [PATCH v1 14/30] io_uring: add release callback for ring death
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> Allow registering a release callback on a ring context that will be
> called when the ring is about to be destroyed.
>
> This is a preparatory patch for fuse. Fuse will be pinning buffers and
> registering bvecs, which requires cleanup whenever a server
> disconnects. It needs to know if the ring is alive when the server has
> disconnected, to avoid double-freeing or accessing invalid memory.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring.h       |  9 +++++++++
>  include/linux/io_uring_types.h |  2 ++
>  io_uring/io_uring.c            | 15 +++++++++++++++
>  3 files changed, 26 insertions(+)
>
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 85fe4e6b275c..327fd8ac6e42 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -2,6 +2,7 @@
>  #ifndef _LINUX_IO_URING_H
>  #define _LINUX_IO_URING_H
>
> +#include <linux/io_uring_types.h>
>  #include <linux/sched.h>
>  #include <linux/xarray.h>
>  #include <uapi/linux/io_uring.h>
> @@ -28,6 +29,9 @@ static inline void io_uring_free(struct task_struct *ts=
k)
>         if (tsk->io_uring)
>                 __io_uring_free(tsk);
>  }
> +void io_uring_set_release_callback(struct io_ring_ctx *ctx,
> +                                  void (*release)(void *), void *priv,
> +                                  unsigned int issue_flags);
>  #else
>  static inline void io_uring_task_cancel(void)
>  {
> @@ -46,6 +50,11 @@ static inline bool io_is_uring_fops(struct file *file)
>  {
>         return false;
>  }
> +static inline void
> +io_uring_set_release_callback(struct io_ring_ctx *ctx, void (*release)(v=
oid *),
> +                             void *priv, unsigned int issue_flags)
> +{
> +}
>  #endif
>
>  #endif
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index dcc95e73f12f..67c66658e3ec 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -441,6 +441,8 @@ struct io_ring_ctx {
>         struct work_struct              exit_work;
>         struct list_head                tctx_list;
>         struct completion               ref_comp;
> +       void                            (*release)(void *);
> +       void                            *priv;
>
>         /* io-wq management, e.g. thread count */
>         u32                             iowq_limits[2];
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 1e58fc1d5667..04ffcfa6f2d6 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2952,6 +2952,19 @@ static __poll_t io_uring_poll(struct file *file, p=
oll_table *wait)
>         return mask;
>  }
>
> +void io_uring_set_release_callback(struct io_ring_ctx *ctx,
> +                                  void (*release)(void *), void *priv,
> +                                  unsigned int issue_flags)
> +{
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       ctx->release =3D release;
> +       ctx->priv =3D priv;

Looks like this doesn't support the registration of multiple release
callbacks. Should there be a WARN_ON() to that effect?

Best,
Caleb

> +
> +       io_ring_submit_unlock(ctx, issue_flags);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_set_release_callback);
> +
>  struct io_tctx_exit {
>         struct callback_head            task_work;
>         struct completion               completion;
> @@ -3099,6 +3112,8 @@ static int io_uring_release(struct inode *inode, st=
ruct file *file)
>         struct io_ring_ctx *ctx =3D file->private_data;
>
>         file->private_data =3D NULL;
> +       if (ctx->release)
> +               ctx->release(ctx->priv);
>         io_ring_ctx_wait_and_kill(ctx);
>         return 0;
>  }
> --
> 2.47.3
>

