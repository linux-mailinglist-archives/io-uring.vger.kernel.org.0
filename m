Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8CE6CB2E8
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 02:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjC1Ayd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 20:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjC1Ayc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 20:54:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB3410CB
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 17:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679964826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7uKDsuoIvADC1EAt/1iiUigmYYoFAZqXm6qo0C/1x6E=;
        b=jECZsXgZqxtmcWLrzDEHxPJAUZ3HP/4iwvQ0dBlu3fPuFZBwSxtMj2Sh6cx2PLWM/qLW/A
        nq8nZfGOrddaXR4+57pIcznYHzPldRWTY1ZuqlWIqYR9WkO4aJ3yOcJR88TKbJlVzaCR7q
        ggHnznhBDw2dCroPYOeW9FIvEvAycn0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-fyeSO611O2C8bj8cb43KJw-1; Mon, 27 Mar 2023 20:53:41 -0400
X-MC-Unique: fyeSO611O2C8bj8cb43KJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84F23185A78F;
        Tue, 28 Mar 2023 00:53:40 +0000 (UTC)
Received: from ovpn-8-20.pek2.redhat.com (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA3494020C82;
        Tue, 28 Mar 2023 00:53:34 +0000 (UTC)
Date:   Tue, 28 Mar 2023 08:53:29 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <ZCI6ifwZwwaM6TFw@ovpn-8-20.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
 <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
 <ded5b188-0bcd-3003-353e-b31608e58be4@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ded5b188-0bcd-3003-353e-b31608e58be4@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Ziyang,

On Tue, Mar 21, 2023 at 05:17:56PM +0800, Ziyang Zhang wrote:
> On 2023/3/19 00:23, Pavel Begunkov wrote:
> > On 3/16/23 03:13, Xiaoguang Wang wrote:
> >>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> >>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> >>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> >>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> >>> and its ->issue() can retrieve/import buffer from master request's
> >>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> >>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> >>> submits slave OP just like normal OP issued from userspace, that said,
> >>> SQE order is kept, and batching handling is done too.
> >> Thanks for this great work, seems that we're now in the right direction
> >> to support ublk zero copy, I believe this feature will improve io throughput
> >> greatly and reduce ublk's cpu resource usage.
> >>
> >> I have gone through your 2th patch, and have some little concerns here:
> >> Say we have one ublk loop target device, but it has 4 backend files,
> >> every file will carry 25% of device capacity and it's implemented in stripped
> >> way, then for every io request, current implementation will need issed 4
> >> fused_cmd, right? 4 slave sqes are necessary, but it would be better to
> >> have just one master sqe, so I wonder whether we can have another
> >> method. The key point is to let io_uring support register various kernel
> >> memory objects, which come from kernel, such as ITER_BVEC or
> >> ITER_KVEC. so how about below actions:
> >> 1. add a new infrastructure in io_uring, which will support to register
> >> various kernel memory objects in it, this new infrastructure could be
> >> maintained in a xarray structure, every memory objects in it will have
> >> a unique id. This registration could be done in a ublk uring cmd, io_uring
> >> offers registration interface.
> >> 2. then any sqe can use these memory objects freely, so long as it
> >> passes above unique id in sqe properly.
> >> Above are just rough ideas, just for your reference.
> > 
> > It precisely hints on what I proposed a bit earlier, that makes
> > me not alone thinking that it's a good idea to have a design allowing
> > 1) multiple ops using a buffer and 2) to limiting it to one single
> > submission because the userspace might want to preprocess a part
> > of the data, multiplex it or on the opposite divide. I was mostly
> > coming from non ublk cases, and one example would be such zc recv,
> > parsing the app level headers and redirecting the rest of the data
> > somewhere.
> > 
> > I haven't got a chance to work on it but will return to it in
> > a week. The discussion was here:
> > 
> > https://lore.kernel.org/all/ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com/
> > 
> 
> Hi Pavel and all,
> 
> I think it is a good idea to register some kernel objects(such as bvec)
> in io_uring and return a cookie(such as buf_idx) for READ/WRITE/SEND/RECV sqes.
> There are some ways to register user's buffer such as IORING_OP_PROVIDE_BUFFERS
> and IORING_REGISTER_PBUF_RING but there is not a way to register kernel buffer(bvec).
> 
> I do not think reusing splice is a good idea because splice should run in io-wq.
> If we have a big sq depth there may be lots of io-wqs. Then lots of context switch
> may lower the IO performance especially for small IO size.

Agree, not only it is hard for splice to guarantee correctness of buffer lifetime,
but also it is much less efficient to support the feature in one very ugly way, not
mention Linus objects to extend splice wrt. buffer direction issue, see the reasoning
in my document:

https://github.com/ming1/linux/blob/my_v6.3-io_uring_fuse_cmd_v4/Documentation/block/ublk.rst#zero-copy

> 
> Here are some rough ideas:
> (1) design a new OPCODE such as IORING_REGISTER_KOBJ to register kernel objects in
>     io_uring or
> (2) reuse uring-cmd. We can send uring-cmd to drivers(opcode may be CMD_REGISTER_KBUF)
>     and let drivers call io_uring_provide_kbuf() to register kbuf. io_uring_provide_kbuf()
>     is a new function provided by io_uring for drivers.
> (3) let the driver call io_uring_provide_kbuf() directly. For ublk, this function is called
>     before io_uring_cmd_done().

Can you explain a bit which use cases you are trying to address by
registering kernel io buffer unmapped to userspace?

The buffer(request buffer, represented by bvec) are just bvecs, basically only
physical pages available, and the userspace does not have mapping(virtual address)
on this buffer and can't read/write the buffer, so I don't think it makes sense
to register the buffer somewhere for userspace, does it?

That said the buffer should only be used by kernel, such as io_uring normal OPs.
It is basically invisible for userspace, 

However, Xiaoguang's BPF might be one perfect supplement here[1], such as:

- add one generic io_uring BPF OP, which can run one specified registered BPF
program by passing bpf_prog_id

- link this BPF OP as slave request of fused command, then the ebpf prog can do
whatever on the kernel pages if kernel mapping & buffer read/write is allowed
for ebpf prog, and results can be returned into user via any bpf mapping(s)

- then userspace can decide how to handle the result from bpf mapping(s), such as,
submit another fused command to handle IO with part of the kernel buffer.

Also the buffer is io buffer, and its lifetime is pretty short, and register/
unregister introduces unnecessary cost in fast io path for any approach.

Finally it is pretty easy to extend fused command[2] for supporting this kind of
interface[2], but at least you need to share your use case first.

[1] https://lwn.net/Articles/927356/
[2] https://lore.kernel.org/linux-block/ZBnTuX+5D8QeLPuQ@ovpn-8-18.pek2.redhat.com/T/#m0b8d0dcca5024765cef0439ef1d8ca3f7b38bd1c


Thanks,
Ming

