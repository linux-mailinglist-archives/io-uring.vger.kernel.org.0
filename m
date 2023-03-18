Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A4D6BFB9A
	for <lists+io-uring@lfdr.de>; Sat, 18 Mar 2023 17:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjCRQks (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 12:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCRQkr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 12:40:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B1E1ADE4
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 09:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679157601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QVDseqXcb5Tz+MF0YDcURLigIjMf9adAoc3YfhWgh/s=;
        b=bKmGZTXXVrZ4rVMo75x8dW98hqC7r+/42x0JblXpe0Nov1/b4jixboSV+E5s3Df/p3SWA8
        R1uhe1PqqHpbHuouBQAk1G00R9h++Lv9WqvGD+MxinCjVnx/utmJu0J69syi4mkiICBVAL
        ix/NI9gLZe0HA+JZ+oqih8Akx6yFgN8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-I38_88u2Mc6VoQX7M04hfw-1; Sat, 18 Mar 2023 12:39:50 -0400
X-MC-Unique: I38_88u2Mc6VoQX7M04hfw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BF621C05195;
        Sat, 18 Mar 2023 16:39:50 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BDA11121315;
        Sat, 18 Mar 2023 16:39:44 +0000 (UTC)
Date:   Sun, 19 Mar 2023 00:39:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZBXpTFf5B51oUAIR@ovpn-8-18.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
 <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 18, 2023 at 04:23:35PM +0000, Pavel Begunkov wrote:
> On 3/16/23 03:13, Xiaoguang Wang wrote:
> > > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > > to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> > > and its ->issue() can retrieve/import buffer from master request's
> > > fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> > > this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> > > submits slave OP just like normal OP issued from userspace, that said,
> > > SQE order is kept, and batching handling is done too.
> > Thanks for this great work, seems that we're now in the right direction
> > to support ublk zero copy, I believe this feature will improve io throughput
> > greatly and reduce ublk's cpu resource usage.
> > 
> > I have gone through your 2th patch, and have some little concerns here:
> > Say we have one ublk loop target device, but it has 4 backend files,
> > every file will carry 25% of device capacity and it's implemented in stripped
> > way, then for every io request, current implementation will need issed 4
> > fused_cmd, right? 4 slave sqes are necessary, but it would be better to
> > have just one master sqe, so I wonder whether we can have another
> > method. The key point is to let io_uring support register various kernel
> > memory objects, which come from kernel, such as ITER_BVEC or
> > ITER_KVEC. so how about below actions:
> > 1. add a new infrastructure in io_uring, which will support to register
> > various kernel memory objects in it, this new infrastructure could be
> > maintained in a xarray structure, every memory objects in it will have
> > a unique id. This registration could be done in a ublk uring cmd, io_uring
> > offers registration interface.
> > 2. then any sqe can use these memory objects freely, so long as it
> > passes above unique id in sqe properly.
> > Above are just rough ideas, just for your reference.
> 
> It precisely hints on what I proposed a bit earlier, that makes
> me not alone thinking that it's a good idea to have a design allowing
> 1) multiple ops using a buffer and

Firstly fused command does cover this case, io_fused_cmd_provide_kbuf()
is very cheap, which just passes buffer reference.

Secondly, your original suggestion is to wire the per-io buffer with
context fixed buffer, which basically has to add two OPs:

1) one for registering buffer

2) another one for un-registering buffer

So one usual such IO may have to takes 3+ SQEs, which won't be efficient for
single or even double submission cases since the cost of touching global
context fixed buffer can't be ignored.

> 2) to limiting it to one single
> submission because the userspace might want to preprocess a part
> of the data, multiplex it or on the opposite divide.

Unfortunately ublk has to support multiple submissions, and there can
be lots of such use cases, logical volume manager(mirror, stripped),
distributed network storage, ...


Thanks, 
Ming

