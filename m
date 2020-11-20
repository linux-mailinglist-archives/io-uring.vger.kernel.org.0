Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E66B2BA5FD
	for <lists+io-uring@lfdr.de>; Fri, 20 Nov 2020 10:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgKTJXA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Nov 2020 04:23:00 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:46319 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726618AbgKTJXA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Nov 2020 04:23:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UFz0ukx_1605864175;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UFz0ukx_1605864175)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 20 Nov 2020 17:22:56 +0800
Subject: Re: [PATCH v4 1/2] block: disable iopoll for split bio
To:     Christoph Hellwig <hch@infradead.org>
Cc:     axboe@kernel.dk, ming.lei@redhat.com, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com
References: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
 <20201117075625.46118-2-jefflexu@linux.alibaba.com>
 <20201119175234.GA20944@infradead.org>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <c080d087-84c1-a019-1398-5358025e090f@linux.alibaba.com>
Date:   Fri, 20 Nov 2020 17:22:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201119175234.GA20944@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 11/20/20 1:52 AM, Christoph Hellwig wrote:
> On Tue, Nov 17, 2020 at 03:56:24PM +0800, Jeffle Xu wrote:
>> iopoll is initially for small size, latency sensitive IO. It doesn't
>> work well for big IO, especially when it needs to be split to multiple
>> bios. In this case, the returned cookie of __submit_bio_noacct_mq() is
>> indeed the cookie of the last split bio. The completion of *this* last
>> split bio done by iopoll doesn't mean the whole original bio has
>> completed. Callers of iopoll still need to wait for completion of other
>> split bios.
>>
>> Besides bio splitting may cause more trouble for iopoll which isn't
>> supposed to be used in case of big IO.
>>
>> iopoll for split bio may cause potential race if CPU migration happens
>> during bio submission. Since the returned cookie is that of the last
>> split bio, polling on the corresponding hardware queue doesn't help
>> complete other split bios, if these split bios are enqueued into
>> different hardware queues. Since interrupts are disabled for polling
>> queues, the completion of these other split bios depends on timeout
>> mechanism, thus causing a potential hang.
>>
>> iopoll for split bio may also cause hang for sync polling. Currently
>> both the blkdev and iomap-based fs (ext4/xfs, etc) support sync polling
>> in direct IO routine. These routines will submit bio without REQ_NOWAIT
>> flag set, and then start sync polling in current process context. The
>> process may hang in blk_mq_get_tag() if the submitted bio has to be
>> split into multiple bios and can rapidly exhaust the queue depth. The
>> process are waiting for the completion of the previously allocated
>> requests, which should be reaped by the following polling, and thus
>> causing a deadlock.
>>
>> To avoid these subtle trouble described above, just disable iopoll for
>> split bio.
>>
>> Suggested-by: Ming Lei <ming.lei@redhat.com>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>   block/blk-merge.c | 7 +++++++
>>   block/blk-mq.c    | 6 ++++--
>>   2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-merge.c b/block/blk-merge.c
>> index bcf5e4580603..53ad781917a2 100644
>> --- a/block/blk-merge.c
>> +++ b/block/blk-merge.c
>> @@ -279,6 +279,13 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>>   	return NULL;
>>   split:
>>   	*segs = nsegs;
>> +
>> +	/*
>> +	 * bio splitting may cause subtle trouble such as hang when doing iopoll,
> Please capitalize the first character of a multi-line comments.  Also
> this adds an overly long line.

Regards.


>
>> +	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
>> +	if (hctx->type != HCTX_TYPE_POLL)
>> +		return 0;
> I think this is good as a sanity check, but shouldn't we be able to
> avoid even hitting this patch if we ensure that BLK_QC_T_NONE is
> returned after a bio is split?

Actually I had thought about returning  BLK_QC_T_NONE for split bio, but 
got blocked.


At the beginning, I want to identify split bio by checking if @split is 
NULL in __blk_queue_split().

```

                 split = blk_bio_segment_split(q, *bio, &q->bio_split, 
nr_segs);
                 break;
         }

         if (split) {

             /* bio got split */

```

But it's not the case. Even if @split is NULL, the input @bio may be the 
*last* split bio.


Then I want to identify split bio by checking loop times in 
__submit_bio_noacct_mq().

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1008,12 +1008,15 @@ static blk_qc_t __submit_bio_noacct_mq(struct 
bio *bio)
  {
         struct bio_list bio_list[2] = { };
         blk_qc_t ret = BLK_QC_T_NONE;
+       int split = -1;

         current->bio_list = bio_list;

         do {
                 struct gendisk *disk = bio->bi_disk;

+               split = min(split + 1, 1)
+
                 if (unlikely(bio_queue_enter(bio) != 0))
                         continue;

@@ -1027,7 +1030,7 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio 
*bio)
         } while ((bio = bio_list_pop(&bio_list[0])));

         current->bio_list = NULL;
-       return ret;
+       return split ? BLK_QC_T_NONE : ret;
  }

But the bio-based routine will call blk_mq_submit_bio() directly, bypassing

__submit_bio_noacct_mq().


It seems that we have to add one specific flag to identify split bio.


Or we could use BIO_CHAIN to identify the *last* split bio from normal 
bio, since the

last split bio is always marked with BIO_CHAIN. Then we can identify the 
last split

bio by BIO_CHAIN, and the others by checking if @split is NULL in 
__blk_queue_split().


-- 
Thanks,
Jeffle

