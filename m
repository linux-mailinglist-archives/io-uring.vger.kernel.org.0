Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD9375FFC3
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 21:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjGXTXu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 15:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjGXTXt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 15:23:49 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DD610F0;
        Mon, 24 Jul 2023 12:23:48 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-52229f084beso2559371a12.2;
        Mon, 24 Jul 2023 12:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690226626; x=1690831426;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cWo4sIKyvyIpPAwWLeOJz8L9JuZtA+G/0dxZszCh6vo=;
        b=latCLXtw9bkLnLi+GLz0mDfQySuJCccWsImdGir5RMfkHE5vZl+IIi4uL+keuRwu9t
         60BrwZbclALe81Fmmch9iK+eeXTACpiUYg5lqLsAIrkxyJZkCnTIFBjZjqXa6gi2kisY
         rmVUL8HEqXdXtzqarHvCsirm7SK6hcJulzBHcyeHxt1Qapo1jSQLjNA4MDVedjg2Pvnj
         xPP28DoqOBqMFzMKbj4qh+BICTLz0fN6wVksJQFAKOdXsqLqmbVosQ6gxFoIKLStt8gR
         nRDmJ68TT7H4nfQ4/RciVdwnC2kJPLmV0t44hV5vMEGiSARqdDgWmEuEztVMzGfej8Ch
         uQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690226626; x=1690831426;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cWo4sIKyvyIpPAwWLeOJz8L9JuZtA+G/0dxZszCh6vo=;
        b=jLmKBi/nYImE3YPjz/1DR5L0KuC49OGrXiRFlup0yLbQZUlknhd11KgPnqolLEQ7GU
         /Yucm/VksRpY152b5KD2i7Dy0ocDxoZozZk413BcTJ4z+iBxuqIXpNAN1CwIjZOS7ywa
         xNzYMSHVJrJl7wzqtrzZdIv12I6ydDNtKv8yREsfPHWAi7e9CGrCcRh/fbWy9v0RFTh7
         bktT3OZXON5zU1rK781SYVxrUGCKIDLLSSpzoUSD2bCAXA1VtXsBRv/1sgJsbDC24Q76
         HEaQB1E/9xW1zI/2SXoy/4DCDUG4lJJpEa0t8Oj3vzje1Ouo7U4IfxAXp3CNijL2ruwa
         8weQ==
X-Gm-Message-State: ABy/qLbKJCvEgUnl2FdVQwVt+k8gPDlNABhpO+qh0TnyR8vQRLBh7fzo
        8aiTdcw9DzIa+rgK2CoBHHY=
X-Google-Smtp-Source: APBJJlFLrOqXJwk2/ZogigT9lz5sDvbwFGJVMGIOCEC/jeoYe69weJzVeSfX0lbNF+PHSciKnQdVNw==
X-Received: by 2002:a17:907:b11:b0:992:7e1f:8419 with SMTP id h17-20020a1709070b1100b009927e1f8419mr10392698ejl.2.1690226626234;
        Mon, 24 Jul 2023 12:23:46 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:c92])
        by smtp.gmail.com with ESMTPSA id h23-20020a170906829700b0098d486d2bdfsm7242644ejx.177.2023.07.24.12.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 12:23:46 -0700 (PDT)
Message-ID: <0f63b072-840c-db5d-13cd-7faa554975d3@gmail.com>
Date:   Mon, 24 Jul 2023 20:22:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
To:     Jens Axboe <axboe@kernel.dk>, Greg KH <gregkh@linuxfoundation.org>,
        Phil Elwell <phil@raspberrypi.com>
Cc:     andres@anarazel.de, david@fromorbit.com, hch@lst.de,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, stable <stable@vger.kernel.org>
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
 <2023072438-aftermath-fracture-3dff@gregkh>
 <140065e3-0368-0b5d-8a0d-afe49b741ad2@kernel.dk>
 <ecb821a2-e90a-fec1-d2ca-b355c16b7515@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ecb821a2-e90a-fec1-d2ca-b355c16b7515@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/23 16:58, Jens Axboe wrote:
