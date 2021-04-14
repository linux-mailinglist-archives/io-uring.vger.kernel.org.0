Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A829435FE71
	for <lists+io-uring@lfdr.de>; Thu, 15 Apr 2021 01:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbhDNX3c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 19:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235104AbhDNX3c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 19:29:32 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA537C061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 16:29:08 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c17so14796276pfn.6
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 16:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5gxKEMPAS/iqm4IOmXNIkQmZ3GWwOtCt5TsoIHjxqp0=;
        b=avr1o69v7wgTLgk4MuS031i0gJJXTadaJ7JMz3yEWw61rB0H7F1nXEM/8MHcsh+eOf
         6G6Uv52+BmZ4Cj2GIIdfgXyjHG9tH4dYalspXhYlaUiJq10q/NNQ9i3NuT3HyaFovs37
         OG+f+n+GuGKwJLqXbXFW049quoXL0sr51Kg4CiqYHmi1VqD6fzG8XwCIi5gPHnS7AAL1
         sm/V/xa/l7kuCzzMKdKfHYDxj6MbposibzQFmh6Rw5Lg9iMSn8bzYUkTPBzy78fn2p5r
         r83ov/n95EdRMe7OcBTarvzzvuHJAOHi6LgXKNP1huIBPLdfSGfetWdDCRBpo0DGVMQE
         3Wqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5gxKEMPAS/iqm4IOmXNIkQmZ3GWwOtCt5TsoIHjxqp0=;
        b=NU3deoqHfTCOxy8WYaUg7b/clf/jxu9W6B6tFP7oVi7IgMKylGLVVnusiNhlWWhNDP
         1om6Yng7DRo6Z5LYnpxKMByXnotCicaFusF1LMV7h1bIz0Py86VNH4HWjsT70yqNnd7m
         7G3ejhDyP9yQv7jgGbQJt16Q4pAt+ClRS8tlc8nM9DqHwfkeGi5uxM9p41/wowSj/8qs
         iO2UITHTRBu6fByngd6wWFVJAoAjrWAYZ6kIpTIex0lmRPJXBeLWtnJ0ZaCvZkpQFK5n
         QuW0fPZFW9jvOUF73lfaj7WoDeodqXjHBf07cHoUjVFG65VWjAEgJ3es214RCLqRjiLf
         ZNSA==
X-Gm-Message-State: AOAM531uX5SB0uh3MEP9thi/IQtrYEu0oVqF+fa3/U3WDefGUGQ73ZGW
        QCUwxPvOODz38UEGwgpZkqnlNAeAWLR1lQ==
X-Google-Smtp-Source: ABdhPJyUXAq4YIDgb6nU5M2ufUCi4VN38fuJ7LhppeWNpJOAKjt55DQhl+qCP5NKVlTgWqpsNl3tXw==
X-Received: by 2002:a62:6585:0:b029:241:cf5d:93b2 with SMTP id z127-20020a6265850000b0290241cf5d93b2mr466476pfb.15.1618442948138;
        Wed, 14 Apr 2021 16:29:08 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id mu6sm371318pjb.35.2021.04.14.16.29.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 16:29:07 -0700 (PDT)
Subject: Re: [PATCH liburing] tests/poll: poll update as a part of poll remove
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <3d7646712081cf84346f13d94098cda257cab11a.1618442414.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <33532d00-2e39-508c-28cc-2f5a0ed27251@kernel.dk>
Date:   Wed, 14 Apr 2021 17:29:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3d7646712081cf84346f13d94098cda257cab11a.1618442414.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/14/21 5:22 PM, Pavel Begunkov wrote:
> Fix up poll-mshot-update test doing poll updates as we moved poll
> updates under IORING_OP_POLL_REMOVE. And add a helper for updates.

Applied, thanks. Now it just need a documentation update, but it's not
the only one... I'll make a pass at that soonish.

-- 
Jens Axboe

