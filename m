Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7E73E83FF
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 21:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhHJT6N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 15:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhHJT6N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 15:58:13 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F92C0613C1
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 12:57:50 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so847481pjb.0
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 12:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/z60Hyb0AKG8nWSuCD21tqavMKZuWqlNh+umF7ewqkg=;
        b=QEe+/CofRGHZFYGBG5B7WIONdcKiAqkX4NFjzweHOxS6IJy4xDpeOA3VxPyrea2sUD
         P2pQj8q4pgKCWFHvD/rXbvbc51FN9pluhXaHEkyJg/jJ384NNydneLSSMer1+pYBtnb4
         Q6nSsnKVveactdDNgVvkNmhkfRl2dA623HCFhPBrrxQItqOopgIZUyv5NvT7i58OdsCJ
         qErCYS897k73X4MvFHMclbqitP7i+JCgh3y/ptIbNvxaJcRlrl7KsjBeWMSxD+6azHaU
         PFUCNpr/NW+RYxEIVd9b6V80KYleg0inls9QRSfUjieuKKv5yJrrUeq8Kyxu/8P1N8Co
         Glbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/z60Hyb0AKG8nWSuCD21tqavMKZuWqlNh+umF7ewqkg=;
        b=LrZUVNqu7mCgUeXs5Q90salpulp70Cn55h8SOaYaF+8RIjxGCTVqqQStmbYyYD2cXa
         mPdCrHCFstncGBTtUcD3WOc2QCC1MuuxHKW0zJKE4BeyKenL1twQyXbH7TFPMJOm/sIp
         mOMh9DMp64MV0kDQtgVALFi1vFMlla06IVa7Tgot6ZvWdinTaTo+viwuA3N54UdAH41g
         wG1hGL0AVNzl7nzKgZ3DcNXhh7+1x4L04ehqEA9IHih+9sQEumPdsx9blRT7pef0Lqwe
         mXCmOU86VrKfOYMlTXz1JHS79c/vZp1MMNCbyT/ReTc/0gO7CPNZP9oMo9ijRz/XIUEy
         2Jxg==
X-Gm-Message-State: AOAM532vT+ZEw+XihAbmZ9oqnLzyTdQkRR+xQT4Y7cpm0F7vTVc3Bg9z
        7Im4CWIn+h7eeSM2BbSYogSfpy7JbTjtG5Zj
X-Google-Smtp-Source: ABdhPJwMmw9DpBuEll5RQwmuHT/GQCRX4lMBONdyMiF0ALBEWlR5T9C43YSqhHWd/gg1s24Iycu4/Q==
X-Received: by 2002:a17:90a:2942:: with SMTP id x2mr6469779pjf.95.1628625470001;
        Tue, 10 Aug 2021 12:57:50 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j16sm26443448pfi.165.2021.08.10.12.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 12:57:49 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: clean up tctx_task_work()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d0d57262d757b564753c3e0b564a3a79e42095d5.1628614278.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <432f5ea7-c3b1-48a5-3694-54db03699302@kernel.dk>
Date:   Tue, 10 Aug 2021 13:57:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d0d57262d757b564753c3e0b564a3a79e42095d5.1628614278.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 10:53 AM, Pavel Begunkov wrote:
> After recent fixes, tctx_task_work() always does proper spinlocking
> before looking into ->task_list, so now we don't need atomics for
> ->task_state, replace it with non-atomic task_running using the critical
> section.
> 
> Tide it up, combine two separate block with spinlocking, and always try
> to splice in there, so we do less locking when new requests are arriving
> during the function execution.

Applied for 5.15, thanks.

-- 
Jens Axboe

