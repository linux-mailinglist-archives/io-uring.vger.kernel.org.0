Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD8131A5D2
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 21:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhBLUK4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 15:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhBLUKz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 15:10:55 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73428C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:10:15 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d2so260996pjs.4
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/mio1khzlbkr7GA+cnueRvG3mmBp0SUfmCF2jz1gs+c=;
        b=PxNFL+8Fcl7tZJJexjEXXbvK6MYjzHas1rjTMlrU3g+Uomluqy5lg+2Vv15ge1BMNn
         THks8v4uRY7oa7VrPsj/FzWA7X4dR8RJguYRCjs5S1EMiGCV7DTbIzS6vGYvZqo1LdqB
         b9HwuIbFroOBlZldzDGMy9SA6AXYKO/ogBpEey3xvQysBtQa5FLzXzwgE+7RfeNb6e8z
         yGdTWJ2FZCAJLFrYHWa8ukefCO9+M8jlaaJX2GRlGTxjPqnaL1es4YQEgwVL8gchpcUm
         /y7c6makxCGDe/gnCnYV9oIqZZInLkcExs5+g7B8chEIgGJHtrL6FTfHtGPkDWF5ik4Y
         TMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/mio1khzlbkr7GA+cnueRvG3mmBp0SUfmCF2jz1gs+c=;
        b=eHklO58zb0V0YyghotKoH2Yppwsw6JtrAbifeU3GuZoRMndXTmb3bGNxJvmHw7vZVm
         U3fJRmMsUOND0EZ74uoZI7wgZmAnp7PkUK+MBJxurHL6ccD+8iOpglm8zLIMiySWQ7qR
         Fs1O8PvWyMdB9h5GgxVAkUJXhuVwnAzGHP5lWaVB7fPLr2Pvxi6oTcFmvlr7dtYFiV/R
         702zrIvpgSL5l87CYyQr19zoEX5UhAiHssaF66wZgJxpHELBEKAkXLlS350VAewssNtd
         +ggy6tp9rVkizyo9QScRDF1eZsLqffcpJpILJjH8g0bOaM8VFYxaIaWjWf0s68vzQbl7
         hGFQ==
X-Gm-Message-State: AOAM532BKNZYGR1w27mh7AAaTtrKZodzR5xpZceqWCOT2358+LoBWx/X
        IMhd2jXpuiKW09NtxtKvn0+Ly5ItaqqB5A==
X-Google-Smtp-Source: ABdhPJzdQUiw12BSYpBIBQKP9u23jYGCnH0HXJ6k/mzqr6D1c3+jHyDCs4EjFqUV8QL1/3nxeAU5Ow==
X-Received: by 2002:a17:90a:4e0b:: with SMTP id n11mr4274352pjh.145.1613160600270;
        Fri, 12 Feb 2021 12:10:00 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21e8::16bf? ([2620:10d:c090:400::5:2056])
        by smtp.gmail.com with ESMTPSA id y3sm8672080pfn.191.2021.02.12.12.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 12:09:59 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fix for 5.11 final
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
 <CAHk-=wicH60LB9sENxT95mE_LY-EPruphMc-wRRXc97KVER2vQ@mail.gmail.com>
 <1b7b68bd-80d4-8be8-cf6d-26df28e334ce@kernel.dk>
 <CAHk-=wjEuDEVBM+3SMStLC8Jh8iaDe4JY5hKg4SRGR5G6HuCtg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0c813cc8-142e-15a4-de6a-ebdcf1f03b13@kernel.dk>
Date:   Fri, 12 Feb 2021 13:09:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjEuDEVBM+3SMStLC8Jh8iaDe4JY5hKg4SRGR5G6HuCtg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/21 1:07 PM, Linus Torvalds wrote:
> On Fri, Feb 12, 2021 at 12:04 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> We end up doing path resolution for certain cases, so having the
>> right fs_struct ends up being paramount. Do you want me to update the
>> commit with a fuller description?
> 
> I've pulled it, but please keep it in mind.

OK thanks, will keep it in mind for future changes.

> What are the "certain cases" that need path resolution for sendmsg?
> I'm assuming AF_UNIX dgram case, but it really would be interesting to
> just document this.

Right, it's exactly the AF_UNIX dgram case. Working on adding some checks
that means we'll catch this sort of thing upfront while testing.

-- 
Jens Axboe

