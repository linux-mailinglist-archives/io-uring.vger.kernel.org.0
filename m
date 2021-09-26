Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378C341880A
	for <lists+io-uring@lfdr.de>; Sun, 26 Sep 2021 12:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhIZKBv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Sep 2021 06:01:51 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:54086 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231336AbhIZKBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Sep 2021 06:01:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpbrNVT_1632650404;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpbrNVT_1632650404)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 26 Sep 2021 18:00:05 +0800
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
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <0d781b5f-3d2d-5ad4-9ad3-8fabc994313a@linux.alibaba.com>
Date:   Sun, 26 Sep 2021 18:00:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <96ef70e8-7abf-d820-3cca-0f8aedc969d8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/30 上午6:15, Pavel Begunkov 写道:
> On 4/29/21 4:28 AM, Hao Xu wrote:
>> 在 2021/4/28 下午10:07, Pavel Begunkov 写道:
>>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>>> currently unit of io_sq_thread_idle is millisecond, the smallest value
>>>> is 1ms, which means for IOPS > 1000, sqthread will very likely  take
>>>> 100% cpu usage. This is not necessary in some cases, like users may
>>>> don't care about latency much in low IO pressure
>>>> (like 1000 < IOPS < 20000), but cpu resource does matter. So we offer
>>>> an option of nanosecond granularity of io_sq_thread_idle. Some test
>>>> results by fio below:
>>>
>>> If numbers justify it, I don't see why not do it in ns, but I'd suggest
>>> to get rid of all the mess and simply convert to jiffies during ring
>>> creation (i.e. nsecs_to_jiffies64()), and leave io_sq_thread() unchanged.
>> 1) here I keep millisecond mode for compatibility
>> 2) I saw jiffies is calculated by HZ, and HZ could be large enough
>> (like HZ = 1000) to make nsecs_to_jiffies64() = 0:
>>
>>   u64 nsecs_to_jiffies64(u64 n)
>>   {
>>   #if (NSEC_PER_SEC % HZ) == 0
>>           /* Common case, HZ = 100, 128, 200, 250, 256, 500, 512, 1000 etc. */
>>           return div_u64(n, NSEC_PER_SEC / HZ);
>>   #elif (HZ % 512) == 0
>>           /* overflow after 292 years if HZ = 1024 */
>>           return div_u64(n * HZ / 512, NSEC_PER_SEC / 512);
>>   #else
>>           /*
>>           ¦* Generic case - optimized for cases where HZ is a multiple of 3.
>>           ¦* overflow after 64.99 years, exact for HZ = 60, 72, 90, 120 etc.
>>           ¦*/
>>           return div_u64(n * 9, (9ull * NSEC_PER_SEC + HZ / 2) / HZ);
>>   #endif
>>   }
>>
>> say HZ = 1000, then nsec_to_jiffies64(1us) = 1e3 / (1e9 / 1e3) = 0
>> iow, nsec_to_jiffies64() doesn't work for n < (1e9 / HZ).
> 
> Agree, apparently jiffies precision fractions of a second, e.g. 0.001s
> But I'd much prefer to not duplicate all that. So, jiffies won't do,
> ktime() may be ok but a bit heavier that we'd like it to be...
> 
> Jens, any chance you remember something in the middle? Like same source
> as ktime() but without the heavy correction it does.
I'm gonna pick this one up again, currently this patch
with ktime_get_ns() works good on our productions. This
patch makes the latency a bit higher than before, but
still lower than aio.
I haven't gotten a faster alternate for ktime_get_ns(),
any hints?

Regards,
Hao
> 

