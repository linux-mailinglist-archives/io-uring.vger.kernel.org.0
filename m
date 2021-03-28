Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7685F34BEF1
	for <lists+io-uring@lfdr.de>; Sun, 28 Mar 2021 22:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhC1Umj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Mar 2021 16:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbhC1UmU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Mar 2021 16:42:20 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB85CC061756
        for <io-uring@vger.kernel.org>; Sun, 28 Mar 2021 13:42:19 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo5630665wmq.4
        for <io-uring@vger.kernel.org>; Sun, 28 Mar 2021 13:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ncUmqZv5FjdoR3GFLXteAXsfU0eBF0685dwdt1I8t5A=;
        b=eycV5Uv/cjGUIAgdiZyrNvlztjedPMZb2hCtosVKBdWOPp6R3G4RLympTOUWkI6GTY
         5pjiSf84pBZENLR5suilBHBLwJjeIJT0HGXRLNkz1dJhj/5PXDsbmtI5hmlRNL5WNL0S
         B4zYBJ34o5h3I2y1Xw239PYaywMWvkLHLqXCBt6QlOXv1EEqecDzNEAKEbW0fScwmUnY
         RqNm6fGBcUcHdcFdjdwBwYtYKJWxHYWdYMoT8s9cou9cW4P7HlXb3urBUTgPhnAPJKV3
         AlaijrHqeu83lV1BVN13wz5yTYFG0PtZ0HDa6VH4nZORXNonHWzy12k591QwqGLU4EDq
         ZF5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ncUmqZv5FjdoR3GFLXteAXsfU0eBF0685dwdt1I8t5A=;
        b=iDzLHcwkpN+5VqlmTRofpmUdPbvD/RZuJ4lyx+Hz/iLlrvGRyluPS8hn+xJNfnH5IG
         KbjR45/cct38wizA4LndqSlEju3fHG9e7yGcsX1r3P90aKRhf490Yk6dLPQ+d4gMCzb9
         U0rVSqzCPV+Vu0jqEhYGkeyAJdvHkwUYXJ1uCEizUXx/5+6E4Up+qx13HXG2HOw/VCNr
         hF1fAbl9rGDCIiNgJa15UrnKH4NOEiBjixfDn+yuw+w310fr1Oqx3GcfItMntqivdke0
         IASngfvWl0LftiD8KtObyJFgDfxOR3oNCnWmALtTawSteVr4ex/WQRICdgPu03hZ1nBf
         m/pg==
X-Gm-Message-State: AOAM532k/rh/UnAkI1Y3O57xXUjSFZx/lZjCzJEaNuAo4EbNYWxU1lAY
        V8AlxndfM6RWVgAk5fC0ytRnyh9ei/iJDw==
X-Google-Smtp-Source: ABdhPJyFFsx+r/5cUu/6jIXxu5ZpYc9NS2HB4LNx+OsZS5foCuJnnnRliBMYFgnq2Rn00dyMKLKWtw==
X-Received: by 2002:a7b:cd15:: with SMTP id f21mr21554954wmj.43.1616964137621;
        Sun, 28 Mar 2021 13:42:17 -0700 (PDT)
Received: from [192.168.8.108] ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i10sm25825834wrs.11.2021.03.28.13.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Mar 2021 13:42:17 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Colin Ian King <colin.king@canonical.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <aa67d57a-ba51-f443-c0f2-43d455bff25c@kernel.dk>
 <CAHk-=wiHof59ZbJai7M7Xw7RYfm8KszApXztnoTHePke5mZBsA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc5
Message-ID: <d48d4580-0255-4637-3d44-a9984398557e@gmail.com>
Date:   Sun, 28 Mar 2021 21:38:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wiHof59ZbJai7M7Xw7RYfm8KszApXztnoTHePke5mZBsA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 28/03/2021 20:02, Linus Torvalds wrote:
> On Sat, Mar 27, 2021 at 6:02 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> - Fix sign extension issue for IORING_OP_PROVIDE_BUFFERS
> 
> I don't think this fixes anything.
> 
> It may change the sign bit, but as far as I can tell, doesn't actually
> fix anything at all. You're multiplying a 16-bit value with a signed
> 32-bit one. The cast to "unsigned long" makes sure it's done as an
> unsigned multiply, but doesn't change anything funcamental.
> 
>  - "p->len" is an explictly signed type (__s32). Don't ask me why.
> 
>  - the size calculation takes that signed value, turns it into an
> "unsigned long" (which sign-extends it), and then does an unsigned
> multiply of that nonsensical value
> 
>  - that can overflow both in 64-bit and 32-bit (since the 32-bit
> signed value has been made an extremely large "unsigned long"
> 
> So there is absolutely nothing "right" about the typing there. Not
> before, and not after. The whole cast is entirely meaningless, and
> doesn't seem to fix anything. It is basically a random change.
> 
> If you want that calculation to make sense, you need to
> 
>  (a) disallow the insane case of signed "len". Most certainly not
> sign-extend it to a large unsigned value.
> 
>  (b) actually make sure there is no overflow
> 
> because adding a random cast does neither of those things.

Agree, thanks for pointing out. Will get it fixed.


-- 
Pavel Begunkov
