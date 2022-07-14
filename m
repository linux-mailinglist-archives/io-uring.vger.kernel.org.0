Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCAE5575184
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 17:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbiGNPOy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 11:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiGNPOx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 11:14:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8147EDE8E
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 08:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657811691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OeF6usJeTyAcTdKe5UBwqQy7jEW4hkpRgeYYoNc1qmc=;
        b=KIFkiLckc39SYnjHrymz5JKb1GASAtimkW2ppnmVmkNwnAQ6ZPrcrKWMttgUCH/aagm6bR
        Q8l1w/y00w47nXjrFGGokUlgYfZ7hJtqxtYlxMJacRnbl+042mYMVH11Wcc00iZCmwQpJm
        jKvv+fHVsHIEQuDpBVjQ7BqCjplI+jo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-cF3MWFlaO3-_NJpZ-c4sCw-1; Thu, 14 Jul 2022 11:14:46 -0400
X-MC-Unique: cF3MWFlaO3-_NJpZ-c4sCw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E7C718F025F;
        Thu, 14 Jul 2022 15:14:45 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2B05140EBE3;
        Thu, 14 Jul 2022 15:14:37 +0000 (UTC)
Date:   Thu, 14 Jul 2022 23:14:32 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, hch@lst.de, kbusch@kernel.org,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        asml.silence@gmail.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com, ming.lei@redhat.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <YtAy2PUDoWUUE9Bl@T590>
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
 <20220711110155.649153-5-joshi.k@samsung.com>
 <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
 <20220711183746.GA20562@test-zns>
 <5f30c7de-03b1-768a-d44f-594ed2d1dc75@grimberg.me>
 <20220712042332.GA14780@test-zns>
 <3a2b281b-793b-b8ad-6a27-138c89a46fac@grimberg.me>
 <20220713053757.GA15022@test-zns>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713053757.GA15022@test-zns>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 13, 2022 at 11:07:57AM +0530, Kanchan Joshi wrote:
> > > > > > The way I would do this that in nvme_ioucmd_failover_req (or in the
> > > > > > retry driven from command retriable failure) I would do the above,
> > > > > > requeue it and kick the requeue work, to go over the requeue_list and
> > > > > > just execute them again. Not sure why you even need an explicit retry
> > > > > > code.
> > > > > During retry we need passthrough command. But passthrough command is not
> > > > > stable (i.e. valid only during first submission). We can make it stable
> > > > > either by:
> > > > > (a) allocating in nvme (b) return -EAGAIN to io_uring, and
> > > > > it will do allocate + deferral
> > > > > Both add a cost. And since any command can potentially fail, that
> > > > > means taking that cost for every IO that we issue on mpath node. Even if
> > > > > no failure (initial or subsquent after IO) occcured.
> > > > 
> > > > As mentioned, I think that if a driver consumes a command as queued,
> > > > it needs a stable copy for a later reformation of the request for
> > > > failover purposes.
> > > 
> > > So what do you propose to make that stable?
> > > As I mentioned earlier, stable copy requires allocating/copying in fast
> > > path. And for a condition (failover) that may not even occur.
> > > I really think currrent solution is much better as it does not try to make
> > > it stable. Rather it assembles pieces of passthrough command if retry
> > > (which is rare) happens.
> > 
> > Well, I can understand that io_uring_cmd is space constrained, otherwise
> > we wouldn't be having this discussion.
> 
> Indeed. If we had space for keeping passthrough command stable for
> retry, that would really have simplified the plumbing. Retry logic would
> be same as first submission.
> 
> > However io_kiocb is less
> > constrained, and could be used as a context to hold such a space.
> > 
> > Even if it is undesired to have io_kiocb be passed to uring_cmd(), it
> > can still hold a driver specific space paired with a helper to obtain it
> > (i.e. something like io_uring_cmd_to_driver_ctx(ioucmd) ). Then if the
> > space is pre-allocated it is only a small memory copy for a stable copy
> > that would allow a saner failover design.
> 
> I am thinking along the same lines, but it's not about few bytes of
> space rather we need 80 (72 to be precise). Will think more, but
> these 72 bytes really stand tall in front of my optimism.
> 
> Do you see anything is possible in nvme-side?
> Now also passthrough command (although in a modified form) gets copied
> into this preallocated space i.e. nvme_req(req)->cmd. This part -

I understand it can't be allocated in nvme request which is freed
during retry, and looks the extra space has to be bound with
io_uring_cmd.


thanks, 
Ming

