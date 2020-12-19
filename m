Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696EB2DF07A
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 17:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgLSQab (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 11:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgLSQab (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 11:30:31 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA66C0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 08:29:51 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id v3so3075363plz.13
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 08:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8kawlziLHntw3Vt6rv4U9cBn9oLG7O1EvcdGAT5L0Vs=;
        b=FH8I0QaY8098NFCYzONkGa/uAloHnu+n87FNajxOU3S5gKsFIMoJMGCdMZk8MXo7gU
         irW1QwGFAaDw5IQf8FdH4SU4QZj0zejG60Or/x7eGVPgoChpASE2LOqWd4VrmcaJ7wxf
         2Fe9p5zQMVGhZZTvVDmxwALHzDJsR8n0jBsEi6qrLwPWRr5KwZFbQuethbRxNIDV2abI
         OjxeahQQTKZGZ28k7qRvpWxQGsxPiGcUJXgbhtcx2hHThc1A0lN5ekLWpLWhf1kxPd2I
         LYIQgGIoK3GsGz4XYmlBwAqkrxoK4TUyH1W9yy08JGEkw80lxDQuJKo5BKgLv5A7+gjW
         o6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8kawlziLHntw3Vt6rv4U9cBn9oLG7O1EvcdGAT5L0Vs=;
        b=gTDIBYZ+lkBSclIhOwaaLM0SULcUSOQg1jTnjvremqBjSzPTLv6ecokgWHbDKpVK/2
         WH0XgMJzhrXQ9vRqU7EdiJodWlSyrrnnm7jwAEA0An7DHopKxuGA435UaMZfiRcvTUY7
         ednk7Pdr1ndqE82nQf1/IAflNK5EJxfORqEVfx5mF6EKe5SIRLxUfowbPNqtD2mzKvLY
         nEf4sMfsZt/N0FoJOFDtAqP8yGbRGF31s9Tm18zyCxUKjrziYKJNCwM5hmsCBBymlnHU
         3qFqarksBBulptPk1K/1/VX83dZ2NACuci0RBuLsfEUbI3LgByM5Xjb5jtSwSIL4LuU2
         q35g==
X-Gm-Message-State: AOAM531+04Hx1G1u3HKuHBdvLb1i6lukOzWy3HPSTN6tbYfW81MSEPbQ
        4PtRLKBrdFFvSlM2jdQmMDwxiQ==
X-Google-Smtp-Source: ABdhPJyDaF/TWp7mQlhgxyADWestBiqyG58HUg5R0C7/wfHBhM1sybK3piCtms+V2+3GvMgOrjiYrA==
X-Received: by 2002:a17:90a:67c5:: with SMTP id g5mr10047051pjm.20.1608395391008;
        Sat, 19 Dec 2020 08:29:51 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g17sm7989819pgg.78.2020.12.19.08.29.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 08:29:50 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
From:   Jens Axboe <axboe@kernel.dk>
To:     Josef <josef.grieb@gmail.com>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Norman Maurer <norman.maurer@googlemail.com>
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <7d263751-e656-8df7-c9eb-09822799ab14@kernel.dk>
 <CAAss7+oi9LFaPpXfdCkEEzFFgcTcvq=Z9Pg7dXwg5i=0cu-5Ug@mail.gmail.com>
 <caca825c-e88c-50a6-09a8-c4ba9d174251@kernel.dk>
 <CAAss7+rwgjo=faKi2O7mUSJTWrLWcOrpyb7AESzaGw+_fWq1xQ@mail.gmail.com>
 <159a8a38-4394-db3b-b7f2-cc26c39caa07@kernel.dk>
Message-ID: <37d4d1fa-a512-c9d0-eaa6-af466adc2a4e@kernel.dk>
Date:   Sat, 19 Dec 2020 09:29:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159a8a38-4394-db3b-b7f2-cc26c39caa07@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/19/20 9:13 AM, Jens Axboe wrote:
> On 12/18/20 7:49 PM, Josef wrote:
>>> I'm happy to run _any_ reproducer, so please do let us know if you
>>> manage to find something that I can run with netty. As long as it
>>> includes instructions for exactly how to run it :-)
>>
>> cool :)  I just created a repo for that:
>> https://github.com/1Jo1/netty-io_uring-kernel-debugging.git
>>
>> - install jdk 1.8
>> - to run netty: ./mvnw compile exec:java
>> -Dexec.mainClass="uring.netty.example.EchoUringServer"
>> - to run the echo test: cargo run --release -- --address
>> "127.0.0.1:2022" --number 200 --duration 20 --length 300
>> (https://github.com/haraldh/rust_echo_bench.git)
>> - process kill -9
>>
>> async flag is enabled and these operation are used: OP_READ,
>> OP_WRITE, OP_POLL_ADD, OP_CLOSE, OP_ACCEPT
>>
>> (btw you can change the port in EchoUringServer.java)
> 
> This is great! Not sure this is the same issue, but what I see here is
> that we have leftover workers when the test is killed. This means the
> rings aren't gone, and the memory isn't freed (and unaccounted), which
> would ultimately lead to problems of course, similar to just an
> accounting bug or race.
> 
> The above _seems_ to be related to IOSQE_ASYNC. Trying to narrow it
> down...

Further narrowed down, it seems to be related to IOSQE_ASYNC on the
read requests. I'm guessing there are cases where we end up not
canceling them on ring close, hence the ring stays active, etc.

If I just add a hack to clear IOSQE_ASYNC on IORING_OP_READ, then
the test terminates fine on the kill -9.

-- 
Jens Axboe

