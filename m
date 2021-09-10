Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA45406AFF
	for <lists+io-uring@lfdr.de>; Fri, 10 Sep 2021 13:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhIJLv7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Sep 2021 07:51:59 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:55108 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232613AbhIJLv7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Sep 2021 07:51:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UntYggS_1631274645;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UntYggS_1631274645)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Sep 2021 19:50:46 +0800
Subject: Re: [PATCH v2] io_uring: fix bug of wrong BUILD_BUG_ON check of
 __REQ_F_LAST_BIT
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210907032243.114190-1-haoxu@linux.alibaba.com>
Message-ID: <39514727-827c-6920-2ffc-c0aa06bb2c9d@linux.alibaba.com>
Date:   Fri, 10 Sep 2021 19:50:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210907032243.114190-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ping
在 2021/9/7 上午11:22, Hao Xu 写道:
> Build check of __REQ_F_LAST_BIT should be large than not equal or large
> than.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2bde732a1183..d159d9204e07 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -10643,7 +10643,7 @@ static int __init io_uring_init(void)
>   	BUILD_BUG_ON(SQE_VALID_FLAGS >= (1 << 8));
>   
>   	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
> -	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
> +	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
>   
>   	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
>   				SLAB_ACCOUNT);
> 

