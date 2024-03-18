Return-Path: <io-uring+bounces-1089-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68B1A87E3D8
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 08:00:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D01101F21729
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 07:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72804208AD;
	Mon, 18 Mar 2024 06:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RXSf645c"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833B61CA89
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 06:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710745197; cv=none; b=Wky3MJlgAWHTh2guASg3gP3fJ4ir5QudTbcrZKy3xLi2AhHS3RZj7nt3wix7qjTQ7SRiSf22gYYrMz29Vm+1ygIT21w6kEzL0XLTGSpr8dpdOr3SauyRMnNQ+URvMAh208B/mSM73YDH4Ew5r/jOT9HJeFxt5LAUzogt/5rRmr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710745197; c=relaxed/simple;
	bh=wl3/XG5JAIlWJxTNN/fd+QFNCCH72jFS4QT092uYOik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFiYOenuQGFfFG0rb3VNeOzCQojKBqR4+2Oc21iIDY38Pzu/Onoc9sG7VLqKLcfdCuibPCXkkgql2OaYRh0/1n8bNtZr00/Gqx++ReoqtsI+lxsY8Ip/UOTjAsB24D+wWIWALsGUchMm5mE6djHL7dW8YjsECYPeUzGyQplmjR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RXSf645c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710745194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lwWTigDHY4YfpllhhJIyOzsLhhMoCQZ+UCmJ5X7Z9fg=;
	b=RXSf645cPksc0RcSCRyOh4qhv+GRvfO4vxegE/r2WzbLzmGhAWR+CLwhFNZKfEH2Xo35ve
	H3D+9ZKfYJFHlF6SY66HrLhV+zVDQaUG8ny6d5Ksx5HqT0fXaMUvONZQkhrrmvCKszI51W
	pdYs9ydyPVz+uKyceWJEJkjGeA+a2sc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-0jjVWMCEO9GIPFCAxylJRA-1; Mon, 18 Mar 2024 02:59:50 -0400
X-MC-Unique: 0jjVWMCEO9GIPFCAxylJRA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26E4F101A552;
	Mon, 18 Mar 2024 06:59:50 +0000 (UTC)
Received: from fedora (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 883A4492BD0;
	Mon, 18 Mar 2024 06:59:46 +0000 (UTC)
Date: Mon, 18 Mar 2024 14:59:38 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 02/14] io_uring/cmd: fix tw <-> issue_flags conversion
Message-ID: <ZffmWuGsNH/QVC/O@fedora>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <c48a7f3919eecbee0319020fd640e6b3d2e60e5f.1710720150.git.asml.silence@gmail.com>
 <Zfelt6mbVA0moyq6@fedora>
 <e987d48d-09c9-4b7d-9ddc-1d90f15a1bfe@kernel.dk>
 <e2167849-8034-4649-9d35-3ab266c8d0d5@gmail.com>
 <6291a6f9-61e0-4e3f-b070-b61e8764fb63@kernel.dk>
 <ZferOJCWcWoN2Qzf@fedora>
 <ed73a4de-0b3b-4812-8345-40ea7fa39587@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed73a4de-0b3b-4812-8345-40ea7fa39587@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Sun, Mar 17, 2024 at 09:11:27PM -0600, Jens Axboe wrote:
