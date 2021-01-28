Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716A7306B01
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 03:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhA1CUN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 21:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhA1CUH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 21:20:07 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5147C061573
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 18:19:27 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y205so2997800pfc.5
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 18:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ey0CrgepuNX4oLvc3t2TaJSKdPIskmfV9uksdEQcplM=;
        b=YDqCzJIpYuuUUgO+VzpsNPXawNyKG8gZpVhdQDwX3ei/OSlqcq3Tka2k2J5UlA54yf
         /nWpdSuoTg0C1jXN+YZNp8Uupa0QrLc+RSvnV9zdjHuHVSeCDZcoXzLMgZDuBjzCVQYX
         /ra5lkcwLMkWBOpg2Tnto4plkHR1kuZGTlSJxHyjbghtJlCnrfqgZzTeejTZDJHdhphj
         68VYv15rLRd1lefQyxLhZXLJABiEnibambEzXXXORDoCUdOdJ6qvZANh8ng69PAJmnhf
         ELHc8I7fj/pd8KmN7ErSWfewBB5FGmsH3nOV7qi9kh+3XaBIQBNs4DjHKiW8g+ohvj7o
         ln8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ey0CrgepuNX4oLvc3t2TaJSKdPIskmfV9uksdEQcplM=;
        b=UZXXAssC6o2pUKVdgDvANZqH4lqfDyJ4yvf8ls7qFlHlWMJPi06I8WK4n8v4vOYS71
         nP4vloHk6G29T2K7E/gsVtszoOtCk/cs8Ox85XXhjtI76UNBYDMbtiNQMN+AioDnsC/B
         d9HyhgEa5Om5WP39QCyx8PR9Ccv/Zpr3wMMasoKGspSYF2026SPS5rWchzqwIMhVKM3k
         nOhgieeZRgr4xpLk2fHMwsPQxdicDmaCHTGmkFNsQNyqBaCbXF89GgaktpxvTfMUFAmB
         xKuEu/rtISeFAYYrZLak3CeVsJjuB2p6rkPeQnFQN926iVz+U2vnLxXOeKTYtmFpNvD0
         n4kw==
X-Gm-Message-State: AOAM533h+Op9BOhmV5YglmZytHbVf4k/BbD6muyHCHvP8eBjk39uertA
        dnCEy14nl/tPeSaam4RD99Zd0ScyV09piA==
X-Google-Smtp-Source: ABdhPJwtrqu31t0zI2F6CzQNkBO+LpN1goufuCGDlu48lD0cRni+2D1+jmTVhuy119GXYRs6f0ROmQ==
X-Received: by 2002:a63:f905:: with SMTP id h5mr5134615pgi.187.1611800367191;
        Wed, 27 Jan 2021 18:19:27 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b17sm3193602pju.15.2021.01.27.18.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 18:19:26 -0800 (PST)
Subject: Re: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
From:   Jens Axboe <axboe@kernel.dk>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org
References: <20210127212541.88944-1-axboe@kernel.dk>
 <20210127212541.88944-3-axboe@kernel.dk> <20210128003831.GE7695@magnolia>
 <67627096-6d30-af3a-9545-1446909a38c4@kernel.dk>
Message-ID: <f8576940-5441-1355-c09e-db60ad0ac889@kernel.dk>
Date:   Wed, 27 Jan 2021 19:19:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <67627096-6d30-af3a-9545-1446909a38c4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

>> Assuming that I got that right, that means that the pdu information
>> doesn't actually go all the way to the end of the sqe, which currently
>> is just a bunch of padding.  Was that intentional, or does this mean
>> that io_uring_pdu could actually be 8 bytes longer?
> 
> Also correct. The reason is actually kind of stupid, and I think we
> should just fix that up. struct io_uring_cmd should fit within the first
> cacheline of io_kiocb, to avoid bloating that one. But with the members
> in there, it ends up being 8 bytes too big, if we grab those 8 bytes.
> What I think we should do is get rid of ->done, and just have drivers
> call io_uring_cmd_done() instead. We can provide an empty hook for that.
> Then we can reclaim the 8 bytes, and grow the io_uring_cmd to 56 bytes.

Pushed out that version:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v2

which gives you the full 56 bytes for the payload command.

-- 
Jens Axboe

