Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2692B97CE
	for <lists+io-uring@lfdr.de>; Thu, 19 Nov 2020 17:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgKSQYu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Nov 2020 11:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbgKSQYt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Nov 2020 11:24:49 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AA4C0613CF
        for <io-uring@vger.kernel.org>; Thu, 19 Nov 2020 08:24:49 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id w8so5830324ilg.12
        for <io-uring@vger.kernel.org>; Thu, 19 Nov 2020 08:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
        b=sPr0LY4KxEIoN0Vw3DRUl9w82MvOs1MVjNykNCppm5S2E1Gh/HSzfiAOIP7Lqv84Xz
         bj1UdQ/J8Lf67TZm48avaObJLzH5eb/2N8G2JL2zuLnll58ewjpWsmAacKFmp2NBfqhn
         7rM7qJZq5vSqDUOdx7HZAkJLv43smWK+IWVOTPs4l0VTuSrXr3pq0CYqK/uxRJFwcpTQ
         c1EB8W3Tv8vOtFo/ycRUCVdfRLsvDmMTtB60ILJfRK5snEzU72zE9UwtJ4TuLt8NCzOy
         4ErPOGUVd85aMtvouf7EoCceuV8N3SHP1xqaIEe2VxjWD94BF2l+GjkjB08wZ8wH+e+P
         KbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
        b=M7vnLa+qhG8ZSSbT0ZoMwDEIVQsVzjIqF85TsS3L4xbJq8PFaFQGF5VPzEkxQaj5Z5
         ZiGlhgQ8ZpC2Ir/9JOVptWDM9w/LTvCGL4mXMJbbbCQtj5r86ha5QBXwCD9ERwv8wKyN
         VTLnmWTSwm0RZ4Mjit0FuiyAm+ysmIGC0upHD3sS8wRIJxQhTM6O/Cbs+f0AVPGa5SFw
         s3iGLYF7wF1RtfeFO3QUeubbSSh6G7gMFUAv2q6AEiLCgFA1NYj/pUqwHhwLMjeYbGSq
         kGCg7tnIbylCpuxDWfitkZh5B/MDvKX6xvGTdyvzF47BeBJ3HUCwLZcjWbrGp+1ZK+8P
         i+mg==
X-Gm-Message-State: AOAM532zvQrbgqcBb208iWysxmjHH/op12Rp1ooM0qnWaV24uILI/a6s
        2t+8r6EjJljDWNfC9K2QNpQvutpCq4WtQw==
X-Google-Smtp-Source: ABdhPJx1fgRbwmH7ZCCcgrDSusGAn+IYu1dDCmGW122oYAHvjGWWikohsUozpPnXlBnUOLD44TqGXA==
X-Received: by 2002:a92:cc52:: with SMTP id t18mr5758168ilq.124.1605803088544;
        Thu, 19 Nov 2020 08:24:48 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e18sm157692ilc.52.2020.11.19.08.24.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 08:24:47 -0800 (PST)
Subject: Re: [PATCH] io_uring: check kthread stopped flag when sq thread is
 unparked
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201119094446.10658-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8fb13591-b23d-ba97-228e-69d8c0e5412f@kernel.dk>
Date:   Thu, 19 Nov 2020 09:24:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201119094446.10658-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Applied, thanks.

-- 
Jens Axboe

