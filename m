Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769C830F471
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbhBDOAV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 09:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbhBDN6P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:58:15 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DFDBC06178B
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:36 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id j11so3191382wmi.3
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uRbr47gfy43kyeCqR1yKouX7nRDGSFYKCmaboSC8Oj8=;
        b=nelWG+yMLS650zrWEwlBwNBp4fEF00jku+pC/nmk1TxEEnD5jFR3kwdqolOUb7uKeE
         RjPTF0VyXui/476FK5GACA5JXkrP7CM8QoF4BjM1Am1SJIulw2mR3xyaB7BVb24Cozzh
         /FdExnEiIyK96Jwn1U0u2FQ1jUhbYERZKXaSCaTMsh7iaKkFctsKknPy04354nkr4CeA
         2sCg/yDp+GETRAU7x9pu7oo41HEik6nStLlpmC6r8zdTKI95jV8s0nZoZOT1tvGZ+3F3
         HNvMBTQYeRuxnoVzRcKcRs87moYVtoalZ1rNenTwSj1cgfOyizJDUu9Nw/rvdixZhTlM
         XirQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uRbr47gfy43kyeCqR1yKouX7nRDGSFYKCmaboSC8Oj8=;
        b=FbL4sGJ+TyCp+YHF7GB6XFHXjNOaOC3DYPY/5ZyFibjS97AbZi3nS0VEmilhCqY+r/
         6LRQA3+Vm/e0Y1dRM7sRtFgdWGDPp7aZhfTKaEn6M7r8DZfzL2j53lwUt/0tWoh/d3J2
         EJOEKF6yKuG9nkFtYR0Vfmlyja3A/wObsUawfeJD+xZhr2eDLfywfBPUBxqBp04r00lq
         X4XZxifrc5FCFLHKhHPYwTlITZ1oLEcEe6UaS91XKMeusHOUps6tJWsP/3yBbsKq0u/i
         +RSQiFKaq74J0FhFMv3i0p78yqJ5RzNM6Wf4DabIauJbJH86hjHsBh9yvhIHI5Eb9Fvi
         TEsA==
X-Gm-Message-State: AOAM530h+dzzVuP8ZvgHxFDyjtGlwr4s1ME8CktdfFgPMOubY+l+AUfF
        mWIE0Ou8HOvp7oW2J4hT8UIHtI0UE4p4nw==
X-Google-Smtp-Source: ABdhPJwedjodDZdknBojsST8zsY+vN9N7w1VEYeokphfPEb1eMNEIEq+ofLpmbk/CRQjzRaB6TTjbA==
X-Received: by 2002:a05:600c:2252:: with SMTP id a18mr7349488wmm.167.1612446994706;
        Thu, 04 Feb 2021 05:56:34 -0800 (PST)
Received: from [192.168.8.175] ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id x22sm428382wmc.25.2021.02.04.05.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 05:56:33 -0800 (PST)
Subject: Re: [PATCH 0/8] a second pack of 5.12 cleanups
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1612223953.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <177ec0e1-f125-ab83-fc40-d53ceb899aab@gmail.com>
Date:   Thu, 4 Feb 2021 13:52:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1612223953.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/02/2021 00:21, Pavel Begunkov wrote:
> Those are a bit harder to look through.
> 
> 4-8 are trying to simplify io_read(). 7/8 looks like a real problem, but
> not sure if even can happen with this IOCB_WAITQ set.

extended v2 has been sent

> 
> Pavel Begunkov (8):
>   io_uring: deduplicate core cancellations sequence
>   io_uring: refactor scheduling in io_cqring_wait
>   io_uring: refactor io_cqring_wait
>   io_uring: refactor io_read for unsupported nowait
>   io_uring: further simplify do_read error parsing
>   io_uring: let io_setup_async_rw take care of iovec
>   io_uring: don't forget to adjust io_size
>   io_uring: inline io_read()'s iovec freeing
> 
>  fs/io_uring.c | 215 +++++++++++++++++++++++---------------------------
>  1 file changed, 97 insertions(+), 118 deletions(-)
> 

-- 
Pavel Begunkov
