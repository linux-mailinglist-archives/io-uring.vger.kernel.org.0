Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DE76C8EC5
	for <lists+io-uring@lfdr.de>; Sat, 25 Mar 2023 15:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCYOQQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Mar 2023 10:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYOQQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Mar 2023 10:16:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08F86A68
        for <io-uring@vger.kernel.org>; Sat, 25 Mar 2023 07:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679753728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EJskXx//8dz1rUMxGQMccM+rIb22Wd8SqK5F/LVmoVM=;
        b=CIB2Uj/pGyUtEJLQ+53bO8fPqD5W/3NO7dU5CzEMGxb4VDYpXzVq6oU/I3c+Befuj3dky4
        ofQXivjaYAO/Du20CLdo6dsVMWk28Xx0Kz2W4A2PSg9ZTcKxFds836QRup+vO0DLP6jT+V
        KaLoR/YITHGIuoTWmuXZomiltUYXQ6k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-3RB24tOHMhOwj5tywzySTQ-1; Sat, 25 Mar 2023 10:15:25 -0400
X-MC-Unique: 3RB24tOHMhOwj5tywzySTQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F40B13C0DDA3;
        Sat, 25 Mar 2023 14:15:24 +0000 (UTC)
Received: from ovpn-8-21.pek2.redhat.com (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A516202701E;
        Sat, 25 Mar 2023 14:15:18 +0000 (UTC)
Date:   Sat, 25 Mar 2023 22:15:13 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZB8B8cr1/qIcPdRM@ovpn-8-21.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
 <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
> 1) multiple ops using a buffer and 2) to limiting it to one single
> submission because the userspace might want to preprocess a part
> of the data, multiplex it or on the opposite divide. I was mostly
> coming from non ublk cases, and one example would be such zc recv,
> parsing the app level headers and redirecting the rest of the data
> somewhere.

Just get some time to think about zc recv.

Firstly I understand the buffer shouldn't be provided from userspace unlike
storage, given network recv can happen any time, and NIC driver has to put
received data into kernel socket recv buffer first. But if yes for some special recv
case, the use case is totally different with ublk, and impossible to share
any code with ublk.

So here suppose the zc recv means to export socket recv buffer to userspace
just like the implementation in lwn doc [1].

[1] https://lwn.net/Articles/752188/

But how does userspace pre-process this kernel buffer? mmap is expensive,
and copy won't be one option. Or the data is just simply forwarded to
somewhere(special case)?

If yes, it can become a bit similar with ublk's case in which
the device io buffer needn't to be modified and just simply forwarded to
FS or socket in most of cases. Then it could be possible to extend fused
for supporting it given the buffer lifetime model is useful for generic zero
copy, such as:

- send fused command(A) to just register buffer(socket recv buffer) with one
empty buffer index, then return the buffer index to userspace via CQE(
IORING_CQE_F_MORE), but not complete this fused command(A); but it
requires socket FS to implement ->uring_command() for providing recv
buffer.

- after getting recv SQE, userspace can use the registered buffer to
do whatever, but direct access on buffer is one problem, since it is
simply pages which have to be mapped for handling from userspace

- after userspace handles everything(includes net send over this buffer) on
the recv buffer, send another fused command or new OP to ask kernel to
release buffer by completing fused command(A). However, one corner case
is that this fuse command needs to be completed automatically when
io_uring exits since app is dead at that time.

It should be easy to extend fused command in above way(slave less)
since V4 starts to support normal 64byte SQE, and we have enough uring
command flags.

But not sure if that is what you need. If not, please explain a bit
your exact requirement.

> 
> I haven't got a chance to work on it but will return to it in
> a week. The discussion was here:
> 
> https://lore.kernel.org/all/ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com/


Thanks,
Ming

