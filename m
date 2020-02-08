Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1111B156734
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 19:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBHSs4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 13:48:56 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:55059 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbgBHSs4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 13:48:56 -0500
Received: by mail-wm1-f42.google.com with SMTP id g1so5716382wmh.4
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 10:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=tFqWnPeuMPtxvuU5gjZz4Ag8i34YjvpVWQK873aSKAE=;
        b=U3gw6GWOx64/miuFikQKIc02mr6vZKWvb590mlhjy7Bq7pMwc6/wzJk0nHRhnsXZj5
         ng0PHC/3Toh5a1wNeoo8VNwkQXokcs5roVA6XqP7mhUqc1FzcTtNjgaIxnUM5Gyn71dm
         UzN9Uf0Iyyyv3xRPSRkZKXWmZHdRYv6YRsta+CWd2kHaKTqaxsn//HmYyP/VO4mg9+h5
         w7IqdqOJSBxbzxvsFB2bbAt5iEcp0SOJ6uXJ3tMP/N4L/xu488MMcQj+Fqftiq/3LzOP
         0Jlm0zxCIyew3YmRXolXb8FPyMbnHbHRkrbomXvCVKmfjiWozqYIiI/zDsCDDnk9bPo+
         79BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tFqWnPeuMPtxvuU5gjZz4Ag8i34YjvpVWQK873aSKAE=;
        b=ZD1e7VhCtJLHmhYVMegXtJ+2+V2Qt1bq2S0strXMDVuuA8UKy5MjfiEm2krLY3+SUq
         1ZgoiyXfvepqt2vavl4VYhiCIm3th+TcKdoTNjGAGyAy42MlY7eoAmecAvmw8YTWMH5g
         Mp7Be7dpiS635dUsxVGk6F8WLGu5qY6OCH8//vDOgBlDaZ7n04sRUjVCWukWxzFWEEVL
         vlWOGpmJwKtWzyhO0ws7lePfuOwslniw08gnmsMzY0RvXhJooqNecv1OBqr28ej9jbsD
         z+2mJiijAJCmswt9cmMG2gfr/FFailSuok5hiz5bWmBJv074ZHf8QA5GCpT+ht5fB6ov
         nNlw==
X-Gm-Message-State: APjAAAWLCUgIMzMMna/tR8j/+AOWdoyi+Mf9GrVujlXgXCZR7gx2rC/c
        HmaXhDkClUqL5b+QjWnhnvZuxA==
X-Google-Smtp-Source: APXvYqwQSMZY3z1Y4U+MG+/tW7t10k+NdRPkSiLtHoJqsLpBeOVamm/GEzV417AZhxCRk8R2pNuXmg==
X-Received: by 2002:a7b:c392:: with SMTP id s18mr5343789wmj.169.1581187733246;
        Sat, 08 Feb 2020 10:48:53 -0800 (PST)
Received: from tmp.scylladb.com (bzq-109-67-34-200.red.bezeqint.net. [109.67.34.200])
        by smtp.googlemail.com with ESMTPSA id x14sm8052875wmj.42.2020.02.08.10.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 10:48:52 -0800 (PST)
Subject: Re: shutdown not affecting connection?
To:     Glauber Costa <glauber@scylladb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
 <cfc6191b-9db3-9ba7-9776-09b66fa56e76@gmail.com>
 <CAD-J=zbMcPx1Q5PTOK2VTBNVA+PQX1DrYhXvVRa2tPRXd_2RYQ@mail.gmail.com>
From:   Avi Kivity <avi@scylladb.com>
Message-ID: <9ec6cbf7-0f0b-f777-8507-199e8837df94@scylladb.com>
Date:   Sat, 8 Feb 2020 20:48:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zbMcPx1Q5PTOK2VTBNVA+PQX1DrYhXvVRa2tPRXd_2RYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/8/20 8:42 PM, Glauber Costa wrote:
> Hi
>
> BTW, my apologies but I should have specified the kernel I am running:
> 90206ac99c1f25b7f7a4c2c40a0b9d4561ffa9bf
>
> On Sat, Feb 8, 2020 at 9:26 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> Hi
>>
>> On 2/8/2020 4:55 PM, Glauber Costa wrote:
>>> Hi
>>>
>>> I've been trying to make sense of some weird behavior with the seastar
>>> implementation of io_uring, and started to suspect a bug in io_uring's
>>> connect.
>>>
>>> The situation is as follows:
>>>
>>> - A connect() call is issued (and in the backend I can choose if I use
>>> uring or not)
>>> - The connection is supposed to take a while to establish.
>>> - I call shutdown on the file descriptor
>>>
>>> If io_uring is not used:
>>> - connect() starts by  returning EINPROGRESS as expected, and after
>>> the shutdown the file descriptor is finally made ready for epoll. I
>>> call getsockopt(SOL_SOCKET, SO_ERROR), and see the error (104)
>>>
>>> if io_uring is used:
>>> - if the SQE has the IOSQE_ASYNC flag on, connect() never returns.
>>> - if the SQE *does not* have the IOSQE_ASYNC flag on, then most of the
>>> time the test works as intended and connect() returns 104, but
>>> occasionally it hangs too. Note that, seastar may choose not to call
>>> io_uring_enter immediately and batch sqes.
>>>
>>> Sounds like some kind of race?
>>>
>>> I know C++ probably stinks like the devil for you guys, but if you are
>>> curious to see the code, this fails one of our unit tests:
>>>
>>> https://github.com/scylladb/seastar/blob/master/tests/unit/connect_test.cc
>>> See test_connection_attempt_is_shutdown
>>> (above is the master seastar tree, not including the io_uring implementation)
>>>
>> Is this chaining with connect().then_wrapped() asynchronous? Like kind
>> of future/promise stuff?
> Correct.
> then_wrapped executes eventually when connect returns either success or failure
>
>> I wonder, if connect() and shutdown() there may
>> be executed in the reverse order.
> The methods connect and shutdown will execute in this order.
> But connect will just queue something that will later be sent down to
> the kernel.
>
> I initially suspected an ordering issue on my side. What made me start
> suspecting a bug
> are two reasons:
> - I can force the code to grab an sqe and call io_uring_enter at the
> moment the connect()
> call happens : I see no change.
> - that IOSQE_ASYNC changes this behavior, as you acknowledged yourself.
>
> It seems to me that if shutdown happens when the sqe is sitting on a
> kernel queue somewhere
> the connection will hang forever instead of failing right away as I would expect
> - if shutdown happens after the call to io_uring_enter



You can try to cancel the sqe before you shutdown the socket. This will 
flush the queue (even if the cancellation fails).


However, if you io_uring_enter before calling shutdown and connect does 
not return, I'd consider that a kernel bug. Perhaps you can reduce the 
problem to a small C reproducer?


