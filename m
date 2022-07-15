Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DA8575932
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 03:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiGOBqi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 21:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240987AbiGOBqh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 21:46:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0EC867177
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 18:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657849594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1uDHwOsNid0jsDEylMKETcWrzHJiMFYyISkHnYnOqww=;
        b=OIuiBxflU2KoC+oR38VgeKEKjyhrurrdzKrpqH0XPMme3zwa1rdulG9juujpUxLtqAtu3U
        4DCFmkEhha2ygQwuwOvJF5Y+9LXtf2NlTDgEbxhzluBJkF9sOnTpFBiqwnshMyog7cS3U1
        c59IA7RSmC8AnD3SU/xE7ETYjh0pn9g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-3FjKqbaBMg-8ciV8j88y7A-1; Thu, 14 Jul 2022 21:46:32 -0400
X-MC-Unique: 3FjKqbaBMg-8ciV8j88y7A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F22551C05AD1;
        Fri, 15 Jul 2022 01:46:31 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 736AC40CFD05;
        Fri, 15 Jul 2022 01:46:22 +0000 (UTC)
Date:   Fri, 15 Jul 2022 09:46:16 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, hch@lst.de, kbusch@kernel.org,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com, ming.lei@redhat.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <YtDG6BUZvJRO/4DR@T590>
References: <20220711110155.649153-5-joshi.k@samsung.com>
 <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
 <20220711183746.GA20562@test-zns>
 <5f30c7de-03b1-768a-d44f-594ed2d1dc75@grimberg.me>
 <20220712042332.GA14780@test-zns>
 <3a2b281b-793b-b8ad-6a27-138c89a46fac@grimberg.me>
 <20220713053757.GA15022@test-zns>
 <YtAy2PUDoWUUE9Bl@T590>
 <20220714230523.GA14373@test-zns>
 <YtDEatX54KA2Q5XU@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtDEatX54KA2Q5XU@T590>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 15, 2022 at 09:35:38AM +0800, Ming Lei wrote:
> On Fri, Jul 15, 2022 at 04:35:23AM +0530, Kanchan Joshi wrote:
> > On Thu, Jul 14, 2022 at 11:14:32PM +0800, Ming Lei wrote:
> > > On Wed, Jul 13, 2022 at 11:07:57AM +0530, Kanchan Joshi wrote:
> > > > > > > > > The way I would do this that in nvme_ioucmd_failover_req (or in the
> > > > > > > > > retry driven from command retriable failure) I would do the above,
> > > > > > > > > requeue it and kick the requeue work, to go over the requeue_list and
> > > > > > > > > just execute them again. Not sure why you even need an explicit retry
> > > > > > > > > code.
> > > > > > > > During retry we need passthrough command. But passthrough command is not
> > > > > > > > stable (i.e. valid only during first submission). We can make it stable
> > > > > > > > either by:
> > > > > > > > (a) allocating in nvme (b) return -EAGAIN to io_uring, and
> > > > > > > > it will do allocate + deferral
> > > > > > > > Both add a cost. And since any command can potentially fail, that
> > > > > > > > means taking that cost for every IO that we issue on mpath node. Even if
> > > > > > > > no failure (initial or subsquent after IO) occcured.
> > > > > > >
> > > > > > > As mentioned, I think that if a driver consumes a command as queued,
> > > > > > > it needs a stable copy for a later reformation of the request for
> > > > > > > failover purposes.
> > > > > >
> > > > > > So what do you propose to make that stable?
> > > > > > As I mentioned earlier, stable copy requires allocating/copying in fast
> > > > > > path. And for a condition (failover) that may not even occur.
> > > > > > I really think currrent solution is much better as it does not try to make
> > > > > > it stable. Rather it assembles pieces of passthrough command if retry
> > > > > > (which is rare) happens.
> > > > >
> > > > > Well, I can understand that io_uring_cmd is space constrained, otherwise
> > > > > we wouldn't be having this discussion.
> > > > 
> > > > Indeed. If we had space for keeping passthrough command stable for
> > > > retry, that would really have simplified the plumbing. Retry logic would
> > > > be same as first submission.
> > > > 
> > > > > However io_kiocb is less
> > > > > constrained, and could be used as a context to hold such a space.
> > > > >
> > > > > Even if it is undesired to have io_kiocb be passed to uring_cmd(), it
> > > > > can still hold a driver specific space paired with a helper to obtain it
> > > > > (i.e. something like io_uring_cmd_to_driver_ctx(ioucmd) ). Then if the
> > > > > space is pre-allocated it is only a small memory copy for a stable copy
> > > > > that would allow a saner failover design.
> > > > 
> > > > I am thinking along the same lines, but it's not about few bytes of
> > > > space rather we need 80 (72 to be precise). Will think more, but
> > > > these 72 bytes really stand tall in front of my optimism.
> > > > 
> > > > Do you see anything is possible in nvme-side?
> > > > Now also passthrough command (although in a modified form) gets copied
> > > > into this preallocated space i.e. nvme_req(req)->cmd. This part -
> > > 
> > > I understand it can't be allocated in nvme request which is freed
> > > during retry,
> > 
> > Why not. Yes it gets freed, but we have control over when it gets freed
> > and we can do if anything needs to be done before freeing it. Please see
> > below as well.
> 
> This way requires you to hold the old request until one new path is
> found, and it is fragile.
> 
> What if there isn't any path available then controller tries to
> reset the path? If the requeue or io_uring_cmd holds the old request,
> it might cause error recovery hang or make error handler code more
> complicated.
> 
> > 
> > > and looks the extra space has to be bound with
> > > io_uring_cmd.
> > 
> > if extra space is bound with io_uring_cmd, it helps to reduce the code
> > (and just that. I don't see that efficiency will improve - rather it
> 
> Does retry have to be efficient?
> 
> > will be tad bit less because of one more 72 byte copy opeation in fast-path).
> 
> Allocating one buffer and bind it with io_uring_cmd in case of retry is actually
> similar with current model, retry is triggered by FS bio, and the allocated
> buffer can play similar role with FS bio.

oops, just think of SQE data only valid during submission, so the buffer
has to be allocated during 1st submission, but the allocation for each io_uring_cmd
shouldn't cost much by creating one slab cache, especially inline data
size of io_uring_cmd has been 56(24 + 32) bytes.


thanks,
Ming

