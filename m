Return-Path: <io-uring+bounces-251-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD4E80715D
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 14:56:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30A1C1F20FEC
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 13:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 915EE3C46C;
	Wed,  6 Dec 2023 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c3Rtak9W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4877612B
	for <io-uring@vger.kernel.org>; Wed,  6 Dec 2023 05:56:08 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-54d712c254aso1187788a12.0
        for <io-uring@vger.kernel.org>; Wed, 06 Dec 2023 05:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701870966; x=1702475766; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9NtHEXBKTWTiA0icVnsHeiE8Pfrx+OjZf5R3SvMQ/3M=;
        b=c3Rtak9WDCqlJMrkfbhUWGg0X01uiTncTGVQa2l5UQ7kf4+sLxg17XsPvRmDEcolf2
         8x5Xs8N5AtFhl7jTsGPEzkgKA81dkKiwGRyE0rswlOmbAQw/3KDyXqZLIiE1kh34nlkw
         bedjnUw0Nn9N0Qo3Kw/5o1TBUS1kMBlWqt7ZuXOlrPCfPlpC3FoKDqXGmfOGoZgNBgFD
         Iert9wMe+o69MThuFWXmFs/9YxXZn3RuuuDtHMrCyRX8ymvJJFXmpIVl0hdJEwpy0vSn
         0PhAAM/nYz6dtJSvUO5TQERf/17C9V9j9e7Jp9uAifanC3hfRS+z3+QBkN8s6XTand7t
         KVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701870966; x=1702475766;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9NtHEXBKTWTiA0icVnsHeiE8Pfrx+OjZf5R3SvMQ/3M=;
        b=iqPzJxlWrlgfC/rE9sX9xtN4WrEbyeLfRFu/7ax281NHYQ5f65VbCtjbN+W2m/03BT
         5HyZOfoSjZF3bDDjyvDUHinKvtWEtBExM16yVUkng5GV+rb5rpeYzXJoOdHfBd4A2BBm
         NuQxffceEESvbwfxLezt9oubJEJXpnc6wbvmkqcy4DcY/yEtPbcky5zT5aipDuodlFN2
         tCxfKUr0XLhfJhapGA8eCk3xJpso3nDzG1muANp9mUOX0cQ0dZZpOCbZEfL+BkjPeqCo
         S4/QRHmWFQXNeiyb68mRxhSFhZHQSnOA/+O0sgEp24LUBCWLeugB94vNK0q/5PYQPbLW
         q3gw==
X-Gm-Message-State: AOJu0YzVl4KhiTI7rb9IcENhXpAkQhKTmvOQPbyHYWTahqxVrsbbSoQs
	kUs0dUW1dwsbSKe/yz5R5ppA7QSSFtQ=
X-Google-Smtp-Source: AGHT+IH5c0iJqqXzNxiKLqYlDYBBvNlJXG0EAge8Ffbtw4DC8z0CPFRQ70mIfzhJ509OxMieesO2Jg==
X-Received: by 2002:a50:8d18:0:b0:54c:b175:87bf with SMTP id s24-20020a508d18000000b0054cb17587bfmr646174eds.2.1701870966120;
        Wed, 06 Dec 2023 05:56:06 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:15ce])
        by smtp.gmail.com with ESMTPSA id o24-20020aa7c518000000b005485282a520sm2453765edq.75.2023.12.06.05.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Dec 2023 05:56:05 -0800 (PST)
Message-ID: <5810c5a1-c991-4c1a-a159-6c5b16b692bf@gmail.com>
Date: Wed, 6 Dec 2023 13:53:00 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/af_unix: disable sending io_uring over
 sockets
Content-Language: en-US
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, jannh@google.com
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/6/23 13:26, Pavel Begunkov wrote:
> File reference cycles have caused lots of problems for io_uring
> in the past, and it still doesn't work exactly right and races with
> unix_stream_read_generic(). The safest fix would be to completely
> disallow sending io_uring files via sockets via SCM_RIGHT, so there
> are no possible cycles invloving registered files and thus rendering
> SCM accounting on the io_uring side unnecessary.

As it involves AF_UNIX I should have CC'ed net maintainers,
I'll be resending it.


> Cc: stable@vger.kernel.org
> Fixes: 0091bfc81741b ("io_uring/af_unix: defer registered files gc to io_uring release")
> Reported-and-suggested-by: Jann Horn <jannh@google.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Note, it's a minimal patch intended for backporting, all the leftovers
> will be cleaned up separately.
> 
>   io_uring/rsrc.h | 7 -------
>   net/core/scm.c  | 6 ++++++
>   2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 8625181fb87a..08ac0d8e07ef 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -77,17 +77,10 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>   
>   int __io_scm_file_account(struct io_ring_ctx *ctx, struct file *file);
>   
> -#if defined(CONFIG_UNIX)
> -static inline bool io_file_need_scm(struct file *filp)
> -{
> -	return !!unix_get_socket(filp);
> -}
> -#else
>   static inline bool io_file_need_scm(struct file *filp)
>   {
>   	return false;
>   }
> -#endif
>   
>   static inline int io_scm_file_account(struct io_ring_ctx *ctx,
>   				      struct file *file)
> diff --git a/net/core/scm.c b/net/core/scm.c
> index 880027ecf516..7dc47c17d863 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -26,6 +26,7 @@
>   #include <linux/nsproxy.h>
>   #include <linux/slab.h>
>   #include <linux/errqueue.h>
> +#include <linux/io_uring.h>
>   
>   #include <linux/uaccess.h>
>   
> @@ -103,6 +104,11 @@ static int scm_fp_copy(struct cmsghdr *cmsg, struct scm_fp_list **fplp)
>   
>   		if (fd < 0 || !(file = fget_raw(fd)))
>   			return -EBADF;
> +		/* don't allow io_uring files */
> +		if (io_uring_get_socket(file)) {
> +			fput(file);
> +			return -EINVAL;
> +		}
>   		*fpp++ = file;
>   		fpl->count++;
>   	}

-- 
Pavel Begunkov

