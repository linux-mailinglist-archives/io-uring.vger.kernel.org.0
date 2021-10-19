Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6474341E8
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 01:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhJSXMK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 19:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhJSXMJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 19:12:09 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBE6C06161C
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 16:09:56 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id d125so22355867iof.5
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 16:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8hD/b91dIyFBAhIbuYWF+GElK7R9wlEHdmX4K/L1Tw8=;
        b=zsNt3TgxohCrzPRbGT8RGjNXImWk9zumRps6ufplpWgcA81bwo6h3+43+dBmQTx9Cn
         IPCG2Rfy9o5NYzh8vNEuPC6qPeTaqQyAzIl2gYdMNH5p4Lsr805qseSzW3jCmo78mmJT
         VlCtuOVTZB3Fm9yu9exW4ZWto5+byHr+GCSQwca3LcCu8eJezUnleQV7LGqhiGGojm01
         5l57cGwPaZcHOg9vFvp9jXrZ8EjeFTnjzmaSFWtVmAiA/MzE6LEZJrEJV0YFbE5tr7bC
         /0oTMx3LPm0xZBG7IAlxFwgHkit8Dr9lKm9fPleX5tR14AucFfWo8Q01ijKIT5uxto5H
         6j0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8hD/b91dIyFBAhIbuYWF+GElK7R9wlEHdmX4K/L1Tw8=;
        b=Xeu0hoNsM1C+ph28ToEmb8CO/8BJBCAfnu2xNuWdCT9ZmARukXIb/W+ZUuAvLixHNe
         JvrJNNrvLEeF4vEZOWHq+bxyWnHfxRG3YG4zLhgmG33P0D2mrFdwVm38vgn0nrUoGlu0
         haf1GmZ1U0vG3il3/Pm1Zpbp2/bZFCDeX/oIJuZeyEIwiyMQ9a4rV/ObAEeEvfAAfHRo
         ObOSGZWrT7iE2zzngCl3lnfxvMg6BQgoZ4GrW+5ayigDglED6irwE9AkpktxxSS/yxbB
         tX3nWpRmq8r8l/M/GJbP5A/M0+Mxb/t54azNMNP31TDXr1u7K/IxQmq24Ol8E1oQHJXT
         k81g==
X-Gm-Message-State: AOAM533WP+6Fc/vrCeyTSA7U+NQ7isWZJo9TkvOKT6GhZ8DIPuWwy3Xd
        ySqBkDG9bDLxNJg7sHV8riCLVnXzh5Xgjw==
X-Google-Smtp-Source: ABdhPJxGYnGtP/ued/VnZOan+SA70+SX3PoGBLBZe9cuLd7cIs5opwCUiDR4eW5L4r8zZ2q2Q0TLVg==
X-Received: by 2002:a02:ccf1:: with SMTP id l17mr6378996jaq.131.1634684995388;
        Tue, 19 Oct 2021 16:09:55 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id e10sm197278ili.53.2021.10.19.16.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 16:09:54 -0700 (PDT)
Subject: Re: [PATCH 5.15] io-wq: max_worker fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Beld Zhang <beldzhang@gmail.com>
References: <11f90e6b49410b7d1a88f5d04fb8d95bb86b8cf3.1634671835.git.asml.silence@gmail.com>
 <242c1e1d-ffd4-5844-77fb-4ac0eb23ff91@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b781f3e5-7423-5955-46d2-ad36f0570df4@kernel.dk>
Date:   Tue, 19 Oct 2021 17:09:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <242c1e1d-ffd4-5844-77fb-4ac0eb23ff91@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/21 4:54 PM, Pavel Begunkov wrote:
> On 10/19/21 20:31, Pavel Begunkov wrote:
>> First, fix nr_workers checks against max_workers, with max_worker
>> registration, it may pretty easily happen that nr_workers > max_workers.
>>
>> Also, synchronise writing to acct->max_worker with wqe->lock. It's not
>> an actual problem, but as we don't care about io_wqe_create_worker(),
>> it's better than WRITE_ONCE()/READ_ONCE().
> 
> Jens, can you add
> 
> Reported-by: Beld Zhang <beldzhang@gmail.com>

Yep, done.

-- 
Jens Axboe

