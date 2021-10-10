Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057A34280CC
	for <lists+io-uring@lfdr.de>; Sun, 10 Oct 2021 13:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhJJLVb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Oct 2021 07:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhJJLVb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Oct 2021 07:21:31 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AEFC061570
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 04:19:33 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id w10so15023958ilc.13
        for <io-uring@vger.kernel.org>; Sun, 10 Oct 2021 04:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3HI9YkaB5xDykGRYzp/WqzfgIOD9u3OCbyyfxHg7aRk=;
        b=ZUjZUAXKZ8BFujjCo1im0c9kn632t8Y5RvQ8REf7foHjBnm0DyYfoNoIre2VXXDcQA
         QpAxVmx2LqHKe1L5i1lnSuutTgr/VcgKWbQWdllZLxi88uU0cM8qv2Y9e5AR8e+XoyGi
         GA39vK03m4MHgTQF3GJNKO30y/Gyf8oOLAbF20dmV7nfBwRd6ZQIXVcP4ZRFKdduVJwz
         UIcb/KdRW/qK1k2NoFdX1cBwndtwouzuvkZb/RC3wWIFEESuiPxj2IDqgxV6lZ/LdVyD
         5L5V1Ni6FN8qxJfepfGiJ/7N5vpim0VXEbA28VnrDmSWEQUvi6R+mKkXhfRxK13b6/Dd
         CH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3HI9YkaB5xDykGRYzp/WqzfgIOD9u3OCbyyfxHg7aRk=;
        b=UVciTEtc9B1MQJbdO2kOZaiuDcSLFJ8lBbYX8sQJ48gV5dpmhmuJBss9bFOXpWhopr
         JGdBwYJ4SOGycHljtdCAgJPzyD5RdWzsJsXUMg3//9PFI4pXI/e8Q6t4an46vCvICyb/
         7GMQKmx//P1u9mWZPoZk3whu9Ag+wAHxCInmRnGb4ij/dp34qJRFUsMEfw7lEybIFxIA
         T51NdkyrzANpzYmyWURArlCtJuj5t6o278nQUhMh2ZNGiS7kRQBfLvAQfx+khrst/jxW
         dydKTkskPRxUbehs5/g22t4ci+IBc0RBgDb/yTjNL0jGhv/kjHlI4xQ5CfYzlTr/Eb6V
         QqOQ==
X-Gm-Message-State: AOAM532UaWBFm7AVmaK4s61mkacJhRcyfUQtdQYB5KVZR370gTPMBcjf
        0Pax6uWC0FTm4kzbt6u6MAIi7g==
X-Google-Smtp-Source: ABdhPJwT6MD831sPOQxE3I2JzvxHogm5GotHrwSl1asQOr034v9ba8afbQTGl61Wm1PLJbmI+c8Uwg==
X-Received: by 2002:a05:6e02:1d12:: with SMTP id i18mr15440748ila.182.1633864772599;
        Sun, 10 Oct 2021 04:19:32 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v17sm2495172ilh.67.2021.10.10.04.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 04:19:32 -0700 (PDT)
Subject: Re: [PATCH v2 liburing 3/4] Add no libc build support
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <20211010063906.341014-1-ammar.faizi@students.amikom.ac.id>
 <20211010063906.341014-4-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b37e2154-6555-4a0c-1212-ddb31bc7309e@kernel.dk>
Date:   Sun, 10 Oct 2021 05:19:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211010063906.341014-4-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/21 12:39 AM, Ammar Faizi wrote:
> +#ifdef CONFIG_NOLIBC
> +#  if defined(__x86_64__) || defined(__i386__)
> +#    include "arch/x86/lib.h"
> +#  else
> +#    error "The arch is currently not supported to build liburing without libc"
> +#  endif
> +#endif

That reads a bit awkwardly, how about:

"This arch doesn't support building liburing without linc"

-- 
Jens Axboe

