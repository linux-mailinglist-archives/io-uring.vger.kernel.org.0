Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B414F6929
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 20:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237378AbiDFSOx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 14:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbiDFSOn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 14:14:43 -0400
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67549228AA5
        for <io-uring@vger.kernel.org>; Wed,  6 Apr 2022 09:52:13 -0700 (PDT)
Received: by mail-qt1-f180.google.com with SMTP id s7so5319225qtk.6
        for <io-uring@vger.kernel.org>; Wed, 06 Apr 2022 09:52:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0UyyMFvWOCB2BNkoIAffwKLA75E1qzGUQJVZnjoP6F8=;
        b=GJdF1pnHHYQscsfvX1ddksWce2EIntXTbp/7ch1zuQE9A+T83GKFQz6JXA+N16AyLR
         ENRDNZCJ9oKjBI4orEYao0hrq25+YbSUMgIj/u58XlM2PtRb4Y8E3IeccB2APCAOQTsC
         mRmZBvAXj4kKZ4IUBEr+7hwB9++Cxteg/GgIA3trgllZ3ih0CoJ42Q77M9+B+hniniEM
         XvssqJ//PdRJC93/zXI668OQcDpCFBC/34XL/MdA0fMIssH/a8JudpRYkjXzzEv2w5gm
         fduil3Kdn9QNlrI5PKDY2DXxvzU8ffUKm/q8Va8dLoFwwMYCff3MN9mFvYDHSgCnvqcq
         +Oxg==
X-Gm-Message-State: AOAM530dR8Q1b8G+5oudtDKpH3D/eX4bRGz5vS4UzggPLehKyOO00bvK
        4MFm38oowAn7UrS1scQnl8XH
X-Google-Smtp-Source: ABdhPJxeGr9pRX+lQAkLZarPV0vNTSLVDiqNubmN+iUnTP6n78OWHiePsV1tyro38o409L4WN4X5aQ==
X-Received: by 2002:ac8:5a4f:0:b0:2e1:a7be:2d13 with SMTP id o15-20020ac85a4f000000b002e1a7be2d13mr8247436qta.598.1649263932461;
        Wed, 06 Apr 2022 09:52:12 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id k13-20020a05622a03cd00b002e21621c243sm14231183qtx.39.2022.04.06.09.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 09:52:12 -0700 (PDT)
Date:   Wed, 6 Apr 2022 12:52:11 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: Re: [RFC PATCH] io_uring: reissue in case -EAGAIN is returned after
 io issue returns
Message-ID: <Yk3FO6r59nTrDuiS@redhat.com>
References: <20220403114532.180945-1-ming.lei@redhat.com>
 <YksiEk+G5QuPG6o8@redhat.com>
 <Ykz2aF3VgyyVG46m@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ykz2aF3VgyyVG46m@T590>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Apr 05 2022 at 10:09P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> On Mon, Apr 04, 2022 at 12:51:30PM -0400, Mike Snitzer wrote:
