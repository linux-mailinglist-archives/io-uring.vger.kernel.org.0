Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B71636E3B0
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 05:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhD2D3C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 23:29:02 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:23681 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229805AbhD2D3C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 23:29:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UX7Mp1E_1619666884;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UX7Mp1E_1619666884)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 29 Apr 2021 11:28:05 +0800
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <51308ac4-03b7-0f66-7f26-8678807195ca@linux.alibaba.com>
Date:   Thu, 29 Apr 2021 11:28:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/28 下午10:07, Pavel Begunkov 写道:
> On 4/28/21 2:32 PM, Hao Xu wrote:
>> currently unit of io_sq_thread_idle is millisecond, the smallest value
>> is 1ms, which means for IOPS > 1000, sqthread will very likely  take
>> 100% cpu usage. This is not necessary in some cases, like users may
>> don't care about latency much in low IO pressure
>> (like 1000 < IOPS < 20000), but cpu resource does matter. So we offer
>> an option of nanosecond granularity of io_sq_thread_idle. Some test
>> results by fio below:
> 
> If numbers justify it, I don't see why not do it in ns, but I'd suggest
> to get rid of all the mess and simply convert to jiffies during ring
> creation (i.e. nsecs_to_jiffies64()), and leave io_sq_thread() unchanged.
1) here I keep millisecond mode for compatibility
2) I saw jiffies is calculated by HZ, and HZ could be large enough
(like HZ = 1000) to make nsecs_to_jiffies64() = 0:

   u64 nsecs_to_jiffies64(u64 n)
   {
   #if (NSEC_PER_SEC % HZ) == 0
           /* Common case, HZ = 100, 128, 200, 250, 256, 500, 512, 1000 
etc. */
           return div_u64(n, NSEC_PER_SEC / HZ);
   #elif (HZ % 512) == 0
           /* overflow after 292 years if HZ = 1024 */
           return div_u64(n * HZ / 512, NSEC_PER_SEC / 512);
   #else
           /*
           ¦* Generic case - optimized for cases where HZ is a multiple 
of 3.
           ¦* overflow after 64.99 years, exact for HZ = 60, 72, 90, 120 
etc.
           ¦*/
           return div_u64(n * 9, (9ull * NSEC_PER_SEC + HZ / 2) / HZ);
   #endif
   }

say HZ = 1000, then nsec_to_jiffies64(1us) = 1e3 / (1e9 / 1e3) = 0
iow, nsec_to_jiffies64() doesn't work for n < (1e9 / HZ).

> 
> Or is there a reason for having it high precision, i.e. ktime()?
> 
>> uring average latency:(us)
>> iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
>> 2k	        10.93	10.68	10.72	10.7	10.79	10.52	10.59	10.54	10.47	10.39	8.4
>> 4k	        10.55	10.48	10.51	10.42	10.35	8.34
>> 6k	        10.82	10.5	10.39	8.4
>> 8k	        10.44	10.45	10.34	8.39
>> 10k	        10.45	10.39	8.33
>>
>> uring cpu usage of sqthread:
>> iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
>> 2k	        4%	14%	24%	34.70%	44.70%	55%	65.10%	75.40%	85.40%	95.70%	100%
>> 4k	        7.70%	28.20%	48.50%	69%	90%	100%
>> 6k	        11.30%	42%	73%	100%
>> 8k	        15.30%	56.30%	97%	100%
>> 10k	        19%	70%	100%
>>
>> aio average latency:(us)
>> iops	latency	99th lat  cpu
>> 2k	13.34	14.272    3%
>> 4k	13.195	14.016	  7%
>> 6k	13.29	14.656	  9.70%
>> 8k	13.2	14.656	  12.70%
>> 10k	13.2	15	  17%
>>
>> fio config is:
>> ./run_fio.sh
>> fio \
>> --ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
>> --direct=1 --rw=randread --time_based=1 --runtime=300 \
>> --group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
>> --randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
>> --io_sq_thread_idle=${2}
>>
>> in 2k IOPS, if latency of 10.93us is acceptable for an application,
>> then they get 100% - 4% = 96% reduction of cpu usage, while the latency
>> is smaller than aio(10.93us vs 13.34us).
>>
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
> [snip]
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index e1ae46683301..311532ff6ce3 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -98,6 +98,7 @@ enum {
>>   #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
>>   #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
>>   #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
>> +#define IORING_SETUP_IDLE_NS	(1U << 7)	/* unit of thread_idle is nano second */
>>   
>>   enum {
>>   	IORING_OP_NOP,
>> @@ -259,7 +260,7 @@ struct io_uring_params {
>>   	__u32 cq_entries;
>>   	__u32 flags;
>>   	__u32 sq_thread_cpu;
>> -	__u32 sq_thread_idle;
>> +	__u64 sq_thread_idle;
> 
> breaks userspace API
> 
>>   	__u32 features;
>>   	__u32 wq_fd;
>>   	__u32 resv[3];
>>
> 

