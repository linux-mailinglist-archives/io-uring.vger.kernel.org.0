Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175F645DE55
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 17:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356366AbhKYQMq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 11:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356376AbhKYQKq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 11:10:46 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79A5C0617A5;
        Thu, 25 Nov 2021 07:55:54 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id i5so12640062wrb.2;
        Thu, 25 Nov 2021 07:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=W5cqCxZab5R3GKtO7D+pDtXsizA0EzP36NiILRNFYgk=;
        b=EvJYqyQ04f9Vtpz3rYR4TqhxLVuD4aAQRHAMiomlwF0G3uOu97QSFuhus03d/VWh66
         s0Js3Lu+4ojsGvhATUmExSncCil/eNIQiSH/wYmEyYfuaZ2aPsb+PlPfqIUiK3TMraq+
         hWvl41s6A2dFLZiTwSyVcgFlOtpBoqBkcXeyg1VQ8G43RsZHAMEL6pq/2Gafb1G8lA1V
         Xr2206bGFXAdQM4nUtgZuFvKX7Ks+/qaFBCz/nxwRbgaKcu4vdW9k90jiuGePrVyTMGB
         LxIg+rpeo7ReqvPbD2U4byAhQADVIOudlo3uGe5j6HJtAbMjzHB0mj398nrCmOEq6uKd
         lCIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W5cqCxZab5R3GKtO7D+pDtXsizA0EzP36NiILRNFYgk=;
        b=6sWxsNKCatnwaQvWTfw8sB+znQUGocZ9prLKelVPn7JiGmMFzi9T20OecMx9lVfjD9
         AMS0iGBg6vJ+sLdG2HeSpH5vA76TnAzHim5hZ9Gu//HQTvex1RTNaK6K1JgCDQyRG6aU
         QnddbP0C9IE7FaPbgS07OgFb2WwOsexY8jshfJiGmzoU0zK41/FsBy/bY8452Qos9lBO
         OmVRcru1B2oo9Vocth3B9xRvl5Ptnh+QLumES8aFWTllpLu7NxYqeWt6fFvhfVL9ThlZ
         0Ca3mQUTnuVD1u2ANk6CMB/Ftn1DKBSyuE3c7St4wGeXKYjAzoBRWrHvVgyxuNvw3eIN
         lGOg==
X-Gm-Message-State: AOAM530koh7XC9nL3pCrWxvxoMHH7BKIYVZj/Zzdd0NrJdMn/MB5Ftln
        CAuLlk9rq6aJSyeize/JAqRc8boEedY=
X-Google-Smtp-Source: ABdhPJyMVjZHnqO5A6MbJW6x0zK66ggN72w150ozV/TQ9NUirbpDfrCOHzoy9O1jWZf3qqSpTtt1sA==
X-Received: by 2002:adf:edc6:: with SMTP id v6mr7784365wro.461.1637855753494;
        Thu, 25 Nov 2021 07:55:53 -0800 (PST)
Received: from [192.168.43.77] (82-132-229-54.dab.02.net. [82.132.229.54])
        by smtp.gmail.com with ESMTPSA id c1sm3112138wrt.14.2021.11.25.07.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 07:55:53 -0800 (PST)
Message-ID: <a2fd9431-d61c-d222-03cb-dbc481fa1996@gmail.com>
Date:   Thu, 25 Nov 2021 15:55:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v1 1/3] fs: add parameter use_fpos to iterate_dir function
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20211123181010.1607630-1-shr@fb.com>
 <20211123181010.1607630-2-shr@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211123181010.1607630-2-shr@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/23/21 18:10, Stefan Roesch wrote:
> This adds the use_fpos parameter to the iterate_dir function.
> If use_fpos is true it uses the file position in the file
> structure (existing behavior). If use_fpos is false, it uses
> the pos in the context structure.
> 
> This change is required to support getdents in io_uring.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>   fs/exportfs/expfs.c    |  2 +-
>   fs/nfsd/nfs4recover.c  |  2 +-
>   fs/nfsd/vfs.c          |  2 +-
>   fs/overlayfs/readdir.c |  6 +++---
>   fs/readdir.c           | 28 ++++++++++++++++++++--------
>   include/linux/fs.h     |  2 +-
>   6 files changed, 27 insertions(+), 15 deletions(-)
> 
[...]
> diff --git a/fs/readdir.c b/fs/readdir.c
> index 09e8ed7d4161..8ea5b5f45a78 100644
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -21,6 +21,7 @@
>   #include <linux/unistd.h>
>   #include <linux/compat.h>
>   #include <linux/uaccess.h>
> +#include "internal.h"
>   
>   #include <asm/unaligned.h>
>   
> @@ -36,8 +37,14 @@
>   	unsafe_copy_to_user(dst, src, len, label);		\
>   } while (0)
>   
> -
> -int iterate_dir(struct file *file, struct dir_context *ctx)
> +/**
> + * iterate_dir - iterate over directory
> + * @file    : pointer to file struct of directory
> + * @ctx     : pointer to directory ctx structure
> + * @use_fpos: true : use file offset
> + *            false: use pos in ctx structure
> + */
> +int iterate_dir(struct file *file, struct dir_context *ctx, bool use_fpos)
>   {
>   	struct inode *inode = file_inode(file);
>   	bool shared = false;
> @@ -60,12 +67,17 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
>   
>   	res = -ENOENT;
>   	if (!IS_DEADDIR(inode)) {
> -		ctx->pos = file->f_pos;
> +		if (use_fpos)
> +			ctx->pos = file->f_pos;

One more thing I haven't noticed before, should pos be sanitised
somehow if passed from the userspace? Do filesystems handle it
well?


> +
>   		if (shared)
>   			res = file->f_op->iterate_shared(file, ctx);
>   		else
>   			res = file->f_op->iterate(file, ctx);
> -		file->f_pos = ctx->pos;
> +
> +		if (use_fpos)
> +			file->f_pos = ctx->pos;
> +
>   		fsnotify_access(file);
>   		file_accessed(file);
>   	}


-- 
Pavel Begunkov
