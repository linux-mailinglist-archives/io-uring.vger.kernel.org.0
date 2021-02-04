Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF4430F5DC
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 16:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbhBDPJ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 10:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237157AbhBDPIW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 10:08:22 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F4EC0613D6
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 07:07:21 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id u20so3491167iot.9
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 07:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=c6OYH4Eyk2ia7X0UZIv7UzNa5sP9Pjr3T8Tl/CHiXjY=;
        b=dQf+DFeGxxN86KPPHrq7fj+hlRpjsDNu6Zli1H3ycRXVsD1ylm6UTWLL9DU5mIp2oP
         XtqTd2F6TJeYLy+Tf//CurGxV0ofCjQAfS7IYMyDasuil8kZYQ6yQzqgd9LhjxiBoBnT
         nY5hqmykdF3/+nAuYbWT0ABxS4gYp+bVG6QW/HnCuNtN1b5ePBFTk010I/LicTnuwVt0
         1di6aFaziEqYaP2sfNvvmnNcYqxMh6k/A2ynhSw2kBpqUjiGBw4O8U9qCen8G4UsBwJX
         +sLcBP2JYZIdvhB8oTK69V4zLRyjJlwtGot9cxdKdNFYHBO/CUExJk9fL1ZJGpY3JnHU
         djcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c6OYH4Eyk2ia7X0UZIv7UzNa5sP9Pjr3T8Tl/CHiXjY=;
        b=MFVXwtgUkXMHxv6ZbStBd+OURoUi85TV9bgAaAbmHMG7GeS4rr53Yh2awZU3rbprX1
         qQCyPCvk5F75xIZEFgcHN40+DoW+fN9S0XFREn7W4w8zL2hz31eVbMPSEeD9bF/xUnGm
         ACS1aBNtWlS1sZ++38lBzhF8vn+MPG5fxZPmrHYHjO5N8zWm0Wo1x+d3shZ//3bZCSVY
         bD18kLKpsIoDJsaqMYtTey7yhqf3e3OTzuPz+m0Yz4E9pn1iqBbySyJG1O8cTNIoNT8M
         gq/gBpLDOeDmzLj/Zq2ZPy2CrDUs+NBgU4T99j+pOE3G0biRutpiRwtGluAIQmLW11/c
         Pilg==
X-Gm-Message-State: AOAM533PHxpZ/XRghs5GWvpJKWOID8yxOVBjfuA8ELkL/lXNTWi20qar
        QM+DqbPR/h5LTmueEHoHyx13nSyknQX+vbcu
X-Google-Smtp-Source: ABdhPJxfzNGOpdwogm6cVHX+p+p4i8A7uVS19YrA6agfN/bpikR10I8iiVkIxqKDYvWTbAftZzITNw==
X-Received: by 2002:a02:3b6c:: with SMTP id i44mr8234665jaf.91.1612451240946;
        Thu, 04 Feb 2021 07:07:20 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 4sm2786173ilj.22.2021.02.04.07.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 07:07:20 -0800 (PST)
Subject: Re: [PATCH v2 5.12 00/13] a second pack of 5.12 cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612446019.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a5c1cf3b-2a8a-4f86-403b-d14ab9bd6275@kernel.dk>
Date:   Thu, 4 Feb 2021 08:07:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/21 6:51 AM, Pavel Begunkov wrote:
> Bunch of random cleanups, noticeable part of which (4-9/13) refactor
> io_read(), which is currently not in the best shape and is hard to
> understand.
> 
> 7/13 may actually fix a problem.
> 10/13 should make NOWAIT and NONBLOCK to work right
> 
> v2: add 9-13/13
> 
> Pavel Begunkov (13):
>   io_uring: deduplicate core cancellations sequence
>   io_uring: refactor scheduling in io_cqring_wait
>   io_uring: refactor io_cqring_wait
>   io_uring: refactor io_read for unsupported nowait
>   io_uring: further simplify do_read error parsing
>   io_uring: let io_setup_async_rw take care of iovec
>   io_uring: don't forget to adjust io_size
>   io_uring: inline io_read()'s iovec freeing
>   io_uring: highlight read-retry loop
>   io_uring: treat NONBLOCK and RWF_NOWAIT similarly
>   io_uring: io_import_iovec return type cleanup
>   io_uring: deduplicate file table slot calculation
>   io_uring/io-wq: return 2-step work swap scheme
> 
>  fs/io-wq.c    |  16 +--
>  fs/io-wq.h    |   4 +-
>  fs/io_uring.c | 366 ++++++++++++++++++++++----------------------------
>  3 files changed, 166 insertions(+), 220 deletions(-)

Applied, thanks Pavel!

-- 
Jens Axboe

