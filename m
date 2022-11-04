Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E07361A5E4
	for <lists+io-uring@lfdr.de>; Sat,  5 Nov 2022 00:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiKDXhc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 19:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKDXhb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 19:37:31 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF2E26117;
        Fri,  4 Nov 2022 16:37:27 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 0E06832008FB;
        Fri,  4 Nov 2022 19:37:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 04 Nov 2022 19:37:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1667605044; x=
        1667691444; bh=KPSj58myQkOWoEMJnn+Mf3F8dNGI3qP/0VDwKyDorz0=; b=h
        hfOv2yw3rF4PWlowL6L1d88Kh1z02uXbUQ1RaWnFSmMgauOUFqO/HzAl40VJc+Iq
        qA9DIVVcL3RPScaZS7cUNCr9ihPV7IvdUsPtH9vPBoXSIfB0vOOD7YjjrKTOG11o
        rStzQeNwRuXNLHNlczO3tlBkGw8wlPO4lnvscup7SOl9ef188JeNK5ru+D5j9DtS
        XvjXfUyEEEEaxSYOtz4AX1yBsd9/bGQoW3705kEicfRaWKg2HfwIyVbT9J+koonV
        JT1Pai6SXaomRAFlmlIjcrTXpEpPCT8SfCwDH/XksrzPFNvoi/L8ES6nCs7qpox4
        xAYZ9uB/YAJaAq+46ye3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1667605044; x=
        1667691444; bh=KPSj58myQkOWoEMJnn+Mf3F8dNGI3qP/0VDwKyDorz0=; b=S
        XQN2VEuWylrzlq+TNLLhv5pcrXqlcvxLsE9vac+kngk5ISsp3X5ZKqPuO/JVNA5x
        oavsCVbtyf4j0Onvsy6ror852I/v5LMGMNOE8+XWL0wIpsCjvijHZa61bMq5WKCL
        BEpX9eLePIsaZQtJ7JyrggTqRfra0dDb0AEQZgrZuPMqMrPMGg7fFkYGnsdgMS0D
        BltXpx46eS99apnjdUV4/X+yHEJrytz97X/CJUj8sLd/cq5vRMCm55Ab/AsqKOwR
        BYn6zD6Fs568uQ8ZzJRrnkjXo4lKHlCwv8Qf09FqRgOEB4racW+0LLVqpsiVfdOS
        DaDpSjBov4MJ/HNDUWVkg==
X-ME-Sender: <xms:NKJlY7_-2A2kteFlgTn4e_7EEo6QwBtytHdzvl4gNQYv0dxPWeVZcA>
    <xme:NKJlY3stTpxcKG32pLzh8AGi79o5Oex0tmPlvJVIVMK5igxWKbP0NdNxl8lc65c3f
    3Wo2Guk2xBLOfNj>
X-ME-Received: <xmr:NKJlY5A36liqmk8HqHmVO57GmwFmzJhewcKGLR2rG739l1n00mA8jLOvlKKHbBqwGNX7mcizu-FbutkwOKSa589ORoHrrONAXbEEqvmjsDSoRbkAlktX>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvddvgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkffggfgfuvfevfhfhjggtgfesthejredttdefjeenucfhrhhomhepuegvrhhn
    ugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrghilh
    drfhhmqeenucggtffrrghtthgvrhhnpeeuudekheelkeejhedvvdeifedtueelieeiuddt
    lefhveeuledugfeljeeviedtgfenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdr
    shgthhhusggvrhhtsehfrghsthhmrghilhdrfhhm
X-ME-Proxy: <xmx:NKJlY3d0SKcw6tQPE2KxiYKVibwWOL-iSqZ0Ena_I4AfZUEhv01ASA>
    <xmx:NKJlYwNFdB78ZaixwJM58CtWzkNMM0L78CWTCgN3nMF3pJWRh-zsJw>
    <xmx:NKJlY5mwLCeSRntx4BsZ-u1B2TTZG1FZk8VQpj9CTqkcvTBNmZjYnA>
    <xmx:NKJlY3cMWvqBee2k0yG4N3xDMLGJwApMsdpcouJOIDuB7oDIsEaO7A>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Nov 2022 19:37:22 -0400 (EDT)
Message-ID: <ead8a6cc-13eb-6dc0-2c17-a87e78d8a422@fastmail.fm>
Date:   Sat, 5 Nov 2022 00:37:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [RFC PATCH 4/4] ublk_drv: support splice based read/write zero
 copy
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>
References: <20221103085004.1029763-1-ming.lei@redhat.com>
 <20221103085004.1029763-5-ming.lei@redhat.com>
 <712cd802-f3bb-9840-e334-385cd42325f2@fastmail.fm> <Y2Rgem8+oYafTLVO@T590>
