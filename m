Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257BD6C898D
	for <lists+io-uring@lfdr.de>; Sat, 25 Mar 2023 01:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCYAZH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 20:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjCYAZG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 20:25:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D4115170
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 17:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679703858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n3U7R2w0+0tju6eCRynlAzXWJMScWwbctIakkVGel4M=;
        b=IlyFCZ+YqaDurnYliMYeSSwIc7l0qPvZZscRLElu2z0DJVGeg+x+dL1KAFtUfCfYQ3Jmjn
        aWT8VzSObt4b5IUK+Gv9NLg3fnx1kvTXxg9ZpSFBF1SYZzcAeF05OP7o81UJ1a/qPY14Ro
        Ii/E1+1qSjkP87nX76U6SaWJ5BbeO20=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-R0QrZbk9MSmew2Qilm2_KQ-1; Fri, 24 Mar 2023 20:24:16 -0400
X-MC-Unique: R0QrZbk9MSmew2Qilm2_KQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A74CE1C0898E;
        Sat, 25 Mar 2023 00:24:16 +0000 (UTC)
Received: from ovpn-8-20.pek2.redhat.com (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC5BA40CF916;
        Sat, 25 Mar 2023 00:24:13 +0000 (UTC)
Date:   Sat, 25 Mar 2023 08:24:08 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>, ming.lei@redhat.com
Subject: Re: [PATCH] io_uring/rw: transform single vector readv/writev into
 ubuf
Message-ID: <ZB4/KLT6XGBPCeYD@ovpn-8-20.pek2.redhat.com>
References: <43cb1fb7-b30b-8df1-bba6-e50797d680c6@kernel.dk>
 <ZB4nJStBSrPR9SYk@ovpn-8-20.pek2.redhat.com>
 <9c3473b7-8063-4d14-1f8b-7a0e67979cf4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c3473b7-8063-4d14-1f8b-7a0e67979cf4@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 24, 2023 at 05:06:00PM -0600, Jens Axboe wrote:
> On 3/24/23 4:41?PM, Ming Lei wrote:
> > On Fri, Mar 24, 2023 at 08:35:38AM -0600, Jens Axboe wrote:
> >> It's very common to have applications that use vectored reads or writes,
> >> even if they only pass in a single segment. Obviously they should be
> >> using read/write at that point, but...
> > 
> > Yeah, it is like fixing application issue in kernel side, :-)
> 
> It totally is, the same thing happens all of the time for readv as well.
> No amount of informing or documenting will ever fix that...
> 
> Also see:
> 
> https://lore.kernel.org/linux-fsdevel/20230324204443.45950-1-axboe@kernel.dk/
> 
> with which I think I'll change this one to just be:
> 
> 	if (iter->iter_type == ITER_UBUF) {
> 		rw->addr = iter->ubuf;
> 		rw->len = iter->count;
> 	/* readv -> read distance is the same as writev -> write */
> 	BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
> 			(IORING_OP_WRITE - IORING_OP_WRITEV));
> 		req->opcode += (IORING_OP_READ - IORING_OP_READV);
> 	}
> 
> instead.
> 
> We could also just skip it completely and just have liburing do the
> right thing if io_uring_prep_readv/writev is called with nr_segs == 1.
> Just turn it into a READ/WRITE at that point. If we do that, and with
> the above generic change, it's probably Good Enough. If you use
> READV/WRITEV and you're using the raw interface, then you're on your
> own.
> 
> >> +	rw->addr = (unsigned long) iter->iov[0].iov_base;
> >> +	rw->len = iter->iov[0].iov_len;
> >> +	iov_iter_ubuf(iter, ddir, iter->iov[0].iov_base, rw->len);
> >> +	/* readv -> read distance is the same as writev -> write */
> >> +	BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
> >> +			(IORING_OP_WRITE - IORING_OP_WRITEV));
> >> +	req->opcode += (IORING_OP_READ - IORING_OP_READV);
> > 
> > It is a bit fragile to change ->opcode, which may need matched
> > callbacks for the two OPs, also cause inconsistent opcode in traces.
> > 
> > I am wondering why not play the magic in io_prep_rw() from beginning?
> 
> It has to be done when importing the vec, we cannot really do it in
> prep... Well we could, but that'd be adding a bunch more code and
> duplicating part of the vec import.

I meant something like the following(un-tested), which at least
guarantees that op_code, rw->addr/len are finalized since ->prep().

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0c292ef9a40f..4bf4c3effdac 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -120,6 +120,25 @@ int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return ret;
 	}
 
+	if (req->opcode == IORING_OP_READV && req->opcode == IORING_OP_WRITEV &&
+			rw->len == 1) {
+		struct iovec iov;
+		struct iovec *iovp;
+
+		iovp = iovec_from_user(u64_to_user_ptr(rw->addr), 1, 1, &iov,
+					req->ctx->compat);
+		if (IS_ERR(iovp))
+			return PTR_ERR(iovp);
+
+		rw->addr = (unsigned long) iovp->iov_base;
+		rw->len = iovp->iov_len;
+
+		/* readv -> read distance is the same as writev -> write */
+		BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
+				(IORING_OP_WRITE - IORING_OP_WRITEV));
+		req->opcode += (IORING_OP_READ - IORING_OP_READV);
+	}
+
 	return 0;
 }
 


Thanks,
Ming

