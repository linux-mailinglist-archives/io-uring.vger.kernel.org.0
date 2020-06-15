Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027601F9B62
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 17:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbgFOPFA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 11:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730847AbgFOPE7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 11:04:59 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16C8C05BD43
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 08:04:58 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id s23so7935079pfh.7
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 08:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vbfKhiMK9FyLJ1R4wzHm2mLCW6oCsbN/2Vi0OJTPAQo=;
        b=UV0mod8bg56pi0FyFJpgtMlX23de2Qm5wpkixqrt/9rDVU8HADl5f3aptV1rzGXfOc
         pdvaO1DPQw/7ZN2yh1ipYAxvd4STNxMN40fG6yYJjYYciSOWbbK2xQh43Sme7Bfh+0dH
         gH8kOHv7RSrwH7tVO8IdxgjKLzQNji9ociZNigE12wE/ZOjwhHaELO4xGjKlIkrkUYDF
         LWMMZW1dQT2alUOz/xDDBxSE98NHQ1W4jGIm2ZLc2VCNpTjzzK89m0oSUfByWMXvEaMA
         2mPQPJE+ZJTMGqO1PcUvZZZXmRFNbXYJKIo++8x5u6P+7OLhQ+5H86ksYFaBwEQnd8Vp
         U4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vbfKhiMK9FyLJ1R4wzHm2mLCW6oCsbN/2Vi0OJTPAQo=;
        b=pju50Ik1YUL4WLfi8FdNyMSr4hre3PVZKjxEH+yLBNI7Ne8nM0uheVTothrUOHl1hN
         4xlDQe7yzIgH0Z5fWUbnplzOcnOuwcjwMZnc8Manoo7jNjZUWSuZb3zMj29Kwu1RoXkL
         DSVXurd8WnBrkwKcZfhqlYv1Bfw7qW5yiYrUzZMEdPtZc58/rKPARhIOTl+U4t/93+4F
         kBMwhJ2Dw1bLUoTDr60aIafrrgNT9LSrPrxKlfQop4thqFYiLKcitmL3SsMAm2TcDUU0
         pXhZvDBEdMRfwbp+pfFc09E2rOyYJeYoA6BgOjKC9aiKQC1xo+63aaQVnr9B2+wYBmwL
         T1Lw==
X-Gm-Message-State: AOAM533XBiLqtb+hC75ZHjYPhkE/snDKZ7rdL0Cri8Ep6ZB1Vh+ot7Cg
        XFqYcF3g4wOdmsklPcOrg3IrwQ==
X-Google-Smtp-Source: ABdhPJzkLU5Mcmvc37UJQiY2VC0UwaTdz+1le9AnlfiahfbjtwzkcjdaekcYs22ELcQo+GXOxRaqsQ==
X-Received: by 2002:a63:5c55:: with SMTP id n21mr20644016pgm.27.1592233498289;
        Mon, 15 Jun 2020 08:04:58 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b10sm11376026pfb.110.2020.06.15.08.04.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 08:04:57 -0700 (PDT)
Subject: Re: [PATCH 0/2] don't use pid for request cancellation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ebiederm@xmission.com
References: <cover.1592206077.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9b90fd1d-c60d-523a-b6b5-6c960ae52cc6@kernel.dk>
Date:   Mon, 15 Jun 2020 09:04:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1592206077.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/20 1:33 AM, Pavel Begunkov wrote:
> Cancel requests of an extiting task based on ->task address. As
> reported by Eric W. Biederman, using pid for this purpose is not
> right.
> 
> note: rebased on top of "cancel all" patches

Looks good, and I had the same thought of not grabbing a ref to the
task for the cancel case where we don't need to dereference it.

-- 
Jens Axboe

