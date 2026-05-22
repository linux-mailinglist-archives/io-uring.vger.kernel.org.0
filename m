Return-Path: <io-uring+bounces-13480-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EEHiJlaGEGqEYwYAu9opvQ
	(envelope-from <io-uring+bounces-13480-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 18:37:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 96F7D5B7A5F
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 18:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 78CCA3004693
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 16:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB8734DCE3;
	Fri, 22 May 2026 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RNuzC3fD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9C234388F
	for <io-uring@vger.kernel.org>; Fri, 22 May 2026 16:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779467015; cv=pass; b=VcRRPZzMgRG8gbIVMk8hXHvpU4Ha8J/2wNXfdZd1hRmhaXqWsBOkLccmtFQYNKloCjKJ3VAMYKvFSuwhBpp2M0uWRqho2p7nxLhqZI2UygHcAJweWMjXK0CRqP/0gbT/uya2PB2FWrZuGZH28u475aDzYXL8yrwyfgp8G/cGXiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779467015; c=relaxed/simple;
	bh=MUF90qCu9GXdIph+CV86DU+ja1PcIQ5RH/e7jaf7J60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GICYdkvIduwgfZbkIUsttBw8WiTIzGDVdgNWPijHvX2sqtKN4lYx0j1XoTY/ZAcXg6L6276R88KdTGfgQ52S+BCi5xKIasfWxyvjo2QOVXJm8eVfBMYFWDAD2wOD2VJbBKE5f/HGIIpPGNx9dfPm4AzlI+U6szCIvs5gC/Wc+/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RNuzC3fD; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43eb05b1875so4207807f8f.3
        for <io-uring@vger.kernel.org>; Fri, 22 May 2026 09:23:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779467012; cv=none;
        d=google.com; s=arc-20240605;
        b=WIIwfsE5zV1xFd+QLwX1WahpTTtmH0vfekdH9IgdSF+bGQ+z9GTqDxSp74XbIrwLiX
         ikSAev5lmfL/yn1O0nkPMbKSgpsyxQ20B5hGD5/6pgid3a+dtMPFjpw0IaHbFYVRDy7g
         +BINsw1cJwhjZ6MFQ0o04wlcZHOjYUnuwaouvGb7aeB+CFDm6/7GZaRVBAkkvhJnnDLZ
         fFUrZlGfAyF1Zke62QXXy4H5BquySPr5D+hqKfCz+jJPo6ODR4PhmK24eqrvMK9vDHGi
         ZiJaiaG60azRYgQWZ7MRjMtG+HvfFDXYTXQLSewSBSb/WD2ep2MpatoBqN0RlPMaRhHZ
         ZViw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b/jscbBrwj1twIqme363v5OVn72yRLSZli60I+/FDRA=;
        fh=byydpFfk5dTt9IOuTXKEQNA2ileepK88T/zicoI+wio=;
        b=jsLmUJFbfoFuBH48c0xLxY0FDgrMtVlc6iHqbcXMMN0/BJwfNdFIwYNZmai+UPlpFA
         clOWdhkkM/gJy52DJb9hfEnq+SR7HNu1t3MAwrFW1xa4QCx3gRCjpVMoMhd6qzZIUuIQ
         EFfhsMl2JqC9Nr6xdgh7X5iHKU/eP0LF63BfVpBSm96ZPD0+QvxjxwyTNAznmU5vbvPB
         T/sTeHOKOBoQtBfl2VYt4VUpy18/uWM/FERSogkTQ9UlSeyI6YM8XgVPgWwyfbOnH9tj
         Uhav/SWe33UIXtHyVNaAsfLPDZp+mXYy0dKAHIpyQ1NUJFyAvTc+enLJLt9cIuLHTe+C
         TY2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779467012; x=1780071812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/jscbBrwj1twIqme363v5OVn72yRLSZli60I+/FDRA=;
        b=RNuzC3fDBCIp0BU6stv693gU8plVWNgSHuukUzv7jkJ9NUiPVfFFfXgu93YRS7B9jD
         LDug5qAmJIcWLCUxhkRHKHN1HciXcF4gO+lkzgeYpwk1fkDCpQMiOANh4U9TxJ5qJCoy
         vgx9CU/bnLStZKwU8idsRYi3M8BYz9XhvRjZNxYRjtkPsrGmfDRaro0FYLgP7jVCK9QJ
         UWtkyO8rjnYGGY59llhMdXmLBaBRYUXt0cYuaJ3/AV49xB+KZBpG5me3PTyBduzSiqwS
         goa3A8u1CbQb/Xvc2Cfi+nau0Fj3wyZUftchfZBCO6Ru+oOi2aRnmhOnmbzFIfHna8Uq
         eIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779467012; x=1780071812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b/jscbBrwj1twIqme363v5OVn72yRLSZli60I+/FDRA=;
        b=Yx+xyP3YvJhnemZJrBe71rAFyBswal/IIuw9TCiJ2J8fAr9OXwhJ5Qv9hhx9+OkAl/
         fbZ0GrhWA0pfU3rf378fdf9F4YKK64yrwBLIVdsVD/227zRTu/f+hm/YgLmRql/TY4v/
         lJJCp4ZqM5reDRujdtXOE9IciE23Dyo5P6n0mw5SCMi8sxidB2KSclFX4u4HvXD8N34U
         pwS2o66KeUeymlQbdI7sfxkB5i/Q1hlSV6zcLh3u6PC/cJD809A4YepH7tpqZoNudQ82
         zciBk3g6h5M2RmU6bnR53Ahz+SJY4ucodbYYpn/Uk8b87oMbznF6FFP6H7LIovyAkYJ9
         2R7A==
X-Gm-Message-State: AOJu0YxTrhCX3ExPTs2rH+nrbxcKp4r2wcoj1SXrYFwAOIgM61L+gyXF
	HAL+tAQTJjzalDlSbKXuhpS7T9UfpC82/e6GpdsQezRI+luujoSzdjouD9Sz011g3oaGIGuFiqn
	rGheO39+5ikIaZJh9o1l+eDOgzX1McPU=
X-Gm-Gg: Acq92OFPLklVvlvKp5mEGIZP/oHNwCENoubbTPTlGCqGVyR4hgSo/ZFS3tcIGc+YTrU
	cwZMxdDc4NwaCc3j4km4lhL1G05vH1jsxwJ6BL/I+Fo58fHbvElp0F18iqk15gLFARj0ELZSFN0
	aVh3jUpBd7Gvp3+q+ZGh5lzi8gvmE0SlnjwjtGxPhRlT82GtTQx5KHj7f64bCJ+7RwXAi/sAU2X
	y4mrpdSZAzaG/frxyi9wcGl4Wr2NJRhd37LaotCbD5cSi2QE1OTqmRTY3Hqt8dCZl74bCrXkVt1
	bYJSwotoLwATr7Yi2+IJaK17Cslv459HuNza8jOj8Q==
X-Received: by 2002:a05:6000:25fe:b0:43f:dbbf:6d93 with SMTP id
 ffacd0b85a97d-45eb38af972mr6867381f8f.27.1779467011852; Fri, 22 May 2026
 09:23:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+fCnZcHbkT=knNbOnAAmrbhx+8+WdcshLty84S_0UbYWVL-=A@mail.gmail.com>
 <20260520204303.558392-2-robert@fmmr.tech>
In-Reply-To: <20260520204303.558392-2-robert@fmmr.tech>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 22 May 2026 18:23:19 +0200
X-Gm-Features: AVHnY4K2totJufW8_E_OLLnCN0N5bYCrgQVUSY_4MS1xYzrSY29Ut9YqAqCco6A
Message-ID: <CA+fCnZeE6-8NFXjguJJKc_=UuF-Puw8BdtiFcUhOd23y9pAKOw@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: annotate remote tasks for kcoverage
To: Robert Femmer <robert@fmmr.tech>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13480-lists,io-uring=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andreyknvl@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,googlegroups.com:email,fmmr.tech:email]
X-Rspamd-Queue-Id: 96F7D5B7A5F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 20, 2026 at 10:44=E2=80=AFPM Robert Femmer <robert@fmmr.tech> w=
rote:
>
> Fuzzers use coverage information to guide generation of test cases
> towards new or interesting code paths. Syzkaller, specifically, makes
> use kcoverage (CONFIG_KCOV). Coverage information is not collected for
> kernel tasks unless annotated by kcov_remote_start and kcov_remote_stop.
> This patch annotates io-uring's work queue and sqpoll tasks.
>
> Signed-off-by: Robert Femmer <robert@fmmr.tech>
> ---
>  include/linux/io_uring_types.h |  4 ++++
>  io_uring/io-wq.c               |  4 ++++
>  io_uring/io_uring.c            |  3 +++
>  io_uring/io_uring.h            | 24 ++++++++++++++++++++++++
>  io_uring/sqpoll.c              |  4 ++++
>  5 files changed, 39 insertions(+)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 244392026c6d..b92b8e7169ea 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -504,6 +504,10 @@ struct io_ring_ctx {
>         struct io_mapped_region         ring_region;
>         /* used for optimised request parameter and wait argument passing=
  */
>         struct io_mapped_region         param_region;
> +
> +#ifdef CONFIG_KCOV
> +       u64                             kcov_handle;
> +#endif

Jann recently sent a patch that added kcov_common_handle_id, I think
you can base your code on it and use that helper struct here.

https://lore.kernel.org/all/20260430-kcov-refactor-common-handle-v1-1-23a0c=
7a0ba38@google.com/

>  };
>
>  /*
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index 8cc7b47d3089..16af75b1cfe0 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -639,6 +639,7 @@ static void io_worker_handle_work(struct io_wq_acct *=
acct,
>                 /* handle a whole dependent link */
>                 do {
>                         struct io_wq_work *next_hashed, *linked;
> +                       struct io_kiocb *req;
>                         unsigned int work_flags =3D atomic_read(&work->fl=
ags);
>                         unsigned int hash =3D __io_wq_is_hashed(work_flag=
s)
>                                 ? __io_get_work_hash(work_flags)
> @@ -649,7 +650,10 @@ static void io_worker_handle_work(struct io_wq_acct =
*acct,
>                         if (do_kill &&
>                             (work_flags & IO_WQ_WORK_UNBOUND))
>                                 atomic_or(IO_WQ_WORK_CANCEL, &work->flags=
);
> +                       req =3D container_of(work, struct io_kiocb, work)=
;
> +                       io_kcov_remote_start(req->ctx);

And also use kcov_remote_start_common() here.

>                         io_wq_submit_work(work);
> +                       io_kcov_remote_stop(req->ctx);
>                         io_assign_current_work(worker, NULL);
>
>                         linked =3D io_wq_free_work(work);
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 036145ee466c..f38b8eca6bbb 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -293,6 +293,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
>         INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
>         io_napi_init(ctx);
>         mutex_init(&ctx->mmap_lock);
> +#ifdef CONFIG_KCOV
> +       ctx->kcov_handle =3D current->kcov_handle;
> +#endif
>
>         return ctx;
>
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index e612a66ee80e..881d43bd529c 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -7,6 +7,7 @@
>  #include <linux/resume_user_mode.h>
>  #include <linux/poll.h>
>  #include <linux/io_uring_types.h>
> +#include <linux/kcov.h>
>  #include <uapi/linux/eventpoll.h>
>  #include "alloc_cache.h"
>  #include "io-wq.h"
> @@ -581,4 +582,27 @@ static inline bool io_has_work(struct io_ring_ctx *c=
tx)
>         return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
>                io_local_work_pending(ctx);
>  }
> +
> +#ifdef CONFIG_KCOV
> +static inline void io_kcov_remote_start(struct io_ring_ctx *ctx)
> +{
> +       if (ctx->kcov_handle)
> +               kcov_remote_start(ctx->kcov_handle);
> +}
> +
> +static inline void io_kcov_remote_stop(struct io_ring_ctx *ctx)
> +{
> +       if (ctx->kcov_handle)
> +               kcov_remote_stop();
> +}
> +#else
> +static inline void io_kcov_remote_start(struct io_ring_ctx *ctx)
> +{
> +}
> +
> +static inline void io_kcov_remote_stop(struct io_ring_ctx *ctx)
> +{
> +}
> +#endif
> +
>  #endif
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 46c12afec73e..8d2876e31acb 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -342,19 +342,23 @@ static int io_sq_thread(void *data)
>
>                 cap_entries =3D !list_is_singular(&sqd->ctx_list);
>                 list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +                       io_kcov_remote_start(ctx);
>                         int ret =3D __io_sq_thread(ctx, sqd, cap_entries,=
 &ist);
>
>                         if (!sqt_spin && (ret > 0 || !list_empty(&ctx->io=
poll_list)))
>                                 sqt_spin =3D true;
> +                       io_kcov_remote_stop(ctx);
>                 }
>                 if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
>                         sqt_spin =3D true;
>
>                 list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +                       io_kcov_remote_start(ctx);
>                         if (io_napi(ctx)) {
>                                 io_sq_start_worktime(&ist);
>                                 io_napi_sqpoll_busy_poll(ctx);
>                         }
> +                       io_kcov_remote_stop(ctx);
>                 }
>
>                 io_sq_update_worktime(sqd, &ist);
> --
> 2.54.0
>
> --
> You received this message because you are subscribed to the Google Groups=
 "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev=
/20260520204303.558392-2-robert%40fmmr.tech.

