Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9312811DF97
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 09:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbfLMIlj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 03:41:39 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42110 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfLMIlj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 03:41:39 -0500
Received: by mail-lf1-f67.google.com with SMTP id y19so1327132lfl.9;
        Fri, 13 Dec 2019 00:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rLQ5m+u1dvrjSizT1sS4iO+rnO5Zjh0/I2TBX2IdsrQ=;
        b=lDI74twSnmzAP+UZ3bIAiF1+NnttuW0yfFKA2pCdFYGcb8nOdOD5Vd+1JeMr/xk5lt
         MLayFIEEIaFktMbOiqEry4oYOO7QfBohbaDmto24P1Lg+sQHGf/jx4RS2PYdFeA8ZPRT
         LbuRXKXmvnnThVDivXkbbGoKQOwRJWyWeRh6YgdKx5NqZGX0V5GLBOFEgRvPQWhdGZ67
         wBjphQDcaVIzS8YuPPvW9vO7Ne6stVJ7eZy+N4VeU3C2343su9FQOS5eqCsIUqF0lA86
         Ml/AemxALKi+ka01i5yoPCpFbgrkVZ069SgRuOgJ/do8G+sBAWpx7yrhOa7Q+vqhkpHk
         0ooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rLQ5m+u1dvrjSizT1sS4iO+rnO5Zjh0/I2TBX2IdsrQ=;
        b=BD/6RzGwC/1dKTKZ6cXQiD9lxdTQnMs2hLfSivcB4BI4YL1mqWbfsFZQPw1kVcOgWv
         QWx4ayt6F8nr1OhBjD+9aaQi+wvLEvjPlo9zTZ1nbGl/3BAdh7JBAMLLQYwUlPKgEMiO
         AKUHCuZhvr5WpOx9np9+ooBjx86mvFcYQ/JgIHFA5yreNj451NgmYuQUp+C6lIHrU9mi
         yA9Sp+gU0g1d/p5rJql4t+c9UfK4oY5W5FRuSEykFmUsFCl3+geg3nFecAu6PrkBd5Hq
         Y+bqbTxvKsPtyVgoVQGcA9ppZOf2Xwec0NR1BNx/3sO2hrUxu6YT/POGy3sqU7eaUrhb
         wS2w==
X-Gm-Message-State: APjAAAXIasKEyDFy24LhMwiSIXwrjlFv4u1nQqtRydBjizwwOoPg2BNp
        7oHQiYncuk4W1dMCSJuUBxOeUDLOIKI=
X-Google-Smtp-Source: APXvYqyySNePGf8Iw3wiWo/O7Kxs5ALek69lfyC5bZcw4C/Hicer9vtPstNSq6i9zEGJM7PBaabGXQ==
X-Received: by 2002:a19:5212:: with SMTP id m18mr8153947lfb.7.1576226496826;
        Fri, 13 Dec 2019 00:41:36 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id h19sm4356381ljl.57.2019.12.13.00.41.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Dec 2019 00:41:36 -0800 (PST)
Subject: Re: [PATCH liburing] Test wait after under-consuming
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e5579bbac4fcb4f0e9b6ba4fbf3a56bd9a925c6c.1576224356.git.asml.silence@gmail.com>
Message-ID: <688ff2e6-0bb3-908f-5b5f-af894ed9f0c5@gmail.com>
Date:   Fri, 13 Dec 2019 11:41:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <e5579bbac4fcb4f0e9b6ba4fbf3a56bd9a925c6c.1576224356.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/13/2019 11:06 AM, Pavel Begunkov wrote:
> In case of an error submission won't consume all sqes. This tests that
> it will get back to the userspace even if (to_submit == to_wait)
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  test/link.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/test/link.c b/test/link.c
> index 8ec1649..93653f3 100644
> --- a/test/link.c
> +++ b/test/link.c
> @@ -384,6 +384,55 @@ err:
>  	return 1;
>  }
>  
> +static int test_early_fail_and_wait(struct io_uring *ring)
> +{
> +	struct io_uring_cqe *cqe;
> +	struct io_uring_sqe *sqe;
> +	int ret, submitted, i;
> +	const int invalid_fd = 42;
> +	struct iovec iov = { .iov_base = NULL, .iov_len = 0 };
> +
> +	sqe = io_uring_get_sqe(ring);
> +	if (!sqe) {
> +		printf("get sqe failed\n");
> +		goto err;
> +	}
> +
> +	io_uring_prep_readv(sqe, invalid_fd, &iov, 1, 0);
> +	sqe->user_data = 1;
> +	sqe->flags |= IOSQE_IO_LINK;
> +
> +	sqe = io_uring_get_sqe(ring);
> +	if (!sqe) {
> +		printf("get sqe failed\n");
> +		goto err;
> +	}
> +
> +	io_uring_prep_nop(sqe);
> +	sqe->user_data = 2;
> +
> +	submitted = io_uring_submit_and_wait(ring, 2);
> +	if (submitted == -EAGAIN)
> +		return 0;

As io_uring isn't recreated for each test case, I need to complete all
cqes in any case. I'll resend

> +	if (submitted <= 0) {
> +		printf("sqe submit failed: %d\n", submitted);
> +		goto err;
> +	}
> +
> +	for (i = 0; i < 2; i++) {
> +		ret = io_uring_wait_cqe(ring, &cqe);
> +		if (ret < 0) {
> +			printf("wait completion %d\n", ret);
> +			goto err;
> +		}
> +		io_uring_cqe_seen(ring, cqe);
> +	}
> +
> +	return 0;
> +err:
> +	return 1;
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	struct io_uring ring, poll_ring;
> @@ -400,7 +449,6 @@ int main(int argc, char *argv[])
>  	if (ret) {
>  		printf("poll_ring setup failed\n");
>  		return 1;
> -
>  	}
>  
>  	ret = test_single_link(&ring);
> @@ -439,5 +487,11 @@ int main(int argc, char *argv[])
>  		return ret;
>  	}
>  
> +	ret = test_early_fail_and_wait(&ring);
> +	if (ret) {
> +		fprintf(stderr, "test_early_fail_and_wait\n");
> +		return ret;
> +	}
> +
>  	return 0;
>  }
> 

-- 
Pavel Begunkov
