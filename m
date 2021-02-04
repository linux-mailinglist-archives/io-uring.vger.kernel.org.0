Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A368730F8B0
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 17:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbhBDQzx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 11:55:53 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:53559 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238172AbhBDQzQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 11:55:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UNto3f6_1612457667;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UNto3f6_1612457667)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 05 Feb 2021 00:54:27 +0800
Subject: Re: [PATCH] io_uring: fix possible deadlock in io_uring_poll
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612295573-221587-1-git-send-email-haoxu@linux.alibaba.com>
 <9d60270f-993b-ba83-29a0-ce6582c383e0@gmail.com>
 <5f0db9bc-700a-e0f5-a77c-9acfe4e56783@kernel.dk>
 <0c7cfa8b-5c32-7b00-e312-936df68553a2@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <8a4ff8ae-8c92-b4fc-7f95-6724be1f92e9@linux.alibaba.com>
Date:   Fri, 5 Feb 2021 00:54:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <0c7cfa8b-5c32-7b00-e312-936df68553a2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/2/5 上午12:48, Pavel Begunkov 写道:
> On 03/02/2021 01:48, Jens Axboe wrote:
>> On 2/2/21 5:04 PM, Pavel Begunkov wrote:
>>> On 02/02/2021 19:52, Hao Xu wrote:
>>>> This might happen if we do epoll_wait on a uring fd while reading/writing
>>>> the former epoll fd in a sqe in the former uring instance.
>>>> So let's don't flush cqring overflow list when we fail to get the uring
>>>> lock. This leads to less accuracy, but is still ok.
>>>
>>> if (io_cqring_events(ctx) || test_bit(0, &ctx->cq_check_overflow))
>>>          mask |= EPOLLIN | EPOLLRDNORM;
>>>
>>> Instead of flushing. It'd make sense if we define poll as "there might
>>> be something, go do your peek/wait with overflow checks". Jens, is that
>>> documented anywhere?
>>
>> Nope - I actually think that the approach chosen here is pretty good,
>> it'll force the app to actually check and hence do what it needs to do.
> 
> Ok, seems we agree on that.
> 
> Hao, can you send an updated patch?
> 
Sure, will send v2 soon.