> On 7/24/23 9:50?AM, Jens Axboe wrote:
>> On 7/24/23 9:48?AM, Greg KH wrote:
>>> On Mon, Jul 24, 2023 at 04:35:43PM +0100, Phil Elwell wrote:
>>>> Hi Andres,
>>>>
>>>> With this commit applied to the 6.1 and later kernels (others not
>>>> tested) the iowait time ("wa" field in top) in an ARM64 build running
>>>> on a 4 core CPU (a Raspberry Pi 4 B) increases to 25%, as if one core
>>>> is permanently blocked on I/O. The change can be observed after
>>>> installing mariadb-server (no configuration or use is required). After
>>>> reverting just this commit, "wa" drops to zero again.
>>>
>>> This has been discussed already:
>>> 	https://lore.kernel.org/r/12251678.O9o76ZdvQC@natalenko.name
>>>
>>> It's not a bug, mariadb does have pending I/O, so the report is correct,
>>> but the CPU isn't blocked at all.
>>
>> Indeed - only thing I can think of is perhaps mariadb is having a
>> separate thread waiting on the ring in perpetuity, regardless of whether
>> or not it currently has IO.
>>
>> But yes, this is very much ado about nothing...
> 
> Current -git and having mariadb idle:
> 
> Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> Average:     all    0.00    0.00    0.04   12.47    0.04    0.00    0.00    0.00    0.00   87.44
> Average:       0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> Average:       1    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> Average:       2    0.00    0.00    0.00    0.00    0.33    0.00    0.00    0.00    0.00   99.67
> Average:       3    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> Average:       4    0.00    0.00    0.33    0.00    0.00    0.00    0.00    0.00    0.00   99.67
> Average:       5    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> Average:       6    0.00    0.00    0.00  100.00    0.00    0.00    0.00    0.00    0.00    0.00
> Average:       7    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 
> which is showing 100% iowait on one cpu, as mariadb has a thread waiting
> on IO. That is obviously a valid use case, if you split submission and
> completion into separate threads. Then you have the latter just always
> waiting on something to process.
> 
> With the suggested patch, we do eliminate that case and the iowait on
> that task is gone. Here's current -git with the patch and mariadb also
> running:
> 
> 09:53:49 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> 09:53:50 AM  all    0.00    0.00    0.00    0.00    0.00    0.75    0.00    0.00    0.00   99.25
> 09:53:50 AM    0    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 09:53:50 AM    1    0.00    0.00    0.00    0.00    0.00    1.00    0.00    0.00    0.00   99.00
> 09:53:50 AM    2    0.00    0.00    0.00    0.00    0.00    1.00    0.00    0.00    0.00   99.00
> 09:53:50 AM    3    0.00    0.00    0.00    0.00    0.00    1.00    0.00    0.00    0.00   99.00
> 09:53:50 AM    4    0.00    0.00    0.00    0.00    0.00    0.99    0.00    0.00    0.00   99.01
> 09:53:50 AM    5    0.00    0.00    0.00    0.00    0.00    1.00    0.00    0.00    0.00   99.00
> 09:53:50 AM    6    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
> 09:53:50 AM    7    0.00    0.00    0.00    0.00    0.00    1.00    0.00    0.00    0.00   99.00
> 
> 
> Even though I don't think this is an actual problem, it is a bit
> confusing that you get 100% iowait while waiting without having IO
> pending. So I do think the suggested patch is probably worthwhile
> pursuing. I'll post it and hopefully have Andres test it too, if he's
> available.

Emmm, what's the definition of the "IO" state? Unless we can say what exactly
it is there will be no end to adjustments, because I can easily argue that
CQ waiting by itself is IO.
Do we consider sleep(N) to be "IO"? I don't think the kernel uses io
schedule around that, and so it'd be different from io_uring waiting for
a timeout request. What about epoll waiting, etc.?

-- 
Pavel Begunkov
