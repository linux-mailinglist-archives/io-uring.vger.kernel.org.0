Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1A52C98BB
	for <lists+io-uring@lfdr.de>; Tue,  1 Dec 2020 08:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgLAH4e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Dec 2020 02:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgLAH4e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Dec 2020 02:56:34 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C59C0613CF
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 23:55:48 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id e13so534015pfj.3
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 23:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uNMNU/yR47TiwpyMtUifHOozYUyNgo1UzfGJEzhmW9k=;
        b=CB0jODU0/X56pw2oJsFUt6jJV5fiwsbihQXNLTqYoqKK9zsQquow9XiEwae75fqk//
         thkjRXp/wnG8a7e4M4fioFixA8ST4OCZHY2e4MinYLe8PB+TQT1Z0V3I1XgBn9dLGjm0
         o43IvAkFtUDo1ukszYVYq7Tbka4BOXSgvgO+et5FXNwsLAW2DuWH7A0dCwEsEL2KFh3N
         Wi990yB2rUTPEFZVqtipgYgWHAuG24f+t7hbzTkGQ3ftgnrLtWWtCqyfNl4/4Ta+732N
         e10h3nRmwLtBIYFJ9JWtAWTtxjvTCx7SnlcBSGwFd159CUNA+hPnI46J/eekWALVeDx5
         +8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uNMNU/yR47TiwpyMtUifHOozYUyNgo1UzfGJEzhmW9k=;
        b=DK+kPPRfGea6Z93ngtxgW35Gk4atIgmss9tU2pW6h+r4vK6mI7TVTPEKHQ8lDZmu+s
         vogOPkDpggG2ULQNQrIFFXsiCX+VkfDqBZsfeuzxaAnXeGQ/HP67yh59j7gmVAV3P03t
         s+gw7E98geabw6nELJ+YcRM3FbrkiTKZAbgeaXuQe73F9mytsoBlPgnLlFyQ0YA8EBPL
         yg52zOyVT6T4/mm7IeKI7yXVBUcdwsQFTG3hIW7qWM9Ge8Tsl3p/zRro75aAGjk0ql3f
         Jkdve7XTipwmLnCL8G4MzR9A9O5qyo2KTjg1Ld/bK2RBaY/KvkQPva/8ucJlL1nYJQNt
         C3Dg==
X-Gm-Message-State: AOAM532H4hss7kpaQ7GbZgWTuUD7pTpu1any1ReLnW33NTPdGWmMFTTi
        J1iFXAl6lpZ7ITp3VagDX70I2A==
X-Google-Smtp-Source: ABdhPJxFZAztcjICfuRIAOH2zs0IVmkfSNykMdby3x8eXSQoK1c456I3KsGjVYeHj6L6KdXDIS/oUg==
X-Received: by 2002:a63:4648:: with SMTP id v8mr1291868pgk.248.1606809347720;
        Mon, 30 Nov 2020 23:55:47 -0800 (PST)
Received: from [192.168.10.23] (124-171-134-245.dyn.iinet.net.au. [124.171.134.245])
        by smtp.gmail.com with UTF8SMTPSA id y21sm1330257pfr.90.2020.11.30.23.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 23:55:47 -0800 (PST)
Subject: Re: [PATCH kernel] fs/io_ring: Fix lockdep warnings
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     lexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201130020028.106198-1-aik@ozlabs.ru>
 <44057e4a-9dd0-ddfa-70fd-8f6287de4e2d@gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <8616fff3-8a89-8316-3920-b33fb7db235c@ozlabs.ru>
Date:   Tue, 1 Dec 2020 18:55:41 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:84.0) Gecko/20100101
 Thunderbird/84.0
MIME-Version: 1.0
In-Reply-To: <44057e4a-9dd0-ddfa-70fd-8f6287de4e2d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 01/12/2020 03:34, Pavel Begunkov wrote:
> On 30/11/2020 02:00, Alexey Kardashevskiy wrote:
>> There are a few potential deadlocks reported by lockdep and triggered by
>> syzkaller (a syscall fuzzer). These are reported as timer interrupts can
>> execute softirq handlers and if we were executing certain bits of io_ring,
>> a deadlock can occur. This fixes those bits by disabling soft interrupts.
> 
> Jens already fixed that, thanks
> 
> https://lore.kernel.org/io-uring/948d2d3b-5f36-034d-28e6-7490343a5b59@kernel.dk/T/#t

Oh good! I assumed it must be fixed somewhere but could not find it 
quickly in the lists.

> FYI, your email got into spam.

Not good :-/ Wonder why... Can you please forward my mail in attachment 
for debugging (there should be nothing private, I guess)? spf should be 
alright, not sure what else I can do. Thanks,


-- 
Alexey
