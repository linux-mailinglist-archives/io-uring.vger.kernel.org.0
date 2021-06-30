Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29843B8A13
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbhF3VUK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 17:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhF3VUJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 17:20:09 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9EDC061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:17:40 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id g3so4312865ilj.7
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZJUwk8K9XYgRnENVNODKEi53QEvKtDZRquSfK1zf5vQ=;
        b=fCbdjy/chKXor8MDu0LlQfpggXgv0wrQYUF5rbAjETgOSYUGEGcrJfBt39eQb4wmJf
         TkReGRiZtYYOxSy05ZLXLmJVdKwGRAh/dY2Manac3QVQ6hYwp4rPrnnaxJpTBMBN4fzZ
         LB/OCdjw+QeKOXzNIslKL/368uHW2+QZFGuV6WebjPKTwXJ67YwRgd3fj1retnpJb5U/
         3HxscKo6S5mkk71TUnlyWfIDHVjFwnI5oh8FWde/nAWu4Rzdiz0x9k/S3+3jHU9aWulp
         /+Y37FyY4GVk3Hb4KRvmmkR7CmTnAO1weTQzGKASzCxr5aX7/OQTapM3KUNigW634apz
         rlWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZJUwk8K9XYgRnENVNODKEi53QEvKtDZRquSfK1zf5vQ=;
        b=k3Qjfe5RKaurWuGtbimmqjzZUyPWd9VTpzpVjQ0XsqsUi1H4PYGbnY9zqeoCPujGTV
         sahK38Eb99bMsXMZ32PRaxAO42PX7JIB69qLwzPpiUzkH8RLUBb3auuMvgjsj8qOY6JU
         goMMEc+4ddq/42v6SP0DQE3ABm+p+6PZDSm4z5RKdbhOowkgQYCagOBP01aVnKShjd5X
         EkwysS+ZVsgFBWowYQ5Xu/T3JuvRiiY4gZ8dayYllcAzuG/YHeujFS6XK/aZuXhzFTQi
         v+Ri4eTP1s5KrUfj5/hvTM+3u+GI3KjIxNPIT+A1VPnoavtJf7C4UQSjQgxLV1b68PfJ
         M4bA==
X-Gm-Message-State: AOAM533amoRPfxx6kOk+0WMbbdZUq45v/NdwA3BXnkfLGujs0gk46a/B
        nhnZRPKjs9mNr0GUBvz8kQTX4EDRcqgkfw==
X-Google-Smtp-Source: ABdhPJwXkRmT64xegznljgjnD1hu1Uh/tePeWS7GxY/hMOx0WS3ujphLS/2DoeQNSQWdMso1hKrjmg==
X-Received: by 2002:a92:de45:: with SMTP id e5mr20837807ilr.157.1625087859603;
        Wed, 30 Jun 2021 14:17:39 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id g5sm30868ilr.87.2021.06.30.14.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:17:39 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: tweak io_req_task_work_add
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
 <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <70c425a8-73dd-e15a-5a10-8ea640cdc7cd@kernel.dk>
Date:   Wed, 30 Jun 2021 15:17:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 2:54 PM, Pavel Begunkov wrote:
> Whenever possible we don't want to fallback a request. task_work_add()
> will be fine if the task is exiting, so don't check for PF_EXITING,
> there is anyway only a relatively small gap between setting the flag
> and doing the final task_work_run().
> 
> Also add likely for the hot path.

I'm not a huge fan of likely/unlikely, and in particular constructs like:

> -	if (test_bit(0, &tctx->task_state) ||
> +	if (likely(test_bit(0, &tctx->task_state)) ||
>  	    test_and_set_bit(0, &tctx->task_state))
>  		return 0;

where the state is combined. In any case, it should be a separate
change. If there's an "Also" paragraph in a patch, then that's also
usually a good clue that that particular change should've been
separate :-)

-- 
Jens Axboe

