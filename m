Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA35E36F236
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 23:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhD2Vni (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 17:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbhD2Vni (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 17:43:38 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC46C06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 14:42:50 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e5so39707216wrg.7
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 14:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9WkbRWqb+txyBt26RKsQFAnguvM14NvRE6PTIYpAVJ0=;
        b=Yy9VZM8hWsPNC0A5A8EWvyggm2SuepZye19lty+8o4rjiwedo0KLH9rJDLnGksQrx0
         sd35vajMAEjfZcdo/D6Kjj9LxFbenMYkn8yuq1+8GegrJRiaJhhqv7SAtA8tfhve87vQ
         ZUoab5SF51rxvNLvftQE97Z/P5ks7O7QgtVF39Me823vcf4i+1O79cizTkE2bBWejsiG
         ZN55XO53fE14xgvyHMwYueleVP8VE7XzYlyKJxv2VKBJ3A9HvpVLECtLB2ecZMDxvtp9
         nSe7PuCxzwG7S0NHoaxvircmOXuN1qjjTcNw1JcjUSo+DHQyRusmEUpOqORelVIHOCs8
         iS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9WkbRWqb+txyBt26RKsQFAnguvM14NvRE6PTIYpAVJ0=;
        b=PJlDeYiI3sc4aBEbdLW9gj7yLAkO9AXB5bToMCGFEM+2yOuo25HnoUG9jj01Nv8H8p
         IHR9L0OrkiXfzxWLvtB+BLNFmwULieiWw18kAnvdQrxNnXmjr2UnOoigvlmo/TccOJ1D
         nZAHAhFesUA7g+Ypf1CvzxiLgSHefRTfNDAx4kHB+4gHBD/5zx6y/qEucYuw9eYRjlDS
         sb23WM0RkOlH4sJO1UoOm3qzabI3VeCOUVxy4pwZg6SMRSOfrbbx9YurAWZvUumdAGaq
         o9ipTQ42tk3GLefmAC6GuWhjNY49vKpvoTb17owB+XdHNPh0E+RUG/s2HqxnBKeDmPEt
         d5jw==
X-Gm-Message-State: AOAM531ddseTvQdDzrwKVA6IRUOvxnhiu+gSk0GMoUxX8PuyPIehDLWR
        0FjDkVjyWxyGFH81gjKa3QWygm/R1eQ=
X-Google-Smtp-Source: ABdhPJxV0lE9G7xf7bvYfyaYrw4fv4kf/OoLAJU4CC1OddU1XKCbzlCRpCaYqlNgXDyrSDGuyK5K2g==
X-Received: by 2002:adf:df8d:: with SMTP id z13mr2033066wrl.317.1619732569490;
        Thu, 29 Apr 2021 14:42:49 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id g19sm1157560wme.48.2021.04.29.14.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 14:42:49 -0700 (PDT)
Subject: Re: [PATCH liburing] test: test ring exit cancels SQPOLL's iowq
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <5ff453f83e0202fcdb48c27b6597aa615cd17f01.1619390260.git.asml.silence@gmail.com>
Message-ID: <e3837b06-1173-6fc0-a349-fbfbc16013fc@gmail.com>
Date:   Thu, 29 Apr 2021 22:42:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <5ff453f83e0202fcdb48c27b6597aa615cd17f01.1619390260.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/21 11:38 PM, Pavel Begunkov wrote:
> Another SQPOLL cancellation test making sure that io_uring_queue_exit()
> does cancel all requests and free the ring, in particular for SQPOLL
> requests gone to iowq.

up

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  test/io-cancel.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/test/io-cancel.c b/test/io-cancel.c
> index c08b7e5..c2a39b5 100644
> --- a/test/io-cancel.c
> +++ b/test/io-cancel.c
> @@ -438,6 +438,48 @@ static int test_cancel_inflight_exit(void)
>  	return 0;
>  }
>  
> +static int test_sqpoll_cancel_iowq_requests(void)
> +{
> +	struct io_uring ring;
> +	struct io_uring_sqe *sqe;
> +	int ret, fds[2];
> +	char buffer[16];
> +
> +	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SQPOLL);
> +	if (ret) {
> +		fprintf(stderr, "ring create failed: %d\n", ret);
> +		return 1;
> +	}
> +	if (pipe(fds)) {
> +		perror("pipe");
> +		return 1;
> +	}
> +	/* pin both pipe ends via io-wq */
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_read(sqe, fds[0], buffer, 10, 0);
> +	sqe->flags |= IOSQE_ASYNC | IOSQE_IO_LINK;
> +	sqe->user_data = 1;
> +
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_write(sqe, fds[1], buffer, 10, 0);
> +	sqe->flags |= IOSQE_ASYNC;
> +	sqe->user_data = 2;
> +	ret = io_uring_submit(&ring);
> +	if (ret != 2) {
> +		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
> +		return 1;
> +	}
> +
> +	/* wait for sqpoll to kick in and submit before exit */
> +	sleep(1);
> +	io_uring_queue_exit(&ring);
> +
> +	/* close the write end, so if ring is cancelled properly read() fails*/
> +	close(fds[1]);
> +	read(fds[0], buffer, 10);
> +	close(fds[0]);
> +	return 0;
> +}
>  
>  int main(int argc, char *argv[])
>  {
> @@ -461,6 +503,11 @@ int main(int argc, char *argv[])
>  		return 1;
>  	}
>  
> +	if (test_sqpoll_cancel_iowq_requests()) {
> +		fprintf(stderr, "test_sqpoll_cancel_iowq_requests() failed\n");
> +		return 1;
> +	}
> +
>  	t_create_file(".basic-rw", FILE_SIZE);
>  
>  	vecs = t_create_buffers(BUFFERS, BS);
> 

-- 
Pavel Begunkov
