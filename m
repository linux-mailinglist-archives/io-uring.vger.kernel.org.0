Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D9B326EC5
	for <lists+io-uring@lfdr.de>; Sat, 27 Feb 2021 20:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhB0Ts1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Feb 2021 14:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhB0TsZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Feb 2021 14:48:25 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675C1C06174A
        for <io-uring@vger.kernel.org>; Sat, 27 Feb 2021 11:47:45 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id h4so8383681pgf.13
        for <io-uring@vger.kernel.org>; Sat, 27 Feb 2021 11:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QCOA7C2LdKfUUC8PfSUi5rd1JRD1+NkvDJpFnIDOryI=;
        b=n9szUDdI07u5dmu9zWtfzZ0v2TX6otdGctHMBX8JfTUV/+IxQRP6dgFdl0uCGj0iC3
         Nk3njBA0mqi83GcnV57UFl5mL1U9mO/3xZPFgxkp1+iNAaVVQs7i7QNUOznZOQQn2k1+
         AZGtxWCUDXEjxf7X009n1UPTPoxI1Q+LKeq4p7A4Uq3smDbayWcYFiYnibq5Dr1ytkLC
         uhV4R+b9f9lj253spC5V6jRUgppLXdxxbPbFKtPFVFNTVEQ2HX4oj06pD0tlKeq+Ls2I
         Zy5oQ4QAtP2mc1BpFmfJ8Q3bV5SeTIlppW2xc5EZ/h+JwDSsrGkRbGUZPVkzuui5FI5W
         6a2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QCOA7C2LdKfUUC8PfSUi5rd1JRD1+NkvDJpFnIDOryI=;
        b=Cb7S+x9ENASrTU7b67pBUsuSmzJHZlw832B0fX3CpwvWYsJlxxcQhy+DkDy1X4jvsY
         PQ44GioDp9tXpe0+elm0hSCOcEobao6+wE/7pHHxh22I0q+tIxOHAouWrEEFrDnoShL9
         OfWQvx6gRtk302VqfSTpMEKAf1QezqacOezc9cxYy6NVaGCAHmclT6l4n4GeFN/r4GTu
         kj9tOjQQbBT3wbj9J3iNZ9S8LJEjBEroYHvA1zjefWSDaBTHPOiUDs3GtE3xZgkXDX2s
         yhOoVk++i2Hu7tnktOkM1HPPJcLyYAyoPPj48n/yyL10NlNJ+WqdkvPnwmul/4gVjnwL
         WDgQ==
X-Gm-Message-State: AOAM532TO47jVP0wHNY9rniJPgSMG9bky5j3cg+o/iuoU/Bn8fAYwrB3
        LP5gYsclqo/2Z4TBsG1J8Al3lxSPLS56lg==
X-Google-Smtp-Source: ABdhPJwizEw2Xj6gaBH7Ts2/X/4GhBV6l2919MwpxrFPs9Y5ZLVLt1LZcsaeR/7mAF0uLUwpCXveDg==
X-Received: by 2002:a63:9d42:: with SMTP id i63mr7659873pgd.414.1614455264172;
        Sat, 27 Feb 2021 11:47:44 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id na8sm5734436pjb.2.2021.02.27.11.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Feb 2021 11:47:43 -0800 (PST)
Subject: Re: [GIT PULL] io_uring thread worker change
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
 <CAHk-=wi6=LQ1MAJ3Z9jyT90mos_8GhYCEMQtDrJ7CZ_FxuK3Rg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6e22e9be-bfca-eab7-d9bd-a1ef79de2dc0@kernel.dk>
Date:   Sat, 27 Feb 2021 12:47:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wi6=LQ1MAJ3Z9jyT90mos_8GhYCEMQtDrJ7CZ_FxuK3Rg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/27/21 9:38 AM, Linus Torvalds wrote:
> On Fri, Feb 26, 2021 at 2:04 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>   git://git.kernel.dk/linux-block.git tags/io_uring-worker.v3-2021-02-25
> 
> Ok, I've pulled it, because it's clearly the right thing to do. It
> would have been nicer had it been ready earlier in the merge window,
> but delaying it will only make things worse, I suspect.

Oh I agree, in fact I would've loved to have done this releases
earlier... But better late than never. Thanks!

-- 
Jens Axboe

