Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDE23F3B0E
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 16:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhHUOgM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 10:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhHUOgL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 10:36:11 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E47EC061575
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 07:35:32 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id v2so12503471ilg.12
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 07:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2gyfelHB2aycuBn/t6hqC/gI/6Upj5TjBBj9SZ+Nz80=;
        b=bLwJBN8pGSDiBwqy8oLXvMSINghiv+MCHhx3M+7B8Vsy8QN36cHtaolRqWtAMfkNYU
         ASEVosAjsCW1qqXba7rjbHKp1gJIhzpBUuL692jkNR2u8UzAFp4qEzTbCHdQYoSo9hN8
         Edj67AeMcXLGDvYHGoOGp23QHrkP2RiLmtRqC6W71BXqCKR/GzmpeAMLaJCg1uUYFolS
         irF8EC8P6XxmEWuWO+ligJB9ScS3dWYb5MzXclbDFAmLNq3zjraY2JncoZXx1pr1CiRi
         +r1Mr7V5WRjhtWTwSEzOxr3eVZXLliUspjQj73CbHtiwXc06NI00uW6I9ngELlqwl5DM
         o29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2gyfelHB2aycuBn/t6hqC/gI/6Upj5TjBBj9SZ+Nz80=;
        b=V2pBMXEJ2qQzuIkAIaeVZegJ+G4z66l5FRbZSz2RMDVxx9brSZK+tMI3Og4XOVrYFS
         2gh5jnVjA6cuDfRCTKudpUMd+G3i0srxMM/tet3iiZ/YaBT74JHeQ1AXjWhneXQJWMBs
         udX67/pYmtGzE0T6a+/waBFv12mhYWirLslCrvIT1T0tjrhHJM2LCvh4Z0yBFE+sGcG1
         IMMud8lwHUI3DV1/P79/aL+bJaA7Zy88DgxiyqHNbgw5lh81z8IMsweJD/i4+paV9m6/
         3WlvffUVshz1grO1hEkJNSlOiTIrGOd2yPUpOMtJbTR/xIA7mMyY138LLLSgc6BouR/C
         Js4Q==
X-Gm-Message-State: AOAM532M6FGHahgpY61hty8wZVB0hDDn5u4CUmRs03puGS67GTgG55lH
        EXE5+sSg3gZF7eyEIwGj8E01QK0cfq44oXlw
X-Google-Smtp-Source: ABdhPJylOpsWQfhGOOeZAeWDB6n15MoqCQF2hARA6s6ZI0DPNJEdO6yzC71ExrCIYYBoeLEtx55xYw==
X-Received: by 2002:a05:6e02:f44:: with SMTP id y4mr17413006ilj.257.1629556531433;
        Sat, 21 Aug 2021 07:35:31 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v14sm5181943ilh.54.2021.08.21.07.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Aug 2021 07:35:31 -0700 (PDT)
Subject: Re: [PATCH liburing] tests: fix test_cancel_req_across_fork
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <956be84e623dda6f7fbd0e0b0840a8dff22e6f45.1629555705.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9c2304d4-01ab-adb8-7f57-3b3c82b52b6b@kernel.dk>
Date:   Sat, 21 Aug 2021 08:35:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <956be84e623dda6f7fbd0e0b0840a8dff22e6f45.1629555705.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/21/21 8:22 AM, Pavel Begunkov wrote:
> Rarely, the request we're trying to cancel may not yet got picked by
> a worker, and so the cancel request returns 0 instead of -EALREADY, and
> it's a valid output we should consider.

Agree, applied.

-- 
Jens Axboe

