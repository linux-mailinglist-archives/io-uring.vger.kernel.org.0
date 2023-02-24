Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1674B6A14EB
	for <lists+io-uring@lfdr.de>; Fri, 24 Feb 2023 03:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjBXC3h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Feb 2023 21:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjBXC3g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Feb 2023 21:29:36 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0F21589A
        for <io-uring@vger.kernel.org>; Thu, 23 Feb 2023 18:29:35 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id y19so6813637pgk.5
        for <io-uring@vger.kernel.org>; Thu, 23 Feb 2023 18:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677205775;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qwNRQLXpbgmeG6gtF2j1SgKQd0doLDGHOq+m83fVYFo=;
        b=4VgjbzA2C3vtUbGMG5qR7ba41D4wCV73ruwDF5j9H42bRQw4eV4VdYUzXHztt92S5y
         FW8bmKeiORmBLPtYj4caJEUfMC6FGaVq1B1p0Khs10ylnMGc6vabtIFuMmAiKY9qEsvL
         Rm4SZPdjiwCeJFvSYz9JBMUlnM3RkGsN3ldROy7kvDUn2PA2nynaluQpFflxZI51qMgt
         5TK+7tHVWkK73wtsAKHRwR8tEXJoJmXWAsPfWHxO40fF+7a2ciCQz2cR/Vl6ObKqUeHc
         oDObRkvjXVyEisr2khwFArIA7rXavJ3rUJxwmScNBdQbTRX8BXqYqN7P4QnycszUKqHB
         fzgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677205775;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qwNRQLXpbgmeG6gtF2j1SgKQd0doLDGHOq+m83fVYFo=;
        b=zheXFMA6J6zogafoWo6rbwxUXVxUjonoFg8L29DMg0B0BUhyY2w9++28jwqdD7zodB
         YTsOSbOmZG4o8GviHsJa3rLQQKAg5pL5JMt+SoE0dyKNLnMwLCUKuJ6WMWDhyc/pyWRt
         5ILZr6qOBzE4Pim40FvqZ5/m3flTTTzgNPZf3c1CVco6CT7i4Pj0AtsTYGVyJwYCasaP
         Q2VdgsVRr0EV+8Abz7/KmVXtfUz+HfQVRtY1nlM9gDmhoVQOGNmb0CrqRz4FOd5Rorw4
         r5/5nHueEiT5bNIJo7AYsvlIxlGVeVQjkhu4p7H7WzXjIf81WHPB2wXApvxvzzTEUpL4
         rF5Q==
X-Gm-Message-State: AO0yUKWbipdVISUVde2c58Nr/bHRP3S/8ICRyHEJWiqkEaSDC3RufXr9
        LXpmGtUMXujcYzexLwEO91lPxQ==
X-Google-Smtp-Source: AK7set+QdDAF7stRlVv2RoN/k2otnHIZBQzsA3ZSmsY+uCQ/hYRC2E1HIUBLD830x5UOEsIlWR6zpA==
X-Received: by 2002:a62:e713:0:b0:5a9:cebd:7b79 with SMTP id s19-20020a62e713000000b005a9cebd7b79mr14338696pfh.0.1677205774289;
        Thu, 23 Feb 2023 18:29:34 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c6-20020a62e806000000b00593e4e6516csm6185695pfi.124.2023.02.23.18.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 18:29:33 -0800 (PST)
Message-ID: <6188031e-8af2-5f67-fe79-79bfb7ad4344@kernel.dk>
Date:   Thu, 23 Feb 2023 19:29:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH tools/io_uring] tools/io_uring: correctly set "ret" for
 sq_poll case
Content-Language: en-US
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        asml.silence@gmail.com
References: <20230221073736.628851-1-ZiyangZhang@linux.alibaba.com>
 <55a01e39-c28c-dde0-172c-feee378c2f74@kernel.dk>
 <084ea730-a3a1-4dff-ecb5-d45a0af82e97@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <084ea730-a3a1-4dff-ecb5-d45a0af82e97@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/23 7:25 PM, Ziyang Zhang wrote:
> On 2023/2/23 11:46, Jens Axboe wrote:
>> On 2/21/23 12:37?AM, Ziyang Zhang wrote:
>>> For sq_poll case, "ret" is not initialized or cleared/set. In this way,
>>> output of this test program is incorrect and we can not even stop this
>>> program by pressing CTRL-C.
>>>
>>> Reset "ret" to zero in each submission/completion round, and assign
>>> "ret" to "this_reap".
>>
>> Can you check if this issue also exists in the fio copy of this, which
>> is t/io_uring.c in:
>>
>> git://git.kernel.dk/fio
>>
>> The copy in the kernel is pretty outdated at this point, and should
>> probably get removed. But if the bug is in the above main version, then
>> we should fix it there and then ponder if we want to remove the one in
>> the kernel or just get it updated to match the upstream version.
>>
> 
> Hi Jens,
> 
> I have checked t/io_uring.c and the code is correct with sq_poll.

OK good, I'll attempt a sync with the kernel copy...

-- 
Jens Axboe