> > On Sun, Apr 03 2022 at  7:45P -0400,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > -EAGAIN still may return after io issue returns, and REQ_F_REISSUE is
> > > set in io_complete_rw_iopoll(), but the req never gets chance to be handled.
> > > io_iopoll_check doesn't handle this situation, and io hang can be caused.
> > > 
> > > Current dm io polling may return -EAGAIN after bio submission is
> > > returned, also blk-throttle might trigger this situation too.
> > > 
> > > Cc: Mike Snitzer <snitzer@kernel.org>
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > 
> > I first reverted commit 5291984004ed ("dm: fix bio polling to handle
> > possibile BLK_STS_AGAIN") then applied this patch and verified this
> > fixes the DM bio polling hangs.  Nice work!
> > 
> > But interestingly with this fio test (against dm-linear ontop of
> > null_blk with queue_mode=2 submit_queues=8 poll_queues=2 bs=4096 gb=16):
> > 
> > fio --bs=4096 --ioengine=io_uring --fixedbufs --registerfiles --hipri=1 \
> > --iodepth=16 --iodepth_batch_submit=16 --iodepth_batch_complete_min=16 \
> > --filename=/dev/mapper/linear --direct=1 --runtime=20 --numjobs=16 \
> > --rw=randread --name=test --group_reporting --norandommap
> 
> 16jobs in io_uring/aio test is overkill.

Sure, it is.. I was just exhausting driver resources.. could fiddle
with it so that it exhausts quickly with even a single thread.

Besides the point really.

> > I get 3186k IOPS with your patch to have io_uring retry (and commit
> > 5291984004ed reverted), but 4305k IOPS if leave commit 5291984004ed
> > applied (and DM resorts to retrying any -EAGAIN _without_ polling).
> 
> IMO, commit 5291984004ed shouldn't be reverted, which is reasonable to
> retry on underlying IO for dm.

Right, I wasn't saying commit 5291984004ed should be reverted.  But I
was testing to see if your patch covered the case commit 5291984004ed
handles.

Note that the DM retry isn't in terms of polling though, polling gets
disabled when the bio is requeued to DM.

> This patch is for making io_uring more reliable, since the current
> io_uring code only handles -EAGAIN from submission code path, and
> -EAGAIN/REISSUE isn't handled if it is returned during ->poll(),
> then the io hang is caused.
> 
> Jens, what do you think of this patch? Does io_uring need to handle
> -EAGAIN in this case?
> 
> > 
> > Jens rightly pointed out to me that polling tests that exhaust tags
> > are bogus anyway (because such unbounded IO defeats the point of
> > polling).  Jens also thinks my result, with commit 5291984004ed
> > applied, is somehow bogus and not to be trusted ;)  He is very likely
> > correct, and the failing likely in the null_blk driver -- I'm
> > skeptical of that driver given it cannot pass fio verify testing
> > (e.g. --do_verify=1 --verify=crc32c --verify_async=1) with or without
> > polling.
> 
> Because it is null block...

Ha, yes.. very good point. I was expecting null_blk capability (read
back written data) that it was never intended to provide. Sorry ;)

