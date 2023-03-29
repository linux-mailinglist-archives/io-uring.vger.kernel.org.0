Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6706CD261
	for <lists+io-uring@lfdr.de>; Wed, 29 Mar 2023 08:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjC2G5q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Mar 2023 02:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC2G5p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Mar 2023 02:57:45 -0400
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FFD2111;
        Tue, 28 Mar 2023 23:57:43 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Vevn4LL_1680073059;
Received: from 30.97.56.166(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0Vevn4LL_1680073059)
          by smtp.aliyun-inc.com;
          Wed, 29 Mar 2023 14:57:40 +0800
Message-ID: <1004bd4d-d74e-f1de-0e60-6532fc526c85@linux.alibaba.com>
Date:   Wed, 29 Mar 2023 14:57:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
 <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
 <ded5b188-0bcd-3003-353e-b31608e58be4@linux.alibaba.com>
 <ZCI6ifwZwwaM6TFw@ovpn-8-20.pek2.redhat.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <ZCI6ifwZwwaM6TFw@ovpn-8-20.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023/3/28 08:53, Ming Lei wrote:
> Hi Ziyang,
> 
> On Tue, Mar 21, 2023 at 05:17:56PM +0800, Ziyang Zhang wrote:
>> On 2023/3/19 00:23, Pavel Begunkov wrote:
>>> On 3/16/23 03:13, Xiaoguang Wang wrote:
>>>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>>>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>>>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>>>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>>>>> and its ->issue() can retrieve/import buffer from master request's
>>>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>>>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>>>>> submits slave OP just like normal OP issued from userspace, that said,
>>>>> SQE order is kept, and batching handling is done too.
>>>> Thanks for this great work, seems that we're now in the right direction
>>>> to support ublk zero copy, I believe this feature will improve io throughput
>>>> greatly and reduce ublk's cpu resource usage.
>>>>
>>>> I have gone through your 2th patch, and have some little concerns here:
>>>> Say we have one ublk loop target device, but it has 4 backend files,
>>>> every file will carry 25% of device capacity and it's implemented in stripped
>>>> way, then for every io request, current implementation will need issed 4
>>>> fused_cmd, right? 4 slave sqes are necessary, but it would be better to
>>>> have just one master sqe, so I wonder whether we can have another
>>>> method. The key point is to let io_uring support register various kernel
>>>> memory objects, which come from kernel, such as ITER_BVEC or
>>>> ITER_KVEC. so how about below actions:
>>>> 1. add a new infrastructure in io_uring, which will support to register
>>>> various kernel memory objects in it, this new infrastructure could be
>>>> maintained in a xarray structure, every memory objects in it will have
>>>> a unique id. This registration could be done in a ublk uring cmd, io_uring
>>>> offers registration interface.
>>>> 2. then any sqe can use these memory objects freely, so long as it
>>>> passes above unique id in sqe properly.
>>>> Above are just rough ideas, just for your reference.
>>>
>>> It precisely hints on what I proposed a bit earlier, that makes
>>> me not alone thinking that it's a good idea to have a design allowing
>>> 1) multiple ops using a buffer and 2) to limiting it to one single
>>> submission because the userspace might want to preprocess a part
>>> of the data, multiplex it or on the opposite divide. I was mostly
>>> coming from non ublk cases, and one example would be such zc recv,
>>> parsing the app level headers and redirecting the rest of the data
>>> somewhere.
>>>
>>> I haven't got a chance to work on it but will return to it in
>>> a week. The discussion was here:
>>>
>>> https://lore.kernel.org/all/ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com/
>>>
>>
>> Hi Pavel and all,
>>
>> I think it is a good idea to register some kernel objects(such as bvec)
>> in io_uring and return a cookie(such as buf_idx) for READ/WRITE/SEND/RECV sqes.
>> There are some ways to register user's buffer such as IORING_OP_PROVIDE_BUFFERS
>> and IORING_REGISTER_PBUF_RING but there is not a way to register kernel buffer(bvec).
>>
>> I do not think reusing splice is a good idea because splice should run in io-wq.
>> If we have a big sq depth there may be lots of io-wqs. Then lots of context switch
>> may lower the IO performance especially for small IO size.
> 
> Agree, not only it is hard for splice to guarantee correctness of buffer lifetime,
> but also it is much less efficient to support the feature in one very ugly way, not
> mention Linus objects to extend splice wrt. buffer direction issue, see the reasoning
> in my document:
> 
> https://github.com/ming1/linux/blob/my_v6.3-io_uring_fuse_cmd_v4/Documentation/block/ublk.rst#zero-copy
> 
>>
>> Here are some rough ideas:
>> (1) design a new OPCODE such as IORING_REGISTER_KOBJ to register kernel objects in
>>     io_uring or
>> (2) reuse uring-cmd. We can send uring-cmd to drivers(opcode may be CMD_REGISTER_KBUF)
>>     and let drivers call io_uring_provide_kbuf() to register kbuf. io_uring_provide_kbuf()
>>     is a new function provided by io_uring for drivers.
>> (3) let the driver call io_uring_provide_kbuf() directly. For ublk, this function is called
>>     before io_uring_cmd_done().
> 
> Can you explain a bit which use cases you are trying to address by
> registering kernel io buffer unmapped to userspace?

