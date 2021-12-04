Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2192E46879D
	for <lists+io-uring@lfdr.de>; Sat,  4 Dec 2021 21:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355723AbhLDVCC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Dec 2021 16:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353461AbhLDVCB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Dec 2021 16:02:01 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F71CC061751
        for <io-uring@vger.kernel.org>; Sat,  4 Dec 2021 12:58:35 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso7493096wms.3
        for <io-uring@vger.kernel.org>; Sat, 04 Dec 2021 12:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=I08e73UT5TNnEZdv9qbbhUd8WvRfCpPSmKDvUWTOzIc=;
        b=Lk0J2qgs5GdkxwBJDphNcQDcNnSuFC0caJ9s2a+PHph0HrYmY+bbRg+M7uDYl0j+lI
         yeXrm3vhw3LJbVqP5M5YLZgNZmL+POq8NHvL8RnZBQEkzZ1h5Oe1PtKjwNq2SCWFG+cl
         KsdTOu/SjmPABlKRD1Q69T6dvwtulA3Uk+TBuCVL7aFY1ut64OWXWqcX2VCIbQdePJ32
         kxW9ee8m2WMJAhnR5q4oaVmAOB3rygYrn9NCVviL7CBunBJoXcl/t4WV1wxJ8PQknPGq
         muumS2Yf/u9XU7h/8GKhoVWpeDdXuLFid3k5vI9m8I7ujsmnd4ib6npl2MttRbh4cDFC
         Y8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I08e73UT5TNnEZdv9qbbhUd8WvRfCpPSmKDvUWTOzIc=;
        b=45emf9HVoVXhCFR3++kSjQzaJWc3MSvFDrPvAd2NvKh84dkt8P3ehboleABuPe1x4G
         uFN8O1Kx5zeZR8T2jY4O3VbhkAW87kl+Pp9hBsLFMwfUbIBGn4pTZZ3mT1bUN5y5QGRJ
         erEpnifBNUg75yIbaKBWYSQq54bMGu6zKNGp/Zxo+MOB7b9oE5r0zCS28ziw9+6n3gKl
         33lEKXWz4sUqQocdBw04gSvuzvZlvdXA5t3e9xE4A48TvJJax1gyThZZi46hFMvjX862
         9eaXdDc2hbXyRBW4B0sr1TmkYeg6pxRGvVXqbGN/8hjPYrjI8DU9rZmpW77xDegmEkq3
         OYTg==
X-Gm-Message-State: AOAM531tivYF/p+meqEC4Xt5t4Nep3UNBd2yN0h824Wd2Y0iSYIn0HQ0
        Dhv3LvuvTNG5fDw6Axkbbw08T9MxkKQ=
X-Google-Smtp-Source: ABdhPJwX5KuW00D5x9WxD8qoAmApOkCCF24BTj4lOEos4k3NAKCGl3gH71ZOh7p8KqsU1UerOxJxVQ==
X-Received: by 2002:a05:600c:1083:: with SMTP id e3mr25443218wmd.167.1638651514115;
        Sat, 04 Dec 2021 12:58:34 -0800 (PST)
Received: from [192.168.8.198] ([148.252.132.146])
        by smtp.gmail.com with ESMTPSA id x1sm6428195wru.40.2021.12.04.12.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Dec 2021 12:58:33 -0800 (PST)
Message-ID: <7184b704-5996-e3b5-a277-7a4f446b2f82@gmail.com>
Date:   Sat, 4 Dec 2021 20:58:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 0/6] task work optimization
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211126100740.196550-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/26/21 10:07, Hao Xu wrote:
> v4->v5
> - change the implementation of merge_wq_list
> 
> v5->v6
> - change the logic of handling prior task list to:
>    1) grabbed uring_lock: leverage the inline completion infra
>    2) otherwise: batch __req_complete_post() calls to save
>       completion_lock operations.

FYI, took 5/6 into another patchset to avoid conflicts.

also, you can remove "[pavel: ...]" from patches, I was just
leaving them as a hint that the patches were very slightly
modified. I'll retest/etc. once you fix 6/6. Hopefully, will
be merged soon, the patches already had been bouncing around
for too long.


> Hao Xu (6):
>    io-wq: add helper to merge two wq_lists
>    io_uring: add a priority tw list for irq completion work
>    io_uring: add helper for task work execution code
>    io_uring: split io_req_complete_post() and add a helper
>    io_uring: move up io_put_kbuf() and io_put_rw_kbuf()
>    io_uring: batch completion in prior_task_list
> 
>   fs/io-wq.h    |  22 +++++++
>   fs/io_uring.c | 168 ++++++++++++++++++++++++++++++++++----------------
>   2 files changed, 136 insertions(+), 54 deletions(-)
> 

-- 
Pavel Begunkov
