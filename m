Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F01C38F266
	for <lists+io-uring@lfdr.de>; Mon, 24 May 2021 19:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhEXRme (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 13:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbhEXRmd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 13:42:33 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602D9C061574
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 10:41:05 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id r4so27915596iol.6
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 10:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ORnZtruCxhNMgEoo2B1oCdWDZj80tIP0stMbyb82J9Q=;
        b=w8TNUkXAKKfkpVqigpC8Msq5q8DWm5x/+68CThp0egahLxcfOXRO43+vJqegdOPRsH
         9kqlZYfIl0x4JYuN1uBHV/kLOPK9yRgbYpAEQbd7i1rVsC3zXdEqRPbl8XbFUcgE95Sl
         dEe8AjITP5GK4upJJ3nq2D0YA+IsXIDI/+JtxjP4EaoHNgTMNhTBEM1Pi5yynG85epOb
         sKziUEXxvu6FN4NeGF5jWPPnBQIqBInXZ9T7rEqGwNRues0v6T0FVrK3LhYEBh3ehgmX
         FlysYnyyTuTPTcUyjjfdSsMTC3U63TELb2sdzfqLhgDzmCc2HYhFdeFbrIQYTFu3M1sa
         FySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ORnZtruCxhNMgEoo2B1oCdWDZj80tIP0stMbyb82J9Q=;
        b=hWM8VjAkdbIiP4+r5DZEFcJrmdlPq2zbt4rqnkLhZwiyBH4yBXhvZpkSYrOpPKUy5W
         +M6mQZkoJbnkshXGsThMwXTWbOcXuBDVgAG93xTB3xpAbe7XjEpjnrYCjNJbarJCUIok
         09QxjKf8cySzlR9mLpfX+jLNj1LGjYFgY9OEMo92ZpLZIiw7f3vWCtCx946MuvJzUJS/
         D6AlvFCB47YOqdTAX2dGjG/aA0lrr3HZQbwYtVue8hkeb1anzpWkXAnv4WrLaAAkPq+c
         ykz2lNnoVQAPRUNvfzc5E4E/IIXZ9t++QYk/44WRHfyVBQOP0bw2RyzhEPe4aABW/1zd
         20Yw==
X-Gm-Message-State: AOAM531vlOkjBNKboIBivSZ9kLKP7Lhl6h4RBz7akJhdkkFbpuhNjvOZ
        HmdwmxCkFXs5c+JcDhfPSOUCR7ag6IpmTShd
X-Google-Smtp-Source: ABdhPJz8HLsRzjTY1KgJgfFYxea3QTmFkw8breEqiDAJcZT8hMuvnO7+Jq2Os8nP4ZWwkFFJnwpLWQ==
X-Received: by 2002:a6b:4408:: with SMTP id r8mr8563981ioa.55.1621878063235;
        Mon, 24 May 2021 10:41:03 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z8sm11527180ioi.38.2021.05.24.10.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 10:41:02 -0700 (PDT)
Subject: Re: [PATCH for-next 00/13] 5.14 cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1621201931.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c4185fef-e29c-b1da-c11f-110fede79921@kernel.dk>
Date:   Mon, 24 May 2021 11:41:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/16/21 3:57 PM, Pavel Begunkov wrote:
> Various cleanups and resends of lost ones. Some are a bit bigger
> due to find/replace.
> 
> 7-13 are about optimising CPU caches use and things related.
> 
> Pavel Begunkov (13):
>   io_uring: improve sqpoll event/state handling
>   io_uring: improve sq_thread waiting check
>   io_uring: remove unused park_task_work
>   io_uring: simplify waking sqo_sq_wait
>   io_uring: get rid of files in exit cancel
>   io_uring: make fail flag not link specific
>   io_uring: shuffle rarely used ctx fields
>   io_uring: better locality for rsrc fields
>   io_uring: remove dependency on ring->sq/cq_entries
>   io_uring: deduce cq_mask from cq_entries
>   io_uring: kill cached_cq_overflow
>   io_uring: rename io_get_cqring
>   io_uring: don't bounce submit_state cachelines
> 
>  fs/io_uring.c | 343 +++++++++++++++++++++++++-------------------------
>  1 file changed, 171 insertions(+), 172 deletions(-)

Got the 5.14 branch setup, applied these. Thanks!

-- 
Jens Axboe

