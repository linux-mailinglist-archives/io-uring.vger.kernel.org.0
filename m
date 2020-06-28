Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC9B20CA4C
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 22:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgF1UEe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 16:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgF1UEd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 16:04:33 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0326C03E979
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 13:04:33 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g67so6434770pgc.8
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 13:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mCQ0XXZZep96pfLzpadWEUmWe/EXAUtBXy+p5QlUftk=;
        b=uaO3BOQyZX2fcvgdbV3Ts4Qve13oCTrPw8aptHw17yIpmHVhHOg1EIEgM+AXorD2l4
         gwAaFLtwrvo/ArITtibSLkauE3joAKvtmZUlPC6jx2WdYUoeaFYYeBxXNPY7rCl6DVD7
         DB3Hnl+hQvHnWm0ERkUAQXafTsij0DqMGSK8dz8uCGEtq2LR9njFYfJPKNVw+WtoECRF
         QWdK1sv4FlPuqD1vcBtt2ClBN3EBT5umpnYs5yq9300Thc3XjGtmtB8xy2F+CEHDkE9F
         x4gcAPRqyd6u90K0Uh9qi3GrM5uGnJ4aCEtIA4h6zCGQHTdoq1ub1nJjdUNVHhJ+OgXK
         /aRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mCQ0XXZZep96pfLzpadWEUmWe/EXAUtBXy+p5QlUftk=;
        b=kK+j1LQ2FURgtQ5rkBGwnXa1WSLhTmpLLy2CQBtCrcNz6yj0xJM8tOYnmIdvXR3FmO
         egLvuzWVOd6pyJVO0vjELKUAKU4uVdKmqKy8ISMv4r/aCwukXFcfjwaH6xLVoEEh5vuM
         SkxniMJxH/u4/6taKJj9QSX156S7N1v4YC+HbCc/jsgL/POQSG9r4b2qQa+7tHFlT3NQ
         d9WShbBUeSrabOy8mw793k5NzdtV+WM2iq95I+ngrLA3sEuYbVN08NmQQ9lYbfc8UO9C
         67L4K2vnxi7/zO39dxS8Bnr6/SvNPd7sqfLuTWc70o/HERfwKsBm06Cwr2hzRl0TFYqb
         0Piw==
X-Gm-Message-State: AOAM5334gmYgzyEu1Eut/Mbc1GFMfK9uB3safRJNGTrsx3TRFnZVlQLF
        U7hEquCVkPmrc9AKKy62DSccihuMk+aPgQ==
X-Google-Smtp-Source: ABdhPJx+J/vwNuWOAqTIooXjnw7S4U9DHU6Mzndb1MjhXkUAutja6PLX7gbwYDPq+ZwPPYtNX4ln7g==
X-Received: by 2002:aa7:838a:: with SMTP id u10mr12367903pfm.20.1593374673116;
        Sun, 28 Jun 2020 13:04:33 -0700 (PDT)
Received: from [192.168.86.197] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id n89sm13074257pjb.1.2020.06.28.13.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 13:04:32 -0700 (PDT)
Subject: Re: [PATCH liburing 0/7] C++ and Travis patches
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     io-uring@vger.kernel.org
References: <20200628195823.18730-1-bvanassche@acm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ff8196b4-1eb0-61cd-726d-a7d1d01da8a4@kernel.dk>
Date:   Sun, 28 Jun 2020 14:04:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200628195823.18730-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/20 1:58 PM, Bart Van Assche wrote:
> Hi Jens,
> 
> This patch series includes patches that restore C++ compatibility, that
> restore clang compatibility and also that improve the Travis build. Please
> consider these patches for inclusion in the official liburing repository.

Looks good to me, thanks Bart.

-- 
Jens Axboe

