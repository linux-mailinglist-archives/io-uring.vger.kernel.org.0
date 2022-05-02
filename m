Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E321E517602
	for <lists+io-uring@lfdr.de>; Mon,  2 May 2022 19:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244310AbiEBRoh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 May 2022 13:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244389AbiEBRod (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 May 2022 13:44:33 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5947421B4;
        Mon,  2 May 2022 10:41:03 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id w4so20403591wrg.12;
        Mon, 02 May 2022 10:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5yilTDVWyYVQnat0wTW/cshHY+EZUdB/qoHF/HgKqh0=;
        b=b5t3fQ/sc6WafpGvCpiTDmwe3DSD9Yby3pt2wIsQT7bEHa9TxNfH77jTWrmVEbXWxA
         cZaPeDyBcyK6NQ/LmprunhCxGTPygSeR5bbfTUuzcVEFnTXZUlVVDYkqjo/xnt/NAs6r
         jzIj+2nw8hdtCD17bTlCjgzZTI3GnlOfNVBnqp13eAOY+xWZT20UnHbUsiBZgkfUaufI
         oR0QVi7JMCCi+xVFp+6Gg53rQQasX3deNRymuQjbPpHrPJiaq/F6tzdlmTXFL8AQg/FQ
         EhW6UrpH7nmXmGZ5pULLkrdPabj8ULkG9W3rc3JFbX6JK3fWCfJICLwBpkCIjLtuQn6N
         vpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5yilTDVWyYVQnat0wTW/cshHY+EZUdB/qoHF/HgKqh0=;
        b=nwYA1rE0NKnv66ZfmVaat9Yl2QAKdTlfL3ovwxLT+jX+E9rrdArrlvJte3Qjc+1R97
         JoAjcZt364b6BkoTyKJL/pxtU8JskVVokZ65jlm9qFcDm+QUglo+Mi7CUHajwyuiqmOw
         RSpMEvCGGiEZmjrsnilRWhTQSN4erX//eKRvN4l9HaKl5fPMjp+7X4txieHgTtUu7mAG
         XInsO/dlAiyRmdLL2Ku3yiFQBvn/1V8X3dU4MjV2rMFM3xghWZiQgJw8ehEJ4FYt/yox
         o31DyTAObwsF+utb8n/YCyTY6Yz5dI489LXrlAZ++njQBHmnZ6Tb1Vz/1kCm7VfqojrG
         25ZA==
X-Gm-Message-State: AOAM533Et4hNnfiN8PNCFfX2DJhkSjQVgls+J9SSCtrC0otC1lw06xm4
        vvpLo9FJohXBlxsq485vULis/H9wXVw=
X-Google-Smtp-Source: ABdhPJxywibdFq1ctsjS/GPe80Fc7DTC9r2SQDQ3wmUuqEQ6EQpJb07yaHE/CoAXsaiZmQ9A7GCLcA==
X-Received: by 2002:a05:6000:110d:b0:20a:ea3b:8d48 with SMTP id z13-20020a056000110d00b0020aea3b8d48mr10313168wrw.196.1651513261679;
        Mon, 02 May 2022 10:41:01 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.235.73])
        by smtp.gmail.com with ESMTPSA id y20-20020a7bc194000000b003942a244f48sm6657482wmi.33.2022.05.02.10.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 10:41:00 -0700 (PDT)
Message-ID: <2436d42c-85ca-d060-6508-350c769804f1@gmail.com>
Date:   Mon, 2 May 2022 18:40:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Daniel Harding <dharding@living180.net>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
 <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
 <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
 <bb283ff5-6820-d096-2fca-ae7679698a50@kernel.dk>
 <371c01dd-258c-e428-7428-ff390b664752@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <371c01dd-258c-e428-7428-ff390b664752@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/2/22 18:00, Jens Axboe wrote:
> On 5/2/22 7:59 AM, Jens Axboe wrote:
>> On 5/2/22 7:36 AM, Daniel Harding wrote:
>>> On 5/2/22 16:26, Jens Axboe wrote:
>>>> On 5/2/22 7:17 AM, Daniel Harding wrote:
>>>>> I use lxc-4.0.12 on Gentoo, built with io-uring support
>>>>> (--enable-liburing), targeting liburing-2.1.  My kernel config is a
>>>>> very lightly modified version of Fedora's generic kernel config. After
>>>>> moving from the 5.16.x series to the 5.17.x kernel series, I started
>>>>> noticed frequent hangs in lxc-stop.  It doesn't happen 100% of the
>>>>> time, but definitely more than 50% of the time.  Bisecting narrowed
>>>>> down the issue to commit aa43477b040251f451db0d844073ac00a8ab66ee:
>>>>> io_uring: poll rework. Testing indicates the problem is still present
>>>>> in 5.18-rc5. Unfortunately I do not have the expertise with the
>>>>> codebases of either lxc or io-uring to try to debug the problem
>>>>> further on my own, but I can easily apply patches to any of the
>>>>> involved components (lxc, liburing, kernel) and rebuild for testing or
>>>>> validation.  I am also happy to provide any further information that
>>>>> would be helpful with reproducing or debugging the problem.
>>>> Do you have a recipe to reproduce the hang? That would make it
>>>> significantly easier to figure out.
>>>
>>> I can reproduce it with just the following:
>>>
>>>      sudo lxc-create --n lxc-test --template download --bdev dir --dir /var/lib/lxc/lxc-test/rootfs -- -d ubuntu -r bionic -a amd64
>>>      sudo lxc-start -n lxc-test
>>>      sudo lxc-stop -n lxc-test
>>>
>>> The lxc-stop command never exits and the container continues running.
>>> If that isn't sufficient to reproduce, please let me know.
>>
>> Thanks, that's useful! I'm at a conference this week and hence have
>> limited amount of time to debug, hopefully Pavel has time to take a look
>> at this.
> 
> Didn't manage to reproduce. Can you try, on both the good and bad
> kernel, to do:

Same here, it doesn't reproduce for me


> # echo 1 > /sys/kernel/debug/tracing/events/io_uring/enable
> 
> run lxc-stop
> 
> # cp /sys/kernel/debug/tracing/trace ~/iou-trace
> 
> so we can see what's going on? Looking at the source, lxc is just using
> plain POLL_ADD, so I'm guessing it's not getting a notification when it
> expects to, or it's POLL_REMOVE not doing its job. If we have a trace
> from both a working and broken kernel, that might shed some light on it.

-- 
Pavel Begunkov
