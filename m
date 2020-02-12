Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25C2415AAD9
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2020 15:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgBLOUG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 09:20:06 -0500
Received: from mail-io1-f44.google.com ([209.85.166.44]:43246 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727732AbgBLOUG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Feb 2020 09:20:06 -0500
Received: by mail-io1-f44.google.com with SMTP id n21so2368136ioo.10
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2020 06:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/RU7AjymT+Kqd/mBfrnw3xV4wkHrtPAHX9pVDjDYQ+M=;
        b=BNEqOb51BEsO2mFX7n1/aVM1O2wgXhqtJsdhNpN4Q2wUpkJINctcU6UvQ3Wz7LOydR
         pJNUU308iGE+PDL9D1lgRd0Ao/RkBLJ1r2U73cOAN4i/9Xr0uzcDk9KseERcNW3PKnqw
         3vm5qkcdpbfpk3Uf5lRkHF+Fs+GGBUlXf/aK7NeQAgOKtD1vJSTEAT+YvmfxBfmBlQi9
         QdflsZhdZ/kGf8L2cvcXgawIGY1zGHWjjPv04YjSb6bG5w8ZWaoabpHtS0/CrtXPGdXZ
         MDs9f7RADFWXd+yfP04x3j6XzFs/kNbLjHGXQH8CVU9SO0jaMolEzDc6MSxGqpH4HS+Z
         KZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/RU7AjymT+Kqd/mBfrnw3xV4wkHrtPAHX9pVDjDYQ+M=;
        b=kPQE2NpL6GyfWi/P11gxxswKewxIP4y+Nc24ADoHGN9GBmJPiRJBrT8ii5WWlucAA5
         d/0EcoUS/jHpcwWeiOBPrhFIyULKqpquvDchlMd2xkM2Lqgu8y13WyLVdSe9X6vcsoyW
         OSrinjsf3CjqzKuvShPgoDnqmaMtv7AK3BHlE0XpiOp5faqWT2F5/to7j85m5tqT+ZWS
         7BJVx57rfjkel3ABiSazAO3jvFG1WnqbFcKGo0wsbTvHzX517YgPbkPzcv35D0zdefAd
         mVGDgnKWk7RS1rmh91AzKDMNOSdShoOpaHfDgbFpzFzM55riwBrM5rwrkOtSgxzEtW0k
         pt5Q==
X-Gm-Message-State: APjAAAW2LCozV88djr1uB0t07aKA2cePqQs4+TmnmlLfad5EzhzVFFnz
        bRhRqgMuPXqmnI3lBYlpsBwPHw==
X-Google-Smtp-Source: APXvYqz5km12ToSIwVOEv/LfPaEmODTjBva2OZ5RT8e7y2qIN3/EsNnvIVdBszBhciNYVJVDeq2HoA==
X-Received: by 2002:a05:6638:72c:: with SMTP id j12mr19383060jad.136.1581517205818;
        Wed, 12 Feb 2020 06:20:05 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w24sm153831ilk.4.2020.02.12.06.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 06:20:04 -0800 (PST)
Subject: Re: how is register_(buffer|file) supposed to work?
To:     Glauber Costa <glauber@scylladb.com>, io-uring@vger.kernel.org,
        Avi Kivity <avi@scylladb.com>
References: <CAD-J=zbYp0D5NSV1hqxpU7C-Ki+ffwretuXEYCxX5cbazA5WqQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bc739db5-9dac-dc6d-ef14-aef269864598@kernel.dk>
Date:   Wed, 12 Feb 2020 07:20:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zbYp0D5NSV1hqxpU7C-Ki+ffwretuXEYCxX5cbazA5WqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/20 9:12 PM, Glauber Costa wrote:
> Hi,
> 
> I am trying to experiment with the interface for registering files and buffers.
> 
> (almost) Every time I call io_uring_register with those opcodes, my
> application hangs.
> 
> It's easy to see the reason. I am blocking here:
> 
>                 mutex_unlock(&ctx->uring_lock);
>                 ret = wait_for_completion_interruptible(&ctx->completions[0]);
>                 mutex_lock(&ctx->uring_lock);
> 
> Am I right in my understanding that this is waiting for everything
> that was submitted to complete? Some things in my ring may never
> complete: for instance one may be polling for file descriptors that
> may never really become ready.
> 
> This sounds a bit too restrictive to me. Is this really the intended
> use of the interface?

For files, this was added in the current merge window:

commit 05f3fb3c5397524feae2e73ee8e150a9090a7da2
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Dec 9 11:22:50 2019 -0700

    io_uring: avoid ring quiesce for fixed file set unregister and update

which allows you to call IORING_REGISTER_FILES_UPDATE without having to
quiesce the ring. File sets can be sparse, you can register with an fd
of -1 and then later use FILES_UPDATE (or IORING_OP_FILES_UPDATE) to
replace it with a real entry. You can also replace a real entry with a
new one, or switch it to sparse again.

This helps the file case, but the buffer case is the same as originally,
it is intended to be used at ring setup time, not really during runtime.
As you have found, it needs to quiesce the ring, hence if you have any
requests pending, it'll wait for those. If they are unbounded requests
(like poll, for instance), then it won't really work that well.

That said, there's absolutely no reason why buffer registration can't
mimick what was done for file updates - allow registering a larger
sparse set, and update buffers as you need to. The latter without
needing a quiesce. The above commit basically just needs to be
implemented for buffers as well, which would be pretty trivial.

-- 
Jens Axboe

