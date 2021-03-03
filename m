Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3690E32B554
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350272AbhCCGo3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:44:29 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:52290 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244144AbhCCDD1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Mar 2021 22:03:27 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UQAbNuR_1614740007;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQAbNuR_1614740007)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Mar 2021 10:53:27 +0800
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
To:     Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
References: <20210302190555.201228400@debian-a64.vm>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
Date:   Wed, 3 Mar 2021 10:53:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210302190555.201228400@debian-a64.vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 3/3/21 3:05 AM, Mikulas Patocka wrote:

> Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
> cookie.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
> +++ linux-2.6/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
> @@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
>  		}
>  	}
>  
> +	if (ci.poll_cookie != BLK_QC_T_NONE) {
> +		while (atomic_read(&ci.io->io_count) > 1 &&
> +		       blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
> +	}
> +
>  	/* drop the extra reference count */
>  	dec_pending(ci.io, errno_to_blk_status(error));
>  }

It seems that the general idea of your design is to
1) submit *one* split bio
2) blk_poll(), waiting the previously submitted split bio complets

and then submit next split bio, repeating the above process. I'm afraid
the performance may be an issue here, since the batch every time
blk_poll() reaps may decrease.


Besides, the submitting routine and polling routine is bound together
here, i.e., polling is always synchronous.

-- 
Thanks,
Jeffle
