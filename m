Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8603A18E0
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 17:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhFIPPf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 11:15:35 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:43949 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhFIPPd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 11:15:33 -0400
Received: by mail-pj1-f50.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso1571312pjp.2
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 08:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KUrs+4C5j1c/PibGjBDNj2MaVm/jI92djHTblcyVV5c=;
        b=WSTtA1urxHsID6ZW2tdYbZf2iVEr9XEwggWl2mLYSJBW/T2icQHj5uBPppFHsWIEGA
         xd1IDGG7KLtljfgCMzc8rnk3UCZit3naN3kRYQ/KS/gaxDHrG71nsZlEDZdFMOG9f/+f
         wfbShtd5p6ok0nUMvOrMyqz+563CNmYJlKz7qU5SYS3T026sGpGU9hG+825fFiHOBEs8
         rDQ/vM9baYNC3TDTnVrojI8l7b6ItNPFqEAyDZ66+REnFm1W3p8YJnor9RshG5XluyEC
         yyM5XpcHltZqAFnFkWjT49RTxTG/0Rs+K9o2Q+4lOaKOyPD+sRjLi6tG7IalbevAEi+K
         M2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KUrs+4C5j1c/PibGjBDNj2MaVm/jI92djHTblcyVV5c=;
        b=Qq37DTbvNNKg59ddjBhKVp9lzT6Pt63rYbN3qSl8xqXp93sq/vUpbLK/YS1puMW0Gf
         hbS3c7W9ISfQ8Fj5SqPRmaveJyex7dDFY4/txYFhhC7PSHJkYz8JCTMyA6M3UuTJbeWS
         kpO5NRLUSFo37Lt4LaEQl4JsrrmGXln5BzB4vmgEuCv5oKU4BBmg8wTPUjcj61p53IqF
         yw/Pg8DEHUtUh3zMQp32ODES4olEaLsXyOvz/EcZW7gL7GWBNDENiLK5p9GZ0fGqGK3y
         PoCGTkZCDaj0o51HBAOrRBe0uK6+XJxrC9towrGONZjFBTBun2wSCdjrder9Gr1rNtop
         rSAA==
X-Gm-Message-State: AOAM532qa4ihD1T3nP0IMTfFqGNp571T94SK2oFUb0Jgh5OI+52IIowb
        sm/U/S0BRdiKL3nwrK1OOhhjUA+BeP7gNA==
X-Google-Smtp-Source: ABdhPJy0+14qvVRnblJj637ognh42krr4H5Du0Jsgl/9AXK3LzjVy3pQ+yA6ttk9Wd+2/S7FHt7HPA==
X-Received: by 2002:a17:902:bc46:b029:106:c097:88bd with SMTP id t6-20020a170902bc46b0290106c09788bdmr5393463plz.81.1623251545413;
        Wed, 09 Jun 2021 08:12:25 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id e2sm153513pgh.5.2021.06.09.08.12.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 08:12:25 -0700 (PDT)
Subject: Re: [RFC] io_uring: enable shmem/memfd memory registration
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <52247e3ec36eec9d6af17424937c8d20c497926e.1623248265.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <355210c4-7b2c-8445-b8af-da40aed2af26@kernel.dk>
Date:   Wed, 9 Jun 2021 09:12:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <52247e3ec36eec9d6af17424937c8d20c497926e.1623248265.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 8:26 AM, Pavel Begunkov wrote:
> Relax buffer registration restictions, which filters out file backed
> memory, and allow shmem/memfd as they have normal anonymous pages
> underneath.

I think this is fine, we really only care about file backed.

-- 
Jens Axboe

