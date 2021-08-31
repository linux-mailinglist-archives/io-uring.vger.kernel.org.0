Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C61C3FCBE6
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 18:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhHaQ6R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 12:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238852AbhHaQ6Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 12:58:16 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89586C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:57:21 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e186so25801687iof.12
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=61efSlPxYXxCVMioe6m21bysEdvNZE9U+ZS86CV/c/4=;
        b=gxdezQTId30zuH7aTuuzwlj56Rt1RobBjNEJreAy1oUAUegFAL+yxr2Vg73AxQZSW3
         cv1dhVF86ozUQI2gRq3eu76Du/q6Tc6v75VbIJrDnEUiP9hZ1NE2XbLVE+6a55hfjjSH
         Vi8dRZ0XpB/h0er16Qjdf/qjGVYS3UzfRnvzoMLI7SoTuz3kXGu7iydT8mRNT6albnKf
         9rflLmmjuQmyAJ/utdyb3SG7SVa6boJcQxrHRU1w8lwhUC0+QFzYQhE83QU7RrkTCDeK
         7LF5ULaTXjLFO+ig5Dz/Qz8Ou+X7Ui24XfP0cYJYUMabM5zIMDH2mvg4xaas0mVVEQcJ
         7fhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=61efSlPxYXxCVMioe6m21bysEdvNZE9U+ZS86CV/c/4=;
        b=XD25oK6ILKyi1QFXgEfTp6Kcf1Fw8vwMSgsQYgxig0Tt/D6C8800dhH/QwL03RJj3C
         6uCmh+2FDNF/yw30c4HASFA7oQntKjSzBYsW7/VCH3eEkKbuj6daMYdTKSlXMVQk9wHP
         Kdx3m8iIS6Iv1D7nBo0S2MufjemaHrShSp8N6QGLKy30AkMsuMZFdHplyN13eQQDPcxt
         7Gj1MxoDh7PZYM89sFYUeNmq+u0DzoVDas7LNBcfWc8z+YI/gveii+0KtbkiCBw7mdmv
         48EPgUEyZbIPu+O4swiDH/vMHjW6bTC2mAnDlFUMHVv8aj9IINOmF5Wwolts6lDi8bYS
         J/aQ==
X-Gm-Message-State: AOAM531IYkv4x3TLvTWFul9O6ATuG+/0hJeZd5TH6SNPGdBGoT+dRJKO
        PCFQ36ww8HdGb8frbDkMCV6F1w==
X-Google-Smtp-Source: ABdhPJyRkf3+0wjRbcDaa9uzGeoKlhsojT1uyVDMTPxNz+4Xji/6UdyHYEs4gr90NRGlHTde5bAGBw==
X-Received: by 2002:a5d:8986:: with SMTP id m6mr23123626iol.87.1630429040871;
        Tue, 31 Aug 2021 09:57:20 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m26sm10124179ioj.54.2021.08.31.09.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 09:57:20 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] fix failing request submission
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>
References: <cover.1630415423.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5350415e-f1e6-8581-8916-3907a5e7d8e8@kernel.dk>
Date:   Tue, 31 Aug 2021 10:57:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1630415423.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/21 7:13 AM, Pavel Begunkov wrote:
> Fix small problems with new link fail logic
> 
> v2: set REQ_F_LINK after clearing HARDLINK, leaking reqs otherwise (Hao)
> 
> Pavel Begunkov (2):
>   io_uring: fix queueing half-created requests
>   io_uring: don't submit half-prepared drain request
> 
>  fs/io_uring.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Jens Axboe

