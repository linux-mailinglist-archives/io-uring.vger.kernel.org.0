Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B71D3B99FF
	for <lists+io-uring@lfdr.de>; Fri,  2 Jul 2021 02:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbhGBAXt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 20:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbhGBAXs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 20:23:48 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE67C061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 17:21:17 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id f14so9972948wrs.6
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 17:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+r0DGofD4RFh4dSbuksrz26j1WqvdYPlFStvxjY2b/M=;
        b=Mshumi2qeNBsOsyHofCe53+iiuaexAMAbZjySmxjbsZWB194apGoday5jYcK0DVr8l
         z15EpB6vUs3XBtsmJaioeCJcXX5M1IjX4j72C6R3YRsoJWD3HlpoUUbn3t9pyuOLpXb3
         MsLkm7MXV63LN5xdpM3NsM88xsJn4wVTil+9IGXJuYXLpN8W9ywXWywSKN8R688+hvQ6
         D6rM0ofyT2VsH9hm6E4bBihq9UcHc0EFq9fea4uWL+j+omtCYOVgwL57jvWOw+3Mxutc
         eoCuIFBE58VOPaZrptUK8xU9EpJ6XRDBSrpmDe/Blcyd9SJbc323CtvDSLuEEix+uPYs
         iyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+r0DGofD4RFh4dSbuksrz26j1WqvdYPlFStvxjY2b/M=;
        b=tIRbKD5fXjpf9qbQNW4Uu0cGsUkAZv9s5zlBoFNOAU4pLO2/jiJzxZeXGbGmD+m/Dg
         s1ZBIohEuqhaTWtMyGxf2h25la21XtMdBbH38J8npLjUIF6yVDPryv/njMFrZXdL2osA
         NqfaWENW9RW3HzSh7YYG6rOoMKT8IjYgHW8oi8cITsFDM6ZdE1ohylqjqUhBVwKNiyNQ
         04Ioy/jcpg4ZCx/KmKVGQRHErEHrSMj6zg4y4xIRqcdfzJFswMSDY6LQ1oTJ++mW2Urx
         zk8vPhWBl0XN6nxwgkENW4aZk6Bnd4A3SNTxD8qzciYYDB3YO+o2dpM0K8DbobhN72f0
         NvMg==
X-Gm-Message-State: AOAM532MCf+qZ/AtRlKaN+JqtoL0XJcD/IWzD/1D+aJmOgzX/OuFOOvI
        uSCSmjPVWQtcqXA7+Z3On+HedepbY2m2ww==
X-Google-Smtp-Source: ABdhPJxzr0yxgQDFTp4XEaVsddNPDW/oeWrSpLCvJgfduZI3z62zUZeuoQivfv+8E3irWtxdwJoVHg==
X-Received: by 2002:adf:8b4d:: with SMTP id v13mr2408854wra.223.1625185275825;
        Thu, 01 Jul 2021 17:21:15 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.176])
        by smtp.gmail.com with ESMTPSA id w8sm1380169wre.70.2021.07.01.17.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 17:21:15 -0700 (PDT)
Subject: Re: [Bug] io_uring_register_files_update broken
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwgU2V0RsE+77mRUg+mr6WL5PJpbFKh4FrEGOnfzZ5vZ3A@mail.gmail.com>
 <5201d747-121d-4e5e-d2a6-9442a5e4c534@gmail.com>
 <CAM1kxwgEZ1bPMGgJixqQPVm4AP84xwYU8zrPOohvGp9nCQPpZg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <2a66d0f3-e3a9-49ad-e098-e0782cf464b4@gmail.com>
Date:   Fri, 2 Jul 2021 01:20:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwgEZ1bPMGgJixqQPVm4AP84xwYU8zrPOohvGp9nCQPpZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/1/21 4:46 PM, Victor Stewart wrote:
> On Thu, Jul 1, 2021 at 3:51 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
[...]
>>> sockfd, fds, 1);
>>
>> s/fds/&fds[sockfd]/
>>
>> Does it help? io_uring_register_files_update() doesn't
>> apply offset parameter to the array, it's used only as
>> an internal index.
> 
> i see yes, it works it like this!
> 
> io_uring_register_files_update(&ring, fd, &(socketfds[fd]), 1);
> io_uring_register_files_update(&ring, fd, &(socketfds[fd] = -1), 1);
> 
> and this behavior is clear upon a closer reading of...
> https://github.com/axboe/liburing/blob/11f6d56302c177a96d7eb1df86995939a4feb736/test/file-register.c#L80
> 
> i guess it's sometimes ambiguous whether int* is requesting an array
> or an actual pointer to a single int.

It's an array, just element 0 is registered as a registered
file with index @off, element 1 as a reg-file with index
@(off+1) and so on.

> all good now.
> 
>>
>>> +
>>> +               if (result != 1)
>>> +               {
>>> +                       fprintf(stderr, "file update failed\n");
>>> +                       goto err;
>>> +               }
>>>         }
>>>
>>> +       use_fd = sockfd;
>>> +
>>>         sqe = io_uring_get_sqe(ring);
>>>         io_uring_prep_recv(sqe, use_fd, iov->iov_base, iov->iov_len, 0);
>>>         if (registerfiles)
>>>
>>
>> --
>> Pavel Begunkov

-- 
Pavel Begunkov
