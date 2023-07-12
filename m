Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7AA750BF0
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 17:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbjGLPKq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 11:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjGLPKp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 11:10:45 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4412103
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 08:10:27 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-346636b9761so2916545ab.0
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 08:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689174624; x=1691766624;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wj4QF04GqhfOXgZJMhxX0dNs4/SeSh8zekCeq3JhY6c=;
        b=eKp/sXs6Ml16YA4OH/lW4DNToyGScZHnMnfPYDFmhHAQgA2lAGDlOM25FFJEO8L+7A
         YgCULt/hhJ6QiwITARC9bKlXBI7jTuU4Wii5cj8JR+cOMVeDRzoYHl2iP66U9RVNVHB5
         Kw6tF8MMDal1eg8hFM6Ul1Oke6Q54fCx556iUuIKUT+TI/bhFaCqyeKAZ8aLIf2HQiU4
         oS+1Natvid4McB1vsKSOu0U/NOpwQ6eKpp5N3mXpDdrPJ7LhIbneOy0b0BUkiic+5ZHJ
         yeA6jq/LQHAbtOzLKsallr8luwe4DrXI7eH+WgqZ9ODOOaNh6/uVdpViuVokMniUEXKd
         sQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689174624; x=1691766624;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wj4QF04GqhfOXgZJMhxX0dNs4/SeSh8zekCeq3JhY6c=;
        b=eMxhYH8svgsd1+tohD4IyQXNqkRb9M+yjQK19+j1GUqCexeECOy6R7B1FJLZpsoGpp
         FMKAi2106Ig28qponsUYN/4UAUHFO9v76JcWR2qVDho2qDN19oo2m5aDTlQi9hqkuwxX
         MAqvQ21P/ZQhZvlSNWwa61kskScPwddglbkT36oq7aiPbzxA4e7naZ+8+nothXz7Xd03
         WBtfQabDkoziylN63IIqrPw9tLLtL5MyDTg+BReAoP5w5HtBCrGZxjb0uA+ZfzBnGDm4
         YKGSM+0qWKx+2MXybNi9ANQXqrOg8cfYV1oYF4BQAjNNs8X0wVam+FDS1OK0wQCjNSLr
         ildw==
X-Gm-Message-State: ABy/qLbqiSmgcPsabD1Potgi/rUioO5UTkepY29klB1ODXjV92ggxPxN
        ohwaw3z9+t7quUSc71U1Q4zQnw==
X-Google-Smtp-Source: APBJJlFz9hDdB5LE4AQRO6QY4eCL9IIK0r/ENpBZTtRFvn/hT3E/u+TSgEV3F6rjZTaWcCzZGKap3w==
X-Received: by 2002:a05:6e02:e04:b0:345:e438:7381 with SMTP id a4-20020a056e020e0400b00345e4387381mr15577306ilk.2.1689174623958;
        Wed, 12 Jul 2023 08:10:23 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id i15-20020a92c94f000000b003460bb48516sm1368429ilq.67.2023.07.12.08.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 08:10:23 -0700 (PDT)
Message-ID: <0ffd2e2f-a179-393b-bd0d-cd62a41ecb92@kernel.dk>
Date:   Wed, 12 Jul 2023 09:10:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 7/7] io_uring: add futex waitv
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com
References: <20230712004705.316157-1-axboe@kernel.dk>
 <20230712004705.316157-8-axboe@kernel.dk>
 <20230712093152.GF3100107@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230712093152.GF3100107@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/12/23 3:31?AM, Peter Zijlstra wrote:
> On Tue, Jul 11, 2023 at 06:47:05PM -0600, Jens Axboe wrote:
>> Needs a bit of splitting and a few hunks should go further back (like
>> the wake handler typedef).
>>
>> WIP, adds IORING_OP_FUTEX_WAITV - pass in an array of futex addresses,
>> and wait on all of them until one of them triggers.
>>
> 
> So I'm once again not following. FUTEX_WAITV is to wait on multiple
> futexes and get a notification when any one of them wakes up with an
> index to indicate which one.

Right

> How exactly is that different from multiple FUTEX_WAIT entries in the
> io_uring thing itself? Admittedly I don't actually know much of anything
> when it comes to io_uring, but isn't the idea that queue multiple
> 'syscall' like things and get individual completions back?
> 
> So how does WAITV make sense here?

You most certainly could just queue N FUTEX_WAIT operations rather than
a single FUTEX_WAITV, but it becomes pretty cumbersome to deal with.
First of all, you'd now get N completions you have to deal with. That's
obviously doable, but you'd probably also need to care about
cancelations of the N-1 FUTEX_WAIT that weren't triggered.

For those reasons, I do think having a separate FUTEX_WAITV makes a lot
more sense. It's a single request and there's no cleanup or cancelation
work to run when just one futex triggers. Tongue in cheek, but you could
also argue that why would you need futex waitv support in the kernel,
when you could just have N processes wait on N futexes? We can certainly
do that a LOT more efficiently with io_uring even without FUTEX_WAITV,
but from an efficiency and usability point of view, having FUTEX_WAITV
makes this a lot easier than dealing with N requests and cancelations on
completion.

-- 
Jens Axboe

