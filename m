Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0D04280C1
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 13:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhJJLTE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Oct 2021 07:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbhJJLSv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Oct 2021 07:18:51 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4726DC06176C
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 04:16:53 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id s17so11112656ioa.13
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 04:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bV2PQk5NsTuBLkNO5U5cp6aYX5eHoqcW8mhMWP2kvHA=;
        b=ZHRz0VCShu7RtjgCxfHjwq94XPscmM98hFlfpm/GKmt0UnRBUYncgudeJEA+0OyxeI
         IPDj9BuB0MiUCGSM54KU2Z3bXpL1966G5XjOmP3VE3+c7c0UPuNBC9dEHHt6bfY0mngq
         2vs+DN3Cwog87/WWOmjIJXntozUsT15JDZohD/vkQgMv8+gRT+LUJR/QY0UGCBUCqP5q
         HPaqb7BolbtjTKmV0go5XlE8GqfqtlOQP8/l8cVfparv8jhrOGzuZm9BGro2/UOWjuRz
         ByTI/8k4/jXZbocVzjjjkFUY1JZS6D9V1Ms40zcFDxUx992SnrTzMOb5mNGMBlZzCqQ8
         WMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bV2PQk5NsTuBLkNO5U5cp6aYX5eHoqcW8mhMWP2kvHA=;
        b=UlzeyufKxqmMZhClIfc8QVUay+G0wzGYYSKanh2Yi/UxMOT2LeWAgNln/q3jMcDL8b
         AgU2YPpCl9rJJx7Cm89u8tyN5/meCew9/F0U83DPsBaWFC5btEqnFIMyg9uOe/b6oI5o
         cCPapsFEW6NieUji322dDJrX+v3I062kAHRovZ0pHNgtdQK42bRWbmE21kF1Bimv1N1M
         pyI2XKfpSRiaZyu1bIzzyr/D0csPtgx8k5LVsqSeJTK6Y6uyEKEcV6S974m9uZu1ioQz
         9OCPpH2vqz5M2lXOOqMbGrUrwaUu58F2750JkmY98Uv+tR6Y51+9mmaQtLMImLL+i8+r
         x9Dw==
X-Gm-Message-State: AOAM533hTurKf0/hVSgcmRGw88BmpAqIzOip9BLD4Y4DuGRAHlQv99OF
        4xJ8OHBa8qahNftRsOX4Kvf6OQ==
X-Google-Smtp-Source: ABdhPJy4t4cys1Mdma0XYzhSHsGGxVLKC2ovOtxaqj+q47g560HpPZqoliBBk0YaLOJ2ve/eoTFIKQ==
X-Received: by 2002:a05:6638:3293:: with SMTP id f19mr15140203jav.51.1633864612552;
        Sun, 10 Oct 2021 04:16:52 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id e10sm2403210ili.53.2021.10.10.04.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 04:16:52 -0700 (PDT)
Subject: Re: [PATCH v2 liburing 2/4] Add arch dependent directory and files
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <20211010063906.341014-1-ammar.faizi@students.amikom.ac.id>
 <20211010063906.341014-3-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3fbbc207-0df3-bace-838e-5286c3092935@kernel.dk>
Date:   Sun, 10 Oct 2021 05:16:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211010063906.341014-3-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/21 12:39 AM, Ammar Faizi wrote:
> Create a new directory `src/arch` to save arch dependent sources.
> Add support start from x86-64, add syscalls crafted in Assembly code
> and lib (currently the lib only contains get page size function).
> 
> Link: https://github.com/axboe/liburing/issues/443
> Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
> ---
>  src/arch/x86/lib.h     |  26 ++++++
>  src/arch/x86/syscall.h | 200 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 226 insertions(+)
>  create mode 100644 src/arch/x86/lib.h
>  create mode 100644 src/arch/x86/syscall.h
> 
> diff --git a/src/arch/x86/lib.h b/src/arch/x86/lib.h
> new file mode 100644
> index 0000000..0d4b321
> --- /dev/null
> +++ b/src/arch/x86/lib.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: MIT */
> +
> +#ifndef LIBURING_ARCH_X86_LIB_H
> +#define LIBURING_ARCH_X86_LIB_H
> +
> +#ifndef LIBURING_LIB_H
> +#  error "This file should be included from src/lib.h (liburing)"
> +#endif
> +
> +#if defined(__x86_64__)
> +
> +static inline long __arch_impl_get_page_size(void)
> +{
> +	return 4096;
> +}
> +
> +#else /* #if defined(__x86_64__) */
> +
> +/*
> + * TODO: Add x86 (32-bit) support here.
> + */
> +#error "x86 (32-bit) is currently not supported"

Can we change this to:

#error "x86 (32-bit) is currently not supported for nolibc builds"

to make it a bit more specific. Apart from that, this looks good.

-- 
Jens Axboe

