Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB212320005
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 21:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhBSUyA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 15:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBSUx4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 15:53:56 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366A1C061574
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:53:16 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id o24so8743754wmh.5
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0iDLn3+C2O3rMLSiCAXWm4d5koSwtfhqThVR6uCnY8c=;
        b=D+eGUpVJ8w/VGORlILpAzXJg+hUNP8BateLxyljvElwzs8qYL4HjFC0xCFU8XHRa1D
         X6ocxUpV3/AN2EHuPvjc2KiySzZjIpUB1ZlpkudfM5RvGPJnQPiJ7+04DAjxWP0MFUNN
         HVkT+B39gUWgNtvGYEIzF1p2Uq7Jf1mAzTdnTuF4lQtED2FOM8ejjSB2U5etIypx39mM
         gHSkJs1qiRKJN8I8NCHraGm4NtgwWA9gCUZh9TTIp3mOE1W65cceR3AU7tfOwB+HQF8s
         dJb2qp2zHLZDMYpqbnM/pEctyrVN99D5A8hNadmxplGER+YUA0m5vctmqUmJSVX93sgp
         aP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0iDLn3+C2O3rMLSiCAXWm4d5koSwtfhqThVR6uCnY8c=;
        b=ZCG5rSgwBMD0cHwKxNnQYxI2EXwbKIa07fUtRlk5Mj+qLefAcDf7uBpbGD7nKZtAzW
         j2Y93a5ntstoZ6LnOx+rHvJCBE4uUNfrTE2LubCCcNFSotHpzye3TBx6leWqJNA2ooag
         2NirG4K+64E6GC5oyIdpoFAhHo6PHVEZ+qRwuOkJCF25SbNW/nNha9qohzvEX3rkzj8l
         FqALqKgZzAvf0F3UYPQBijGsJRQdevjy7YVh2U2+CPhsehF+x0DfzHdBlpKpStpoflev
         SrZbEgfuKqXQnF1aGcVhMZMzvTLlaPu1uOneOEld8DKcYN8MH6ujnglngu0C/10FcrUW
         6JeQ==
X-Gm-Message-State: AOAM531B9LhkU8B2ATkaHDSkFWPoiWNzKwbs5qE8chzn5E9d9Rnvj5kG
        GjIOLcnEfawGjuL1Yk9xZIiz9pGk6y/tgA==
X-Google-Smtp-Source: ABdhPJyfVQUPkv6xtRHq7wElghmj31foNo6knK3cyTXFGr5idemD3PlxR9xxH6FGp63SpEfV8HMHdg==
X-Received: by 2002:a1c:e90d:: with SMTP id q13mr9735697wmc.136.1613767994996;
        Fri, 19 Feb 2021 12:53:14 -0800 (PST)
Received: from [192.168.8.139] ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id w8sm14560742wrm.21.2021.02.19.12.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 12:53:14 -0800 (PST)
Subject: Re: [PATCH 0/3] rsrc quiesce fixes/hardening
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Hao Xu <haoxu@linux.alibaba.com>
References: <cover.1613767375.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <1253a9e9-fbf4-4289-ae36-2768c682d6b5@gmail.com>
Date:   Fri, 19 Feb 2021 20:49:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1613767375.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/02/2021 20:45, Pavel Begunkov wrote:
> 1/3 addresses new races in io_rsrc_ref_quiesce(), others are hardenings.

s/1/2/

Hao, any chance you guys can drag these patches through the same
tests you've done for "io_uring: don't hold uring_lock ..."?

> 
> Pavel Begunkov (3):
>   io_uring: zero ref_node after killing it
>   io_uring: fix io_rsrc_ref_quiesce races
>   io_uring: keep generic rsrc infra generic
> 
>  fs/io_uring.c | 65 +++++++++++++++++----------------------------------
>  1 file changed, 21 insertions(+), 44 deletions(-)
> 

-- 
Pavel Begunkov
