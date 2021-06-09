Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9A23A14AF
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 14:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhFIMoP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 08:44:15 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:57771 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234450AbhFIMoK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 08:44:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UbsYWuF_1623242533;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UbsYWuF_1623242533)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Jun 2021 20:42:14 +0800
Subject: Re: [PATCH] io_uring: fix blocking inline submission
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <d8033ef5-f22e-10a7-d836-0e66455327cf@linux.alibaba.com>
Date:   Wed, 9 Jun 2021 20:42:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/6/9 下午7:07, Pavel Begunkov 写道:
> There is a complaint against sys_io_uring_enter() blocking if it submits
> stdin reads. The problem is in __io_file_supports_async(), which
> sees that it's a cdev and allows it to be processed inline.
> 
> Punt char devices using generic rules of io_file_supports_async(),
> including checking for presence of *_iter() versions of rw callbacks.
> Apparently, it will affect most of cdevs with some exceptions like
> null and zero devices.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> "...For now, just ensure that anything potentially problematic is done
> inline". I believe this part is outdated, but what use cases we miss?
> Anything that we care about?
> 
> IMHO the best option is to do like in this patch and add
> (read,write)_iter(), to places we care about.
> 
> /dev/[u]random, consoles, any else?
> 
This reminds me another thing, once I did nowait read on a brd(block
ramdisk), I saw a 10%~30% regression after __io_file_supports_async()
added. brd is bio based device (block layer doesn't support nowait IO
for this kind of device), so theoretically it makes sense to punt it to
iowq threads in advance in __io_file_supports_async(), but actually
what originally happen is: IOCB_NOWAIT is not delivered to block
layer(REQ_NOWAIT) and then the IO request is executed inline (It seems
brd device won't block). This finally makes 'check it in advance'
slower..
>   fs/io_uring.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 42380ed563c4..44d1859f0dfb 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2616,7 +2616,7 @@ static bool __io_file_supports_async(struct file *file, int rw)
>   			return true;
>   		return false;
>   	}
> -	if (S_ISCHR(mode) || S_ISSOCK(mode))
> +	if (S_ISSOCK(mode))
>   		return true;
>   	if (S_ISREG(mode)) {
>   		if (IS_ENABLED(CONFIG_BLOCK) &&
> 

