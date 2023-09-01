Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E060D78F6E5
	for <lists+io-uring@lfdr.de>; Fri,  1 Sep 2023 03:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244108AbjIAB5z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Aug 2023 21:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbjIAB5y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Aug 2023 21:57:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C3EE6E
        for <io-uring@vger.kernel.org>; Thu, 31 Aug 2023 18:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693533425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hGTlLE4GbRfg92inaxAbNFTpkzSFszG9W5O+dVH7Flo=;
        b=eiS/fhjsXSwCXK0MIBIeNs9rmqoi10DIgcI6XX5aHW0URu/1m79EqZQQPa92XiZtd0ie2u
        u+6qj8xe/nwGUuX36ANxFNID2/s6sylrZerTKL6CQa3d7XCSvRnbyt0xkEzSYFIDU/8FCt
        Bbpes8/6nd2bA1iYLXe6BUpCoyenghw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-458-y3dyoyi-PBqN5jCZx9Ra6A-1; Thu, 31 Aug 2023 21:57:00 -0400
X-MC-Unique: y3dyoyi-PBqN5jCZx9Ra6A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE93E803F3A;
        Fri,  1 Sep 2023 01:56:59 +0000 (UTC)
Received: from fedora (unknown [10.72.120.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 147AE2166B25;
        Fri,  1 Sep 2023 01:56:55 +0000 (UTC)
Date:   Fri, 1 Sep 2023 09:56:47 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Message-ID: <ZPFE3+vOI/Wm7/3e@fedora>
References: <20230831074221.2309565-1-ming.lei@redhat.com>
 <9353345b-bf34-4ee9-a81f-3c58e7e0e68c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9353345b-bf34-4ee9-a81f-3c58e7e0e68c@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 31, 2023 at 11:59:42AM -0600, Jens Axboe wrote:
> On 8/31/23 1:42 AM, Ming Lei wrote:
> > @@ -3313,11 +3323,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
> >  	atomic_inc(&tctx->in_cancel);
> >  	do {
> >  		bool loop = false;
> > +		bool wq_cancelled;
> 
> Minor nit, but io_uring generally uses US spelling, so this should be
> wq_canceled.

OK.

> 
> >  
> >  		io_uring_drop_tctx_refs(current);
> >  		/* read completions before cancelations */
> >  		inflight = tctx_inflight(tctx, !cancel_all);
> > -		if (!inflight)
> > +		if (!inflight && !tctx->io_wq)
> >  			break;
> 
> Not sure I follow this one, is it just for checking of io_wq was ever
> setup? How could it not be?

Here if we have io_wq, all requests in io_wq have to be canceled no
matter if inflight is zero or not because tctx_inflight(tctx, true)
doesn't track FIXED_FILE IOs, but there still can be such IOs in io_wq.

> 
> > -		if (loop) {
> > +		if (!wq_cancelled || (inflight && loop)) {
> >  			cond_resched();
> >  			continue;
> >  		}
> 
> And this one is a bit puzzling to me too - if we didn't cancel anything
> but don't have anything inflight, why are we looping? Should it be
> something ala:
> 
> if (inflight && (!wq_cancelled || loop)) {

There can be FIXED_FILE IOs in io_wq even though inflight is zero.


Thanks,
Ming

