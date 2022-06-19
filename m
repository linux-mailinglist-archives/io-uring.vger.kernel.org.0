Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE28550BEC
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 17:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiFSPuM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 11:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiFSPuM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 11:50:12 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DACBC94
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 08:50:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id hv24-20020a17090ae41800b001e33eebdb5dso10523951pjb.0
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 08:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=em/kIvLaVBYa5qjHgveKLQMO7prOUy+v0jOIHeOcrvg=;
        b=vMad+PA/zk5M6/Ut28TbQhJVVaYh9jBkR14qOrt5B6XtVVoxrkkW4mmdtzAP8ox2v0
         x/C5iYGuWSPRBEX9srh9t0jSDufo5a6yi089YVkkkEakjbdcvgiSYkHxhKbZXnPT553b
         PXfN66dQC2XFlo3D7FyBK8C+KN0j2B23I0qBHtB3lGHRpe0z+5zI8bSrIb/vtR19mIbO
         N1HX4Rt5L0PmFYCY/7YkIwo4ZpM0cHTAlsJXo5AcHBs1F+I7ez8gm3tfBBYiDcuWZaMo
         mtl9x2aUxOXpA2Xf9Y5oDz1jg4gCavHgJ5gWp17nSNcBElzI6TL50xD9ZRHwygsKaa1x
         8mug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=em/kIvLaVBYa5qjHgveKLQMO7prOUy+v0jOIHeOcrvg=;
        b=cMtZjTr9vd/4t3Og/ZzrcdUyKEke+m+QYzUqoUAa9vWQ9mfbbD31qFR6AtSi5INcT2
         r1ATo+tgc0JB2fhoIZH/0ZH78PkzHJ0OOauKF5xiAEcvauPVgj/ICbAMXHq64W+DKjD+
         0Ewz68cYyZXoIWB0f0u51SOCvBlm/7T2YSiW7Si+hHlJSobnhDmcl4+j7uyEvKpMHxpJ
         ELIh79xQeIj1HMcFAlhR2/lHYP7eTwA0DPS83fa1Z9Igf+lQ6EM3LOFeD+cUUGlS3meM
         Y57MDvT7JJLjtdQSj8WmIudsMyhgN9RV1NfWP61Oi4lOr5V7NGpBFLRXcxqSHAcBn8RG
         vjTg==
X-Gm-Message-State: AJIora8VOM+TxS1ti4DlTH45gwEjGMpSDOZAleZTDVZKu87rEzJOIqBj
        C0KkdMhBsJ8LgBUl5lZtEcdbK4PsGoCtNw==
X-Google-Smtp-Source: AGRyM1t39mf1kHLPCPudIE4JUuNhbMwNUzECTgAsgfht5hcYZsGf8OEMWxKQi4U4JKRdzdKoGJBIQA==
X-Received: by 2002:a17:903:1053:b0:16a:56d:3afa with SMTP id f19-20020a170903105300b0016a056d3afamr13050712plc.16.1655653810260;
        Sun, 19 Jun 2022 08:50:10 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j6-20020a17090a694600b001ec839fff50sm3153708pjm.34.2022.06.19.08.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 08:50:09 -0700 (PDT)
Message-ID: <0474590e-ec6a-d8dc-7554-7d9908fa6f4c@kernel.dk>
Date:   Sun, 19 Jun 2022 09:50:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 6/7] io_uring: introduce locking helpers for CQE
 posting
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655637157.git.asml.silence@gmail.com>
 <693e461561af1ce9ccacfee9c28ff0c54e31e84f.1655637157.git.asml.silence@gmail.com>
 <91584f2b-f7bb-ec20-8b27-62451e2b19e0@kernel.dk>
 <f967dcd4-9078-e5a4-4d0c-7a757e47aee4@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f967dcd4-9078-e5a4-4d0c-7a757e47aee4@gmail.com>
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

On 6/19/22 8:20 AM, Pavel Begunkov wrote:
> On 6/19/22 14:30, Jens Axboe wrote:
>> On 6/19/22 5:26 AM, Pavel Begunkov wrote:
>>> spin_lock(&ctx->completion_lock);
>>> /* post CQEs */
>>> io_commit_cqring(ctx);
>>> spin_unlock(&ctx->completion_lock);
>>> io_cqring_ev_posted(ctx);
>>>
>>> We have many places repeating this sequence, and the three function
>>> unlock section is not perfect from the maintainance perspective and also
>>> makes harder to add new locking/sync trick.
>>>
>>> Introduce to helpers. io_cq_lock(), which is simple and only grabs
>>> ->completion_lock, and io_cq_unlock_post() encapsulating the three call
>>> section.
>>
>> I'm a bit split on this one, since I generally hate helpers that are
>> just wrapping something trivial:
>>
>> static inline void io_cq_lock(struct io_ring_ctx *ctx)
>>     __acquires(ctx->completion_lock)
>> {
>>     spin_lock(&ctx->completion_lock);
>> }
>>
>> The problem imho is that when I see spin_lock(ctx->lock) in the code I
>> know exactly what it does, if I see io_cq_lock(ctx) I have a good guess,
>> but I don't know for a fact until I become familiar with that new
>> helper.
>>
>> I can see why you're doing it as it gives us symmetry with the unlock
>> helper, which does indeed make more sense. But I do wonder if we
>> shouldn't just keep the spin_lock() part the same, and just have the
>> unlock helper?
> 
> That what I was doing first, but it's too ugly, that's the main
> reason. And if we find that removing locking with SINGLE_ISSUER
> is worth it, it'd need modification on the locking side:
> 
> cq_lock() {
>     if (!(ctx->flags & SINGLE_ISSUER))
>         lock(compl_lock);
> }
> 
> cq_unlock() {
>     ...
>     if (!(ctx->flags & SINGLE_ISSUER))
>         unlock(compl_lock);
> }

OK, that makes sense, if the helper will grow further changes.

-- 
Jens Axboe

