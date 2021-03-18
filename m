Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355843406C8
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 14:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhCRNX6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 09:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhCRNXz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 09:23:55 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DD0C06174A
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 06:23:55 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e14so1299482plj.2
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 06:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EtT96sRpsxp1MPS6OhlOJF0xFvp4KCU7p6HmgUYIoxk=;
        b=p/09braq3hX/KlCiBRYu57S/x3j9sID7yG8MGsi817cKBS9TfJFS3taCh8nQFrJ24Q
         7KpTFVIi4iV2KGCCqELZz6T2eT5CDWBVAoty+quifXxPUF6P7gw4J5oAXmAd2umOY5A6
         q2eCHSUSHZrTC4N0XZVFkS9/V8zeqUXdabWrIUgwnGNfEVlPpXcW535JdU6hCiAnu/K4
         o4LfJWSaSAH3vHOxArNx4kHbon/+b5gOpnXLdweDuF1KCAWFFj9oZJdemezVhhGGPQb3
         yimkQ5VX5VbGjnslfTtmQpubFhzLXlts3U/3xGwcdaDuYa4wYpnuFlZsJofx6u3k8S6l
         S9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EtT96sRpsxp1MPS6OhlOJF0xFvp4KCU7p6HmgUYIoxk=;
        b=h8NWNOB1sU2O6WHPFub4+KRkq4cv1yzWmeulABH6wh5cKkJKcOZnbRJXNrXr2rnd7k
         0GsM4VbziQ+D3L5W5yeT/uwyt6fTK1XwN2bLkvjTNXcvvSGNQiyMSt0vG03Ak0tpHtvh
         fGPywQT+oyI1vxfCatafhIgMKmJ/+UJQ1XEmUGd5SEYGsRf+KPDc6FblPcGXC/1TORyf
         0s/80w0/5B2Y5H9xmrhJkGWSjLY+h5nuct/1veza+U4g7SwSJWUv6osaIEJpBnkJ5j8K
         867J/g9Smr4ngmGURMnxef8xVSzyz3DOgNhbA8vxv0dfwJ2BMjtlLIfE96nHOexrrusF
         0a0w==
X-Gm-Message-State: AOAM532ivcpc8SErbb5B5/FVaQhbUUgjlCor0TGfQ4Fzaf4mYNCufS2z
        /M+3GzZQVR1q89AVyXm1pNtvJmh2FuZsTg==
X-Google-Smtp-Source: ABdhPJyTh8FS59x6HeOnfhjQOPJOm6IDM8aNs0QuPt9a1AcQFUgJWFed+ju7QZeBuQtNkzHN27lpnA==
X-Received: by 2002:a17:90b:310b:: with SMTP id gc11mr4402319pjb.186.1616073834398;
        Thu, 18 Mar 2021 06:23:54 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id l2sm2782826pji.45.2021.03.18.06.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 06:23:53 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: don't leak creds on SQO attach error
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <7c7e783bbc4b785825b159d4172527de0014ebc2.1616066965.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5d0b3609-0e6c-7758-f9fe-d57cc04f3d95@kernel.dk>
Date:   Thu, 18 Mar 2021 07:23:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7c7e783bbc4b785825b159d4172527de0014ebc2.1616066965.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/18/21 5:54 AM, Pavel Begunkov wrote:
> Attaching to already dead/dying SQPOLL task is disallowed in
> io_sq_offload_create(), but cleanup is hand coded by calling
> io_put_sq_data()/etc., that miss to put ctx->sq_creds.
> 
> Defer everything to error-path io_sq_thread_finish(), adding
> ctx->sqd_list in the error case as well as finish will handle it.

Applied, thanks.

-- 
Jens Axboe

