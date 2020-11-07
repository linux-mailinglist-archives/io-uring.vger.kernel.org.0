Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C6B2AA4EB
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 13:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgKGMNd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 07:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbgKGMNa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 07:13:30 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEC6C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 04:13:29 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 10so3130413wml.2
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 04:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BWVOQStIp2X2ztvUAFp9d6IljgwwIasCV64dUZTDPtA=;
        b=srZzL8pn86S+IblwibSIlYR7R3+6zDEOUChmpo+9PlAbpivloWSG8XkOcN2rlPBPiJ
         Ms/kOBmDS+ns6DJaeUQi+U78YX0MLc5O6CO6xK6SL8wObcBOas+qUveXu/ollJgVZmzL
         EWDvAsZ2mVwTCiToFMO10RkJUcOwi3aefSuA39sB5jXDgW6vxi/7JgGxAl25z8r7IJqS
         avM5L7SpdzqosQXbqqElQXCXSnZIWz7oygcDnfm8I8TIwF8XaC8hlc4cxOqFVthsfh55
         QkjM3ABYcGabipf7OrpQbYWEIEghSbSj3JFStXBHS1WpZHsihkdzRVxdKQ6pON/fM6DH
         LwTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BWVOQStIp2X2ztvUAFp9d6IljgwwIasCV64dUZTDPtA=;
        b=TSPuOaiSNgqHjizVlhjzEOtV6bl9foTY6F4MMgBnmDHWxswk/DgOswah1gvWGg9Ec1
         FaevykTinUuXrQ7xMlWLreUIGVnt0HR//xZuz21cfi6dkqEyqTyrhznfbPdsTm//Y8Iw
         QucUeUZbDBaf/tD5mABW31BvdC4eJb13isRgVPEhfK7gbSR06yCIVzVqHBXSLUibY0lV
         HDqeq4klqzuP8tCaG8HAsQWxsXPNykyUlNE1EJ4mXm1MNCpCZWoaLR38eH3mkfKHHCht
         7aDknqONNxFHXm35JCRmoOm6s1SSYwPqUMcO0TnegnJaepOOH6FtZTS60qjmu8UNrETa
         s/ZA==
X-Gm-Message-State: AOAM531C3ee7KG/wV3i4HVHOIemXYgMjf2T5N2X85VVGxV/OV/FVZVID
        SFhFvi+ecOjjj8BO4B6qTh8=
X-Google-Smtp-Source: ABdhPJx9nZlwZ4FdPrPYmPB9eiMFDy9wpKyluF5sHspNFTXftFyfyTC0f5vsRT5zbFrL50o0GNUzlA==
X-Received: by 2002:a1c:f606:: with SMTP id w6mr4380730wmc.136.1604751208386;
        Sat, 07 Nov 2020 04:13:28 -0800 (PST)
Received: from [192.168.1.139] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id i11sm6087941wro.85.2020.11.07.04.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 04:13:27 -0800 (PST)
To:     Josef <josef.grieb@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>
Cc:     norman@apache.org
References: <CAAss7+pgQN7uPFaLakd+K4yZH6TRcMHELQV0wAA2NUxPpYEL_Q@mail.gmail.com>
 <CAAss7+rt_mkHhGY=kkduDK58jVZy73yZx8qFYEPOU9JjGaCs=g@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Using SQPOLL for-5.11/io_uring kernel NULL pointer dereference
Message-ID: <c5d77fb0-ea86-10a4-5314-42aed9ef5a18@gmail.com>
Date:   Sat, 7 Nov 2020 12:10:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+rt_mkHhGY=kkduDK58jVZy73yZx8qFYEPOU9JjGaCs=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/11/2020 00:51, Josef wrote:
> On Sat, 7 Nov 2020 at 01:45, Josef <josef.grieb@gmail.com> wrote:
>> I came across some strange behaviour in some netty-io_uring tests when
>> using SQPOLL which seems like a bug to me, however I don't know how to
>> reproduce it, as the error occurs randomly which leads to a kernel
>> "freeze",  I spend all day trying to figure out how to reproduce this
>> error...any idea what the cause is?
>>
>> branch: for-5.11/io_uring
>> last commit 34f98f655639b32f28c30c27dbbea57f8c304d9c
>>
>> (please don't waste your time as I'll take a look on the weekend)
>>
> I forgot to mention that same cores are running at 100% cpu usage,
> when error occurs

I haven't got the first email, is it "kernel NULL pointer dereference"
as in the subject or just freeze?

also
- anything in dmesg? (>5 min after freeze)
- did you locate which test hangs it? If so what it uses? e.g. SQPOLL
sharing, IOPOLL., etc.
- is it send/recvmsg, send/recv you use? any other?
- does this happen often?
- you may try `funcgraph __io_sq_thread -H` or even with `io_sq_thread`
(funcgraph is from bpftools). Or catch that with some other tools.

-- 
Pavel Begunkov
