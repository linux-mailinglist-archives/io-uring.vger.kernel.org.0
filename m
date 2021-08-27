Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B213F9853
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 13:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244836AbhH0LCm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 07:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244780AbhH0LCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 07:02:41 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21144C061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 04:01:53 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so4092662wma.0
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 04:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YknIqqkmRZVfoYCrCvTnqoKz5K5krrOzNOAxYAaEM/Y=;
        b=GepskwoaESkAApOPE8t+FQni1AdLtdPyocr77pwGkIbQm/UDYSoXND0SDass/Ysdis
         4OEJL8QMfKzosCiVcAw8L3msBk65CvQAY9o4U4tjJwtidmfvXmeCkCcRVj3a9VEtiIe8
         R3fUoJeek5xEOPCqtNFaewum0yST796mnmjwDYLu6l/AF4kI1xwbh1zkGgkGQj2YZQCw
         QmwUnr1YIoV4UfxdaCgKdCjeOtZZemXp0dBG1AV5lcQ3c6Iyz4BDSYEzuCd5yqc6KGQ+
         JpTtnN4nbA2jq2oIppBJqBtYGPT+iOnITwwQI5PVWJkCUeWOKH9/zUf1hqpmeL7AHgvo
         QkDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YknIqqkmRZVfoYCrCvTnqoKz5K5krrOzNOAxYAaEM/Y=;
        b=FBv6jRMrKLcWcjJtzFSXip3NccbMrBlXKmtjwxkNrsajzcEEOQDEDeFOXvO+WInPDn
         hOLtx3Ue+MGVejaOHqULY0fCYWfgp0fVoStj4RhLJvNF6J2o4PtceClCKzuWwltS8aTo
         w/4eyRGo/880Wss+D0uV57F69BmRwecKK6zM+2xELvWNYhq8xYCnrnUenxqiC5letlkL
         T6jY7baJ8QGOBc4bhCE6J+m3dRx/kOsJ8VEZiPjpO1ktS18/4qbPQKFgSK+YsyQXYAka
         kblNznm8cuM/YNGmRYo+RS4EH1Dm8iAbq3E4/k6jiFNbWLCoPdYKMMtP/IvBZu9OZdSW
         tjGg==
X-Gm-Message-State: AOAM533KkIetox6Y22g8KTANLJOZpf9QmaviN7ZF5eiDpNQEJlNuiCYI
        MgnDia7t4AoQSpYMVDf/ptQ=
X-Google-Smtp-Source: ABdhPJzW6uok43rwzf1uUXxc5wFqjuu9kDqrDOQVbRjF2iCzg77ZuBxJY6BBw6TvdUbCCkGstX54pA==
X-Received: by 2002:a05:600c:a41:: with SMTP id c1mr8069748wmq.109.1630062111678;
        Fri, 27 Aug 2021 04:01:51 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.94])
        by smtp.gmail.com with ESMTPSA id 18sm12091571wmv.27.2021.08.27.04.01.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 04:01:50 -0700 (PDT)
Subject: Re: [PATCH for-5.15 v3 0/2] fix failed linkchain code logic
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210827094609.36052-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <99ef07a1-d072-5970-6c9a-df388026a01e@gmail.com>
Date:   Fri, 27 Aug 2021 12:01:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210827094609.36052-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/21 10:46 AM, Hao Xu wrote:
> the first patch is code clean.
> the second is the main one, which refactors linkchain failure path to
> fix a problem, detail in the commit message.

Looks good, thanks

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> v1-->v2
>  - update patch with Pavel's suggestion.
> v2-->v3
>  - move req->result initiation to better place
>  - add helpers for failing link node
> 
> Hao Xu (2):
>   io_uring: remove redundant req_set_fail()
>   io_uring: fix failed linkchain code logic
> 
>  fs/io_uring.c | 62 ++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 47 insertions(+), 15 deletions(-)
> 

-- 
Pavel Begunkov
