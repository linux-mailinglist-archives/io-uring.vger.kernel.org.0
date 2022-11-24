Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A04637FA3
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 20:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiKXT3m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 14:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiKXT3l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 14:29:41 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CC96F817
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:29:40 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id x13-20020a17090a46cd00b00218f611b6e9so2321709pjg.1
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 11:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LVF2cTm7I1zQ/aUKf4MS5EGk/oKLg4JSZzIL2hPJIZQ=;
        b=Y2CD7SKEel0MG8uwR/Nh2SFggCVQqTTxFYx9ElP+JS+byyBadqSP77m44H3epluVFK
         bfQt3nMsO/AcbRm9tz3yJEfi8XD/l+VIkSri5wTUIkIjAbF/gDyL07CkvGXE5sTZmHsJ
         srXv0F1pOHpeu8Vnn2bxWWOPblES1kxRGuG3EsWAtrMBC1Ah/RpUKXBwT5NMxKPoA4cM
         VIyZW9VATttYOviJ00v3uoPA4WtrygZ0ZLM5Gi52oQRVl4sWa7BVRJjZNj7uu6sBq387
         rUMnBZKjbuO/UUxUhO29pZEUH/V0BIdSxkPxu556HNEtiPiefRsUuFDTRDcf/MejAApy
         v8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LVF2cTm7I1zQ/aUKf4MS5EGk/oKLg4JSZzIL2hPJIZQ=;
        b=htyOUG0Ouf1YOGfSwLl+GQGC+L8YDJ5Zl2BbhQYN2jtgJGyO8bDSWLpSvbs5MbSe8H
         P/vZ4HaskmVEmoK8us+Wd1Q4Gn/gM29ORwsUV14/io2TAscN2wFs7UuKELvqUkCFyg8E
         howwiOlanCcuuIBbYVBMQ/fuz1PP6L5rcRf+PQIfleM8ERgsFoFhc2WbV0fhzNhqFFjR
         v54t60SY7rQCOO4Ft3Cl6E3FLL+1D8gJRmeZ0WuAGJXKEv1mmGp5yLRfXGLs9mpJa4P8
         BJwUdBiE1afhreRp22weabBeA8Ut8hMHlOJ43rhV9/aMULlcN4B0P/bsjnKPEWaxWdJ/
         sivg==
X-Gm-Message-State: ANoB5pnr/Lu6OKU3786ecKdGs32jkbVBZ8+7dLKsTyD+jTRb+tAxMbQy
        u5L8K+912d5MRIdSuweTaWHZu/N9IatWzGPf
X-Google-Smtp-Source: AA0mqf4iYJVCRP+XhFbVoqWsaZlMKg28FOyGma7yZY0mfHKkYKE3jH6A0FHtsOD3TAKLNzHN3Dk5mw==
X-Received: by 2002:a17:90b:264a:b0:213:7030:f69a with SMTP id pa10-20020a17090b264a00b002137030f69amr36856055pjb.231.1669318180079;
        Thu, 24 Nov 2022 11:29:40 -0800 (PST)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id v2-20020a17090a0e0200b00218bd1745c5sm3545749pje.12.2022.11.24.11.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 11:29:39 -0800 (PST)
Message-ID: <672d1714-7bf6-db8e-39ae-daa7f155d2c4@kernel.dk>
Date:   Thu, 24 Nov 2022 12:29:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] io_uring: kill io_cqring_ev_posted() and
 __io_cq_unlock_post()
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <c09446bd-faca-13cc-97af-c06fa324e798@kernel.dk>
 <c03977b8-85a1-5984-ebda-8a0c7d0087d2@gmail.com>
 <bd80da09-a433-1ea6-6a0c-bbb335b5187d@kernel.dk>
 <40e17ac2-8c02-9d04-fab0-d7e29db89bab@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <40e17ac2-8c02-9d04-fab0-d7e29db89bab@gmail.com>
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

On 11/24/22 12:17?PM, Pavel Begunkov wrote:
> On 11/24/22 18:46, Jens Axboe wrote:
>> On 11/24/22 9:16?AM, Pavel Begunkov wrote:
>>> On 11/21/22 14:52, Jens Axboe wrote:
>>>> __io_cq_unlock_post() is identical to io_cq_unlock_post(), and
>>>> io_cqring_ev_posted() has a single caller so migth as well just inline
>>>> it there.
>>>
>>> It was there for one purpose, to inline it in the hottest path,
>>> i.e. __io_submit_flush_completions(). I'll be reverting it back
>>
>> The compiler is most certainly already doing that, in fact even
> 
> .L1493:
> # io_uring/io_uring.c:631:???? io_cq_unlock_post(ctx);
> ????movq??? %r15, %rdi??? # ctx,
> ????call??? io_cq_unlock_post??? #

Doubled checked here, and you're actually right:

    55bc:       94000000        bl      4760 <io_cq_unlock_post>                

Huh, that's very odd that it doesn't inline it. It doesn't even it I
mark it inline, __always_inline gets it done.

> Even more, after IORING_SETUP_CQE32 was added I didn't see
> once __io_fill_cqe_req actually inlined even though it's marked
> so.

Doesn't seem to be inlined here either. Compiler:

gcc (Debian 12.2.0-9) 12.2.0

>> __io_submit_flush_completions() is inlined in
>> io_submit_flush_completions() for me here.
> 
> And io_submit_flush_completions is inlined as well, right?
> That would be quite odd, __io_submit_flush_completions() is not
> small by any means and there are 3 call sites.

io_submit_flush_completions() doesn't get inlined,
__io_submit_flush_completions() gets inlined in
io_submit_flush_completions().

-- 
Jens Axboe
