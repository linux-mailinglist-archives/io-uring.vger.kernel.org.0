Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A22DA34D05D
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 14:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhC2MtX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 08:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhC2MtR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 08:49:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41764C061574
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 05:49:17 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so5881479pjb.0
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 05:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rxlu6rAulce6a90QUtb/XK4PFThX3KZXeA9ndiQKAD0=;
        b=O3JZ/VqkdF7O5Qe9ac40V92foBx1RmvRfDS3ShA9R6sqZNlc+MyIhhchNEOEGA4e1T
         kOSGSzRNQmBjvvK3+YVcIoauR0EVewLKYW3Bxe1+KgxM5wlgSjEbijDACiXxJe6DI5lp
         IQSAgx9NV3cZHJQxs5O77Dl9ADPvfDK71Pq0jF0V7VKTVyPCJqshADAZuONCSDpPMsMD
         BIzV0pUnG+9sJhpxRQGDc9gZ40x45cD2KvooCeQNkrXyMOVr+cJS9lei/N/5O7A2Qt1t
         W7HJDF7wcfl6k9IARwGRkKml3elCm2SXQLL69PSlhiqxQdWwR+nxaM+TkJCsvPJ2bUBQ
         cvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rxlu6rAulce6a90QUtb/XK4PFThX3KZXeA9ndiQKAD0=;
        b=SnerPyl7EFHl/uIgEheN1VLGebHbTf8tqMj2rQWZTFXt78RTWTreou/0dcZxiJCmQW
         V6g+gkF9z4BwzGj8t4MFWe6RXKlFhvWPKOXc9kCDG75vo35TZDNcF81qngnFwnyTvruL
         5+Y+duHaVtCE26jr7SpT7bEHMbUTSQCIvtL1a+19qH8V6dCIYSbOyK6qS8WXb3dj3/lp
         6fuvZr1G0CNrWRvqcKijwNvgliiNTq0AoYAEbxYRjAV+WTBIw8z4/3YRaPNNrD3PT30N
         W9qtpHwQF+K0dFlm80RszF9b/GFUlCmkzhQETuqLsqlUM3KMm5vqyj2Lt9QavrbNvOLM
         bzaA==
X-Gm-Message-State: AOAM5339FrJ2DnHe7UGCJd0LOXnCNzXbhq4k/RxGFMXA++UAC1Nz1SzH
        9N9YGt+6+0+70UBpDbLtElXg6Q==
X-Google-Smtp-Source: ABdhPJw+/2KIGaxprmCBKaLnoWZm/nWeWz9Fa9dRxy/4tiQFzOIhH2h8XYRoddN6MrYmcfipbPEksg==
X-Received: by 2002:a17:90a:e2ca:: with SMTP id fr10mr26902096pjb.18.1617022156746;
        Mon, 29 Mar 2021 05:49:16 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q15sm17846229pje.28.2021.03.29.05.49.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 05:49:16 -0700 (PDT)
Subject: Re: [PATCH 5.12] io_uring: handle setup-failed ctx in kill_timeouts
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     syzbot+0e905eb8228070c457a0@syzkaller.appspotmail.com
References: <660261a48f0e7abf260c8e43c87edab3c16736fa.1617014345.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <433a5e13-12f0-8abb-865c-aeb4a41cbc49@kernel.dk>
Date:   Mon, 29 Mar 2021 06:49:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <660261a48f0e7abf260c8e43c87edab3c16736fa.1617014345.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/29/21 4:39 AM, Pavel Begunkov wrote:
> general protection fault, probably for non-canonical address
> 	0xdffffc0000000018: 0000 [#1] KASAN: null-ptr-deref
> 	in range [0x00000000000000c0-0x00000000000000c7]
> RIP: 0010:io_commit_cqring+0x37f/0xc10 fs/io_uring.c:1318
> Call Trace:
>  io_kill_timeouts+0x2b5/0x320 fs/io_uring.c:8606
>  io_ring_ctx_wait_and_kill+0x1da/0x400 fs/io_uring.c:8629
>  io_uring_create fs/io_uring.c:9572 [inline]
>  io_uring_setup+0x10da/0x2ae0 fs/io_uring.c:9599
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> It can get into wait_and_kill() before setting up ctx->rings, and hence
> io_commit_cqring() fails. Mimic poll cancel and do it only when we
> completed events, there can't be any requests if it failed before
> initialising rings.

Thanks, applied.

-- 
Jens Axboe

