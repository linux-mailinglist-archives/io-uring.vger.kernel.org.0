Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E666CD548
	for <lists+io-uring@lfdr.de>; Wed, 29 Mar 2023 10:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjC2Ixo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Mar 2023 04:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjC2Ixj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Mar 2023 04:53:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4224D40DB
        for <io-uring@vger.kernel.org>; Wed, 29 Mar 2023 01:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680079953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GaNT2Og1QOD5grKCAXED7/s8sdTatYwvipTFRccPuKo=;
        b=KSINstsgLZa3El9wgSozbDnJf6eUTbecTIYJ5TI1FYR+bJiVyXOTOzLemo41nDlumOggVS
        yokoKqM34zXsAxoBMCp2xkMUlPkWAyoRxmnNe06gFFWEhO4xsSCh67l++G4m9AP1h7pJvJ
        oy73GLvZ9dasm94rLpQ/S4SIT4w3Xdg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-_YcrxN-_MXmPumzneapgwQ-1; Wed, 29 Mar 2023 04:52:29 -0400
X-MC-Unique: _YcrxN-_MXmPumzneapgwQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F03DA101A550;
        Wed, 29 Mar 2023 08:52:28 +0000 (UTC)
Received: from ovpn-8-26.pek2.redhat.com (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F043918EC2;
        Wed, 29 Mar 2023 08:52:22 +0000 (UTC)
Date:   Wed, 29 Mar 2023 16:52:16 +0800
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
Message-ID: <ZCP8QEBC8cL5CKa8@ovpn-8-26.pek2.redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
 <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
 <ded5b188-0bcd-3003-353e-b31608e58be4@linux.alibaba.com>
 <ZCI6ifwZwwaM6TFw@ovpn-8-20.pek2.redhat.com>
 <1004bd4d-d74e-f1de-0e60-6532fc526c85@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1004bd4d-d74e-f1de-0e60-6532fc526c85@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 29, 2023 at 02:57:38PM +0800, Ziyang Zhang wrote:
> On 2023/3/28 08:53, Ming Lei wrote:
> > Hi Ziyang,
> > 
> > On Tue, Mar 21, 2023 at 05:17:56PM +0800, Ziyang Zhang wrote:
> >> On 2023/3/19 00:23, Pavel Begunkov wrote:
> >>> On 3/16/23 03:13, Xiaoguang Wang wrote:
> >>>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> >>>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> >>>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> >>>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> >>>>> and its ->issue() can retrieve/import buffer from master request's
> >>>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> >>>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> >>>>> submits slave OP just like normal OP issued from userspace, that said,
> >>>>> SQE order is kept, and batching handling is done too.
> >>>> Thanks for this great work, seems that we're now in the right direction
> >>>> to support ublk zero copy, I believe this feature will improve io throughput
> >>>> greatly and reduce ublk's cpu resource usage.
> >>>>
> >>>> I have gone through your 2th patch, and have some little concerns here:
> >>>> Say we have one ublk loop target device, but it has 4 backend files,
> >>>> every file will carry 25% of device capacity and it's implemented in stripped
> >>>> way, then for every io request, current implementation will need issed 4
> >>>> fused_cmd, right? 4 slave sqes are necessary, but it would be better to
> >>>> have just one master sqe, so I wonder whether we can have another
> >>>> method. The key point is to let io_uring support register various kernel
> >>>> memory objects, which come from kernel, such as ITER_BVEC or
> >>>> ITER_KVEC. so how about below actions:
> >>>> 1. add a new infrastructure in io_uring, which will support to register
> >>>> various kernel memory objects in it, this new infrastructure could be
> >>>> maintained in a xarray structure, every memory objects in it will have
> >>>> a unique id. This registration could be done in a ublk uring cmd, io_uring
> >>>> offers registration interface.
> >>>> 2. then any sqe can use these memory objects freely, so long as it
> >>>> passes above unique id in sqe properly.
> >>>> Above are just rough ideas, just for your reference.
> >>>
> >>> It precisely hints on what I proposed a bit earlier, that makes
> >>> me not alone thinking that it's a good idea to have a design allowing
> >>> 1) multiple ops using a buffer and 2) to limiting it to one single
> >>> submission because the userspace might want to preprocess a part
> >>> of the data, multiplex it or on the opposite divide. I was mostly
> >>> coming from non ublk cases, and one example would be such zc recv,
> >>> parsing the app level headers and redirecting the rest of the data
> >>> somewhere.
> >>>
> >>> I haven't got a chance to work on it but will return to it in
> >>> a week. The discussion was here:
> >>>
> >>> https://lore.kernel.org/all/ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com/
> >>>
> >>
> >> Hi Pavel and all,
> >>
> >> I think it is a good idea to register some kernel objects(such as bvec)
> >> in io_uring and return a cookie(such as buf_idx) for READ/WRITE/SEND/RECV sqes.
> >> There are some ways to register user's buffer such as IORING_OP_PROVIDE_BUFFERS
> >> and IORING_REGISTER_PBUF_RING but there is not a way to register kernel buffer(bvec).
> >>
> >> I do not think reusing splice is a good idea because splice should run in io-wq.
> >> If we have a big sq depth there may be lots of io-wqs. Then lots of context switch
> >> may lower the IO performance especially for small IO size.
> > 
> > Agree, not only it is hard for splice to guarantee correctness of buffer lifetime,
> > but also it is much less efficient to support the feature in one very ugly way, not
> > mention Linus objects to extend splice wrt. buffer direction issue, see the reasoning
> > in my document:
> > 
> > https://github.com/ming1/linux/blob/my_v6.3-io_uring_fuse_cmd_v4/Documentation/block/ublk.rst#zero-copy
> > 
> >>
> >> Here are some rough ideas:
> >> (1) design a new OPCODE such as IORING_REGISTER_KOBJ to register kernel objects in
> >>     io_uring or
> >> (2) reuse uring-cmd. We can send uring-cmd to drivers(opcode may be CMD_REGISTER_KBUF)
> >>     and let drivers call io_uring_provide_kbuf() to register kbuf. io_uring_provide_kbuf()
> >>     is a new function provided by io_uring for drivers.
> >> (3) let the driver call io_uring_provide_kbuf() directly. For ublk, this function is called
> >>     before io_uring_cmd_done().
> > 
> > Can you explain a bit which use cases you are trying to address by
> > registering kernel io buffer unmapped to userspace?
> 
> Hi Ming,
> 
> Sorry there is no specific use case. In our product, we have to calculate cksum
> or compress data before sending IO to remote backend. So Xiaoguang's EBPF might
> be the final solution... :) But I'd rather to start here...

