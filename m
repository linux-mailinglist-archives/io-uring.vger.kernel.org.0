Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7844252FE
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 14:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbhJGM3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 08:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241308AbhJGM3w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 08:29:52 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092A0C061746
        for <io-uring@vger.kernel.org>; Thu,  7 Oct 2021 05:27:59 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id p68so6538923iof.6
        for <io-uring@vger.kernel.org>; Thu, 07 Oct 2021 05:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=icUtX52MNkKbUOZJug/39HWLFs9m9Ibwi1nyK2qV6Gc=;
        b=A6A6ad1OuJDZsUdWsIrLyb7XkHtOz//mDZZhuAtQ76IGCybxGOGT3jBMTjFnAhdCGo
         ybIBxGqqI6vk1Olp+tFWqjEIWisfOA8z2KeZSldyY5EUoAO+uMLyZm0o/6d4qkGky53w
         xZghRKgMd4FjTQ2lBSs8ymFPLMJJBNsGdR+BEyHa1gdCy2aQZU3AZLyfILQzYz0skA8E
         Mu2XatHzUhBPDo+e8jcgQZJzl2EIxO+9iEeXAh7vPc5iWaojrz7yF4CWV5MiQh5fx9dw
         dzoF++NSfx88gnNP5UIW2RlQ+7ar88hmoj5qJ9pK8ryDPwpFiwwj3k+f/MrJfDguyoYF
         AT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=icUtX52MNkKbUOZJug/39HWLFs9m9Ibwi1nyK2qV6Gc=;
        b=YQe2zOAUvi6ntvRxnYJ6gMTafy9N2Y9eeay7roQtwTk08HisCIoho9EC27Ndct2N7N
         3u2I7D+cnJoO6sYryutm+bWojmVRTMb6/qnSsf4FUTWXJidk2y3iDWJnOCleydpbYyV0
         YBMNufOFCxcEbzQC0XWXTNl5Y/kP5ez4BoMvM8uk1Iaiwg7/XFN2jTFhkVkvrab+pLoy
         Tq5ZPwH4tcnHUEFK7K4Nia7Hg9f8XIKAJCGXUorEKR7SCm0dJlwcL1NN9wxKHOliAfQe
         Yu8n3x+vz5s2A/v7SB80Mf17QKJejaNkCdfPNtpHRBt1G7QT3ipJlu9UMOPhPJIgAHLM
         ap7A==
X-Gm-Message-State: AOAM5315j2DvQsQEYsY4e6z3plR69BSd2qjpyejRUyl3tY5OFqUx5fIl
        N5rvG9vjbjnuWU0i+a63gWcTHg==
X-Google-Smtp-Source: ABdhPJwnVouOQVTK43eWIlSZqMBKVhPYDnbay0FGjoeNvn3m88fiSSuOs+4QuggxmAOV8AHl/9oLoA==
X-Received: by 2002:a02:6a0d:: with SMTP id l13mr2787007jac.92.1633609678490;
        Thu, 07 Oct 2021 05:27:58 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o1sm13717165ilj.41.2021.10.07.05.27.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 05:27:58 -0700 (PDT)
Subject: Re: [PATCH v2 RFC liburing 4/5] Add no libc build support
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <a8a96675-91c2-5566-4ac1-4b60bbafd94e@kernel.dk>
 <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
 <20211007063157.1311033-5-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3ca99c4b-1aa6-b10e-340c-f2d860c39b57@kernel.dk>
Date:   Thu, 7 Oct 2021 06:27:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211007063157.1311033-5-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/7/21 12:31 AM, Ammar Faizi wrote:
> Create `src/nolibc.c` to substitute libc functions like `memset()`,
> `malloc()` and `free()`. Only build this file when we build liburing
> without libc.
> 
> Wrap libc functions with `static inline` functions, defined in
> `src/lib.h`, currently we have:
>  1) `get_page_size`
>  2) `uring_memset`
>  3) `uring_malloc`
>  4) `uring_free`
> 
> Add conditional preprocessor in `src/{syscall,lib}.h` to use arch
> dependent and nolibc functions when we build liburing without libc.
> 
> Extra notes for tests:
>  1) Functions in `src/syscall.c` require libc to work.
>  2) Tests require functions in `src/syscall.c`.
> 
> So we build `src/syscall.c` manually from test's Makefile.
> 
> The Makefile in `src/` dir still builds `src/syscall.c` when we
> compile liburing with libc.

Why are we jumping through hoops on the naming? You add a uring_memset()
that the lib is supposed to use, then that calls memset() with libc or
__uring_memset() if we're building without libc. Why not just have the
nolibc build provide memset() and avoids this churn? Not just in terms
of the immediate patch, that matters less. But longer term where
inevitably a memset() or similar will be added to the existing code
base.

-- 
Jens Axboe

