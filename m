Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4002B78FFBC
	for <lists+io-uring@lfdr.de>; Fri,  1 Sep 2023 17:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350149AbjIAPNJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Sep 2023 11:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350138AbjIAPNI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Sep 2023 11:13:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9939B1704
        for <io-uring@vger.kernel.org>; Fri,  1 Sep 2023 08:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693581133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tZBr/LfycIULLeRLnHJSqS4P44rHWJatMTmZFfEhWuo=;
        b=ZlFYuSP4Lwcc4ok/Ha2wCAFnaNBkiJNtbOvbHeUNC58fV3x7Gfm+btVp7h5GqvHMgO5Vpg
        MeA5CInBiA+6cKERT6hfGvcPzSf1FAhsEi7CbF5w3bdx6xVgWPOdNDJbVJw2BZQMR7kjRm
        yZTUSeDHP6+HYNXb5s/X49GEJdbhIag=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-29hmEgLrOD2UA4UMW8PauQ-1; Fri, 01 Sep 2023 11:12:10 -0400
X-MC-Unique: 29hmEgLrOD2UA4UMW8PauQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CEAF923004;
        Fri,  1 Sep 2023 15:12:09 +0000 (UTC)
Received: from fedora (unknown [10.72.120.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5453C83B9B;
        Fri,  1 Sep 2023 15:12:04 +0000 (UTC)
Date:   Fri, 1 Sep 2023 23:12:00 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH V2] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Message-ID: <ZPH/QEXmh3NiY736@fedora>
References: <20230901134916.2415386-1-ming.lei@redhat.com>
 <78ae000c-5704-4f59-bd2a-79e8cbeb9aaa@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78ae000c-5704-4f59-bd2a-79e8cbeb9aaa@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 01, 2023 at 08:47:28AM -0600, Jens Axboe wrote:
> On 9/1/23 7:49 AM, Ming Lei wrote:
> > io_wq_put_and_exit() is called from do_exit(), but all FIXED_FILE requests
> > in io_wq aren't canceled in io_uring_cancel_generic() called from do_exit().
> > Meantime io_wq IO code path may share resource with normal iopoll code
> > path.
> > 
> > So if any HIPRI request is submittd via io_wq, this request may not get resouce
> > for moving on, given iopoll isn't possible in io_wq_put_and_exit().
> > 
> > The issue can be triggered when terminating 't/io_uring -n4 /dev/nullb0'
> > with default null_blk parameters.
> > 
> > Fix it by always cancelling all requests in io_wq by adding helper of
> > io_uring_cancel_wq(), and this way is reasonable because io_wq destroying
> > follows canceling requests immediately.
> 
> This does look much cleaner, but the unconditional cancel_all == true
> makes me a bit nervous in case the ring is being shared.

Here we just cancel requests in io_wq, which is per-task actually.

Yeah, ctx->iopoll_ctx could be shared, but if it is used in this way,
the event can't be avoided to reap from remote context.

> 
> Do we really need to cancel these bits? Can't we get by with something
> trivial like just stopping retrying if the original task is exiting?
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index c6d9e4677073..95316c0c3830 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1939,7 +1939,7 @@ void io_wq_submit_work(struct io_wq_work *work)
>  		 * If REQ_F_NOWAIT is set, then don't wait or retry with
>  		 * poll. -EAGAIN is final for that case.
>  		 */
> -		if (req->flags & REQ_F_NOWAIT)
> +		if (req->flags & REQ_F_NOWAIT || req->task->flags & PF_EXITING)
>  			break;

This way isn't enough, any request submitted to io_wq before do_exit()
need to be reaped by io_iopoll_try_reap_events() explicitly.

Not mention IO_URING_F_NONBLOCK isn't set, so io_issue_sqe() may hang
forever.


Thanks,
Ming

