Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8723948871E
	for <lists+io-uring@lfdr.de>; Sun,  9 Jan 2022 01:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbiAIA6D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Jan 2022 19:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbiAIA6D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Jan 2022 19:58:03 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B72C06173F;
        Sat,  8 Jan 2022 16:58:03 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id k30so1608937wrd.9;
        Sat, 08 Jan 2022 16:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=aEpu3o18b3C+mPQjgIJSZna8gX09G1civRUAdCthvY8=;
        b=MMUp06bThKCsrELvgNFXBuaxlTutT5d7THW8qjnHcG/Kh9kGDyVHSF7Va6NGxFqFys
         tJ+GYgcB4jN8DXBMPxaib9avJtZu52/vE57YVLHb10LpKVXkIqAj4gf9J5qg4C+VScxQ
         Ct13H91nDu61OiWwwMZGjP1kiW7vuuvQQsSXtdlhgF5zey9jgIo/Q40/ag9pTBo742eT
         bkr6aiZYXpQCBBYVpErkt20GKyAJ0a1ny5jJcySrfMXPTLAyqOUpl+T0p2OlOaLR4Nt5
         OL2wvJ0YNzzkEdwYbpXTzeRIKHO/NPGpW7mZCSRy9gvrn3rAALlx6MG3jPyRk2XO/vIW
         BxlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=aEpu3o18b3C+mPQjgIJSZna8gX09G1civRUAdCthvY8=;
        b=Jk+hwF8eeZqXfEbJxWBrH8xxLPhW5eKGe6e+DNol4ajsjC3OzcsromO1ZHupvezWI2
         wrtvdYvNTwXevXuzSWTMt+aAG6s8TcTyyjjr8sdXuYEfauxeG3aY+v+Y+4VJsCsxpQcD
         XPnkjaFmDGiGvIU64v7Y9tDIcLOgQ+xBPXbEr98nJjEfYTvZrw0kZmzBLnahdrpFFX5u
         8iPEDcw5b0y27OelIgAVCdMvaE03Bk7pN/tyqBseDPmLoy5uxRRCqxgNw0FStywGI9+X
         yY3bwvipZHjmfT7l0ixKIb8ElpO1xkJIVcWnxjq5ux0cFVEjmELhjRXfr4fDPbBVx4IN
         wgcA==
X-Gm-Message-State: AOAM531G6wQ5obdDSX59q1a/JgjIXmJJrDzqlkHIH8ODsWtI+KZZj2H/
        bcNVpJ5n/3YDRO6CYwD6yK3Tn+0wu4w=
X-Google-Smtp-Source: ABdhPJxkjaZnfUetLtNYPS20H2eVunOsEDTlWwg8W62dTL6nAFqpA5hThJJra2ux/pAeUzwGCwHxLg==
X-Received: by 2002:a05:6000:1aca:: with SMTP id i10mr58901930wry.453.1641689880787;
        Sat, 08 Jan 2022 16:58:00 -0800 (PST)
Received: from [192.168.8.197] ([185.69.144.215])
        by smtp.gmail.com with ESMTPSA id n12sm3124335wrf.29.2022.01.08.16.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Jan 2022 16:58:00 -0800 (PST)
Message-ID: <5f2be3fe-7a16-6559-7d40-575c6e29e443@gmail.com>
Date:   Sun, 9 Jan 2022 00:57:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: Observation of a memory leak with commit e98e49b2bbf7 ("io_uring:
 extend task put optimisations")
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <CAKXUXMzHUi3q4K-OpiBKyMAsQ2K=FOsVzULC76v05nCUKNCA+Q@mail.gmail.com>
 <e8f2a002-4364-18e4-41a4-228cd364feef@gmail.com>
In-Reply-To: <e8f2a002-4364-18e4-41a4-228cd364feef@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/7/22 16:22, Pavel Begunkov wrote:
> On 1/7/22 15:00, Lukas Bulwahn wrote:
>> Dear Pavel, dear Jens,
>>
>> In our syzkaller instance running on linux-next,
>> https://elisa-builder-00.iol.unh.edu/syzkaller-next/, we have been
>> observing a memory leak in copy_process for quite some time.
>>
>> It is reproducible on v5.15-rc1, v5.15, v5.16-rc8 and next-20220106:
>>
>> https://elisa-builder-00.iol.unh.edu/syzkaller-next/crash?id=1169da08a3e72457301987b70bcce62f0f49bdbb
>>
>> So, it is in mainline, was released and has not been fixed in linux-next yet.
>>
>> As syzkaller also provides a reproducer, we bisected this memory leak
>> to be introduced with commit e98e49b2bbf7 ("io_uring: extend task put
>> optimisations").
>>
>> Could you please have a look how your commit introduces this memory
>> leak? We will gladly support testing your fix in case help is needed.
> 
> Thanks for letting know
> I think I know what it is, will get back later.

https://lore.kernel.org/io-uring/69f226b35fbdb996ab799a8bbc1c06bf634ccec1.1641688805.git.asml.silence@gmail.com

Should fix it, tested with the repro

-- 
Pavel Begunkov
