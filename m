Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BACF352D423
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 15:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbiESNdz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 09:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235765AbiESNdy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 09:33:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1B277E1F3
        for <io-uring@vger.kernel.org>; Thu, 19 May 2022 06:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652967231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eMu0TlQoEPsu5A0dNqyE4kosLWfd95ivJDcxXU5XZ9k=;
        b=CEXAuFXaZieNhIBXI+9JxCg3XOtY6ox8WhhvmA6MGrZ7b09G4ZjiWZP+LcWatjrCwJDPaR
        A+ZhCLal6CrjfyYUZL9OqCGn/I4WGbRbrDkxQ9dh/Mq530hFRY2D+eqeE9tDw7yg3eSBeE
        1oXNxb/nHU2t4avSbBksMod2JewGOPU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-B37KWeoPNrm0MpDgCivevw-1; Thu, 19 May 2022 09:33:47 -0400
X-MC-Unique: B37KWeoPNrm0MpDgCivevw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78B1E185A7BA;
        Thu, 19 May 2022 13:33:46 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F1AF67AE4;
        Thu, 19 May 2022 13:33:39 +0000 (UTC)
Date:   Thu, 19 May 2022 21:33:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, ming.lei@redhat.com
Subject: Re: [PATCH V2 0/1] ubd: add io_uring based userspace block driver
Message-ID: <YoZHLrxE87t6T+Tz@T590>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517055358.3164431-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 17, 2022 at 01:53:57PM +0800, Ming Lei wrote:
> Hello Guys,
> 
> ubd driver is one kernel driver for implementing generic userspace block
> device/driver, which delivers io request from ubd block device(/dev/ubdbN) into
> ubd server[1] which is the userspace part of ubd for communicating
> with ubd driver and handling specific io logic by its target module.
> 
> Another thing ubd driver handles is to copy data between user space buffer
> and request/bio's pages, or take zero copy if mm is ready for support it in
> future. ubd driver doesn't handle any IO logic of the specific driver, so
> it is small/simple, and all io logics are done by the target code in ubdserver.
> 
> The above two are main jobs done by ubd driver.
> 
> ubd driver can help to move IO logic into userspace, in which the
> development work is easier/more effective than doing in kernel, such as,
> ubd-loop takes < 200 lines of loop specific code to get basically same 
> function with kernel loop block driver, meantime the performance is
> still good. ubdsrv[1] provide built-in test for comparing both by running
> "make test T=loop".
> 
> Another example is high performance qcow2 support[2], which could be built with
> ubd framework more easily than doing it inside kernel.
> 
> Also there are more people who express interests on userspace block driver[3],
> Gabriel Krisman Bertazi proposes this topic in lsf/mm/ebpf 2022 and mentioned
> requirement from Google. Ziyang Zhang from Alibaba said they "plan to
> replace TCMU by UBD as a new choice" because UBD can get better throughput than
> TCMU even with single queue[4], meantime UBD is simple. Also there is userspace
> storage service for providing storage to containers.
> 
> It is io_uring based: io request is delivered to userspace via new added
> io_uring command which has been proved as very efficient for making nvme
> passthrough IO to get better IOPS than io_uring(READ/WRITE). Meantime one
> shared/mmap buffer is used for sharing io descriptor to userspace, the
> buffer is readonly for userspace, each IO just takes 24bytes so far.
> It is suggested to use io_uring in userspace(target part of ubd server)
> to handle IO request too. And it is still easy for ubdserver to support
> io handling by non-io_uring, and this work isn't done yet, but can be
> supported easily with help o eventfd.
> 
> This way is efficient since no extra io command copy is required, no sleep
> is needed in transferring io command to userspace. Meantime the communication
> protocol is simple and efficient, one single command of
> UBD_IO_COMMIT_AND_FETCH_REQ can handle both fetching io request desc and commit
> command result in one trip. IO handling is often batched after single
> io_uring_enter() returns, both IO requests from ubd server target and
> IO commands could be handled as a whole batch.
> 
> Remove RFC now because ubd driver codes gets lots of cleanup, enhancement and
> bug fixes since V1:
> 
> - cleanup uapi: remove ubd specific error code,  switch to linux error code,
> remove one command op, remove one field from cmd_desc
> 
> - add monitor mechanism to handle ubq_daemon being killed, ubdsrv[1]
>   includes builtin tests for covering heavy IO with deleting ubd / killing
>   ubq_daemon at the same time, and V2 pass all the two tests(make test T=generic),
>   and the abort/stop mechanism is simple
> 
> - fix MQ command buffer mmap bug, and now 'xfstetests -g auto' works well on
>   MQ ubd-loop devices(test/scratch)
> 
> - improve batching submission as suggested by Jens
> 
> - improve handling for starting device, replace random wait/poll with
> completion
> 
> - all kinds of cleanup, bug fix,..
> 
> And the patch by patch change since V1 can be found in the following
> tree:
> 
> https://github.com/ming1/linux/commits/my_for-5.18-ubd-devel_v2

BTW, a one-line fix[1] is added to above branch, which fixes performance
obviously on small BS(< 128k) test. If anyone run performance test,
please include this fix.

[1] https://github.com/ming1/linux/commit/fa91354b418e83953304a3efad4ee6ac40ea6110

Thanks,
Ming

