Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276AD2C5ACA
	for <lists+io-uring@lfdr.de>; Thu, 26 Nov 2020 18:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391549AbgKZRjD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Nov 2020 12:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391424AbgKZRjD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Nov 2020 12:39:03 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47792C0613D4
        for <io-uring@vger.kernel.org>; Thu, 26 Nov 2020 09:39:02 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id s21so2182232pfu.13
        for <io-uring@vger.kernel.org>; Thu, 26 Nov 2020 09:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jwtkwy/3WeoJ7c8VJ+T4nhh5tXo72+tyQjjVhj3vQ64=;
        b=kdB69QjmIzcQn81LtrPA3p/DY0TguVWavZAZq65jSOWdrRE0a5G9BSwm/ERB6zXUKE
         jOyIqcga3E3Cp3fCsOgR5v6st8peyoog/1wLpy/FYUZpAGB04wg4KD82NQBk2g7A8DT/
         yw3n8R6cACPbnWZJ3hy9HbU8u65te3Sfyttq2jRRhJJQKc86C0TW+1cxcRWKqGozi4jv
         hrlNJAkPOo9yERmdViWZxCFcoQKprBBX1Arnk9IjB0MGUlzLiu1S/bc/wm6f2uakjGvy
         5mC6f1OScl6StgKL9omZLtZouO5FWlNelO+K+Gzw1z2A9mHjPHXVQSxQJA60lvWTttF/
         DVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jwtkwy/3WeoJ7c8VJ+T4nhh5tXo72+tyQjjVhj3vQ64=;
        b=V7KYSTtaD6QvnWKZ5hF0iYmcR0BvMzqrvwyleklTHcCeNouCwydaICnft26qqiVMH1
         EXcuMtn71HX58QxEMq9ZQER0r1qqxed0SmDKf3f5DJ4OLWIuHInhfrEwCCNyY7jw+r0Z
         pscWKtyGsLBrBa0nbx1ujc99ZaOtVlzL3frGUhpS9m2PRaG4VDpy4ldA41jmlOEYin9z
         R1o/aR/PUu1g7/T6mktsqgXOl+96xaiCVm6Z4USryvbhH6hrmXIJod7edObJNwbclnHk
         I8Eb4U9LbRJ+YeXai5kEXUTJNOQENOojW5ukkO/HeEnwMNRU3SvD4hNiK+/Utv/rys4j
         XFeA==
X-Gm-Message-State: AOAM532BaXo5mIcvPyyeBt7KKJMAWLdtrJRMfwRLij6VT+lYdEAJsCYv
        p0SdTfu438qCpE0KLzvn8iKd3kKufmi5yg==
X-Google-Smtp-Source: ABdhPJytw3LAEy9wqGk4qbNE0877b+ft+dhqJNXxO0yolie9QbiriN72v3AdupC2bcnTgem+q4E2+g==
X-Received: by 2002:a63:db09:: with SMTP id e9mr3355732pgg.60.1606412341711;
        Thu, 26 Nov 2020 09:39:01 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:6526:b582:2933:53f4? ([2605:e000:100e:8c61:6526:b582:2933:53f4])
        by smtp.gmail.com with ESMTPSA id w12sm5047049pfn.136.2020.11.26.09.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2020 09:39:01 -0800 (PST)
Subject: Re: [PATCH] test/timeout-new: test for timeout feature
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1606115273-164396-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2562fb6f-fb84-07d7-39dc-597683773e12@kernel.dk>
Date:   Thu, 26 Nov 2020 10:39:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1606115273-164396-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/23/20 12:07 AM, Hao Xu wrote:
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Hi Jens,
> This is a simple test for the new getevent timeout feature. Sorry for
> the delay.

We need a lot more in this test case, to be honest. Maybe test that
it returns around 1 second? Test that if we have an event it doesn't
wait, etc. This is as bare bones as it gets, a test case for a new
addition/change really should test all the interesting cases around
it.

-- 
Jens Axboe

