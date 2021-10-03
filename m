Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53424201A2
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 15:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhJCNHz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 09:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhJCNHz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 09:07:55 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FB9C0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 06:06:08 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id h20so15466235ilj.13
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 06:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NIcrEiMqOR2ySYAg32vLT4hqdYTImcb1fU7prptLse8=;
        b=3DNXS0z8Y45a60FIPcSqFxG+ZbKnH2I+0zL9H1/DYrHcVImv6rYZxZ9QyhUCt6JOJd
         uaY1QJrnF0m+3B2frgOBZnL/ovDvYW12SCRTXQlUyvY0+cP/gFbhrrhzpqrwwaDvPMA4
         wZcFSZ5jPpSAdv0XOkHAHsK1sO0IE6VLSGpeJO2ZjUs48hhYMr4GJtAeCF36GyONspU8
         Q7HIbuuawJy9d/bsvAnERY/oV/ivXrOXvE4G8yyl5Q1xOOD/Bcab41tApoE5fyNm4aAg
         i6i4Bo3Xm+YrSvRJ1kTJs6WJ4/1VQ471ErPrV4qu0fptKMVdDo2YF7/TGpAQ/JHvn4SU
         fWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NIcrEiMqOR2ySYAg32vLT4hqdYTImcb1fU7prptLse8=;
        b=GBCZzCERSLnqDhj32tppKc0gfiY8U0N4GrluL61drR0KOjy2ReoXvG10J79pOGSnaJ
         SCU95Z0MBP3aFpDZyY1UUmX/kfXTqVOI/shKhIexunmaSk0FhDVu5hkepK687rwomGG/
         WvzeyvwTTukXMacfY0VlrnP565IgnvQwLJP4EanPZH2ff7wySBSu6EFw1LiLdbgZLAa9
         BKfTCH75kBNmxDVdwg2oboTcNCyGDIR6lAWIi8Wsr5vIZNCKEt73XO4HVSVssEepdfpM
         YUvyZrWlh/JRRMlqXIJgMylhwOaKnd29+MqGTZdGJjXG6hJPtP+aVoUwQziwAzPZKduJ
         2DCw==
X-Gm-Message-State: AOAM5315BzMbfJEaYzRrtmR7sh0jxLAyFoAmHzlE7oDOGwbX34dX3JAX
        stdvdwksqrnBaXYG8ib9dDZHL/bon0+H0w==
X-Google-Smtp-Source: ABdhPJynSQCrmXQdQhYfSVnUF5shj/MSkK5hUw2HqlRk4ou2PokRaR5O21ed0e/VoIk1fCq062fL6g==
X-Received: by 2002:a05:6e02:f94:: with SMTP id v20mr6321125ilo.148.1633266367286;
        Sun, 03 Oct 2021 06:06:07 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o1sm7237392ilj.41.2021.10.03.06.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 06:06:06 -0700 (PDT)
Subject: Re: [PATCH liburing] test/probe: Use `io_uring_free_probe()` instead
 of `free()`
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>
References: <20211003010608.58380-1-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b497300f-fc3a-ba61-0b29-da3fa080f366@kernel.dk>
Date:   Sun, 3 Oct 2021 07:06:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211003010608.58380-1-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/21 7:06 PM, Ammar Faizi wrote:
> `io_uring_free_probe()` should really be used to free the return value
> of `io_uring_get_probe_ring()`. As we may not always allocate it with
> `malloc()`. For example, to support no libc build [1].

Applied, thanks.

-- 
Jens Axboe

