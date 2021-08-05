Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9533E176D
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 16:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhHEO6k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 10:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbhHEO6j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 10:58:39 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194E9C061765
        for <io-uring@vger.kernel.org>; Thu,  5 Aug 2021 07:58:25 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so6544367pjn.4
        for <io-uring@vger.kernel.org>; Thu, 05 Aug 2021 07:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ue1VQ1SLekIZ2ciYmKp7aO77mtFyct8IjNrmqz7y94Q=;
        b=Bv0zuLBNn5SdJLYbNrnqmgPg7u4ITz4a4T0OeMX28F+R1/CFcsr49/Yl2EW/tA/qBR
         Bl35ls2SjSRRvCA4kBmfUtlbYCirkj9qWN0FyHWDL65xlCrzOf6SqlYeu76RuerGB+Vh
         CFUtee5xHE0J2BFQ8/WBYk1wzg5gMVE+Ci0zrgLLCM8iNk4Z59ggmMFTT3LFnIFxjiQC
         M5wgN9dl2esT9+0+C3ZXHqWU5jz4cyeY2SoajuA4jbZok7X0dyeWNF1poLwuHW5f/gLV
         yWXUbD+n0POmJYyTMZKSkoVuMFBu/stwvkAHTPk30YyssoYPqM39GVHPv91/iGMBSVKo
         SRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ue1VQ1SLekIZ2ciYmKp7aO77mtFyct8IjNrmqz7y94Q=;
        b=ZvZMWmcz/r9euF5VAVBk5fI6hEsL87wP8dkq0LIEwBLloLdz34hYzZ2Kl+kEQ0tbbk
         LaFaYZ4XdsGp+fmSKuXy9UA6q/vP/8Pg5ySW1Pz2wiHMrbGQMXqCA7OkGt+H2Nx2jSts
         in7mVIHvk5A0pyKs6gb8siYhYjZOF1XtfPpzC9KsSLsWDou21iGikgSEWEp0KhDk3qPv
         xsqSN2sBlsXy19oCaO1EZibuen0KQmk5ifwhIXXw5YCezP0KC+CxbxOAhKjw8ASO4Gb8
         9Ggm2x48p2GhecE4cFC8CJhLw44yhct6Uwc+KKn1nQnH7UeVqaF4/aSa4bXrnJExF4jW
         PWPw==
X-Gm-Message-State: AOAM531ZaT98Z6PJ1jX5DmIGCxw0mdEAa16TvMSFcGxX/rbJWQrosSHM
        b+YGAQ9HUd8s9BHd4yS53IaEpM9XCHVDKkog
X-Google-Smtp-Source: ABdhPJzD9SC78isFj45WbAELj8XeIBmwU0iG9/q9yAm6A5Qv0WSzGwPEzDWP8hI0ZbO2tBpY4ZQJuA==
X-Received: by 2002:a17:90b:4b46:: with SMTP id mi6mr5138016pjb.234.1628175504487;
        Thu, 05 Aug 2021 07:58:24 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id h24sm7245922pfn.180.2021.08.05.07.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 07:58:24 -0700 (PDT)
Subject: Re: [PATCH 0/3] code clean and nr_worker fixes
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210805100538.127891-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e124b236-c72d-ec35-3ed8-61935bd440cc@kernel.dk>
Date:   Thu, 5 Aug 2021 08:58:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210805100538.127891-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/5/21 4:05 AM, Hao Xu wrote:
> 
> Hao Xu (3):
>   io-wq: clean code of task state setting
>   io-wq: fix no lock protection of acct->nr_worker
>   io-wq: fix lack of acct->nr_workers < acct->max_workers judgement
> 
>  fs/io-wq.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)

Applied 2-3, thanks!

-- 
Jens Axboe

