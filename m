Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010C42D8913
	for <lists+io-uring@lfdr.de>; Sat, 12 Dec 2020 19:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405078AbgLLSMQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Dec 2020 13:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731634AbgLLSMQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Dec 2020 13:12:16 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23269C0613CF
        for <io-uring@vger.kernel.org>; Sat, 12 Dec 2020 10:11:36 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id y8so6402430plp.8
        for <io-uring@vger.kernel.org>; Sat, 12 Dec 2020 10:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=roKdRrgCfk1pxyi4++bxowGtvxEYB4UlBYmPiftIIBY=;
        b=KdNAOl/oMsXjtgnHlQtiayNkE6CYm1XaMXkiFjW/NqPpCJwqeAb+X4NVklXHTrXEr1
         Y9cCy/bqV5c2FVoCHeo+F+eSWmor/yVzCnRsqeFhxrrZ5Lkisd1k+lwfir6miECZzAXq
         gLY4ZIvCXFAc+8yWPO+Mg12MTXePT0ssWLswXE2c85lqcXfMX21rrlqgCdAY6j3+XG6p
         7KqltC0Zzq+vRT+3GteXomqPwgOLaMATtqLLsgWrc9Lxk1qsfZkF0iLZON40bPz8+bM/
         Hu5Tq3eqnErQb4a1lg/yPcl5e92mT9IOjxwTiYPBEMyXQ90jfTKmkHoJwUMStSUEUmHx
         FTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=roKdRrgCfk1pxyi4++bxowGtvxEYB4UlBYmPiftIIBY=;
        b=IkwA+qLnB33gfwVI7hDDHOGLoPHGQbKOEPZvGNDWdFDwKQeZ2p66jw6RO2LHfh6R9s
         c5MEUIgPVUgeyRQYZTSl90S6OSNuJcgWUbjQSeQjMIjfF7t063WjtXMeML+28u/9T8H6
         uAi8ImwvLAKZILqnWn7ryPR8ZA2q9EDcM3Y+QcUBora08vQY5tuAgwBrJj8OnMn5oH7Y
         o2RoudFeJGUuu38u9EyreZRxfmAapBRuk+m8pjCAoEvAtCqrWbYYHrRTWdpLgn/dVLa8
         XH8aE5PF4ZIBpq6LZ1Mc3Jgl2v7j+IJulSEOfNmn+xBGMWxvXceAPxgqqycSelYImyjX
         WHJg==
X-Gm-Message-State: AOAM532ofo7ktRsTC4qk8Fu0enoVD4m7wvaQq/EErf/Kf++RSwfPE3RN
        d3eBZ2s8/lRvzmuUOpy77yvNUA==
X-Google-Smtp-Source: ABdhPJwN0+DGqb7Rca2cSbByKSpkCZPZc1TnEdEveMrsufdOecBKVaiZ3H0/mahdpxzlu9UiPvqhJA==
X-Received: by 2002:a17:90a:c905:: with SMTP id v5mr18321486pjt.183.1607796695635;
        Sat, 12 Dec 2020 10:11:35 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t19sm15975260pgk.86.2020.12.12.10.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 10:11:35 -0800 (PST)
Subject: Re: [PATCH liburing v2 RESEND] test/timeout-new: test for timeout
 feature
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20201211101121.uk5i75uw2fln3zdh@steredhat>
 <1607748579-92734-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4533cff7-6d26-26df-3804-6f424359a984@kernel.dk>
Date:   Sat, 12 Dec 2020 11:11:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1607748579-92734-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/11/20 9:49 PM, Hao Xu wrote:
> Tests for the new timeout feature. It covers:
>     - wake up when timeout, sleeping time calculated as well
>     - wake up by a cqe before timeout
>     - the above two in sqpoll thread mode
>     - multi child-threads wake up by a cqe issuing in main thread before
>       timeout

Much more thorough test case, thank! Applied.

-- 
Jens Axboe

