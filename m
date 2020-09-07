Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD76A25FEC5
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 18:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgIGQXc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 12:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730476AbgIGQV7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 12:21:59 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E53C061573
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 09:21:58 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id a8so4673057plm.2
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 09:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dxgu3JesoXBFz6XimF7qjptp1uzAjI9aqCIBMQ70+4U=;
        b=apJSEs2BB7vs71JXcDmqj7+yVp/fUrnMWAiKC/aXDICF2BtYoRv0OWiuAoRQWPhmhc
         Ox64a/ajj7863xTh93iFSH9sP+fpjnXQhQdIByn2Ta38ktS3gy7Sf/fMPV0vVNE7rblL
         qR3IWUpd+46iwPu7OnKumahcq9b1dvtJkeb4dYyeU4RxUWaTOCxV9CLTT22b9hfdYmVD
         vNgrgxT6AL8Pc5Dd5fdu1PYugSgfdqCkGmBOYOk+DHa22DuWw2CnfKc+iepmGf+naFdH
         YwPhtqR/wg2xHq/u/63wz0cR486SYTlC12f1cx78/29E++usYhfbfGXGoKM90ylgbgPf
         wbug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dxgu3JesoXBFz6XimF7qjptp1uzAjI9aqCIBMQ70+4U=;
        b=Ehnw2sXorCszPPgKQMXjOP/ZSFMqoens8HlxKWs70gmBlO4QrvYfbWgFcQSuxv+cgz
         9j9yGM/66wTGJEV3whLAArth0tyNpIymjU5Yp9RnuIh1iI+bNufOIaFYdFbatVHv+cFZ
         c2Mwci3zLmRC4OUWKrEccv1GfHSg2970tdVZF7e8sNO5prxz2bG96Q0uiIZnZHBa77Gy
         0xLDcaUuyGE6c+68A0q6tuBRCflZh+VDOr/SzMDf51yQ2SVvVnzolM336MSToL3ZAPS4
         srkeDCrHJTFCDtN4uKVo13qK7mFXXwbnOSXL+gG70vksxde0hc+NsOBGR2u1IcZjHdWH
         mZ9w==
X-Gm-Message-State: AOAM530FowNmy/v9GPUv9gq/k++7oxW1x3k7Bl3TqNbqRJ/HjRoVZ+rw
        InTyBHPYpgag7223LVmqObSr3+A8gJXafnwq
X-Google-Smtp-Source: ABdhPJwOSkCgDjMIj4WD14dCVAwx7LO0ZOk1t2tlNJQMf+RnOW7Q3Vr4kSZFDbkkrXPKNdVvGT/Xbg==
X-Received: by 2002:a17:90a:c795:: with SMTP id gn21mr82210pjb.27.1599495717705;
        Mon, 07 Sep 2020 09:21:57 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b20sm16674220pfb.198.2020.09.07.09.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 09:21:57 -0700 (PDT)
Subject: Re: [PATCH 2/2] runtests: add ability to exclude tests
To:     Lukas Czerner <lczerner@redhat.com>, io-uring@vger.kernel.org
References: <20200907132225.4181-1-lczerner@redhat.com>
 <20200907132225.4181-2-lczerner@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bfdf7e5e-06b6-f2e3-7f52-d2a6a32d719e@kernel.dk>
Date:   Mon, 7 Sep 2020 10:21:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200907132225.4181-2-lczerner@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/20 7:22 AM, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Is there a cover letter and/or 1/2 patch that didn't go out?

-- 
Jens Axboe

