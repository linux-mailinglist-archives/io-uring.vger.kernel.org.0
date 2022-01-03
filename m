Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA6B483417
	for <lists+io-uring@lfdr.de>; Mon,  3 Jan 2022 16:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbiACPWa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Jan 2022 10:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiACPW3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Jan 2022 10:22:29 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AC8C061761
        for <io-uring@vger.kernel.org>; Mon,  3 Jan 2022 07:22:29 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id h23so30560591iol.11
        for <io-uring@vger.kernel.org>; Mon, 03 Jan 2022 07:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a0cR/6w8uqwzTMG+CuX313qBRCEM9+65JVhVSxfZXSI=;
        b=pFpeojOrh358OHZlb6AmXhZw9zsHYcd3g6zZZS5Dp9TMt/5ZzkhOpdO75RDTXCEDJE
         fm2ComG8Jm45tJ76qDylJvQAZVZPSvaYr4bpl/8tq+H0G94eXiGbGMPxpqX2B/q6vWSr
         CyAqCYLJ+pqvbxKQKCBqUEtAjj7XZlrp2ne7kMLIJxO0Rckd8IGamlhh8ILqVtFEjB9Q
         TpQQ5lh+Js6ovT48AUkumjGypnhK90V6yKPmMVTZCUvxl5k2c+T+esisfXxdvK7iAGJ/
         J+5336tCmPKgC67OmPthw2J3PkPteaMOMM1uOi/N3ehz+8AwDC4HcUgYFNX//Tld14sn
         pPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a0cR/6w8uqwzTMG+CuX313qBRCEM9+65JVhVSxfZXSI=;
        b=CZmvIkEstyIw1vTiCvU3fsKSE7vnfqd20bzcT6E+KYp6CILSpRN73ByRrF6HyJR70M
         urlTz36xStLQp99XO/X5zAeHQp1X0NtyBNBtZp8ru9VjDL578f73r5E5v0I1y8vxbX5V
         fsbFlu4fq/kCtmBt+ChaKuxsrFoCeAoKsztlAVzDqvcAZviibD7c1bEMaYKCvz57fZMl
         gtEgBLtAJjzazMK5oCkNqZj4yJsMeg5kiOB5czmxXUNx1DrppBPx+yGAdH8kcwl0HQab
         5r6XqHaSQKVIUb7BJ8NDf8reHkLF4Nowu+M2BBLYs5I64p2FQSQygaBOrW8/cU44b2HT
         2dEw==
X-Gm-Message-State: AOAM532FPGNSxV+9Dd6LJ9bkdrP7ZBPfbZas7ULtHrv9AVB9BLR2Dmmr
        C1BtL/sH1T0r7F9CB5/kNtDVRUmwp6C8AA==
X-Google-Smtp-Source: ABdhPJxyiONubxQ+zDbq9p/0xpcsRrUXA3tP4jaSBMdlWHgb2z8P7/Do86VsXzbeerzGqmVmJnglUQ==
X-Received: by 2002:a05:6638:1410:: with SMTP id k16mr19255535jad.224.1641223348564;
        Mon, 03 Jan 2022 07:22:28 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k7sm23749948iov.40.2022.01.03.07.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 07:22:28 -0800 (PST)
Subject: Re: [PATCH RFC] io_uring: improve current file position IO
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <8a9e55bf-3195-5282-2907-41b2f2b23cc8@kernel.dk>
 <CAG48ez3ndoSC=fRvmzku1hLkO99RPwA3F3PA5mVZ47AkU5q-5A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0cb60924-b92c-8844-4ec7-1219fcef08df@kernel.dk>
Date:   Mon, 3 Jan 2022 08:22:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez3ndoSC=fRvmzku1hLkO99RPwA3F3PA5mVZ47AkU5q-5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/3/22 7:17 AM, Jann Horn wrote:
> On Fri, Dec 24, 2021 at 3:35 PM Jens Axboe <axboe@kernel.dk> wrote:
>> io_uring should be protecting the current file position with the
>> file position lock, ->f_pos_lock. Grab and track the lock state when
>> the request is being issued, and make the unlock part of request
>> cleaning.
>>
>> Fixes: ba04291eb66e ("io_uring: allow use of offset == -1 to mean file position")
>> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> Main thing I don't like here:
>>
>> - We're holding the f_pos_lock across the kernel/user boundary, as
>>   it's held for the duration of the IO. Alternatively we could
>>   keep it local to io_read() and io_write() and lose REQ_F_CUR_POS_LOCK,
>>   but will messy up those functions more and add more items to the
>>   fast path (which current position read/write definitely is not).
>>
>> Suggestions welcome...
> 
> Oh, that's not pretty... is it guaranteed that the

Right, hence why it's an RFC :-)

> __f_unlock_pos(req->file) will happen in the same task as the
> io_file_pos_lock(req, false), and have you tried running this with

It might unlock from a thread off that task, depends on how the execution
happens. And as it stands, it'll also potentially exit the kernel with
the lock held until it completes.

> lockdep and mutex debugging enabled? Could a task deadlock if it tried
> to do a read() on a file while io_uring is already holding the
> position lock?

lockdep will complain about the leaving the kernel with it held aspect
for sure.

I think the better solution here is, as I suggested in the patch, to
keep it local to io_read() and io_write() rather than try and track it.
Which is a bit annoying in terms of adding mostly useless code to the
fast path, but... Don't think there's a better way.

-- 
Jens Axboe

