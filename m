Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13841E91D3
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgE3Nus (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 09:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbgE3Nul (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 09:50:41 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E64C03E969
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 06:50:40 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id v24so328745plo.6
        for <io-uring@vger.kernel.org>; Sat, 30 May 2020 06:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RXgrwt9PbbSX3t/ukylqmDcsnfwgGXpqGngrByB2Wxs=;
        b=XNy4Wqw1hnA+o/lKZ7o8W+5cd0PzsWvQzvNKSj3dpld7fyif/tu6FrPeovOnHH5uLn
         20Coo7jd5wT2fP+GZawqHJMRIOXZcSFzPpB1abmWTxwvQ5FPO/HGazssPeqMCY7Tn68O
         6tGzacVWhx/zzYtdhaAh2vRC57t7VynCSqG+d7Liu5ENSwhPcWD9c1xdVy8JFc5c0jjb
         XwIGrEg2jAI2GvwZYtnSVRSgrnwUgfI9Z6r6oYItb3ymKtSkpdTes7Lyj3INWKsn27jL
         wx29fvGrTnsGpGsGAYgVAEHytFerKSBSDC7g59aIXRp2Ah7ONnE09OLK1r4nqLdKkUUt
         cyYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RXgrwt9PbbSX3t/ukylqmDcsnfwgGXpqGngrByB2Wxs=;
        b=O3T6uKyufowUKB6HASMnOBsJPWVPtw3DHt7Hh6JT+yPq0se0QWEU9eu1mNcqRkCxcm
         MqzHuJ+dixQ9BrW+3BxKoUGmPVoiO6DIGHbOlt5P5N9Z8+ypCR1kamehCzzLU0nWVI0J
         z5BJzWM/+WVLFZNYOdxVYDVVAHdIXSlMZAz9e8fUmEsH7XiQ/u8FUYre35GXZ+v4n7hM
         ZNuGhffZTA3fULLbMizbXmyoAVR1YlVZT5hU9LVbliKx0bGhhxe6/F33Ena8K+yGlk2g
         CLYs/5rPQvxZQhnCcVuHYV7zlOREz//FYhy4z2kvM1SV3mY5UMcrnNAfJGurgUNuyISg
         cU8g==
X-Gm-Message-State: AOAM533KTbrVNHFIjLUAFUDwE/jJ36lZBLjZtpisaGKNLPuZ3Z3uvCkf
        fUs4aM7cQGRovkKo0EFXYnHmmw==
X-Google-Smtp-Source: ABdhPJwkZm5zTsn0XdJ46Ne0zVIWPxOBE/ToR+NK/aeIgt3NP9C3vuKcwkQzDbsc8p4oSKGZ3cAlUg==
X-Received: by 2002:a17:90b:ec4:: with SMTP id gz4mr14883884pjb.36.1590846639987;
        Sat, 30 May 2020 06:50:39 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a14sm9585928pfc.133.2020.05.30.06.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 06:50:39 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] CQ-seq only based timeouts
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1590839530.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d1a637d7-e16e-ce08-fad6-9423bb52d1e7@kernel.dk>
Date:   Sat, 30 May 2020 07:50:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1590839530.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/20 5:54 AM, Pavel Begunkov wrote:
> The old series that makes timeouts to trigger exactly after N
> non-timeout CQEs, but not (#inflight + req->off).
> 
> v2: variables renaming
> v3: fix ordering with REQ_F_TIMEOUT_NOSEQ reqs
>     squash 2 commits (core + ingnoring timeouts completions)
>     extract a prep patch (makes diffs easier to follow)
> 
> Pavel Begunkov (2):
>   io_uring: move timeouts flushing to a helper
>   io_uring: off timeouts based only on completions
> 
>  fs/io_uring.c | 97 ++++++++++++++-------------------------------------
>  1 file changed, 27 insertions(+), 70 deletions(-)

Applied, thanks.

-- 
Jens Axboe

