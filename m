Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F3A4D1260
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 09:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiCHIjF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 03:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbiCHIjE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 03:39:04 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889F61D30A
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 00:38:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0V6dNU90_1646728685;
Received: from 30.225.28.121(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V6dNU90_1646728685)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Mar 2022 16:38:05 +0800
Message-ID: <9938e76f-420d-c20e-fb46-a75fa960f284@linux.alibaba.com>
Date:   Tue, 8 Mar 2022 16:38:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <66bfc962-b983-e737-7c36-85784c52b7fa@kernel.dk>
 <8466f91e-416e-d53e-8c24-47a0b20412ac@kernel.dk>
 <968510d6-6101-ca0f-95a0-f8cb8807b0da@kernel.dk>
 <6b1a48d5-7991-b686-06fa-22ac23650992@kernel.dk>
 <3a59a3e1-4aa8-6970-23b6-fd331fb2c75c@linux.alibaba.com>
 <43e733d9-f62d-34b5-318c-e1abaf8cc4a3@kernel.dk>
 <b12cd9d2-ee0a-430a-e909-608621c87dcc@linux.alibaba.com>
 <044ccbcd-2339-dc67-2af5-b599c37b7114@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <044ccbcd-2339-dc67-2af5-b599c37b7114@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

>>> I'll take a look at liburing and see what we need to do there. I think
>>> the sanest thing to do here is say that using a registered ring fd means
>>> you cannot share the ring, ever. And then just have a
>>> ring->enter_ring_fd which is normally just set to ring_fd when the ring
>>> is setup, and if you register the ring fd, then we set it to whatever
>>> the registered value is. Everything calling io_uring_enter() then just
>>> needs to be modified to use ->enter_ring_fd instead of ->ring_fd.
>> ok, look forward to use this api.
> Can you take a look at the registered-ring branch for liburing:
>
> https://git.kernel.dk/cgit/liburing/log/?h=registered-ring
>
> which has the basic plumbing for it. Comments (or patches) welcome!
Sorry for late reply, spend time to read your patch today. Basically it 
looks ok,
there is one minor issue in "Add preliminary support for using a 
registered ring fd":
@@ -417,6 +425,10 @@ struct io_uring_sqe *io_uring_get_sqe(struct 
io_uring *ring)

  int __io_uring_sqring_wait(struct io_uring *ring)
  {
-    return  ____sys_io_uring_enter(ring->ring_fd, 0, 0,
-                       IORING_ENTER_SQ_WAIT, NULL);
+    int flags = IORING_ENTER_SQ_WAIT;
+
+    if (ring->int_flags & INT_FLAG_REG_RING)
+        flags |= IORING_ENTER_REGISTERED_RING;
+
+    return  ____sys_io_uring_enter(ring->ring_fd, 0, 0, flags, NULL);
  }

Here it should be enter_ring_fd.

>
> Few things I don't really love:
>
> 1) You need to call io_uring_register_ring_fd() after setting up the
>     ring. We could provide init helpers for that, which just do queue
>     init and then register ring. Maybe that'd make it more likely to get
>     picked up by applications.
Agree, that'd be better in some cases, but consider that currently the 
capacity of ring
fd cache is just 16, I'd suggest to let users make their own decisions, 
in case some
ring fds could not allocate one empty slot, but some ring fds don't need 
them at all,
for example, ring fd which enable sqpoll may no need this feature.

>
> 2) For the setup where you do share the ring between a submitter and
>     reaper, we need to ensure that the registered ring fd is the same
>     between both of them. We need a helper for that. It's basically the
>     same as io_uring_register_ring_fd(), but we need the specific offset.
>     And if that fails with -EBUSY, we should just turn off
>     INT_FLAG_RING_REG for the ring and you don't get the registered fd
>     for either of them. At least it can be handled transparantly.
Storing enter_ring_fd in struct io_uring seems not good, struct io_uring 
is a shared struct,
as what you say, different threads that share one ring fd may have 
differed offset in ring fd
cache. I have two suggestions:
1) Threads keep their offset in ring fd cache alone, and pass it to 
io_uring_submit, which may
look ugly :)
2) define enter_ring_fd in struct io_ring to be a thread_local type, 
then your patches don't
need to do any modifications.

Regards,
Xiaoguang Wang
>
>>>>> Anyway, current version below. Only real change here is allowing either
>>>>> specific offset or generated offset, depending on what the
>>>>> io_uring_rsrc_update->offset is set to. If set to -1U, then io_uring
>>>>> will find a free offset. If set to anything else, io_uring will use that
>>>>> index (as long as it's >=0 && < MAX).
>>>> Seems you forgot to attach the newest version, and also don't see a
>>>> patch attachment. Finally, thanks for your quick response and many
>>>> code improvements, really appreciate it.
>>> Oops, below now. How do you want to handle this patch? It's now a bit of
>>> a mix of both of our stuff...
>> Since you have almost rewritten most of my original patch and now it
>> looks much better, so I would suggest just adds my Reported-by :)
> OK I'll post it, but Co-developed-by is probably a better one.
>

