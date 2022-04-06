Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41E04F5D2D
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 14:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbiDFMFG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 08:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbiDFMEI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 08:04:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8CD12DFD40
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 19:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649210999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LJiWQIvRQ5wTfWE3+Ak81ps9bDVIYTrzrfCvrgb2WRU=;
        b=UKBZQsLBj2D2z1N/BPqZL0LixE0fmSvNdfZ8LQtjnIVK9mfC7tU5ObBjxzy38Vt1/BA+E7
        e382IZtymQ4XJPO1v5LGcwz2ErmlwOm2Jqq7Y4DcBJ0uh6lzJXrjMK1e3OOXJnWQsXZqYo
        X6ugprJDDRXikz8/4Y0+HzRLqH7Rb9g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-xMShxLWFOfa4Z4tKieKgNQ-1; Tue, 05 Apr 2022 22:09:55 -0400
X-MC-Unique: xMShxLWFOfa4Z4tKieKgNQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D2F7805F46;
        Wed,  6 Apr 2022 02:09:55 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BB1A492C14;
        Wed,  6 Apr 2022 02:09:49 +0000 (UTC)
Date:   Wed, 6 Apr 2022 10:09:44 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Mike Snitzer <snitzer@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [RFC PATCH] io_uring: reissue in case -EAGAIN is returned after
 io issue returns
Message-ID: <Ykz2aF3VgyyVG46m@T590>
References: <20220403114532.180945-1-ming.lei@redhat.com>
 <YksiEk+G5QuPG6o8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YksiEk+G5QuPG6o8@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 04, 2022 at 12:51:30PM -0400, Mike Snitzer wrote:
> On Sun, Apr 03 2022 at  7:45P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > -EAGAIN still may return after io issue returns, and REQ_F_REISSUE is
> > set in io_complete_rw_iopoll(), but the req never gets chance to be handled.
> > io_iopoll_check doesn't handle this situation, and io hang can be caused.
> > 
> > Current dm io polling may return -EAGAIN after bio submission is
> > returned, also blk-throttle might trigger this situation too.
> > 
> > Cc: Mike Snitzer <snitzer@kernel.org>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> I first reverted commit 5291984004ed ("dm: fix bio polling to handle
> possibile BLK_STS_AGAIN") then applied this patch and verified this
> fixes the DM bio polling hangs.  Nice work!
> 
> But interestingly with this fio test (against dm-linear ontop of
> null_blk with queue_mode=2 submit_queues=8 poll_queues=2 bs=4096 gb=16):
> 
> fio --bs=4096 --ioengine=io_uring --fixedbufs --registerfiles --hipri=1 \
> --iodepth=16 --iodepth_batch_submit=16 --iodepth_batch_complete_min=16 \
> --filename=/dev/mapper/linear --direct=1 --runtime=20 --numjobs=16 \
> --rw=randread --name=test --group_reporting --norandommap

16jobs in io_uring/aio test is overkill.

> 
> I get 3186k IOPS with your patch to have io_uring retry (and commit
> 5291984004ed reverted), but 4305k IOPS if leave commit 5291984004ed
> applied (and DM resorts to retrying any -EAGAIN _without_ polling).

IMO, commit 5291984004ed shouldn't be reverted, which is reasonable to
retry on underlying IO for dm.

This patch is for making io_uring more reliable, since the current
io_uring code only handles -EAGAIN from submission code path, and
-EAGAIN/REISSUE isn't handled if it is returned during ->poll(),
then the io hang is caused.

Jens, what do you think of this patch? Does io_uring need to handle
-EAGAIN in this case?

> 
> Jens rightly pointed out to me that polling tests that exhaust tags
> are bogus anyway (because such unbounded IO defeats the point of
> polling).  Jens also thinks my result, with commit 5291984004ed
> applied, is somehow bogus and not to be trusted ;)  He is very likely
> correct, and the failing likely in the null_blk driver -- I'm
> skeptical of that driver given it cannot pass fio verify testing
> (e.g. --do_verify=1 --verify=crc32c --verify_async=1) with or without
> polling.

Because it is null block...

