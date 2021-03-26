Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE07034AC08
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhCZPzW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhCZPzE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:55:04 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C21C0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:55:04 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id e8so5866198iok.5
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YzxP5UpfFXdsVjJxXNszyr/h/KQIg+2Ous8Alsocgxs=;
        b=k0rTeDxuRcDitKcq6A/fj46rQMjOFobooSlsh0UUi6TtmUFHMsN/S3ODgc1bU99moK
         sDInNblVM5dKeL/ve5fR4++SNp4c27gyxZAE0yKV8pM/Kr5hArzYG5N98G02Jq8zG7i4
         IQr3xDW5QRTCWVYDm7SnV0ZM92SHVu07vQD/IwT/vLVaJomcwfMoZRk8O4zXDuAdQSVw
         CPSUHzZsDNS+vZ66j8T/H3f/yZk5NuecAE8/1y+DbgOHINCxV92UQjhrAdoxkzePeonL
         TFgsR/d+4qPY5Crb0f8j+x86ZoLsUNzST9HyF4EZkEaCNenC8Gu6benspZSMraqh8AIj
         lkXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YzxP5UpfFXdsVjJxXNszyr/h/KQIg+2Ous8Alsocgxs=;
        b=jdR9AopZP2+r25OsQVFMLFjzZIu5lr6i/91tbp96UuWEAsS/Zum2OZdJDsAJ2NquS1
         lRjoDgA2sAUDWwIXoFZUaSJJF2jdMsSMKX0kg8dyQ5rCLd1B84rVkL+l3d6h8Io939R7
         zqVBzWPHokP9TOGVCyAMlSBB2xQSx+bS6TV4IzNpcQqV8Pehh6Wv/gqGgORLBFjDSVzI
         yirJBil1LmBH6/nnJbFQfNfEXMi0wbhy3rLbo8dMLSW0aEkYZ/knw7v88bKnGeFvxB43
         +vgmabKI+g5naxvkBdlOZ1JILXSFdiZG73Ouin4MVeNa/9lY4K0EHStaVU+JUjlhGNdM
         x8Bw==
X-Gm-Message-State: AOAM530GEMlUEdwlLi7CbR/ohC2FB+A6WHbkNyMdZnSys1j0VrrF8KZH
        ijFgWULuC4paKqM+dnv8iWe1q4FuS69Yhw==
X-Google-Smtp-Source: ABdhPJzfezg9AFcAXuK8fVd0G00AQ5wyzIwWci7EEx32Tz3G65PKk07mTu8xAsZ6+MP2Xfp7o6NhUA==
X-Received: by 2002:a5e:8e41:: with SMTP id r1mr10778831ioo.5.1616774103901;
        Fri, 26 Mar 2021 08:55:03 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o8sm829876ilt.4.2021.03.26.08.55.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 08:55:03 -0700 (PDT)
Subject: Re: [PATCH 5.12 0/4] cancellation fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1616696997.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1189a1ea-d07a-d4ad-23c5-417b226d9873@kernel.dk>
Date:   Fri, 26 Mar 2021 09:55:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1616696997.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 12:32 PM, Pavel Begunkov wrote:
> 1-3 timeout cancellation fixes
> 4/4 prevents a regression cancelling more than needed
> 
> Pavel Begunkov (4):
>   io_uring: fix timeout cancel return code
>   io_uring: do post-completion chore on t-out cancel
>   io_uring: don't cancel-track common timeouts
>   io_uring: don't cancel extra on files match
> 
>  fs/io_uring.c | 53 ++++++++++++++++++++++++++-------------------------
>  1 file changed, 27 insertions(+), 26 deletions(-)

Thanks, applied.

-- 
Jens Axboe

