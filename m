Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC98C34D916
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 22:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhC2Uhy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 16:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhC2Uhm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 16:37:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25281C061762
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 13:37:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so8324074pjb.0
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 13:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yHw9sshxoYuACLrTjqNN6yy+mznnvpE/1N42vZsEoUs=;
        b=h5F9vdRjQ4LioJG8eD9OmaooCXnroWwcI7ACooozOP9Cf8J3AjghvHTR9E/XFPxuJO
         xRZGLs0FI0RIexkC89/kGGBdQA5Khpvf+3BBT9uZpZBywUoWwfRjyyKtuWLMiNDz/S+v
         b7k/sPntQJy4rp2SazSrLRsHdeJ8gtvCrirojjQ8QO+HUlZGOJdTx8dgfpHEanUc9L4g
         QrBjx6c5m1MGZu6/cv+aVsgW6pDbaZgMDaReujs921UUMPPAGuJBWbFNAvGim1XfY/5n
         nLsH5+NmfIwiwmdzxlYtFXaHp+VJc3ok21R7bs085bQKNmZiUltWtf9HIYpm7IFu1nf7
         NuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yHw9sshxoYuACLrTjqNN6yy+mznnvpE/1N42vZsEoUs=;
        b=HMuF/Ny5kGFoooGbe/fHV2H0f2GVDAhBniNIJ7EgZrUmklpFBvNYeXgzS+G45ran0m
         vNTjD9NgxaArX+jSNVoXk84X/Ol9azJvNTYuGHPMWLGAzHvzH+7XzTMDH0NSxyeFh3S7
         gX9/Td8Ty//mr/PuUfaaBEWDX5AUWn9EUae40o9knNP80hG0rOu1W1L0wmwXUnep7AIE
         sgHi5pXGusD3RlckaamvazmQmF10RzAPc2IihI9SVrElneq3d213LxcMqPM7wBeqQQeF
         aQ55nphua4m1D0dVL4X2DHPjJ6d7uTqS/FiLpGHprXfmX+/4irkd4Kwcnfbq5m+gYGp6
         pGag==
X-Gm-Message-State: AOAM533vYgCMrd5C3zXaUiUlSfyJ1NeEvztBt7qs1I/7WLE4lTK9B3YK
        yoO0lsN/CnIr9U7bbkjGahuplVYOBE3YsQ==
X-Google-Smtp-Source: ABdhPJzJTU9hNPRCb3LW8F5vA4F04gPYzY16Ecx9WfPIlEfDFKSb/4CUxWGqJp8gvey7vWpPt4dlew==
X-Received: by 2002:a17:90a:f489:: with SMTP id bx9mr876313pjb.80.1617050261376;
        Mon, 29 Mar 2021 13:37:41 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o3sm422731pjm.30.2021.03.29.13.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 13:37:40 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] io_uring: add mkdirat support
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210202082353.2152271-1-dkadashev@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <81aae948-940e-8fd3-7ac8-5b37692a931b@kernel.dk>
Date:   Mon, 29 Mar 2021 14:37:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210202082353.2152271-1-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/21 1:23 AM, Dmitry Kadashev wrote:
> This adds mkdirat support to io_uring and is heavily based on recently
> added renameat() / unlinkat() support.
> 
> The first patch is preparation with no functional changes, makes
> do_mkdirat accept struct filename pointer rather than the user string.
> 
> The second one leverages that to implement mkdirat in io_uring.
> 
> Based on for-5.11/io_uring.

Can you check if it still applies against for-5.13/io_uring? Both the
vfs and io_uring bits.

It'd be nice to get this moving forward, there's no reason why this
should keep getting stalled.

-- 
Jens Axboe

