Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6700561E81B
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 02:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiKGBGN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Nov 2022 20:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiKGBGL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Nov 2022 20:06:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BABBC0C
        for <io-uring@vger.kernel.org>; Sun,  6 Nov 2022 17:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667783118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SNimcy03lVO1HY+U4NDPJI3Wpm45K80Mxm9Usc2lI5A=;
        b=FPR9UNkE45KcrYzKYEUisimPX49+u7zVraXpctncRDfnZwptId9MwhztOP/ovwmmOe6E4d
        OLT4nyNVRJUgFdL1dxxDECY5RVo0ysCG1KeTrydfAw5eaauNHs6HRxtxJ2yrrbpnVTt5k0
        zNUlPNLv+fapK6AppBST7Rm+UP6fCpk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-_RKCmUxEOBKh-hXpjIX--g-1; Sun, 06 Nov 2022 20:05:14 -0500
X-MC-Unique: _RKCmUxEOBKh-hXpjIX--g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73AF78027ED;
        Mon,  7 Nov 2022 01:05:14 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 652E740C6EC4;
        Mon,  7 Nov 2022 01:05:07 +0000 (UTC)
Date:   Mon, 7 Nov 2022 09:05:05 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bernd Schubert <bernd.schubert@fastmail.fm>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>
Subject: Re: [RFC PATCH 4/4] ublk_drv: support splice based read/write zero
 copy
Message-ID: <Y2hZwWdY28bCn+iT@T590>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
 <20221103085004.1029763-5-ming.lei@redhat.com>
 <712cd802-f3bb-9840-e334-385cd42325f2@fastmail.fm>
 <Y2Rgem8+oYafTLVO@T590>
 <ead8a6cc-13eb-6dc0-2c17-a87e78d8a422@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ead8a6cc-13eb-6dc0-2c17-a87e78d8a422@fastmail.fm>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Nov 05, 2022 at 12:37:21AM +0100, Bernd Schubert wrote:
> 
> 
> On 11/4/22 01:44, Ming Lei wrote:
> > On Thu, Nov 03, 2022 at 11:28:29PM +0100, Bernd Schubert wrote:
> > > 
> > > 
> > > On 11/3/22 09:50, Ming Lei wrote:
> > > > Pass ublk block IO request pages to kernel backend IO handling code via
> > > > pipe, and request page copy can be avoided. So far, the existed
> > > > pipe/splice mechanism works for handling write request only.
> > > > 
> > > > The initial idea of using splice for zero copy is from Miklos and Stefan.
> > > > 
> > > > Read request's zero copy requires pipe's change to allow one read end to
> > > > produce buffers for another read end to consume. The added SPLICE_F_READ_TO_READ
> > > > flag is for supporting this feature.
> > > > 
> > > > READ is handled by sending IORING_OP_SPLICE with SPLICE_F_DIRECT |
> > > > SPLICE_F_READ_TO_READ. WRITE is handled by sending IORING_OP_SPLICE with
> > > > SPLICE_F_DIRECT. Kernel internal pipe is used for simplifying userspace,
> > > > meantime potential info leak could be avoided.
> > > 
> > > 
> > > Sorry to ask, do you have an ublk branch that gives an example how to use
> > > this?
> > 
> > Follows the ublk splice-zc branch:
> > 
> > https://github.com/ming1/ubdsrv/commits/splice-zc
> > 
> > which is mentioned in cover letter, but I guess it should be added to
> > here too, sorry for that, so far only ublk-loop supports it by:
> > 
> >     ublk add -t loop -f $BACKING -z
> > 
> > without '-z', ublk-loop is created with zero copy disabled.
> 
> Ah, thanks a lot! And sorry, I had missed this part in the cover letter.
> 
> I will take a look on your new zero copy code on Monday.
> 
> 
> > 
> > > 
> > > I still have several things to fix in my branches, but I got basic fuse
> > > uring with copies working. Adding back splice would be next after posting
> > > rfc patches. My initial assumption was that I needed to duplicate everything
> > > splice does into the fuse .uring_cmd handler - obviously there is a better
> > > way with your patches.
> > > 
> > > This week I have a few days off, by end of next week or the week after I
> > > might have patches in an rfc state (one thing I'm going to ask about is how
> > > do I know what is the next CQE in the kernel handler - ublk does this with
> > > tags through mq, but I don't understand yet where the tag is increased and
> > > what the relation between tag and right CQE order is).
> > 
> > tag is one attribute of io request, which is originated from ublk
> > driver, and it is unique for each request among one queue. So ublksrv
> > won't change it at all, just use it, and ublk driver guarantees that
> > it is unique.
> > 
> > In ublkserv implementation, the tag info is set in cqe->user_data, so
> > we can retrieve the io request via tag part of cqe->user_data.
> 
> Yeah, this is the easy part I understood. At least I hope so :)
> 
> > 
> > Also I may not understand your question of 'the relation between tag and right
> > CQE order', io_uring provides IOSQE_IO_DRAIN/IOSQE_IO_LINK for ordering
> > SQE, and ublksrv only applies IOSQE_IO_LINK in ublk-qcow2, so care to
> > explain it in a bit details about the "the relation between tag and right
> > CQE order"?
> 
> 
> For fuse (kernel) a vfs request comes in and I need to choose a command in
> the ring queue. Right now this is just an atomic counter % queue_size
> 
> fuse_request_alloc_ring()
> 	req_cnt = atomic_inc_return(&queue->req_cnt);
> 	tag = req_cnt & (fc->ring.queue_depth - 1); /* cnt % queue_depth */
> 
> 	ring_req = &queue->ring_req[tag];
> 
> 
> 
> I might be wrong, but I think that can be compared a bit to ublk_queue_rq().
> Looks like ublk_queue_rq gets called in blk-mq context and blk-mq seems to
> provide rq->tag, which then determines the command in the ring queue -
> completion of commands is done in tag-order provided by blk-mq? The part I

The two are not related, blk-mq tag number means nothing wrt. io
handling order:

- tag is allocated via sbitmap, which may return tag number in any
  order, you may think the returned number is just random
- blk-mq may re-order requests and dispatch them with any order
- once requests are issued to io_uring, userspace may handles these IOs
  with any order
- after backend io is queued via io_uring or libaio or whatever to kernel, it
could be completed at any order

> didn't figure out yet is where the tag value gets set.
> Also interesting is that there is no handler if the ring is already full -
> like the ublk_io command is currently busy in ublksrv (user space). Handled
> auto-magically with blk-mq?

For ublk, the queue has fixed depth, so the pre-allocated io_uring size is
enough, and blk-mq can throttle IOs from the beginning if the max queue depth is
reached, so ublk needn't to worry about io_uring size/depth.

But fuse may have to consider request throttle.


Thanks, 
Ming

