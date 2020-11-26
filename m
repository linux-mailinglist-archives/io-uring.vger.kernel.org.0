Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC74D2C5449
	for <lists+io-uring@lfdr.de>; Thu, 26 Nov 2020 13:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389603AbgKZM4H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Nov 2020 07:56:07 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:53094 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388892AbgKZM4G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Nov 2020 07:56:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UGblxIV_1606395342;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UGblxIV_1606395342)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 26 Nov 2020 20:55:43 +0800
Subject: Re: [PATCH] test/timeout-new: test for timeout feature
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1606115273-164396-1-git-send-email-haoxu@linux.alibaba.com>
Message-ID: <df8e16f4-6864-9259-aec8-34775f81c656@linux.alibaba.com>
Date:   Thu, 26 Nov 2020 20:55:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1606115273-164396-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

�� 2020/11/23 ����3:07, Hao Xu д��:
a gentle ping
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Hi Jens,
> This is a simple test for the new getevent timeout feature. Sorry for
> the delay.
> 
>   test/Makefile      |  6 ++++--
>   test/timeout-new.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 53 insertions(+), 2 deletions(-)
>   create mode 100644 test/timeout-new.c
> 
> diff --git a/test/Makefile b/test/Makefile
> index cbbd400391dd..53dd4afa42e5 100644
> --- a/test/Makefile
> +++ b/test/Makefile
> @@ -25,7 +25,8 @@ all_targets += poll poll-cancel ring-leak fsync io_uring_setup io_uring_register
>   		short-read openat2 probe shared-wq personality eventfd \
>   		send_recv eventfd-ring across-fork sq-poll-kthread splice \
>   		lfs-openat lfs-openat-write iopoll d4ae271dfaae-test \
> -		eventfd-disable close-opath ce593a6c480a-test cq-overflow-peek
> +		eventfd-disable close-opath ce593a6c480a-test cq-overflow-peek \
> +		timeout-new
>   
>   include ../Makefile.quiet
>   
> @@ -65,7 +66,8 @@ test_srcs := poll.c poll-cancel.c ring-leak.c fsync.c io_uring_setup.c \
>   	madvise.c short-read.c openat2.c probe.c shared-wq.c \
>   	personality.c eventfd.c eventfd-ring.c across-fork.c sq-poll-kthread.c \
>   	splice.c lfs-openat.c lfs-openat-write.c iopoll.c d4ae271dfaae-test.c \
> -	eventfd-disable.c close-opath.c ce593a6c480a-test.c cq-overflow-peek.c
> +	eventfd-disable.c close-opat h.c ce593a6c480a-test.c cq-overflow-peek.c \
> +	timeout-new.c
>   
>   ifdef CONFIG_HAVE_STATX
>   test_srcs += statx.c
> diff --git a/test/timeout-new.c b/test/timeout-new.c
> new file mode 100644
> index 000000000000..03e03eb1bba7
> --- /dev/null
> +++ b/test/timeout-new.c
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Description: tests for getevents timeout
> + *
> + */
> +#include <stdio.h>
> +
> +#include "liburing.h"
> +
> +static int test_timeout(struct io_uring *ring)
> +{
> +	struct io_uring_cqe *cqe;
> +	int ret;
> +	struct __kernel_timespec timeout;
> +
> +	timeout.tv_sec = 1;
> +	timeout.tv_nsec = 0;
> +
> +	ret = io_uring_wait_cqe_timeout(ring, &cqe, &timeout);
> +	if (ret != -ETIME) {
> +		fprintf(stderr, "timeout error: %d\n", ret);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct io_uring ring;
> +	int ret;
> +
> +	if (argc > 1)
> +		return 0;
> +
> +	ret = io_uring_queue_init(8, &ring, 0);
> +	if (ret) {
> +		fprintf(stderr, "ring setup failed: %d\n", ret);
> +		return 1;
> +	}
> +
> +	ret = test_timeout(&ring);
> +	if (ret) {
> +		fprintf(stderr, "test_timeout failed\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> 

