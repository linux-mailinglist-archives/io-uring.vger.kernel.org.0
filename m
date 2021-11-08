Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F275D449893
	for <lists+io-uring@lfdr.de>; Mon,  8 Nov 2021 16:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241000AbhKHPmi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Nov 2021 10:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbhKHPmh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Nov 2021 10:42:37 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436E1C061570
        for <io-uring@vger.kernel.org>; Mon,  8 Nov 2021 07:39:53 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id r10-20020a056830080a00b0055c8fd2cebdso4764017ots.6
        for <io-uring@vger.kernel.org>; Mon, 08 Nov 2021 07:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=1AHJ/6IS8p9Mt7T9fwvpbbUokvMiVAl35mOpHVH5JsQ=;
        b=wAuONZw9MuVmyrkamJyZ9qy7k2F8LumKrh6VnZw3K9GG+xgI6TZwsI1p24m0Amqg//
         FjOI2SqAwihZxMTYFn20OS/hTeIZXheXuR3AgZe0nxewg+jMMoAqjAIPKFYL7JaPMkJL
         5W4lr5aDNVMkpapH95KrWhEhXFJ3wB01I5dZu8QO7vU9eh0niIl49sQ+nen0Yw5yLx36
         yjwXCRE4PUUCQDspWvFFeN/d+u2cXVhuiL/k65ZL+zu3VGgBjp2Wll6/40L0rDgAqNaR
         abScTRCxK5fYK+kvQ00GM6NsIqGfYygtpvPvQ7oHRWTeeA8QKyYV0QnnSqNABkik3ol4
         EYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=1AHJ/6IS8p9Mt7T9fwvpbbUokvMiVAl35mOpHVH5JsQ=;
        b=mrv1M0I5g4cMvYKe59nQDTsRIB/L8axC5t0739r2AmrGh12CRHu1ENkplSUNbZwbap
         qboXOIHG0IunPoZKFPAujkEp+gFHSN6ENC8bhM/t53CIlt2jWlCwplQwW0c1Iw/StnST
         UwbWKiiOvtwAmYJaQ4IDBiKZqVsiNL37q0jcSKVz+dRc1IyQOjfz4EiYdQF1zKrUHgLz
         fU/rrB4R5HLE8t+fWiKL2UGWrlrNlfRahF3Zg7j8lXFKa1KP5Vu6o2C2rUGQ6JwsoJwi
         tnmeY6Zbpp1scvkEVKwhltzRiJL95W4gGfXQJ7Y2lHvG6MD2ziCQVEElLK/3UBmAWc7p
         P/GQ==
X-Gm-Message-State: AOAM5337E3Kz/aARt4J/x9ptWb8SB1nM6R2OeRUzDAvNO2T4Z6gHLwa/
        poZS/aXg0XUgzOB+ZftwRDmS7w==
X-Google-Smtp-Source: ABdhPJwyLE2OLtwdZoZPbBvK4wNyiY3mPaXF/HWNG9Qn3Wedtgc/1m7vYcuIfbZM81jaG+dXizmonA==
X-Received: by 2002:a9d:6484:: with SMTP id g4mr495974otl.221.1636385992518;
        Mon, 08 Nov 2021 07:39:52 -0800 (PST)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h16sm4403468ots.20.2021.11.08.07.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 07:39:52 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Beld Zhang <beldzhang@gmail.com>
In-Reply-To: <1b222a92f7a78a24b042763805e891a4cdd4b544.1636384034.git.asml.silence@gmail.com>
References: <1b222a92f7a78a24b042763805e891a4cdd4b544.1636384034.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: honour zeroes as io-wq worker limits
Message-Id: <163638599185.334216.17898340409492815905.b4-ty@kernel.dk>
Date:   Mon, 08 Nov 2021 08:39:51 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 8 Nov 2021 15:10:03 +0000, Pavel Begunkov wrote:
> When we pass in zero as an io-wq worker number limit it shouldn't
> actually change the limits but return the old value, follow that
> behaviour with deferred limits setup as well.
> 
> 

Applied, thanks!

[1/1] io_uring: honour zeroes as io-wq worker limits
      commit: bad119b9a00019054f0c9e2045f312ed63ace4f4

Best regards,
-- 
Jens Axboe


