Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDA63B557E
	for <lists+io-uring@lfdr.de>; Mon, 28 Jun 2021 00:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhF0WZn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 27 Jun 2021 18:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhF0WZn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 27 Jun 2021 18:25:43 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F65BC061574
        for <io-uring@vger.kernel.org>; Sun, 27 Jun 2021 15:23:18 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id k16so19791230ios.10
        for <io-uring@vger.kernel.org>; Sun, 27 Jun 2021 15:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2NKo7XXP2p4/8gEyUwQU3WRvGu5lpWsLtZ7M5lqICAg=;
        b=dg74VmciEuKC1D/Yv/skqA/+YuyVnycI08YS3LnN93gGXpEDHw+m3pHuBAJBG4GVXN
         7dYYyw3b+ojFBb42lwL2kZAurY5tSdndDb3gQqHKnSq4hr23vKHBpq5U79Ni9aXR6OKH
         Y9kMQUy3eEHoZ8TumkaguVMxf5eWOpaok7MWCiQELUyzTsIWvqSXCWxbye1efHKFrXIp
         AcMFc062tVl7+S5hljHFQBbWRDQyim85CHjcMWOJ/QZe53qnVJKe9K2QXaz9qz2MCaPT
         OtqMAFCmcGVtbp9Alo99aA7XiNOiFgWi5OQcPL3pUCu4KTqwMWck+O6DbIusnH3GpOrP
         ev2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2NKo7XXP2p4/8gEyUwQU3WRvGu5lpWsLtZ7M5lqICAg=;
        b=nl+4fQlY6oXWdWXXFxpXwE2lwYFJNNbXxuma3UoCoN0Gx2Q3wezpYQIOEuCr422XcB
         q6jhqqrkP1V09etg6KriU3myDBQApbzRdliLPH0ylpITlYDjwQEBT7NKPJsKuWL+TwdI
         KucCBy5O9fKHndzekyX3x4dL8WhE5u/Jl6P1FYIs65BtsJPislWAcnH1tqDB4eFV2XFp
         QPSTwQARCqDHMDXEpY00W/Lk1dZOw8WpZNeuwZT4gtnrFkJBTyGeZ/ObSC/SHaNQ0tmO
         5oqPFdJ0kll5UJObN28ANLFKlpN4ywH1K5ZECVGI/gQLsb66nKumxSyYoJ2mKzS9KmiG
         s6jA==
X-Gm-Message-State: AOAM532ygx+3Z4LI1P3rvFgcC31QIF0TuHEO6jh2s6UUKAg9pCDA9rPY
        /SvwycHWZmvdYUo5BDIu49FJZYsIYAE88Q==
X-Google-Smtp-Source: ABdhPJwieC09ln8+Zj9qbJpqIcx8ETJLdxCijQyW+fnTD+Fds+5rjRHvSpypGupl7AtuM5/M3uGk2w==
X-Received: by 2002:a05:6602:737:: with SMTP id g23mr6664051iox.49.1624832597462;
        Sun, 27 Jun 2021 15:23:17 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id g4sm7539047ilk.37.2021.06.27.15.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jun 2021 15:23:17 -0700 (PDT)
Subject: Re: [PATCH for-next 0/6] small for-next optimisations
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1624739600.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d78e2a8b-58e8-4e12-c5b2-c71df6020def@kernel.dk>
Date:   Sun, 27 Jun 2021 16:23:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1624739600.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/26/21 2:40 PM, Pavel Begunkov wrote:
> Another pack of small randomly noticed optimisations with no
> particular theme.
> 
> Pavel Begunkov (6):
>   io_uring: refactor io_arm_poll_handler()
>   io_uring: mainstream sqpoll task_work running
>   io_uring: remove not needed PF_EXITING check
>   io_uring: optimise hot path restricted checks
>   io_uring: refactor io_submit_flush_completions
>   io_uring: pre-initialise some of req fields
> 
>  fs/io_uring.c | 91 ++++++++++++++++++++++++++-------------------------
>  1 file changed, 46 insertions(+), 45 deletions(-)

LGTM, applied!

-- 
Jens Axboe