> 
> Review comments inlined below.
> 
> > ---
> >  fs/io-wq.h    |  13 +++++
> >  fs/io_uring.c | 128 ++++++++++++++++++++++++++++----------------------
> >  2 files changed, 86 insertions(+), 55 deletions(-)
> > 
> > diff --git a/fs/io-wq.h b/fs/io-wq.h
> > index dbecd27656c7..4ca4863664fb 100644
> > --- a/fs/io-wq.h
> > +++ b/fs/io-wq.h
> > @@ -96,6 +96,19 @@ static inline void wq_list_add_head(struct io_wq_work_node *node,
> >  	WRITE_ONCE(list->first, node);
> >  }
> >  
> > +static inline void wq_list_remove(struct io_wq_work_list *list,
> > +				  struct io_wq_work_node *prev,
> > +				  struct io_wq_work_node *node)
> > +{
> > +	if (!prev)
> > +		WRITE_ONCE(list->first, node->next);
> > +	else
> > +		prev->next = node->next;
> > +
> > +	if (node == list->last)
> > +		list->last = prev;
> > +}
> > +
> >  static inline void wq_list_cut(struct io_wq_work_list *list,
> >  			       struct io_wq_work_node *last,
> >  			       struct io_wq_work_node *prev)
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 59e54a6854b7..6db5514e10ca 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -2759,6 +2759,65 @@ static inline bool io_run_task_work(void)
> >  	return false;
> >  }
> >  
> > +#ifdef CONFIG_BLOCK
> > +static bool io_resubmit_prep(struct io_kiocb *req)
> > +{
> > +	struct io_async_rw *rw = req->async_data;
> > +
> > +	if (!req_has_async_data(req))
> > +		return !io_req_prep_async(req);
> > +	iov_iter_restore(&rw->s.iter, &rw->s.iter_state);
> > +	return true;
> > +}
> > +
> > +static bool io_rw_should_reissue(struct io_kiocb *req)
> > +{
> > +	umode_t mode = file_inode(req->file)->i_mode;
> > +	struct io_ring_ctx *ctx = req->ctx;
> > +
> > +	if (!S_ISBLK(mode) && !S_ISREG(mode))
> > +		return false;
> > +	if ((req->flags & REQ_F_NOWAIT) || (io_wq_current_is_worker() &&
> > +	    !(ctx->flags & IORING_SETUP_IOPOLL)))
> > +		return false;
> > +	/*
> > +	 * If ref is dying, we might be running poll reap from the exit work.
> > +	 * Don't attempt to reissue from that path, just let it fail with
> > +	 * -EAGAIN.
> > +	 */
> > +	if (percpu_ref_is_dying(&ctx->refs))
> > +		return false;
> > +	/*
> > +	 * Play it safe and assume not safe to re-import and reissue if we're
> > +	 * not in the original thread group (or in task context).
> > +	 */
> > +	if (!same_thread_group(req->task, current) || !in_task())
> > +		return false;
> > +	return true;
> > +}
> > +#else
> > +static bool io_resubmit_prep(struct io_kiocb *req)
> > +{
> > +	return false;
> > +}
> > +static bool io_rw_should_reissue(struct io_kiocb *req)
> > +{
> > +	return false;
> > +}
> > +#endif
> > +
> > +static void do_io_reissue(struct io_kiocb *req, int ret)
> > +{
> > +	if (req->flags & REQ_F_REISSUE) {
> > +		req->flags &= ~REQ_F_REISSUE;
> > +		if (io_resubmit_prep(req))
> > +			io_req_task_queue_reissue(req);
> > +		else
> > +			io_req_task_queue_fail(req, ret);
> > +	}
> > +}
> 
> Minor nit but: I'd leave caller to check for REQ_F_REISSUE.
> 
> > +
> > +
> >  static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
> >  {
> >  	struct io_wq_work_node *pos, *start, *prev;
> > @@ -2786,6 +2845,13 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
> >  		if (READ_ONCE(req->iopoll_completed))
> >  			break;
> >  
> > +		/*
> > +		 * Once REISSUE flag is set, the req has been done, and we
> > +		 * have to retry
> > +		 */
> > +		if (req->flags & REQ_F_REISSUE)
> > +			break;
> > +
> >  		ret = kiocb->ki_filp->f_op->iopoll(kiocb, &iob, poll_flags);
> >  		if (unlikely(ret < 0))
> >  			return ret;
> > @@ -2807,6 +2873,12 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
> >  	wq_list_for_each_resume(pos, prev) {
> >  		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
> >  
> > +		if (req->flags & REQ_F_REISSUE) {
> > +			wq_list_remove(&ctx->iopoll_list, prev, pos);
> > +			do_io_reissue(req, -EIO);
> > +			break;
> > +		}
> > +
> 
> That way you'll avoid redundant checks for REQ_F_REISSUE here.

Another do_io_reissue() needn't to remove req from ->iopoll_list, that
is why the check is done here.


Thanks,
Ming