Content-Language: en-US
From:   Bernd Schubert <bernd.schubert@fastmail.fm>
In-Reply-To: <Y2Rgem8+oYafTLVO@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/4/22 01:44, Ming Lei wrote:
> On Thu, Nov 03, 2022 at 11:28:29PM +0100, Bernd Schubert wrote:
>>
>>
>> On 11/3/22 09:50, Ming Lei wrote:
>>> Pass ublk block IO request pages to kernel backend IO handling code via
>>> pipe, and request page copy can be avoided. So far, the existed
>>> pipe/splice mechanism works for handling write request only.
>>>
>>> The initial idea of using splice for zero copy is from Miklos and Stefan.
>>>
>>> Read request's zero copy requires pipe's change to allow one read end to
>>> produce buffers for another read end to consume. The added SPLICE_F_READ_TO_READ
>>> flag is for supporting this feature.
>>>
>>> READ is handled by sending IORING_OP_SPLICE with SPLICE_F_DIRECT |
>>> SPLICE_F_READ_TO_READ. WRITE is handled by sending IORING_OP_SPLICE with
>>> SPLICE_F_DIRECT. Kernel internal pipe is used for simplifying userspace,
>>> meantime potential info leak could be avoided.
>>
>>
>> Sorry to ask, do you have an ublk branch that gives an example how to use
>> this?
> 
> Follows the ublk splice-zc branch:
> 
> https://github.com/ming1/ubdsrv/commits/splice-zc
> 
> which is mentioned in cover letter, but I guess it should be added to
> here too, sorry for that, so far only ublk-loop supports it by:
> 
>     ublk add -t loop -f $BACKING -z
> 
> without '-z', ublk-loop is created with zero copy disabled.

Ah, thanks a lot! And sorry, I had missed this part in the cover letter.

I will take a look on your new zero copy code on Monday.


> 
>>
>> I still have several things to fix in my branches, but I got basic fuse
>> uring with copies working. Adding back splice would be next after posting
>> rfc patches. My initial assumption was that I needed to duplicate everything
>> splice does into the fuse .uring_cmd handler - obviously there is a better
>> way with your patches.
>>
>> This week I have a few days off, by end of next week or the week after I
>> might have patches in an rfc state (one thing I'm going to ask about is how
>> do I know what is the next CQE in the kernel handler - ublk does this with
>> tags through mq, but I don't understand yet where the tag is increased and
>> what the relation between tag and right CQE order is).
> 
> tag is one attribute of io request, which is originated from ublk
> driver, and it is unique for each request among one queue. So ublksrv
> won't change it at all, just use it, and ublk driver guarantees that
> it is unique.
> 
> In ublkserv implementation, the tag info is set in cqe->user_data, so
> we can retrieve the io request via tag part of cqe->user_data.

Yeah, this is the easy part I understood. At least I hope so :)

> 
> Also I may not understand your question of 'the relation between tag and right
> CQE order', io_uring provides IOSQE_IO_DRAIN/IOSQE_IO_LINK for ordering
> SQE, and ublksrv only applies IOSQE_IO_LINK in ublk-qcow2, so care to
> explain it in a bit details about the "the relation between tag and right
> CQE order"?


For fuse (kernel) a vfs request comes in and I need to choose a command 
in the ring queue. Right now this is just an atomic counter % queue_size

fuse_request_alloc_ring()
	req_cnt = atomic_inc_return(&queue->req_cnt);
	tag = req_cnt & (fc->ring.queue_depth - 1); /* cnt % queue_depth */

	ring_req = &queue->ring_req[tag];



I might be wrong, but I think that can be compared a bit to 
ublk_queue_rq(). Looks like ublk_queue_rq gets called in blk-mq context 
and blk-mq seems to provide rq->tag, which then determines the command 
in the ring queue - completion of commands is done in tag-order provided 
by blk-mq? The part I didn't figure out yet is where the tag value gets set.
Also interesting is that there is no handler if the ring is already full 
- like the ublk_io command is currently busy in ublksrv (user space). 
Handled auto-magically with blk-mq?
This is one of the parts not handled in my fuse code yet and my current 
plan is to have a request queue on top of the (per core) ring queues. 
Similar to the existing fuse request queue, just not one, but per ring 
queue and processed by the ring queue. Unless there is a better way - 
which is another reason to understand how ublk handles this.


Thanks,
Bernd