Hi Ming,

Sorry there is no specific use case. In our product, we have to calculate cksum
or compress data before sending IO to remote backend. So Xiaoguang's EBPF might
be the final solution... :) But I'd rather to start here...

I think you, Pavel and I all have the same basic idea: register the kernel object
(bvec) first then incoming sqes can use it. But I think fused-cmd is too specific
(hack) to ublk so other users of io_uring may not benefit from it.

What if we design a general way which allows io_uring to register kernel objects
(such as bvec) just like IORING_OP_PROVIDE_BUFFERS or IORING_REGISTER_PBUF_RING?
Pavel said that registration replaces fuse master cmd. And I think so too.

> 
> The buffer(request buffer, represented by bvec) are just bvecs, basically only
> physical pages available, and the userspace does not have mapping(virtual address)
> on this buffer and can't read/write the buffer, so I don't think it makes sense
> to register the buffer somewhere for userspace, does it?

The userspace does not touch these registered kernel bvecs, but reference it id.
For example, we can set "sqe->kobj_id" so this sqe can import this bvec as its
RW buffer just like IORING_OP_PROVIDE_BUFFERS.

There is limitation on fused-cmd: secondary sqe has to be primary+1 or be linked.
But with registration way we allow multiple OPs reference the kernel bvecs. However
we have to deal with buffer ownership/lifetime carefully.

> 
> That said the buffer should only be used by kernel, such as io_uring normal OPs.
> It is basically invisible for userspace, 
> 
> However, Xiaoguang's BPF might be one perfect supplement here[1], such as:
> 
> - add one generic io_uring BPF OP, which can run one specified registered BPF
> program by passing bpf_prog_id
> 
> - link this BPF OP as slave request of fused command, then the ebpf prog can do
> whatever on the kernel pages if kernel mapping & buffer read/write is allowed
> for ebpf prog, and results can be returned into user via any bpf mapping(s)

In Xiaoguang's ublk-EBPF design, we almost avoid userspace code/logic while
handling ublk io. So mix fused-cmd with ublk-EBPF may be a bad idea.

> 
> - then userspace can decide how to handle the result from bpf mapping(s), such as,
> submit another fused command to handle IO with part of the kernel buffer.
> 
> Also the buffer is io buffer, and its lifetime is pretty short, and register/
> unregister introduces unnecessary cost in fast io path for any approach.

I'm not sure the io buffer has short lifetime in our product. :P In our product
we can first issue a very big request with a big io buffer. Then the backend
can parse&split it into pieces and distribute each piece to a specific socket_fd
representing a storage node. This big io buffer may have long lifetime.

Regards,
Zhang

