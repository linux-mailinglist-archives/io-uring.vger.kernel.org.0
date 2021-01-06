Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964A22EBF98
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 15:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbhAFO3v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 09:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbhAFO3u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 09:29:50 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC2FC06134D
        for <io-uring@vger.kernel.org>; Wed,  6 Jan 2021 06:29:10 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id 75so3303380ilv.13
        for <io-uring@vger.kernel.org>; Wed, 06 Jan 2021 06:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Miq3a/yWsdM3va7SYt76hZuVxciQI0gIvNiL9ePel7Y=;
        b=Bl2UxzFNHIt3m2/VDA1dRC7ejXnxPiQVlzYsfh3pQygQKmgK1igZGEB5ukNimMiLdt
         xeeEqSfffEq53brMyMPNF0RfJaPzuUXp4lpRGMpy/gdU3FFW6XzFJHtIPzhXfTSAcnaR
         Sur3IIZnlUT5EmknJ7DbbiDDRewc/yxWPwFBg7hGkTh5p8qaE1eUpL42kiKLupfpFiJh
         ss2IjHU63FvwhKCzEcjgfOwQFCtkYGM2N3iPVm/FhHrC2+inzRgqCJfyZHAyCzwjIQee
         eLid/97NvMXsbwIvA+gKTG14L7rbURbfmDVOTp/HTXQ+QRh8AjmuvQfQ4XhLExfH/vXa
         KJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Miq3a/yWsdM3va7SYt76hZuVxciQI0gIvNiL9ePel7Y=;
        b=gCaK2rvsr7CFfdgmwHYM+g8xYqdOUu9B8F8FtRCtm9wllY74oc8qzO4A5jIHLZ9q+e
         5tiH1KZSVC+FYw9hbJnUYIl9Ao90vXnC9jnL8ZQPoRSYTL3e80h3DMPyB4y9s4vpESKX
         L3j1DKqBIv74m2AUUahqTBMd3OshY5SIWQp0b2Qf1dxqMKGNW2ukOCsPkSblz/ucvcD0
         pju3PTi0qS3lRrAwfK8n5OzH8M+qXjwCrRm1OULBaXO/qG+Mop8jYVcCV16rcQnVxKgT
         bhrJHLuiPC2FrNgKQZ6F1MTlGLwSg6rS0umco4TOZl77wuyw98YYdlAHbpSIgfXffl7P
         Ladg==
X-Gm-Message-State: AOAM530GEI7wCwG438rOadTVA50Qf65idh4+GYb55h1lOtHq3VRwePOB
        mxZatbhnuPu/cTRJudF54oiHJA==
X-Google-Smtp-Source: ABdhPJxQJKDNdDpqH8UHDNrSwF6JY9A6A1Z9D81IKe6ZAb8x4B18HaBUTgBmv7EieWu2dffFyLUYKw==
X-Received: by 2002:a05:6e02:5d0:: with SMTP id l16mr3010276ils.90.1609943349918;
        Wed, 06 Jan 2021 06:29:09 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r10sm2144436ilo.34.2021.01.06.06.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 06:29:09 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix an IS_ERR() vs NULL check
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <X/WCTxIRT4SHLemV@mwanda>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d2da0e81-434c-24d3-8eb8-cccc391f481f@kernel.dk>
Date:   Wed, 6 Jan 2021 07:29:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <X/WCTxIRT4SHLemV@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/6/21 2:26 AM, Dan Carpenter wrote:
> The alloc_fixed_file_ref_node() function never returns NULL, it returns
> error pointers on error.

Applied, thanks.

-- 
Jens Axboe

