Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3B2417C0F
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 21:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348271AbhIXUBE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 16:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345980AbhIXUBD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 16:01:03 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4607EC061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:59:30 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id h129so14220231iof.1
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 12:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tOf4reCSIPZkzRtu8obkS4ifnfSs27E0k8fLCVLDnNM=;
        b=jC2jI8Kd/3+DNj5F3sABN45CNGPvSW43BCSYKnWY4q9EFUuzcRx4ts4JT2qvhPS9+J
         RMOHFr5Wo0YmmO3ZdnN+zSgPHtUHqWVbjebOOLKbIh+g5y/5HartCV46dN55gq5KM5pd
         hos7+eSPxVvyyM3Q5AOjCzRfn+SdQB1/11zc3EEEWvG/Ws7dMnBRdjl4yXLjUZKgMFR2
         1NNLOUP6975bcr4tATKyxvHfPFhQKofUGMboxg4Qy8zKwYyLesDEpJ3ChPvrG+jR2cz8
         S84aph0edMgXrDE70+TDxdDqsRLY70cYtJjrBY6koNnytvGg0GV8Dy7sncW19ekPpAym
         fIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tOf4reCSIPZkzRtu8obkS4ifnfSs27E0k8fLCVLDnNM=;
        b=ipzQLnyGf1nMQZz3eL015MqouSJcDRaLqZaCtigebH0sjzPSVh2fgo7ugq5/QNIGeU
         9Co93vo4qyonEIrc2XC5dvj5ZmDnWj4SGKixxAUPGjLE228Pnp5YaPeJNq++kWK7AQoj
         xa9Jul3geutG9W/dS8gzWLyMiLtcwZ3XvgrCJXkRvJ3cR89/skOf2GSX9YpyTcXTspvv
         or5mqUHWtENCpyRhwlJV/SnWczGcc9Endt8Mwzacb9WAC1XTiZ0Txo9uyibqS9qoj6dg
         XObIb018EIhryG2Me1EXcpmyitlvYNsHAW/KqNtX5bwbRyVNQf53qRXi2XIQTOheokBa
         GnXw==
X-Gm-Message-State: AOAM533lM3cjCdY5N+S+gQINXtC9ELRLtGPdxL5d0+f0P+a7+1vb+UIu
        iODBftNc66bkwCVpfqcAyFjglMUfrnvRbJDvao4=
X-Google-Smtp-Source: ABdhPJyTySGu5Y2Zc8GKYyYSSv2/ryAAQ+c94yJbMjrzio2tCtst69JqapYKQ9p6HokrBAVT6VPJaA==
X-Received: by 2002:a6b:b40a:: with SMTP id d10mr10687097iof.85.1632513569493;
        Fri, 24 Sep 2021 12:59:29 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w1sm4623360ilj.55.2021.09.24.12.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 12:59:28 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] small test improvements
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1632507515.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <145ac6b6-53c2-9bcb-dc98-b657fbc68d11@kernel.dk>
Date:   Fri, 24 Sep 2021 13:59:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1632507515.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 1:05 PM, Pavel Begunkov wrote:
> fix types in rsrc_tags test, and make a few adjustments in multicqe_drain

Applied, thanks.

-- 
Jens Axboe

