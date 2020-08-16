Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADAB245579
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 04:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgHPChd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 22:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgHPChc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 22:37:32 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A575C061786
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 19:37:32 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c10so6705423pjn.1
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 19:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fhVOo1Q2InhZ1KbIHyFqLqEG8IVcC3BtHUbMG2zv5Y0=;
        b=ZS4i2Y6IAWz1WOR/HWcjhIk9VHQWqLH4Qh7o0HC8QViaBqWGxGSU2qs64/rXJYO2KA
         PpV/nIV2ZyTdZpRs/BfaWOodlysNOTjON6iVe7EoJLMS9mrcEyMg3X+bn40cLix/zSXA
         wtmfUchjHWiQ0D2PezS2J3+UDe6LgYSC/Pmv9hY3AyP6GFwb5sfHZfEQ1EAbcyiMjLVw
         2GhHTcVpmJyfZPv01KoHUibGETu/zPXICAHSfi7GF4o8Hv6TtxFIe6whGmL/5kCYoLP0
         aSOuK9K4z+PsSVyl/D6hxY/HLaRF5ZEf7L3lMEGFxEldzP35sqqhYPPKDoVnsn9qwyJD
         lItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fhVOo1Q2InhZ1KbIHyFqLqEG8IVcC3BtHUbMG2zv5Y0=;
        b=kXOo6gSjGJUiUJOCZXRcSf9Od+rutZLcurkisHWjNuLOSH+4cjvSYG4Spc1tcSoZb2
         klqx2dUBogxjI4fb34PIBzWPCOPxr9d17Siu7diop0Wr1wWxE04HBAIzEm6BK8BBKcir
         E91GP7y9+a7kktgAgE0bde6PfoeBI8kEbZUf9fPoSmZXrZ/118pTOXr6NXHoGvhxVJwF
         iGGsF0z7reN3hhVpsqZf87GdbRJWnXVML/sIUDI9oaI9qh1DolYNjfbb/uQ+YMWJ3jTm
         PoGDgLxavyGO2nTsc0T9eitR5U4Qvs29tA5MP0Dq+VdNGo7AH5zu0FtdSZeFmRw/Mc+K
         sjZA==
X-Gm-Message-State: AOAM531iMZZTiDSxcm3QT9C1hExsvYmHUD/+5zg5LhzYahP/v/EotwIo
        F218GyWDAPFD4J04jgkAgRxKyb74m//gVg==
X-Google-Smtp-Source: ABdhPJyNDGGv+q0fBhcbEkkhFerOCaWUQU4/vkQLA5VOl3euOqZtnI4qiB59pXzGdkTRJr6IeofWXA==
X-Received: by 2002:a17:90a:230d:: with SMTP id f13mr7257771pje.116.1597545451480;
        Sat, 15 Aug 2020 19:37:31 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:6299:2df1:e468:6351? ([2605:e000:100e:8c61:6299:2df1:e468:6351])
        by smtp.gmail.com with ESMTPSA id m62sm13294689pje.18.2020.08.15.19.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 19:37:30 -0700 (PDT)
Subject: Re: Consistently reproducible deadlock with simple io_uring program
To:     Drew DeVault <sir@cmpwn.com>, io-uring@vger.kernel.org
References: <C4Y22EC7RW97.3K03685KXYM5S@homura>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <839f2d17-0486-b12d-3540-4a8408902492@kernel.dk>
Date:   Sat, 15 Aug 2020 19:37:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <C4Y22EC7RW97.3K03685KXYM5S@homura>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/20 7:12 PM, Drew DeVault wrote:
> Kernel 5.7.12-arch1-1 x86_64, Arch Linux.
> 
> I'm working on a new implementation of the userspace end of io_uring for
> a new programming language under design. The program is pretty simple:
> it sets up an io_uring with flags set to zero, obtains an SQE, prepares
> it to read 1024 bytes from stdin, and then calls io_uring_enter with
> submit and min_complete both set to 1.
> 
> The code is set up to grab the CQE and interpret the data in the buffer
> after this, but I'm not sure if this side ever gets run in userspace,
> because my kernel immediately locks up after I press enter on the
> controlling terminal to submit some data to stdin.
> 
> I have uploaded a binary which reproduces the problem here:
> 
> https://yukari.sr.ht/io_uring-crashme
> 
> If you want to reproduce it from source, reach out to me out of band; it
> will be a challenge. This new programming langauge is technically GPL'd,
> but it hasn't been released to the public, YMMV getting it set up on
> localhost, and it doesn't generate DWARF symbols so you're going to be
> debugging assembly no matter what.

This should be fixed by this one:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=d4e7cd36a90e38e0276d6ce0c20f5ccef17ec38c

which will go into 5.7/5.8 stable shortly. Affected files are the ones
that use double waitqueues at the same time for polling, which are
mostly just tty...

-- 
Jens Axboe

