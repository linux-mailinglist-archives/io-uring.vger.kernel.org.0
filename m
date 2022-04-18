Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC57B504AC5
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 04:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbiDRCD5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 22:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiDRCD4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 22:03:56 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929A813E93
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 19:01:19 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n8so11279656plh.1
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 19:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=c0UtYwB3XQiAGAZe3QoLQCyyoKKirxtRtGxVPfJPdkw=;
        b=FStFDn96w5tRUw2WHYx0W1KX5wJCzxDQtwMxXuuVaZkESmv4EtgwtBhnvekygIqhse
         8mbS1QXZEh7wPcemuenT/Y7piR5p387ZfS44vbl1DrK3yBF3IIRBrtNPi+xH7WULKN4j
         xAPPMCrmH+bFlFHvac/EPVwoQVMVy5p9qUaso0+yN73N9rqPSXWcfyIiPolX1NiSmztN
         5JIL/nwD9BdEJI8ziNDo+ORnrUy8hgogvkvyz3FPZ7KD6f+9VcNI4XfYBzHGdO0ZCxcy
         zRnqX6yWqLc5jMgAXfZYXW7cp20yjhsmSqMKKtqahPl6B/OUCSazbjpJ2u8BZ2i8Grqa
         yeEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c0UtYwB3XQiAGAZe3QoLQCyyoKKirxtRtGxVPfJPdkw=;
        b=QylgsDOyMTG7vtMV/FJR4H8KZzZy0/aRFzakK/7467OzXyN2v5Iz8Zb/viaHasuFuy
         Lr+bPDKfFliWQcvxkDQM3YSFuxiBcljWV3JZvbAT0e2jNX330XlAhSgBqRfYeEQMmlNl
         +/SqwvDAO7DsBeY0xPztFY/IBJGTv1cZILdV5jy0TQRHCohHHx/V7OAzW9NK8Fvq0xuW
         ucMjJHMQJ+Rmgrn/HjWNHlvLBlbM+VmZQ575qUheduT8oBhvkNqQnp5EQIdQtAovkVJQ
         X7hCznnnyr0wVtPOWjsI1TWhv1FRVwbIEQkLmBWJztNNhZaKpTbxgY69DsRcQEyUwjR3
         NxIA==
X-Gm-Message-State: AOAM532bdl355EXDWXapFJtnRnZcU0EgKqM+DQxA4o2sbtz6SBYmPxEW
        GgAVY5WzIIjN+7CH+a51ScesLmKzXPD3wc5n
X-Google-Smtp-Source: ABdhPJw4oEO80+3PDkomDE1Mscmg2UglrpDfX80faPe0t48MEWTlJYa5gyXj7b1BU5p7zoDJI9oxvA==
X-Received: by 2002:a17:90b:804:b0:1cb:be2d:e28f with SMTP id bk4-20020a17090b080400b001cbbe2de28fmr10346049pjb.21.1650247278959;
        Sun, 17 Apr 2022 19:01:18 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z16-20020a637e10000000b00382b21c6b0bsm11139468pgc.51.2022.04.17.19.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Apr 2022 19:01:18 -0700 (PDT)
Message-ID: <459a2922-55cd-aec1-f4f2-bf037844017f@kernel.dk>
Date:   Sun, 17 Apr 2022 20:01:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH liburing 0/3] Add x86 32-bit support for the nolibc build
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
References: <20220414224001.187778-1-ammar.faizi@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220414224001.187778-1-ammar.faizi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/14/22 4:41 PM, Ammar Faizi wrote:
> Hi,
> 
> This series adds nolibc support for x86 32-bit. There are 3 patches in
> this series:
> 
> 1) Use `__NR_mmap2` instead of `__NR_mmap` for x86 32-bit.
> 2) Provide `get_page_size()` function for x86 32-bit.
> 3) Add x86 32-bit native syscall support.
> 
> The most noticeable changes is the patch 3. Unlike x86-64, only
> use native syscall from the __do_syscall macros when CONFIG_NOLIBC is
> enabled for 32-bit build. The reason is because the libc syscall
> wrapper can do better in 32-bit. The libc syscall wrapper can dispatch
> the best syscall instruction that the environment is supported, there
> are at least two variants syscall instruction for x86 32-bit, they are:
> `int $0x80` and `sysenter`. The `int $0x80` instruction is always
> available, but `sysenter` is not, it relies on VDSO. liburing always
> uses `int $0x80` for syscall if it's compiled with CONFIG_NOLIBC,
> otherwise it uses whatever the libc provides.
> 
> Extra notes for __do_syscall6() macro:
> On i386, the 6th argument of syscall goes in %ebp. However, both Clang
> and GCC cannot use %ebp in the clobber list and in the "r" constraint
> without using -fomit-frame-pointer. To make it always available for
> any kind of compilation, the below workaround is implemented:
> 
>   1) Push the 6-th argument.
>   2) Push %ebp.
>   3) Load the 6-th argument from 4(%esp) to %ebp.
>   4) Do the syscall (int $0x80).
>   5) Pop %ebp (restore the old value of %ebp).
>   6) Add %esp by 4 (undo the stack pointer).
> 
> WARNING:
>   Don't use register variables for __do_syscall6(), there is a known
>   GCC bug that results in an endless loop.
> 
> BugLink: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105032
> 
> 
> ===== How is this tested? =====
> 
> This has been tested on x86-64 Linux (compiled with 32-bit bin support)
> with the following commands:
> 
>   sudo apt-get install gcc-i686-linux-gnu g++-i686-linux-gnu -y;
>   ./configure --cc=i686-linux-gnu-gcc --cxx=i686-linux-gnu-g++ --nolibc;
>   sudo make -j8 runtests;

Looks reasonable to me, even with the warts. I keep threatening to do a
2.2 release, and I do want to do that soon, so question is if we defer
this patchset until after that has happened?

I'm looking for a gauge of confidence on the series.

-- 
Jens Axboe

