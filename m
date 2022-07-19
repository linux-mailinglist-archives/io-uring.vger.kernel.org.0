Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE233579830
	for <lists+io-uring@lfdr.de>; Tue, 19 Jul 2022 13:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbiGSLJx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jul 2022 07:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiGSLJw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jul 2022 07:09:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 453982FFC8
        for <io-uring@vger.kernel.org>; Tue, 19 Jul 2022 04:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658228989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=srd/A0Ksc4RE5F6CWlUB1xaNiwD2aqvXQ7W1+Q7wvSo=;
        b=hb1pSjxfDA1LQPF0imvD24JnDiZtkB3q+npJPMcWdqaefiqNanamRlrRXcrBPobfvvncio
        J2Xt2da/X9e3bHtLv8rzTYERReYKMXUBMdjd8OBvt4TYjzNrebnBlBdj815bqBy56WmIiD
        d+JrVVk49ToqpfLt0FiHoYz6fbg4iVw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-BItOYDr5OeadZoklaF082A-1; Tue, 19 Jul 2022 07:09:46 -0400
X-MC-Unique: BItOYDr5OeadZoklaF082A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D4FB2806AAA;
        Tue, 19 Jul 2022 11:09:46 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B2A8492C3B;
        Tue, 19 Jul 2022 11:09:40 +0000 (UTC)
Date:   Tue, 19 Jul 2022 19:09:35 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        joseph.qi@linux.alibaba.com, ming.lei@redhat.com
Subject: Re: [PATCH] ublk_drv: add one new ublk command: UBLK_IO_NEED_GET_DATA
Message-ID: <YtaQ7wLJ9vZpwv31@T590>
References: <9993fb25-ecd1-4682-99b9-e83472583897@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9993fb25-ecd1-4682-99b9-e83472583897@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Ziyang,

Now it is close to v5.20 merge window, so I'd suggest to delay
this patch to next cycle.

On Mon, Jul 18, 2022 at 07:44:51PM +0800, Ziyang Zhang wrote:
> Add one new ublk command: UBLK_IO_NEED_GET_DATA.
> 
> It is designed for a user application who wants to allocate IO buffer
> and set IO buffer address only after it receives an IO request.

I'd understand the reason why the user application wants to set the io buffer
after receiving each io command from ublk_drv.

ublksrv has provides ->alloc_io_buf()/->free_io_buf() callbacks to
set pre-allocated buffers from target code.

Meantime ublksrv has supported[1] to discard pages mapped to io buffers
when the queue is idle, so pre-allocation should cover most of cases.

[1] https://github.com/ming1/ubdsrv/commit/9de36e4525a1f64a112ff2a4ce95dced4fc96673

> 
> 1. Background:
> For now, ublk requires the user to set IO buffer address in advance(with
> last UBLK_IO_COMMIT_AND_FETCH_REQ command)so the user has to
> pre-allocate IO buffer.
> 
> For READ requests, this work flow looks good because the data copy
> happens after user application gets a cqe and the kernel copies data.
> So user application can allocate IO buffer, copy data to be read into
> it, and issues a sqe with the newly allocated IO buffer.
> 
> However, for WRITE requests, this work flow looks weird because
> the data copy happens in a task_work before the user application gets one
> cqe. So it is inconvenient for users who allocates(or fetch from a
> memory pool)buffer after it gets one request(and know the actual data
> size).

Can I understand that the only benefit of UBLK_IO_NEED_GET_DATA is to
provide one chance for userspace to change io buffer after getting
each io command?

And the cost is one extra io_uring loop between ublksrv and ublk_drv.

Also if every time new io buffer is used, it could pin lots of pages,
then page reclaim can be triggered frequently and perf drops a lot, so
I guess you won't allocate new io buffer during handling
UBLK_IO_NEED_GET_DATA in userspace side? And you should have use
sort of pre-allocation too?

> 
> 2. Design:
> Consider add a new feature flag: UBLK_F_NEED_GET_DATA.
> 
> If user sets this new flag(through libublksrv) and pass it to kernel
> driver, ublk kernel driver should returns a cqe with
> UBLK_IO_RES_NEED_GET_DATA after a new blk-mq WRITE request comes.
> 
> A user application now can allocate data buffer for writing and pass its
> address in UBLK_IO_NEED_GET_DATA command after ublk kernel driver returns
> cqe with UBLK_IO_RES_NEED_GET_DATA.
> 
> After the kernel side gets the sqe (UBLK_IO_NEED_GET_DATA command), it
> now copies(address pinned, indeed) data to be written from bio vectors
> to newly returned IO data buffer.
> 
> Finally, the kernel side returns UBLK_IO_RES_OK and ublksrv handles the
> IO request as usual.The new feature: UBLK_F_NEED_GET_DATA is enabled on
> demand ublksrv still can pre-allocate data buffers with task_work.
> 
> 3. Evaluation:
> We modify ublksrv to support UBLK_F_NEED_GET_DATA and the modification
> will be PR-ed to Ming Lei's github repository soon if this patch is
> okay.

IMO, for any new feature, I'd suggest to create one git MR
somewhere for holding userspace code & related test code, so that:

1) easier to understand the change with userspace change

2) easier to verify if the change works as expected.

3) review userspace change at the same time, and it can be super
efficient, but this one can be optional

Given you have to verify the change in your side first, the kind of work
in 3) should be quite small.


Thanks, 
Ming

