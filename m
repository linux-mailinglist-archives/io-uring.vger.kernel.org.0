Return-Path: <io-uring+bounces-13859-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 0L5pAHHIQ2oPhwoAu9opvQ
	(envelope-from <io-uring+bounces-13859-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 15:45:21 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B2D66E5005
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 15:45:20 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AAJtQXrZ;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13859-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13859-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6AA96306BCFA
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 13:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0DA3921CC;
	Tue, 30 Jun 2026 13:41:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A73A37B3F9
	for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 13:41:25 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782826886; cv=pass; b=TKB2QRZ4ej++yyB57l6roFnax6CTBVqTwJNia/6SDhNI94lAApOKJdslOmpbLo9yfh0kUuGhI27Yv7XnSeC+3Z6Gw+QyqekHqa/S35ogPe90Hs7cUJDj6gFIUJ3Zz6Ff0dNH8KmBPMMWnE5e+o69f00/gzaYa1f3HeNfWP3DOFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782826886; c=relaxed/simple;
	bh=xoPU2K5o4fSamMrq8Nn4qkJOZoY5H0ni3IFUulSADvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NHtrjEw0T6bb8uAkIraJtte4m6KsFWQzQxJh0zCTWxNg5I5od7v4+S5SWz9+QkpRBGX7CHp30W+LvNCUJXG2fIiiWBNKO7hPVj5xDNHgkZorXAmA77nB9w0THR47q4cKhKNH0y7fPxk/qe949YKopJcLojyRGod/j7AxylroWRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AAJtQXrZ; arc=pass smtp.client-ip=209.85.128.41
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493b691cb44so11874105e9.0
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 06:41:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782826884; cv=none;
        d=google.com; s=arc-20260327;
        b=gV7ZUSsN3zbJFw+Qd+bmYzYlfvpp50QhT0yHDg4PP6GwjVILymWqrpFt7ALqPok5Er
         /zcQ9auTHfBseOVKwE5Oy0c/gnXPdo5h+dZgE1dCc8TytR8TP66yHWhEZCjH1/1Fkm/O
         xX+OR0EZMh8MHjZUZjW1TM7Pf4aephxW09S3+d5RM6jwgQr8pwjM7atHWWsHz+rwaHb4
         hIRZnPamyi21oo9i94KGMlirtS/5v9NGOJJRzn0e1jjFjqmAPrBiK7RKiO6bZWEJKSHU
         s+bYRIzk2wzPyYlCxR48RRV/RHWkkeVh8705eXrff7TEG4VgQGBWNN7ShgHB/1cPCFdh
         m3RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pa21sicLXG3a6RoR+4X0u++Mm7jJAtyyMoUdGzgneHU=;
        fh=byydpFfk5dTt9IOuTXKEQNA2ileepK88T/zicoI+wio=;
        b=dJ8GqM0d/xJggM9YEhhPoXXGvSDJO+ugnfPhxRI8n0iRnvyY+k+h6MFAXrkHQPZ7nS
         lWkuQg2g8XKiZKT08CQd/F/ttwNIBqRKv0xAV9fSe3KalWGNpiJkW3WXzsdQwj8eHjZi
         X9aDSfxs2ZVlkyMXjYVOfWMAaFG3SxjrDcCBvLzn6Khf1Wvj3TohlNVVWpkp9vW2yp2l
         P/0ZCOu/zqgxTZf/sQuJBBXSllhoOqhIggSHrK33zbtnZsrC/jYX0RW5EkNukDLRRMHW
         Tur5+XHAxsCozbxZoDVewGirWrdznVggKn+b3chbWCJeVwA1KppVSKM4WGm/6FfP984Z
         meRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782826884; x=1783431684; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pa21sicLXG3a6RoR+4X0u++Mm7jJAtyyMoUdGzgneHU=;
        b=AAJtQXrZsljDMytA7URQZDEJUhQ9+jqsjuOWvcq1HmVwtQ2ch5PMFY+8D6NhU1MahE
         S9EYuDXq74QMZn9jFoM5qtOr7UQXiVcSnYSEWkc9LqpNGKjfMVUj2xqakaEI8WnsHA7x
         ISbisBlb/tKXqYMP1LlX7tRVmQj4uxamI5hULUtp11p+71V3HegL+nxu6u8N9+UyI5HD
         uTXM2VfXhpRTY/Sw3x6zkKd5vShRfV+RVNXGv6VyhN+14bNhjD4McNW827HjhFSKXnDL
         UQRC1wahuuHrJkLl5zPqc1JuZf0PRs1iqWNBFYtZS2Eu5DUn3e5oxmaLm7tpAuVHI9AI
         c9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782826884; x=1783431684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pa21sicLXG3a6RoR+4X0u++Mm7jJAtyyMoUdGzgneHU=;
        b=GrLPuW6/Wan0hdQSp3fJU0+eNvOyQhbmQbt0qhFRgTWUXUoA4aEi/urwE/8LNxsoAF
         TtMSRp9eIipMDvqE6vN+0YDVwWPNSERbF2TpIs3RpMrUANE+m4KEeO+vqIUeisEt6Z05
         LC+E4Uo+b4q9HckQgGbMjlWrEao7CyC7Vf2Z6knX85cIvcVfTFGnMWmx00khS123e5/2
         JmzH8yopqXsmk5Fb4tYBgdd16uywDrDdR0MKToTAVit3rYNJ0pOKtJ0a8GazIhurC6O0
         SyJ2EaL1UvvGMnBvqzwkmbq1d2pHgYIKsKEOWDdVKqHfIh40IFYVPY5YTnFCnJoA0IWb
         BqRw==
X-Gm-Message-State: AOJu0YzhE9YLgUdW0fPH/i1/RX+d6DRp8ZqXVdghasYC+x4dxdPHW4SA
	ueHMxa8hQ2ulf7yjIWH0iYk06RyUFQeOrQvWFjBUdtM9wVZVGTJWbpltqOp2oACaDVgmimbxLh6
	ZdVfXWxM6ngHyDveUwDQinKsvhNirmXJpDqBG
X-Gm-Gg: AfdE7ckx4Sm1Gi9jRbfqvdgNHKMHH3lfzPZQxQmwTp3Hr9Qdtc8Ip32J2y50GUryqiH
	KYaa6oZJyMoBIkeQFAup89PlJFm/QmUO4ay1nvzih2y1mFJ1e0zfX9+c038fDGM898erzL71Awn
	bXpEHed+djMqrwOzcAEanbZ1Io0zPdvAFULVcEohnRbXZJj+EdeGvd42ks42lj/91ViLdd49laP
	Pwb87Nhw9lYdmBLSw+Sh6gBu6p1tdFzkVVJ5NtWL3h07GajjSm/3z0BCSmxYfHqxElwBmOVPOAC
	u2bpp73mX4PadCoLXHjF8ly8ZJQ/Yqc109nbVFaB1w==
X-Received: by 2002:a05:600c:3e0f:b0:493:a5d4:3798 with SMTP id
 5b1f17b1804b1-493bda28d59mr11508455e9.1.1782826883348; Tue, 30 Jun 2026
 06:41:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez02Sio8ZENVK3gUWM+8j6NgG9LxtnDV=v+FSqsqs_KfnA@mail.gmail.com>
 <20260624090145.1715865-2-robert@fmmr.tech>
In-Reply-To: <20260624090145.1715865-2-robert@fmmr.tech>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 30 Jun 2026 15:41:03 +0200
X-Gm-Features: AVVi8CfLdl--pUxA7bc7sjYDMXH1jNn9Ovhha-7OFBfug_w1YUKX-_k5aA2LmKo
Message-ID: <CA+fCnZf6pj66Z0wmGPa+yRbzK7BQDx+ZoFO7nJ7rGnCfOW10Qw@mail.gmail.com>
Subject: Re: [PATCH v4] io_uring: annotate remote tasks for kcoverage
To: Robert Femmer <robert@fmmr.tech>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:robert@fmmr.tech,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:dvyukov@google.com,m:kasan-dev@googlegroups.com,m:jannh@google.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13859-lists,io-uring=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER(0.00)[andreyknvl@gmail.com,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andreyknvl@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4B2D66E5005

On Wed, Jun 24, 2026 at 11:03=E2=80=AFAM Robert Femmer <robert@fmmr.tech> w=
rote:
>
> Fuzzers use coverage information to guide generation of test cases
> towards new or interesting code paths. Syzkaller, specifically, makes
> use kcoverage (CONFIG_KCOV). Coverage information is not collected for
> kernel tasks unless annotated by kcov_remote_start and kcov_remote_stop.
> This patch annotates io-uring's work queue and sqpoll tasks.
>
> Depends-On: 20260430-kcov-refactor-common-handle-v1-1-23a0c7a0ba38@google=
.com
> Signed-off-by: Robert Femmer <robert@fmmr.tech>
> ---
>  include/linux/io_uring_types.h | 2 ++
>  io_uring/io-wq.c               | 5 +++++
>  io_uring/io_uring.c            | 2 ++
>  io_uring/sqpoll.c              | 3 +++
>  4 files changed, 12 insertions(+)
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
> index 8cc7b47d3089..173299dfc9c2 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -19,6 +19,7 @@
>  #include <linux/mmu_context.h>
>  #include <linux/sched/sysctl.h>
>  #include <uapi/linux/io_uring.h>
> +#include <linux/kcov.h>
>
>  #include "io-wq.h"
>  #include "slist.h"
> @@ -639,6 +640,7 @@ static void io_worker_handle_work(struct io_wq_acct *=
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
> @@ -649,7 +651,10 @@ static void io_worker_handle_work(struct io_wq_acct =
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
> index 103b6c88f252..ab7c3e45e238 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -59,6 +59,7 @@
>  #include <linux/audit.h>
>  #include <linux/security.h>
>  #include <linux/jump_label.h>
> +#include <linux/kcov.h>
>
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> @@ -293,6 +294,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
>         INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
>         io_napi_init(ctx);
>         mutex_init(&ctx->mmap_lock);
> +       ctx->kcov_handle =3D kcov_common_handle();
>
>         return ctx;
>
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 46c12afec73e..aafb640d3b2f 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -13,6 +13,7 @@
>  #include <linux/cpuset.h>
>  #include <linux/sched/cputime.h>
>  #include <linux/io_uring.h>
> +#include <linux/kcov.h>
>
>  #include <uapi/linux/io_uring.h>
>
> @@ -342,10 +343,12 @@ static int io_sq_thread(void *data)
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
> --
> 2.54.0
>

From KCOV API side:

Acked-by: Andrey Konovalov <andreyknvl@gmail.com>

Thanks!

