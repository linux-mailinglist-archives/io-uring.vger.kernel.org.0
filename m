Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC852789D6
	for <lists+io-uring@lfdr.de>; Fri, 25 Sep 2020 15:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgIYNnP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Sep 2020 09:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728333AbgIYNnP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Sep 2020 09:43:15 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D77C0613CE
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 06:43:14 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q4so1867142pjh.5
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 06:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XWcmG+F7FbNh/q4vWwYlmzSTHgXWNZpHjcDsYW0n7+g=;
        b=T5nnXLMEI+0PXGQ0PqbbLbvmi0O+cTuQSJwl+rZHGZznlY71HZqzPj+Ax/mJHAs7F8
         c1D51/KNNlNDDAU59RLwnxzrBXZt5QrYDAHqiaa4/SQ1qZITXFckQwMuAq9YkFBygpkq
         LUzjE20s1ACepJsqmj9fUnhEE9gV/fLfafgoQdyA5Ratj9va5SnWZ8QNmCBtjkRGhfqz
         cjVdRl+kxq5YdQYGv815Hf4RgNCTGggQtA/EBnRl9zlfUyQ8u+YLd53OM8SKNeLDmMLF
         +ghbrpqdc1NnIPhIX4+4Kb282ebVCzfeHiPZEd1/WLZcAAKBbM7RKkSlS1kK2IWeNkvp
         5ngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XWcmG+F7FbNh/q4vWwYlmzSTHgXWNZpHjcDsYW0n7+g=;
        b=cN3Yhqqn4E2WDEvD8v6ctrCpDLLaCuqkhWK6kw+ziL/3ajA42xGahzPlbUQj0bZAzD
         xpAF4eVNdVf+d37I8L6SI9+G6+DZyx1OBlPaKSkv47SQUquPooqXWBdxcxdM/C7kOprY
         bmevtRvW2BjiSrjeeK0972F7UE5ogB89Sisk2C9mluZLfwJetIiP5WP34brJT5rRsFr5
         +9YvOw3hpKI07s0c4VIVRbqZNpVwRPzOXWp9GLAXPYOaPmqpEBEHPBVefDROrmhOnmnZ
         TgN5VixAp3nHTTjWM915V2oEr48dNPlBSC58EzOl3l5HAI5Y+5MjB+hNjGTPnFi+5pdf
         TFoQ==
X-Gm-Message-State: AOAM533t9+7Sjrwa972ZPg7GNtj/QcJpfdnVEyHJ1uOsze60eb3Trfgb
        0wGfURxjUTpegpCpuJfgYmkzdH/33abd/w==
X-Google-Smtp-Source: ABdhPJyLAamy2cDTXNtMAMlQLYhhUulTAA5yygwR4x38EqMEwJ/Ki5DcryjJd6LWsmfCCdST8sVdNA==
X-Received: by 2002:a17:90a:ec06:: with SMTP id l6mr412660pjy.66.1601041393990;
        Fri, 25 Sep 2020 06:43:13 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i17sm2729683pfa.2.2020.09.25.06.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 06:43:13 -0700 (PDT)
Subject: Re: [PATCH] io_uring: ensure open/openat2 name is cleaned on
 cancelation
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <ea883f39-0da5-fcd3-a069-43d7f5002380@kernel.dk>
 <20200925083210.xwfmssdvg4t6j3ar@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <be2b8cf8-5548-0e43-348f-00086dbde419@kernel.dk>
Date:   Fri, 25 Sep 2020 07:43:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200925083210.xwfmssdvg4t6j3ar@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/25/20 2:32 AM, Stefano Garzarella wrote:
> On Thu, Sep 24, 2020 at 02:59:33PM -0600, Jens Axboe wrote:
>> io_uring: ensure open/openat2 name is cleaned on cancelation
>>
>> If we cancel these requests, we'll leak the memory associated with the
>> filename. Add them to the table of ops that need cleaning, if
>> REQ_F_NEED_CLEANUP is set.
>>
> 
> IIUC we inadvertently removed 'putname(req->open.filename)' from the cleanup
> function in commit e62753e4e292 ("io_uring: call statx directly").
> 
> Should we add the Fixes tag?
> 
>     Fixes: e62753e4e292 ("io_uring: call statx directly")

You are right, I got a bit tricked by it since that commit removed
the putname(), and then later on we got rid of the (now) empty
openat/openat2 entries.

I'll add the fixes, which means it's 5.8 only.

> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Added, thanks for reviewing!

-- 
Jens Axboe

