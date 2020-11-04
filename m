Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3F72A6DDA
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 20:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgKDTaE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 14:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgKDTaE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 14:30:04 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A04C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 11:30:02 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id b8so23323560wrn.0
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 11:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bC20gInbT+9tk8vXvmhNxkU4TFDTSZSl2BMBbnv2PJA=;
        b=DDVEBc59p/8VOmj2qqOU5mdYegmeURMM4LJdDRsDAwgmzlNjUn2yVVN/XByL49bVJ+
         mbjaXOc630VUtospx3nxvnX/pSMq/gc42qxFLbK3yUIVVZnmvxEx8cJHafRSeWO7qeS8
         ahG7KvSVbXdzaqT9RoK53YLx7Dt8rCyhSlfZnW0nT+dGqcv9pz/PHbhcp+0AEcIJWYBd
         oYs0WrPFNYiD7fdC4I+JERbrM1zkl7MaBqlPAr1zCsT8FhzjZdmxdSbxhTuMrzqTuysm
         Q2434w2oY3jmJy42L2JLkAp1qZSt47Kstm0mK4DLDYNCNJEcYgtNK0yvQaFeFa2DNxr7
         feeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=bC20gInbT+9tk8vXvmhNxkU4TFDTSZSl2BMBbnv2PJA=;
        b=AJgTaOY2EFw+ptUtj/3T2XTBRkEuMXrcxOtSU4ATg3fM5qO4PsThD6jVVSljw/dqhI
         10OH3JlZdSFCRi4WAffmgEnwB7RMxSeq2OJfc0gw33/EKqBRmtxzgghWU+kHP9mHibgW
         DvXd4sbjiDi/lUmMBg9xIlf9KBNcf4E4oNVda3tYstv608RZeV3tPxvnUqeJrzdl/+NO
         so7KzK+O4ce95jwMqxbq+0wDLvaE3oMvT8allzQIkNqec9A3YxCVVeZpVOKT8IUMjl1T
         0V81w6ekZ0YFVFXYbktDFfdFpWa3SNoHgIJ0PrW83iVrXjSXxo4jQR8Er+YXFSTkGC3j
         8TLA==
X-Gm-Message-State: AOAM532OltuqUP7aUozkXVMjvDMsGXkExMfzDm7qtHduc8kb8BU8ojyN
        7uAcVXNqpVTKcVQ0obIv7y0S6t60WW2UOw==
X-Google-Smtp-Source: ABdhPJwYvoXAbi5lJ+aLDLjqya4mqp9qdOXrK3tcb/P4BEBhWft3ZHWB187ayDxPJzBiikyXz5G8aA==
X-Received: by 2002:a5d:6ac6:: with SMTP id u6mr24674706wrw.145.1604518201152;
        Wed, 04 Nov 2020 11:30:01 -0800 (PST)
Received: from [192.168.1.121] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id i6sm3650218wma.42.2020.11.04.11.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 11:30:00 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, metze@samba.org,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1604307047-50980-1-git-send-email-haoxu@linux.alibaba.com>
 <1604372077-179941-1-git-send-email-haoxu@linux.alibaba.com>
 <c2ae5254-d558-a48f-fca2-0759781bf3e1@kernel.dk>
 <052a2b54-017f-8617-5d1a-074408d164fd@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 RESEND] io_uring: add timeout support for
 io_uring_enter()
Message-ID: <fa632df8-28c8-a63f-e79a-5996344b8226@gmail.com>
Date:   Wed, 4 Nov 2020 19:27:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <052a2b54-017f-8617-5d1a-074408d164fd@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/11/2020 18:32, Jens Axboe wrote:
> On 11/4/20 10:50 AM, Jens Axboe wrote:
>> +struct io_uring_getevents_arg {
>> +	sigset_t *sigmask;
>> +	struct __kernel_timespec *ts;
>> +};
>> +
> 
> I missed that this is still not right, I did bring it up in your last
> posting though - you can't have pointers as a user API, since the size
> of the pointer will vary depending on whether this is a 32-bit or 64-bit
> arch (or 32-bit app running on 64-bit kernel).

Maybe it would be better 

1) to kill this extra indirection?

struct io_uring_getevents_arg {
-	sigset_t *sigmask;
-	struct __kernel_timespec *ts;
+	sigset_t sigmask;
+	struct __kernel_timespec ts;
};

then,

sigset_t *sig = (...)arg;
__kernel_timespec* ts = (...)(arg + offset);


It'd spare us from IORING_ENTER_GETEVENTS_TIMEOUT but we'd need
to find a way to disable some of them. E.g. don't use sigmask when
user don't want it, but sigsz == sizeof(io_uring_getevents_arg),

and parsing would look like

switch (argsz) {
case sizeof(struct io_uring_getevents_arg): {
	struct __kernel_timespec ts = argp + ts_offset;
	...
}
fallthrough;
case sizeof(sig): {
	const sigset_t __user *sig = argp;
	...
	break;
}
default:
	return -EINVAL;
}

2) and move all the parsing into io_cqring_wait(). That sounds better
performance-wise.

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7e6945383907..2f533f6815ea 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -9158,8 +9158,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>  			return -EINVAL;
>  		if (copy_from_user(&arg, argp, sizeof(arg)))
>  			return -EFAULT;
> -		sig = arg.sigmask;
> -		ts = arg.ts;
> +		sig = u64_to_user_ptr(arg.sigmask);
> +		ts = u64_to_user_ptr(arg.ts);
>  	} else {
>  		sig = (const sigset_t __user *)argp;
>  		ts = NULL;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index fefee28c3ed8..0b104891df68 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -338,8 +338,8 @@ enum {
>  };
>  
>  struct io_uring_getevents_arg {
> -	sigset_t *sigmask;
> -	struct __kernel_timespec *ts;
> +	__u64	sigmask;
> +	__u64	ts;
>  };
>  
>  #endif
> 

-- 
Pavel Begunkov
