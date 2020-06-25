Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FAA209FBB
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 15:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404923AbgFYNY1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 09:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404740AbgFYNY0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 09:24:26 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FC1C08C5C1
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 06:24:26 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id cv18so544685pjb.1
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 06:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=eWSfWI4wpEme8MrwfvQ7LPuMKGxIgLayOyX6JwETS9k=;
        b=TXs317Chw7NlZME2mN7859gja5QL9DFyQzGIbvLyC0Z35kZPOYP34joAI5KMOaN5PK
         Y77JHyvhP0f0iy4PPvYyb3iqfJhnEeW3XAc/Yq4Mo6Plmgmrc3xGo58DDXeQ85sneA47
         PJPwd2z3+2sBXiPkmSRiEmNcu7THXZR/EyE43riF8IF51yLxi9ckeQh1tzSL36Zp2OZd
         Y2WdMe051I5Rir1G6lfaQ5QnuC0igLb9IuHs4cFtpBkSN02avQR1M/U9A7IsJQ3qWikQ
         QO54UdFpQW+EBxCNjZ11lXroQgTPm+3/aPJPO+A6aI0CijcjTfwCCGbumI9waZ7JDcp4
         gMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eWSfWI4wpEme8MrwfvQ7LPuMKGxIgLayOyX6JwETS9k=;
        b=AMKWyzQ6/IVEFDQuekT8wpMPKLgLlgiM1vx7vW5UMaGsB283ldtK4hrLzSODs+ogYf
         qYeizZElVvTXR4w+mLbBfvD1eFyzWxWrOxRAvUHFYY9WSrUG4sWfbxu8JU2RKKorBlMs
         08J8QISXfbmR8HwpRMFOF3I+Mc1+7E42ZxJDluBMo/93rYI2JhVdWJnqy9PaytC5F4tG
         sCj4DLnwCtfQ1U4NikPQGUZDLUI0rMr3TpLPVf5e3qgxLNmrRsXqlDaZxYV5xsBsDLjF
         01eUHg4lfeHbBXfPMHgQaTfYrCtjYcd3q4GQorufzRdTPW4GWVgvUBXe10sM3RPD/PQN
         1u0g==
X-Gm-Message-State: AOAM530m3xZwDXvdkjGqyvvaJMbyXoIgGzOdXhEX7/cPIarjtDfUhv96
        FWzlxGffxi1bhyABBPrPist52GMsIwjU6g==
X-Google-Smtp-Source: ABdhPJxz6W6AkCZ4Vb3R22w+iIOiwz8jbFDCPrudgODkVLqlhWeN9HIjLKRDHz7pD59URGE0+fPI5g==
X-Received: by 2002:a17:902:8690:: with SMTP id g16mr33052502plo.257.1593091465728;
        Thu, 25 Jun 2020 06:24:25 -0700 (PDT)
Received: from ?IPv6:2600:380:6c49:6812:d113:f43c:df53:19ee? ([2600:380:6c49:6812:d113:f43c:df53:19ee])
        by smtp.gmail.com with ESMTPSA id h5sm24249689pfb.120.2020.06.25.06.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 06:24:24 -0700 (PDT)
Subject: Re: [PATCH 5.9] io_uring: fix NULL-mm for linked reqs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <f7d8272bcf142fe2c11c85ecd86f7f75f6e48316.1593077850.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <41f3f2db-bc1c-22cc-d93c-4ed31cfb225f@kernel.dk>
Date:   Thu, 25 Jun 2020 07:24:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <f7d8272bcf142fe2c11c85ecd86f7f75f6e48316.1593077850.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/25/20 3:38 AM, Pavel Begunkov wrote:
> __io_queue_sqe() tries to handle all request of a link,
> so it's not enough to grab mm in io_sq_thread_acquire_mm()
> based just on the head.
> 
> Don't check req->needs_mm and do it always.

Applied, thanks.

-- 
Jens Axboe

