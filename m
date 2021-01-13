Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC22A2F4E7C
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 16:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbhAMPZO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jan 2021 10:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbhAMPZN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jan 2021 10:25:13 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2722AC061575
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 07:24:33 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id a6so1959672wmc.2
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 07:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hvSWlyNEK47leFNFgNTP3gSBWMLlAFh5LWE31LeSECE=;
        b=PdRBb7e2y/dAHW7r4Xd2t4vydv0cmSawDYWlPM9bHjkzZme6VhiLEgophcJ1Vdw3pk
         U2WVSjL28MbaJd9EOEL729eTiGFU2Dk4LbIBlLVhBZpxdVLYclzGGwAjgzkr5YXxqzfD
         XQ8VdArGYvKk1vWT+J8Xqhi1IPhbrlOpFAuhYzruMmpYszLJCuC+mLXRb2QjkTdX/DRC
         I67/Rnw0S+1I2JFERJmcFWaN1GqhW2gPI1hVIdbLkSBhgcLspCpuuAUhapzAQpfhEvio
         I367BHg3JITyZQkdnBnjVxsjD2BxqZgXiSlk/a6Zf7ieAZ2jl6hzyh/bTWPGz10/PtNj
         Uyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=hvSWlyNEK47leFNFgNTP3gSBWMLlAFh5LWE31LeSECE=;
        b=CMdPtZjJN5Z/rVbjkb40MnuXb+0PXfZj1mHwbTsZu6i9rDbJsZz9Thdt/oD55S5Nzi
         Rhzgz2HPy1wPRIp5J5II+hWHdim8Qca3riRQEUy8oWnQcDtrLdzwYhczvOVP9tfC9sLI
         1Jn/97pKXGZvuRqOhhikw3XIFunnQSd9970hnsfj0WI9rCU+oNDOgkfl39ezgFYSTUP2
         ZsEV2lgWUQwwCIqzlinU2C2Q3nEQ3l9v90OuI99WfeHCKT0xMwfe/BjastxeSDCl/PBg
         OT5yDWgtjNjAD0Lan1eszKmtdy50b0Ru1kbMcVXDJy3rlbUcx9wd3+nF3eBsCg89NW+m
         NVzw==
X-Gm-Message-State: AOAM530Svn0CV7yO6qJB4Gdok9MwgloOr1bBq70aRO87nziERpbj/IMm
        n00MCHkYl5sl/fTqJgHEq/bRweB45FE=
X-Google-Smtp-Source: ABdhPJxH6kdAvoGXA5kXnphh6VYLFvKQBqDh0Li7qOlE0mie29+uqJSidXtE/lwgNMLskCCSqjaisA==
X-Received: by 2002:a1c:804a:: with SMTP id b71mr2717331wmd.21.1610551471560;
        Wed, 13 Jan 2021 07:24:31 -0800 (PST)
Received: from [192.168.8.122] ([85.255.235.134])
        by smtp.gmail.com with ESMTPSA id y11sm3272825wmi.0.2021.01.13.07.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 07:24:30 -0800 (PST)
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <20201219191521.82029-1-marcelo827@gmail.com>
 <20201219191521.82029-3-marcelo827@gmail.com>
 <d3feb2bc-b456-d057-e553-af024b234d31@gmail.com>
 <c0cde7df-f19f-92fd-e0f6-855396d126ab@gmail.com>
 <20210108155726.GA8655@marcelo-debian.domain>
 <257c0977-2546-adeb-5e04-6b41ced792c7@gmail.com>
 <20210113144114.GA64157@marcelo-debian.domain>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 2/2] io_uring: flush timeouts that should already have
 expired
Message-ID: <05cfac9b-f9c8-3b03-2b73-5935f79a0b5c@gmail.com>
Date:   Wed, 13 Jan 2021 15:20:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210113144114.GA64157@marcelo-debian.domain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/01/2021 14:41, Marcelo Diop-Gonzalez wrote:
> On Tue, Jan 12, 2021 at 08:47:11PM +0000, Pavel Begunkov wrote:
>> What about the first patch about overflows and cq_timeouts? I
>> assume that problem is still there, isn't it?
> 
> Yeah it's still there I think, I just couldn't think of a good way
> to fix it. So I figured I would just send this one since at least
> it doesn't make that problem worse. Maybe could send a fix for that
> one later if I think of something

sounds good to me

>>> +		events_needed = req->timeout.target_seq - ctx->cq_last_tm_flush;
>>> +		events_got = seq - ctx->cq_last_tm_flush;
>>> +		if (events_got < events_needed) 
>>
>> probably <=
> 
> Won't that make it break too early though? If you submit a timeout
> with off = 1 when {seq == 0, last_flush == 0}, then target_seq ==
> 1. Then let's say there's 1 cqe added, so the timeout should trigger.
> Then events_needed == 1 and events_got == 1, right?

Yep, you're right. I had in mind

@target in [last_flush, cur_flush], and so

(!(target - last_flush <= cur_flush - last_flush))
	break;

but that's same but reshuffled. Thanks for double checking. 

>> basically it checks that @target is in [last_flush, cur_seq],
>> it can use such a comment + a note about underflows and using
>> the modulus arithmetic, like with algebraic rings
-- 
Pavel Begunkov
