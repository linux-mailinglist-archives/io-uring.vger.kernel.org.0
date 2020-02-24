Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236B916AD71
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgBXRaZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:30:25 -0500
Received: from mail-io1-f42.google.com ([209.85.166.42]:39564 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbgBXRaZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:30:25 -0500
Received: by mail-io1-f42.google.com with SMTP id c16so11083757ioh.6
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gwHy3HWowIgtedbSZEx3NLWMjUbhgcwff7VI01htL3s=;
        b=B5dXRYxK/5lwfMLgmzVp+5BK/FeA+dQ+bq6MgKZ8O7cmu4vPTlI3TUBoHNHDUNnzLX
         XHMhIT3ZyQwNS1vLXBERuuoktpV+OF4nAnAErABdlbtHtIvXVh2yz+EmvQZmhydwSCRw
         PNk5meG7XcRqjEi9Zo3vXcz2lnjZWawLV4myrbeJuiFBxZQtn9AA6TDq+qX5eZCCbQL9
         FrbLuC0ZRvB+7QLXKRSZXSx894fB5x4nR4AcD9Vj2dusAyWVviDGlSyUUtzvHCpV0PZY
         7Krr87brMQcq2YGaq8weds8kFY4Sud3a8u6nkJSGqdIvhIyCnYZ8Rw8vGREu9OX+IASv
         SPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gwHy3HWowIgtedbSZEx3NLWMjUbhgcwff7VI01htL3s=;
        b=uaRErM/zf+hepiohMQUYzJ9SVK30bg1UK8sjWoO/ldkGp42Wxw6aat/ZTuAE95Y5Ic
         4JFW8YaU1SCTnovNiBOQdO70nVJ/W7+ixw/uQxmkh50SPM+D5sUOQDv0U35wDjDfwlGM
         QNbHvBE3Dkk34/l0p0uaRlh59DgGljhOU12NNzpQVwha7TqE1yXORYIWe6it7yliY3Xz
         okOxKE/YQ7870Gdkpu53/orHlkH99xTySZdAQcxVeL3Upd4vnxj30EvWVSXz+7ddSxUD
         mbmHkwDmFu+L3PaNYLpBT6PgynwZBnt1JdbZTjkfBibLhq9W5tiI2eaZSO2lTvLCmgwA
         RsCQ==
X-Gm-Message-State: APjAAAVG8fdx2OVr9G1R4rnsXP3kkIwGKx/L6gvHUIDpTCThkHgcBtH8
        zqyLkthM+XN2t8m0K1GGRARSc3u9GHQ=
X-Google-Smtp-Source: APXvYqyFkMZPjroyroxiHA8qKvLipZyWd5xk4FE7CUh8wpRQopqUbYZ0v9flPJPZkkutSaUqS/C2/A==
X-Received: by 2002:a02:856a:: with SMTP id g97mr51411305jai.97.1582565423595;
        Mon, 24 Feb 2020 09:30:23 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m27sm4500548ilb.53.2020.02.24.09.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 09:30:23 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
From:   Jens Axboe <axboe@kernel.dk>
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <20200224165334.tvz5itodcizpfkmw@alap3.anarazel.de>
 <14eb8dcb-d5ba-9e0a-697d-e4b8fbad3f08@kernel.dk>
Message-ID: <c477a4ca-1576-997d-07b2-1576942db78e@kernel.dk>
Date:   Mon, 24 Feb 2020 10:30:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <14eb8dcb-d5ba-9e0a-697d-e4b8fbad3f08@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 10:19 AM, Jens Axboe wrote:
> On 2/24/20 9:53 AM, Andres Freund wrote:
>> Hi,
>>
>> On 2020-02-24 08:40:16 -0700, Jens Axboe wrote:
>>> Agree that the first patch looks fine, though I don't quite see why
>>> you want to pass in opcode as a separate argument as it's always
>>> req->opcode. Seeing it separate makes me a bit nervous, thinking that
>>> someone is reading it again from the sqe, or maybe not passing in
>>> the right opcode for the given request. So that seems fragile and it
>>> should go away.
>>
>> Without extracting it into an argument the compiler can't know that
>> io_kiocb->opcode doesn't change between the two switches - and therefore
>> is unable to merge the switches.
>>
>> To my knowledge there's no easy and general way to avoid that in C,
>> unfortunately. const pointers etc aren't generally a workaround, even
>> they were applicable here - due to the potential for other pointers
>> existing, the compiler can't assume values don't change.  With
>> sufficient annotations of pointers with restrict, pure, etc. one can get
>> it there sometimes.
>>
>> Another possibility is having a const copy of the struct on the stack,
>> because then the compiler often is able to deduce that the value
>> changing would be undefined behaviour.
>>
>>
>> I'm not sure that means it's worth going for the separate argument - I
>> was doing that mostly to address your concern about the duplicated
>> switch cost.
> 
> Yeah I get that, but I don't think that's worth the pain. An alternative
> solution might be to make the prep an indirect call, and just pair it
> with some variant of INDIRECT_CALL(). This would be trivial, as the
> arguments should be the same, and each call site knows exactly what
> the function should be.

I guess that won't work, as we'd still need it inside the switch then
and it sort of becomes a pointless exercise at that point...

-- 
Jens Axboe

