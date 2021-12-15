Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCAC47644B
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 22:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhLOVJy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 16:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhLOVJy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 16:09:54 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55464C06173E
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 13:09:54 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id p65so32285968iof.3
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 13:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5Q+WSgSr064mkUseEEX3jWFB2tdlOM5Z453qQSoCbHg=;
        b=WDlBqkdEI7kxFH+wJqgqXjUjeYPC1/0TkN+cEF34zn2SRUrML+Dgbin5phBwiRtsAt
         m1dYAXifjaNaSzKX4SxOimN2ee5uYH7Q6IDxzyGwxKwAhGVRXFmao5vc+L+6a0PU/3Sz
         uO8VKvDTKuxT6YDNsZX0/n3RHOPikReASjGPFgg/l/SImoN6kzJdjTXF3c77nDvXUmDD
         rl7MMddA60u9j/fbDDqsLhGYrIHCjnasoli1QU5bRuchIektDsf/D/ycE0HgbGZeR8qu
         5gi0sFC9LmTPZ8l2bU1kje3w9wNfS09g4X0rRCsV6SOEyd9t7k+K2riagwLDpwtPTPAk
         qR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Q+WSgSr064mkUseEEX3jWFB2tdlOM5Z453qQSoCbHg=;
        b=tmEM6EszWlrCOx54qb7h+F5C/hnpvMndcUnbETmYiQb40USknXa3/HLWlXNAV6SUk/
         q87zUvhY+jxfNOyTafUGDnLb6r7t2s2LM1UnsE5dg7CRmNTEsM5ySw7NCi9Y4iNXMfWT
         +WoL8K2IPX4Az1lN/M8NeQDNMidFZsdGBjaMVsNSjjjVfUxKP1hfO6f3g/nDuT0kUWTl
         CULqBe1XC2ZtMzShV2ZCQetM2R5plHLTygXcwlyPEFyygD7drcjxCUjuQjzxu8FUonRq
         CVtyBsuKn5jjsPdbldi366mjuDGoFeFwrc5HR4CYiC6YiRN7osw4Mae9cyb+u88OIE/W
         ITSw==
X-Gm-Message-State: AOAM532OZnrZoMPq7zhOOZJyGcCg6GzSZHxmbuukICQ1CV981DXTyevW
        sv0DSTdVB96LR/AhxfnviDAyew==
X-Google-Smtp-Source: ABdhPJwTvinOdFkaSDVsp24gveeu8UqEF5AB3Nx+fm5Kd2lsZrKm1PTUVDnWjrAKYv97eTEZWBpuzw==
X-Received: by 2002:a02:ab8f:: with SMTP id t15mr7128205jan.147.1639602593713;
        Wed, 15 Dec 2021 13:09:53 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u24sm1558545ior.20.2021.12.15.13.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 13:09:53 -0800 (PST)
Subject: Re: [PATCH v2 0/3] io_uring: add getdents64 support
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <20211124231700.1158521-1-shr@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <49b476cb-0de6-22ff-61b7-87ac300b9567@kernel.dk>
Date:   Wed, 15 Dec 2021 14:09:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211124231700.1158521-1-shr@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/21 4:16 PM, Stefan Roesch wrote:
> This series adds support for getdents64 in liburing. The intent is to
> provide a more complete I/O interface for io_uring.
> 
> Patch 1: fs: add parameter use_fpos to iterate_dir()
>   This adds a new parameter to the function iterate_dir() so the
>   caller can specify if the position is the file position or the
>   position stored in the buffer context.
> 
> Patch 2: fs: split off vfs_getdents function from getdents64 system call
>   This splits of the iterate_dir part of the syscall in its own
>   dedicated function. This allows to call the function directly from
>   liburing.
> 
> Patch 3: io_uring: add support for getdents64
>   Adds the functions to io_uring to support getdents64.
> 
> There is also a patch series for the changes to liburing. This includes
> a new test. The patch series is called "liburing: add getdents support."

Al, ping on this one as well, same question on the VFS side.

-- 
Jens Axboe

