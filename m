Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD1F79824B
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 08:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjIHGXa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 02:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbjIHGXa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 02:23:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4091BEF
        for <io-uring@vger.kernel.org>; Thu,  7 Sep 2023 23:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694154152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+UXfFIxsVw2h5+OEph1QBomDGEtwA2v/p6/zzV+9LVY=;
        b=R26kiXuMlzxtTqIQNIEnM1/pShpxqR9bTlzIPGdpxUIcCYjbH0s1LlFaboRaPMcxGhCbor
        9pi/ZTdiZqSe6fNBmFTA0upPaxZIsOlOALuCKyJHSRejrzAs2eFQhs3ChjvqH1nZA6dTxh
        oWNJiL0QLAZus22gSZ5ft5/wRX9q76Q=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-zixQwmlfOaCgXScOdQxPzw-1; Fri, 08 Sep 2023 02:22:26 -0400
X-MC-Unique: zixQwmlfOaCgXScOdQxPzw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8621C1C06EC8;
        Fri,  8 Sep 2023 06:22:26 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ADBFC493110;
        Fri,  8 Sep 2023 06:22:22 +0000 (UTC)
Date:   Fri, 8 Sep 2023 14:22:17 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH V2] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Message-ID: <ZPq9mY51e7++cbpC@fedora>
References: <20230901134916.2415386-1-ming.lei@redhat.com>
 <169358121201.335729.4270950770834703042.b4-ty@kernel.dk>
 <f6be40a3-38de-41ed-a545-d9063379f8e2@kernel.dk>
 <ffbe8a96-9f3e-9139-07c6-9bbf863185ed@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffbe8a96-9f3e-9139-07c6-9bbf863185ed@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 08, 2023 at 02:03:11AM +0100, Pavel Begunkov wrote:
> On 9/7/23 16:36, Jens Axboe wrote:
> > On 9/1/23 9:13 AM, Jens Axboe wrote:
> > > 
> > > On Fri, 01 Sep 2023 21:49:16 +0800, Ming Lei wrote:
> > > > io_wq_put_and_exit() is called from do_exit(), but all FIXED_FILE requests
> > > > in io_wq aren't canceled in io_uring_cancel_generic() called from do_exit().
> > > > Meantime io_wq IO code path may share resource with normal iopoll code
> > > > path.
> > > > 
> > > > So if any HIPRI request is submittd via io_wq, this request may not get resouce
> > > > for moving on, given iopoll isn't possible in io_wq_put_and_exit().
> > > > > > [...]
> > > 
> > > Applied, thanks!
> > > 
> > > [1/1] io_uring: fix IO hang in io_wq_put_and_exit from do_exit()
> > >        commit: b484a40dc1f16edb58e5430105a021e1916e6f27
> > 
> > This causes a regression with the test/thread-exit.t test case, as it's
> > canceling requests from other tasks as well. I will drop this patch for
> > now.
> 
> And this one has never hit my mailbox... Anyway, I'm confused with
> the issue:
> 
> 1) request tracking is done only for io_uring polling io_uring, which

request tracking isn't done on FIXED_FILE IO, which is used by t/io_uring.

> shouldn't be the case for t/io_uring, so it's probably unrelated?

So io_uring_try_cancel_requests() won't be called because
tctx_inflight() returns zero.

> 
> 2) In case of iopoll, io-wq only submits a request but doesn't wait/poll
> for it. If io_issue_sqe() returned -EAGAIN or an error, the request is
> considered not yet submitted to block and can be just cancelled normally
> without any dancing like io_iopoll_try_reap_events().

io_issue_sqe() may never return since IO_URING_F_NONBLOCK isn't set
for iopoll, and recently polled IO doesn't imply nowait in commit
2bc057692599 ("block: don't make REQ_POLLED imply REQ_NOWAIT"), this
commit is actually fragile, cause it is easy to cause io hang if
iopoll & submission is done in same context.

This one should be easy to address, either the following change
or revert 2bc057692599 ("block: don't make REQ_POLLED imply
REQ_NOWAIT").

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ad636954abae..d8419689ad3e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1930,6 +1930,9 @@ void io_wq_submit_work(struct io_wq_work *work)
                }
        }

+       if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
+               issue_flags |= IO_URING_F_NONBLOCK;
+
        do {
                ret = io_issue_sqe(req, issue_flags);
                if (ret != -EAGAIN)

> 
> 
> 3) If we condense the code it sounds like it effectively will be
> like this:
> 
> void io_wq_exit_start(struct io_wq *wq)
> {
> 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
> }
> 
> io_uring_cancel_generic()
> {
> 	if (tctx->io_wq)
> 		io_wq_exit_start(tctx->io_wq);
> 	io_uring_clean_tctx(tctx);
> 	...
> }
> 
> We set the flag, interrupt workers (TIF_NOTIFY_SIGNAL + wake up), and
> wait for them. Workers are woken up (or just return), see
> the flag and return. At least that's how it was intended to work.
> 
> What's missing? Racing for IO_WQ_BIT_EXIT? Not breaking on IO_WQ_BIT_EXIT
> correctly? Not honouring / clearing TIF_NOTIFY_SIGNAL?
> 
> I'll try to repro later

After applying your patch of 9256b9371204 ("io_uring: break out of iowq
iopoll on teardown") and the above patch, the issue still can be triggered,
and the worker is keeping to call io_issue_sqe() for ever, and
io_wq_worker_stopped() returns false. So do_exit() isn't called on
t/io_uring pthread yet, meantime I guess either iopoll is terminated or not
get chance to run.


Thanks,
Ming

