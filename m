Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF6F2EEBC0
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 04:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbhAHDNK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 22:13:10 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:53756 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727003AbhAHDNK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 22:13:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UL14Hmt_1610075546;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UL14Hmt_1610075546)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 08 Jan 2021 11:12:26 +0800
Subject: Re: [dm-devel] [PATCH RFC 7/7] dm: add support for IO polling
From:   JeffleXu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
 <20201223112624.78955-8-jefflexu@linux.alibaba.com>
Message-ID: <c052e81f-1ade-dbd2-f5cb-259aca9d5b0f@linux.alibaba.com>
Date:   Fri, 8 Jan 2021 11:12:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201223112624.78955-8-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/23/20 7:26 PM, Jeffle Xu wrote:
> Enable iopoll when all underlying target devices supports iopoll.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  drivers/md/dm-table.c | 28 ++++++++++++++++++++++++++++
>  drivers/md/dm.c       |  1 +
>  2 files changed, 29 insertions(+)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 188f41287f18..b0cd5bf58c3c 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1791,6 +1791,31 @@ static bool dm_table_requires_stable_pages(struct dm_table *t)
>  	return false;
>  }
>  
> +static int device_supports_poll(struct dm_target *ti, struct dm_dev *dev,
> +				sector_t start, sector_t len, void *data)
> +{
> +	struct request_queue *q = bdev_get_queue(dev->bdev);
> +
> +	return q && test_bit(QUEUE_FLAG_POLL, &q->queue_flags);
> +}
> +
> +static bool dm_table_supports_poll(struct dm_table *t)
> +{
> +	struct dm_target *ti;
> +	unsigned int i;
> +
> +	/* Ensure that all targets support iopoll. */
> +	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> +		ti = dm_table_get_target(t, i);
> +
> +		if (!ti->type->iterate_devices ||
> +		    !ti->type->iterate_devices(ti, device_supports_poll, NULL))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  			       struct queue_limits *limits)
>  {
> @@ -1883,6 +1908,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  #endif
>  
>  	blk_queue_update_readahead(q);
> +
> +	if (dm_table_supports_poll(t))
> +		blk_queue_flag_set(QUEUE_FLAG_POLL, q);
>  }
>  

This works in arbitrary bio-based DM stacking. Suppose the following
device stack:

    dm0
    dm1
nvme0  nvme1


dm 0 will check if dm1 has QUEUE_FLAG_POLL flag set.


>  unsigned int dm_table_get_num_targets(struct dm_table *t)
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 03c2b867acaa..ffd2c5ead256 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -3049,6 +3049,7 @@ static const struct pr_ops dm_pr_ops = {
>  };
>  
>  static const struct block_device_operations dm_blk_dops = {
> +	.iopoll = blk_bio_poll,
>  	.submit_bio = dm_submit_bio,
>  	.open = dm_blk_open,
>  	.release = dm_blk_close,
> 

-- 
Thanks,
Jeffle
