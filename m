Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BC44A914C
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 00:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbiBCXwQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 18:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiBCXwP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 18:52:15 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAC1C061714;
        Thu,  3 Feb 2022 15:52:15 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m26so3326515wms.0;
        Thu, 03 Feb 2022 15:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=X8nmCVHJ379c2rWKF+EsTK87BPAYAbcavdukluaxqiw=;
        b=SZsI9kxQkQay0F92vHj7zRj7yXLU//8JUXnD1Yge7+5IArP4f8KTLghaAtcsjNojkm
         Bj+FwWsHsxEUgLaj6Gvvvf84gm7UEQmvr8alGdnBoUHYnYDZdKTZoTcpbbwOV9VX1kLD
         3Gi5pUtGy0Cwe6G7UCaEmqA7wUQOHmmAet9Zvksi+MT4eAzc1A2wKJpgoMVykrKr5tFh
         NMXdYlWudWMfuMWK3g5g5dsAI0qoKRUJN4rhJkvK32h+jwpMtDDsmc/YU94Kq7+DlpwK
         67iWTAK1S0OjkIWd8CTpzKuwme1q7yY/4IBWLzckN1G+LZ5GVpZgutZ3qdZYTffxdvKH
         xBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X8nmCVHJ379c2rWKF+EsTK87BPAYAbcavdukluaxqiw=;
        b=RFBiIZgdbktR3Y/b/eXQRdBhyzytDukSbbocxsluG3/NClL6BKq3LGXQJ/eifRlIzD
         fM3xUgHvV6mn68Cld7aFr7TLyERl/oXWnQQ0DEm1Sm8aOBcH+GjWRrQbYrZuQXsCDT3i
         WWnsQOwN85ll01ctwnmKeU09rPWQYMVszQX1CKdt6V9GwAMoYnI6dy4hazbTlHjo+JPy
         fx8XoZjoyDKTwukhYrdo5MzjY1SHNluHTtofb4G6MlJK1f/XOdUX4CALkTAM1v/3LpRl
         ojHJEb6tKe7PzzyeXDEcnyt+chh5A8xJ1o5BnUUoDQCK44ccUflcK4CFPNZO46GjhyHO
         36Fw==
X-Gm-Message-State: AOAM530mQmURqvvAePOB3LnIgWaUEHAhqHiNw0T14+ozdvK+cCqL/zI1
        oYaidmh758iMSqeaQ2nmlBFZLt6N8WI=
X-Google-Smtp-Source: ABdhPJwY1mbB+4B/nUEwyIP1GlGOhr3lx8B64511nH/6AB+0QntZ5XpqkJGZmBUohi06egpDeEVp8g==
X-Received: by 2002:a05:600c:19ce:: with SMTP id u14mr91070wmq.92.1643932333994;
        Thu, 03 Feb 2022 15:52:13 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id o14sm8208859wmr.3.2022.02.03.15.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 15:52:13 -0800 (PST)
Message-ID: <f592de55-5a5c-e715-95c4-d219266bcd9e@gmail.com>
Date:   Thu, 3 Feb 2022 23:47:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 4/4] io_uring: remove ring quiesce for
 io_uring_register
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203233439.845408-1-usama.arif@bytedance.com>
 <20220203233439.845408-5-usama.arif@bytedance.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220203233439.845408-5-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 23:34, Usama Arif wrote:
> Ring quiesce is currently only used for 2 opcodes
> IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS.
> IORING_SETUP_R_DISABLED prevents submitting requests and
> so there will be no requests until IORING_REGISTER_ENABLE_RINGS
> is called. And IORING_REGISTER_RESTRICTIONS works only before
> IORING_REGISTER_ENABLE_RINGS is called. Hence ring quiesce is
> not needed for these opcodes and therefore io_uring_register.

I think I'd prefer to retain quiesce code than reverting this
patch later.



> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> ---
>   fs/io_uring.c | 69 ---------------------------------------------------
>   1 file changed, 69 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5ae51ea12f0f..89e4dd7e8995 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -11022,64 +11022,6 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
>   	return ret;
>   }
>   
> -static bool io_register_op_must_quiesce(int op)
> -{
> -	switch (op) {
> -	case IORING_REGISTER_BUFFERS:
> -	case IORING_UNREGISTER_BUFFERS:
> -	case IORING_REGISTER_FILES:
> -	case IORING_UNREGISTER_FILES:
> -	case IORING_REGISTER_FILES_UPDATE:
> -	case IORING_REGISTER_EVENTFD:
> -	case IORING_REGISTER_EVENTFD_ASYNC:
> -	case IORING_UNREGISTER_EVENTFD:
> -	case IORING_REGISTER_PROBE:
> -	case IORING_REGISTER_PERSONALITY:
> -	case IORING_UNREGISTER_PERSONALITY:
> -	case IORING_REGISTER_FILES2:
> -	case IORING_REGISTER_FILES_UPDATE2:
> -	case IORING_REGISTER_BUFFERS2:
> -	case IORING_REGISTER_BUFFERS_UPDATE:
> -	case IORING_REGISTER_IOWQ_AFF:
> -	case IORING_UNREGISTER_IOWQ_AFF:
> -	case IORING_REGISTER_IOWQ_MAX_WORKERS:
> -		return false;
> -	default:
> -		return true;
> -	}
> -}
> -
> -static __cold int io_ctx_quiesce(struct io_ring_ctx *ctx)
> -{
> -	long ret;
> -
> -	percpu_ref_kill(&ctx->refs);
> -
> -	/*
> -	 * Drop uring mutex before waiting for references to exit. If another
> -	 * thread is currently inside io_uring_enter() it might need to grab the
> -	 * uring_lock to make progress. If we hold it here across the drain
> -	 * wait, then we can deadlock. It's safe to drop the mutex here, since
> -	 * no new references will come in after we've killed the percpu ref.
> -	 */
> -	mutex_unlock(&ctx->uring_lock);
> -	do {
> -		ret = wait_for_completion_interruptible_timeout(&ctx->ref_comp, HZ);
> -		if (ret) {
> -			ret = min(0L, ret);
> -			break;
> -		}
> -
> -		ret = io_run_task_work_sig();
> -		io_req_caches_free(ctx);
> -	} while (ret >= 0);
> -	mutex_lock(&ctx->uring_lock);
> -
> -	if (ret)
> -		io_refs_resurrect(&ctx->refs, &ctx->ref_comp);
> -	return ret;
> -}
> -
>   static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>   			       void __user *arg, unsigned nr_args)
>   	__releases(ctx->uring_lock)
> @@ -11103,12 +11045,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>   			return -EACCES;
>   	}
>   
> -	if (io_register_op_must_quiesce(opcode)) {
> -		ret = io_ctx_quiesce(ctx);
> -		if (ret)
> -			return ret;
> -	}
> -
>   	switch (opcode) {
>   	case IORING_REGISTER_BUFFERS:
>   		ret = io_sqe_buffers_register(ctx, arg, nr_args, NULL);
> @@ -11213,11 +11149,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>   		break;
>   	}
>   
> -	if (io_register_op_must_quiesce(opcode)) {
> -		/* bring the ctx back to life */
> -		percpu_ref_reinit(&ctx->refs);
> -		reinit_completion(&ctx->ref_comp);
> -	}
>   	return ret;
>   }
>   

-- 
Pavel Begunkov
