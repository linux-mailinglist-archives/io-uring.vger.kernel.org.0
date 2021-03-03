Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D38C32B553
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348050AbhCCGoW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:44:22 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:40116 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235594AbhCCCXS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Mar 2021 21:23:18 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UQADoLL_1614738083;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQADoLL_1614738083)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Mar 2021 10:21:24 +0800
Subject: Re: [dm-devel] [PATCH 2/4] block: dont clear REQ_HIPRI for bio-based
 drivers
To:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
References: <20210302190552.715551440@debian-a64.vm>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <3e8b3b2e-f1f4-e946-4858-d2c78e2a8825@linux.alibaba.com>
Date:   Wed, 3 Mar 2021 10:21:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210302190552.715551440@debian-a64.vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 3/3/21 3:05 AM, Mikulas Patocka wrote:
> Don't clear REQ_HIPRI for bio-based drivers. Device mapper will need to
> see this flag in order to support polling.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  block/blk-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/block/blk-core.c
> ===================================================================
> --- linux-2.6.orig/block/blk-core.c	2021-03-02 10:43:28.000000000 +0100
> +++ linux-2.6/block/blk-core.c	2021-03-02 10:53:50.000000000 +0100

I notice that the diff header indicates that the code base is from
linux-2.6. Or it's just the name of your directory, while the code base
is for the latest upstream 5.12?


> @@ -836,7 +836,7 @@ static noinline_for_stack bool submit_bi
>  		}
>  	}
>  
> -	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> +	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && !bdev->bd_disk->fops->submit_bio)
>  		bio->bi_opf &= ~REQ_HIPRI;
>  
>  	switch (bio_op(bio)) {
> 
> --

What if dm device is built upon mq devices that are not capable of
polling, i.e., mq devices without QUEUE_FLAG_POLL set? Then this dm
device shall not support polling.


-- 
Thanks,
Jeffle
