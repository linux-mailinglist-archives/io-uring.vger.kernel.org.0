Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC963FA00D
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 21:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhH0TgX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 15:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhH0TgW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 15:36:22 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D41BC061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 12:35:33 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v10so12038368wrd.4
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 12:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=URUiQ+Q5c0GhxOsXgJsjAF/ktTLb15XxeVpjne4jfKY=;
        b=j5hu/AMxeCCYj5KIjLqtFrY/utm92ev2zsdKpQvjWtTv6px0vmvY2Q/80sxH6TIcy2
         CA7GAmh2HJv/vNnX2apFDitGiG7GSnsWwoEyS5koHv+xYm7eIHUDtP+A2yYG2MpmY6N0
         5mQLo+5T0aCXIBxTu5+J43Qsu0ijIZuwUdvZw2srj2bPZqu+hYCWn790yqWKlmBsKW8d
         DT+MbaiQARUvpN3eyKalHBJww8eN8fcEN7RnCMHC7H/O59lEGkCFDE1YX1qEeyjFo5Fv
         GvFPMpwl5Bj4Locy24GsG4P/N6rWsrRv26O8Kd4MGdUFW2M1ck4qt/lY++ELD5YP8lwu
         iNRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=URUiQ+Q5c0GhxOsXgJsjAF/ktTLb15XxeVpjne4jfKY=;
        b=NiR9vG8Tb8sfq6eVVobATU6Rwro/M+RjkJeFLto1ePP49AOx2hCyQ0hoZn8iavgUIo
         MrhecFFtsh1oGVwr6nKYVXVtULXtGIfIRfagcTcIGbl6i4t13qi+2iCkIXU4whs1+TAt
         Hn7m8zgRS8u1X0Iydp89DB8aAp31+AhNdmJKbDCfHSQj6H+MzziJL/kvUsD0beRa7+7A
         1kh0rc/qgUkv+3TGWGZgaXYCs/GAAScjE+b7d6nzk0NtPDNuuMGhuIXg/2C3uZHtqPTE
         /aY/V50Wkwp+dTP9DcISMnO3J3I0ow6zuCAEmKyzsbruoqSJXpBvEyRW2a7ytOzg9+2z
         s9lg==
X-Gm-Message-State: AOAM532a4sgruc5dSAj07/A4OmaeotpL/ksBv+lEibiFeDVzKKC1CrdP
        MH/qPyKWAm8ivHlgK6SV6VdbiyQ98ZA=
X-Google-Smtp-Source: ABdhPJyuDyNc1VQyyKAVsNp+VNIVWnjqmLDZFoQ7KKzvOMwvbej7knEifENAdMle1BUp8ZNHDVl/6g==
X-Received: by 2002:a5d:4d8c:: with SMTP id b12mr11979785wru.232.1630092931791;
        Fri, 27 Aug 2021 12:35:31 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.94])
        by smtp.gmail.com with ESMTPSA id o5sm7092923wrw.17.2021.08.27.12.35.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 12:35:31 -0700 (PDT)
Subject: Re: [PATCH liburing] register: add tagging and buf update helpers
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <f4f19901c6f925e103dea32be252763ba8a4d2d3.1630089830.git.asml.silence@gmail.com>
 <7c95d8a0-7449-ce1e-4c7b-c6fb8537d61f@kernel.dk>
 <652de562-c9ac-3a03-fdd1-e91751eb1997@gmail.com>
 <52832dbf-1c55-db0e-4521-198ec6443fe7@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <45ba112f-feb0-6b35-2daa-97ff768415ab@gmail.com>
Date:   Fri, 27 Aug 2021 20:35:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <52832dbf-1c55-db0e-4521-198ec6443fe7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/21 8:14 PM, Jens Axboe wrote:
> On 8/27/21 12:51 PM, Pavel Begunkov wrote:
>> On 8/27/21 7:48 PM, Jens Axboe wrote:
>>> On 8/27/21 12:46 PM, Pavel Begunkov wrote:
>>>> Add heplers for rsrc (buffers, files) updates and registration with
>>>> tags.
>>>
>>> Excellent! They should go into src/liburing.map too though. 
>>
>> Hmm, indeed
>>
>> Should it be LIBURING_2.2 or LIBURING_2.1 ?
> 
> It should go into the 2.1 section, as it'll be part of 2.1 release.
> Any symbols added after 2.1 has been tagged would go into a 2.2
> section.

Good, sent it out

-- 
Pavel Begunkov
