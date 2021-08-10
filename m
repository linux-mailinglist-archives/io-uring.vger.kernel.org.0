Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DE33E5C31
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 15:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241934AbhHJNvV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 09:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241853AbhHJNvU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 09:51:20 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10E0C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 06:50:58 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id z3so21049426plg.8
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 06:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XoWeVxyak4DWU94pEzM6MUAbK2lfkSPHc8kV9GBn1Xw=;
        b=uF3F0hZgVxYl3RCrx+c1fva6X9MmI7dgyLS/Ut16oNRj/N933RDSMJURC66trAX5Yi
         5ot9QB52YSNM9rkHPLn+8Pz1B06Wrk8/y6qvpw4irlfV/HqCOOE1L9JmMUUtgA2gP6Te
         ONNdEkr+qWr7AB5DkN2qAFlGYpaHOTLI+u1GnsGZ1+JY6/xoBLxIK8nL8zps3Go8aiT2
         Xbv3CFELefETqtotvuY/D8PnRAApPGdamf9gbpbY/aN2PeWyR4tSlCL6vhFWaq12arRM
         pdgMIityTmOcAZ/biSHiHIGmDBZS8yQFN6AIxa0dv9txW9izXveF+KlGOVPVrBdSF4HQ
         I4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XoWeVxyak4DWU94pEzM6MUAbK2lfkSPHc8kV9GBn1Xw=;
        b=DcOh5gUJSak0BoyA5Vo59t1CdHwrHbqFjTSnTIVEEBrlhod9BDKYnke2yF8J+Zr0EO
         Mn/YyxvHpuUyswcxLsZRUokLpRPDqnn02MkXMEhp5q1pXqHcq0J0qs2vtRMxizbMogA1
         TmRKsAIAIyft+URmPI1GVlAmPYG+8a1UNR0iohuS9FnnO6hCZPX0J05WlBNgHXhKtAaZ
         rXr64u77B1yFkKlqe4jV03+FUw9sdARUXvpXTUwB/hzmadMfrOCR8NfguamRKitvkXZt
         cX/CHKU72kWTZz+DfY3PYH6ncF5vIhKitWJKvDuoqPCRWnCfhm7Vkqjxof5dw6Sfzsoy
         6j8g==
X-Gm-Message-State: AOAM531Sl93FbnrH3rg2XnIxysV663tAtF77DcgCr2WQXv65rjQDJpGF
        dt/6WMj61dlWLYD7jL7Wre+dMw==
X-Google-Smtp-Source: ABdhPJy4mP2As13SmqECTfCVTuLG7/rR2QGtE0EFlR44tPcdU6oMjHtsu0AmIvsUQxpwgCjS4b+sPw==
X-Received: by 2002:a17:902:da8a:b029:12c:6f0:fe3c with SMTP id j10-20020a170902da8ab029012c06f0fe3cmr25854832plx.41.1628603458328;
        Tue, 10 Aug 2021 06:50:58 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id n35sm28341569pgb.90.2021.08.10.06.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 06:50:57 -0700 (PDT)
Subject: Re: [PATCH 3/4] io_uring: wire up bio allocation cache
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210809212401.19807-1-axboe@kernel.dk>
 <20210809212401.19807-4-axboe@kernel.dk>
 <CA+1E3rKB7m54VxD+RrdS06ZSSJ_gJtO_ZVVQvespo+Y+jOBiKg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <60fc0384-028e-3878-dd1a-7601bff44d1e@kernel.dk>
Date:   Tue, 10 Aug 2021 07:50:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3rKB7m54VxD+RrdS06ZSSJ_gJtO_ZVVQvespo+Y+jOBiKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 6:25 AM, Kanchan Joshi wrote:
> On Tue, Aug 10, 2021 at 6:40 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Initialize a bio allocation cache, and mark it as being used for
>> IOPOLL. We could use it for non-polled IO as well, but it'd need some
>> locking and probably would negate much of the win in that case.
> 
> For regular (non-polled) IO, will it make sense to tie a bio-cache to
> each fixed-buffer slot (ctx->user_bufs array).
> One bio cache (along with the lock) per slot. That may localize the
> lock contention. And it will happen only when multiple IOs are spawned
> from the same fixed-buffer concurrently?

I don't think it's worth it - the slub overhead is already pretty low,
basically turning into a cmpxchg16 for the fast path. But that's a big
enough hit for polled IO of this magnitude that it's worth getting rid
of.

I've attempted bio caches before for non-polled, but the lock + irq
dance required for them just means it ends up being moot. Or even if
you have per-cpu caches, just doing irq enable/disable means you're
back at the same perf where you started, except now you've got extra
code...

Here's an example from a few years ago:

https://git.kernel.dk/cgit/linux-block/log/?h=cpu-alloc-cache

-- 
Jens Axboe

