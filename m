Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E4522A5FF
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 05:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387497AbgGWDZL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jul 2020 23:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbgGWDZK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jul 2020 23:25:10 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E075C0619DC
        for <io-uring@vger.kernel.org>; Wed, 22 Jul 2020 20:25:10 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id j20so2301407pfe.5
        for <io-uring@vger.kernel.org>; Wed, 22 Jul 2020 20:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9MVfx3nOR6UuOciR/xo7cXZ/th4WV5eo7kpG1rG3ysA=;
        b=sYGg/2srzRVqnhZoUg5o1/8tbs+uw5e5GRk9Prg191UfP1xoMwvH723Ge9XxV8UQ+Y
         4CEWot9lS0SqzGP8KRgPxAJxpC/eEprKLS3vIBqZ5aANULGw14jQP2A7earpJeHPMRIR
         h03gCHjIS00DOdkrfY88+LkPeWA803BH19mIOcX825pt//wFRoKWgLX/4GQxUeM57uDp
         WyjOxQQ4rtE7lDBcbhS6m9tuIqe5ezBXIEwPrhUrtefYV324MprVw5BfPaQGw3Ip0u/v
         Aa//OtUahu1SxHH+0XFEgauJFf2i+AujXdahv7KDbKSx8tvSGdZciHACQveIiHGHIFa7
         5V6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9MVfx3nOR6UuOciR/xo7cXZ/th4WV5eo7kpG1rG3ysA=;
        b=DP8JEuWdf0TysaOTaVKPjXaK+I8xKn+FJlSr4UQ6K1LQNimx9KZPNrP8Ill7ZhAUny
         0relRjD1Kxg3JZ2Dn8N34/+P7H2qCOJr6bIRSce97QbMinbIHgkYKQ/Srs9qb4tfrmU5
         gl9oLwCeIF5sO1eqIeXCqyGTt7XC19cgdSbSoicSeiSIpzFEgX79zoev/wAaVELkt1Oe
         NK7tvn17ALFpnMA/OK6NghxcTSu7OLuXk8fg6h/Wac4OasAcYt+eroxqgZJ9SAlpVvgH
         Qit/QXmuDZf+6WFLFQPR/Fr/Pbi4uBq3//qL3G3KFvm1d95bfLlXZkqbVVddmrlRytR4
         kXsg==
X-Gm-Message-State: AOAM531KeBukYeNjPuhPQH2iowXpLFqHhVOIoRIC4zhQDgWXSQBVHdnd
        KI1XA6u6M0gj8vyio2Vu742kbg==
X-Google-Smtp-Source: ABdhPJyG7BgknGC9wMaKL2Q7w46TNfVt44bgRZhyUF0TneCCHjumSEJ/mUDzmmYzIcEUfulF3SLN8A==
X-Received: by 2002:aa7:9685:: with SMTP id f5mr2422134pfk.223.1595474710040;
        Wed, 22 Jul 2020 20:25:10 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b128sm1001418pfg.114.2020.07.22.20.25.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 20:25:09 -0700 (PDT)
Subject: Re: [PATCH -next] io_uring: Remove redundant NULL check
To:     Li Heng <liheng40@huawei.com>, viro@zeniv.linux.org.uk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1595474350-10039-1-git-send-email-liheng40@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c05036b0-49c0-411c-6051-27dee4a0f2b4@kernel.dk>
Date:   Wed, 22 Jul 2020 21:25:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595474350-10039-1-git-send-email-liheng40@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/22/20 9:19 PM, Li Heng wrote:
> Fix below warnings reported by coccicheck:
> ./fs/io_uring.c:1544:2-7: WARNING: NULL check before some freeing functions is not needed.
> ./fs/io_uring.c:3095:2-7: WARNING: NULL check before some freeing functions is not needed.
> ./fs/io_uring.c:3195:2-7: WARNING: NULL check before some freeing functions is not needed.

Not needed, but it's faster that way. See recent discussions on the
io-uring list. Hence they are very much on purpose, and it'd be great if
someone would ensure that kfree() was an inline that checks for non-NULL
before calling __kfree() or whatever the real function would then be.

-- 
Jens Axboe

