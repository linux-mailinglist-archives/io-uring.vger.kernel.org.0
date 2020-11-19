Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2652B8A4C
	for <lists+io-uring@lfdr.de>; Thu, 19 Nov 2020 04:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKSDGQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 22:06:16 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:46061 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbgKSDGQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 22:06:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UFqsT0m_1605755169;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UFqsT0m_1605755169)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 19 Nov 2020 11:06:09 +0800
Subject: Re: [PATCH v4 1/2] block: disable iopoll for split bio
From:   JeffleXu <jefflexu@linux.alibaba.com>
To:     axboe@kernel.dk, hch@infradead.org, ming.lei@redhat.com
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com
References: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
 <20201117075625.46118-2-jefflexu@linux.alibaba.com>
Message-ID: <e0d59ea2-3c30-9edb-4cbb-f63703fdf0f1@linux.alibaba.com>
Date:   Thu, 19 Nov 2020 11:06:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201117075625.46118-2-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

Would you mind giving a glance at this, at least patch 1?


Patch 1 could fix the potential deadlock may be triggered by sync io polling

in direct IO routine.


Actually this patch could alleviate another potential hang in io_uring. The

returned cookie of submit_bio() is actually the cookie of the last split bio

if splitting happened. If the returned cookie is BLK_QC_T_NONE ( the

last split bio get merged into another request, or queue depth exhausted

and REQ_NOWAIT set by io_uring), then iocb->ki_cookie is BLK_QC_T_NONE.


If there's only this one IO (though split to several bios) in the 
polling hw queue,

then io_do_iopoll() will get stuck in indefinite calling of blk_poll(), 
while blk_poll()

will return 0 immediately because of BLK_QC_T_NONE, without reaping any

former completed requests.


This hang rarly happened, maybe because as long as there's other IO, polling

of these other IOs will help reap completed requests of the stuck IO 
described

above.


Of course we could refactor the problematic logic of returning cookie in 
submit_bio(),

But this patch 1 could also fix this issue. Besides this patch 1 is also 
needed to fix

the potential deadlock triggered by sync io polling described above.


Thanks,

Jeffle



On 11/17/20 3:56 PM, Jeffle Xu wrote:
> iopoll is initially for small size, latency sensitive IO. It doesn't
> work well for big IO, especially when it needs to be split to multiple
> bios. In this case, the returned cookie of __submit_bio_noacct_mq() is
> indeed the cookie of the last split bio. The completion of *this* last
> split bio done by iopoll doesn't mean the whole original bio has
> completed. Callers of iopoll still need to wait for completion of other
> split bios.
>
> Besides bio splitting may cause more trouble for iopoll which isn't
> supposed to be used in case of big IO.
>
> iopoll for split bio may cause potential race if CPU migration happens
> during bio submission. Since the returned cookie is that of the last
> split bio, polling on the corresponding hardware queue doesn't help
> complete other split bios, if these split bios are enqueued into
> different hardware queues. Since interrupts are disabled for polling
> queues, the completion of these other split bios depends on timeout
> mechanism, thus causing a potential hang.
>
> iopoll for split bio may also cause hang for sync polling. Currently
> both the blkdev and iomap-based fs (ext4/xfs, etc) support sync polling
> in direct IO routine. These routines will submit bio without REQ_NOWAIT
> flag set, and then start sync polling in current process context. The
> process may hang in blk_mq_get_tag() if the submitted bio has to be
> split into multiple bios and can rapidly exhaust the queue depth. The
> process are waiting for the completion of the previously allocated
> requests, which should be reaped by the following polling, and thus
> causing a deadlock.
>
> To avoid these subtle trouble described above, just disable iopoll for
> split bio.
>
> Suggested-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>   block/blk-merge.c | 7 +++++++
>   block/blk-mq.c    | 6 ++++--
>   2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index bcf5e4580603..53ad781917a2 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -279,6 +279,13 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>   	return NULL;
>   split:
>   	*segs = nsegs;
> +
> +	/*
> +	 * bio splitting may cause subtle trouble such as hang when doing iopoll,
> +	 * not to mention iopoll isn't supposed to be used in case of big IO.
> +	 */
> +	bio->bi_opf &= ~REQ_HIPRI;
> +
>   	return bio_split(bio, sectors, GFP_NOIO, bs);
>   }
>   
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 55bcee5dc032..6d10652a7ed0 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3853,11 +3853,13 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>   	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
>   		return 0;
>   
> +	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> +	if (hctx->type != HCTX_TYPE_POLL)
> +		return 0;
> +
>   	if (current->plug)
>   		blk_flush_plug_list(current->plug, false);
>   
> -	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> -
>   	/*
>   	 * If we sleep, have the caller restart the poll loop to reset
>   	 * the state. Like for the other success return cases, the

-- 
Thanks,
Jeffle

