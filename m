Return-Path: <io-uring+bounces-13820-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id NBUhAje3OmoUEwgAu9opvQ
	(envelope-from <io-uring+bounces-13820-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 18:41:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D666B8CA5
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 18:41:26 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=google.com header.s=20251104 header.b=KN8zFDcJ;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13820-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13820-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4AF173043F85
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2026 16:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FE2318EC1;
	Tue, 23 Jun 2026 16:38:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC39313545
	for <io-uring@vger.kernel.org>; Tue, 23 Jun 2026 16:38:31 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782232712; cv=pass; b=pR/zaW45B3fpgpVdsYa3mhgULEpT5kMcqDTlbHoN0KZnpaiYJH6DG6+xe/xyVW2IQHmSvTTf3Fwezwtb/XelC0iq0DMVjh1n6vOJaHapMNPtEy/Q7x0t59KWg9cC0NrB1vfMQ128/q37bN1zP13tdIPECVTchRsyWQbsAjGmJi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782232712; c=relaxed/simple;
	bh=OK1freLKBktM/Zcgmyinc+e5qWYDzYfIzkDw90rFrFs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VjCpJ5iUOAjHSaoXjQYFZIQV5v0+kkUJKlXogXoDCvrqfYC5/F3lX49bykuvLCbuOVW65MM2a7cdcekVBTON2fHgKA0L4J5PRKCH+m8AFNqsKEh9nxw85iNm+Ai27qu6yXHOmGOLkZ2SUydpF1XxjlqXw48zW8MXH67YUiqvr9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KN8zFDcJ; arc=pass smtp.client-ip=209.85.208.44
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-695469b574eso11774a12.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2026 09:38:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782232710; cv=none;
        d=google.com; s=arc-20260327;
        b=YgiuvXFK7J52SH06ki0vlvHPYqpMSjfX5g6Mb+14tCsOY1wE8L+5mMB+AJbmT3+Pua
         r0noF9fi+kVwkXZJC5g+xod7cRPtNeVCcAVRYzGNIA+PYsw92N9qTtALkqsjz8g+u55a
         nvxQpgXBQSP1dSeeXtL4yRU/xkk+ZnnWNIdB6lj/s5mbcCY8Q1ld8wPHkcz5Ru8LNkwn
         c3EX3gbAdH/hgsiKm5Bvwn7a1twy3G5UBt/yJ94L5JCqlNSP+mh+UTM/6EMKYZdgmEIP
         FVaEh2t6gmHKgwdEne8ZBSKmAIPoQoiOtV69d2y9pd2ymWDnRbJHtjRmNWchsUCfEtK2
         TdKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=enIathbEym9k1SCwrWqYqy/XIaiTBhqqzAk5M/jJuXE=;
        fh=cxiKEPG9SyFMB3knvMuAnpRT8OyEN5XCoxtm8gNDVAI=;
        b=EvSf+ebzASl1Qt1gKxs7anBgfRiHjZNKUdth8Ykt8E8zW3lyN3eRXy7Sneg8oAgHv6
         wh7cqIMwZLWdfQkJ9MFJ+DDajxkwD9yiOHt/TZYvt55QMf+J0weIIz/t3pKOq9rhXa3h
         vol43ik7WbaHTdN7GsqNgodby8IES/dsDEMgem1pTbxXVzqBXBYEK+PJMIZJHjt0aBhd
         R3Hhlvb6rczd8keYxx7R8FuAUhxG4TyQ2LfmdicDHVkko1Ga/usGutFY0zYygP5iU3RM
         1qFsslEFTopMihq9ASC2rQpkHt80JoPhuKaFh+kAnNsR0CqPv6HxkqrSc4+byb1uzHGa
         HX0w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782232710; x=1782837510; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=enIathbEym9k1SCwrWqYqy/XIaiTBhqqzAk5M/jJuXE=;
        b=KN8zFDcJXXxEu/rviKstGhuYzmQ6rTT7YTuzlPGi/DdMBVVK20QWg7imwLTCtGkI+y
         Vr9WTK1kKFTQEF6/pfJYjI1AZDN9iudZt5d6UxPxo1hpaKhlMOsDuhtu5F8fz5ELzZCD
         DpbnLKy97r/pBEBGKY+CpL0Pe/fiWSfnQxERYeYpEWlTI4xOgY17uftWgJdFwUOa4zRi
         yEE0BsELJTl2WW7SPQZyDAr8qBWJfQnMC511Spru6FJeZnBAyLdJHzMJZrjaz2cJVRiR
         J7JN9JCsNSp/VUaDpA7ZbFTjN8nKfSjvHchC/NEvoEv+yhgIuF92uBM54rR0XL6UUk9R
         gH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782232710; x=1782837510;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=enIathbEym9k1SCwrWqYqy/XIaiTBhqqzAk5M/jJuXE=;
        b=HfYLbe1eHTVBPXyeQZfX5VQj5MXiR4i1xCruBeDHCUHEudkMVRUb/sIsi0A0TmjkRI
         Dwg1kQCi2dac7BQQ92oUGm/Z61/w6+nsF9V8uSDKF5aczLzOBLAgZXFSVlAsDZhPpD0L
         q576u1JDjCbRhahulIkKw/kaj6JtXZMJEDfddDkp5yx3CbrU+NG9yAARoWAjygwTRZH1
         0o5EYXvCnFoy2dtHOriROyOVXcPFlfqIizCbsja66d1H4swGx4y1DMsvm2ETtNHTkUSb
         s+XChiaOU1W14zMy4p8BWd+pEuQ84jQsu8VXMZPnh+jDJWfokWNyC4G1B2AsUtjnj0KS
         3+pg==
X-Gm-Message-State: AOJu0YzfgQ5SPaIu9We8HmdAYmJl1LZW6TuAgA4KE7O/BToxA+k4prFk
	Q0Ad4f3zcz2229kJZ3dzu5iXqkNu5h8Bdt+YBEQmfEkQWi6xDouRCiNw5DBD06e6KUwR2dFw1z4
	zp1tE3PLXb0owR/V31X1q1Wjxm9ca6xSnB7pxVZHx
X-Gm-Gg: AfdE7cm9jLfBRcFKMcEJnKTj6co1XtYbtCLxx+CtrQTDSNH40hMM33IOVlCH10hFfI5
	BkqgDJs1B1ITfLHum1N94h5q2h6cvK93QyD/qiVpOjgQHh9S+w+R/1n4DvNx2HJ/B2p92SdzZaC
	nxZPl5hvn6G+jC5Dpe/9+ML54zYJAm3MhK5/+UmfqGr0kKBzqahKfGYBUPqbrP5+ILGP/nvZF8W
	bxeS7FE93Tawh4UrwXUxac/ZBEyM61LLJ0wm1VbHEJ8OLaHqvR5jaCeHZ1CFNKPBY9UDmijQjMH
	cD0TiTQuv+QnsTpG4ursHDhRyPz69RdVBF4/IeL5406vc1AgBKrarlt6ag==
X-Received: by 2002:a05:6402:52d9:b0:691:6fb6:dab2 with SMTP id
 4fb4d7f45d1cf-697daf287d0mr80846a12.5.1782232709427; Tue, 23 Jun 2026
 09:38:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+fCnZeE6-8NFXjguJJKc_=UuF-Puw8BdtiFcUhOd23y9pAKOw@mail.gmail.com>
 <20260526164948.831543-2-robert@fmmr.tech>
In-Reply-To: <20260526164948.831543-2-robert@fmmr.tech>
From: Jann Horn <jannh@google.com>
Date: Tue, 23 Jun 2026 18:37:52 +0200
X-Gm-Features: AVVi8CeecdWvU2JRCsgIRxIjtpk10iZN5qMj4n0qeMspnj5KmEi35sn99rM3Dng
Message-ID: <CAG48ez02Sio8ZENVK3gUWM+8j6NgG9LxtnDV=v+FSqsqs_KfnA@mail.gmail.com>
Subject: Re: [PATCH v3] io_uring: annotate remote tasks for kcoverage
To: robert@fmmr.tech
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:robert@fmmr.tech,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:dvyukov@google.com,m:andreyknvl@gmail.com,m:kasan-dev@googlegroups.com,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13820-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[jannh@google.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,kernel.dk,google.com,gmail.com,googlegroups.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jannh@google.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,fmmr.tech:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 54D666B8CA5

On Tue, May 26, 2026 at 6:49=E2=80=AFPM Robert Femmer <robert@fmmr.tech> wr=
ote:
> Fuzzers use coverage information to guide generation of test cases
> towards new or interesting code paths. Syzkaller, specifically, makes
> use kcoverage (CONFIG_KCOV). Coverage information is not collected for
> kernel tasks unless annotated by kcov_remote_start and kcov_remote_stop.
> This patch annotates io-uring's work queue and sqpoll tasks.

I think this is a useful change overall.

@maintainers: For context, this should have no impact on normal builds
- "struct kcov_common_handle_id" is zero-sized in normal builds, and
all the helpers used here are empty inline functions.

> Depends-on: 20260430-kcov-refactor-common-handle-v1-1-23a0c7a0ba38@google=
.com
> Signed-off-by: Robert Femmer <robert@fmmr.tech>
> ---
>  include/linux/io_uring_types.h | 2 ++
>  io_uring/io-wq.c               | 4 ++++
>  io_uring/io_uring.c            | 1 +
>  io_uring/io_uring.h            | 2 ++
>  io_uring/sqpoll.c              | 4 ++++
>  5 files changed, 13 insertions(+)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 244392026c6d..b6590b2b350c 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -504,6 +504,8 @@ struct io_ring_ctx {
>         struct io_mapped_region         ring_region;
>         /* used for optimised request parameter and wait argument passing=
  */
>         struct io_mapped_region         param_region;
> +
> +       struct kcov_common_handle_id    kcov_handle;
>  };
>
>  /*
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index 8cc7b47d3089..9ade4c4f4983 100644
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
> +                       kcov_remote_start_common(req->ctx->kcov_handle);
>                         io_wq_submit_work(work);
> +                       kcov_remote_stop();
>                         io_assign_current_work(worker, NULL);
>
>                         linked =3D io_wq_free_work(work);
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 103b6c88f252..89cb649944d9 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -293,6 +293,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
>         INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
>         io_napi_init(ctx);
>         mutex_init(&ctx->mmap_lock);
> +       ctx->kcov_handle =3D kcov_common_handle();
>
>         return ctx;
>
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index e612a66ee80e..7226fbbbf9f0 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -7,6 +7,7 @@
>  #include <linux/resume_user_mode.h>
>  #include <linux/poll.h>
>  #include <linux/io_uring_types.h>
> +#include <linux/kcov.h>

I think instead of this, normal kernel coding style is to use includes
directly in the files where they are needed.
https://docs.kernel.org/process/submit-checklist.html says:
"If you use a facility then #include the file that defines/declares
that facility. Don=E2=80=99t depend on other header files pulling in ones t=
hat
you use."

>  #include <uapi/linux/eventpoll.h>
>  #include "alloc_cache.h"
>  #include "io-wq.h"
> @@ -581,4 +582,5 @@ static inline bool io_has_work(struct io_ring_ctx *ct=
x)
>         return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
>                io_local_work_pending(ctx);
>  }
> +
>  #endif

This looks like an accidental whitespace change.

> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 46c12afec73e..c7b78ea98587 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -342,19 +342,23 @@ static int io_sq_thread(void *data)
>
>                 cap_entries =3D !list_is_singular(&sqd->ctx_list);
>                 list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +                       kcov_remote_start_common(ctx->kcov_handle);
>                         int ret =3D __io_sq_thread(ctx, sqd, cap_entries,=
 &ist);
>
>                         if (!sqt_spin && (ret > 0 || !list_empty(&ctx->io=
poll_list)))
>                                 sqt_spin =3D true;
> +                       kcov_remote_stop();
>                 }
>                 if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
>                         sqt_spin =3D true;
>
>                 list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> +                       kcov_remote_start_common(ctx->kcov_handle);
>                         if (io_napi(ctx)) {
>                                 io_sq_start_worktime(&ist);
>                                 io_napi_sqpoll_busy_poll(ctx);
>                         }
> +                       kcov_remote_stop();

Someone who knows more about networking than me might know this area
better, but I think we probably don't want to have KCOV coverage
around the call to io_napi_sqpoll_busy_poll() for two reasons:

1. This is NAPI busypolling code, designed to busy-loop until network
packets arrive - meaning the limited KCOV coverage buffer will quickly
fill up even if no data is actually being processed.
2. As far as I know, io_napi_sqpoll_busy_poll() doesn't really process
data related to the uring instance - it (more or less) merely
busy-polls network interfaces specified by the user. Received packets
are not necessarily actually related to this uring instance.

>                 }
>
>                 io_sq_update_worktime(sqd, &ist);
> --
> 2.54.0
>

