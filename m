Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D36E352796
	for <lists+io-uring@lfdr.de>; Fri,  2 Apr 2021 10:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhDBIwZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 04:52:25 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:45351 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229599AbhDBIwU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 04:52:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0UUEBL8T_1617353535;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUEBL8T_1617353535)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 02 Apr 2021 16:52:15 +0800
Subject: Re: [PATCH] io_uring: don't mark S_ISBLK async work as unbounded
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <a96971ea-2787-149a-a4bd-422fa696a586@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <48023516-ac7d-8393-f603-f9bf4faa722f@linux.alibaba.com>
Date:   Fri, 2 Apr 2021 16:52:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <a96971ea-2787-149a-a4bd-422fa696a586@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/4/1 下午10:57, Jens Axboe 写道:
> S_ISBLK is marked as unbounded work for async preparation, because it
> doesn't match S_ISREG. That is incorrect, as any read/write to a block
> device is also a bounded operation. Fix it up and ensure that S_ISBLK
> isn't marked unbounded.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
Hi Jens, I saw a (un)bounded work is for a (un)bounded worker to
execute. What is the difference between bounded and unbounded?

Thanks,
Hao
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6d7a1b69712b..a16b7df934d1 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1213,7 +1213,7 @@ static void io_prep_async_work(struct io_kiocb *req)
>   	if (req->flags & REQ_F_ISREG) {
>   		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
>   			io_wq_hash_work(&req->work, file_inode(req->file));
> -	} else {
> +	} else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
>   		if (def->unbound_nonreg_file)
>   			req->work.flags |= IO_WQ_WORK_UNBOUND;
>   	}
> 

