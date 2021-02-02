Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D11C30CD2C
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 21:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhBBUjN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 15:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhBBUjL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 15:39:11 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500DAC0613ED
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 12:38:31 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 190so3663200wmz.0
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 12:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WGp2j+ROZI/Vzvy0FztA5aKbHFWxz5FvHc3POKx4Se4=;
        b=Xz3R/6/JhOLabEFwrb1ZrbI7eUb4SyKCT//LkrRnWu5Ogt+GVIYm//90fm5Ri3Xc8M
         pnjp5NNq8TDEdDa2N63PBLuyzw2JuvfxS4hHCV2xpXY8W3C3JwUHe7LAry/D93Rcrme4
         0UnoBjb7w3ptwl1iwMCvdHO1nLjDrHZRgfGaC5Hf2Fzl1NRAmKuyPlOP83i+74WnoMcF
         KoEO559ChMA73Lc+nbcR072TQVpLY6QY5Ol2JNz93Lgk3K41fTLQTpwtfYhVpDPDcHUA
         Yx4WGU7qsbuRxKO3b0p9fOfPi6vCMQToHoPtO2QHLn3yCqYo8yNFaPTeofrbfIG7Z6FO
         BgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WGp2j+ROZI/Vzvy0FztA5aKbHFWxz5FvHc3POKx4Se4=;
        b=aToOqdCgFGUMelWdHLpoUHSAWXEt7SVLR79fZ1RPaObjEs6B60d1RkGd0uAzkXukLA
         J3SuMWWKFqIs0g6K+KgcI156NftMOE31srm7287+D+SWZqCYjs00ubLVQ7IS7XxIQEyg
         mraMx7YLympjZuCIkFcvWN4i2rC1t4AloQ4y7CBYTE+n1GHPAHgAjyrUqfuL4nt335Oo
         XvIKbiSrCAYaKYlxHlq5TGE8e7shxP3zuRHpAoB6RSUI5aJJ5pnDJMe89Q8qh9nhYGg9
         FNqvGbCBfGaCLk4SWI78Zu6MKE2kNcuFrOqGFn0zLeAfKb0AcVwrDBcNmrPLxxBEyp01
         PkiA==
X-Gm-Message-State: AOAM5316yBWN1/b4VEWLPpx3WL9ib37mSCX5Po8r7Naj7L6wH4yOpTKo
        YcxlAaUwCVDqMDkYFIZu/99xFCMxdBohDw==
X-Google-Smtp-Source: ABdhPJwydoQoVVnW8l/kboZnL7yaASbYjZBUVf9ho0E5OVIe/pLWDopj32qlsOf8i4U3ykxkzYRa5A==
X-Received: by 2002:a1c:e255:: with SMTP id z82mr5102605wmg.93.1612298309843;
        Tue, 02 Feb 2021 12:38:29 -0800 (PST)
Received: from [192.168.8.171] ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id 23sm3817039wmo.47.2021.02.02.12.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 12:38:29 -0800 (PST)
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com>
 <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
 <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk>
 <CAM1kxwgPW5Up-YqQWdh_cG4jvc5RWsD4UYNWN-jRRbWq5ide5g@mail.gmail.com>
 <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk>
 <8d75bf78-7361-0649-e5a3-1288fea1197f@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <bb75dec2-2700-58ed-065e-a533994d3df7@gmail.com>
Date:   Tue, 2 Feb 2021 20:34:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8d75bf78-7361-0649-e5a3-1288fea1197f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/02/2021 17:41, Pavel Begunkov wrote:
> On 02/02/2021 17:24, Jens Axboe wrote:
>> On 2/2/21 10:10 AM, Victor Stewart wrote:
>>>> Can you send the updated test app?
>>>
>>> https://gist.github.com/victorstewart/98814b65ed702c33480487c05b40eb56
>>>
>>> same link i just updated the same gist
>>
>> And how are you running it?
> 
> with SQPOLL    with    FIXED FLAG -> FAILURE: failed with error = ???
> 	-> io_uring_wait_cqe_timeout() strangely returns -1, (-EPERM??)

Ok, _io_uring_get_cqe() is just screwed twice

TL;DR
we enter into it with submit=0, do an iteration, which decrements it,
then a second iteration passes submit=-1, which is returned back by
the kernel as a result and propagated back from liburing...

-- 
Pavel Begunkov
