Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28336402BB8
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 17:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345190AbhIGPZ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 11:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345234AbhIGPZ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 11:25:56 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275EAC0613C1
        for <io-uring@vger.kernel.org>; Tue,  7 Sep 2021 08:24:50 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id b7so13363656iob.4
        for <io-uring@vger.kernel.org>; Tue, 07 Sep 2021 08:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LAvrd0RoV9cdxXwIYq6Q5+zHtHMu/ucdhKiIgwfuJik=;
        b=n0pZ39Zq94ek99qQTQokSVIh73fuP2qsSoJ1o6WdLaLQ0ACJ6DrGGhmJEq7lDmjBTm
         fmhHc9hM4c431zNsU0Q8dlNIinmD/SAU2hvhZP0uHWkKRgG++a0pibPTENfcyCb5z1im
         wvy7yvSXjs8bnICus75QcTJeSjhpzAbE62pwCwlzBMfIhsIIQoiRAG/22BBdAbHZD7xt
         UQb28eYuQueuEJTsMZi70vcn68SgT2gSMfWch6e6V2rUevZnGfqcGP2IQr8PHhWV5hbB
         oXXgu2X+Auv9kwZnwnDA8J8J3TJsndLJtAyVVz+mW8itwumtZJ+VOFkGwrf2LN9gPrQ/
         kZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LAvrd0RoV9cdxXwIYq6Q5+zHtHMu/ucdhKiIgwfuJik=;
        b=Xgyb4hWcFozUGu/3YlKd9LeyFHEds8Q2j8dI+ajIBP/bfG07wPx4PvoAWeHlmVcbSa
         J0AXbGClNs3Nw46mG+tVh2+j+tBndedV1yIMUbCUZwtBZf2AiAQc5RxC8WdSe8i79UWN
         EkKlBc6JAFjsnmH6UT4wmakmX286anEHPycOEpvypLeBYPTHF7LY1zGytsfNdyeEOcMC
         FZfwY7iRgAu9bVDA8yiHMkiNSGQ+6W9MBO1jOHvlJndIsOc6PMlWCVcPFgz7ll2mOfVm
         2UJbmCDrq09298P4DY/asX6cMqCccnU8J6g8OmFxlQbn0ZCNq46dCPQGTFNe1PZRKpPl
         J9Uw==
X-Gm-Message-State: AOAM532jW2f10p6L+tOuZn1rlDNhRoiVwzIFpMuFA5tOk3NO36GM7rSt
        w+Ef2OPZuFe/NPkwFTaqmr1f0sUkv04c+Q==
X-Google-Smtp-Source: ABdhPJxgmzE8B3uVBdOf1ALri2PFCDxmXz3nxhTe4EMjDlnsdXCBZ4J7O9EQ1TI8Aq3YyNs7lmDZOw==
X-Received: by 2002:a05:6638:1642:: with SMTP id a2mr16061736jat.88.1631028289464;
        Tue, 07 Sep 2021 08:24:49 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s18sm6304945ilp.83.2021.09.07.08.24.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 08:24:49 -0700 (PDT)
Subject: Re: [PATCH] io_uring: check file_slot early when accept use fix_file
 mode
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210907151653.18501-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3ca81c51-87fb-2f1d-f3f7-92abafdd5cca@kernel.dk>
Date:   Tue, 7 Sep 2021 09:24:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210907151653.18501-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/21 9:16 AM, Hao Xu wrote:
> check file_slot early in io_accept_prep() to avoid wasted effort in
> failure cases.

It's generally better to just let the failure cases deal with it instead
of having checks in multiple places. This is a failure path, so we don't
care about making it fail early. Optimizations should be for the hot path,
which is not a malformed sqe.

-- 
Jens Axboe

