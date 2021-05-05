Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E871E374A14
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 23:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhEEVZR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 17:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhEEVZR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 17:25:17 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3494EC06174A
        for <io-uring@vger.kernel.org>; Wed,  5 May 2021 14:24:20 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id m124so2711258pgm.13
        for <io-uring@vger.kernel.org>; Wed, 05 May 2021 14:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tbi2NP8oFf5oAcg/x098y443Byr1ACnKEW59oCKludQ=;
        b=xx0pwIuSOktpNkeWklZJGu6Cko0G1l0bvVUGDKVEgbnizr19MculAxr2bDpvI3Vfgi
         iGsk5zrblgoIpZFH27viwjt5uyxAGkkyWhnTpD1y5r0pUFvRG9g6Vam2W3OmLb3Heohb
         hr5dbqm4LSKjWPQ4dyAqLoGf2Ed9z6fMrzu9yWvodPRYqYqRU37Gs19UjEUcOCnljHp5
         mmsFmxa1WPGEKYSeEg6uSmnwZSSCxHMF7LAB4VOEkXlr0q3uGxP0KkU2qtzlEtY0Plh9
         dgAqNF37qqiECS88f41al64jl8wefKns/fal1dWMnORwvw/BlsnID4Hy5SpMDPh70or2
         77Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tbi2NP8oFf5oAcg/x098y443Byr1ACnKEW59oCKludQ=;
        b=aiGkYXgNeLNbufJlTgj1T0+wH+rLSVqK9I1JJ5g7sf7gkjWPjz7I2MD3QbWGNpKt7n
         LcdXvRRmS4Xc6E015fVQvjmcxLYu2c5EKsvXN4Ug11kvD32tBl9A4e8mv7/qgJ+VwoMr
         KQnMq19pDXqvzDot5AqQjnN6W2iJ5IrUEdpW6OL7OLHGmKgCVGyhZktsA0FEtTYGO/RB
         jotfb92V8+tPUaTmvofgCTvKBQqaD3kumW17YA2yP2/hfdLzxhQ0XXofmkT2jR3yUok3
         mnCwu5puUs4icg9tym6xvqAzvch7J5nfYpcxK7LFMe5VDjXFC17qwsgrN6CgLfFIAEmt
         v4GQ==
X-Gm-Message-State: AOAM532d0gMoLeRIEFnIK9O2K7kmGTO0qB+X5xoT491AWpnVIS4OeTQw
        8PYF5VFVjcaWPxn7IvodZtO4dg==
X-Google-Smtp-Source: ABdhPJzVOY3MFoCiJbIHKSnoYSS+LXA5vMsUgbYKPariGqAf/lvnj8U6hvTzRQauGY+yfzVosWCQ3Q==
X-Received: by 2002:a05:6a00:706:b029:217:9e8d:f9cc with SMTP id 6-20020a056a000706b02902179e8df9ccmr1005944pfl.1.1620249859635;
        Wed, 05 May 2021 14:24:19 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id br10sm8005727pjb.13.2021.05.05.14.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 14:24:19 -0700 (PDT)
Subject: Re: [PATCH v2] io_thread/x86: setup io_threads more like normal user
 space threads
To:     Stefan Metzmacher <metze@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        x86@kernel.org
References: <20210411152705.2448053-1-metze@samba.org>
 <20210505110310.237537-1-metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <df4b116a-3324-87b7-ff40-67d134b4e55c@kernel.dk>
Date:   Wed, 5 May 2021 15:24:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210505110310.237537-1-metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/21 5:03 AM, Stefan Metzmacher wrote:
> As io_threads are fully set up USER threads it's clearer to
> separate the code path from the KTHREAD logic.
> 
> The only remaining difference to user space threads is that
> io_threads never return to user space again.
> Instead they loop within the given worker function.
> 
> The fact that they never return to user space means they
> don't have an user space thread stack. In order to
> indicate that to tools like gdb we reset the stack and instruction
> pointers to 0.
> 
> This allows gdb attach to user space processes using io-uring,
> which like means that they have io_threads, without printing worrying
> message like this:
> 
>   warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386
> 
>   warning: Architecture rejected target-supplied description
> 
> The output will be something like this:
> 
>   (gdb) info threads
>     Id   Target Id                  Frame
>   * 1    LWP 4863 "io_uring-cp-for" syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
>     2    LWP 4864 "iou-mgr-4863"    0x0000000000000000 in ?? ()
>     3    LWP 4865 "iou-wrk-4863"    0x0000000000000000 in ?? ()
>   (gdb) thread 3
>   [Switching to thread 3 (LWP 4865)]
>   #0  0x0000000000000000 in ?? ()
>   (gdb) bt
>   #0  0x0000000000000000 in ?? ()
>   Backtrace stopped: Cannot access memory at address 0x0

I have queued this one up in the io_uring branch, also happy to drop it if
the x86 folks want to take it instead. Let me know!

-- 
Jens Axboe

