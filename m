Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA8132ECC8
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 15:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhCEOLZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 09:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbhCEOLT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 09:11:19 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54674C061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 06:11:19 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id z9so2115020iln.1
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 06:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l6IgK3ij/YjTNmmcEwyfRQ1upb35j4vL73l5Wo3XyTo=;
        b=air1o57k6XY5FgslA8r0maE5x9dm7J/LFHlDA1WEJRvWIoZqZJ3fWHOJQcW0Eo8WEU
         5/HqZ84JS+9Jg1VC8cpLVcwC/VLhBFYDK26CJKbmcDHyNoATnAGJYWGY64MWDMB0oLh0
         C+/wgD2MUZTqtJsr0dPKwWmVoIkEknbTGHQg3elNISKUZ61nlxNZZL5bFVI8Wyopkw/w
         U5AAD+G4kLtLnKHd9fxnCNh8ZoS4Bo4y9Hz8LoUsjj0wpzo8b5U+V5iSwQwsX1Ty1tEn
         sSB5WQOhjPvlEBGHL+68Yuj2UTTwUFFSW483k92G/Zl1oTVHrtz/oau5JEeTiz+lJU+a
         wmEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l6IgK3ij/YjTNmmcEwyfRQ1upb35j4vL73l5Wo3XyTo=;
        b=HbuTtuv2zkUxAyTi04dRbz3Jsvc13NS63IujBWolrflDokPXEmmdxrq+H/cy+suSbA
         9SUTgFJLtk47pbvXRBRw+zhNCyBTmlq9zt5gwfU+FOT0Vy4oC1QydJHMo7NSvollvR59
         GU4C5v2mP80z4EstTCoWBTdexruqFxLbBQJAJfPa33eYafP8sNzeT19DTNbQ3uPq3LRs
         xDvAeJvGj1y8Ed5GYAFwfNp/Vl1S9dnOxXpF5EXyDsj22Ke6ZAlk9/wSFyxuVy3krtXW
         2GSvBfaDNdHdewNehqma7WAza1nts1zEiTsFBkgVA0fvaupLqWZnu45paIN1EZQocZRJ
         BV1g==
X-Gm-Message-State: AOAM533f0qNl7h5/0Ll/ZAK1pHAEbvS7Nx/cUxlR/UcAlTteELAbBvIt
        EIFRqCuEj47ZFzJvtgqreNhOvw==
X-Google-Smtp-Source: ABdhPJx1jHAyAAVkrSYkKfQUk8fYUr60wo0yZNlweVSgSYTVLm0o+aREwH8rNuFbNkSYkmy7E8ApRQ==
X-Received: by 2002:a92:b003:: with SMTP id x3mr9569044ilh.15.1614953478153;
        Fri, 05 Mar 2021 06:11:18 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u14sm1363894ilv.0.2021.03.05.06.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 06:11:17 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: BUG: soft lockup in corrupted
To:     Palash Oswal <oswalpalash@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hillf Danton <hdanton@sina.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        syzkaller-bugs@googlegroups.com
References: <CAGyP=7eHKPdST4sVEKQZ9fZEhoT5MOMH2FZjzXVb6_SzSwGaAg@mail.gmail.com>
Message-ID: <dfa85777-758e-96b9-4859-e22e92a1d5a7@kernel.dk>
Date:   Fri, 5 Mar 2021 07:11:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGyP=7eHKPdST4sVEKQZ9fZEhoT5MOMH2FZjzXVb6_SzSwGaAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mar 4, 2021, at 10:06 PM, Palash Oswal <oswalpalash@gmail.com> wrote:
>
> ﻿Hello,
>
> I was running syzkaller and I found the following issue :
> Head Commit : 27e543cca13fab05689b2d0d61d200a83cfb00b6 ( v5.11.2 )
> Git Tree : stable
>
> Console logs:
> watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [syz-executor497:423]
> Modules linked in:
> CPU: 0 PID: 423 Comm: syz-executor497 Not tainted 5.11.2 #13
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
> RIP: 0010:__io_cqring_events fs/io_uring.c:1732 [inline]
> RIP: 0010:io_cqring_events fs/io_uring.c:2399 [inline]
> RIP: 0010:io_should_wake fs/io_uring.c:7190 [inline]
> RIP: 0010:io_cqring_wait fs/io_uring.c:7283 [inline]
> RIP: 0010:__do_sys_io_uring_enter+0x6b9/0x1040 fs/io_uring.c:9389
> Code: 00 00 e8 ea 9a cd ff 31 ff 44 89 e6 e8 30 9d cd ff 45 85 e4 0f
> 85 5c 08 00 00 e8 d2 9a cd ff 48 8b 5d c0 48 8b 83 c0 00 00 00 <8b> 88
> 80 00 00 00 8b 83 00 02 00 00 29 c8 8b 4d c8 89 c7 89 85 78
> watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [syz-executor497:416]
> RSP: 0018:ffffc900001efe58 EFLAGS: 00000293

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.12&id=701b8b187525e3b90cbcab4dbc073f42dbcc4059

— 
Jens Axboe

