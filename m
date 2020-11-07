Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E851E2AA6A7
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 17:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbgKGQYT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 11:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgKGQYT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 11:24:19 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA36AC0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 08:24:18 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id r17so490643wrw.1
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 08:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2/15PsPacgQavyxrzh4fjwaIXtos4kpPgvH8B6ZacM0=;
        b=uPDIfQBJpurZkWZ9denpnMkHHT+k1LAebLg310GlMePSMk51OyrYymIn41WpuY0Vpb
         8PJ0z/sSq2p1hWkBNB9sxoBqdeZ4f3uak6GDB+jsH9pIjd9Se/5DHJVc5wEc4DkcRBUz
         lfF36WrCUYCDzXEGW1w/TyW+MOG2X1Vz68NGGEDVR6pkmleN07YI5xapFn9e94SKcLbH
         4rVYpd/SubsEjBhy71/YylVcvJsnraMAjmFXD8/3FyR48T91oo2IgO4OtuAzhww9mxuU
         zICEI9suUu4P0oS+Xc3AV49PIkuKLQ3jXfGYC3A2XzF0dpnt7JNL+w8JJZ5JKiSE2zSL
         4M+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2/15PsPacgQavyxrzh4fjwaIXtos4kpPgvH8B6ZacM0=;
        b=ajpLwfmAAS8UvfVH/DuNXC9+6UmL1ldjNM69ISci8HKdu8FFuP7feK8pU84gR3moRZ
         iCswjYPAZJh4wfDVra2U5EvZLE+Hd7bRebGkAV1Ru70QViiFZrLQgSSQCehnX2D7YXtK
         +ZW6f5KW4s4FsvdSD2hxfoFxHH5ce04VG/6N4pr4mqCgNjLcTSIkevyZi8+VuPoThjLG
         5ZvuHys8c86VZgVBOBUyQ6UwYJ0uDtbc2M0HRz8+riFmGCsuxeQbRBVwj9zAnWBqGZQJ
         HOeDzaoaSSWrmaYwziRH0ONlMCdn6EhPWGUR41ZJTE4X4cYNETbCX7yyrvlZ4zILcnY6
         7E0g==
X-Gm-Message-State: AOAM531kKGz8DL8Nj4kvw8zhPLTywB1O1b8UuFkokWnU8mUv/GjKMg0u
        WOy0d6CHU4kYur1G4n/xKBpU1Zmn9+Gz7g==
X-Google-Smtp-Source: ABdhPJwhOJQI4l2NfttkpYGxi49VT2urZZYOWaj6RDXtNy7pFfsE5Tx+lAWxgoc973VgSQLyMYNO7w==
X-Received: by 2002:adf:814f:: with SMTP id 73mr8516255wrm.174.1604766257377;
        Sat, 07 Nov 2020 08:24:17 -0800 (PST)
Received: from [192.168.1.84] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id b14sm2520996wrs.46.2020.11.07.08.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 08:24:16 -0800 (PST)
To:     Victor Stewart <v@nametag.social>, io-uring@vger.kernel.org
References: <CAM1kxwhuVfkofDXKaeW4J6Khy2Jp3UcXALQ4SdP9Okk_w7zjNg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: allowing msg_name and msg_control
Message-ID: <7da29ea8-47b6-a122-c16e-83a052e4d0d9@gmail.com>
Date:   Sat, 7 Nov 2020 16:21:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwhuVfkofDXKaeW4J6Khy2Jp3UcXALQ4SdP9Okk_w7zjNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/11/2020 14:22, Victor Stewart wrote:
> RE Jen's proposed patch here
> https://lore.kernel.org/io-uring/45d7558a-d0c8-4d3f-c63a-33fd2fb073a5@kernel.dk/

Hmm, I haven't seen this thread, thanks for bringing it up

> 
> and RE what Stefan just mentioned in the "[PATCH 5.11] io_uring: don't
> take fs for recvmsg/sendmsg" thread a few minutes ago... "Can't we
> better remove these checks and allow msg_control? For me it's a
> limitation that I would like to be removed."... which I coincidentally
> just read when coming on here to advocate the same.
> 
> I also require this for a few vital performance use cases:
> 
> 1) GSO (UDP_SEGMENT to sendmsg)
> 2) GRO (UDP_GRO from recvmsg)

Don't know these you listed, may read about them later, but wouldn't [1]
be enough? I was told it's queued up.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/net/socket.c?id=583bbf0624dfd8fc45f1049be1d4980be59451ff

> 
> GSO and GRO are super important for QUIC servers... essentially
> bringing a 3-4x performance improvement that brings them in line with
> TCP efficiency.
> 
> Would also allow the usage of...
> 
> 3) MSG_ZEROCOPY (to receive the sock_extended_err from recvmsg)
> 
> it's only a single digit % performance gain for large sends (but a
> minor crutch until we get registered buffer sendmsg / recvmsg, which I
> plan on implementing).
> 
> So if there's an agreed upon plan on action I can take charge of all
> the work and get this done ASAP.
> 
> #Victor
> 

-- 
Pavel Begunkov
