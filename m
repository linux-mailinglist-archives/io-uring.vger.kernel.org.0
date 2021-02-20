Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6FD3205C0
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 15:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhBTOjM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 09:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhBTOjM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 09:39:12 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C0AC061574
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 06:38:31 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id k13so3765457pfh.13
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 06:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KNnACSMUPBkXXr+ofKmLdjUoP4p0WWr/DFAY1PtXw4o=;
        b=tDJ1P9aA32+ESLYdSaL13rg0kjH9fr4/78R4NLqDA2CgYAtx3pws7YJIsbKqcOxGZs
         GpQsOhL+l7Yhg2BxbTa1hRdPXxAKNoHby5yB6bhxyzgYtUWzEempkzIXK5vWBdD+KVkJ
         9A5qiaFh5kiURPrTLTzneCp9yX6hD43cVr1tQlgel8vIirCveMAUt2ML8WIn7IEON1Wq
         QyU+OaSoVrf+vuTvoRvGcddFd1eGgav/JMUd0RdBTstmteuBCAGzZe23sV5IFapkBr0H
         4qdPGFeoP3wGIErCBYlBDssUbjklpwlHv+GvbFIic0EIW9HuwIdBooU5VE7mBUUfIXiB
         hGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KNnACSMUPBkXXr+ofKmLdjUoP4p0WWr/DFAY1PtXw4o=;
        b=Gd8P0axGHxT9S2Ev1rEuz0Oy+hVg+dIfeMMLYZ0H5Ewa68MhT4/OFzFEnahkADkSW5
         QFH/IWrV3I47RSjK80q7KtywNYKCZnAJ1TbW0oc1ADA5B384mwJ0Q6s+PEn7yVuPEC5t
         Eq9Exld4BoDt+v3/cDooA9fBIpkw+cTOG3uJq025clpsTfo+U+sGt2BMSD498/U1KNhd
         AXROc2aWvt+7ab5epZwFcgyjztf8VPy+twqBt1NiQLdFKKiyTzZDz8radUPkkUnHyTpY
         X2CPUJu9qLGQ25xeAo+fydoMuKn6r/d0zXrL5Omu3RJ33aIAffaGP8jERbRb0qV6zloB
         WmRA==
X-Gm-Message-State: AOAM531zgOL4XRoDIEo5PLC8IkmeY/mWipzyLincp1BOD4I1cYT7kUJq
        jjguEb9MHLH/WQhBKUAgvWm4YEFu2X6AAA==
X-Google-Smtp-Source: ABdhPJzhrfE+2/Ik9uNBk7kOHyRBKcNm5l5vqlXpgnXrmxDW/u+i9iiv27+2Auua+PSKKkEqJ0xuEA==
X-Received: by 2002:a62:e703:0:b029:1ed:5a8b:4308 with SMTP id s3-20020a62e7030000b02901ed5a8b4308mr5566767pfh.67.1613831910945;
        Sat, 20 Feb 2021 06:38:30 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w6sm171126pfj.190.2021.02.20.06.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 06:38:30 -0800 (PST)
Subject: Re: [PATCH 05/18] io_uring: tie async worker side to the task context
To:     Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-6-axboe@kernel.dk>
 <45d8a997-7a1a-7d07-9039-6970acece61b@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fe6810fe-7828-a4d2-a92e-5f3c4172b94f@kernel.dk>
Date:   Sat, 20 Feb 2021 07:38:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <45d8a997-7a1a-7d07-9039-6970acece61b@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/21 1:11 AM, Hao Xu wrote:
>> @@ -8167,6 +8153,14 @@ static int io_uring_alloc_task_context(struct task_struct *task)
>>   		return ret;
>>   	}
>>   
>> +	tctx->io_wq = io_init_wq_offload(ctx);
>> +	if (IS_ERR(tctx->io_wq)) {
>> +		ret = PTR_ERR(tctx->io_wq);
>> +		percpu_counter_destroy(&tctx->inflight);
>> +		kfree(tctx);
>> +		return ret;
>> +	}
>> +
> How about putting this before initing tctx->inflight so that
> we don't need to destroy tctx->inflight in the error path?

Sure, but then we'd need to destroy the workqueue in the error path if
percpu_counter_init() fails instead.

Can you elaborate on why you think that'd be an improvement to the error
path?

-- 
Jens Axboe