If chsum calculation and compression are done in userspace, the current zero
copy can't help you because the fused command is for sharing ublk client
io buffer to io_uring OPs only. And userspace has to reply on data copy
for checksum & compression.

ebpf could help you, but that is still one big project, not sure if
current prog is allowed to get kernel mapping of pages and read/write
via the kernel mapping.

> 
> I think you, Pavel and I all have the same basic idea: register the kernel object
> (bvec) first then incoming sqes can use it. But I think fused-cmd is too specific
> (hack) to ublk so other users of io_uring may not benefit from it.

fused command is actually one generic interface:

1) create relationship between primary command and secondary requests,
the current interface does support to setup 1:N relationship, and just
needs multiple secondary reqs following the primary command. If you
think following SQEs isn't flexible, you still can send multiple fused
requests with same primary cmd to relax the usage of following SQEs.

2) based on the above relationship, lots of thing can be done, sharing
buffer is just one function, it could be other kind of resource sharing.
The 'sharing' can be implemented as plugin way, such as passing
uring_command flags for specifying which kind of plugin is used.

I have re-organized code in my local repo in the above way.


> What if we design a general way which allows io_uring to register kernel objects
> (such as bvec) just like IORING_OP_PROVIDE_BUFFERS or IORING_REGISTER_PBUF_RING?
> Pavel said that registration replaces fuse master cmd. And I think so too.

The buffer belongs to device, not io_uring context. And the registration
isn't necessary, and not sure it is doable:

