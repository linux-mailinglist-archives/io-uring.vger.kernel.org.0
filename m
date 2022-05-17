Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875F6529707
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 03:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbiEQB6o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 21:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbiEQB6n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 21:58:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89BCD40E66
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 18:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652752721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dan4b7oMniQEPDBtcHcK4omWqrnS96Raov0S3bkdiog=;
        b=g4jTGhG729+2xYvAw2og/YIv86l5/TITjEh8SWwLhFvkmm7XW5qczWtE2aEiDz+gWtxHVB
        L7vLoXz/csPxngBdoIAGn7j/pqBHxL8ZPv5DTwokTJgekxZU0l8W10b1dWgan+R3PojBYT
        Dv18pYimEh18nwgSkRpA6nEjE4LZNh0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-hM4Qy6dFPTmRJTsFajiPog-1; Mon, 16 May 2022 21:58:38 -0400
X-MC-Unique: hM4Qy6dFPTmRJTsFajiPog-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E425B3AF42A2;
        Tue, 17 May 2022 01:58:37 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FFD72026D64;
        Tue, 17 May 2022 01:58:02 +0000 (UTC)
Date:   Tue, 17 May 2022 09:57:56 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        kwolf@redhat.com, sgarzare@redhat.com
Subject: Re: [RFC PATCH] ubd: add io_uring based userspace block driver
Message-ID: <YoMBJMk0GhXk+13E@T590>
References: <20220509092312.254354-1-ming.lei@redhat.com>
 <YoKmFYjIe1AWk/P8@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoKmFYjIe1AWk/P8@stefanha-x1.localdomain>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Stefan,

On Mon, May 16, 2022 at 08:29:25PM +0100, Stefan Hajnoczi wrote:
> Hi,
> This looks interesting! I have some questions:

Thanks for your comment!

> 
> 1. What is the ubdsrv permission model?
> 
> A big usability challenge for *-in-userspace interfaces is the balance
> between security and allowing unprivileged processes to use these
> features.
> 
> - Does /dev/ubd-control need to be privileged? I guess the answer is
>   yes since an evil ubdsrv can hang I/O and corrupt data in hopes of
>   triggering file system bugs.

Yes, I think so.

UBD should be in same position with NBD which does require
capable(CAP_SYS_ADMIN).

> - Can multiple processes that don't trust each other use UBD at the same
>   time? I guess not since ubd_index_idr is global.

Only single process can open /dev/ubdcN for communicating with ubd
driver, see ubd_ch_open().

> - What about containers and namespaces? They currently have (write)
>   access to the same global ubd_index_idr.

I understand contrainers/namespaces only need to see /dev/ubdbN, and
the usage model should be same with kernel loop: the global ubd_index_idr
is same with loop's loop_index_idr too.

Or can you explain a bit in detail if I misunderstood your point.

> - Maybe there should be a struct ubd_device "owner" (struct
>   task_struct *) so only devices created by the current process can be
>   modified?

I guess it isn't needed since /dev/ubdcN is opened by single process.

> 
> 2. io_uring_cmd design
> 
> The rationale for the io_uring_cmd design is not explained in the cover
> letter. I think it's worth explaining the design. Here are my guesses:
> 
> The same thing can be achieved with just file_operations and io_uring.
> ubdsrv could read I/O submissions with IORING_OP_READ and write I/O
> completions with IORING_OP_WRITE. That would require 2 sqes per
> roundtrip instead of 1, but the same number of io_uring_enter(2) calls
> since multiple sqes/cqes can be batched per syscall:
> 
> - IORING_OP_READ, addr=(struct ubdsrv_io_desc*) (for submission)
> - IORING_OP_WRITE, addr=(struct ubdsrv_io_cmd*) (for completion)
> 
> Both operations require a copy_to/from_user() to access the command
> metadata.

Yes, but it can't be efficient as io_uring command.

Two OPs require two long code path for read and write which are supposed
for handling fs io, so reusing complicated FS IO interface for sending
command via cha dev is really overkill, and nvme passthrough has shown
better IOPS than read/write interface with io_uring command, and extra
copy_to/from_user() may fault with extra meta copy, which can slow down
the ubd server.

Also for IORING_OP_READ, copy_to_user() has to be done in the ubq daemon
context, even though that isn't a big deal, but with extra cost(cpu utilization)
in the ubq deamon context or sleep for handling page fault, that is
really what should be avoided, we need to save more CPU for handling user
space IO logic in that context.

> 
> The io_uring_cmd approach works differently. The IORING_OP_URING_CMD sqe
> carries a 40-byte payload so it's possible to embed struct ubdsrv_io_cmd
> inside it. The struct ubdsrv_io_desc mmap gets around the fact that
> io_uring cqes contain no payload. The driver therefore needs a
> side-channel to transfer the request submission details to ubdsrv. I
> don't see much of a difference between IORING_OP_READ and the mmap
> approach though.

At least the performance difference, ->uring_cmd() requires much less
code path(single simple o_uring command) than read/write, without any copy
on command data, without fault in copy_to/from_user(), without two long/
complicated FS IO code path.

Single command of UBD_IO_COMMIT_AND_FETCH_REQ can handle both fetching
io request desc and commit command result in one trip.

> 
> It's not obvious to me how much more efficient the io_uring_cmd approach
> is, but taking fewer trips around the io_uring submission/completion
> code path is likely to be faster. Something similar can be done with
> file_operations ->ioctl(), but I guess the point of using io_uring is
> that is composes. If ubdsrv itself wants to use io_uring for other I/O
> activity (e.g. networking, disk I/O, etc) then it can do so and won't be
> stuck in a blocking ioctl() syscall.

ioctl can't be a choice, since we will lose the benefit of batching
handling.

> 
> It would be nice if you could write 2 or 3 paragraphs explaining why the
> io_uring_cmd design and the struct ubdsrv_io_desc mmap was chosen.

Fine, I guess most are the above inline comment?

> 
> 3. Miscellaneous stuff
> 
> - There isn't much in the way of memory ordering in the code. I worry a
>   little that changes to the struct ubdsrv_io_desc mmap may not be
>   visible at the expected time with respect to the io_uring cq ring.

I believe io_uring_cmd_done() with userspace cqe helper implies enough memory
barrier, once the cqe is observed in userspace, any memory OP done before
io_uring_cmd_done() should be observed by user side cqe handling code,
otherwise it can be thought as io_uring bug.

If it isn't this way, we still can avoid any barrier by moving
setting io desc into ubq daemon context(ubd_rq_task_work_fn), but I
really want to save cpu in that context, and don't think it is needed.


Thanks, 
Ming

