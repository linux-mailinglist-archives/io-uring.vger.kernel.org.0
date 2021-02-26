Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDFA325EDB
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 09:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhBZIXR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 03:23:17 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:2413 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229621AbhBZIXK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 03:23:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UPchXz8_1614327746;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UPchXz8_1614327746)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Feb 2021 16:22:27 +0800
Subject: Re: [dm-devel] [PATCH v3 09/11] dm: support IO polling for bio-based
 dm device
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     axboe@kernel.dk, snitzer@redhat.com, caspar@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        joseph.qi@linux.alibaba.com, dm-devel@redhat.com, hch@lst.de
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
 <20210208085243.82367-10-jefflexu@linux.alibaba.com>
 <alpine.LRH.2.02.2102190907560.10545@file01.intranet.prod.int.rdu2.redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <60703cc8-a1bf-0e7e-683f-594b1ea1639f@linux.alibaba.com>
Date:   Fri, 26 Feb 2021 16:22:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2102190907560.10545@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/19/21 10:17 PM, Mikulas Patocka wrote:
> 
> 
> On Mon, 8 Feb 2021, Jeffle Xu wrote:
> 
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index c2945c90745e..8423f1347bb8 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -1657,6 +1657,68 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
>>  	return BLK_QC_T_NONE;
>>  }
>>  
>> +static int dm_poll_one_md(struct mapped_device *md);
>> +
>> +static int dm_poll_one_dev(struct dm_target *ti, struct dm_dev *dev,
>> +				sector_t start, sector_t len, void *data)
>> +{
>> +	int i, *count = data;
>> +	struct request_queue *q = bdev_get_queue(dev->bdev);
>> +	struct blk_mq_hw_ctx *hctx;
>> +
>> +	if (queue_is_mq(q)) {
>> +		if (!percpu_ref_tryget(&q->q_usage_counter))
>> +			return 0;
>> +
>> +		queue_for_each_poll_hw_ctx(q, hctx, i)
>> +			*count += blk_mq_poll_hctx(q, hctx);
>> +
>> +		percpu_ref_put(&q->q_usage_counter);
>> +	} else
>> +		*count += dm_poll_one_md(dev->bdev->bd_disk->private_data);
> 
> This is fragile, because in the future there may be other bio-based 
> drivers that support polling. You should check that "q" is really a device 
> mapper device before calling dm_poll_one_md on it.
> 

This can be easily fixed by calling disk->fops->poll() recursively, such as

````
if (queue_is_mq(q)) {
    ...
} else {
    //disk = disk of underlying device
    pdata->count += disk->fops->poll(q, pdata->cookie);
}
```


But meanwhile I realize that we are recursively calling
disk->fops->poll() here, and thus may cause stack overflow similar to
submit_bio() when the depth of the device stack is large enough.

Maybe the control structure like bio_list shall be needed here, to
flatten the recursive structure here.

Any thoughts?


-- 
Thanks,
Jeffle
