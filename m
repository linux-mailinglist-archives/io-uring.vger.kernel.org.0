Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF425F2EEF
	for <lists+io-uring@lfdr.de>; Mon,  3 Oct 2022 12:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiJCKkd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Oct 2022 06:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiJCKkK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Oct 2022 06:40:10 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880FD49B6D
        for <io-uring@vger.kernel.org>; Mon,  3 Oct 2022 03:40:05 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id e10-20020a05600c4e4a00b003b4eff4ab2cso8788678wmq.4
        for <io-uring@vger.kernel.org>; Mon, 03 Oct 2022 03:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=1Dw8KXfm6iLd2P5grhw87JO4qo7p8vhaTo4Z6CCVlBo=;
        b=WYj5cQhTgodwDRXwJvC5mHZdZx8bWXE5nNlaOHWJFAfkuMak4KxglrsnfGUrLpRfO+
         0OERv8I7TBiMrYTVc7y+gNj+ZX7fr5W8h/CWV6Z/SQ3xWIqcvkgqfnBVpTcKdzilt7Bl
         19Brjj6efLMlyVlUYw8D/N+mFHWVSVhOzfH+5oZ/aQTxa/k5xi9UY7VVs8nmh6c1492Y
         GBtft4aUFxfu0ydeMu7EgwrtkrBDidh2mp1i8y5MH2H+3G/lP02id+Q7Qx4Pa0kX+fUJ
         GSLl1pHZXmM0HzVeEZIx2ymlXftE92CAwCluxBvqHRLagMHDM7/mQ4JXkXp18kFc+qJS
         Wahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=1Dw8KXfm6iLd2P5grhw87JO4qo7p8vhaTo4Z6CCVlBo=;
        b=qQqnW8wA7ICvyN3Hp43cJOJRIi51DHn24JMsTYYDuFjvq4Zxo4DWFuuGGvZctSsVju
         Wo4iUqnbM3aBeXe9WNt7bsfXrk2HaE8lIO5vND/zBB3fnz89e2BZQIzZlfPnHt/CXGRe
         chIlJ6ZvdaFx/wSoyKurvpymXGWJnMjMpgjJC2Zy/Y8HuJAclA8dVkKiEHCOmQC8+yly
         zpyFBUxQaM2m7sx01Gzf5mUTzeBe+vfx8soHfQ8ivrXHcXKf2OTVY6W1/BnellD+xTHy
         TU7xObXmWZqphbglzgk+c+LwlrYhaJ7IjeSmrXK3oogwNKMQqPh9518iY3OTm5m7oJA6
         6q2g==
X-Gm-Message-State: ACrzQf1lUJn539LZKrF5by+p0FFDq5JbVnLgoPLQu3IIpFX6kXou/t/W
        5G3rbQurR3QWYNk3A6kFJmHRtV/Da8o=
X-Google-Smtp-Source: AMsMyM6r1GaJxQx2EfGqqPJR4MGzziIV17THRQzpr5FZXZ55whqri4+0XBhvvxwvTMUB9+VDw7rBpQ==
X-Received: by 2002:a05:600c:35cf:b0:3b4:c0c2:d213 with SMTP id r15-20020a05600c35cf00b003b4c0c2d213mr6751318wmq.162.1664793603946;
        Mon, 03 Oct 2022 03:40:03 -0700 (PDT)
Received: from [192.168.8.100] (188.30.232.152.threembb.co.uk. [188.30.232.152])
        by smtp.gmail.com with ESMTPSA id j6-20020a05600c190600b003b477532e66sm23884029wmq.2.2022.10.03.03.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 03:40:03 -0700 (PDT)
Message-ID: <6932613a-e900-3cd3-cecf-5b982ae84a19@gmail.com>
Date:   Mon, 3 Oct 2022 11:35:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] io_uring: fix short read/write with linked ops
To:     David Stevens <stevensd@chromium.org>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20221003091923.2096150-1-stevensd@google.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221003091923.2096150-1-stevensd@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/3/22 10:19, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> When continuing a short read/write, account for any completed bytes when
> calculating the operation's target length. The operation's actual
> accumulated length is fixed up by kiocb_done, and the target and actual
> lengths are then compared by __io_complete_rw_common. That function
> already propagated the actual length to userspace, but the incorrect
> target length was causing it to always cancel linked operations, even
> with a successfully completed read/write.

The issue looks same as fixed with

https://git.kernel.dk/cgit/linux-block/commit/?h=for-6.1/io_uring&id=bf68b5b34311ee57ed40749a1257a30b46127556

Can you check if for-6.1 works for you?

git://git.kernel.dk/linux.git for-6.1/io_uring
https://git.kernel.dk/cgit/linux-block/log/?h=for-6.1/io_uring


> Fixes: 227c0c9673d8 ("io_uring: internally retry short reads")
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>   io_uring/rw.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 76ebcfebc9a6..aa9967a52dfd 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -706,13 +706,14 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
>   	struct kiocb *kiocb = &rw->kiocb;
>   	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>   	struct io_async_rw *io;
> -	ssize_t ret, ret2;
> +	ssize_t ret, ret2, target_len;
>   	loff_t *ppos;
>   
>   	if (!req_has_async_data(req)) {
>   		ret = io_import_iovec(READ, req, &iovec, s, issue_flags);
>   		if (unlikely(ret < 0))
>   			return ret;
> +		target_len = iov_iter_count(&s->iter);
>   	} else {
>   		io = req->async_data;
>   		s = &io->s;
> @@ -733,6 +734,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
>   		 * need to make this conditional.
>   		 */
>   		iov_iter_restore(&s->iter, &s->iter_state);
> +		target_len = iov_iter_count(&s->iter) + io->bytes_done;
>   		iovec = NULL;
>   	}
>   	ret = io_rw_init_file(req, FMODE_READ);
> @@ -740,7 +742,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
>   		kfree(iovec);
>   		return ret;
>   	}
> -	req->cqe.res = iov_iter_count(&s->iter);
> +	req->cqe.res = target_len;
>   
>   	if (force_nonblock) {
>   		/* If the file doesn't support async, just async punt */
> @@ -850,18 +852,20 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>   	struct iovec *iovec;
>   	struct kiocb *kiocb = &rw->kiocb;
>   	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> -	ssize_t ret, ret2;
> +	ssize_t ret, ret2, target_len;
>   	loff_t *ppos;
>   
>   	if (!req_has_async_data(req)) {
>   		ret = io_import_iovec(WRITE, req, &iovec, s, issue_flags);
>   		if (unlikely(ret < 0))
>   			return ret;
> +		target_len = iov_iter_count(&s->iter);
>   	} else {
>   		struct io_async_rw *io = req->async_data;
>   
>   		s = &io->s;
>   		iov_iter_restore(&s->iter, &s->iter_state);
> +		target_len = iov_iter_count(&s->iter) + io->bytes_done;
>   		iovec = NULL;
>   	}
>   	ret = io_rw_init_file(req, FMODE_WRITE);
> @@ -869,7 +873,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>   		kfree(iovec);
>   		return ret;
>   	}
> -	req->cqe.res = iov_iter_count(&s->iter);
> +	req->cqe.res = target_len;
>   
>   	if (force_nonblock) {
>   		/* If the file doesn't support async, just async punt */

-- 
Pavel Begunkov
