Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3AC3B8A14
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbhF3VVP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 17:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbhF3VVP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 17:21:15 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E21C061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:18:45 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id i189so4885706ioa.8
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=AeG31Vp1XyiSS7mZSPqEneE5estaaJkzU46Bfe6TY9A=;
        b=h8wbtSmGiousEsROsQsdWVsGuJUco8g9ZaAd+AtHzRR5KhFkk7mR00CsdqQFLzB6OE
         j6elhhCJMu3xTCiTJ5BqZvVhxLtBrLpJaedmPZQWjQtl28nNn6g8AGiQarmQKftSgn3U
         hAV/Jgk5kbRVEBPq34slDctVSk/DqPSXWN2vhZ2alOUWpL69CrJMRimkIjDTrx4ExnkX
         NVdSFIR3vwJXLYy0hsG4VRt7CPJAfF/hUG/LXYiGicVztlCO4BSPQ3G870LPk0uXC2Vm
         d4ulIFd743j9lbfVohFC2ItNFESLJ2mSmbu3BNxp7HafIzIhY2BOFSwry+eZhZOuGdJc
         cY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AeG31Vp1XyiSS7mZSPqEneE5estaaJkzU46Bfe6TY9A=;
        b=ne0XyNn1DBPynFPdD3gbYKx3PS5BovfpGczzD+9Ndk8iJSMnP8IHDCDBBQ+cRDS6bN
         +6Fssj3iEYsuhCnnhmLLmHBmM9we0j522A4GeQ1cCS/1g5c1/J4WyLn8Ys/vU1IWY493
         ag09Ir6nYkXWVuGppKErwKK2FdidY3CaFjyApucL5aGHZIKDhSnm5wz4kRErvK7qVFcW
         RhbOav2RIeQiS7fFD+2dKfANfSHW6mhUX5AakP4DGoSBHV4aK2C/4dgnU2s0dOF6UnXn
         QlH8hPZ42iFyPyu9R1iYzQ50PfvbJbAPTzLmTsJ0CRhsmLbVLX+raBUr2L6ByqMzmdr+
         IVPg==
X-Gm-Message-State: AOAM532pYvu34xllbAP4++Zb+17YFDPzeURzC2GPoOsnawGWuuEWo3h2
        DzjaGyOt1Fbvl1ngTKQCM4ee791fXcOIsQ==
X-Google-Smtp-Source: ABdhPJyVJfPTvBA+eafBfaBv+Yn6AIiWWX3S+Mv8h/+27e91pe3fG3VwRfy+nSIcb1136tugdu2cIQ==
X-Received: by 2002:a5d:85c1:: with SMTP id e1mr9107301ios.18.1625087924436;
        Wed, 30 Jun 2021 14:18:44 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id g1sm3012645ile.35.2021.06.30.14.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:18:44 -0700 (PDT)
Subject: Re: [PATCH 5.14 0/3] fallback fix and task_work cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d9368ce8-954e-794a-ec77-0cf6f38a884a@kernel.dk>
Date:   Wed, 30 Jun 2021 15:18:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1625086418.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 2:54 PM, Pavel Begunkov wrote:
> Haven't see the bug in 1/3 in the wild, but should be possible, and so
> I'd like it for 5.14. Should it be stable? Perhaps, others may go 5.14
> as well.
> 
> Pavel Begunkov (3):
>   io_uring: fix stuck fallback reqs
>   io_uring: simplify task_work func
>   io_uring: tweak io_req_task_work_add
> 
>  fs/io_uring.c | 131 +++++++++++++++++---------------------------------
>  1 file changed, 45 insertions(+), 86 deletions(-)

Applied 1-2, thanks.

-- 
Jens Axboe

