Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB385716A0
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 12:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbiGLKIt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 06:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbiGLKIr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 06:08:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47A3FA186
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 03:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657620517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rFweDuIk2SBo5KB2wklW/S9Ar1k61Yu0hajCwnXEGu0=;
        b=WZ2s7ZniY6Yl+T2+ELkA/wtBz5dRVmWMxTWQSmHPK/bfqD1uzN/ieAEJqlnjotooTd09XX
        TDxDNfzl9V14eiRVTFwPWbeCI0ZqTNauxCZYqfKsjH6pBSU0Z5uvz/DP/3vNwwjQGOqWp5
        bIT0cRdiq8wJWATv0J/cyykBOZRqy00=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-bPi2MNEPMj2hs1inCXRbsA-1; Tue, 12 Jul 2022 06:08:30 -0400
X-MC-Unique: bPi2MNEPMj2hs1inCXRbsA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B3758032F0;
        Tue, 12 Jul 2022 10:08:29 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 143F8492C3B;
        Tue, 12 Jul 2022 10:08:23 +0000 (UTC)
Date:   Tue, 12 Jul 2022 18:08:18 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Oleg Nesterov <oleg@redhat.com>, ming.lei@redhat.com
Subject: Re: [PATCH V4 2/2] ublk_drv: add UBLK_IO_REFETCH_REQ for supporting
 to build as module
Message-ID: <Ys1IEiIs2Xlp5iAk@T590>
References: <20220711022024.217163-1-ming.lei@redhat.com>
 <20220711022024.217163-3-ming.lei@redhat.com>
 <87lesze7o3.fsf@collabora.com>
 <YszdfgTbmHWveFjW@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YszdfgTbmHWveFjW@T590>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 12, 2022 at 10:33:34AM +0800, Ming Lei wrote:
> Hi Gabriel,
> 
> On Mon, Jul 11, 2022 at 04:06:04PM -0400, Gabriel Krisman Bertazi wrote:
> > Ming Lei <ming.lei@redhat.com> writes:
> > 
> > > Add UBLK_IO_REFETCH_REQ command to fetch the incoming io request in
> > > ubq daemon context, so we can avoid to call task_work_add(), then
> > > it is fine to build ublk driver as module.
> > >
> > > In this way, iops is affected a bit, but just by ~5% on ublk/null,
> > > given io_uring provides pretty good batching issuing & completing.
> > >
> > > One thing to be careful is race between ->queue_rq() and handling
> > > abort, which is avoided by quiescing queue when aborting queue.
> > > Except for that, handling abort becomes much easier with
> > > UBLK_IO_REFETCH_REQ since aborting handler is strictly exclusive with
> > > anything done in ubq daemon kernel context.
> > 
> > Hi Ming,
> > 
> > FWIW, I'm not very fond this change.  It adds complexity to the kernel
> > driver and to the userspace server implementation, who now have to deal
> 
> IMO, this way just adds dozens line of code, no much complexity. The only
> complexity in ublk driver should be in aborting code, which is actually
> originated from concurrent aborting work and running task work which may be
> run after task is exiting. But any storage driver's aborting/error
> handling code is complicated.
> 
> Using REFETCH_REQ actually becomes much easier for handling abort which is
> run exclusively with any code running in ubq daemon context, but with
> performance cost.
> 
> > with different interface semantics just because the driver was built-in
> > or built as a module.  I don't think the tristate support warrants such
> > complexity.  I was hoping we might get away with exporting that symbol
> > or adding a built-in ubd-specific wrapper that can be exported and
> > invokes task_work_add.
> 
> If task_work_add can be exported, that would be very great.

Another choice is to use io_uring_cmd_complete_in_task which is actually
exported, now we can build ublk_drv as module by using io_uring_cmd_complete_in_task
without needing one new command.

Thanks,
Ming

