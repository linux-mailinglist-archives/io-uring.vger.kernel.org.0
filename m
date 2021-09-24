Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614F5417BB3
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 21:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346121AbhIXTRD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 15:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346043AbhIXTRD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 15:17:03 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D31CC061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:15:29 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id s17so21206688edd.8
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DyWw/dav68KhNeGtKwCwcaVswLcOh9wwMffW7YcY6Vc=;
        b=W8ZobZW9lciFYxLRJDgJ+iWG0SKIyBKRkfeR4JtCP7wxCQu8z6mEgWE6FOzFkKtFSb
         2Pop6tQiP+cgxVyLrcqcxHogi3HhbGFn+qDt2FMLXNqYQCqrhZwTUyrPIh8mqANm0/x1
         ZLA81X/mJRIwWzQWWFwOpW/mg8VZ/C0dWFlIR5ly/qcx6su9iSWK9Se8030vOXmtdI2h
         F9qb+zS9G5kytr+M9emAR0BhSWG5Agarmwiv6uL6lwfMOaUeLizaOOx6YjUHROKSyk5R
         4AqPF7gZQIHGDwdYFuq9kv/DhLXeT/g0D1qUIXj4kAkvlvriJnEtf9Hr5B1l2j0qUbYp
         Gx1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DyWw/dav68KhNeGtKwCwcaVswLcOh9wwMffW7YcY6Vc=;
        b=X5g/P1U9ExCwueFhq1VF2qFkt/sC9P6Dg26GpLIYuq0AE9X9xEG5baHzZ3YK1/2INs
         8e04+d01YfpFxLX4iLio5Q+P4LtEFXy/BGr7cC3KcIGtXdCT8LAQuA81wbl764a92MPZ
         2QmTYUidksdmD4sQI8fXgcaaZNyKHGUuN0wcfLfHCqzuXdScPvSrZImevk9TUVgvzzDM
         JLzY6mxoUZBVt32XDn0zoX34nKIVx8Puv2cDOewfVWZbvSaQFw95z0miDMnpdp2xfqk9
         wcq9i19XBAOkjl7M9sE/ntLro/Uukt+MrPymdE7CRRvnwoABEHeRv/TPK6fdQkn5qXQE
         gGlA==
X-Gm-Message-State: AOAM530kdlrfeCZyeCGVWC++9b3eS41OGH4Ifwq9+Ps87/O/UPN9U0lr
        cYEVLSoqe7sepKAYmrJOHnBduppDGYI=
X-Google-Smtp-Source: ABdhPJzge28JRonqBEi8Shzj8XQVrjrEKrfWFkGZaCii0uxxy2HOxaxbA8FXaq5S0qngaFK92JngMQ==
X-Received: by 2002:a17:906:584b:: with SMTP id h11mr13511064ejs.209.1632510927167;
        Fri, 24 Sep 2021 12:15:27 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id ml12sm5403945ejb.29.2021.09.24.12.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 12:15:26 -0700 (PDT)
Subject: Re: [PATCH liburing] tests: test close with fixed file table
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <5e22cfaf9f0f513574a098dba6548cbb4fb5e2d8.1632510387.git.asml.silence@gmail.com>
Message-ID: <f45010fb-44c3-3cba-12a0-ab299a319e15@gmail.com>
Date:   Fri, 24 Sep 2021 20:14:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <5e22cfaf9f0f513574a098dba6548cbb4fb5e2d8.1632510387.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 8:07 PM, Pavel Begunkov wrote:
> Test IO_CLOSE closing files in the fixed file table.

