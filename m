Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603CF69150C
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 01:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjBJACN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 19:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjBJACL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 19:02:11 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFA457769
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 16:02:09 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id pj3so3637684pjb.1
        for <io-uring@vger.kernel.org>; Thu, 09 Feb 2023 16:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1675987329;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lk5Feku5TfsHzw8F96Zts8Y373kHynUO7XQTlaZ6Vw0=;
        b=g1nbz3wpet5BPm+t9V8oHlhV00D0LPPkcw6OKYtZFykANT31c2ZndZm1Rz8PZM0HZk
         8pyIggym12WgRQHBChPwKKrXRtktd+0ODBS2I4xcsMtEMq2xH11wdpaMTlATlLPY86fF
         gIaUXhWxGkF+S39LUQ6xBLWqFZ0NJ5JlO0dR//Xjx93OcCKsasUEmbbvP+ZCLQeZyP9z
         EVtcMRG0vG1PDFyRbA2B5Nrp0Qw9RZbnID4gCrZsEy3c4EW5A9ZPneA824FLMX8DwpHj
         NcHhnJG1QAbs70sSYrSCGNKiE3KovLge0q6yK6Y0NSLWs9lgB2Fne7plbYOWGIXgvuN2
         QVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1675987329;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lk5Feku5TfsHzw8F96Zts8Y373kHynUO7XQTlaZ6Vw0=;
        b=0+ZF7jVT1BsKAvHtGqsjdYlaKAlWUJeqXMx7X/y0X+/1vr96PEO0VG7Q4bIPITYDL4
         Pa20fGFShkGRJqpfktIAOp3HcdZkDsnrFhA4pEkLGdiP8OCN9RENI+erjQ82jPobVfVy
         Aql9tM2glIENJSttqHkggtfF8jGUStQRcN7Nc9vZSDM1N2aBZ8TyXUN8xstcTg26i2kD
         DE9bv8HAj7qeNdBRV/NbytcmliwlIeLe8IMlyiaE2HKQfUgYC6tfXcJtExM2flNNlafo
         fW/iurRJrogLsQceNj6Wx5xIJVpIBIRJCnltzZiJPm2v22ZDV97qz/sx5dZPy44vaDGA
         hHuA==
X-Gm-Message-State: AO0yUKUiAnZiHabrrkBTqhc0cfk04BsO4mv34ayR2pX4DsujVqRYzcVs
        YWhtIGbz7znzoKKvpCWyrY4NuA==
X-Google-Smtp-Source: AK7set84TTaw2HiYDqR0otZmBPaB2GANF0WOMWu8YIMUGOU15rQ/bRqOlh+RxJhh0AY0d+RsQkbdPw==
X-Received: by 2002:a17:902:dac8:b0:197:8e8e:f15 with SMTP id q8-20020a170902dac800b001978e8e0f15mr14557754plx.6.1675987328640;
        Thu, 09 Feb 2023 16:02:08 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b8-20020a1709027e0800b0019956f23fc1sm2023583plm.302.2023.02.09.16.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 16:02:08 -0800 (PST)
Message-ID: <6b9ad861-6bb2-d01e-2207-9c32f495ec5e@kernel.dk>
Date:   Thu, 9 Feb 2023 17:02:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v8 6/7] io_uring: add api to set / get napi configuration.
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, Jakub Kicinski <kuba@kernel.org>
References: <20230209230144.465620-1-shr@devkernel.io>
 <20230209230144.465620-7-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230209230144.465620-7-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/9/23 4:01 PM, Stefan Roesch wrote:
> This adds an api to register the busy poll timeout from liburing. To be
> able to use this functionality, the corresponding liburing patch is needed.

I don't think this commit message makes sense. It should explain what the
patch does - it adds an API to register/unregister NAPI for the ring. The
commit message should explain the API.

-- 
Jens Axboe


