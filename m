Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934E741C460
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 14:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343709AbhI2MO4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 08:14:56 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:38813 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343700AbhI2MOw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 08:14:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uq1.5JF_1632917589;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uq1.5JF_1632917589)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Sep 2021 20:13:09 +0800
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <51308ac4-03b7-0f66-7f26-8678807195ca@linux.alibaba.com>
 <96ef70e8-7abf-d820-3cca-0f8aedc969d8@gmail.com>
 <0d781b5f-3d2d-5ad4-9ad3-8fabc994313a@linux.alibaba.com>
 <11c738b2-8024-1870-d54b-79e89c5bea54@gmail.com>
 <10358b7e-9eb3-290f-34b6-5f257e98bcb9@linux.alibaba.com>
 <f9c93212-1bc9-5025-f96d-510bbde84e21@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <5af509fe-b9f7-7913-defd-4d32d4f98f4e@linux.alibaba.com>
Date:   Wed, 29 Sep 2021 20:13:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f9c93212-1bc9-5025-f96d-510bbde84e21@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/29 下午7:37, Pavel Begunkov 写道:
> On 9/29/21 10:24 AM, Hao Xu wrote:
>> 在 2021/9/28 下午6:51, Pavel Begunkov 写道:
>>> On 9/26/21 11:00 AM, Hao Xu wrote:
> [...]
>>>> I'm gonna pick this one up again, currently this patch
>>>> with ktime_get_ns() works good on our productions. This
>>>> patch makes the latency a bit higher than before, but
>>>> still lower than aio.
>>>> I haven't gotten a faster alternate for ktime_get_ns(),
>>>> any hints?
>>>
>>> Good, I'd suggest to look through Documentation/core-api/timekeeping.rst
>>> In particular coarse variants may be of interest.
>>> https://www.kernel.org/doc/html/latest/core-api/timekeeping.html#coarse-and-fast-ns-access
>>>
>> The coarse functions seems to be like jiffies, because they use the last
>> timer tick(from the explanation in that doc, it seems the timer tick is
>> in the same frequency as jiffies update). So I believe it is just
>> another format of jiffies which is low accurate.
> 
> I haven't looked into the details, but it seems that unlike jiffies for
> the coarse mode 10ms (or whatever) is the worst case, but it _may_ be
Maybe I'm wrong, but for jiffies, 10ms uis also the worst case, no?
(say HZ = 100, then jiffies updated by 1 every 10ms)
> much better on average and feasible for your case, but can't predict
> if that's really the case in a real system and what will be the
> relative error comparing to normal ktime_ns().
> 