s/IO_CLOSE/OP_CLOSE/

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> P.S. not tested with kernels not supporting the feature
> 
>  test/open-close.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 115 insertions(+)
> 
> diff --git a/test/open-close.c b/test/open-close.c
> index 648737c..d5c116b 100644
> --- a/test/open-close.c
> +++ b/test/open-close.c
> @@ -9,10 +9,119 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <fcntl.h>
> +#include <assert.h>
>  
>  #include "helpers.h"
>  #include "liburing.h"
>  
> +static int submit_wait(struct io_uring *ring)
> +{
> +	struct io_uring_cqe *cqe;
> +	int ret;
> +
> +	ret = io_uring_submit(ring);
> +	if (ret <= 0) {
> +		fprintf(stderr, "sqe submit failed: %d\n", ret);
> +		return 1;
> +	}
> +	ret = io_uring_wait_cqe(ring, &cqe);
> +	if (ret < 0) {
> +		fprintf(stderr, "wait completion %d\n", ret);
> +		return 1;
> +	}
> +
> +	ret = cqe->res;
> +	io_uring_cqe_seen(ring, cqe);
> +	return ret;
> +}
> +
> +static inline int try_close(struct io_uring *ring, int fd, int slot)
> +{
> +	struct io_uring_sqe *sqe;
> +
> +	sqe = io_uring_get_sqe(ring);
> +	io_uring_prep_close(sqe, fd);
> +	__io_uring_set_target_fixed_file(sqe, slot);
> +	return submit_wait(ring);
> +}
> +
> +static int test_close_fixed(void)
> +{
> +	struct io_uring ring;
> +	struct io_uring_sqe *sqe;
> +	int ret, fds[2];
> +	char buf[1];
> +
> +	ret = io_uring_queue_init(8, &ring, 0);
> +	if (ret) {
> +		fprintf(stderr, "ring setup failed\n");
> +		return -1;
> +	}
> +	if (pipe(fds)) {
> +		perror("pipe");
> +		return -1;
> +	}
> +
> +	ret = try_close(&ring, 0, 0);
> +	if (ret == -EINVAL) {
> +		fprintf(stderr, "close for fixed files is not supported\n");
> +		return 0;
> +	} else if (ret != -ENXIO) {
> +		fprintf(stderr, "no table failed %i\n", ret);
> +		return -1;
> +	}
> +
> +	ret = try_close(&ring, 1, 0);
> +	if (ret != -EINVAL) {
> +		fprintf(stderr, "set fd failed %i\n", ret);
> +		return -1;
> +	}
> +
> +	ret = io_uring_register_files(&ring, fds, 2);
> +	if (ret) {
> +		fprintf(stderr, "file_register: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = try_close(&ring, 0, 2);
> +	if (ret != -EINVAL) {
> +		fprintf(stderr, "out of table failed %i\n", ret);
> +		return -1;
> +	}
> +
> +	ret = try_close(&ring, 0, 0);
> +	if (ret != 0) {
> +		fprintf(stderr, "close failed %i\n", ret);
> +		return -1;
> +	}
> +
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_read(sqe, 0, buf, sizeof(buf), 0);
> +	sqe->flags |= IOSQE_FIXED_FILE;
> +	ret = submit_wait(&ring);
> +	if (ret != -EBADF) {
> +		fprintf(stderr, "read failed %i\n", ret);
> +		return -1;
> +	}
> +
> +	ret = try_close(&ring, 0, 1);
> +	if (ret != 0) {
> +		fprintf(stderr, "close 2 failed %i\n", ret);
> +		return -1;
> +	}
> +
> +	ret = try_close(&ring, 0, 0);
> +	if (ret != -EBADF) {
> +		fprintf(stderr, "empty slot failed %i\n", ret);
> +		return -1;
> +	}
> +
> +	close(fds[0]);
> +	close(fds[1]);
> +	io_uring_queue_exit(&ring);
> +	return 0;
> +}
> +
>  static int test_close(struct io_uring *ring, int fd, int is_ring_fd)
>  {
>  	struct io_uring_cqe *cqe;
> @@ -133,6 +242,12 @@ int main(int argc, char *argv[])
>  		goto err;
>  	}
>  
> +	ret = test_close_fixed();
> +	if (ret) {
> +		fprintf(stderr, "test_close_fixed failed\n");
> +		goto err;
> +	}
> +
>  done:
>  	unlink(path);
>  	if (do_unlink)
> 

-- 
Pavel Begunkov
