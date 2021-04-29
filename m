Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E667E36EC5C
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 16:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbhD2O2K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 10:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239655AbhD2O2K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 10:28:10 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529D9C06138C
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 07:27:21 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id l19so13745955ilk.13
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 07:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oX7qYgxXYUDTnDWIrAAdrMAk23CW1FWOs8hQTp5c3yY=;
        b=U4mbRlv5UHD7sn2yKKFCrR+4XJ13UgOrePmZ9r2zi4LgU/UxNb72eYOLK/TvO7VUlz
         30WM7WkrcRFNI/x/ite+fOcgwI2QEtgUxsjoskRUTfetp2ZeV8V6EvbTQJQ8k/LVqLSz
         LkoD3TnCV+fTaXYxRE35BxH8SiXnv7w1dxW3bIcojZXcQEWKEdKLy4tpks1Cw+gUrAkq
         VuQqMkHFdQ0zszYyHwo5cmhjNf9iphNdIiDdkLefNDM7yiRp1rrPoe+45r/HOSWh/7WI
         vNsgd2MnuJMVvW5PuGtKQDv4GD6uCtf2xJAILqgH4/102fTtZdT3o7pZTZtcy7g1yg4X
         791A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oX7qYgxXYUDTnDWIrAAdrMAk23CW1FWOs8hQTp5c3yY=;
        b=NSIMrel3/sdX38rGIdWU1cBQEGp956wtzXN3VPvhbm9IDEZGCEnobHScpGh6i9n5iH
         F+JKfeaaSV1YXzrsS/MkFNikLWTlagPUg2kkgzsO1S2tYW5/0vWasQq32x6kwrxK4YP/
         5MPO8rh71hz012wkX2SF2Ij88e6yO27TerRZQDcwVMHD/2G1pNY2GAYeqWsiGNh9MiRE
         jPpR3U2Y/9PGKgYBpLG+88ujSVXDk/uISSBb8GxA2M9vE9Dy/Pct5tBP8CLvFvwswV+M
         h7ubm250A28ch0P0z1TCqXwsrU0mpBVR8c7AnCLbOP1DP3mIP7F8pK8mdoaBlLIyZ3Al
         ZLjQ==
X-Gm-Message-State: AOAM533KSRUrpdchY+upNtOkddKUabZ6bN4gezj9oEa1ym2erVBBo3oI
        cJ8AP94pZhdLIzpDl3M7HU8EjQ==
X-Google-Smtp-Source: ABdhPJzWaBrIbWy1Gn3RmYAqSSx+0mMumwirKFFqogCYQtG1qxtNM3so9mUBItXCb//RX9HCWkhDEg==
X-Received: by 2002:a05:6e02:20ed:: with SMTP id q13mr26252658ilv.235.1619706440821;
        Thu, 29 Apr 2021 07:27:20 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p1sm1453223ilp.10.2021.04.29.07.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 07:27:20 -0700 (PDT)
Subject: Re: [PATCH][next][V2] io_uring: Fix premature return from loop and
 memory leak
To:     Colin King <colin.king@canonical.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210429104602.62676-1-colin.king@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8513d853-fd44-c90f-26ba-45b763b8879a@kernel.dk>
Date:   Thu, 29 Apr 2021 08:27:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210429104602.62676-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 4:46 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the -EINVAL error return path is leaking memory allocated
> to data. Fix this by not returning immediately but instead setting
> the error return variable to -EINVAL and breaking out of the loop.
> 
> Kudos to Pavel Begunkov for suggesting a correct fix.

Applied, thanks.

-- 
Jens Axboe

