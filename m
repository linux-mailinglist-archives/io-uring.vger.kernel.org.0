Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E732F574483
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 07:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiGNFan (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 01:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiGNFam (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 01:30:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01BEA20BF8
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 22:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657776639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yo60Yucr2FRbmnfU3FuLxXFG6GjMa37IcYtYc/Agp+4=;
        b=F5g+JCTUJL5IFIACnD0d3veEDXZ4ulxU7IF7WUnqtVAuNjayGf/BVucEn2GHChL2r9o1i/
        okypgtFR+2mleCIfwk3nTqhi2Ag6hYPw+eb4uj+f3yDPJutMtPXyaX+Jnt8SS+2iUwf/+f
        DMiRiKfpq9nmGFrRrN1zyroHyycWAjc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-YUaiakrXM1i8OKU56w9wwQ-1; Thu, 14 Jul 2022 01:30:35 -0400
X-MC-Unique: YUaiakrXM1i8OKU56w9wwQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F87A2806AB3;
        Thu, 14 Jul 2022 05:30:35 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3ACD2166B26;
        Thu, 14 Jul 2022 05:30:29 +0000 (UTC)
Date:   Thu, 14 Jul 2022 13:30:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH V5 0/2] ublk: add io_uring based userspace block driver
Message-ID: <Ys+p79SG+9QBjo7x@T590>
References: <20220713140711.97356-1-ming.lei@redhat.com>
 <6e5d590b-448d-ea75-f29d-877a2cd6413b@kernel.dk>
 <Ys9g9RhZX5uwa9Ib@T590>
 <94289486-a7fa-1801-3c67-717e0392f374@kernel.dk>
 <38b6e5f5-247a-bd44-061d-f492e7d47b99@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38b6e5f5-247a-bd44-061d-f492e7d47b99@kernel.dk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 13, 2022 at 08:59:16PM -0600, Jens Axboe wrote:
> On 7/13/22 8:54 PM, Jens Axboe wrote:
> > On 7/13/22 6:19 PM, Ming Lei wrote:
> >> On Wed, Jul 13, 2022 at 02:25:25PM -0600, Jens Axboe wrote:
> >>> On 7/13/22 8:07 AM, Ming Lei wrote:
> >>>> Hello Guys,
> >>>>
> >>>> ublk driver is one kernel driver for implementing generic userspace block
> >>>> device/driver, which delivers io request from ublk block device(/dev/ublkbN) into
> >>>> ublk server[1] which is the userspace part of ublk for communicating
> >>>> with ublk driver and handling specific io logic by its target module.
> >>>
> >>> Ming, is this ready to get merged in an experimental state?
> >>
> >> Hi Jens,
> >>
> >> Yeah, I think so.
> >>
> >> IO path can survive in xfstests(-g auto), and control path works
> >> well in ublksrv builtin hotplug & 'kill -9' daemon test.
> >>
> >> The UAPI data size should be good, but definition may change per
> >> future requirement change, so I think it is ready to go as
> >> experimental.
> > 
> > OK let's give it a go then. I tried it out and it seems to work for me,
> > even if the shutdown-while-busy is something I'd to look into a bit
> > more.
> > 
> > BTW, did notice a typo on the github page:
> > 
> > 2) dependency
> > - liburing with IORING_SETUP_SQE128 support
> > 
> > - linux kernel 5.9(IORING_SETUP_SQE128 support)
> > 
> > that should be 5.19, typo.
> 
> I tried this:
> 
> axboe@m1pro-kvm ~/g/ubdsrv (master)> sudo ./ublk add -t loop /dev/nvme0n1
> axboe@m1pro-kvm ~/g/ubdsrv (master) [255]> 

That looks one issue in ubdsrv, and '-f /dev/nvme0n1' is needed.

> 
> and got this dump:
> 
> [   34.041647] WARNING: CPU: 3 PID: 60 at block/blk-mq.c:3880 blk_mq_release+0xa4/0xf0
> [   34.043858] Modules linked in:
> [   34.044911] CPU: 3 PID: 60 Comm: kworker/3:1 Not tainted 5.19.0-rc6-00320-g5c37a506da31 #1608
> [   34.047689] Hardware name: linux,dummy-virt (DT)
> [   34.049207] Workqueue: events blkg_free_workfn
> [   34.050731] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   34.053026] pc : blk_mq_release+0xa4/0xf0
> [   34.054360] lr : blk_mq_release+0x44/0xf0
> [   34.055694] sp : ffff80000b16bcb0
> [   34.056804] x29: ffff80000b16bcb0 x28: 0000000000000000 x27: 0000000000000000
> [   34.059135] x26: 0000000000000000 x25: ffff00001fe9bb05 x24: 0000000000000000
> [   34.061454] x23: ffff000005062eb8 x22: ffff000004608998 x21: 0000000000000000
> [   34.063775] x20: ffff000004608a50 x19: ffff000004608950 x18: ffff80000b7b3c88
> [   34.066085] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> [   34.068410] x14: 0000000000000002 x13: 0000000000013638 x12: 0000000000000000
> [   34.070715] x11: ffff80000945b7e8 x10: 0000000000006f2e x9 : 00000000ffffffff
> [   34.073037] x8 : ffff800008fb5000 x7 : ffff80000860cf28 x6 : 0000000000000000
> [   34.075334] x5 : 0000000000000000 x4 : 0000000000000028 x3 : ffff80000b16bc14
> [   34.077650] x2 : ffff0000086d66a8 x1 : ffff0000086d66a8 x0 : ffff0000086d6400
> [   34.079966] Call trace:
> [   34.080789]  blk_mq_release+0xa4/0xf0
> [   34.081811]  blk_release_queue+0x58/0xa0
> [   34.082758]  kobject_put+0x84/0xe0
> [   34.083590]  blk_put_queue+0x10/0x18
> [   34.084468]  blkg_free_workfn+0x58/0x84
> [   34.085511]  process_one_work+0x2ac/0x438
> [   34.086449]  worker_thread+0x1cc/0x264
> [   34.087322]  kthread+0xd0/0xe0
> [   34.088053]  ret_from_fork+0x10/0x20

I guess there should be some validation missed in driver side too, will
look into it.


Thanks,
Ming

