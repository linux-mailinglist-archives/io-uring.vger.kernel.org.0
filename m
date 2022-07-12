Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104FD571073
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 04:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiGLCrP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 22:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiGLCrP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 22:47:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61D565B7BA
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 19:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657594033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x1/jSIRVCmdrp57N6o2GT3cX8fSlWGgTPHdnSTG+KfQ=;
        b=iw3vStGhJN5OJzjVu3X++LjY9WTxKHNv0rX3NTZ89u8pqF05ViNwikQr45e0ki90e30UPm
        C1Sr/3iww/wOVld098nA5sdZqzjrV5BBa27Y8K6ArWS221Hmmq6LlS637mZ/NefkrSfWJV
        XDQJtsjtUrvwpLHr2YTIRycBud2dhz4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-exFlLAfsO4GNH_20BlqzDQ-1; Mon, 11 Jul 2022 22:47:03 -0400
X-MC-Unique: exFlLAfsO4GNH_20BlqzDQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD41C2806AB5;
        Tue, 12 Jul 2022 02:47:02 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4987440D282E;
        Tue, 12 Jul 2022 02:46:56 +0000 (UTC)
Date:   Tue, 12 Jul 2022 10:46:49 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: [PATCH V4 2/2] ublk_drv: add UBLK_IO_REFETCH_REQ for supporting
 to build as module
Message-ID: <YszgmQzXSBsQmV9p@T590>
References: <20220711022024.217163-1-ming.lei@redhat.com>
 <20220711022024.217163-3-ming.lei@redhat.com>
 <87lesze7o3.fsf@collabora.com>
 <1f021cc5-3cbe-a69d-7d50-8c758174d178@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f021cc5-3cbe-a69d-7d50-8c758174d178@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 12, 2022 at 10:26:47AM +0800, Ziyang Zhang wrote:
> On 2022/7/12 04:06, Gabriel Krisman Bertazi wrote:
> > Ming Lei <ming.lei@redhat.com> writes:
> > 
> >> Add UBLK_IO_REFETCH_REQ command to fetch the incoming io request in
> >> ubq daemon context, so we can avoid to call task_work_add(), then
> >> it is fine to build ublk driver as module.
> >>
> >> In this way, iops is affected a bit, but just by ~5% on ublk/null,
> >> given io_uring provides pretty good batching issuing & completing.
> >>
> >> One thing to be careful is race between ->queue_rq() and handling
> >> abort, which is avoided by quiescing queue when aborting queue.
> >> Except for that, handling abort becomes much easier with
> >> UBLK_IO_REFETCH_REQ since aborting handler is strictly exclusive with
> >> anything done in ubq daemon kernel context.
> > 
> > Hi Ming,
> > 
> > FWIW, I'm not very fond this change.  It adds complexity to the kernel
> > driver and to the userspace server implementation, who now have to deal
> > with different interface semantics just because the driver was built-in
> > or built as a module.  I don't think the tristate support warrants such
> > complexity.  I was hoping we might get away with exporting that symbol
> > or adding a built-in ubd-specific wrapper that can be exported and
> > invokes task_work_add.
> > 
> > Either way, Alibaba seems to consider this feature useful, and if that
> > is the case, we can just not use it on our side.
> 
> Our app handles IOs itself with network(RPC) and internal memory pool
> so UBLK_IO_REFETCH_REQ
> (actually I think it is like NEED_GET_DATA in the earlist version :) )
> is helpful to us because we can assign data buffer address AFTER the app
> gets one IO requests(WRITE, with data size) and we avoid PRE-allocating buffers.

Maybe you can consider to switch to pre-allocation.

The patch[1] for pinning io vm pages in the io lifetime has been done, just
not included in this patchset, and it passes all the builtin tests, but
there is still space for further optimization.

With that patchset[1] in, io pages becomes pinned during whole io handling time,
after io is done, mm can reclaim these pages without needing to swapout. It
works like madvise(MADV_DONTNEED).

[1] https://github.com/ming1/linux/commits/ubd-master


Thanks, 
Ming

