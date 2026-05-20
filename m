Return-Path: <io-uring+bounces-13458-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mLR6C+/yDWry4wUAu9opvQ
	(envelope-from <io-uring+bounces-13458-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 19:44:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 99820594704
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 19:44:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B7F930E80F8
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 17:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA85C3C870E;
	Wed, 20 May 2026 17:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GCsq819r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A0A2609FD
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 17:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298587; cv=pass; b=EtrC7OaIxqX2GHOB6P/fDfX1ty8L6pwh819EYV184F/++38slW6pK2OkljOC8bAwc/zIagmF65E15CE1xikv71spEPQpwjaNSc2dqKR5lZcd0Eh4tTQ7GdgGk7A1qH5Ot0Obu+TizQz7mtrJAI3rNh35zP9CkV+uFgFPk+l+04k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298587; c=relaxed/simple;
	bh=JN3M6NI6XxVvUIYBJiRPc7MBCTOgzBcLdDM/7MdfIQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=llS34DXUdr2piVJe+j9YxyJoM8X4e69mI5Qrm7B/Bkwa/3Um0tprnHr67Uo/Rl+7Vmqi0M0BfCd6KKnfnBKxuuMjG8diqkGIokL0eDp1hLSPCq14mMsMZqhWEXGw53zGHh6+KI9kJ/jneff0hN8oYL4ylDqqyOi5v4ABuzuYyQ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GCsq819r; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48e82c23840so42357605e9.3
        for <io-uring@vger.kernel.org>; Wed, 20 May 2026 10:36:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779298584; cv=none;
        d=google.com; s=arc-20240605;
        b=L7B91DYB4gzZ1C8WjrwHlkXe1lI8omyxbxXJtB3T1/CiETntH7uVPWCrNulUPRTH2Y
         zEHEW+S5I1qY7kfi1z08N27nV+2Qc2351y3/aoGqOwV2Jw1IcwM1x7R3tam5jQV/tRXx
         WIC8WSZEIyk+gkQMiIGcgHMgVKeZeH2WWv270/4QLmMjT4ba/jrScCumMSsF/Ed+XSjY
         bA7upU9lCbIdhabyZ1bLBwkqfFe2O1nffOKKM2Adzou3TN4WJ0bXzMvqr/oUGBEigC6C
         WvasRWN+fWdgXsVAnL/Jj1gq5vKKkQAoNLCDTKk35EZoksHU6iTdzPzTVrnK+UT1p8vh
         wCfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kHbbDiLUoBE6hflnEkvaSz00u+P20/P60nCw0BhCBEE=;
        fh=Lk40CdLhPJW4fXnGUUMWJp5HH2IyUFywV44I6ega3HM=;
        b=iXWa9shFw9IaatzKYKLkfPdPG38orcd8CLVuRp3qKWjjEhGkZjMJiOiYyYW05jrmjG
         Zc+EMeKhbSzHbTZssYzZLpuRZDfMcaMLsbQhHojI2mxPj0EX4TzoKs2FKKKeTlVD1PGb
         CqQlW+Be9+GKfxKxWklvoIR9V02FBJy0w5JPlK0CglsLsgpVzuO5V7niA2TJRooXkMWh
         Ob0q1HTJtJeE8wsMM3YMYFCw5RV0HcONyOdCYFtjfbmiWVzfHHOLjt8g3k1xUIIhuHun
         ZQ6W9FJgLXLvf/mhkJFKHm9o5BFz61YY8qYwRJ4r9ukcv3F5wq8vpkql9u93etZBI2a8
         4OFQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779298584; x=1779903384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHbbDiLUoBE6hflnEkvaSz00u+P20/P60nCw0BhCBEE=;
        b=GCsq819rtCvwJD5Zkq7nDKUpKyg0XfU/9Jsfsid16gZ6V7asmquwnQnAfRegNIM+zR
         I899G7puzV/DssL9CeWnKap+AxAoCoiX4TQaHxQbVERF/k0dV5/Y+7BrzKY7OVS1RzHz
         BlvTBoYJkBEhf19rlap023Ne3IDUKLkJes1M0Xb06fneJJ5RAEeT2/yWeh+darONzD0E
         kaMSDhLEkdHC+63S8WAnP5o4NKjAonXv9bFp7q+hbeKPzAK5RVCMdxR6qwH8jetF+I6y
         kHh5jaZ0el9SBHuFDIaJfkQlZ4YvfPj0aOvp8fYpDBJ0vUnHD0xxhO8kaAPIHSzImuQV
         Z/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779298584; x=1779903384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kHbbDiLUoBE6hflnEkvaSz00u+P20/P60nCw0BhCBEE=;
        b=JDT43FfyahbPVata6aAxBnIiSlXWuATrjGaFA2ly299Z+r1N6gizlANlqH9wlj0oNP
         B73BYdw7ZkwOfpujt7sdnRojLzgYyqHCO//StW8KWiU/MX7Hrg17FVi4OEBYgMbmd0JX
         ERKzycurfxlQhf9KQD+51unr3oiWRCsWvBTam9gy0JTWcGZTadewCzyHztmneGD370o9
         prUoRD3CmGXHMLoRO5Am6Yv09f3P/f0OJIOK18yfe7JVnp2QxlYh5yqZCouyqKidbQip
         GtIWUHj5cHwVEH5mx5sT0z3ifv891gIaFchPptUcbLgGMFEEQe2cLGc6+7UVv8zMOG6n
         fDug==
X-Gm-Message-State: AOJu0YxGuyrc0ASzSlAXAyxiPeGWbpy5/9vNIeg9FoLmEOVexuUlo6Dn
	EjhjS+JTbox3/NuE++ZIS9pzOCtnzwRrvvI9xBnJxjJayK1gGWQ0TaH7APy3duTSR4AK/QW4oFu
	TEOabUH9rUSvAxT9vh/SLF6/D1wyxtB0=
X-Gm-Gg: Acq92OGTO7EwbJ2BBaA9w55t1ym0giPhBKCWTI8ItxV7fK95pw9fpvcrJ62FumEtX+h
	/JpH1Wa7DA7Pe85wSoKSMskDY7gPppcSv8QArbOi69/k4q1kwFlqA9BttG8r9JhCyMSCz8j/QB8
	utlKlKSdhEhhiqM+wArBZcvpK0S+Ti9OOvxAbbsLia5Yf3/WcIBh071SA9AIzaS//Icy4Plws2G
	JK9CwgNsaUMkqX7ByWLvi4yPO+HwQS3fwbqdQMr6Cr6fKoPvZhdTBVOKdiFWikfqonoi6r1n0DR
	TPcyetcEtBPn0VI9TMYPw1IGjfqQGhJCi9F4ZSyKBA==
X-Received: by 2002:a05:600c:8189:b0:48e:89f9:9408 with SMTP id
 5b1f17b1804b1-48fe632374fmr365340865e9.20.1779298584045; Wed, 20 May 2026
 10:36:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520153902.538206-2-robert@fmmr.tech>
In-Reply-To: <20260520153902.538206-2-robert@fmmr.tech>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 20 May 2026 19:36:11 +0200
X-Gm-Features: AVHnY4ISUi6elhq4QeZL__jXyUdloLfLnuzZKk7L62LgH66P39eU9OXqUk5xd0s
Message-ID: <CA+fCnZcHbkT=knNbOnAAmrbhx+8+WdcshLty84S_0UbYWVL-=A@mail.gmail.com>
Subject: Re: [PATCH] io_uring: annotate remote tasks for kcoverage
To: Robert Femmer <robert@fmmr.tech>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13458-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid,fmmr.tech:email]
X-Rspamd-Queue-Id: 99820594704
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 20, 2026 at 5:41=E2=80=AFPM Robert Femmer <robert@fmmr.tech> wr=
ote:
>
> Fuzzers use coverage information to guide generation of test cases
> towards new or interesting code paths. Syzkaller, specifically, makes
> use kcoverage (CONFIG_KCOV). Coverage information is not collected for
> kernel tasks unless annotated by kcov_remote_start and kcov_remote_stop.
> This patch annotates io-uring's work queue and sqpoll tasks.
>
> The value of the handle needs to be passed by userspace when enabling
> remote coverage collection. I chose the cgroup ns inum, because it is
> predictable and flexible enough for consumers to control which group of
> processes should be included for remote coverage collection, should they
> create an instance of io-uring.
>
> Signed-off-by: Robert Femmer <robert@fmmr.tech>
> ---
>  include/linux/io_uring_types.h |  4 ++++
>  include/uapi/linux/kcov.h      |  1 +
>  io_uring/io-wq.c               |  4 ++++
>  io_uring/io_uring.c            | 18 ++++++++++++++++++
>  io_uring/io_uring.h            | 22 ++++++++++++++++++++++
>  io_uring/sqpoll.c              |  4 ++++
>  kernel/kcov.c                  |  2 ++
>  7 files changed, 55 insertions(+)
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
>  };
>
>  /*
> diff --git a/include/uapi/linux/kcov.h b/include/uapi/linux/kcov.h
> index ed95dba9fa37..15bbce4569b1 100644
> --- a/include/uapi/linux/kcov.h
> +++ b/include/uapi/linux/kcov.h
> @@ -49,6 +49,7 @@ enum {
>
>  #define KCOV_SUBSYSTEM_COMMON  (0x00ull << 56)
>  #define KCOV_SUBSYSTEM_USB     (0x01ull << 56)
> +#define KCOV_SUBSYSTEM_IOURING (0x02ull << 56)

Hi Robet,

Would it be possible to use the common_handle functionality of KCOV
for io_uring?

The global KCOV handles were not the best design decision. They
arguably make sense for kernel tasks that get created during boot. But
if a kernel task gets spawned as a result of a user task actions, the
common handles are a better approach.

>
>  #define KCOV_SUBSYSTEM_MASK    (0xffull << 56)
>  #define KCOV_INSTANCE_MASK     (0xffffffffull)
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index 8cc7b47d3089..bb89d3f4b3dc 100644
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
>                         io_wq_submit_work(work);
> +                       io_kcov_remote_stop();
>                         io_assign_current_work(worker, NULL);
>
>                         linked =3D io_wq_free_work(work);
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 036145ee466c..71478e6ccae4 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -222,6 +222,21 @@ static void io_free_alloc_caches(struct io_ring_ctx =
*ctx)
>         io_rsrc_cache_free(ctx);
>  }
>
> +#ifdef CONFIG_KCOV
> +static __cold u64 io_ring_get_kcov_handle(void)
> +{
> +       struct nsproxy *ns_proxy =3D current->nsproxy;
> +       struct ns_common *ns;
> +       u64 inst =3D 0;
> +
> +       if (ns_proxy) {
> +               ns =3D to_ns_common(ns_proxy->cgroup_ns);
> +               inst =3D ns->inum;
> +       }
> +       return kcov_remote_handle(KCOV_SUBSYSTEM_IOURING, inst);
> +}
> +#endif
> +
>  static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_para=
ms *p)
>  {
>         struct io_ring_ctx *ctx;
> @@ -293,6 +308,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
>         INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
>         io_napi_init(ctx);
>         mutex_init(&ctx->mmap_lock);
> +#ifdef CONFIG_KCOV
> +       ctx->kcov_handle =3D io_ring_get_kcov_handle();
> +#endif
>
>         return ctx;
>
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index e612a66ee80e..cb03df877456 100644
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
> @@ -581,4 +582,25 @@ static inline bool io_has_work(struct io_ring_ctx *c=
tx)
>         return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
>                io_local_work_pending(ctx);
>  }
> +
> +#ifdef CONFIG_KCOV
> +static inline void io_kcov_remote_start(struct io_ring_ctx *ctx)
> +{
> +       kcov_remote_start(ctx->kcov_handle);
> +}
> +
> +static inline void io_kcov_remote_stop(void)
> +{
> +       kcov_remote_stop();
> +}
> +#else
> +static inline void io_kcov_remote_start(struct io_ring_ctx *ctx)
> +{
> +}
> +
> +static inline void io_kcov_remote_stop(void)
> +{
> +}
> +#endif
> +
>  #endif
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 46c12afec73e..b244abd37a27 100644
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
> +                       io_kcov_remote_stop();
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
> +                       io_kcov_remote_stop();
>                 }
>
>                 io_sq_update_worktime(sqd, &ist);
> diff --git a/kernel/kcov.c b/kernel/kcov.c
> index 0b369e88c7c9..6df04581a126 100644
> --- a/kernel/kcov.c
> +++ b/kernel/kcov.c
> @@ -585,6 +585,8 @@ static inline bool kcov_check_handle(u64 handle, bool=
 common_valid,
>                         common_valid : zero_valid;
>         case KCOV_SUBSYSTEM_USB:
>                 return uncommon_valid;
> +       case KCOV_SUBSYSTEM_IOURING:
> +               return uncommon_valid;
>         default:
>                 return false;
>         }
> --
> 2.54.0
>

