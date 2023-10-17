Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC257CB9E2
	for <lists+io-uring@lfdr.de>; Tue, 17 Oct 2023 07:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbjJQFBd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Oct 2023 01:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjJQFBc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Oct 2023 01:01:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64752A2
        for <io-uring@vger.kernel.org>; Mon, 16 Oct 2023 22:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697518844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mnogXwzjyxHek35erqVPrBm0lo+JvaLA1ZwGGG5lvx8=;
        b=CCr6YZf+EH/E1qUezaybfyiPzTGLOot0CSUWRTzkMHHcpLc5JUXFYgT+nocn09SjOoZt8U
        KAhzR04Yo/2rCX/IpMQ6QZF4lHegHMXT1XxyoAojP+c4UqVr5ShDtXxvMMxC8eKuryn8XC
        vFec9/aLW133oNxV/NT0dWsiyDzvivk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196--0plaehJNN2Q6nUC_Alyrg-1; Tue, 17 Oct 2023 01:00:36 -0400
X-MC-Unique: -0plaehJNN2Q6nUC_Alyrg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D725B185A7A7;
        Tue, 17 Oct 2023 05:00:35 +0000 (UTC)
Received: from fedora (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD47D492BFA;
        Tue, 17 Oct 2023 05:00:32 +0000 (UTC)
Date:   Tue, 17 Oct 2023 13:00:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH for-6.7/io_uring 0/7] ublk: simplify abort with
 cancelable uring_cmd
Message-ID: <ZS4U7N0kbH3BLOGA@fedora>
References: <20231009093324.957829-1-ming.lei@redhat.com>
 <169750523303.2166768.9866448914806482249.b4-ty@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169750523303.2166768.9866448914806482249.b4-ty@kernel.dk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Oct 16, 2023 at 07:13:53PM -0600, Jens Axboe wrote:
> 
> On Mon, 09 Oct 2023 17:33:15 +0800, Ming Lei wrote:
> > Simplify ublk request & io command aborting handling with the new added
> > cancelable uring_cmd. With this change, the aborting logic becomes
> > simpler and more reliable, and it becomes easy to add new feature, such
> > as relaxing queue/ublk daemon association.
> > 
> > Pass `blktests ublk` test, and pass lockdep when running `./check ublk`
> > of blktests.
> > 
> > [...]
> 
> Applied, thanks!
> 
> [1/7] ublk: don't get ublk device reference in ublk_abort_queue()
>       commit: a5365f65ea2244fef4d6b5076210b0fc4fe5c104
> [2/7] ublk: make sure io cmd handled in submitter task context
>       commit: fad0f2b5c6d8f4622ed09ebfd6c08817abbfa20d
> [3/7] ublk: move ublk_cancel_dev() out of ub->mutex
>       commit: 95290eef462aaec33fb6f5f9da541042f9c9a97c
> [4/7] ublk: rename mm_lock as lock
>       commit: 9b8ce170c0bc82c50bf0db6187e00d3a601df334
> [5/7] ublk: quiesce request queue when aborting queue
>       commit: e4a81fcd73422bdee366c3a076826d92ee8f2669
> [6/7] ublk: replace monitor with cancelable uring_cmd
>       commit: 3aa8ac4a0c293fcc1b83c4f1a515b66f1f0123a0
> [7/7] ublk: simplify aborting request
>       commit: ac7eb8f9b49c786aace696bcca13a60953ea9b11

Hi Jens,

Thanks for pulling this patchset it.

However, it depends on recent cancelable uring_cmd in for-6.7/io_uring,
but you pull it in for-6.7/block, which is broken now.

Thanks,
Ming

