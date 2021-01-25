Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26C6302867
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 18:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbhAYRFB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 12:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728589AbhAYRE4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 12:04:56 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF92C06174A
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 09:04:13 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id q2so5257315plk.4
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 09:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mPdMkRBLb/5dfEsFw461WVjsm7UMMnTc9u26CZ29Kjk=;
        b=zatq4+uhFxhCg6jPKZ1FSpjrvv715beXtpmcSLom3j1szec3bFk8g2j4P1sWe8uw1e
         mVljjUnloBgwo8rUgANXSy9MR/PUiZenoggEL3ScVKakNug0raRTJKgUHGiLn782EHkZ
         ZEuMwQFcWEbJuDsf8PAQvtNfaF6PjJf9hE5sq5NBrPdZuGjItWHXH5wu9eYsVKGGkJ0O
         VwFXHZkX7q/zh+F77aGAQ9x5CB2SXrhbjd/yRHEM3q74KqMKL7blsw6tDts/0Pgx8fda
         tJ9OKpq1DzXScMu85iqG4khuj0ehgDllXj2w7w9bJ0aJkfJCWXR6bV6Jr+lexw2aGFEj
         z1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mPdMkRBLb/5dfEsFw461WVjsm7UMMnTc9u26CZ29Kjk=;
        b=ZH493M5f7O22Sd2YpoIEKIpBSVaI9VGPgfVl4QrucHhedAhSfmX20bDXCTP2Qayb/Q
         /t9icRg1Wz/cnpvNlGM2H2Gp7HazWT2dUzKXX6vvcdfk6E4enDNJ5riw0QwKOEdi7LPe
         uZofb7k79D5a4etsgkaaTbVSgWi5ZVWpmHh35BkeultUl3Ma0Hl7rd2SG/Kvh+KbBhhn
         AjKGl7UinvDDMjGbGuutOzp+m6759LPBlfeytuIOZjBD8cpejzSpJh56cSfOiNXcmmND
         wWMctTxD2Sr7NRZ9bsMBCtn1hDfwv9lQ9oFM06miUjZO3ZKJvHoGQlfQQjy7KMgNeKlT
         QJsw==
X-Gm-Message-State: AOAM531vF4RtoZ9AyqbKeRxzQsizjaNjjGYW4ZlTTeNWP3ZcKAfHyLrH
        xdoNRP78SvnHrXva7aSgH24vMEY+fQPiWQ==
X-Google-Smtp-Source: ABdhPJx6i1m7nMpgtCXpzgoWXOlQaER1bh0HQty5EUwj5tqRrfuf1MgR0SHXqEyl9k5DUuFRHgY/EA==
X-Received: by 2002:a17:90a:ae12:: with SMTP id t18mr1225396pjq.92.1611594252707;
        Mon, 25 Jan 2021 09:04:12 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id gl6sm19386787pjb.3.2021.01.25.09.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 09:04:11 -0800 (PST)
Subject: Re: [PATCH 0/8] second part of 5.12 patches
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1611573970.git.asml.silence@gmail.com>
 <f10dc4a5-9b2c-da65-bb62-00352aff3926@kernel.dk>
 <5b3cfdda-b16c-5dca-da9a-1c034571f91f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <add73cdc-34f2-b5cb-2e64-ad48808e170b@kernel.dk>
Date:   Mon, 25 Jan 2021 10:04:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5b3cfdda-b16c-5dca-da9a-1c034571f91f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/25/21 9:56 AM, Pavel Begunkov wrote:
> On 25/01/2021 16:08, Jens Axboe wrote:
>> On 1/25/21 4:42 AM, Pavel Begunkov wrote:
>>
>> Applied 1-2 for now. Maybe the context state is workable for the
>> state, if the numbers are looking this good. I'll try and run
>> it here too and see what I find.
> 
> I believe I've seen it jumping from ~9.5M to 14M with turbo boost
> and not so strict environment, but this claim is not very reliable.

Would be nice to see some numbers using eg a network echo bench,
or storage that actually does IO. Even null_blk is better than just
a nop benchmark, even if that one is nice to use as well. But better
as a complement than the main thing.

-- 
Jens Axboe

