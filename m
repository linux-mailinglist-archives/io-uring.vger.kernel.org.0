Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C5C57103B
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 04:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiGLCdw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 22:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiGLCdv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 22:33:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20F93CE30
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 19:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657593229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YuFnA1ScHe8Ca2Lrpo5OIU62sivSllvoFdKtYzv9rMM=;
        b=fDP50byX8GCu9pQ4+T1vVoVCn1KKL1sVZlOL0mwfkVNdkwDkxNLNIHJGgySDOCFBcDdFo1
        OWxbyXk0pC9uZSC4ssnsEUkKgA+e3OAUqSqBgZ8T48ICNIfuiquBFp51bqv+IMXv/muCZr
        ENAp06iphk2+iyiRscXPMn1xGIfFxkY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-16hIgtYyPym5NFtFHQV1cw-1; Mon, 11 Jul 2022 22:33:45 -0400
X-MC-Unique: 16hIgtYyPym5NFtFHQV1cw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FCB885A581;
        Tue, 12 Jul 2022 02:33:44 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA2B92166B26;
        Tue, 12 Jul 2022 02:33:39 +0000 (UTC)
Date:   Tue, 12 Jul 2022 10:33:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH V4 2/2] ublk_drv: add UBLK_IO_REFETCH_REQ for supporting
 to build as module
Message-ID: <YszdfgTbmHWveFjW@T590>
References: <20220711022024.217163-1-ming.lei@redhat.com>
 <20220711022024.217163-3-ming.lei@redhat.com>
 <87lesze7o3.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lesze7o3.fsf@collabora.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Gabriel,

On Mon, Jul 11, 2022 at 04:06:04PM -0400, Gabriel Krisman Bertazi wrote:
> Ming Lei <ming.lei@redhat.com> writes:
> 
> > Add UBLK_IO_REFETCH_REQ command to fetch the incoming io request in
> > ubq daemon context, so we can avoid to call task_work_add(), then
> > it is fine to build ublk driver as module.
> >
> > In this way, iops is affected a bit, but just by ~5% on ublk/null,
> > given io_uring provides pretty good batching issuing & completing.
> >
> > One thing to be careful is race between ->queue_rq() and handling
> > abort, which is avoided by quiescing queue when aborting queue.
> > Except for that, handling abort becomes much easier with
> > UBLK_IO_REFETCH_REQ since aborting handler is strictly exclusive with
> > anything done in ubq daemon kernel context.
> 
> Hi Ming,
> 
> FWIW, I'm not very fond this change.  It adds complexity to the kernel
> driver and to the userspace server implementation, who now have to deal

IMO, this way just adds dozens line of code, no much complexity. The only
complexity in ublk driver should be in aborting code, which is actually
originated from concurrent aborting work and running task work which may be
run after task is exiting. But any storage driver's aborting/error
handling code is complicated.

Using REFETCH_REQ actually becomes much easier for handling abort which is
run exclusively with any code running in ubq daemon context, but with
performance cost.

> with different interface semantics just because the driver was built-in
> or built as a module.  I don't think the tristate support warrants such
> complexity.  I was hoping we might get away with exporting that symbol
> or adding a built-in ubd-specific wrapper that can be exported and
> invokes task_work_add.

If task_work_add can be exported, that would be very great.

Cc more guys who contributed to task_work_add().

Oleg, Jens and other guys, I am wondering if you may share your opinion
wrt. exporting task_work_add for ublk's use case? Then ublk_drv can be
built as module without this patch.

> 
> Either way, Alibaba seems to consider this feature useful, and if that
> is the case, we can just not use it on our side.

If this new added command is proved as useful, we may add it without
binding with module if task_work_add can be exported.

> 
> That said, the patch looks good to me, just a minor comment inline.
> 
> Thanks,
> 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/block/Kconfig         |   2 +-
> >  drivers/block/ublk_drv.c      | 121 ++++++++++++++++++++++++++--------
> >  include/uapi/linux/ublk_cmd.h |  17 +++++
> >  3 files changed, 113 insertions(+), 27 deletions(-)
> >
> > diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> > index d218089cdbec..2ba77fd960c2 100644
> > --- a/drivers/block/Kconfig
> > +++ b/drivers/block/Kconfig
> > @@ -409,7 +409,7 @@ config BLK_DEV_RBD
> >  	  If unsure, say N.
> >  
> >  config BLK_DEV_UBLK
> > -	bool "Userspace block driver"
> > +	tristate "Userspace block driver"
> >  	select IO_URING
> >  	help
> >            io uring based userspace block driver.
> > diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> > index 0076418e6fad..98482f8d1a77 100644
> > --- a/drivers/block/ublk_drv.c
> > +++ b/drivers/block/ublk_drv.c
> > @@ -92,6 +92,7 @@ struct ublk_queue {
> >  	int q_id;
> >  	int q_depth;
> >  
> > +	unsigned long flags;
> >  	struct task_struct	*ubq_daemon;
> >  	char *io_cmd_buf;
> >  
> > @@ -141,6 +142,15 @@ struct ublk_device {
> >  	struct work_struct	stop_work;
> >  };
> >  
> > +#define ublk_use_task_work(ubq)						\
> > +({                                                                      \
> > +	bool ret = false;						\
> > +	if (IS_BUILTIN(CONFIG_BLK_DEV_UBLK) &&                          \
> > +			!((ubq)->flags & UBLK_F_NEED_REFETCH))		\
> > +		ret = true;						\
> > +	ret;								\
> > +})
> > +
> 
> This should be an inline function, IMO.

You are right. I worried that compiler may not be intelligent
enough for handling the code correctly. But just tried inline,
task_work_add() won't be linked in if CONFIG_BLK_DEV_UBLK is
defined as m.


Thanks,
Ming

