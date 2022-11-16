Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F07062C926
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 20:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiKPTq6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 14:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbiKPTq4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 14:46:56 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63662980A
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 11:46:52 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id s10so14050465ioa.5
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 11:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DK4mvxNwSi6YmikV+YE5movO5+qkkFSsaC8H1X3OQC0=;
        b=WR/taDEjqDU9u3IFfH3J/h/CqMu+UO9rU/gxNrYhdBt21LYaimy5qkdVoIZFCcutY3
         DMVQNbKmmszuTs03TV0p/a+tpiXxJN+mnxfnLGeupmbMh4oN/cflh8IuUeyXccdPda6r
         A0xXpkpe1hub7nQ9C/KpmdkPCaEghv0x4HTDT5oRnBnVF8/d086D4XgQ/87xsSEI5lq1
         xA47QMpEZnn1d+Of08G56+QORG58IBdP7VDm90yu6bdMcQFqxAsJD3gujkHZ5PAbKJHz
         sPTdvyP549ADILWPlDnZKTyhhKPg+EVpZ1+jDUjETIDhG3a/eX/D+fAJ/K9eGJLo8ztZ
         BFLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DK4mvxNwSi6YmikV+YE5movO5+qkkFSsaC8H1X3OQC0=;
        b=myRbqswtx4XODaZGHA/muwsMgV0jFGzb/nTZCrwwwH6b6Vb+DensqePgyGsbNEywi1
         s5dh217ht31OvciCRBLD/+pQzLlF7gLvpt9Tp0nWYVxdfvu1OVyOHmlTcJ13bwn5543F
         tS8LJXUvBTSkBbw38Vvo7Q6Pe10sIrjOmae0J7DUvesuJ3/t1KjvVSt+2AdaIThPkYf/
         gOdenfJHeAeJ2afcZcVdSvNip7lWE3lJ3CVpsuUJj7GNFYJB+zO1mHZgKda7/LxQMXAs
         3VO3C0srb+gJomZQoHi18aj9eC8C7jz+OKqRFFi2FdVtbzQ7SmO6Gb9/LVTQZ3iR+S7B
         W17Q==
X-Gm-Message-State: ANoB5pmArab36P//6n3u75LekhPSqVyiDYGUABe2MN4Tvogv8yVHRr/Z
        91taqi/qWbzKLr9dUInYq2ffpg==
X-Google-Smtp-Source: AA0mqf7RRkahzdoqE76awTdXTnsf25FIcW6RLWZ6ALJRhKFz8taogIDOBcwV9bihdkIkXpkjklKICQ==
X-Received: by 2002:a02:211d:0:b0:34a:35a:5463 with SMTP id e29-20020a02211d000000b0034a035a5463mr11203492jaa.148.1668628012110;
        Wed, 16 Nov 2022 11:46:52 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 123-20020a021d81000000b00374cd28d842sm6181017jaj.104.2022.11.16.11.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 11:46:51 -0800 (PST)
Message-ID: <b46b01a1-ed6e-6824-9b4b-c6af82bb60f0@kernel.dk>
Date:   Wed, 16 Nov 2022 12:46:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: (subset) [PATCH v1 0/2] io_uring uapi updates
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20221115212614.1308132-1-ammar.faizi@intel.com>
 <166855408973.7702.1716032255757220554.b4-ty@kernel.dk>
 <61293423-8541-cb8b-32b4-9a4decb3544f@gnuweeb.org>
 <fe9b695d-7d64-9894-b142-2228f4ba7ae5@kernel.dk>
 <69d39e98-71fb-c765-e8b9-b02933c524a9@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <69d39e98-71fb-c765-e8b9-b02933c524a9@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/16/22 7:22 AM, Stefan Metzmacher wrote:
> Am 16.11.22 um 14:50 schrieb Jens Axboe:
>> On 11/15/22 11:34 PM, Ammar Faizi wrote:
>>> On 11/16/22 6:14 AM, Jens Axboe wrote:
>>>> On Wed, 16 Nov 2022 04:29:51 +0700, Ammar Faizi wrote:
>>>>> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>>>>>
>>>>> Hi Jens,
>>>>>
>>>>> io_uring uapi updates:
>>>>>
>>>>> 1) Don't force linux/time_types.h for userspace. Linux's io_uring.h is
>>>>> ???? synced 1:1 into liburing's io_uring.h. liburing has a configure
>>>>> ???? check to detect the need for linux/time_types.h (Stefan).
>>>>>
>>>>> [...]
>>>>
>>>> Applied, thanks!
>>>>
>>>> [1/2] io_uring: uapi: Don't force linux/time_types.h for userspace
>>>> ??????? commit: 958bfdd734b6074ba88ee3abc69d0053e26b7b9c
>>>
>>> Jens, please drop this commit. It breaks the build:
>>
>> Dropped - please actually build your patches, or make it clear that
>> they were not built at all. None of these 2 patches were any good.
> 
> Is it tools/testing/selftests/net/io_uring_zerocopy_tx.c that doesn't build?

Honestly not sure, but saw a few reports come in. Here's the one from
linux-next:

https://lore.kernel.org/all/20221116123556.79a7bbd8@canb.auug.org.au/

> and needs a '#define HAVE_LINUX_TIME_TYPES_H 1'
> 
> BTW, the original commit I posted was here:
> https://lore.kernel.org/io-uring/c7782923deeb4016f2ac2334bc558921e8d91a67.1666605446.git.metze@samba.org/
> 
> What's the magic to compile tools/testing/selftests/net/io_uring_zerocopy_tx.c ?

Some variant of make kselftests-foo?

> My naive tries both fail (even without my patch):

Mine does too, in various other tests. Stephen?

-- 
Jens Axboe
