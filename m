Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AF32AA6B1
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 17:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgKGQcF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 11:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgKGQcF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 11:32:05 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E53C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 08:32:03 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id s13so4116800wmh.4
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 08:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xGvBJc0Jz/sv1lny7h8vRtKj9iI7Hdt2MKDqAykLbX8=;
        b=qIa0+IZM0KUb2QXfeJrJ12Zo1QsGwyR/CEfScRBv6DPVhG7jWVpT3stU29RN7rEspK
         PXoRNVbihHV5VfjYn7PjSPZLnoQpUL62rXJ91q1x8dkNBcAk08NYv9iiTNmRnXIXi3Pn
         J1dpjb9pKVh7k2cqqtPKo12X3koZrR6eK9Fw4v5y6bS/MBUUBbFXhtifQj7XJHVqGJAb
         f9tbmkRj+A36DSWJmNVYMbbbRWFREzbYCGOca6tSMWzvtmVRDkbR6pCJzQqduy/FaExZ
         X0quYGYR36/2YWOSB08pVAr1V0Q5Wv4vBRxrWuzCI50UrIolCE2yFD3IJBN7LsjrGlOn
         ftrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xGvBJc0Jz/sv1lny7h8vRtKj9iI7Hdt2MKDqAykLbX8=;
        b=l/sBqnhiXMjUu/2YSMbmYBDRWmoMlk/GVVFKNs7D2Kk/wvqME5xQ4PvlVJEThx+uPy
         +1tP6s8p4ww0qxa3vnxpxV0WA0zIP+iK2eraX5H9bFynCJ+9Z5D3BLMyoTiRbXJQyFbh
         9fHGM3/okSCIipgOGF6gRGzOYBLr+UyvLOqW1Yx8ZdEBNmaLpK3ZuA9kXEBjM11oCz01
         q2TTMAGagC7u1vbTAIWsqFYu73896K2w0tJ5E2+aQwQtJ0PC3rYh9KF2DUfTa97SnFDq
         yrfvGZRZs/rJuKtRjrDqGNMW346JgTwK2vmgRC0EJn0xG1pzO9tr34UernPnwTpBGUpO
         Me4A==
X-Gm-Message-State: AOAM532B+u6C38JnPNiF5dqOyIoVz3fjI5KzOXEra7QMzJ78uKhYSKmH
        VKhiYBB9CHilW0A2HkGok5Q=
X-Google-Smtp-Source: ABdhPJzxaYL13S/iqIXzdayErG3PrNnq/yiiy4ZsByR7AcI/eIkdi4ir8I17F78/uexvkV7uCd64qQ==
X-Received: by 2002:a7b:cd92:: with SMTP id y18mr5528741wmj.178.1604766722194;
        Sat, 07 Nov 2020 08:32:02 -0800 (PST)
Received: from [192.168.1.84] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id l16sm6861646wrx.5.2020.11.07.08.32.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 08:32:01 -0800 (PST)
Subject: Re: Using SQPOLL for-5.11/io_uring kernel NULL pointer dereference
To:     Josef <josef.grieb@gmail.com>, io-uring <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     norman@apache.org
References: <CAAss7+pgQN7uPFaLakd+K4yZH6TRcMHELQV0wAA2NUxPpYEL_Q@mail.gmail.com>
 <CAAss7+rt_mkHhGY=kkduDK58jVZy73yZx8qFYEPOU9JjGaCs=g@mail.gmail.com>
 <c5d77fb0-ea86-10a4-5314-42aed9ef5a18@gmail.com>
 <CAAss7+pux3gjusGOsAdRr3Txr+dRRUfxnBrzd2eM2KtN+6-FVw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <69f14eaa-b75d-8f7b-3897-1f47bb2e325b@gmail.com>
Date:   Sat, 7 Nov 2020 16:28:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+pux3gjusGOsAdRr3Txr+dRRUfxnBrzd2eM2KtN+6-FVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/11/2020 14:09, Josef wrote:
>> I haven't got the first email, is it "kernel NULL pointer dereference"
>> as in the subject or just freeze?
> 
> that's weird..probably the size of the attached log file is too big...
> here dmesg log file
> https://gist.github.com/1Jo1/3d0bcefc18f097265f0dc1ef054a87c0

That's much better with the log, thanks! I'll take a look later

> 
>> - did you locate which test hangs it? If so what it uses? e.g. SQPOLL
>> sharing, IOPOLL., etc.
> 
> yes, it uses SQPOLL, without sharing, IPOLL is not enabled, and Async
> Flag is enabled
> 
>> - is it send/recvmsg, send/recv you use? any other?
> 
> no the tests which occurs the error use these operations: OP_READ,
> OP_WRITE, OP_POLL_ADD, OP_POLL_REMOVE, OP_CLOSE, OP_ACCEPT, OP_TIMEOUT
> (OP_READ, OP_WRITE and OP_CLOSE async flag is enabled)
> 
>> - does this happen often?
> 
> yeah quite often
> 
>> - you may try `funcgraph __io_sq_thread -H` or even with `io_sq_thread`
>> (funcgraph is from bpftools). Or catch that with some other tools.
> 
> I'm not quite familiar with these tools( kernel debugging in general)
> I'll take a look tomorrow

-- 
Pavel Begunkov
