Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F66F4201AA
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 15:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhJCNTs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 09:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhJCNTr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 09:19:47 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488BDC0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 06:18:00 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id e144so17169164iof.3
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 06:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ohpX+70ZI8kfPsPDXw6vBpcWBolcpOgTx/yatlm5WxE=;
        b=sVejGmId1rTxA7STJYRLjFEo0B7LaHl23j4gaM2owiuk22MQTQtttIWlzZT13QCwCf
         SZNvd/eKjCy+nYGb7oRdbVwL/T0ZQj7DSetqaTTXsEYd0Tzsoz7q1AroXSoLdlAePChl
         j+F+LoGSbYKRRocGL4JGS/KBYvq0dDXbaXHXhRtgp3/P1CtOB2XlHu5TXwvcHt24ncHx
         ADakwA4uQEGOodJ5XelYf6aw7B/LSouhB8t/Nlrc7N93a5xGiAcChMiac0Me/ZC2zqju
         oaDqoSv6Ff2wHsPK3EGis0OleDclqcVnmrFrCbT6hN/4eGyqWtC1WOcvQH6h/gSJmCnr
         kpcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ohpX+70ZI8kfPsPDXw6vBpcWBolcpOgTx/yatlm5WxE=;
        b=JULwQd0K6PfDazUwID3ctSfHYdlU1bAjtBv7HQInItpGiDHiHSpC+hZB5LpcJCixjv
         V4POW6PMEdLjBS+xWUahSE6dGRtoMzM4sr2IXtEFnVLPdNi4wtlasPaLNZ0J2COCeLpF
         K0r8x/OcmGdl/u45RQZQNlGBEXQVkPuKKIVVzi4lSSR20t119+fOS9DphwzbKgnKT8vq
         8Xj81YeizxFbyWdNcBVq6jBSuxlbuL5tz6iJbfs2rT0+3uV3L+7VLFHGQMTW/FHJRFia
         vjCsqZBOdljEhHwa4/defIiy+pEL3m1A2HkiNtAwKlevRMtPB1VNQYVNclCTahfWIyS5
         H/fA==
X-Gm-Message-State: AOAM533LeInFRQ/zPdFD375xal1ooiLceCr/55v0/DkW7krlmW3Vozuf
        roLB9fzicQOYOH5ZF8V9IjxeWQ==
X-Google-Smtp-Source: ABdhPJyZ9TmuJZGJoOlxkGigD1iBIRFWMJe6cYVl+UN+3uqNFxGBRcwX0dOAaZuIAin8u2pTJv42YQ==
X-Received: by 2002:a05:6638:3890:: with SMTP id b16mr6812093jav.65.1633267079612;
        Sun, 03 Oct 2021 06:17:59 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id t10sm7389732iol.34.2021.10.03.06.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 06:17:59 -0700 (PDT)
Subject: Re: [PATCH v4 RFC liburing 3/3] Wrap all syscalls in a kernel style
 return value
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <20211003101750.156218-1-ammar.faizi@students.amikom.ac.id>
 <20211003101750.156218-4-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2f6be7db-5764-8a48-ccbd-4a49f522eae2@kernel.dk>
Date:   Sun, 3 Oct 2021 07:17:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211003101750.156218-4-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> diff --git a/src/register.c b/src/register.c
> index cb09dea..fec144d 100644
> --- a/src/register.c
> +++ b/src/register.c
> @@ -6,7 +6,6 @@
>  #include <sys/mman.h>
>  #include <sys/resource.h>
>  #include <unistd.h>
> -#include <errno.h>
>  #include <string.h>
>  
>  #include "liburing/compat.h"
> @@ -104,13 +103,16 @@ int io_uring_register_files_update(struct io_uring *ring, unsigned off,
>  
>  static int increase_rlimit_nofile(unsigned nr)
>  {
> +	int ret;
>  	struct rlimit rlim;
>  
> -	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
> -		return -errno;
> +	ret = uring_getrlimit(RLIMIT_NOFILE, &rlim);
> +	if (ret < 0)
> +		return ret;
> +
>  	if (rlim.rlim_cur < nr) {
>  		rlim.rlim_cur += nr;
> -		setrlimit(RLIMIT_NOFILE, &rlim);
> +		return uring_setrlimit(RLIMIT_NOFILE, &rlim);
>  	}

This isn't a functionally equivalent transformation, and it's
purposefully not returning failure to increase. It may still succeed if
we fail here, relying on failure later for the actual operation that
needs an increase in files.

> diff --git a/src/syscall.h b/src/syscall.h
> index f7f63aa..3e964ed 100644
> --- a/src/syscall.h
> +++ b/src/syscall.h
> @@ -4,11 +4,15 @@
>  
>  #include <errno.h>
>  #include <signal.h>
> +#include <stdint.h>
>  #include <unistd.h>
> +#include <stdbool.h>
>  #include <sys/mman.h>
>  #include <sys/syscall.h>
>  #include <sys/resource.h>
>  
> +#include <liburing.h>
> +
>  #ifdef __alpha__
>  /*
>   * alpha and mips are exception, other architectures have
> @@ -60,6 +64,21 @@ int __sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
>  			    unsigned int nr_args);
>  
>  
> +static inline void *ERR_PTR(intptr_t n)
> +{
> +	return (void *) n;
> +}
> +
> +

Extra newline here.

Apart from those two, starting to look pretty reasonable.

-- 
Jens Axboe

