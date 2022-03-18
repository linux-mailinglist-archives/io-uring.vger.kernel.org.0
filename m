Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD594DDCAE
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 16:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237410AbiCRPXX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 11:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiCRPXW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 11:23:22 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A2223D5BB
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 08:22:03 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id x9so6033153ilc.3
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 08:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=+ZBiVclRBx4VtR3i1pnuRbBDmhhM4ZtcKbBISSTQD5E=;
        b=WhuxQ5tn1f24yeVNYoRCFCsvkP6cnUD+nH8mqooHz8gvcK9ItvtzcemaUrYnxGnIDf
         yvQntxxzAST1rc1ozPQmIV08imNV10hZXt+JO8Fw3jThL3pRvcK8XEw/QNRZ1zNWzXX2
         C10RPnKi6vUda5hN1VjLkaSOG8sgK43RqL8WpfyyDSWLylLqTOY2xHvVaxw826GSSL8r
         ETOgV+FxEb1GLMNW+GLHJzOjKMT80ecOUEqKKpKeCUNx0EHAVQpr2FGSF42mAEyyXjGn
         MNAoYCOi+/CqsdbRAcFSSCyhgqjUeKN6mHjohjAYH4wfFCIwIRhJVOLLxbe/BC3i4F99
         9uLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+ZBiVclRBx4VtR3i1pnuRbBDmhhM4ZtcKbBISSTQD5E=;
        b=NpVnEW/S08u/ceCMrA0fxTndr1nhqH9stOxJPblvApWCkLlmJScqoo3M1o8oaBBocr
         GsZGAudFzw/3sfl595x0B/IErIRK7ucIzvitRXPfD+NPlb1Y7/kCIWQJ9pAtyiNzMsf6
         uAr9uJmU2Pdrk2YuMR3Lw/sexfb03phPFiBkHMImkBUcsHtqbRcPY7GnYca2BsaIfHc0
         gbW7tOWxwmLeF1tiqTMqX6Lx7LVQ17PtWWYSdXBn9lLxMGFnorSWJwSrcAOYvw3/aun0
         uJazShtF6a1ytBZdpqW1Kaa0yGXM0I75sUfQZFdec4/Ul4+4bjycUiB6YoaJG5ValLBQ
         mgYg==
X-Gm-Message-State: AOAM532njH4NPeeUmbFO7PHOz92k8lejLP7uBcMGyjzQJOfhbLWhc+lA
        zDUHBC1In6hnEtSVv+/cOahWRQ==
X-Google-Smtp-Source: ABdhPJzdsirmBrTEdNGP4ZV7XWwaqia4gScHD/p3JQdYDgEQO+bZQye3xm0hsY5sCk5VAEuSzW0Ytw==
X-Received: by 2002:a92:7106:0:b0:2c6:3167:ce83 with SMTP id m6-20020a927106000000b002c63167ce83mr4720490ilc.138.1647616922905;
        Fri, 18 Mar 2022 08:22:02 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r9-20020a92cd89000000b002c655c48593sm5067451ilb.67.2022.03.18.08.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 08:22:02 -0700 (PDT)
Message-ID: <c61808ee-f583-b243-95ed-fa3739ef3411@kernel.dk>
Date:   Fri, 18 Mar 2022 09:22:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [RFC 0/4] completion locking optimisation feature
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1647610155.git.asml.silence@gmail.com>
 <016bd177-1621-c6c1-80a2-adfabe929d2f@gmail.com>
 <23c1e47b-45e5-242f-a563-d257a7de88ed@kernel.dk>
 <458031c4-2eca-7a9e-ab9f-183a2497af48@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <458031c4-2eca-7a9e-ab9f-183a2497af48@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/22 9:00 AM, Pavel Begunkov wrote:
> On 3/18/22 14:52, Jens Axboe wrote:
>> On 3/18/22 8:42 AM, Pavel Begunkov wrote:
>>> On 3/18/22 13:52, Pavel Begunkov wrote:
>>>> A WIP feature optimising out CQEs posting spinlocking for some use cases.
>>>> For a more detailed description see 4/4.
>>>>
>>>> Quick benchmarking with fio/t/io_uring nops gives extra 4% to throughput for
>>>> QD=1, and ~+2.5% for QD=4.
>>>
>>> Non-io_uring overhead (syscalls + userspace) takes ~60% of all execution
>>> time, so the percentage should quite depend on the CPU and the kernel config.
>>> Likely to be more than 4% for a faster setup.
>>>
>>> fwiw, was also usingIORING_ENTER_REGISTERED_RING, if it's not yet included
>>> in the upstream version of the tool.
>>
>> But that seems to be exclusive of using PRIVATE_CQ?
> 
> No, it's not. Let me ask to clarify the description and so, why do you
> think it is exclusive?

Didn't dig too deep, just saw various EINVAL around registered files and
updating/insertion. And the fact that t/io_uring gets -EINVAL on
register with op 20 (ring fd) if I set CQ_PRIVATE, see other email.

-- 
Jens Axboe

