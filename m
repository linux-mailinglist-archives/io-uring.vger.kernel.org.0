Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF56169CBF
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 04:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBXDwa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 22:52:30 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:33911 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgBXDwa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 22:52:30 -0500
Received: by mail-pg1-f181.google.com with SMTP id j4so4424497pgi.1
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 19:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y59ovc0W2O5AuApJ8f3Qxzk/LdrpQY4yIXl4xCWnCv4=;
        b=dhFNE0+49/XP7TcSKQnvivaAKieaHM5EyP3m9yD0NWWdOSoAmmtQk/aRxKeLIPr0Dv
         9CLJnGklv/nuwkrwo0iChUU6UJhnCVQumdpQb9Vw9TLUvwBuEKVYbx/JH/Agi9nDCKEn
         lZY5fmVNdxqGM7Nx1zdOK0CXKA1rXVPrGTmAbh36vyS2znpD0GYa/fg/w9VRDk2YfT3S
         AneHXVJJrnFeiiLkvwE/kLPQPk9VJsf2hMP79EmvPTPTBJQcBKYS0JJZKjPURSz6yf0G
         NJp/bKfHiy+StnvdAWgtSC3kxUmogm2oqQyi6hhr8mXkltjM0lYz0xR7B1mouWohkwPk
         bYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y59ovc0W2O5AuApJ8f3Qxzk/LdrpQY4yIXl4xCWnCv4=;
        b=BIinxFZjhIDOUJ8ZrZnHPrfrvacFHV2WfdophXEcMdk/iLK987jCYSDXwb0K9Hpwhk
         +mcI2l/sWSiTzPBq3RdJDbU8ZSIvrXTi0Z+JyuUlr76pn2Ih/IbZ8vrEaNDcCXOgRrC1
         gxFf0kZg9PesvmiEkWcyMoLAploUj/BIWXWZVy3zi3ki8dzvltYqfNk/gtHjqBT5zTww
         dvh2qq/rt88iNZFkzvO+QpzFvgtidUYsICU0daVbj5bs1kGXcx6+M9T7zI5TZ1SgcZx2
         tUipjp0HTFj8CkZI+LiFJzpEEQfz0j0K51oGZg+ZERkZLZZw6EYT6+VHaV7WYD02qVhM
         8OBw==
X-Gm-Message-State: APjAAAX0oBvWWoI28d5zJEIonD9L0wJJ3NlBbyXaI5dKTD0w45O35Bxy
        CMSyb5jBXH8OKB1VP+E4DVwnXJqo0QU=
X-Google-Smtp-Source: APXvYqxtJYQJq3v475I/KO1M/jYoXp00RW/WaQn6iHbRiSdd2EAz+t5Fm8MvjXQrR4RnAgC0Lnoo9A==
X-Received: by 2002:a63:60a:: with SMTP id 10mr45050302pgg.302.1582516349406;
        Sun, 23 Feb 2020 19:52:29 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id c1sm10533739pfa.51.2020.02.23.19.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 19:52:28 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
Date:   Sun, 23 Feb 2020 20:52:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/20 8:33 PM, Andres Freund wrote:
> Hi,
> 
> On 2020-02-23 20:17:45 -0700, Jens Axboe wrote:
>>> that seems a bit unnecessary. How about breaking that out into a
>>> separate function?  I can write up a patch, just didn't want to do so if
>>> there's a reason for the current split.
>>>
>>>
>>> Alternatively it'd could all be just be dispatches via io_op_defs, but
>>> that'd be a bigger change with potential performance implications. And
>>> it'd benefit from prior deduplication anyway.
>>
>> The reason for the split is that if we defer a request, it has to be
>> prepared up front. If the request has been deferred, then the
>> io_issue_sqe() invocation has sqe == NULL. Hence we only run the prep
>> handler once, and read the sqe just once.
> 
>> This could of course be compacted with some indirect function calls, but
>> I didn't want to pay the overhead of doing so... The downside is that
>> the code is a bit bigger.
> 
> Shouldn't need indirect function calls? At most the switch() would be
> duplicated, if the compiler can't optimize it away (ok, that's an
> indirect jump...).  I was just thinking of moving the io_*_prep() switch
> into something like io_prep_sqe().
> 
> io_req_defer_prep() would basically move its switch into io_prep_sqe
> (but not touch the rest of its code). io_issue_sqe() would have
> 
> if (sqe) {
>     ret = io_prep_sqe(req, sqe, force_nonblock);
>     if (ret != 0)
>         return ret;
> }
> 
> at the start.
> 
> Even if the added switch can't be optimized away from io_issue_sqe(),
> the code for all the branches inside the opcode cases isn't free
> either...

The fast case is not being deferred, that's by far the common (and hot)
case, which means io_issue() is called with sqe != NULL. My worry is
that by moving it into a prep helper, the compiler isn't smart enough to
not make that basically two switches. Feel free to prove me wrong, I'd
love to reduce it ;-)

-- 
Jens Axboe

