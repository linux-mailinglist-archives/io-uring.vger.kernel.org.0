Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C6F1D26AF
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 07:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgENFdf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 01:33:35 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:40920 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbgENFdf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 01:33:35 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0TyUqU3j_1589434413;
Received: from 30.225.32.37(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TyUqU3j_1589434413)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 May 2020 13:33:33 +0800
Subject: Re: regression: fixed file hang
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <67435827-eb94-380c-cdca-aee69d773d4d@kernel.dk>
 <e183e1c4-8331-93c6-a8de-c9da31e6cd56@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <ac2b8f17-dd3e-c31f-d8a0-737774a2bb92@linux.alibaba.com>
Date:   Thu, 14 May 2020 13:33:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e183e1c4-8331-93c6-a8de-c9da31e6cd56@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 5/13/20 12:45 PM, Jens Axboe wrote:
>> Hi Xiaoguang,
>>
>> Was doing some other testing today, and noticed a hang with fixed files.
>> I did a bit of poor mans bisecting, and came up with this one:
>>
>> commit 0558955373023b08f638c9ede36741b0e4200f58
>> Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> Date:   Tue Mar 31 14:05:18 2020 +0800
>>
>>      io_uring: refactor file register/unregister/update handling
>>
>> If I revert this one, the test completes fine.
>>
>> The case case is pretty simple, just run t/io_uring from the fio
>> repo, default settings:
>>
>> [ fio] # t/io_uring /dev/nvme0n1p2
>> Added file /dev/nvme0n1p2
>> sq_ring ptr = 0x0x7fe1cb81f000
>> sqes ptr    = 0x0x7fe1cb81d000
>> cq_ring ptr = 0x0x7fe1cb81b000
>> polled=1, fixedbufs=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
>> submitter=345
>> IOPS=240096, IOS/call=32/31, inflight=91 (91)
>> IOPS=249696, IOS/call=32/31, inflight=99 (99)
>> ^CExiting on signal 2
>>
>> and ctrl-c it after a second or so. You'll then notice a kworker that
>> is stuck in io_sqe_files_unregister(), here:
>>
>> 	/* wait for all refs nodes to complete */
>> 	wait_for_completion(&data->done);
>>
>> I'll try and debug this a bit, and for some reason it doens't trigger
>> with the liburing fixed file setup. Just wanted to throw this out there,
>> so if you have cycles, please do take a look at it.
> 
> https://lore.kernel.org/io-uring/015659db-626c-5a78-6746-081a45175f45@kernel.dk/T/#u
Thanks for this fix, and sorry, it's my bad, I didn't cover this case when sending patches.
Can you share your test cases or test method when developing io_uring? Usually I just
run test cases under liburing/test, seems it's not enough.

Regards,
Xiaoguang Wang
> 
> 
