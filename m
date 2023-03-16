Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAF26BC504
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 04:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjCPD5D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 23:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCPD5C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 23:57:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADB476141
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 20:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678938977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QNiK2VEGVrc54NDmjJpog4oYcRrtFTUQS5YRNkrDJd8=;
        b=cmA30X1sXN0HZcMZje4DVPi/2HhUHPDJ72mHxKmEnCAtiDmuJzNhtKyNZ62daZxhPfdLYi
        yLRs/sHU5Jtw3vrGixcgK/bX/H1HMjhZoQ9tZS3xe2tfS7qa+Cg6klEllCe4byWP5Eo064
        qDwy9dGWbNUGqNkAG10uUMlG9IktMpg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-rSkoSpS4NJSu5bAAU3FQfw-1; Wed, 15 Mar 2023 23:56:13 -0400
X-MC-Unique: rSkoSpS4NJSu5bAAU3FQfw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 752A187A9E1;
        Thu, 16 Mar 2023 03:56:13 +0000 (UTC)
Received: from ovpn-8-22.pek2.redhat.com (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB782492B00;
        Thu, 16 Mar 2023 03:56:07 +0000 (UTC)
Date:   Thu, 16 Mar 2023 11:56:02 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZBKTUtWTVdcTeUHD@ovpn-8-22.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 16, 2023 at 11:13:39AM +0800, Xiaoguang Wang wrote:
> hi,
> 
> > Hello,
> >
> > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> > and its ->issue() can retrieve/import buffer from master request's
> > fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> > this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> > submits slave OP just like normal OP issued from userspace, that said,
> > SQE order is kept, and batching handling is done too.
> Thanks for this great work, seems that we're now in the right direction
> to support ublk zero copy, I believe this feature will improve io throughput
> greatly and reduce ublk's cpu resource usage.
> 
> I have gone through your 2th patch, and have some little concerns here:
> Say we have one ublk loop target device, but it has 4 backend files,
> every file will carry 25% of device capacity and it's implemented in stripped
> way, then for every io request, current implementation will need issed 4
> fused_cmd, right? 4 slave sqes are necessary, but it would be better to
> have just one master sqe, so I wonder whether we can have another

Yeah, the current approach needs 4 fused command with 4 slave request,
but from user viewpoint it is just 4 128byte SQEs.

It is pretty lightweight to handle master command, just calling io_fused_cmd_provide_kbuf()
for providing the buffer, so IMO it is fine to submit 4 fused command to handle
single stripped IO.

> method. The key point is to let io_uring support register various kernel
> memory objects, which come from kernel, such as ITER_BVEC or
> ITER_KVEC. so how about below actions:
> 1. add a new infrastructure in io_uring, which will support to register
> various kernel memory objects in it, this new infrastructure could be
> maintained in a xarray structure, every memory objects in it will have
> a unique id. This registration could be done in a ublk uring cmd, io_uring
> offers registration interface.
> 2. then any sqe can use these memory objects freely, so long as it
> passes above unique id in sqe properly.
> Above are just rough ideas, just for your reference.

I'd rather not add more complexity from the beginning, and IMO probably it
could be the most simple & generic way to handle it by single fused command,
at least the buffer lifetime/ownership won't cross multiple OPs.

Registering per-io buffer isn't free, Pavel actually mentioned the
idea, basically:

1) one OP is for registering buffer
2) another OP is for un-registering buffer

Then we still need 3+ OPs(SQEs) for handling single IO, not mention the buffer
has to be stored in global(per-ctx) data structure, and you have to pay
cost to read/write global data structure in IO fast path. In the case of
4 stripped underlying device, you still need 6 64byte SQEs for handling single io.

But in future if we don't have other better candidates and fused command can't
scale well, we can extend it or add new OPs for improving the multiple underlying
devices, but so far, not see the problem.

> 
> And current zero-copy method only supports raw data redirection, if

Yeah.

> ublk targets need to crc, compress, encrypt raw io requests' pages,
> then we'll still need to copy block layer's io data to userspace daemon.

Yes, zero copy can't cover all cases, that is why I add read/write
interface to support other cases, see patch 14, then userspace can
do whatwever they like.

Actually once zero copy is accepted, I'd suggest to mark the non-zc code path
as legacy, since the copy can be done explicitly in userspace by the added
read()/write(). And ublk driver can get simplified & cleaned, same with
userspace implementation.

> In that way, ebpf may give a help :) we directly operate block layer's
> io data in ebpf prog, doing crc or compress, encrypt, still does not need
> to copy to userspace daemon. But as you said before, ebpf may not
> support complicated user io logic, a much long way to go...

Of course, there can be lots of work for future improvement, and ebpf is
really one great weapon, but let's start effectively with something
reliable & simple.


thanks,
Ming

