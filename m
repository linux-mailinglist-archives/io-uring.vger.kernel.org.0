Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EEC403A2C
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 14:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348596AbhIHM6T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 08:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhIHM6T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 08:58:19 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6943FC061757
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 05:57:11 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id m11so3064511ioo.6
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 05:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zlLFuLsEO1KhZNssRCS/UqTZg9l4RR8M7d6mRWooPJ4=;
        b=G0FHI0+TbbRym4y4+FpomxJpim8aM6oaGQSYxUKq6AquZsZZW6DfcsNzMn+u8r4ldU
         5IAUlb3DyATiXAF8QoKR1+0o+aY7sAsVkATOEWoUWpmYA2G5FWjqtPHjO0Dz+KvWEr2T
         /nIZktS6I07pz07e4edqEPxLX19xceagumZwlrDIKT+28mQONHnRhHnj+v2ORcUvXNGs
         xTo/m/cab+IwGF4JTygQd5DliXqll7koMjWA71qgqmiJ9BuTQTvwwz+VRMADmK1QDqkM
         3qfp+UPqmc7P9QU7bMPP+Nrx9zP3iHk9Zn91mn+XwstiL5r2oAHje2ejZhX9Ax6EjHIx
         2B6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zlLFuLsEO1KhZNssRCS/UqTZg9l4RR8M7d6mRWooPJ4=;
        b=uIcEvm5Xw1KI4HqJMPJTf6cdTn+Da7Rm1rbU2gMMPTBKN/3w0LWxeCMsaQ2lHRUDPo
         lqN1+fnmqXm5NrnYaIhfugvzpHwx4CI4O0lXLecmsFVbGtTmcmoqoF18qFU9yzmeIjLl
         biu7xVirx+J7OV0MYHih1/4VZevbGI5RD/6WK32/lvu8BNeM/oKQChb1EToRnx4GKw/o
         8kLeAbUR3YZbSjFEHdfPILilSdEgfuVETWCWq81WkTMhxbUJ7MMf866LbZqY/L6ADWhk
         HabuUBD0XIdBEZfgLCqMf2wD6LwHMjr6LDftCUdqtnzZtjYCc1Vkn17hp709NE5yzEo5
         fqFg==
X-Gm-Message-State: AOAM530sHIcQPWPl/0+G/r9/rCZqmgcfQimG465o94SX+jJL7b15yfGj
        JEUGWXRglS9FckMGuUS4tgFQkGuZbV2Diw==
X-Google-Smtp-Source: ABdhPJyHcxRG0FJw36LQTyj78jm4G+FYy1D3he1BNpgGkdRo2a2edYPyKBfl4gr344behPEVDezdNg==
X-Received: by 2002:a6b:2b97:: with SMTP id r145mr3108904ior.193.1631105830552;
        Wed, 08 Sep 2021 05:57:10 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a25sm1062821ioq.46.2021.09.08.05.57.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 05:57:10 -0700 (PDT)
Subject: Re: [PATCH] /dev/mem: nowait zero/null ops
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     io-uring@vger.kernel.org
References: <16c78d25f507b571df7eb852a571141a0fdc73fd.1631095567.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ed21a6b0-be32-e00a-98c3-f25759a44071@kernel.dk>
Date:   Wed, 8 Sep 2021 06:57:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <16c78d25f507b571df7eb852a571141a0fdc73fd.1631095567.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 4:06 AM, Pavel Begunkov wrote:
> Make read_iter_zero() to honor IOCB_NOWAIT, so /dev/zero can be
> advertised as FMODE_NOWAIT. This helps subsystems like io_uring to use
> it more effectively. Set FMODE_NOWAIT for /dev/null as well, it never
> waits and therefore trivially meets the criteria.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/char/mem.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 1c596b5cdb27..531f144d7132 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -495,6 +495,8 @@ static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
>  		written += n;
>  		if (signal_pending(current))
>  			return written ? written : -ERESTARTSYS;
> +		if (iocb->ki_flags & IOCB_NOWAIT)
> +			return written ? written : -EAGAIN;
>  		cond_resched();
>  	}

I don't think this part is needed.

>  	return written;
> @@ -696,11 +698,11 @@ static const struct memdev {
>  #ifdef CONFIG_DEVMEM
>  	 [DEVMEM_MINOR] = { "mem", 0, &mem_fops, FMODE_UNSIGNED_OFFSET },
>  #endif
> -	 [3] = { "null", 0666, &null_fops, 0 },
> +	 [3] = { "null", 0666, &null_fops, FMODE_NOWAIT },
>  #ifdef CONFIG_DEVPORT
>  	 [4] = { "port", 0, &port_fops, 0 },
>  #endif
> -	 [5] = { "zero", 0666, &zero_fops, 0 },
> +	 [5] = { "zero", 0666, &zero_fops, FMODE_NOWAIT },
>  	 [7] = { "full", 0666, &full_fops, 0 },
>  	 [8] = { "random", 0666, &random_fops, 0 },
>  	 [9] = { "urandom", 0666, &urandom_fops, 0 },
> 

This looks fine.

-- 
Jens Axboe

