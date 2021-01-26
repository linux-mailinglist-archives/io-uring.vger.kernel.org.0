Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D98304320
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 16:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404209AbhAZPzI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 10:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391988AbhAZPzE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 10:55:04 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDC1C061A29
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 07:54:24 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id md11so2232605pjb.0
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 07:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PZOLoVuvm5QhtuKFIupm4PN01M798w8wneoB4FV9TAo=;
        b=KOFrEkVOKQWkLffCVTABXrsLu7h1pATNrT7kcOWcYsPLuliMqWX3XvwpX2MYx6/V//
         nNKyP6OsxeVaplvq4eftrEGFXt3MRNiGbX6/Ny0cI9pvcJEG83BxcRmM2hm8gxxcNVdd
         piORSLbv3MpMsKEGy1iMfsCzwfG5cDRmBAxndURT3t+t/B89kn3C8zGT1yV5kjlx+wln
         +TeKMiV9+dz4NQs6Pf8cvmjs8AwZrF7NkKLLSip+GmeN3BO4QNMqQPCEd1/Uxw4N+JcM
         8WRPLyWDw7mgiTADurS+h0Vtho40Z+zvvECuQadpm5ht+XMuyM8BnxtEkm+MlNdRFvP1
         oUYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PZOLoVuvm5QhtuKFIupm4PN01M798w8wneoB4FV9TAo=;
        b=O6AIQh3odgooHmYWh62u8Pw0rbjYTfYrTglfyjDxY7aBs0crAOWObsWMwyc3oIgL8o
         uHIOMDsvwu2n/2zHB0u6WdlA3TLorMDhcaD5KUQWlBqSAwPAHk2iQnyDsvlXfkhuzQ4f
         gDp9mmTl0+1L3ULkyy1Pn0oWwpkpNc3+UtXPWJ87oFiuBdhqDpC+2bjXgrzKmSuSTKw4
         CgdDgdnCYRTTpc2ALn4uhxDJL4XvFwYZIHnKfdfKQcu+/mh/aHOtHr5dhPtASg5+/rA0
         XTDkN21Uv23FTmOJcjBIr8pWHGA3SSQpqLtaT7qeArLYLrZl1ltRaNg7V3z9pNZ5D+Q9
         NBWw==
X-Gm-Message-State: AOAM533x2t5aIZ9SdSsSUHjttey5gUYennQWu80t7c0vnU7PLBe5Lh0e
        rq3HZwQBr14mBPY93FaHiTmMoO3Oq/dP/A==
X-Google-Smtp-Source: ABdhPJxh+UZwhMuop7lK6SaZ3wNib5ZQafbb4qQJRvppVH6rt3+CZRnIChDVLWeGdFAIyuCVDIQG5w==
X-Received: by 2002:a17:902:6b43:b029:df:fb48:aecf with SMTP id g3-20020a1709026b43b02900dffb48aecfmr6742682plt.67.1611676463961;
        Tue, 26 Jan 2021 07:54:23 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id c24sm2814798pjs.3.2021.01.26.07.54.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 07:54:23 -0800 (PST)
Subject: Re: [PATCH 5.11 0/2] syzbot fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1611674535.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <15213528-c052-af6f-164f-85945a0c502f@kernel.dk>
Date:   Tue, 26 Jan 2021 08:54:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1611674535.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/26/21 8:28 AM, Pavel Begunkov wrote:
> 2/2 is a reincarnated issue found by syzbot, fixed by cancel-all-reqs
> patches before.
> 
> Pavel Begunkov (2):
>   io_uring: fix __io_uring_files_cancel() with TASK_UNINTERRUPTIBLE
>   io_uring: fix cancellation taking mutex while TASK_UNINTERRUPTIBLE
> 
>  fs/io_uring.c | 52 ++++++++++++++++++++++++++++-----------------------
>  1 file changed, 29 insertions(+), 23 deletions(-)

LGTM, applied.

-- 
Jens Axboe

