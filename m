Return-Path: <io-uring+bounces-13706-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id MLUvLSdXLGqFPgQAu9opvQ
	(envelope-from <io-uring+bounces-13706-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:59:51 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1055167BE3F
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 20:59:51 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=CRnUsJOZ;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13706-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13706-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D8A3E302BDDD
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 18:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E66345757;
	Fri, 12 Jun 2026 18:59:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5791126BF7
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 18:59:45 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781290788; cv=pass; b=F7hYAWhrM5EZYNtKI1Sw/WKDMtvhcGPibXE2oMienojZ78yQDxzZPq6/wB7Lt5sU7fCzH/cwheZHKxji+LNQ1QRZA6Sx2BUdqGFUdqWbvy/9FF1sFiter/VJrBHF8sj8pHgT4ZcQU03E3fMd3Fnh4VSjq2+GkP8sy8I8Ipgs1RI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781290788; c=relaxed/simple;
	bh=KBSrzJV+SLXlHsDDI99AwAQ/fc+xvNd5M9BTQyMyuok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I8Cw9mrG3ycMN2tzErk/wvr/Vfbsbmr+iXaRNysEBZndfXr+E6cW6PUwcGXbpIky498QbqenwhNYGNciwN1pGnO3TCRxWwII7Yr35T6TVkTtrQLatdIQRA/1eJ84uVIUqDVBPGBKJOcuUNuE9IVwnS72ofs1so7RmkDUq377GxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=CRnUsJOZ; arc=pass smtp.client-ip=209.85.210.52
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e6d7263025so263307a34.0
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 11:59:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781290785; cv=none;
        d=google.com; s=arc-20240605;
        b=W8Mgj9hOdcmRF5/+HBmCyLXeEL5hAi97GiqAVsQZySjYRbK5DFwDZHn+PYDYGhpZzR
         CHZUXqwB2yAurCyJ0RM1EDV1/DMHPjcX+eP6HG92T+jLNT5YaWd9ruPcRNs3Cp2NoHZu
         x0MksUN5OZU6jY/qp0vlCkffEGRhjNGPWjbensW+EQecgu/M2KTLDDZPG7wVSPaNKIX3
         iXttGK7BQ2Ml416iup3w4xJFUxJcYIciz2b2AlwPURpNnyPjh6Ym09xBJdgN3o/p3t4y
         K0woX1QUeLpNc9BTU0ssFEUj9FWg2Gl7qHogtV3VvIFH/9rfmB4cYqJr+2UCjSmNrfnn
         Z/oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/6C+2rYlReOkIA1NiGBi8hfoiXd2l01shRaJQHnWcGs=;
        fh=tcB1jbK5Mfh49jFaBDMFCl5E4RG50sbZDH32oaESUuc=;
        b=Rg5Tt/Td62SKyP8HFEsP3WECTbptshJ7S613qv+MJ5D7+xLss8m+FzZz+CXAh8z8FW
         FFHBbZp0tpeabhf4SUzl+qYnN6iA2eIEyVGO5m3WyQNzgzbOt77lk92KtDexYQNmLCn/
         6mnWaz42SAvd4KR3dwzZTy8wapHN/1J2aMMjcdJl73h7eMuf8qePEydR7q/8Lg4bxgAR
         JOYBcNQEL/NLWRjTq+g7cajecbscmDRoR5OJ36D6HiVUePr/sjdv2uqHy3diYU/zS4L1
         n080c89OllPiK13Uh+jv7vsHtztARCYmbqFyFTWMu8tMqk//ts8B8LnbBUp7U0Fa2lSs
         BGCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781290785; x=1781895585; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6C+2rYlReOkIA1NiGBi8hfoiXd2l01shRaJQHnWcGs=;
        b=CRnUsJOZTd1/Wb3vI/pa6CSFl1LKLMt1CwyFmdUnb4WHnHopIl9eIrImpTfA0esBFG
         avPkxIOAhhBqBQOr0DRBMaWw9p+FWfmhnAohAZ2wD1wRqXEg00pDLcXMuyPvMSnswdgO
         7OuDhJmRf9e1KvjYC4ULIdjalYAihh7J4hB7Z8ARSuUbxSVYYCNoPb5DZQxEH2xYDxlK
         zRG0UywCOeh7SF5RshlXX/BHVs1wn8aM7tjKcKKmzx0Jz90TNEK2H6dWTI/foF1DwPYB
         mbqt45JZClsuGsM12N6Dl/G67ZWPBdGE0pzL5u4vDeyG2XISzT9rgVt0pDIttoCA60R4
         wx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781290785; x=1781895585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/6C+2rYlReOkIA1NiGBi8hfoiXd2l01shRaJQHnWcGs=;
        b=LLI/TfkHprCnN5uX/rmscz5kJzZkSWtxtiui4rcwOcCFM2oKueC4SBs0XlUeJ5nNZ4
         5bARcDhagKTv9YBxgPtKEtX2gnMzva7fKXT2q/MzFLOdtEj2BRJXvv2IYd/CXOfvyOLt
         rVFpKGXLeEdByEVVTVdmPbmhKHdRGncJO6XSEMYhXppUOwlfws3W9uvT7oq760mvXHfF
         Y/grqOjjh61HrD5jD3bcZ30m1DMBJFmvGI4E8snyPIMX1fIuZKI64Os0m3kaGY6L9s7m
         DM4lMzzOVEQwNQlw2kEmasXwEakqyv0eptojwGzAaVFWezsNDJdKXg4o4ueufi4Rc+f2
         yR6w==
X-Gm-Message-State: AOJu0Yz0C8JWuh+8iuGnmyerjbclQQAhAxWax/GpZAl0V1YJzdhQIt65
	wGFJDC0hEraZHrwHQWwtk14lxjI9+17+s02HmOE1/VRr0nY1j5YougZBhMYT2s5AWX1t/MnC0Xj
	xQE74m5iZU0zpb27eirpyODuarPz7wa6WMr+DWIEjxQ==
X-Gm-Gg: Acq92OFP9Pbr0175nTma7Yiheby5uo3jO3YizzHlD1yFmkK6AKAn4YXbtZha7ihQw/q
	5/qleVXicIjaZqBt87yCx2m8Aln2Gm37rRHgzOSa+0BGA7+Nuibf4h9XB3GZN44p6zNbnf2Tmm/
	PQ5F8UBnFt323XD6EsxGCER087BE7PO/PyfaboJSPRe7A1arz8VIAIWpA9vyiIUfaitMT9bCn/Q
	q+4Q10mbOwW7E4TqUK8RtqtdtBViJVN/FwswTOUtvgUTS/ZqVJeF80P4kAmefNgjTWRwHPKGUzr
	d8EDPOE=
X-Received: by 2002:a05:6808:1920:b0:486:39db:ebf1 with SMTP id
 5614622812f47-4872f57225emr1321100b6e.7.1781290784417; Fri, 12 Jun 2026
 11:59:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612025125.1690253-1-axboe@kernel.dk> <20260612025125.1690253-5-axboe@kernel.dk>
In-Reply-To: <20260612025125.1690253-5-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 12 Jun 2026 11:59:33 -0700
X-Gm-Features: AVVi8CeqXqN_sAQMJj0gUXsYj3nLYsCt6F8xoUlklnfIndEXyWqGsM6Cci_6e0A
Message-ID: <CADUfDZqrbUyJR9yn8i+eVbVwEuvs7a4mR8kfXF_umnZ9RUAc6g@mail.gmail.com>
Subject: Re: [PATCH 4/6] io_uring: switch normal task_work to a mpscq
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13706-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:krisman@suse.de,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,purestorage.com:dkim,purestorage.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 1055167BE3F

On Thu, Jun 11, 2026 at 7:51=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Like the local task_work list, the normal (tctx) task_work list is an
> llist, and hence needs the O(n) llist_reverse_order() pass before
> running entries in queue order. On top of that, capped runs - sqpoll
> processing IORING_TW_CAP_ENTRIES_VALUE entries at a time - need the
> claimed-but-unprocessed leftovers carried in a separate retry_list,
> as they can't be pushed back to the shared list.
>
> Switch tctx->task_list to a mpscq, like what was done for the
> DEFER_TASKRUN paths as well.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |  12 ++-
>  io_uring/sqpoll.c              |  30 +++----
>  io_uring/tctx.c                |   3 +-
>  io_uring/tw.c                  | 146 ++++++++++++++++++++-------------
>  io_uring/tw.h                  |   4 +-
>  5 files changed, 113 insertions(+), 82 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 9df5584ec3b1..33de451127f9 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -131,6 +131,11 @@ struct io_uring_task {
>         const struct io_ring_ctx        *last;
>         struct task_struct              *task;
>         struct io_wq                    *io_wq;
> +       /*
> +        * Consumer cursor for ->task_list. Only popped by the task itsel=
f,
> +        * or by ->fallback_work once the task can no longer run task_wor=
k.
> +        */
> +       struct llist_node               *task_head;
>         struct file                     *registered_rings[IO_RINGFD_REG_M=
AX];
>
>         struct xarray                   xa;
> @@ -139,8 +144,13 @@ struct io_uring_task {
>         atomic_t                        inflight_tracked;
>         struct percpu_counter           inflight;
>
> +       /* drains ->task_list once the task can no longer run task_work *=
/
> +       struct work_struct              fallback_work;
> +
>         struct { /* task_work */
> -               struct llist_head       task_list;
> +               struct mpscq            task_list;
> +               /* BIT(0) guards adding tw only once */
> +               unsigned long           tw_pending;
>                 struct callback_head    task_work;
>         } ____cacheline_aligned_in_smp;
>  };
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 46c12afec73e..2460bd605266 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -260,39 +260,29 @@ static bool io_sqd_handle_event(struct io_sq_data *=
sqd)
>  }
>
>  /*
> - * Run task_work, processing the retry_list first. The retry_list holds
> - * entries that we passed on in the previous run, if we had more task_wo=
rk
> - * than we were asked to process. Newly queued task_work isn't run until=
 the
> - * retry list has been fully processed.
> + * Run task_work, processing no more than max_entries at a time. If more
> + * than that is pending, it simply stays on the queue for the next run.
>   */
> -static unsigned int io_sq_tw(struct llist_node **retry_list, int max_ent=
ries)
> +static unsigned int io_sq_tw(int max_entries)
>  {
>         struct io_uring_task *tctx =3D current->io_uring;
>         unsigned int count =3D 0;
>
> -       if (*retry_list) {
> -               *retry_list =3D io_handle_tw_list(*retry_list, &count, ma=
x_entries);
> -               if (count >=3D max_entries)
> -                       goto out;
> -               max_entries -=3D count;
> -       }
> -       *retry_list =3D tctx_task_work_run(tctx, max_entries, &count);
> -out:
> +       tctx_task_work_run(tctx, max_entries, &count);
>         if (task_work_pending(current))
>                 task_work_run();
>         return count;
>  }
>
> -static bool io_sq_tw_pending(struct llist_node *retry_list)
> +static bool io_sq_tw_pending(void)
>  {
>         struct io_uring_task *tctx =3D current->io_uring;
>
> -       return retry_list || !llist_empty(&tctx->task_list);
> +       return !mpscq_empty(&tctx->task_list);
>  }
>
>  static int io_sq_thread(void *data)
>  {
> -       struct llist_node *retry_list =3D NULL;
>         struct io_sq_data *sqd =3D data;
>         struct io_ring_ctx *ctx;
>         unsigned long timeout =3D 0;
> @@ -347,7 +337,7 @@ static int io_sq_thread(void *data)
>                         if (!sqt_spin && (ret > 0 || !list_empty(&ctx->io=
poll_list)))
>                                 sqt_spin =3D true;
>                 }
> -               if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
> +               if (io_sq_tw(IORING_TW_CAP_ENTRIES_VALUE))
>                         sqt_spin =3D true;
>
>                 list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> @@ -372,7 +362,7 @@ static int io_sq_thread(void *data)
>                 }
>
>                 prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
> -               if (!io_sqd_events_pending(sqd) && !io_sq_tw_pending(retr=
y_list)) {
> +               if (!io_sqd_events_pending(sqd) && !io_sq_tw_pending()) {
>                         bool needs_sched =3D true;
>
>                         list_for_each_entry(ctx, &sqd->ctx_list, sqd_list=
) {
> @@ -411,8 +401,8 @@ static int io_sq_thread(void *data)
>                 timeout =3D jiffies + sqd->sq_thread_idle;
>         }
>
> -       if (retry_list)
> -               io_sq_tw(&retry_list, UINT_MAX);
> +       if (io_sq_tw_pending())
> +               io_sq_tw(UINT_MAX);
>
>         io_uring_cancel_generic(true, sqd);
>         rcu_assign_pointer(sqd->thread, NULL);
> diff --git a/io_uring/tctx.c b/io_uring/tctx.c
> index 42b219b34aa8..cc3bf2b3bdbc 100644
> --- a/io_uring/tctx.c
> +++ b/io_uring/tctx.c
> @@ -103,7 +103,8 @@ __cold struct io_uring_task *io_uring_alloc_task_cont=
ext(struct task_struct *tas
>         init_waitqueue_head(&tctx->wait);
>         atomic_set(&tctx->in_cancel, 0);
>         atomic_set(&tctx->inflight_tracked, 0);
> -       init_llist_head(&tctx->task_list);
> +       mpscq_init(&tctx->task_list, &tctx->task_head);
> +       INIT_WORK(&tctx->fallback_work, io_tctx_fallback_work);
>         init_task_work(&tctx->task_work, tctx_task_work);
>         return tctx;
>  }
> diff --git a/io_uring/tw.c b/io_uring/tw.c
> index b8d6027aaeff..ca29bb0b9768 100644
> --- a/io_uring/tw.c
> +++ b/io_uring/tw.c
> @@ -46,46 +46,6 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx,=
 io_tw_token_t tw)
>         percpu_ref_put(&ctx->refs);
>  }
>
> -/*
> - * Run queued task_work, returning the number of entries processed in *c=
ount.
> - * If more entries than max_entries are available, stop processing once =
this
> - * is reached and return the rest of the list.
> - */
> -struct llist_node *io_handle_tw_list(struct llist_node *node,
> -                                    unsigned int *count,
> -                                    unsigned int max_entries)
> -{
> -       struct io_ring_ctx *ctx =3D NULL;
> -       struct io_tw_state ts =3D { };
> -
> -       do {
> -               struct llist_node *next =3D node->next;
> -               struct io_kiocb *req =3D container_of(node, struct io_kio=
cb,
> -                                                   io_task_work.node);
> -
> -               if (req->ctx !=3D ctx) {
> -                       ctx_flush_and_put(ctx, ts);
> -                       ctx =3D req->ctx;
> -                       mutex_lock(&ctx->uring_lock);
> -                       percpu_ref_get(&ctx->refs);
> -                       ts.cancel =3D io_should_terminate_tw(ctx);
> -               }
> -               INDIRECT_CALL_2(req->io_task_work.func,
> -                               io_poll_task_func, io_req_rw_complete,
> -                               (struct io_tw_req){req}, ts);
> -               node =3D next;
> -               (*count)++;
> -               if (unlikely(need_resched())) {
> -                       ctx_flush_and_put(ctx, ts);
> -                       ctx =3D NULL;
> -                       cond_resched();
> -               }
> -       } while (node && *count < max_entries);
> -
> -       ctx_flush_and_put(ctx, ts);
> -       return node;
> -}
> -
>  static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
>  {
>         struct io_ring_ctx *last_ctx =3D NULL;
> @@ -114,43 +74,109 @@ static __cold void __io_fallback_tw(struct llist_no=
de *node, bool sync)
>         }
>  }
>
> -static void io_fallback_tw(struct io_uring_task *tctx, bool sync)
> +void io_tctx_fallback_work(struct work_struct *work)
>  {
> -       struct llist_node *node =3D llist_del_all(&tctx->task_list);
> +       struct io_uring_task *tctx =3D container_of(work, struct io_uring=
_task,
> +                                                 fallback_work);
> +       struct llist_node *node, *first =3D NULL, **tail =3D &first;
> +
> +       /* see tctx_task_work() - a set bit must always have a run coming=
 */
> +       clear_bit(0, &tctx->tw_pending);
> +       smp_mb__after_atomic();
> +
> +       while (!mpscq_empty(&tctx->task_list)) {
> +               node =3D mpscq_pop(&tctx->task_list, &tctx->task_head);
> +               if (!node) {
> +                       /* a producer is mid-push, wait for it to link */
> +                       cond_resched();
> +                       continue;
> +               }
> +               *tail =3D node;
> +               tail =3D &node->next;
> +       }
> +       *tail =3D NULL;
> +       __io_fallback_tw(first, false);
> +       put_task_struct(tctx->task);
> +}
>
> -       __io_fallback_tw(node, sync);
> +static void io_fallback_tw(struct io_uring_task *tctx)
> +{
> +       /*
> +        * The task ref both keeps ->task valid and, as __io_uring_free()=
 is
> +        * only called when the task itself is freed, ensures the tctx (a=
nd
> +        * the queued work) stay around until the drain has run.
> +        */
> +       get_task_struct(tctx->task);
> +       if (!queue_work(system_unbound_wq, &tctx->fallback_work))
> +               put_task_struct(tctx->task);
>  }
>
> -struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
> -                                     unsigned int max_entries,
> -                                     unsigned int *count)
> +/*
> + * Run queued task_work, processing no more than max_entries, with the n=
umber
> + * of entries processed added to *count. If more entries than max_entrie=
s are
> + * available, the remainder simply stay on the queue for the next run.
> + */
> +void tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_ent=
ries,
> +                       unsigned int *count)
>  {
> -       struct llist_node *node;
> +       struct io_ring_ctx *ctx =3D NULL;
> +       struct io_tw_state ts =3D { };
>
> -       node =3D llist_del_all(&tctx->task_list);
> -       if (node) {
> -               node =3D llist_reverse_order(node);
> -               node =3D io_handle_tw_list(node, count, max_entries);
> +       while (*count < max_entries) {
> +               struct llist_node *node =3D mpscq_pop(&tctx->task_list,
> +                                                   &tctx->task_head);
> +               struct io_kiocb *req;
> +
> +               if (!node) {
> +                       if (mpscq_empty(&tctx->task_list))
> +                               break;
> +                       /*
> +                        * A producer has published a node but hasn't
> +                        * linked it into the queue yet (see mpscq_pop())=
.
> +                        * Give it a chance to finish rather than spinnin=
g,
> +                        * and don't sit on the ctx lock while doing so.
> +                        */
> +                       ctx_flush_and_put(ctx, ts);
> +                       ctx =3D NULL;
> +                       cond_resched();
> +                       continue;
> +               }
> +               req =3D container_of(node, struct io_kiocb, io_task_work.=
node);
> +               if (req->ctx !=3D ctx) {
> +                       ctx_flush_and_put(ctx, ts);
> +                       ctx =3D req->ctx;
> +                       mutex_lock(&ctx->uring_lock);
> +                       percpu_ref_get(&ctx->refs);
> +                       ts.cancel =3D io_should_terminate_tw(ctx);
> +               }
> +               INDIRECT_CALL_2(req->io_task_work.func,
> +                               io_poll_task_func, io_req_rw_complete,
> +                               (struct io_tw_req){req}, ts);
> +               (*count)++;
> +               if (unlikely(need_resched())) {
> +                       ctx_flush_and_put(ctx, ts);
> +                       ctx =3D NULL;
> +                       cond_resched();
> +               }
>         }
> +       ctx_flush_and_put(ctx, ts);
>
>         /* relaxed read is enough as only the task itself sets ->in_cance=
l */
>         if (unlikely(atomic_read(&tctx->in_cancel)))
>                 io_uring_drop_tctx_refs(current);
>
>         trace_io_uring_task_work_run(tctx, *count);
> -       return node;
>  }
>
>  void tctx_task_work(struct callback_head *cb)
>  {
>         struct io_uring_task *tctx;
> -       struct llist_node *ret;
>         unsigned int count =3D 0;
>
>         tctx =3D container_of(cb, struct io_uring_task, task_work);
> -       ret =3D tctx_task_work_run(tctx, UINT_MAX, &count);
> -       /* can't happen */
> -       WARN_ON_ONCE(ret);
> +       clear_bit(0, &tctx->tw_pending);
> +       smp_mb__after_atomic();
> +       tctx_task_work_run(tctx, UINT_MAX, &count);
>  }
>
>  /*
> @@ -220,7 +246,7 @@ void io_req_normal_work_add(struct io_kiocb *req)
>         struct io_ring_ctx *ctx =3D req->ctx;
>
>         /* task_work already pending, we're done */
> -       if (!llist_add(&req->io_task_work.node, &tctx->task_list))
> +       if (!mpscq_push(&tctx->task_list, &req->io_task_work.node))
>                 return;
>
>         /*
> @@ -236,10 +262,14 @@ void io_req_normal_work_add(struct io_kiocb *req)
>                 return;
>         }
>
> +       /* task_work must only be added once */
> +       if (test_and_set_bit(0, &tctx->tw_pending))
> +               return;

Is tw_pending necessary? How come the task_work_add() exclusivity
isn't already provided by the mpscq_push() check above?

Best,
Caleb

> +
>         if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->noti=
fy_method)))
>                 return;
>
> -       io_fallback_tw(tctx, false);
> +       io_fallback_tw(tctx);
>  }
>
>  void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags)
> diff --git a/io_uring/tw.h b/io_uring/tw.h
> index f42db5fdbded..387e52004da8 100644
> --- a/io_uring/tw.h
> +++ b/io_uring/tw.h
> @@ -25,8 +25,8 @@ static inline bool io_should_terminate_tw(struct io_rin=
g_ctx *ctx)
>  }
>
>  void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags);
> -struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned i=
nt *count, unsigned int max_entries);
>  void tctx_task_work(struct callback_head *cb);
> +void io_tctx_fallback_work(struct work_struct *work);
>  int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_e=
vents);
>  int io_run_task_work_sig(struct io_ring_ctx *ctx);
>
> @@ -36,7 +36,7 @@ int io_run_local_work_locked(struct io_ring_ctx *ctx, i=
nt min_events);
>
>  void io_req_local_work_add(struct io_kiocb *req, unsigned flags);
>  void io_req_normal_work_add(struct io_kiocb *req);
> -struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsign=
ed int max_entries, unsigned int *count);
> +void tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_ent=
ries, unsigned int *count);
>
>  static inline void __io_req_task_work_add(struct io_kiocb *req, unsigned=
 flags)
>  {
> --
> 2.53.0
>

