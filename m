Return-Path: <io-uring+bounces-11042-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69361CBD82C
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 12:33:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 18EA33028F69
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 11:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E71B32FA3F;
	Mon, 15 Dec 2025 11:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C8pCe/yx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAF72253B0
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 11:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765798314; cv=none; b=B+RhrxjHMAPGL516/VS+woa4T05thFf9y+ODu5Kc3Xpb5A2qWaAtbg/1CUmpd3RBE8S6bj8r3V2LpZGXWB+/HXkqXvuqTIVgDSeXeK2Ao/2OAF/jFVWL5lqCpIe0tDf+ioEWixhFnT991MhOX9IPZ1fS8bnWd8is4y/UNkBbOW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765798314; c=relaxed/simple;
	bh=m08uhxIKpPE1m6+4nO3Kb3BKor+YBUyHe0FR26n7EME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DrJTXOtrjdC2w31EM7OJU0zCI7+MRqa31PJWNv++gHC/NagqdpXAXPxqIAVO+osKNg7XH2XOhTkMI5921Er+cEotQFifVXQmFM76EAxp1s2iHtFBZgIA3KeP/DF1rUdgK4iCzxpOhoP5yDgs6VAlB6V9JStMsdp/K6ErG8k/kZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C8pCe/yx; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ed75832448so45652031cf.2
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 03:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765798310; x=1766403110; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JspIDcQtuSSpLRk0E3VCGq2yOtkR03IsjW1iJovlfKw=;
        b=C8pCe/yxuAuoLkazufJfsjVU3tc62qYzfqvdz3IzCiBpOxI2+575ThlxvwIVMNa67x
         jIYR5llyeqad81t1zRK9/eNvBoChYm18X5ZSdUnNHN62uhGZuqJsra/fIiyNzs6cdXd8
         pmHJk0zTnl1Zqyg8l8j2szFaF8M/89lUoGOWh10vVHs7Dhl5R5SOJ0g0IbeSFl92dVUH
         DlGJWbbJS1dFcxP+GXyKqPe6H6Hod1fWnrK/RV5O3ZYm6R/rC3CCf4IvEJ6XL9nt2idt
         XPFf7FfX1mZ1dKRVQva8hAvpc4gbWcRLts8GmeVFZdfzg3YqYtsoUS27IAco5hTRXhW6
         Wv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765798310; x=1766403110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JspIDcQtuSSpLRk0E3VCGq2yOtkR03IsjW1iJovlfKw=;
        b=HfxmB88W++LFFvJXyW+rFmhXU/sjahxdlKQ3Z8fGw3XT2mnpzxA4sm5IkcFKVy+fP3
         YnW49KZmnB1P3DFv/PHkEeat7SnYlc849U4WE5yg3PJ/q5Rudvy1F2IZBw6ysrnLyJbk
         0PPHjVo0baYaCUoTGz2TCjbFRqy6vK48jkfnI8QuTVThdO78McYUV2ry3FxXCvYTrFJO
         IrR3CW8B2mIgs4ymdKBwovSwCWMtQIRH8ams4/qe3DMUH1N+XeDKZvkVB7AfBnAd7lLz
         Z5xy7r9V8qMhCLxKIpLoY6+/VhkeofouQ+EL2VtDGDOoOVOpArje9bvu8qFlwSYOJJJX
         VLLw==
X-Forwarded-Encrypted: i=1; AJvYcCWisV8NwcAQXWC5+RMIA7Ho+xMI5nRrm8MDi8tz6gJf7O6siD4StBu6m5/7HfExmlEUidnyn6tcSg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWLYSBcx3/7FGSjYukeD/164IyNuKa4q7cw2ehKZ1BBqZiLhgC
	9USE5JTasBn7gCIJ+9d0mzdwhIsaErM58NnT+gHRq7GQd1Vg2xvGPwOljk8BJAYseOiBv6LckpT
	ve3EnLzWyIMhe4+eBTNukmbM/fY0RJZs=
X-Gm-Gg: AY/fxX4nDD2PgHEG7tqeaF0VrO/46nIhQ90fZ1ADx6Kf2pxuieS+IfR+P3GowD4lYVk
	q3rMs2VwNMQoJxMbghzZT+e0uXqI2xxUSd1AoY+Pq5GHu/YN1VnOof0jyN+81pVNogtHNT1n4SO
	7CGMc4Ibg3JVvTfPi6DfUU5ubzOEm4eZMrSyl3G+NdVm92zRwWPdc1WgwXWKCPOodhus8EGtffD
	ULsJUaD0TD6uqYYFybCurcd3AfgvpGBMO8d0BxOAG9WW7XQ+knVaL+xlKD+FiRhuTxhYftMtmpK
	/VSED4LbCyXqE4B90p+EJw==
