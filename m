Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDF1309CEA
	for <lists+io-uring@lfdr.de>; Sun, 31 Jan 2021 15:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhAaO3O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Jan 2021 09:29:14 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:6206 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231871AbhAaOCr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Jan 2021 09:02:47 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UNPb9Rs_1612101028;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UNPb9Rs_1612101028)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 31 Jan 2021 21:50:29 +0800
Subject: Re: [PATCH v2] io_uring: check kthread parked flag before sqthread
 goes to sleep
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1611942122-83391-1-git-send-email-haoxu@linux.alibaba.com>
 <1611942813-89187-1-git-send-email-haoxu@linux.alibaba.com>
 <69b64dc4-7201-ba05-748c-901a9a1069f7@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <a665324a-f04f-7d71-23b8-4515e2ff43dc@linux.alibaba.com>
Date:   Sun, 31 Jan 2021 21:50:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <69b64dc4-7201-ba05-748c-901a9a1069f7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/1/31 下午8:51, Pavel Begunkov 写道:
> On 29/01/2021 17:53, Hao Xu wrote:
>>
>> So check if sqthread gets park flag right before schedule().
>> since ctx_list is always empty when this problem happens, here I put
>> kthread_should_park() before setting the wakeup flag(ctx_list is empty
>> so this for loop is fast), where is close enough to schedule(). The
>> problem doesn't show again in my repro testing after this fix.
> 
> Looks good, and I believe I saw syzbot reporting similar thing before.
> Two nits below
> 
>>
>> Reported-by: Abaci <abaci@linux.alibaba.com>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>   fs/io_uring.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index c07913ec0cca..444dc993157e 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -7132,6 +7132,9 @@ static int io_sq_thread(void *data)
>>   			}
>>   		}
> 
> How about killing btw a kthread_should_park() check few lines
> above before prepare_to_wait? Parking is fairly rare, so we
> don't need fast path for it.
> 
Gotcha, It makes sense to kill that one if parking is rare.
>>   
>> +		if (kthread_should_park())
>> +			needs_sched = false;
>> +
>>   		if (needs_sched) {
> 
> if (needs_sched && !kthread_should_park())
> 
> Looks cleaner to me
> 
Agree, It's cleaner.
I'll send a v3 soon. Thank you, Pavel.

Hao
>>   			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>>   				io_ring_set_wakeup_flag(ctx);
>>
> 

