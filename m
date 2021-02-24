Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCA8323613
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 04:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhBXDfw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 22:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbhBXDfw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 22:35:52 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C47C061574
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 19:35:12 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id t26so597905pgv.3
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 19:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jpNgBWIl8gH0uzbEJuj+DW9nbULqVLhFeiWjsvZc2Dw=;
        b=kPOgu402CzPCu7ZrE7svD+XhhaWDIwMN9AaE4IsZxbOOIcwNhuDpnBp5DrdWyfwGf3
         sk1wT1xccXizETpY27jQLecW8mnIMGa77CMkQExLZo55jZSG0egNzAX7fZTWyNxhXWq8
         KHpXN/9eYr/UVLEtqHRSStCHqkx5hP39GEeSIlPcLEhgAd0p7tkOGHfQHZy7ojJpqUSS
         aUA563WObHRjFRrN2uLK03L1oB4YZ56NBxLypJQ3i0nTc8GRIZLvs9X/8FMpULemK0O6
         Cku7EStW33+uJftE1wsuk3XQpoHojW4T8bOyLUoHf4EKNotKayopS6rlf6cCJfR8RRQX
         c00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jpNgBWIl8gH0uzbEJuj+DW9nbULqVLhFeiWjsvZc2Dw=;
        b=U2HCkXYBkcz2ui72N/eVr5+YvaZAaiCD8cIRdRR2OW8ksCGO4FrPgKkFgvD3aLk6Ko
         pTdOME4U7SlxkqL17MLzzLEqFPLMpLS2bGqBjah57AybR/MzukarCoUQioZumXwkkTvG
         ULuXO+AqvzjblNudpBG0CEDCW86bGRoqH1m7Wew8h1bO3MKqZb9Bj9TjqHeCnROGfnBQ
         IHDJ3x+BCOqnVV9F+mN9qnMU5kRRllcK2QMll9rxb8Qgz3QPPZ9KOQu1tjT34liIjjKt
         YQaRFaWUn6zFSIKU7Kf/8Xssiw11Wv9ASKtiz/j7cRlMHfzppqLE4dkqc3GBF1JF2SR0
         SW6A==
X-Gm-Message-State: AOAM533Q7P3wfy094vwU35cI/cGsJ3KPXiJLwZC8jmXPq+4gTQbe3Qgh
        ZHmapma5xlz/IT38HOcITtQE8vd2m0ZVmg==
X-Google-Smtp-Source: ABdhPJwCNX8jquxtK/yBirrN7iAJp/IT4UZ7SYjyLBbp56b7W2wL2Yht5uQ+O284m5c0non3S/hjXw==
X-Received: by 2002:a65:4887:: with SMTP id n7mr15933566pgs.14.1614137711254;
        Tue, 23 Feb 2021 19:35:11 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a19sm535115pjh.39.2021.02.23.19.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 19:35:10 -0800 (PST)
Subject: Re: io_uring_enter() returns EAGAIN after child exit in 5.12
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20210224032514.emataeyir7d2kxkx@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <db110327-99b5-f008-2729-d1c68483bff1@kernel.dk>
Date:   Tue, 23 Feb 2021 20:35:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210224032514.emataeyir7d2kxkx@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/21 8:25 PM, Andres Freund wrote:
> Hi,
> 
> commit 41be53e94fb04cc69fdf2f524c2a05d8069e047b (HEAD, refs/bisect/bad)
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   2021-02-13 09:11:04 -0700
> 
>     io_uring: kill cached requests from exiting task closing the ring
> 
>     Be nice and prune these upfront, in case the ring is being shared and
>     one of the tasks is going away. This is a bit more important now that
>     we account the allocations.
> 
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> 
> causes EAGAIN to be returned by io_uring_enter() after a child
> exits. The existing liburing test across-fork.c repros the issue after
> applying the patch below.
> 
> Retrying the submission twice seems to make it succeed most of the
> time...

Oh that's funky, I'll take a look.

-- 
Jens Axboe

