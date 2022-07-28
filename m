Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3B6583FA2
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 15:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238776AbiG1NKM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jul 2022 09:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236726AbiG1NKL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jul 2022 09:10:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C11F26C
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 06:10:10 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b10so1807403pjq.5
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 06:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=W2KkhamqxGK8aA70gn/75IeDBM7sA441l7amNOWHOdg=;
        b=1fxrKd9MiK1ZeEW9gNICPYIVS1Bu+A4u7NH2NRpR50Kwc45hQ0WkCSA4EmZVbbmbP4
         GgWyJl8bz8B3vTAJxiPTnW94m+NfE9VFg8kdq/IzWNJImpDtvBrJAapp7N0c/TZH0khQ
         FTLqmxmprcbOtn7jj0+OKhDubMSuJyFs5rnDP82MWx6arSYbuhrbTPmdWr9HyUBtaRw5
         tKq/NVXt9KpZ+8QeRxNWsJpz4ngnwt1e1qsJWsn2iB+H8p7GGfaEd1/1YjzfVVzK1vxi
         jOOowWQsEYq51z9Kre6bio1RPitqpPQQOuJmp4yWsoSDPS+qTQl9JTlwrrBy3Gz+jFJ3
         RBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W2KkhamqxGK8aA70gn/75IeDBM7sA441l7amNOWHOdg=;
        b=li+ExA3/DO7+8D+gMVO+TanNj5D/GtuzZCyuxxvSHz2y/4MxP10nByvT2vJbLAJEgw
         Aa6cVwHLpRwqfhUBBLpux5gzz5tX5HiXLaVOg26HPjN2gqrBDB4juVALmU7Nz17VbC/H
         mPbkWQN6mtX2nRtHQv4fY9rLo6dQL/CNJwO6sMIxlmrwKj8mgXshF721gQ5Fxwnh1Oku
         9RzvKKMEcFP1F4uKgdy630DK4gdpse9W1Hr/XNDPxBAE1VP/oUKH4dWA4wrIHKTk5oIs
         UvEKzWB9tbpuoXjjAKDxlnuwkxiizCaVSojUabrRtT+4UlzdgQFYvRgWo0ce0aNjyqE0
         BB+Q==
X-Gm-Message-State: AJIora9WOwvaEK2AuXy3JTLv0iQWNBUNngRlwHqau9ULLWK34LQcngRO
        inEHIQTmFQ4twZ0ZSvc54/dkUQ==
X-Google-Smtp-Source: AGRyM1tLXPqgSUDn1Ic7m98CgfrJgHkFVEp0WIRhMMZQeLwEu1y/Lm+wqpboS830As5e3oNSLbDvew==
X-Received: by 2002:a17:90a:df96:b0:1f3:22e:7826 with SMTP id p22-20020a17090adf9600b001f3022e7826mr10061877pjv.21.1659013809865;
        Thu, 28 Jul 2022 06:10:09 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x18-20020aa79a52000000b005254e44b748sm687225pfj.84.2022.07.28.06.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 06:10:09 -0700 (PDT)
Message-ID: <ad07149b-6026-0e45-2a33-544f3b78187b@kernel.dk>
Date:   Thu, 28 Jul 2022 07:10:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing v3 0/5] Add basic test for nvme uring passthrough
 commands
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com
References: <CGME20220728093902epcas5p40813f72b828e68e192f98819d29b2863@epcas5p4.samsung.com>
 <20220728093327.32580-1-ankit.kumar@samsung.com>
 <0a9c81d0-d6f6-effd-5d3f-132a92d54205@kernel.dk>
 <20220728130129.GA20031@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220728130129.GA20031@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/28/22 7:01 AM, Ankit Kumar wrote:
> On Thu, Jul 28, 2022 at 06:36:51AM -0600, Jens Axboe wrote:
>> On 7/28/22 3:33 AM, Ankit Kumar wrote:
>>> This patchset adds a way to test NVMe uring passthrough commands with
>>> nvme-ns character device. The uring passthrough was introduced with 5.19
>>> io_uring.
>>>
>>> To send nvme uring passthrough commands we require helpers to fetch NVMe
>>> char device (/dev/ngXnY) specific fields such as namespace id, lba size etc.
>>>
>>> How to run:
>>> ./test/io_uring_passthrough.t /dev/ng0n1
>>>
>>> It requires argument to be NVMe device, if not the test will be skipped.
>>>
>>> The test covers write/read with verify for sqthread poll, vectored / nonvectored
>>> and fixed IO buffers, which can be extended in future. As of now iopoll is not
>>> supported for passthrough commands, there is a test for such case.
>>>
>>> Changes from v2 to v3
>>>  - Skip test if argument is not nvme device and remove prints, as
>>>    suggested by Jens.
>>>  - change nvme helper function name, as pointed by Jens.
>>>  - Remove wrong comment about command size, as per Kanchan's review
>>
>> I didn't get patch 2/5, and lore didn't either. Can you resend the series?
>>
>> -- 
>> Jens Axboe
>>
>>
> Sorry, issue from my side it. You should have 2/5 now and I see its
> there in lore as well. Hope its sufficient and doesn't require me to
> resend the entire series again.

Yep I got it, and I've now applied it. Did a few cleanups on top, but
nothing major. Thanks!

-- 
Jens Axboe