X-Google-Smtp-Source: AGHT+IGFMlqJbK58qieHdcBPLtcVOh+aNACR4dCEDfb1jR/NisGDerssU/IDT6Xl4i/dV+QvnodQA/7HszRvVAGSVLQ=
X-Received: by 2002:ac8:5702:0:b0:4ee:2721:9ebf with SMTP id
 d75a77b69052e-4f1d05dd175mr142152541cf.55.1765798310511; Mon, 15 Dec 2025
 03:31:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251202164121.3612929-1-csander@purestorage.com> <20251202164121.3612929-2-csander@purestorage.com>
In-Reply-To: <20251202164121.3612929-2-csander@purestorage.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 15 Dec 2025 19:31:39 +0800
X-Gm-Features: AQt7F2oHUPGG8tifYk7n3XNtkifDBzUAktkR-Zm7nCd8aCUGKNkFvHEz15Om-3s
Message-ID: <CAJnrk1ZGCKdM_jK9QEbd25ikEQT7sCviaoqA6Rv_m1JjOTuEOw@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] io_uring: use release-acquire ordering for IORING_SETUP_R_DISABLED
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 12:41=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> io_uring_enter() and io_msg_ring() read ctx->flags and
> ctx->submitter_task without holding the ctx's uring_lock. This means
> they may race with the assignment to ctx->submitter_task and the
> clearing of IORING_SETUP_R_DISABLED from ctx->flags in
> io_register_enable_rings(). Ensure the correct ordering of the
> ctx->flags and ctx->submitter_task memory accesses by storing to
> ctx->flags using release ordering and loading it using acquire ordering.
>
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> Fixes: 7e84e1c7566a ("io_uring: allow disabling rings during the creation=
")

This LGTM. But should the fixes be commit 7cae596bc31f ("io_uring:
register single issuer task at creation")? AFAICT, that's the commit
that introduces the ctx->submitter_task assignment in
io_register_enable_rings() that causes the memory reordering issue
with the unlocked read in io_uring_add_tctx_node(). I don't see this
issue in 7e84e1c7566a.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

Thanks,
Joanne

> ---
>  io_uring/io_uring.c | 2 +-
>  io_uring/msg_ring.c | 4 ++--
>  io_uring/register.c | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 1e58fc1d5667..e32eb63e3cf2 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3244,11 +3244,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd,=
 u32, to_submit,
>                         goto out;
>         }
>
>         ctx =3D file->private_data;
>         ret =3D -EBADFD;
> -       if (unlikely(ctx->flags & IORING_SETUP_R_DISABLED))
> +       if (unlikely(smp_load_acquire(&ctx->flags) & IORING_SETUP_R_DISAB=
LED))
>                 goto out;
>
>         /*
>          * For SQ polling, the thread will do all submissions and complet=
ions.
>          * Just return the requested submit count, and wake the thread if
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index 7063ea7964e7..c48588e06bfb 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -123,11 +123,11 @@ static int __io_msg_ring_data(struct io_ring_ctx *t=
arget_ctx,
>
>         if (msg->src_fd || msg->flags & ~IORING_MSG_RING_FLAGS_PASS)
>                 return -EINVAL;
>         if (!(msg->flags & IORING_MSG_RING_FLAGS_PASS) && msg->dst_fd)
>                 return -EINVAL;
> -       if (target_ctx->flags & IORING_SETUP_R_DISABLED)
> +       if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLE=
D)
>                 return -EBADFD;
>
>         if (io_msg_need_remote(target_ctx))
>                 return io_msg_data_remote(target_ctx, msg);
>
> @@ -243,11 +243,11 @@ static int io_msg_send_fd(struct io_kiocb *req, uns=
igned int issue_flags)
>
>         if (msg->len)
>                 return -EINVAL;
>         if (target_ctx =3D=3D ctx)
>                 return -EINVAL;
> -       if (target_ctx->flags & IORING_SETUP_R_DISABLED)
> +       if (smp_load_acquire(&target_ctx->flags) & IORING_SETUP_R_DISABLE=
D)
>                 return -EBADFD;
>         if (!msg->src_file) {
>                 int ret =3D io_msg_grab_file(req, issue_flags);
>                 if (unlikely(ret))
>                         return ret;
> diff --git a/io_uring/register.c b/io_uring/register.c
> index 62d39b3ff317..9e473c244041 100644
> --- a/io_uring/register.c
> +++ b/io_uring/register.c
> @@ -191,11 +191,11 @@ static int io_register_enable_rings(struct io_ring_=
ctx *ctx)
>         }
>
>         if (ctx->restrictions.registered)
>                 ctx->restricted =3D 1;
>
> -       ctx->flags &=3D ~IORING_SETUP_R_DISABLED;
> +       smp_store_release(&ctx->flags, ctx->flags & ~IORING_SETUP_R_DISAB=
LED);
>         if (ctx->sq_data && wq_has_sleeper(&ctx->sq_data->wait))
>                 wake_up(&ctx->sq_data->wait);
>         return 0;
>  }
>
> --
> 2.45.2
>

