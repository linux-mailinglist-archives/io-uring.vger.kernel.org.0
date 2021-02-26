Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71B132657B
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 17:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBZQYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 11:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhBZQX7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 11:23:59 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E76CC06174A
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 08:23:17 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id i9so7564812wml.0
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 08:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EaCswFHezmD6t8vy+WZdTKzhbhtKAZbRTPdYwTbuONs=;
        b=dBp3EVZYguBqmGBFi1ckQ42Z6ekZAegP5rlgF1jY/0uyYDUyoquGlD6GMjcpfw3BwA
         yma6oxPDs6lNUQcnK9ooMA6y9SXpkSDZUKRUHfVxGpQdoyRG4EMc9Loa7PNiEo0ukDlE
         bcS9Emp0WDSlB3O8tWBbH1UqpxN09VWbc/EFPlas+4ic9EnH+96TvPFyH/WLjAQ2kD/g
         gN0Cnwb8bSDw+8RJPQ8TmN0nbu4y/2N1Xx76BFgp0vjBMVl3KKv0jCDaOXRnY6uWiUmX
         9jPFQyLUTVEqp6vbrPHtw3z1YKe12Hi7Zw9fs2HBb/DqpA4JM7oydQ9wrgL6/Inr3MGW
         Dzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EaCswFHezmD6t8vy+WZdTKzhbhtKAZbRTPdYwTbuONs=;
        b=uhrmxw8UkenHJuT6jWB9WctiuTb5WxiNerO6fVeqibC2G4zu/UC/0Sa846kBaxlToH
         Jdqxb07Yq2+ZTJofqngLrCC7xCirRdvMs+8Whc0fM/1Zn2IyLMJ1x+c40GViGjA1+50r
         ZMh9HEfKtz2usNNoD+6YNdV2aN1+fiwfcHdUHaT3O5+37RzRvFXDaloHSwObGX/f3Tz8
         kciHyq+0aQs7g/AaUl/c7Qgw+G+M/8lkn4UtGmJld4THFKyZgrE8L5W6jYEZPMXRtkCS
         MDQEVXwLpg3yZ+TsVY4NuVdDY82NaxtNTjDWsYi6YAm1WrX4uDa8lDMF2E1Kp85LlQNO
         BPCA==
X-Gm-Message-State: AOAM532hz8+mD6DIA8OcYr4Fjt8bQpx4OqrnaOB9N6TH/Bm1wt6+umBd
        z/YlfRrctU8YiWwaEwj3J5UZzfkKqccaiQ==
X-Google-Smtp-Source: ABdhPJytF5V4cRQW1QbQ7mN2Nbvp4q2Es9aqTxwMP/ptX0V2YNK3qHCviFMzjUnQ97+LPwloguX8FQ==
X-Received: by 2002:a1c:2846:: with SMTP id o67mr3659913wmo.188.1614356595530;
        Fri, 26 Feb 2021 08:23:15 -0800 (PST)
Received: from [192.168.8.172] ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id h9sm10624116wmf.38.2021.02.26.08.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 08:23:14 -0800 (PST)
Subject: Re: [PATCH] io_uring: don't re-read iovecs in iopoll_complete
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <562147f55c4adc3518e26ca2b96daebecc9078c5.1614340011.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <ef8d899e-002f-e0a6-a936-f3156fba4aa1@gmail.com>
Date:   Fri, 26 Feb 2021 16:19:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <562147f55c4adc3518e26ca2b96daebecc9078c5.1614340011.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/02/2021 11:49, Pavel Begunkov wrote:
> Request submission and iopolling might happen from different syscalls,
> so iovec backing a request may be already freed by the userspace.
> 
> Catch -EAGAIN passed during submission but through ki_complete, i.e.
> io_complete_rw_iopoll(), and try to setup an async context there
> similarly as we do in io_complete_rw().
> 
> Because io_iopoll_req_issued() happens after, just leave it be until
> iopoll reaps the request and reissues it, or potentially sees that async
> setup failed and post CQE with an error.

Let's wait a week with that. Fine for 5.12, but might get racy after
merging.

> 
> Cc: <stable@vger.kernel.org> # 5.9+
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Reported-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Jens, that assumption that -EAGAIN comes only when haven't yet gone
> async is on you.
> 
>  fs/io_uring.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5c8e24274acf..9fa8ff227f75 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2610,8 +2610,11 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>  		list_del(&req->inflight_entry);
>  
>  		if (READ_ONCE(req->result) == -EAGAIN) {
> +			bool reissue = req->async_data ||
> +				!io_op_defs[req->opcode].needs_async_data;
> +
>  			req->iopoll_completed = 0;
> -			if (io_rw_reissue(req))
> +			if (reissue && io_rw_reissue(req))
>  				continue;
>  		}
>  
> @@ -2794,9 +2797,9 @@ static void kiocb_end_write(struct io_kiocb *req)
>  	file_end_write(req->file);
>  }
>  
> -#ifdef CONFIG_BLOCK
>  static bool io_resubmit_prep(struct io_kiocb *req)
>  {
> +#ifdef CONFIG_BLOCK
>  	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
>  	int rw, ret;
>  	struct iov_iter iter;
> @@ -2826,8 +2829,9 @@ static bool io_resubmit_prep(struct io_kiocb *req)
>  	if (ret < 0)
>  		return false;
>  	return !io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
> -}
>  #endif
> +	return false;
> +}
>  
>  static bool io_rw_reissue(struct io_kiocb *req)
>  {
> @@ -2892,8 +2896,14 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
>  	if (kiocb->ki_flags & IOCB_WRITE)
>  		kiocb_end_write(req);
>  
> -	if (res != -EAGAIN && res != req->result)
> +	if (res == -EAGAIN) {
> +		if (percpu_ref_is_dying(&req->ctx->refs))
> +			res = -EFAULT;
> +		else if (!(req->flags & REQ_F_NOWAIT) && !io_wq_current_is_worker())
> +			io_resubmit_prep(req);
> +	} else if (res != req->result) {
>  		req_set_fail_links(req);
> +	}
>  
>  	WRITE_ONCE(req->result, res);
>  	/* order with io_poll_complete() checking ->result */
> 

-- 
Pavel Begunkov
