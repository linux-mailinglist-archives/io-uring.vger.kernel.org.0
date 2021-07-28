Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1BB3D87A7
	for <lists+io-uring@lfdr.de>; Wed, 28 Jul 2021 08:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhG1GGN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jul 2021 02:06:13 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:49608 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233574AbhG1GGN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jul 2021 02:06:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UhDmBEo_1627452370;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UhDmBEo_1627452370)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Jul 2021 14:06:10 +0800
Subject: Re: [PATCH io_uring-5.14 v2] io_uring: remove double poll wait entry
 for pure poll
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210723092227.137526-1-haoxu@linux.alibaba.com>
 <c628d5bc-ee34-bf43-c7bc-5b52cf983cb1@gmail.com>
 <824dcbe0-34da-a075-12eb-ce7529f3e3f7@linux.alibaba.com>
 <28ce8b3d-e9d2-2fed-e73c-fb09913eea78@gmail.com>
 <a5321436-9ba5-5f07-6081-4567f9469631@linux.alibaba.com>
 <85703a7e-40cd-1f80-9ca4-9c0a2f665e45@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <a2c176ac-99b3-c95d-18f2-60c621419c26@linux.alibaba.com>
Date:   Wed, 28 Jul 2021 14:06:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <85703a7e-40cd-1f80-9ca4-9c0a2f665e45@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/7/28 上午6:46, Jens Axboe 写道:
> On 7/26/21 8:39 AM, Hao Xu wrote:
>> 在 2021/7/26 下午8:40, Pavel Begunkov 写道:
>>> On 7/24/21 5:48 AM, Hao Xu wrote:
>>>> 在 2021/7/23 下午10:31, Pavel Begunkov 写道:
>>>>> On 7/23/21 10:22 AM, Hao Xu wrote:
>>>>>> For pure poll requests, we should remove the double poll wait entry.
>>>>>> And io_poll_remove_double() is good enough for it compared with
>>>>>> io_poll_remove_waitqs().
>>>>>
>>>>> 5.14 in the subject hints me that it's a fix. Is it?
>>>>> Can you add what it fixes or expand on why it's better?
>>>> Hi Pavel, I found that for poll_add() requests, it doesn't remove the
>>>> double poll wait entry when it's done, neither after vfs_poll() or in
>>>> the poll completion handler. The patch is mainly to fix it.
>>>
>>> Ok, sounds good. Please resend with updated description, and
>>> let's add some tags.
>>>
>>> Fixes: 88e41cf928a6 ("io_uring: add multishot mode for IORING_OP_POLL_ADD")
>>> Cc: stable@vger.kernel.org # 5.13+
>>>
>>> Also, I'd prefer the commit title to make more clear that it's a
>>> fix. E.g. "io_uring: fix poll requests leaking second poll entries".
>>>
>>> Btw, seems it should fix hangs in ./poll-mshot-update
>> Sure，I'll send v3 soon, sorry for my unprofessionalism..
> 
> Are you going to send out v3?
> 
v3 sent. Btw I'm working on letting fast poll support multishot,
I believe that will benefit non-persistent programming, let's see
if it helps accept().


