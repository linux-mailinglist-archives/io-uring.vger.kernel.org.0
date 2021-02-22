Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E36C321191
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 08:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhBVHrJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 02:47:09 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:47044 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230136AbhBVHrG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 02:47:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UPAzjxs_1613979980;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UPAzjxs_1613979980)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Feb 2021 15:46:21 +0800
Subject: Re: [PATCH] block: fix potential IO hang when turning off io_poll
To:     Joseph Qi <joseph.qi@linux.alibaba.com>, axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20210222065452.21897-1-jefflexu@linux.alibaba.com>
 <c44800f0-8f88-55e5-adae-ce920a15069a@linux.alibaba.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <e73200c5-6ca7-afa2-1a2f-efd50195bf1d@linux.alibaba.com>
Date:   Mon, 22 Feb 2021 15:46:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c44800f0-8f88-55e5-adae-ce920a15069a@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/22/21 3:12 PM, Joseph Qi wrote:
> 
> 
> On 2/22/21 2:54 PM, Jeffle Xu wrote:
>> QUEUE_FLAG_POLL flag will be cleared when turning off 'io_poll', while
>> at that moment there may be IOs stuck in hw queue uncompleted. The
>> following polling routine won't help reap these IOs, since blk_poll()
>> will return immediately because of cleared QUEUE_FLAG_POLL flag. Thus
>> these IOs will hang until they finnaly time out. The hang out can be
>> observed by 'fio --engine=io_uring iodepth=1', while turning off
>> 'io_poll' at the same time.
>>
>> To fix this, freeze and flush the request queue first when turning off
>> 'io_poll'.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  block/blk-sysfs.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>> index b513f1683af0..10d74741c002 100644
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -430,8 +430,11 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
>>  
>>  	if (poll_on)
>>  		blk_queue_flag_set(QUEUE_FLAG_POLL, q);
>> -	else
>> +	else {
>> +		blk_mq_freeze_queue(q);
>>  		blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
>> +		blk_mq_unfreeze_queue(q);
>> +	}
>>  
>>  	return ret;
>>  }
>>
> 
> Better to place brace to 'if' as well.

Got it, thanks.


-- 
Thanks,
Jeffle
