Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6737D3670D9
	for <lists+io-uring@lfdr.de>; Wed, 21 Apr 2021 19:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244625AbhDURER (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Apr 2021 13:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244583AbhDUREI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Apr 2021 13:04:08 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C59C06174A
        for <io-uring@vger.kernel.org>; Wed, 21 Apr 2021 10:03:34 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q25so11402039iog.5
        for <io-uring@vger.kernel.org>; Wed, 21 Apr 2021 10:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jhpUKjKeF03jdkdsiH6FBXeP0UI71BLbC4nhsSYvY4c=;
        b=QlZ0boo8kAUOEe8Dse9c1E9IuAnBvoMRa+zuXQgfLmmDwqnDiEMkWPvFkwQFNIOZG+
         kUR4iFYcxqo/krIryckuJEh3Xj9fW2a8uggRLsAtVTWKFiOwAhX5BhTzt6SkCJq5NvzV
         y647sIGsADQIfJApFo88z3BGjmoJ6+hhS+XWqF9bxYD8TpE4fSHVPrYD/VQMGXkhy3Xn
         zcWArgx8CFTvURrOqQ7OgVuWkv7T8xTk2hIPAVx3itSsA6Bq2UO9dEuFi/8ZIaGnwg1v
         B39F76gECAC9K2igL6nBpQSF20s09jHVoMbVzoewLnplXgUFrlD2Itfuf0X2POpgFTBQ
         lyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jhpUKjKeF03jdkdsiH6FBXeP0UI71BLbC4nhsSYvY4c=;
        b=ty7XbO2Ao+bFjIk7bZc55LhJD0Dprx/wy4Rb/bGs4SbUlkM6wPTMiV7z4AZjgScYAu
         dGwiVKYLi6CRXhO5rbxAnAOTRB0DMqYInuWJasVeuTtnUg/Ssnc1n5csh9rl66ChfT6f
         IAozys0Uopieht1k2rNfPJfWxwX356RZDEgnRb3/S1sIU/T0OPFmdIU4CTJ5p+6a9dQg
         hk0uGGfYJVq1/rTixIT5I+7VUtikriwlFrvwVF9YxO642C3J/JPFi9DlTu4WHpN2qf/K
         V745Zvc2XVzdo/kuCzfHnqZuiHwuJu6rDqA2m36co9y9B3Bld6jLHB7usQkU2BgZQI/k
         LnwA==
X-Gm-Message-State: AOAM533LBVumIBaWKKXz8cXLVvUGxq3cblR0O/wmYYDJpqztIRb+/Moe
        C3u2l8xK/rGjBl/UsAg0Vqu5pleR1JgY1A==
X-Google-Smtp-Source: ABdhPJy0kNmB1m5Yvbd2qGROssINJMIdxIUOqBJOlX5s9GaUCNR/OHXePByTqOezYAIFV7A9AZx8QQ==
X-Received: by 2002:a02:5d82:: with SMTP id w124mr26801602jaa.21.1619024613847;
        Wed, 21 Apr 2021 10:03:33 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d4sm1231047ilg.65.2021.04.21.10.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 10:03:33 -0700 (PDT)
Subject: Re: [PATCH liburing] tests: remove -EBUSY on CQE backlog tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <602ed592631aaa6605d414b12419ca2f1896a810.1618956047.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1a298439-bec8-160d-e7a0-672542d0be76@kernel.dk>
Date:   Wed, 21 Apr 2021 11:03:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <602ed592631aaa6605d414b12419ca2f1896a810.1618956047.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/21 4:01 PM, Pavel Begunkov wrote:
> From 5.13 the kernel doesn't limit users submission with CQE backlog,
> that was previously failed with -EBUSY. Remove related tests.

Applied, thanks.

-- 
Jens Axboe

