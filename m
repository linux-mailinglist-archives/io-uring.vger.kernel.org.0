Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA41339919
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 22:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbhCLVbs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 16:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbhCLVbY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 16:31:24 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB32C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:31:23 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id t37so5893241pga.11
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O28SrWxFoKuT+W8E0Bqi2pxmRgQgeT6wV86Murma5d8=;
        b=XLWHVYdgsxc8SX+b7SVgTuijmRFGe387AAc68g28G60jTR2WMSCHlAATbKxn5RI1FY
         Zq35BW1/j/QEeLrPK1sGs/f9V9Rj7avlJj8VRXkkU/J0PHl+Fdciv+gJIxXOG396OUE9
         szU7lEkVEg1MPjnmHdGQ/ymx4nF7fE1+oywY5x22fa4CibcLyGcBt/RGKeIGcMFd7sEe
         ekvDjSZcSIY/bsZ6eyadmsc8uU4Ofh0n2PcfEPtv7VrTVo6uZWOhhcbsIUhISuc2IIVn
         4ucM276FQsdcsUAIb0UO+73YuZxfgJWPegc3vx2J5Nj41NvNq2IjGhAn+k1T9nHW1bJT
         Bcag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O28SrWxFoKuT+W8E0Bqi2pxmRgQgeT6wV86Murma5d8=;
        b=oFmc3PFmDCwFmmGvomYDq6fKM+oKc4B3hWoYudK8fVNjwJkfXJQlKHn8VnGyl/xsLi
         gey8PC5oB2Vso5CfmYZzhFnYo4YIsxoK4p9w+CQHkQC/ZtolQoNzRDS1hV8RffimA2KL
         rhn5kpV143TAq9IjnG08//rxNUZCJXS3elv4zR56XgZc9koy04kW30NgU0Om9NpszmXD
         8P+/21immdbgLVpJn8VoXB/mTW4Ke+vQuG0tuRRi6O/0TocUm8/XQ89m/Enp3O4wQP+U
         QR6LvRlMm+E6VtXoY6TJeGK4Pk1KDfE3/s3FmHlAa86A2n25JL/oDeSoLeyIW5ZTNYL0
         oDHA==
X-Gm-Message-State: AOAM533at8x7K4bByQYw1lof26+mbjlxvTgRUYMsrFq0kmr60ARAtrx0
        64zeI9hD2u4eRIFbJHg/7JNV9hdUPAZDmw==
X-Google-Smtp-Source: ABdhPJzT+iBMcPshD3FbOHrhFBAI5OPCckt/kOx9Yz6R42v6hHs2EQgiKS1IG9mALnlt9emr3VKpng==
X-Received: by 2002:a63:6642:: with SMTP id a63mr13285896pgc.333.1615584682514;
        Fri, 12 Mar 2021 13:31:22 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 9sm6157075pgy.79.2021.03.12.13.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 13:31:22 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk>
 <CAHk-=wjpS-kwozJQFNBestco=q5j3bcfXpVXc6uz=9_mmQ7oYg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <647a0f56-3dd5-2eeb-8d57-2180f2ab1bca@kernel.dk>
Date:   Fri, 12 Mar 2021 14:31:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjpS-kwozJQFNBestco=q5j3bcfXpVXc6uz=9_mmQ7oYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/21 2:17 PM, Linus Torvalds wrote:
> On Fri, Mar 12, 2021 at 11:48 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> - Make IO threads unfreezable by default, on account of a bug report
>>   that had them spinning on resume. Honestly not quite sure why thawing
>>   leaves us with a perpetual signal pending (causing the spin), but for
>>   now make them unfreezable like there were in 5.11 and prior.
> 
> That "not quite sure" doesn't exactly give my the warm and fuzzies,
> but not being new is ok, I guess. But I'd really like you to try to
> figure out what is actually going on.

Oh I agree, which is why I wanted to bring it up as I do feel like we're
just working around this issue.

> I'm _guessing_ it's just that now those threads are user threads, and
> then the freezing logic expects them to freeze/thaw using a signal
> machinery or something like that. And that doesn't work when there is
> no signal handling for those threads.
> 
> But it would be good to _know_.

That's very much my guess too, since the symptom is that we loop all
the time because we think there's a signal pending. I am investigating
it and reached out to Rafael to try and figure this out, but at the same
time I did not want to have an -rc3 that caused resume issues for users.
Hence the "let's just disable freezing for now so that things work, get
it fixed for real when we can" kind of solution.

-- 
Jens Axboe

