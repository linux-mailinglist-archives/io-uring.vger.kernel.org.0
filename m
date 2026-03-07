Return-Path: <io-uring+bounces-12581-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YFs9IA2Pq2kaeQEAu9opvQ
	(envelope-from <io-uring+bounces-12581-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 07 Mar 2026 03:35:57 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD971229A18
	for <lists+io-uring@lfdr.de>; Sat, 07 Mar 2026 03:35:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF88F30743E3
	for <lists+io-uring@lfdr.de>; Sat,  7 Mar 2026 02:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B5C2882B4;
	Sat,  7 Mar 2026 02:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MvEW6kLz"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3311F0E2E
	for <io-uring@vger.kernel.org>; Sat,  7 Mar 2026 02:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772850948; cv=none; b=DdSyCid59O535BbG3naFraTmxbcAglFpbjCm8pIUdr05KGAQVmrAUNqDiE5RBXl/OAgkYLBXF5zz2x/C3njjtZWjYHVUvf0lQ32ybXB+iB7/BuM47qGJBbmkE8Pg4n8HZU0s1wr809DtCjr23WZdSwNW6saDsQjuiM74Hhyil/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772850948; c=relaxed/simple;
	bh=XybkX46QohutpeBTmQYjhuqEFIakmZ+1B5ANm17Xkno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfoB0Zw76FfFEZ59wsr3x6kV+NovDFNw1KOmzWPpWqqFnLWpRfP5r7T/xqx/r0sbdgtLzqWP3uWptdoH/dDmPMEitfnffXzDaw3NYtZkMyKnbzthgeXx2mrRff2U8K6AW62HPCCFtp9F0NG/x0EDxuJMUKfOgYJnuMZf5Arkxyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MvEW6kLz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772850945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rqxlIwfDGS1E+lmb9grWkDLKbEw2kPFez03sw9KGHo4=;
	b=MvEW6kLzy68sjQJo3I8UEyGu+e4uVdQ9IhVmhn//HHg2X3REsOrhZYYraUzw+cvOsuBjsZ
	XfqWbk1i8j9fKATbFniSEgYegI3Mx4twybrpliARrDwjM4TX4bhHq6B3RT6Q70hUZm3pag
	qbJBKU62Didsfv7UNiHvW3V74r1nLdQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-510-m3m9-pxIM1CwYtLu4knl2w-1; Fri,
 06 Mar 2026 21:35:42 -0500
X-MC-Unique: m3m9-pxIM1CwYtLu4knl2w-1
X-Mimecast-MFC-AGG-ID: m3m9-pxIM1CwYtLu4knl2w_1772850940
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9515819560B5;
	Sat,  7 Mar 2026 02:35:39 +0000 (UTC)
Received: from fedora (unknown [10.72.116.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C555E1955D71;
	Sat,  7 Mar 2026 02:35:32 +0000 (UTC)
Date: Sat, 7 Mar 2026 10:35:27 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v5 3/5] io_uring: count CQEs in io_iopoll_check()
Message-ID: <aauO72ocnZRhJkiA@fedora>
References: <20260302172914.2488599-1-csander@purestorage.com>
 <20260302172914.2488599-4-csander@purestorage.com>
 <aagKTanM5Az9UDsJ@fedora>
 <CADUfDZozycFBPX0kH=22Gda7njM3xVmL=Cy=zCq6cfXY8JH_dw@mail.gmail.com>
 <a6591d03-3707-4f1c-b1fa-49f010f98d53@kernel.dk>
 <CADUfDZp0shyZ5FqfEcwbi0tHXOFqwqZKRvwQW=heR-yvaOaw0Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZp0shyZ5FqfEcwbi0tHXOFqwqZKRvwQW=heR-yvaOaw0Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: DD971229A18
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12581-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-0.951];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,purestorage.com:email,kernel.dk:email]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 05:38:15PM -0800, Caleb Sander Mateos wrote:
> On Wed, Mar 4, 2026 at 8:29 AM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 3/4/26 8:46 AM, Caleb Sander Mateos wrote:
> > > On Wed, Mar 4, 2026 at 2:33?AM Ming Lei <ming.lei@redhat.com> wrote:
> > >>
> > >> On Mon, Mar 02, 2026 at 10:29:12AM -0700, Caleb Sander Mateos wrote:
> > >>> A subsequent commit will allow uring_cmds that don't use iopoll on
> > >>> IORING_SETUP_IOPOLL io_urings. As a result, CQEs can be posted without
> > >>> setting the iopoll_completed flag for a request in iopoll_list or going
> > >>> through task work. For example, a UBLK_U_IO_FETCH_IO_CMDS command could
> > >>> call io_uring_mshot_cmd_post_cqe() to directly post a CQE. The
> > >>> io_iopoll_check() loop currently only counts completions posted in
> > >>> io_do_iopoll() when determining whether the min_events threshold has
> > >>> been met. It also exits early if there are any existing CQEs before
> > >>> polling, or if any CQEs are posted while running task work. CQEs posted
> > >>> via io_uring_mshot_cmd_post_cqe() or other mechanisms won't be counted
> > >>> against min_events.
> > >>>
> > >>> Explicitly check the available CQEs in each io_iopoll_check() loop
> > >>> iteration to account for CQEs posted in any fashion.
> > >>>
> > >>> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > >>> ---
> > >>>  io_uring/io_uring.c | 9 ++-------
> > >>>  1 file changed, 2 insertions(+), 7 deletions(-)
> > >>>
> > >>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > >>> index 46f39831d27c..b4625695bb3a 100644
> > >>> --- a/io_uring/io_uring.c
> > >>> +++ b/io_uring/io_uring.c
> > >>> @@ -1184,11 +1184,10 @@ __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
> > >>>               io_move_task_work_from_local(ctx);
> > >>>  }
> > >>>
> > >>>  static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
> > >>>  {
> > >>> -     unsigned int nr_events = 0;
> > >>>       unsigned long check_cq;
> > >>>
> > >>>       min_events = min(min_events, ctx->cq_entries);
> > >>>
> > >>>       lockdep_assert_held(&ctx->uring_lock);
> > >>> @@ -1227,34 +1226,30 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
> > >>>                * the poll to the issued list. Otherwise we can spin here
> > >>>                * forever, while the workqueue is stuck trying to acquire the
> > >>>                * very same mutex.
> > >>>                */
> > >>>               if (list_empty(&ctx->iopoll_list) || io_task_work_pending(ctx)) {
> > >>> -                     u32 tail = ctx->cached_cq_tail;
> > >>> -
> > >>>                       (void) io_run_local_work_locked(ctx, min_events);
> > >>>
> > >>>                       if (task_work_pending(current) || list_empty(&ctx->iopoll_list)) {
> > >>>                               mutex_unlock(&ctx->uring_lock);
> > >>>                               io_run_task_work();
> > >>>                               mutex_lock(&ctx->uring_lock);
> > >>>                       }
> > >>>                       /* some requests don't go through iopoll_list */
> > >>> -                     if (tail != ctx->cached_cq_tail || list_empty(&ctx->iopoll_list))
> > >>> +                     if (list_empty(&ctx->iopoll_list))
> > >>>                               break;
> > >>>               }
> > >>>               ret = io_do_iopoll(ctx, !min_events);
> > >>>               if (unlikely(ret < 0))
> > >>>                       return ret;
> > >>>
> > >>>               if (task_sigpending(current))
> > >>>                       return -EINTR;
> > >>>               if (need_resched())
> > >>>                       break;
> > >>> -
> > >>> -             nr_events += ret;
> > >>> -     } while (nr_events < min_events);
> > >>> +     } while (io_cqring_events(ctx) < min_events);
> > >>
> > >> Before entering the loop, if io_cqring_events() finds any queued CQE,
> > >> io_iopoll_check() returns immediately without polling.
> > >>
> > >> If the queued CQE is originated from non-iopoll uring_cmd, iopoll request
> > >> will not be polled, may this be one issue?
> > >
> > > I also noticed that logic and thought it seemed odd. I would think
> > > we'd always want to wait for min_events CQEs (and iopoll once even if
> > > min_events is 0). Looks like Jens added the early return in commit
> > > a3a0e43fd770 ("io_uring: don't enter poll loop if we have CQEs
> > > pending"), perhaps he can shed some light on it?
> >
> > I don't  recall the bug in question, it's been a while... But it always
> > makes sense to return events that are ready, and skip polling. It should
> > only be done if there are no ready events to reap.
> 
> Ming, are you okay with preserving that behavior in this patch then? I
> guess there's a potential fairness concern where REQ_F_IOPOLL requests
> may not be polled for some time if non-REQ_F_IOPOLL requests continue
> to frequently post CQEs.

IMO, the fairness may not a big deal given userspace should keep polling
if the iopoll IO isn't done.

But forget to mention, if non-iopoll CQE is posted and ->cq_flush becomes
true, io_submit_flush_completions() may not get chance to run in case of
the early return. 

Maybe something like below is needed:

@@ -1556,8 +1556,10 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
         * If we do, we can potentially be spinning for commands that
         * already triggered a CQE (eg in error).
         */
-       if (io_cqring_events(ctx))
+       if (io_cqring_events(ctx)) {
+               io_submit_flush_completions(ctx);
                return 0;
+       }



Thanks,
Ming


