Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E90420286
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 17:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhJCQBE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 12:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhJCQBE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 12:01:04 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADECEC0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 08:59:16 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id z184so4297486iof.5
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 08:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J4pq5JYti+AggVSW//Gbm3/UEQzOVMCNGg14KwVZC3s=;
        b=Oi7p5Ws6nhmj59NJlkfauzT2G3qiko9g3FHIMWxlHF8cU7bzeqASiEx9buJQdvDG8+
         hM/ghw8p01sGQ1TDVL6tTpH2t1r1v6W++IqlN3vftIfV+OfJd52QVpaZ/ZG6h3eVv+VR
         MRc9yuwIUNgdjgWJWzpSBfSVz0evoAL8qiw4pQg6Mxlr/N6dqZq5ZOWyyRRVzm/aTx9t
         QHDYzmC2v+4Iw/iFJcYke85LnCko9/F2lesjVg7ePgTk+ezjILEOP2tolYlF6ALlINod
         +aTDYdEXXn6K96U6Yyu7yOxiKGnP+up4hHQOl0bf1YMRuZi93QeYUdFf2Z76bCPnrEum
         8n7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J4pq5JYti+AggVSW//Gbm3/UEQzOVMCNGg14KwVZC3s=;
        b=eprBllOpXaYQgAN/NbSe/7RDeMpwkabhNPaiqNh32JLaAz+bR+gcD+gSUEinFHnKWq
         cQG4Mt0shZDn8zeINKEWSluRfIPsNXwkDwNYlZiYi4lPnETvnZ/ctkh9jSJNf4zkAUlk
         RZ57uZC42khfNnnxIQrlRVc2VPzL9UegI9qIJe9+tQ5TPH+7jvVgyeCoYMAlBL99osBT
         kn6bKHB/Ab5nIcm5sKq0M5AYdaGCWLfMo+8gMvZMwucO06Ex5dW1rEmlgGf9lOyzATJG
         rEsW1W9mVGgfKeuoXy1qYaUulhXmbX4UZMaWxKjzbMQTpY2gJyFw7XdLI7hOXV9mkTj3
         hk6A==
X-Gm-Message-State: AOAM532SfmXuziK3D6bJ/MSNEmhFTgtD8VHryrA7IjzlRiPPyXxhIuwG
        Ex7OQXn0LSNKXOwEf5yq8P4wXA==
X-Google-Smtp-Source: ABdhPJzuMqA+ts/rjd9mQ4kCMEtkhUUr/KrPVTNncwIVveVrHqlG39seN/erVi4yczo6cWrIT3RdJw==
X-Received: by 2002:a05:6602:1486:: with SMTP id a6mr2983517iow.104.1633276755987;
        Sun, 03 Oct 2021 08:59:15 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id n138sm7603069iod.37.2021.10.03.08.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 08:59:15 -0700 (PDT)
Subject: Re: [PATCH v5 liburing 0/3] Implement the kernel style return value
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <20211003153428.369258-1-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9be53222-dd40-1dc7-437d-46a752704277@kernel.dk>
Date:   Sun, 3 Oct 2021 09:59:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211003153428.369258-1-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/3/21 9:34 AM, Ammar Faizi wrote:
> Hi Jens,
> 
> This is the v5 of the kernel style return value implementation for
> liburing.
> 
> The main purpose of these changes is to make it possible to remove
> the dependency of `errno` variable in the liburing C sources. If we
> can land this on liburing, we will start working on adding support
> build liburing without libc.
> 
> Currently, we expose these functions to userland:
>   1) `__sys_io_uring_register`
>   2) `__sys_io_uring_setup`
>   3) `__sys_io_uring_enter2`
>   4) `__sys_io_uring_enter`
> 
> The tests in `test/io_uring_{enter,register,setup}.c` are the examples
> of it. Since the userland needs to check the `errno` value to use them
> properly, this means those functions always depend on libc. So we
> cannot change their behavior. Don't touch them all, this ensures the
> changes only affect liburing internal and no visible functionality
> changes for the users.
> 
> Then we introduce new functions with the same name (with extra
> underscore as prefix, 4 underscores):
>   1) `____sys_io_uring_register`
>   2) `____sys_io_uring_setup`
>   3) `____sys_io_uring_enter2`
>   4) `____sys_io_uring_enter`
> 
> These functions do not use `errno` variable *on the caller*, they use
> the kernel style return value (return a negative value of error code
> when errors).
> 
> These functions are defined as `static inline` in `src/syscall.h`.
> They are just a wrapper to make sure liburing internal sources do not
> touch `errno` variable from C files directly. We need to make C files
> not to touch the `errno` variable to support build without libc.
> 
> To completely remove the `errno` variable dependency from liburing C
> files. We wrap all syscalls in a kernel style return value as well.
> 
> Currently we have 5 other syscalls in liburing. We wrapped all of
> them as these 5 functions:
>   1) `uring_mmap`
>   2) `uring_munmap`
>   3) `uring_madvise`
>   4) `uring_getrlimit`
>   5) `uring_setrlimit`
> 
> All of them are `static inline` and will return a negative value of
> error code in case error happens.
> 
> Extra new helpers:
>   1) `ERR_PTR()`
>   2) `PTR_ERR()`
>   3) `IS_ERR()`
> 
> These helpers are used to deal with syscalls that return a pointer.
> Currently only `uring_mmap()` that depends on these.

Thanks, let's give this a go. I've applied the 3 patches.

-- 
Jens Axboe