> On 3/17/24 8:47 PM, Ming Lei wrote:
> > On Sun, Mar 17, 2024 at 08:40:59PM -0600, Jens Axboe wrote:
> >> On 3/17/24 8:32 PM, Pavel Begunkov wrote:
> >>> On 3/18/24 02:25, Jens Axboe wrote:
> >>>> On 3/17/24 8:23 PM, Ming Lei wrote:
> >>>>> On Mon, Mar 18, 2024 at 12:41:47AM +0000, Pavel Begunkov wrote:
> >>>>>> !IO_URING_F_UNLOCKED does not translate to availability of the deferred
> >>>>>> completion infra, IO_URING_F_COMPLETE_DEFER does, that what we should
> >>>>>> pass and look for to use io_req_complete_defer() and other variants.
> >>>>>>
> >>>>>> Luckily, it's not a real problem as two wrongs actually made it right,
> >>>>>> at least as far as io_uring_cmd_work() goes.
> >>>>>>
> >>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >>>>>> Link: https://lore.kernel.org/r/eb08e72e837106963bc7bc7dccfd93d646cc7f36.1710514702.git.asml.silence@gmail.com
> >>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>
> >>> oops, I should've removed all the signed-offs
> >>>
> >>>>>> ---
> >>>>>>   io_uring/uring_cmd.c | 10 ++++++++--
> >>>>>>   1 file changed, 8 insertions(+), 2 deletions(-)
> >>>>>>
> >>>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> >>>>>> index f197e8c22965..ec38a8d4836d 100644
> >>>>>> --- a/io_uring/uring_cmd.c
> >>>>>> +++ b/io_uring/uring_cmd.c
> >>>>>> @@ -56,7 +56,11 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
> >>>>>>   static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
> >>>>>>   {
> >>>>>>       struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> >>>>>> -    unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
> >>>>>> +    unsigned issue_flags = IO_URING_F_UNLOCKED;
> >>>>>> +
> >>>>>> +    /* locked task_work executor checks the deffered list completion */
> >>>>>> +    if (ts->locked)
> >>>>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
> >>>>>>         ioucmd->task_work_cb(ioucmd, issue_flags);
> >>>>>>   }
> >>>>>> @@ -100,7 +104,9 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
> >>>>>>       if (req->ctx->flags & IORING_SETUP_IOPOLL) {
> >>>>>>           /* order with io_iopoll_req_issued() checking ->iopoll_complete */
> >>>>>>           smp_store_release(&req->iopoll_completed, 1);
> >>>>>> -    } else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
> >>>>>> +    } else if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
> >>>>>> +        if (WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED))
> >>>>>> +            return;
> >>>>>>           io_req_complete_defer(req);
> >>>>>>       } else {
> >>>>>>           req->io_task_work.func = io_req_task_complete;
> >>>>>
> >>>>> 'git-bisect' shows the reported warning starts from this patch.
> >>>
> >>> Thanks Ming
> >>>
> >>>>
> >>>> That does make sense, as probably:
> >>>>
> >>>> +    /* locked task_work executor checks the deffered list completion */
> >>>> +    if (ts->locked)
> >>>> +        issue_flags = IO_URING_F_COMPLETE_DEFER;
> >>>>
> >>>> this assumption isn't true, and that would mess with the task management
> >>>> (which is in your oops).
> >>>
> >>> I'm missing it, how it's not true?
> >>>
> >>>
> >>> static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
> >>> {
> >>>     ...
> >>>     if (ts->locked) {
> >>>         io_submit_flush_completions(ctx);
> >>>         ...
> >>>     }
> >>> }
> >>>
> >>> static __cold void io_fallback_req_func(struct work_struct *work)
> >>> {
> >>>     ...
> >>>     mutex_lock(&ctx->uring_lock);
> >>>     llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
> >>>         req->io_task_work.func(req, &ts);
> >>>     io_submit_flush_completions(ctx);
> >>>     mutex_unlock(&ctx->uring_lock);
> >>>     ...
> >>> }
> >>
> >> I took a look too, and don't immediately see it. Those are also the two
> >> only cases I found, and before the patches, looks fine too.
> >>
> >> So no immediate answer there... But I can confirm that before this
> >> patch, test passes fine. With the patch, it goes boom pretty quick.
> >> Either directly off putting the task, or an unrelated memory crash
> >> instead.
> > 
> > In ublk, the translated 'issue_flags' is passed to io_uring_cmd_done()
> > from ioucmd->task_work_cb()(__ublk_rq_task_work()). That might be
> > related with the reason.
> 
> Or maybe ublk is doing multiple invocations of task_work completions? I
> added this:

Yes, your debug log & point does help.

This patch convert zero flag(!IO_URING_F_UNLOCKED) into IO_URING_F_COMPLETE_DEFER,
and somewhere is easily ignored, and follows the fix, which need to be
folded into patch 2.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5d4b448fdc50..22f2b52390a9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3259,7 +3259,8 @@ static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
                        /* ->sqe isn't available if no async data */
                        if (!req_has_async_data(req))
                                cmd->sqe = NULL;
-                       file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL);
+                       file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL |
+                                       IO_URING_F_COMPLETE_DEFER);
                        ret = true;
                }
        }


Thanks,
Ming


