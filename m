Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BD133835C
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 03:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCLB4m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 20:56:42 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:39170 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229470AbhCLB4U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 20:56:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0URXfkii_1615514176;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0URXfkii_1615514176)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Mar 2021 09:56:17 +0800
Subject: Re: [dm-devel] [PATCH v5 10/12] block: fastpath for bio-based polling
To:     Ming Lei <ming.lei@redhat.com>
Cc:     axboe@kernel.dk, msnitzer@redhat.com, caspar@linux.alibaba.com,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, mpatocka@redhat.com, io-uring@vger.kernel.org
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
 <20210303115740.127001-11-jefflexu@linux.alibaba.com> <YEohgwIIy5ryme8x@T590>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <40f6c434-8414-3967-0000-4b3bffc11d75@linux.alibaba.com>
Date:   Fri, 12 Mar 2021 09:56:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEohgwIIy5ryme8x@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 3/11/21 9:56 PM, Ming Lei wrote:
> On Wed, Mar 03, 2021 at 07:57:38PM +0800, Jeffle Xu wrote:
>> Offer one fastpath for bio-based polling when bio submitted to dm
>> device is not split.
>>
>> In this case, there will be only one bio submitted to only one polling
>> hw queue of one underlying mq device, and thus we don't need to track
>> all split bios or iterate through all polling hw queues. The pointer to
>> the polling hw queue the bio submitted to is returned here as the
>> returned cookie. In this case, the polling routine will call
>> mq_ops->poll() directly with the hw queue converted from the input
>> cookie.
>>
>> If the original bio submitted to dm device is split to multiple bios and
>> thus submitted to multiple polling hw queues, the polling routine will
>> fall back to iterating all hw queues (in polling mode) of all underlying
>> mq devices.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  block/blk-core.c          | 73 +++++++++++++++++++++++++++++++++++++--
>>  include/linux/blk_types.h | 66 +++++++++++++++++++++++++++++++++--
>>  include/linux/types.h     |  2 +-
>>  3 files changed, 135 insertions(+), 6 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 6d7d53030d7c..e5cd4ff08f5c 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -947,14 +947,22 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  {
>>  	struct bio_list bio_list_on_stack[2];
>>  	blk_qc_t ret = BLK_QC_T_NONE;
>> +	struct request_queue *top_q;
>> +	bool poll_on;
>>  
>>  	BUG_ON(bio->bi_next);
>>  
>>  	bio_list_init(&bio_list_on_stack[0]);
>>  	current->bio_list = bio_list_on_stack;
>>  
>> +	top_q = bio->bi_bdev->bd_disk->queue;
>> +	poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags) &&
>> +		  (bio->bi_opf & REQ_HIPRI);
>> +
>>  	do {
>> -		struct request_queue *q = bio->bi_bdev->bd_disk->queue;
>> +		blk_qc_t cookie;
>> +		struct block_device *bdev = bio->bi_bdev;
>> +		struct request_queue *q = bdev->bd_disk->queue;
>>  		struct bio_list lower, same;
>>  
>>  		if (unlikely(bio_queue_enter(bio) != 0))
>> @@ -966,7 +974,23 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  		bio_list_on_stack[1] = bio_list_on_stack[0];
>>  		bio_list_init(&bio_list_on_stack[0]);
>>  
>> -		ret = __submit_bio(bio);
>> +		cookie = __submit_bio(bio);
>> +
>> +		if (poll_on && blk_qc_t_valid(cookie)) {
> 
> In patch 8, dm_submit_bio() is changed to return BLK_QC_T_NONE always,
> so the returned cookie may be BLK_QC_T_NONE for DM device, such as, in
> case of DM_MAPIO_SUBMITTED returned from ->map(), and underlying bios
> can be submitted from another context, then nothing is fed to blk_poll().

Thanks for poniting out this. Indeed this issue exists. If the IO
submission is offloaded to another process context, the current simple
cookie mechanism doesn't support that.


-- 
Thanks,
Jeffle
