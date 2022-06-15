Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A9F54C869
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 14:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345559AbiFOMYa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 08:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348710AbiFOMYa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 08:24:30 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2EC3A19D
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 05:24:29 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id r1so10247658plo.10
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 05:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=tnvHkLKk4ksyfYT9+CL4ymS6mOaC3iBDc3LcJFPSLbI=;
        b=J72Phyw0o8iel2o4TZMCVu+4S8Gt39AT4RiYk/LgwjeLk5virJr2701NUwTT8Znupg
         f5xgu/e9a7Ev4YkGyd4IxdBB8ApsmQJ4JmW1Zjn4k6XBn+BrArHNhI4rInJQtcprq8o1
         4lLe1Bnkz+3iFPbj2eG8r9Xo+Ra/dYibGBac2uiHbbPIeDbhg6mpRB4ZDPMmrbSzC/Gz
         Rma3OJnsdWYJV//6ta75pGI+9nL0j3/e/kheeuwLjrJY8yT/9wyXA3hzY3TLbrvFbDqJ
         vKiuIPgg+Oz1NWmFifhl1KucLoiMqLucGOR6sKTETN6ImoUuM4ewNRpDN+DUbzhleFTL
         32Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tnvHkLKk4ksyfYT9+CL4ymS6mOaC3iBDc3LcJFPSLbI=;
        b=jIQp4BXpjDSIdjBfboiXyoR9a11euz9vZuAsBKnBXB6qMLjBNPTHF/vhjvVt0jqZTf
         9ZKeJ74x4yCdRbpwVgpWkAlLn8yYCWlL8b0qgwzEc7whPGN5CjTngMd7mnITUydm6DWk
         Md2dIOiGdvlEsnDbWBOaGN/lW6novhXX8rwuB+H0Yg1vrrXMIohZGja7DuvJAGsso6P+
         oIpKYzXn80lQMpoGlCw6TKIok0JTvMlAda57t0cH43T+C2BAVgPMWxzG2CLThAGNs1RE
         pf0FfHwfjUZktzrgXUvHNPfYUwH9LnD6cnlqfHDhvyZnTIp65D+bCQwJf8WaUiNRP1Um
         5yrg==
X-Gm-Message-State: AJIora8bRsk3zgYU+5bYLUbH0g1Ij55CyJXIkc+U699ma068FZrdSVG+
        9TNVKGHDEzkp4I6JZUzNBav+D16YEjvLsA==
X-Google-Smtp-Source: AGRyM1uhsZhouDX6NL2mD9lItTlnfwRsNSpZJTOLqan/T5iDg4yHOb59vM9AnylAB20ZlpV+zgU7jg==
X-Received: by 2002:a17:902:7884:b0:167:4d5b:7a2f with SMTP id q4-20020a170902788400b001674d5b7a2fmr9206356pll.18.1655295867665;
        Wed, 15 Jun 2022 05:24:27 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p8-20020a1709027ec800b001663185e654sm9208117plb.280.2022.06.15.05.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 05:24:27 -0700 (PDT)
Message-ID: <538fb474-845b-4842-93be-fad646ca5d37@kernel.dk>
Date:   Wed, 15 Jun 2022 06:24:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.19 0/6] CQE32 fixes
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655287457.git.asml.silence@gmail.com>
 <52279d69-ee83-c6d4-cf02-7384bf758a9a@kernel.dk>
 <b708b629-7d1e-441a-0cf8-395433291e32@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b708b629-7d1e-441a-0cf8-395433291e32@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 6:21 AM, Pavel Begunkov wrote:
> On 6/15/22 13:03, Jens Axboe wrote:
>> On 6/15/22 4:23 AM, Pavel Begunkov wrote:
>>> Several fixes for IORING_SETUP_CQE32
>>>
>>> Pavel Begunkov (6):
>>>    io_uring: get rid of __io_fill_cqe{32}_req()
>>>    io_uring: unite fill_cqe and the 32B version
>>>    io_uring: fill extra big cqe fields from req
>>>    io_uring: fix ->extra{1,2} misuse
>>>    io_uring: inline __io_fill_cqe()
>>>    io_uring: make io_fill_cqe_aux to honour CQE32
>>>
>>>   fs/io_uring.c | 209 +++++++++++++++++++-------------------------------
>>>   1 file changed, 77 insertions(+), 132 deletions(-)
>>
>> Looks good to me, thanks a lot for doing this work. One minor thing that
>> I'd like to change, but can wait until 5.20, is the completion spots
>> where we pass in both ctx and req. Would be cleaner just to pass in req,
>> and 2 out of 3 spots always do (req->ctx, req) anyway.
> 
> That's because __io_submit_flush_completions() should already have
> ctx in a register and we care about its performance. We can add
> a helper if that's an eyesore.

Yeah I realize that, just bothers the eye. Not sure it really matters as
we're going to pull that cacheline hot in io_kiocb anyway.

We can just leave it for now, it's not a big deal.

-- 
Jens Axboe

