Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C094E745E
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 14:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349875AbiCYNoL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 09:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiCYNoJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 09:44:09 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B78CFBBB
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 06:42:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o6-20020a17090a9f8600b001c6562049d9so8352560pjp.3
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 06:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=c+Yyzlx/Y/hGhztkUb5XnWZtRE0o0fC5gaPZq4psCY0=;
        b=ZS4z/gKfSywXDIjwIAWh73t+HJY2p46HRTmDN4MwllvEq+IS62eTwJrpSxRk/G/1fx
         utVftfoc+LQeS+LvehTBzLmNVrHbBywz+TQzALIdONzsVNpJzhjKTfF8jzzM+O7Kftsm
         0AcdNoaWCrMHt5dxv1XBQfDAO3/RpC8fp760wTyteF7jvTm21FV4MPo++vVg7rqwZV3G
         a981Rrx7fzyi2AWyJRrAZ1+MJvqpAqUyYXrzSsqwW0cVES3Z/UGKK8xNByr9OtHKCJ8y
         nB7Cfvh6VRRUWnNb87l9SrSfGB2aGJOxPf7HzmvCd7Gqoe3OTlOkr9rPq6YYl3ES1bD7
         MeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c+Yyzlx/Y/hGhztkUb5XnWZtRE0o0fC5gaPZq4psCY0=;
        b=uBWqOLUxCLtoxWPWy1BUvxhxIxHWCDOtRGai4UTKbciGtFid6ZNB78qANPulc3vn9U
         XyL62oYzj9BWrHvYnPufMmybaj0sYjLa3JeBwNxtNSyLrvoz0HJvX6qTKDYCQzoGC6Dx
         +KKJQtwVT54C98yZFi3dPKLSwir7VApgpwKZ0Zh1uIPiXxxWSqztyMnoFtNRkfWzeU2R
         NpL8nbA8UY/b0El+ymQQmB1pZmE9O6yy5kmPSsmF+dVLVGG8rs3vvXbYPcCwI4AI7OFJ
         Z7HevgJI8vXVTChf18Zm7jjbSiV4V6MRFQqcmj9hncw3z5kOWvlhVH5sZARbHXAQ79y8
         AKfA==
X-Gm-Message-State: AOAM532rbPHwVYZD0dYyL25VoCoC4MtAk4b8sQt7GjTZOi6F5X2/28sS
        Q8vM8udQojviPw/kPUsEH7jX1nYbZ0oTbkCs
X-Google-Smtp-Source: ABdhPJz6aUiXuQIj8KHIA5LU7/fpoohOPChuVdn2gG/PoY2swjILXk2FnFKhJun+P6bnaFx8WUDgcA==
X-Received: by 2002:a17:902:cec5:b0:154:6b18:6157 with SMTP id d5-20020a170902cec500b001546b186157mr11617075plg.145.1648215755005;
        Fri, 25 Mar 2022 06:42:35 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000cd000b004fadb6f0290sm6911972pfv.11.2022.03.25.06.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 06:42:34 -0700 (PDT)
Message-ID: <321d1fef-e6b9-c32d-2d1e-1d132e050c6f@kernel.dk>
Date:   Fri, 25 Mar 2022 07:42:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] io_uring: fix invalid flags for io_put_kbuf()
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1648212967.git.asml.silence@gmail.com>
 <ccf602dbf8df3b6a8552a262d8ee0a13a086fbc7.1648212967.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ccf602dbf8df3b6a8552a262d8ee0a13a086fbc7.1648212967.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/22 7:00 AM, Pavel Begunkov wrote:
> io_req_complete_failed() doesn't require callers to hold ->uring_lock,
> use IO_URING_F_UNLOCKED version of io_put_kbuf(). The only affected
> place is the fail path of io_apoll_task_func(). Also add a lockdep
> annotation to catch such bugs in the future.
> 
> Fixes: 3b2b78a8eb7cc ("io_uring: extend provided buf return to fails")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 862401d23a5a..c83a650ca5fa 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1388,6 +1388,8 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
>  		cflags = __io_put_kbuf(req, &ctx->io_buffers_comp);
>  		spin_unlock(&ctx->completion_lock);
>  	} else {
> +		lockdep_assert_held(&req->ctx->uring_lock);
> +
>  		cflags = __io_put_kbuf(req, &req->ctx->io_buffers_cache);
>  	}
>  
> @@ -2182,7 +2184,7 @@ static inline void io_req_complete(struct io_kiocb *req, s32 res)
>  static void io_req_complete_failed(struct io_kiocb *req, s32 res)
>  {
>  	req_set_fail(req);
> -	io_req_complete_post(req, res, io_put_kbuf(req, 0));
> +	io_req_complete_post(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
>  }

That took me a bit to grok, but it's because we don't use the flag here
as "ok we need to grab that same lock, rather we use it for "should we
use something else" which makes it safe. We should probably use a bool
for this case instead rather than abuse issue_flags, for later.

-- 
Jens Axboe

