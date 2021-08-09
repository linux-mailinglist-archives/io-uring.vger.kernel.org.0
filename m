Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA273E4DF0
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 22:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbhHIUfs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 16:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbhHIUfs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 16:35:48 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3B4C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 13:35:27 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b13so23094614wrs.3
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 13:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oK1IlwIEGrTNJrwZnR1U0Xkp6WU/RPcaHU/8yp/s9H0=;
        b=rK5gbGgM4DYDYnO+yuugoYyfl66c9OtTjPlNRVpAD+Bt9Qr43BSGiRDg00Fdjqfo9I
         DOcx/IikZPZHtq2sXOEgAWDmjF9TUAtgARqZdDAZ5yVASWuYWAHQ4iTL/2prclpiIrno
         0fZOXdGoYsqKiW6MAOYHsiOsyo9ADe5pA82F0MsvKRxBSTQrdhMdxZ8J0F5rX9CZvGpj
         zDc76Ni59ro/JOZfWTgl7C4tQt/+AcImTa0H2Ffc9JDEfYfCyrLD3T4QFa7lk9jHO/LC
         06S0wQdvYMKqyRptTalm0Lf563XUEuBFL/vCqWBCyn1JmSfkKOHf3KaNO8unGLE2sT/o
         e9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oK1IlwIEGrTNJrwZnR1U0Xkp6WU/RPcaHU/8yp/s9H0=;
        b=SZzG88ei3XxI+ymDQRDpuIlZslzkJYL7KzP127ghCNezJsuUq47SAjbe9N3xxuUo9d
         qQURRQoUPGvOoJUNZ3Z+Z6CtqgzMl4z6BjoJgDOuVabGbTBMlxUrIsWmOeBlbIUSERZ3
         jOFiNWgx+FpzfZueWg2x2+v/sK2eIC9Qat0dQIBkt4omEG0PV+OzOzhVyqt0ygJDwXu9
         3B/lfgoEwauSQTp54qXpwcNVzyxd1Ed61zVMmsW53riUFKv1LCWG/p/0xEsDqNfXKrYJ
         F/7oxHvRK8drLpbPsykL1ocKjIO9ocLqQos/y5HN8mz6D91FQxry1lkdxdZqBC11417i
         7+fw==
X-Gm-Message-State: AOAM531J4RFmLLvOHmfPhJSkSgz9+nRwQS4qRP6nboJBauGP24u6yEzG
        1T7Dy7hHcSPbPI3Xcq6CZIo=
X-Google-Smtp-Source: ABdhPJw4m6peY2KKn1/HDSv5EvHZjvinmAE5n3EIFesIp0u1kxkpKS691FRzdlgQ+Vd3rio0nM5vvw==
X-Received: by 2002:adf:d085:: with SMTP id y5mr26639720wrh.272.1628541325850;
        Mon, 09 Aug 2021 13:35:25 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id h4sm6182957wrt.5.2021.08.09.13.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 13:35:25 -0700 (PDT)
To:     Olivier Langlois <olivier@olivierlanglois.net>,
        Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210805100538.127891-1-haoxu@linux.alibaba.com>
 <20210805100538.127891-3-haoxu@linux.alibaba.com>
 <cc9e61da-6591-c257-6899-d2afa037b2ad@kernel.dk>
 <1f795e93-c137-439e-b02c-b460cb38bb14@linux.alibaba.com>
 <5f4b7861-de78-8b45-644f-3a9efe3af964@kernel.dk>
 <a7a07d78e8a24612c7afd4ada4a05d462798fb8b.camel@olivierlanglois.net>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/3] io-wq: fix no lock protection of acct->nr_worker
Message-ID: <e833926d-532d-d234-909b-a5a9ce0c854b@gmail.com>
Date:   Mon, 9 Aug 2021 21:34:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <a7a07d78e8a24612c7afd4ada4a05d462798fb8b.camel@olivierlanglois.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 9:19 PM, Olivier Langlois wrote:
> On Sat, 2021-08-07 at 07:51 -0600, Jens Axboe wrote:
>>
>> Please do - and please always run the full set of tests before
>> sending
>> out changes like this, you would have seen the slower runs and/or
>> timeouts from the regression suite. I ended up wasting time on this
>> thinking it was a change I made that broke it, before then debugging
>> this one.
>>
> Jens,
> 
> for my personal info, where is the regression suite?

liburing/tests.

There are scripts for convenience, e.g. you can run all tests once with

`make runtests`

or even better to leave them for a while executing again and again:

`make runtests-loop`

-- 
Pavel Begunkov
