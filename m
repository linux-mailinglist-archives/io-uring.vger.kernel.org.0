Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90553BEFE0
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 20:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhGGS4X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 14:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhGGS4X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 14:56:23 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46B3C061574
        for <io-uring@vger.kernel.org>; Wed,  7 Jul 2021 11:53:42 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id j12so3973558ils.5
        for <io-uring@vger.kernel.org>; Wed, 07 Jul 2021 11:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mu2+qa0U43gTAe+HguC61ti7EkwAcWUZSC75ohi6WJo=;
        b=r/j7GskvyGdQhOGgz9eEJq3kkKuRg0TIsucOSbqebeag/8P46pN2ygOvmOXZWCEygS
         eS3dZV4EVcPvKOpMjsB0GKCsgDKLhM39dzBz/Ozxmhyz26EcWQQD8a6F90zUVR468lz9
         L1FhxMS3X+Y7pyvKuMm2p1iFnSt1XPY4nOj61vWbSS6tJqAAh686NNEnAuWV51OMkqSB
         Q2fH8YbI2NDHY/t9pXsPVF03qSogpHwg+oCp4Hq5RjNZ1V1UJWrVV0N5ytmKpfltj2qt
         z3nsqnsPgfRGpJtVLNXCQho7NyuieAlxfrHUjXdYQlqjl+DRubpDhAjUKQC4pjPswjIr
         xOIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mu2+qa0U43gTAe+HguC61ti7EkwAcWUZSC75ohi6WJo=;
        b=W2svljunPl8XntpjNZ4uA8NNiybDhPrYSpXn8/pkbAq5b4iCrivQeejeErsU/AjVBC
         BPqYTvoDijJiVkivUo/wxfCTB4F1zLkLbj4q+cez6Le7J1zj0M6THJ0Gf2Cjeei52RnA
         vKNR8gBEwYKo9JCZVSpoJkPz311844wCxYleaPFNbsHtZleU04BwfB9pRMl4zvRra4Xh
         jysyVrtfc1lxYQ7f6qUhtaqUtyPr4ghM8SXo7JX5Jii1KZKtD2Idv7MBoXYU48oC6U0g
         qFnShe6viROGfP2Ggs9dw8pO8P2yMwnucMxPgzx7XaxCFLeNurLqFKSXmxuAnSIbfebw
         idBw==
X-Gm-Message-State: AOAM533CqR8q5vgk5xJnKbHgC5y5zeThZS+T+9/9V4e5xrUxtjTCssEO
        w35xfh/iudidYaTyZ8pdDJd2Lr60FTAtQQ==
X-Google-Smtp-Source: ABdhPJwinYU9frV5hHUay2Tq1j0q1LES/bmy5q0VWoCD+yBq//ZHPaplzlsk1gviibb7XQQGoIAdDg==
X-Received: by 2002:a92:6d03:: with SMTP id i3mr19270704ilc.66.1625684022094;
        Wed, 07 Jul 2021 11:53:42 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id q6sm10759578ilt.41.2021.07.07.11.53.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 11:53:41 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix drain alloc fail return code
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <e068110ac4293e0c56cfc4d280d0f22b9303ec08.1625682153.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <78a2f89e-dcd8-8da0-bc0f-5259407276e5@kernel.dk>
Date:   Wed, 7 Jul 2021 12:54:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e068110ac4293e0c56cfc4d280d0f22b9303ec08.1625682153.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/21 12:24 PM, Pavel Begunkov wrote:
> After a recent change io_drain_req() started to fail requests with
> result=0 in case of allocation failure, where it should be and have
> been -ENOMEM.

Oops - good catch, applied.

-- 
Jens Axboe

