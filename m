Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0184D333053
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 21:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCIUyT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 15:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbhCIUxr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 15:53:47 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D842C06174A
        for <io-uring@vger.kernel.org>; Tue,  9 Mar 2021 12:53:47 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id p16so15511713ioj.4
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 12:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rJvso/FFguiLtD45Ii/iXjsDN2u6oWhDHSHvausDuqY=;
        b=MB+G83mcZpLXm37lIgPIeXbIc2ZK2mE9MmBNl64Fjlvj8sIfqkjUJqF3z45U5eoatT
         vE0eCAbaJkcVHhxkefsiw5mq5Q0u19F1gWGRfUdkmK+I0ioySti3gOv4Uw2EK6veMzPZ
         OQVCOE8ZjB3i1CKBmq31QnxuXfhp4ckjcm6cWP/sC5rOxRrupmXP65ZOeIWU2bWwVewD
         zkvLU5TrfVkK4uYi90tW4oyVZDewQgSTNEANKnyL76ajPG3ReCOTLwQyDl/YCxAsbn1C
         ja0AFeLobeoHPQ53wSwggmok7LmhZD+2yHMpNHh11Zt0rJXcIi1X6LrFxQzXBoF1SiMQ
         4v+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rJvso/FFguiLtD45Ii/iXjsDN2u6oWhDHSHvausDuqY=;
        b=kb4LjeOIFB7a5Z1CUGiqU8qD4uClX8Muibh9KRH97bxtr1OcRRVWKBOpZS+TWKtO6r
         aoyz01sT0xZfPIyxB+Bv287lHNyzIAlsJZtbK0UcKzB6sKfXep7lDgfxOaMspA5F5JT0
         H+f8+FDj5UR6HsVIGDOLcB58f4CjpyBNY8uMUdGD3hqSTBFQ5UOZwsq1th4u5q8Vb780
         HZw/vVhbBdOuYQM3NLxkdJgmHbOS6ixGpsCAg4iNYUVtgEGPCmdRkZwsnXdK3Rn8zJwA
         ssQX4iySueYbNCtFDhRyiYJCKDs/hQyIJgTRfDGVydxwKJtD7nNSrX7HuMHp3kx2kf6h
         kCKg==
X-Gm-Message-State: AOAM53284/6jBbctSKtm+nCnKpkwjuNO0ERsusxVgZ5EF9n0M5LnaKJV
        bdItkdtEzUS0zMuh2DCCBP5D3Q==
X-Google-Smtp-Source: ABdhPJxfm9ss+MwyM9/Y8BM2oI1oHM0Xf+UmDyPo+2sLwKwkIjfKVjLmo58RzJGnWOEDHqB2ccwMkQ==
X-Received: by 2002:a05:6602:722:: with SMTP id g2mr24192930iox.1.1615323226891;
        Tue, 09 Mar 2021 12:53:46 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s16sm8165347ioe.44.2021.03.09.12.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 12:53:46 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: Convert personality_idr to XArray
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        yangerkun <yangerkun@huawei.com>,
        Stefan Metzmacher <metze@samba.org>
References: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2cd3a11c-5f0f-4334-4db8-ff38e2dd2386@kernel.dk>
Date:   Tue, 9 Mar 2021 13:53:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/21 7:16 AM, Pavel Begunkov wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> You can't call idr_remove() from within a idr_for_each() callback,
> but you can call xa_erase() from an xa_for_each() loop, so switch the
> entire personality_idr from the IDR to the XArray.  This manifests as a
> use-after-free as idr_for_each() attempts to walk the rest of the node
> after removing the last entry from it.

I applied this one yesterday, just forgot to reply here. I agree with
Matthew's optimization, though I suspect we'll have a few creds at
most and it won't make much of a difference in real life. Buffers would
likely be a lot more plentiful, so it's worth keeping in mind for
that one.

-- 
Jens Axboe