> > 
> > Review comments inlined below.
> > 
> > > ---
> > >  fs/io-wq.h    |  13 +++++
> > >  fs/io_uring.c | 128 ++++++++++++++++++++++++++++----------------------
> > >  2 files changed, 86 insertions(+), 55 deletions(-)
> > > 
> > > diff --git a/fs/io-wq.h b/fs/io-wq.h
> > > index dbecd27656c7..4ca4863664fb 100644
> > > --- a/fs/io-wq.h
> > > +++ b/fs/io-wq.h
> > > @@ -96,6 +96,19 @@ static inline void wq_list_add_head(struct io_wq_work_node *node,
> > >  	WRITE_ONCE(list->first, node);
> > >  }
> > >  
> > > +static inline void wq_list_remove(struct io_wq_work_list *list,
> > > +				  struct io_wq_work_node *prev,
> > > +				  struct io_wq_work_node *node)
> > > +{
> > > +	if (!prev)
> > > +		WRITE_ONCE(list->first, node->next);
> > > +	else
> > > +		prev->next = node->next;
> > > +
> > > +	if (node == list->last)
> > > +		list->last = prev;
> > > +}
> > > +
> > >  static inline void wq_list_cut(struct io_wq_work_list *list,
> > >  			       struct io_wq_work_node *last,
> > >  			       struct io_wq_work_node *prev)
> > > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > > index 59e54a6854b7..6db5514e10ca 100644
> > > --- a/fs/io_uring.c
> > > +++ b/fs/io_uring.c
> > > @@ -2759,6 +2759,65 @@ static inline bool io_run_task_work(void)
> > >  	return false;
> > >  }
> > >  
> > > +#ifdef CONFIG_BLOCK
> > > +static bool io_resubmit_prep(struct io_kiocb *req)
> > > +{
> > > +	struct io_async_rw *rw = req->async_data;
> > > +
> > > +	if (!req_has_async_data(req))
> > > +		return !io_req_prep_async(req);
> > > +	iov_iter_restore(&rw->s.iter, &rw->s.iter_state);
> > > +	return true;
> > > +}
> > > +
> > > +static bool io_rw_should_reissue(struct io_kiocb *req)
> > > +{
> > > +	umode_t mode = file_inode(req->file)->i_mode;
> > > +	struct io_ring_ctx *ctx = req->ctx;
> > > +
> > > +	if (!S_ISBLK(mode) && !S_ISREG(mode))
> > > +		return false;
> > > +	if ((req->flags & REQ_F_NOWAIT) || (io_wq_current_is_worker() &&
> > > +	    !(ctx->flags & IORING_SETUP_IOPOLL)))
> > > +		return false;
> > > +	/*
> > > +	 * If ref is dying, we might be running poll reap from the exit work.
> > > +	 * Don't attempt to reissue from that path, just let it fail with
> > > +	 * -EAGAIN.
> > > +	 */
> > > +	if (percpu_ref_is_dying(&ctx->refs))
> > > +		return false;
> > > +	/*
> > > +	 * Play it safe and assume not safe to re-import and reissue if we're
> > > +	 * not in the original thread group (or in task context).
> > > +	 */
> > > +	if (!same_thread_group(req->task, current) || !in_task())
> > > +		return false;
> > > +	return true;
> > > +}
> > > +#else
> > > +static bool io_resubmit_prep(struct io_kiocb *req)
> > > +{
> > > +	return false;
> > > +}
> > > +static bool io_rw_should_reissue(struct io_kiocb *req)
> > > +{
> > > +	return false;
> > > +}
> > > +#endif
> > > +
> > > +static void do_io_reissue(struct io_kiocb *req, int ret)
> > > +{
> > > +	if (req->flags & REQ_F_REISSUE) {
> > > +		req->flags &= ~REQ_F_REISSUE;
> > > +		if (io_resubmit_prep(req))
> > > +			io_req_task_queue_reissue(req);
> > > +		else
> > > +			io_req_task_queue_fail(req, ret);
> > > +	}
> > > +}
> > 
> > Minor nit but: I'd leave caller to check for REQ_F_REISSUE.
> > 
> > > +
> > > +
> > >  static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
> > >  {
> > >  	struct io_wq_work_node *pos, *start, *prev;
> > > @@ -2786,6 +2845,13 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
> > >  		if (READ_ONCE(req->iopoll_completed))
> > >  			break;
> > >  
> > > +		/*
> > > +		 * Once REISSUE flag is set, the req has been done, and we
> > > +		 * have to retry
> > > +		 */
> > > +		if (req->flags & REQ_F_REISSUE)
> > > +			break;
> > > +
> > >  		ret = kiocb->ki_filp->f_op->iopoll(kiocb, &iob, poll_flags);
> > >  		if (unlikely(ret < 0))
> > >  			return ret;
> > > @@ -2807,6 +2873,12 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
> > >  	wq_list_for_each_resume(pos, prev) {
> > >  		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
> > >  
> > > +		if (req->flags & REQ_F_REISSUE) {
> > > +			wq_list_remove(&ctx->iopoll_list, prev, pos);
> > > +			do_io_reissue(req, -EIO);
> > > +			break;
> > > +		}
> > > +
> > 
> > That way you'll avoid redundant checks for REQ_F_REISSUE here.
> 
> Another do_io_reissue() needn't to remove req from ->iopoll_list, that
> is why the check is done here.

All do_io_reissue callers would need to first check for REQ_F_REISSUE,
but my point (purely about avoiding redundant checks) is moot if this
patch isn't safe.

Mike
