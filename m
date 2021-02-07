Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D23531265C
	for <lists+io-uring@lfdr.de>; Sun,  7 Feb 2021 18:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhBGRVC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Feb 2021 12:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhBGRVB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Feb 2021 12:21:01 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25136C06174A
        for <io-uring@vger.kernel.org>; Sun,  7 Feb 2021 09:20:21 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id c6so15511091ede.0
        for <io-uring@vger.kernel.org>; Sun, 07 Feb 2021 09:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uoJAFSPV1eJGzjwGM1KYYJLj05FVxMBjC6PiBvYUxXo=;
        b=ZjZ75uLvyFb8JalbngpVCH+iyaztf+SsrI30FYCzUCzp6EqHIZyup11vOVeeXY5KBQ
         QmqqfRCaF7UlYWidPUYi6Gy8BOsVIowtA6RED91cO9a59ozSSPnb2nHV+3dNSjy4kepY
         KJNjA/zxIqttxGlXf3YyhgJX5cpRT8j2tb2ci32i6EUPwMrzEqi5u6jyo3JXnoW0Q6Wd
         I9kl9rapgVvPHLlH15DTRdeKwQNvBaplyE4KtYNl0rccceQ+4G/FDWb2ZKwWcJGAXuMa
         cDXcmD5HzSWe93tO9JTXbfd5JhXQDfOw3dMeCnJ1sU4BMpT2ookiWB9yADn1vP3YZbxW
         gTvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uoJAFSPV1eJGzjwGM1KYYJLj05FVxMBjC6PiBvYUxXo=;
        b=Moy5tlZOtAj/43sFOpyMg0hSHwOdzkMviMRf2vrWjOQNKwgf67ghQv0dYlo7sCud+x
         YaW2KwIUaEorIjS2eLHG0wwKI5n01Qln3n86LOGRch2AnFzDEcu+O1paLzl3vNGHBkzM
         5+KJLUVq/S52ziSlATaTceMlXU2u1OtNODvb9bFyVA9x0lkhsBclWmYrLhgnWUhvs6nV
         8Va5nNlI/D6yXPTHZpKXxYh+peKXC5XJqgE/ilon0pdpT7XH+VVFrTvvyU4nLwgRP3J/
         bd1DZl2f6U25iTkalDQSFMLrrbzB1cI4x/GGCpCE+LZncfKQEH5BBSzJC5cI9rjv7C2q
         15TQ==
X-Gm-Message-State: AOAM533Mwwm5hrGfkwJS75NkXy6cSgV0g6QCcvcW829V6SwTEoBvpxB9
        TlCjGaRLiYbYhdhJBuS0Gw6uTUbArek=
X-Google-Smtp-Source: ABdhPJzvSE5iox8OysxKvzKKXILkv35ZCCpK5URWb5Jj5qQn//RmdhOhhxIC7vVvv4J7SJKLvc6ytA==
X-Received: by 2002:a05:6402:13cd:: with SMTP id a13mr13614190edx.87.1612718419624;
        Sun, 07 Feb 2021 09:20:19 -0800 (PST)
Received: from [192.168.8.177] ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id ov9sm7120706ejb.53.2021.02.07.09.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Feb 2021 09:20:18 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: don't hold uring_lock when calling
 io_run_task_work*
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
 <1612364276-26847-3-git-send-email-haoxu@linux.alibaba.com>
 <c97beeca-f401-3a21-5d8d-aa53a4292c03@gmail.com>
 <9b1d9e51-1b92-a651-304d-919693f9fb6f@gmail.com>
 <3668106c-5e80-50c8-6221-bdfa246c98ae@linux.alibaba.com>
 <f1a0bb32-6357-45e7-d4e4-c65c134f2229@gmail.com>
 <343f70ec-4c41-ed73-564e-494fca895e90@gmail.com>
 <150de65e-0f6a-315a-376e-8e3fcf07ce1a@linux.alibaba.com>
 <570f215e-7292-380a-1213-fe6e84881386@gmail.com>
 <62fc0e30-47bd-71d2-29e3-c2824bf78725@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <433825b4-8330-b448-eeeb-4582c5b25159@gmail.com>
Date:   Sun, 7 Feb 2021 17:16:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <62fc0e30-47bd-71d2-29e3-c2824bf78725@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/02/2021 11:34, Hao Xu wrote:
> I saw percpu_ref_is_dying(&ctx->refs) check in sq thread but not
> in io_uring_enter(), so I guess there could be another thread doing
> io_uring_enter() and submiting sqes.

Ok, looks tryget does it in a different fashion than I recalled.

> So we can just put unlock and lock around io_run_task_work_sig()
> to address the issue 2?

io_set_resource_node()
	-> percpu_ref_get()

If refs are left dying, it won't be safe for in-parallel enters.
tryget or resurrect

-- 
Pavel Begunkov
