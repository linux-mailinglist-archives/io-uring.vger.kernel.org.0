Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623FD4201A0
	for <lists+io-uring@lfdr.de>; Sun,  3 Oct 2021 15:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhJCNG4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Oct 2021 09:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhJCNG4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Oct 2021 09:06:56 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA299C0613EC
        for <io-uring@vger.kernel.org>; Sun,  3 Oct 2021 06:05:08 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id b6so15569602ilv.0
        for <io-uring@vger.kernel.org>; Sun, 03 Oct 2021 06:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iQO0zbqGfFg861M8tcJXeO1xQAbguD5zVE5yDhTAq3Y=;
        b=5rKQzjoR0KmhW35Gf+kkJa4DaXD/gF9O22vc2aZ9HtWQZr/XZCBQtjSsWdG7j49h+B
         toYUQWK5dPAgLasgyJyRspJytDTJbgywK0JZ0grwlTz07k6Gng1GV1RZDzfmyfbkJ2sl
         OpH+y8z/048WsxX+nufbj6+DLJd3ngtPbLY2CCfAedmQAleTu2kv+tP/kKG+w4tePXP/
         ZTJt8CLYHp2OEalrxO4qHLPHfv+E5eAeSM/9Q02fWup5jtaeXMpSMG+YR5FLmp/cKseZ
         AUdSBI/nDoN8zkoyacXooLY/+rp4ZpVSUvRA7wxbnWrQRN4lgwLwvsmO1PZOT3JePLcj
         5iHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iQO0zbqGfFg861M8tcJXeO1xQAbguD5zVE5yDhTAq3Y=;
        b=gib1srwA7x6FhxotzvVfhefCan7GhC5LGxO4Lxx2PmHA7AsodV/ZvP1FN18RlSlmhj
         fNoQrhD3pxeCMIJlLBtPU4nttiDGn9U129gPJZTCuQ81KLriGZJQ1fvEGuhmzsjZuEFy
         OScM2sZrxmcGC3POZPjJZQiKHqItx1iU4/fChw2DLBAKXMeoP9AfxybbZlGQG6gAT26Q
         vCs8gwmN8fy1ODcEijAf/kY6mykdnA1wcmZTHfVFjcMLt+sNmr3VnAhgN3y7nOIl00Kx
         y/MBlKAbpzeghUfceRgvTyu+Rhf4iJ3HmrQROH2S2MBdNJZjGBE+foHxgd/XyOFcf1KT
         /tmg==
X-Gm-Message-State: AOAM5304slopHcRxn389IKtwkWtA0XvH9U8V4TPeD4/RwbDd3nGHiozw
        ZOWSS7rf9Lqs9nG+GF4G5fkktZRNEryy9w==
X-Google-Smtp-Source: ABdhPJyTHYN16jg4GJgQQ/fC4998eP2mkmEDPFQPECRwJ5w1/p9Jz0MWmUIjzwPZ24oN0r6ijRDGnw==
X-Received: by 2002:a05:6e02:16c6:: with SMTP id 6mr1503168ilx.220.1633266308016;
        Sun, 03 Oct 2021 06:05:08 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id e10sm6999168iov.10.2021.10.03.06.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 06:05:07 -0700 (PDT)
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in
 kiocb_done
To:     syzbot <syzbot+726f2ce6dbbf2ad8d133@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000062ec7d05cd6dd2f6@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ea115aca-1c4f-db6f-d4a3-51125db9e75e@kernel.dk>
Date:   Sun, 3 Oct 2021 07:05:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000062ec7d05cd6dd2f6@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/3/21 1:34 AM, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit b8ce1b9d25ccf81e1bbabd45b963ed98b2222df8
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Tue Aug 31 13:13:11 2021 +0000
> 
>     io_uring: don't submit half-prepared drain request
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b14b67300000
> start commit:   4ac6d90867a4 Merge tag 'docs-5.15' of git://git.lwn.net/li..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3c3a5498e99259cf
> dashboard link: https://syzkaller.appspot.com/bug?extid=726f2ce6dbbf2ad8d133
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124a3b49300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=142e610b300000
> 
> If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: io_uring: don't submit half-prepared drain request


-- 
Jens Axboe

