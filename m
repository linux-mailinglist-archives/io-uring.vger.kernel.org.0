Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02BE3B2ED4
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 14:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFXMY1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 08:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhFXMY0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 08:24:26 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47CBC061574;
        Thu, 24 Jun 2021 05:22:07 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id t11-20020a1cc30b0000b02901cec841b6a0so4768826wmf.0;
        Thu, 24 Jun 2021 05:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hLhsABdAx0Xsmj9MOPP942v7TyxXPvs6X5/ccjBOw5Y=;
        b=pkhTpV144GXJgDUoTud8USOZtxEdfdJ94B77TJTnoND95iep1qiFVbY67v0fPB2Jan
         x/lFWEKooGEriqcLK6KrQEwIClsPtQQMAjGoIMCPsNg2PDuJ1R2uVIVUMXfFTdTdVQzD
         WKr5KI3vLwJskMCRHsZ4SZkizviIREUZbSOr9/5LGdIMBAkr4ir93bsp/dKpU/q+SZaX
         dafF2SNV0iL+mHtUbc/sMwa96zBBytHB0OefJOAAxCLdRPOW7LJ19QFkiJCC1YlGckIg
         UfeLcuJg4x2yfp57hf/9c++fv3hroMpGl+iM1KfXMyYzQcOYAdW7CfsUvCiI0k/EjpUx
         2YRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hLhsABdAx0Xsmj9MOPP942v7TyxXPvs6X5/ccjBOw5Y=;
        b=nt/Ott+dVZvwMD0MgkY+9mJdLBuy3u13dBio6LLq2tM4A2XjO40mmYr47MqFYMPGLG
         JmM/vERUE2sOeLkcolbwjHb3+2++vTLZ0Mel9BJL1CojGca3f8sAc7AcyClmDuH0meAZ
         mf1smaF8cvcdBxx6K+EJY2swnDqh1aNs48G8r5upRLv6KDcBZUrh8AgEoWg4hWNi8YJ3
         X5TC2vjtA2P2Tb4kmh/kuImZkzAQNjQvjAgLa3Rua/+AwrNmmvyrVa4w1oh3yV2nIfgs
         fa4urvmDndOGVfrvH/+lEWrZofxEEzNQ8MKz2Pgxc97DLDK5aCmpQ5A5NfAEOlfiXcil
         qrTg==
X-Gm-Message-State: AOAM532kptuu1wAAqIjMJ34+JoyD6IZ4gT1K/Ndzgeqr3bVTQLr8M5JP
        Xi60D+o631ZsyzSPYMnatY9Q3cz3B4VN8LbC
X-Google-Smtp-Source: ABdhPJxzRgctJn6NygdWrLjommXSXDqvFNrRc5koTW0b7Ebf5x/fL75XidgTxFG+NkbSTWlYKWxIOA==
X-Received: by 2002:a05:600c:2c4a:: with SMTP id r10mr3977500wmg.162.1624537325951;
        Thu, 24 Jun 2021 05:22:05 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id i9sm2953873wrn.13.2021.06.24.05.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 05:22:05 -0700 (PDT)
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-3-dkadashev@gmail.com>
 <c079182e-7118-825e-84e5-13227a3b19b9@gmail.com>
 <4c0344d8-6725-84a6-b0a8-271587d7e604@gmail.com>
 <CAOKbgA4ZwzUxyRxWrF7iC2sNVnEwXXAmrxVSsSxBMQRe2OyYVQ@mail.gmail.com>
 <15a9d84b-61df-e2af-0c79-75b54d4bae8f@gmail.com>
 <CAOKbgA4DCGANRGfsHw0SqmyRr4A4gYfwZ6WFXpOFdf_bE2b+Yw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
Message-ID: <b6ae2481-3607-d9f8-b543-bb922b726b3a@gmail.com>
Date:   Thu, 24 Jun 2021 13:21:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA4DCGANRGfsHw0SqmyRr4A4gYfwZ6WFXpOFdf_bE2b+Yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/24/21 12:11 PM, Dmitry Kadashev wrote:
> On Wed, Jun 23, 2021 at 6:54 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 6/23/21 7:41 AM, Dmitry Kadashev wrote:
>>> I'd imagine READ_ONCE is to be used in those checks though, isn't it? Some of
>>> the existing checks like this lack it too btw. I suppose I can fix those in a
>>> separate commit if that makes sense.
>>
>> When we really use a field there should be a READ_ONCE(),
>> but I wouldn't care about those we check for compatibility
>> reasons, but that's only my opinion.
> 
> I'm not sure how the compatibility check reads are special. The code is
> either correct or not. If a compatibility check has correctness problems
> then it's pretty much as bad as any other part of the code having such
> problems, no?

If it reads and verifies a values first, e.g. index into some internal
array, and then compiler plays a joke and reloads it, we might be
absolutely screwed expecting 'segfaults', kernel data leakages and all
the fun stuff.

If that's a compatibility check, whether it's loaded earlier or later,
or whatever, it's not a big deal, the userspace can in any case change
the memory at any moment it wishes, even tightly around the moment
we're reading it.


> That said, I'll just go ahead and use the approach that the rest of the
> code (or rather most of it) uses (no READ_ONCE). If it needs fixing then
> the whole bunch can probably be fixed in one go (either a single patch
> or a series).
> 
> Thanks for your help, Pavel!
> 

-- 
Pavel Begunkov
