Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7949F5704C2
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 15:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiGKNzd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 09:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiGKNzd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 09:55:33 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3969A61DB9
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 06:55:32 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id o18so4779926pgu.9
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 06:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=x4JvlHHbtBg3zb/imkMUwclHSiTfNJtKXCNijr0CDSU=;
        b=Yr+1a250PVJqsVfljNjcsW1gk3h5HCHwRJ1FFcgbewOT04fc2b7XR/DKGBn4RU6PKr
         5BkkKMn90VP6uN82kIY0nd38a45p4Ir/9N608lw2vnrRCDJCmhAxqSzSRb4G3G/xB7ae
         CQUpWMjCJ4hAQ8A8OdjyRzV+KQdwG+xlVF+i3LDRm7o9aUYJPAA3S2hAj+nfFuTtH0gw
         ltPWWagrfise8NktRnUy6jWvWnT04Xq2qSyIp9q/uYOvrGOPHniDFFj+4ulC+QDGSrll
         LqoTU0JLgaCCS4Avd1UdpiKdhj4po1g0/Lcim7pLyNpwnKpozj1eaCGi7Zqwoyjsa3VJ
         8ctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x4JvlHHbtBg3zb/imkMUwclHSiTfNJtKXCNijr0CDSU=;
        b=6qybkNBCPac4qnhtTNNzFZJnfysJQXUif9iwV0V3fOQeZ2+fdQjG5rmCVVXTMwZ4J7
         Cf/72LK46mOlKnoiXYWgBlnytUoc7OmjmtQD150P3auuVWdD7y/gW5DSyS2bv76IzRiV
         4i0qez+FuYnhEWpXtdik23gcfzC5DX/Z0MQZNbRKwvnGANtsSUHzxaeoCLPpYeMyg1nV
         Cz1y92PP6N3I+l9cMk/nUPm5TOhGG7qsJsVRxJXBzWV7FMWakVhtISwIcy4BZuSM07Fa
         tOeT+xNeL8x2J1xJU5edQU9iXcuz4RctbGcW8UbQiC5SpqZzPmuyTRhhSyq5LGLajXnI
         ZZoA==
X-Gm-Message-State: AJIora/XjiRB9jpc7SZGSQO1CfxhvzIfgyCzkkcDgfPfqz0swPb/IChq
        btOQl48zAGnuEknvLZQkRHk7dUq80FfqEg==
X-Google-Smtp-Source: AGRyM1va0BfbAY7AiEflVxAPsYkMHKrDcqqUuaBNtQ7Uog3Cvt3PGLCC5m2TPrWOgGP8d4PHXgSuAw==
X-Received: by 2002:a63:eb07:0:b0:411:9e27:a481 with SMTP id t7-20020a63eb07000000b004119e27a481mr16364562pgh.157.1657547731704;
        Mon, 11 Jul 2022 06:55:31 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z186-20020a6265c3000000b0051b6091c452sm4768761pfb.70.2022.07.11.06.55.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 06:55:29 -0700 (PDT)
Message-ID: <4020dc2d-b994-2a56-7921-f09306bfa814@kernel.dk>
Date:   Mon, 11 Jul 2022 07:55:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL liburing] GitHub bot updates 2022-07-11
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>
References: <3b337606-9141-59cd-a9f5-936942f0ccc0@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3b337606-9141-59cd-a9f5-936942f0ccc0@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/22 7:50 AM, Ammar Faizi wrote:
> 
> Hello Jens,
> 
> GitHub bot updates for liburing:
> 
>   - Upgrade GitHub bot to Ubuntu 22.04 and gcc-11 (default gcc version on
>     Ubuntu 22.04).
> 
>   - Use -O3 optimization.

Pulled, thanks.


-- 
Jens Axboe

