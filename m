Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04787306AEA
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 03:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhA1CKK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 21:10:10 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:48565 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229732AbhA1CJT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 21:09:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UN5mkEi_1611799642;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UN5mkEi_1611799642)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Jan 2021 10:07:22 +0800
Subject: Re: [PATCH v2 5/6] block: add QUEUE_FLAG_POLL_CAP flag
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
 <20210125121340.70459-6-jefflexu@linux.alibaba.com>
 <20210127171320.GA11535@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <6cf4f805-7e27-7c82-08c2-52d1bdab027f@linux.alibaba.com>
Date:   Thu, 28 Jan 2021 10:07:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127171320.GA11535@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/28/21 1:13 AM, Mike Snitzer wrote:
> On Mon, Jan 25 2021 at  7:13am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>> Introduce QUEUE_FLAG_POLL_CAP flag representing if the request queue
>> capable of polling or not.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> 
> Why are you adding QUEUE_FLAG_POLL_CAP?  Doesn't seem as though DM or
> anything else actually needs it.

Users can switch on/off polling on device via
'/sys/block/<dev>/queue/io_poll' at runtime. The requisite for turning
on polling is that the device is **capable** of polling. For mq devices,
the requisite is that there's polling hw queue for the device, i.e.,

```
q->tag_set->nr_maps > HCTX_TYPE_POLL &&
q->tag_set->map[HCTX_TYPE_POLL].nr_queues
```

But for dm devices, we need to check if all the underlying devices
support polling or not. Without this newly added queue flag, we need to
check again every time users want to turn on polling via 'io_poll', and
thus the dm layer need to export one interface to block layer, checking
if all the underlying target devices support polling or not, maybe just
like the iopoll() method we did in patch 3. Something like,

```
 struct block_device_operations {
+	bool (*support_iopoll)(struct request_queue *q);
```

The newly added queue flag 'QUEUE_FLAG_POLL_CAP' is just used as a cache
representing if the device **capable** of polling, while the original
queue flag 'QUEUE_FLAG_POLL' representing if polling is turned on for
this device **currently**.


But indeed we are short of queue flag resource. Adding a new queue flag
may not be the best resolution.

Any inspiration?


-- 
Thanks,
Jeffle
