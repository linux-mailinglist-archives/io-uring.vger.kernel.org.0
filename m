Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5E14A3154
	for <lists+io-uring@lfdr.de>; Sat, 29 Jan 2022 19:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352859AbiA2Scb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Jan 2022 13:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245118AbiA2Sca (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Jan 2022 13:32:30 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797DDC06173B
        for <io-uring@vger.kernel.org>; Sat, 29 Jan 2022 10:32:30 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so9592419pjb.1
        for <io-uring@vger.kernel.org>; Sat, 29 Jan 2022 10:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+Q0KskOzHfXu0Med3x+V7QCm7Q4Z553C4/0me3aW7mM=;
        b=PyeWIc5TRRxFI1vhQKBrAv1n/IUAoAJEtx5ABNsc+IeQRLe8LvNOiJE7iDG5TpHlDz
         e2pnqUzk0YbcF0a7w+Hq22g/UOvFG7aACf/uJFnR6RFPKUrL5avOC8poOem4ymzWK/++
         V5Fga3PRvyEespje2r0u83wrey9lCRe6q27MrbLz4Mtf3WL71LJMi0WEBuueAKgy/Nr2
         Ecr1nxz77Do+XqBK/jKKDJdb65UEnQr4VFwwcp+T5u+dSpUNuAXETH7aIqzNLA+e+LF1
         TXMHNAx7LuPOICGjbMgJ+4nQ1owAGE+x6w588UJsbzEq7OYOnbhtVILQn5zio/kovZeo
         p0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Q0KskOzHfXu0Med3x+V7QCm7Q4Z553C4/0me3aW7mM=;
        b=dz5oaU75I5Lt+Gzh5aRsdGzjgxIcOpZ4haI8BnZveFV6y/BPw0FgS7P8mrpTu+sMGM
         uvRouxuXbraMG0kNK5dwhIrch/L3q3sZq39e3R6jA6dt92IOvoTXTn+KBEIKWaloqIjK
         8w7S/01c5oHLgSEXaugsAsgpdHq+Ww4/lGU6bg5W6RCsIVhEM2jhY+ExHSLrJMCrBH8y
         CV+34s7LCFCey6X7uWNg1iZt4PKTN9hUgp0OS26HzuT7f0Lm7puoo8TZbe8+eInXzN6a
         renkt+BMq5sEUhhLyB2PSlg+eJX1O910Mu/sOeT6VVpBMmCeMJtRPUNwL809c82MHx/L
         xWLA==
X-Gm-Message-State: AOAM531gOYj3TNkFFIubpks6/OHavFsCwevj7KWq8gNo5xAXQqZqYT6t
        16r35wXc7QzlEbqLiwx5+zj+KQ==
X-Google-Smtp-Source: ABdhPJxg+z6WXi1V50x2y7mGuytMCIsoNwXmTfAyHAMt33DbYNDyy93MOV4HPSGOJ0sT04FXCi01bg==
X-Received: by 2002:a17:90b:3148:: with SMTP id ip8mr16282950pjb.106.1643481148667;
        Sat, 29 Jan 2022 10:32:28 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id x18sm12922996pfc.123.2022.01.29.10.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jan 2022 10:32:28 -0800 (PST)
Subject: Re: [PATCH for-5.18 v1 0/3] Add `sendto(2)` and `recvfrom(2)` support
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Nugra <richiisei@gmail.com>,
        Praveen Kumar <kpraveen.lkml@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>
References: <20220129125021.15223-1-ammarfaizi2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <98d4f268-5945-69a7-cec7-bccfcdedde1c@kernel.dk>
Date:   Sat, 29 Jan 2022 11:32:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220129125021.15223-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/22 5:50 AM, Ammar Faizi wrote:
> Hello,
> 
> This patchset adds sendto(2) and recvfrom(2) support for io_uring. It
> also addresses an issue in the liburing GitHub repository [1].
> 
> ## Motivations:
> 
> 1) By using `sendto()` and `recvfrom()` we can make the submission
>    simpler compared to always using `sendmsg()` and `recvmsg()` from
>    the userspace. Especially for UDP socket.
> 
> 2) There is a historical patch that tried to add the same
>    functionality, but did not end up being applied. [2]

As far as I can tell, the only win from sendto/recvfrom is that we can
handle async offload a bit cheaper compared to sendmsg/recvmsg. Is this
enough to warrant adding them separately? I don't know, which is why
this has been somewhat stalled for a while.

Maybe you have done some testing and have numbers (or other reasons) to
back up the submission? There's not a whole lot of justification in this
patchset.

-- 
Jens Axboe

