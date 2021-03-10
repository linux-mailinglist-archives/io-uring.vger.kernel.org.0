Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07B833330D
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 03:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhCJCTM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 21:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbhCJCSh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 21:18:37 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F25C06174A
        for <io-uring@vger.kernel.org>; Tue,  9 Mar 2021 18:18:26 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so6362553pjh.1
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 18:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RrPzKgExLakSNfglFinl/rLo5PZVVt54ykNip4IxOYo=;
        b=Z/uUQSqxocqOZX8J7RHcXC56RqQamTlEYNS62KbiW6twgpjFZ544/kkdonfB5nTB3N
         oz8qETeZ5ObLlpqxhJb4ih0OzVOJXFHltqVyTDDQRinuAeRpzccXp21uzeEJryERBWhZ
         1pG524zmUGIcgwwQ1K6sOy6IXWY7XO86UXDwgWzWd1/x08k/Spb+wXfWmiDJ+YL/A776
         HKzSyURiuO04qlsWTNaNBy8JdJvAkhl+O3F3zhM6Ph8l9EA6aqfKL5Mpro0a8iDgFfeA
         wHZ20pkzVOedRHswZx449PIAQvTSUOfsuo7J5DPIjK1HV7Uc9yO4k36W96Tf6/EMeozV
         SUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RrPzKgExLakSNfglFinl/rLo5PZVVt54ykNip4IxOYo=;
        b=GRdysahtD2DQCLmctv1Qc0VMf/DA9YONBkkiFrrIoWI8+V/UkSNO9BzbcawWQhsFOO
         pHNNNwUW/iHtFlOGEcLYXkTK0liUNI3uaPmm7/rVY23m0qlnjyaj6J1DUf1HNeeRMnJa
         LZm539BGxk9/90V8cGntbLLdfNbp5grMVWbk8IUrET3LCncGFmx1p3Ao+J1puyyn0RkI
         1RSh8HimmH4OIC/aipGYJnrA+09o5XO0JY7n+DkxCzFprbSdBpz3Wzv3IBtuNBLsp1HB
         UQ6L6rPKeRkjN+lAxcGI/WJkAU0inUml3mTyjLdUgTct+ciNwb/mopyKeN5+pGnyTRrF
         Wljw==
X-Gm-Message-State: AOAM532hG4vttBbqB/uKmdLnJF9MeoTiB+haPI188VaOepvFdd1XxRNt
        G1PxoRrViiwrV7MoL2r4feBKxWT6IfjbsA==
X-Google-Smtp-Source: ABdhPJyWu/sQQK+wQ4rlIGXbSdQalPOWx0Cxcqzh5Obvk3cZkLsdZNCGPjfLt1dhW7o1G8pfVcMouQ==
X-Received: by 2002:a17:902:b18c:b029:e4:4cfd:1f7d with SMTP id s12-20020a170902b18cb02900e44cfd1f7dmr946005plr.84.1615342706104;
        Tue, 09 Mar 2021 18:18:26 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d124sm14698761pfa.149.2021.03.09.18.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 18:18:25 -0800 (PST)
Subject: Re: [v5.12-rc2 regression] io_uring: high CPU use after
 suspend-to-ram
To:     Kevin Locke <kevin@kevinlocke.name>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YEgnIp43/6kFn8GL@kevinlocke.name>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <44808ad3-e4f7-8a05-9c52-a1224bf6c534@kernel.dk>
Date:   Tue, 9 Mar 2021 19:18:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YEgnIp43/6kFn8GL@kevinlocke.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/21 6:55 PM, Kevin Locke wrote:
> With kernel 5.12-rc2 (and torvalds/master 144c79ef3353), if mpd is
> playing or paused when my system is suspended-to-ram, when the system is
> resumed mpd will consume ~200% CPU until killed.  It continues to
> produce audio and respond to pause/play commands, which do not affect
> CPU usage.  This occurs with either pulse (to PulseAudio or
> PipeWire-as-PulseAudio) or alsa audio_output.
> 
> The issue appears to have been introduced by a combination of two
> commits: 3bfe6106693b caused freeze on suspend-to-ram when mpd is paused
> or playing.  e4b4a13f4941 fixed suspend-to-ram, but introduced the high
> CPU on resume.
> 
> I attempted to further diagnose using `perf record -p $(pidof mpd)`.
> Running for about a minute after resume shows ~280 MMAP2 events and
> almost nothing else.  I'm not sure what to make of that or how to
> further investigate.
> 
> Let me know if there's anything else I can do to help diagnose/test.

Thanks for the report, let me take a look and try and reproduce (and
fix) it. I'll let you know if I fail in reproducing and need your
help in testing a fix!

-- 
Jens Axboe

