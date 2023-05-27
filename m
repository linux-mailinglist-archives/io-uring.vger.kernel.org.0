Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A597131E8
	for <lists+io-uring@lfdr.de>; Sat, 27 May 2023 04:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbjE0CWd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 May 2023 22:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjE0CWc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 May 2023 22:22:32 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDD49C
        for <io-uring@vger.kernel.org>; Fri, 26 May 2023 19:22:30 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64f1f133c37so295931b3a.0
        for <io-uring@vger.kernel.org>; Fri, 26 May 2023 19:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1685154150; x=1687746150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YibsWnUJQ4Np3t4fAknAJH/bHGwuSnEA6ZYcfvkHPT0=;
        b=T8mc6H4dfyH81Q8PNi3Ym/xXOdC0iGbHvaCzNjouT46D0JUPGDw4MKx56++PulOYoN
         smztwQidoSjAvEhciW0FJk3HIc0U5RKLdo+Nayj8b49FctCMIheOfnd9O1cBDRgQLkeO
         oPUguJRAUOxyCAWpmPPUSdXlSKF4djR8sC2Wf+E2/JEPZE2BwOvWr1/DJfqE3ewuzc7J
         Q6CE74/kCWj7s96N43kIYx09TxCz61AENybAEzEKZwyHL++kdJC9ZWt7+++QnS4SPpqV
         Ji7IycooCJDFtwiqoRMxEXt+HlLHOtleCpfcBV1xxoIvcvwEwp0RqXwG7zBB0McXzi4R
         fI+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685154150; x=1687746150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YibsWnUJQ4Np3t4fAknAJH/bHGwuSnEA6ZYcfvkHPT0=;
        b=G1zDBHKTxmNOrXR71jZvbCAPNbBSpkj0qPVz9JVBTJ5S8nzZArs74URIih58B0tOjG
         yI/dMw/o4+uwPZj6+fB+Z1PTovh2Eld1bMFbsU3pHqFEzFzcmk3+VoP3uYKRpS05Uve0
         B9dX5/2Gb9CGejq8p3tLXZ+LhgdDjRGJ4c3HPNRGn78I65cmqDUnigx+L89JlxIiCCBf
         MxkevcRnXAwNhujDzuIPDboNKqeA2iw4T3cjYpUI3Gn8QPCZxmFj3OOXr9hfHctNKtAF
         Drxbr9c5sAkXdKQWjm3c4wx0Qn6/4HTDNJ3HzT3384njljKZ+FIhYX33BvZolaqHCGSw
         YqkQ==
X-Gm-Message-State: AC+VfDzeb77pYDBccO6f13USAxUE4UjkqatfLDkYWfO32yybQ2qduyMm
        Zfve4fFcDJP6eHep9UnD+gy6Ig==
X-Google-Smtp-Source: ACHHUZ7V/oCX2SL+BdJZnTgn+fuCeFl5fLYubMO1DaM1twR1mLBM+IKOIe9tFuAVJwldDNxo8xVSZA==
X-Received: by 2002:a17:902:daca:b0:1ac:6b92:a775 with SMTP id q10-20020a170902daca00b001ac6b92a775mr5090763plx.6.1685154150322;
        Fri, 26 May 2023 19:22:30 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090322cd00b001ac8cd5ecd6sm3847285plg.65.2023.05.26.19.22.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 19:22:29 -0700 (PDT)
Message-ID: <8a7c1780-af95-fbb3-5f48-888fba5462f6@kernel.dk>
Date:   Fri, 26 May 2023 20:22:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring: undeprecate epoll_ctl support
Content-Language: en-US
To:     Sam James <sam@gentoo.org>, info@bnoordhuis.nl
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org, kernel@gentoo.org
References: <87ttvy1r3c.fsf@gentoo.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87ttvy1r3c.fsf@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/23 7:48 PM, Sam James wrote:
> Hi,
> 
> New libuv is indeed in the wild now and CMake uses it, so I end up
> getting
> a tonne of:
> ```
> [ 1763.697364] isc-net-0000: epoll_ctl support in io_uring is deprecated
> and will be removed in a future Linux kernel version.
> ```
> 
> Could you confirm if this patch looks likely to land so we know if it's
> OK
> to backport it downstream?

Yeah, I think this is the best plan. I was out of town for a bit
around when it got reposted and hence missed it, I'll queue it
up for this release.

-- 
Jens Axboe


