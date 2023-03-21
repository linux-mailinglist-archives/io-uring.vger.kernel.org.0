Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8476C2DB3
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 10:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCUJSF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 05:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCUJSE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 05:18:04 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE282A15E;
        Tue, 21 Mar 2023 02:18:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VeMa7mK_1679390277;
Received: from 30.97.57.9(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VeMa7mK_1679390277)
          by smtp.aliyun-inc.com;
          Tue, 21 Mar 2023 17:17:57 +0800
Message-ID: <ded5b188-0bcd-3003-353e-b31608e58be4@linux.alibaba.com>
Date:   Tue, 21 Mar 2023 17:17:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH V3 00/16] io_uring/ublk: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <fd30b561-86dd-5061-714f-e46058f7079f@linux.alibaba.com>
 <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <845ff5cb-b0ff-8ea0-e2ff-a5b216966dfb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023/3/19 00:23, Pavel Begunkov wrote:
> On 3/16/23 03:13, Xiaoguang Wang wrote:
>>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>>> and its ->issue() can retrieve/import buffer from master request's
>>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>>> submits slave OP just like normal OP issued from userspace, that said,
>>> SQE order is kept, and batching handling is done too.
>> Thanks for this great work, seems that we're now in the right direction
>> to support ublk zero copy, I believe this feature will improve io throughput
>> greatly and reduce ublk's cpu resource usage.
>>
>> I have gone through your 2th patch, and have some little concerns here:
>> Say we have one ublk loop target device, but it has 4 backend files,
>> every file will carry 25% of device capacity and it's implemented in stripped
>> way, then for every io request, current implementation will need issed 4
>> fused_cmd, right? 4 slave sqes are necessary, but it would be better to
>> have just one master sqe, so I wonder whether we can have another
>> method. The key point is to let io_uring support register various kernel
>> memory objects, which come from kernel, such as ITER_BVEC or
>> ITER_KVEC. so how about below actions:
>> 1. add a new infrastructure in io_uring, which will support to register
>> various kernel memory objects in it, this new infrastructure could be
>> maintained in a xarray structure, every memory objects in it will have
>> a unique id. This registration could be done in a ublk uring cmd, io_uring
>> offers registration interface.
>> 2. then any sqe can use these memory objects freely, so long as it
>> passes above unique id in sqe properly.
>> Above are just rough ideas, just for your reference.
> 
> It precisely hints on what I proposed a bit earlier, that makes
> me not alone thinking that it's a good idea to have a design allowing
> 1) multiple ops using a buffer and 2) to limiting it to one single
> submission because the userspace might want to preprocess a part
> of the data, multiplex it or on the opposite divide. I was mostly
> coming from non ublk cases, and one example would be such zc recv,
> parsing the app level headers and redirecting the rest of the data
> somewhere.
> 
> I haven't got a chance to work on it but will return to it in
> a week. The discussion was here:
> 
> https://lore.kernel.org/all/ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com/
> 

Hi Pavel and all,

I think it is a good idea to register some kernel objects(such as bvec)
in io_uring and return a cookie(such as buf_idx) for READ/WRITE/SEND/RECV sqes.
There are some ways to register user's buffer such as IORING_OP_PROVIDE_BUFFERS
and IORING_REGISTER_PBUF_RING but there is not a way to register kernel buffer(bvec).

I do not think reusing splice is a good idea because splice should run in io-wq.
If we have a big sq depth there may be lots of io-wqs. Then lots of context switch
may lower the IO performance especially for small IO size.

Here are some rough ideas:
(1) design a new OPCODE such as IORING_REGISTER_KOBJ to register kernel objects in
    io_uring or
(2) reuse uring-cmd. We can send uring-cmd to drivers(opcode may be CMD_REGISTER_KBUF)
    and let drivers call io_uring_provide_kbuf() to register kbuf. io_uring_provide_kbuf()
    is a new function provided by io_uring for drivers.
(3) let the driver call io_uring_provide_kbuf() directly. For ublk, this function is called
    before io_uring_cmd_done().

Regards,
Zhang
