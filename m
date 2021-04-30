Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A353936FAD7
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 14:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhD3MrD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 08:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbhD3Mqw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 08:46:52 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A83EC06134B
        for <io-uring@vger.kernel.org>; Fri, 30 Apr 2021 05:44:42 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id y30so4185581pgl.7
        for <io-uring@vger.kernel.org>; Fri, 30 Apr 2021 05:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jw66FmD8Th0QIlNzmRqWGxuyLSOR24g11ihkkzBg7Ko=;
        b=hlGRePkaxoY7sy4aSFDJZJ3iBE4O2EHbsMruaZcDCC25qBXEfd3VPxCjyljt+WdSYA
         aGiSP8uZK5FGAyE8i8N4TUND0N5t3WzIGT7ApYUye2cZ/S6Bj7agyrzar9AbylkmAglL
         q6uGsnISmgxKgPqgwyIzvz+BUeDKscJOxj1NscyaQBVo44cP57H43cGKhCaDlFRyN3D9
         +8gknEmQIvz2hB/Zg+oYfyvUWrz1R/8HXwu2DZmMKlEhdrMird+6gqzITaZlHdZOtOct
         EFLw5+hqAr4WyVUh/iBNMsm6+R0T1Yr+btQzMf6c+QrIZRly0ZI1ifYk9tLcBBS06AK3
         rk8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jw66FmD8Th0QIlNzmRqWGxuyLSOR24g11ihkkzBg7Ko=;
        b=sLz0IUWqz0sPzQHvjPqmQWL8dtwgi67bSy/VwbH/+IQlUCzWU2hDa4X5354SFCZnQE
         UFNV/nFgj/Rkl4kqIJmSd/nQR16dG70SUcsbqDZpsIGQLwdUNPayQeq+LkMlB4vxm2cS
         PDUfKWyoL0wp/++vaIZMBAQ7Ao0jeAvTKRifaIj3eZbvORnX3ayrDMfr0K2a1EhULQvC
         bSqrVWZTByuYAZxenMp4IhkVYr1ufOdcNehTZVcgXQGaguKX8CNiTbbJUsH6Rz6UlP11
         xF5vHJgs4vwgZADLe8ZvqLPw8Jl1zDE8NqmRhnaYhJaC8jXLIbGO0ETtcl1HlYY965P7
         sqAQ==
X-Gm-Message-State: AOAM530pREOD0ZQWKUi2kjhnwmQWU3qskRDKDqkmc4eG39bHawfC07ef
        u37bJnpW7jMn8o5yS8SOX2T3dg==
X-Google-Smtp-Source: ABdhPJxp4RDv55/xdrSm4I4F9BxWtAc/wJ9l/k42USFudoXmPT9CwBFlfKrJabuvztMkL75wMOQgxw==
X-Received: by 2002:a63:f957:: with SMTP id q23mr4522088pgk.430.1619786681543;
        Fri, 30 Apr 2021 05:44:41 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x38sm2145473pfu.22.2021.04.30.05.44.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 05:44:41 -0700 (PDT)
Subject: Re: [PATCH] io_uring: Fix memory leak in io_sqe_buffers_register()
To:     qiang.zhang@windriver.com, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20210430082515.13886-1-qiang.zhang@windriver.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <51a36bba-c6d7-1e31-36d2-899466738e97@kernel.dk>
Date:   Fri, 30 Apr 2021 06:44:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210430082515.13886-1-qiang.zhang@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/30/21 2:25 AM, qiang.zhang@windriver.com wrote:
> From: Zqiang <qiang.zhang@windriver.com>
> 
> unreferenced object 0xffff8881123bf0a0 (size 32):
> comm "syz-executor557", pid 8384, jiffies 4294946143 (age 12.360s)
> backtrace:
> [<ffffffff81469b71>] kmalloc_node include/linux/slab.h:579 [inline]
> [<ffffffff81469b71>] kvmalloc_node+0x61/0xf0 mm/util.c:587
> [<ffffffff815f0b3f>] kvmalloc include/linux/mm.h:795 [inline]
> [<ffffffff815f0b3f>] kvmalloc_array include/linux/mm.h:813 [inline]
> [<ffffffff815f0b3f>] kvcalloc include/linux/mm.h:818 [inline]
> [<ffffffff815f0b3f>] io_rsrc_data_alloc+0x4f/0xc0 fs/io_uring.c:7164
> [<ffffffff815f26d8>] io_sqe_buffers_register+0x98/0x3d0 fs/io_uring.c:8383
> [<ffffffff815f84a7>] __io_uring_register+0xf67/0x18c0 fs/io_uring.c:9986
> [<ffffffff81609222>] __do_sys_io_uring_register fs/io_uring.c:10091 [inline]
> [<ffffffff81609222>] __se_sys_io_uring_register fs/io_uring.c:10071 [inline]
> [<ffffffff81609222>] __x64_sys_io_uring_register+0x112/0x230 fs/io_uring.c:10071
> [<ffffffff842f616a>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
> [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Fix data->tags memory leak, through io_rsrc_data_free() to release
> data memory space.

Applied, thanks.

-- 
Jens Axboe