1) userspace hasn't buffer mapping, so can't use the buffer, you can't
calculate checksum and compress data by this registration

2) you just want to use the register id to build the relationship between
primary command and secondary OPs, but fused command can do it(see above)
because we want to solve buffer lifetime easily, fused command has same
lifetime with the buffer reference

3) not sure if the buffer registration is doable:

- only 1 sqe flags is left, how to distinguish normal fixed buffer
  with this kind of registration?

- the buffer belongs to device, if you register it in userspace, you
  have to unregister it in userspace since only userspace knows
  when the buffer isn't needed. Then this buffer lifetime will cross
  multiple OPs, what if the userspace is killed before unregistration.

So what is your real requirement for the buffer registration? I believe
fused command can solve requests relationship building(primary cmd vs.
secondary requests), which seems your only concern about buffer
registration.

> 
> > 
> > The buffer(request buffer, represented by bvec) are just bvecs, basically only
> > physical pages available, and the userspace does not have mapping(virtual address)
> > on this buffer and can't read/write the buffer, so I don't think it makes sense
> > to register the buffer somewhere for userspace, does it?
> 
> The userspace does not touch these registered kernel bvecs, but reference it id.
> For example, we can set "sqe->kobj_id" so this sqe can import this bvec as its
> RW buffer just like IORING_OP_PROVIDE_BUFFERS.
> 
> There is limitation on fused-cmd: secondary sqe has to be primary+1 or be linked.
> But with registration way we allow multiple OPs reference the kernel bvecs.

The interface in V5 actually starts to supports to 1:N relation between primary cmd
and secondary requests, but just implements 1:1 so far. It isn't hard to do 1:N.

Actually you can reach same purpose by sending multiple fused requests with same
primary req, and there shouldn't be performance effect since the primary command
handling is pretty thin(passing buffer reference).

> However
> we have to deal with buffer ownership/lifetime carefully.

That is one fundamental problem. If buffer is allowed to cross multiple
OPs, it can be hard to solve the lifetime issue. Not mention it is less efficient
to add one extra buffer un-registraion in fast io path.

> 
> > 
> > That said the buffer should only be used by kernel, such as io_uring normal OPs.
> > It is basically invisible for userspace, 
> > 
> > However, Xiaoguang's BPF might be one perfect supplement here[1], such as:
> > 
> > - add one generic io_uring BPF OP, which can run one specified registered BPF
> > program by passing bpf_prog_id
> > 
> > - link this BPF OP as slave request of fused command, then the ebpf prog can do
> > whatever on the kernel pages if kernel mapping & buffer read/write is allowed
> > for ebpf prog, and results can be returned into user via any bpf mapping(s)
> 
> In Xiaoguang's ublk-EBPF design, we almost avoid userspace code/logic while
> handling ublk io. So mix fused-cmd with ublk-EBPF may be a bad idea.

What I meant is to add io_uring generic ebpf OP, that isn't ublk dedicated ebpf.

The generic io_uring ebpf OP is for supporting encryption, checksum, or
simple packet parsing,  sort of thing, because the bvec buffer doesn't
have userspace mapping, and we want to avoid to copy data to userspace for
calculating checksum, encryption, ...

> 
> > 
> > - then userspace can decide how to handle the result from bpf mapping(s), such as,
> > submit another fused command to handle IO with part of the kernel buffer.
> > 
> > Also the buffer is io buffer, and its lifetime is pretty short, and register/
> > unregister introduces unnecessary cost in fast io path for any approach.
> 
> I'm not sure the io buffer has short lifetime in our product. :P In our product
> we can first issue a very big request with a big io buffer. Then the backend
> can parse&split it into pieces and distribute each piece to a specific socket_fd
> representing a storage node. This big io buffer may have long lifetime.

The short just means it is in fast io path, not like io_uring fixed buffer which
needs to register just once. IO handling is really fast, otherwise it isn't necessary
to consider zero copy at all.

So we do care performance effect from any unneccessary operation(such
as, buffer unregistration).


Thanks,
Ming

