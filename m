Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5753041E7B5
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 08:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352171AbhJAGqc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 02:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbhJAGqb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 02:46:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694E1C06176A
        for <io-uring@vger.kernel.org>; Thu, 30 Sep 2021 23:44:47 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n2so5655943plk.12
        for <io-uring@vger.kernel.org>; Thu, 30 Sep 2021 23:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=33qZFAu9Fhqooj342fhTL+VSwjk2kKh/jHVBudbP514=;
        b=Thyk7ZCGd9D8A2EYWdCioeJP6tAmW8QEOVKCOuOuEPjk/kWNOQZhrOyPtaRS5n+CxW
         eN485okvWIGJsYWp4xzud/A7fBQ/x5gIFGuaRkxZFvdppdWTOxfn4lWFNfbmo91+8f8Z
         D4INedRRwf0S000B8LmizxIQuO9o89pV+B29IV5ssmGokHURXIew9J8j6HHcepkEzp0p
         yJaCMVM8ZxMgZd7Zhi/Nccd02DHDx2AS2GcUcoUtKcLWd4L0EgkpmoZlO06NM/tc0r3h
         kL8jN0ob36GeTiC0xUz7o2J4m53I6H0UJ+mUmWfT3n+/xvI67R5w6M4ZyuykXEyrHqzX
         cRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=33qZFAu9Fhqooj342fhTL+VSwjk2kKh/jHVBudbP514=;
        b=JPecbXXErs+U6lHw/GXzZgSSyyIQRWFVnNUyaeQ+qCBfiOcxclYNHuwd9SWeQP4T9y
         sF1YunwYz+0de8hbI+qQid/e3fCH+tsYImzk7wrzibRTFmsE1I8OUaPC1RWuY7vbzb+b
         G/SSlH0DbXZcCaFykFu+St4jxSk0HBwZxykoD5mj4bsFj6WRfUJBG2GwDnAdV8F8T5Ys
         Lr97NnPvdGje7Clxvu8hoFrqWqlo4U+ekuR3m5KT/GPcXxMuOHJnvID+AZA/LiCCppxa
         0DuycsnTOWCRMWhCgEBqlIfg6PAIgSeBsP+RsyDH2aieuNb4oZSuXuh7RLucbaMcmkXt
         zv3Q==
X-Gm-Message-State: AOAM530ABYQkuplIar1POVXhI/0lELPz+oRmlTuQ6jGYRG5QzlM3X34w
        X0kqsp5I0sUzfM2JbXA52vRvUGAqdICDPw==
X-Google-Smtp-Source: ABdhPJz0UEIkgCvWSMq+kLBjeQUhiOsH1CXhlQlU52RlhMZlbtaLzPbWlTT+vdduxnRfhnS2+XUMKQ==
X-Received: by 2002:a17:90a:680c:: with SMTP id p12mr11157585pjj.33.1633070687004;
        Thu, 30 Sep 2021 23:44:47 -0700 (PDT)
Received: from [192.168.43.248] ([182.2.72.37])
        by smtp.gmail.com with ESMTPSA id s17sm4880489pge.50.2021.09.30.23.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 23:44:46 -0700 (PDT)
Subject: Re: [PATCHSET v1 RFC liburing 0/6] Implement the kernel style return
 value
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gmail.com>
References: <20210929101606.62822-1-ammar.faizi@students.amikom.ac.id>
 <CAGzmLMX5X45jukOgWuT=+FLvh4eq=mRZ54Rgh1J1W2U3f69fPQ@mail.gmail.com>
From:   Louvian Lyndal <louvianlyndal@gmail.com>
Message-ID: <89cf843d-be43-4bd6-0e20-4fb04a500512@gmail.com>
Date:   Fri, 1 Oct 2021 13:44:42 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAGzmLMX5X45jukOgWuT=+FLvh4eq=mRZ54Rgh1J1W2U3f69fPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/21 5:16 PM, Ammar Faizi wrote:
> ### 3) How to deal syscalls
>
> We have 3 patches in this series to wrap the syscalls, they are:
>   - Add `liburing_mmap()` and `liburing_munmap()`
>   - Add `liburing_madvise()`
>   - Add `liburing_getrlimit()` and `liburing_setrlimit()`
>
> For `liburing_{munmap,madvise,getrlimit,setrlimit}`, they will return
> negative value of error code if error. They basically just return
> an int, so nothing to worry about.
>
> Special case is for pointer return value like `liburing_mmap()`. In
> this case we take the `include/linux/err.h` file from the Linux kernel
> source tree and use `IS_ERR()`, `PTR_ERR()`, `ERR_PTR()` to deal with
> it.
>
>
> ### 4) How can this help to support no libc environment?
>
> When this kernel style return value gets adapted on liburing, we will
> start working on raw syscall directly written in Assembly (arch
> dependent).
>
> Me (Ammar Faizi) will start kicking the tires from x86-64 arch.
> Hopefully we will get support for other architectures as well.
>
> The example of liburing syscall wrapper may look like this:
>
> ```c
> void *liburing_mmap(void *addr, size_t length, int prot, int flags,
>                     int fd, off_t offset)
> {      
> #ifdef LIBURING_NOLIBC
>         /*
>          * This is when we build without libc.
>          *
>          * Assume __raw_mmap is the syscall written in ASM.
>          *
>          * The return value is directly taken from the syscall
>          * return value.
>          */
>         return __raw_mmap(addr, length, prot, flags, fd, offset);
> #else
>         /*
>          * This is when libc exists.
>          */
>         void *ret;
>
>         ret = mmap(addr, length, prot, flags, fd, offset);
>         if (ret == MAP_FAILED)
>                 ret = ERR_PTR(-errno);
>
>         return ret;
> #endif
> }
> ```

This will add extra call just to wrap the libc. Consider to static
inline them?

For libc they just check the retval, if it's -1 then return -errno. If
they are inlined, they are ideally identical with the previous version.

Besides they are all internal functions. I don't see why should we
pollute global scope with extra wrappers.

Regards,

--
Louvian Lyndal
