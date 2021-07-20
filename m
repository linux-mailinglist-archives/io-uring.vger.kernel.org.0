Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB743CFB64
	for <lists+io-uring@lfdr.de>; Tue, 20 Jul 2021 15:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239341AbhGTNN6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jul 2021 09:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbhGTNLg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jul 2021 09:11:36 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F99C061574
        for <io-uring@vger.kernel.org>; Tue, 20 Jul 2021 06:52:11 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id o4so17947404pgs.6
        for <io-uring@vger.kernel.org>; Tue, 20 Jul 2021 06:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mg96Ac5h0FwYX7AHJlirtckZlaLSWupGqp2mVuP86C0=;
        b=cHDkGdim5v/AoF0Ty4L+Z9X+fUgfhOIu3n+Eps0zUe/Wsmro3Bdh5S8IQFemUeyfwb
         9bhKF/Xl+kCaIQTQ4LS9+XbkbALVxb4AcAC8bnxyysQsUgOMQKDmxyuQewJqLpcLH7cB
         DAo2aSJjNPy4waQZNW4b2m0N2H15CUPqP5T3iT8kRhyJW0JUuG/1aQTQeF7lWwHWY0ar
         c3+eYT9sUUnQcLEw7vRjflG1avQpPrz5lovoLi19QSTZgpqXJP2zieqe5paTmhOPCDPD
         i+sgaj1U/+jDuAujkqpgqCQYekLn9rncMx1Xi6njlrqJPa0/87OCAysjBPWXTln8bbhM
         jg/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mg96Ac5h0FwYX7AHJlirtckZlaLSWupGqp2mVuP86C0=;
        b=AI42DAuIG51vxh8dwLWUs5jwPd+Y02kCfkFrka89K3N+bwDdYkPe1z3hHvqWCcKIYM
         MaW1kvmTGznn/gzXdgcZDvAJp1NIwXyE3hz4XagaLe9KnnxhZ/+ZnKvOPAxBzK72LsvR
         2M6kuISVPG+pj7hG9s0Fg/tFLyxxSNplIsWpzVpGRsimKEPZi+1S5oqrDvGENlu4qGEr
         zYlNm1/5fLKNCsiDzy2LZAkh8wRoQtU3WFvTPSPcUlQPWqNr17btK5GwvEHbMgRLhXnd
         vWLmwmDgSQnIJLq94Yjvo6x94vgQUzo148HXN1CWO6Xm2ttNwU17Yipsw9/VVOdj6cC/
         5dBg==
X-Gm-Message-State: AOAM533DNiJT15qEESAh5hut+rPIyLqjoKRpCIuCj8TfCfv9rVqIh743
        WCI18cNvPn0MweCKIwW9g5uhYA==
X-Google-Smtp-Source: ABdhPJzrJdVaaYE1SPojmpR4DYAxF+il6fg+MjegzvCVsYljtsjxNkJZwM+BhLiAgYgyFR6IjqGqnw==
X-Received: by 2002:a63:4d61:: with SMTP id n33mr14230339pgl.219.1626789130776;
        Tue, 20 Jul 2021 06:52:10 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x6sm28325022pgq.67.2021.07.20.06.52.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 06:52:10 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix memleak in io_init_wq_offload()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20210720083805.3030730-1-yangyingliang@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <43a58f84-bd43-a644-bc8c-642147b354aa@kernel.dk>
Date:   Tue, 20 Jul 2021 07:52:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210720083805.3030730-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/20/21 2:38 AM, Yang Yingliang wrote:
> I got memory leak report when doing fuzz test:
> 
> BUG: memory leak
> unreferenced object 0xffff888107310a80 (size 96):
> comm "syz-executor.6", pid 4610, jiffies 4295140240 (age 20.135s)
> hex dump (first 32 bytes):
> 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> 00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00 .....N..........
> backtrace:
> [<000000001974933b>] kmalloc include/linux/slab.h:591 [inline]
> [<000000001974933b>] kzalloc include/linux/slab.h:721 [inline]
> [<000000001974933b>] io_init_wq_offload fs/io_uring.c:7920 [inline]
> [<000000001974933b>] io_uring_alloc_task_context+0x466/0x640 fs/io_uring.c:7955
> [<0000000039d0800d>] __io_uring_add_tctx_node+0x256/0x360 fs/io_uring.c:9016
> [<000000008482e78c>] io_uring_add_tctx_node fs/io_uring.c:9052 [inline]
> [<000000008482e78c>] __do_sys_io_uring_enter fs/io_uring.c:9354 [inline]
> [<000000008482e78c>] __se_sys_io_uring_enter fs/io_uring.c:9301 [inline]
> [<000000008482e78c>] __x64_sys_io_uring_enter+0xabc/0xc20 fs/io_uring.c:9301
> [<00000000b875f18f>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> [<00000000b875f18f>] do_syscall_64+0x3b/0x90 arch/x86/entry/common.c:80
> [<000000006b0a8484>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> CPU0                          CPU1
> io_uring_enter                io_uring_enter
> io_uring_add_tctx_node        io_uring_add_tctx_node
> __io_uring_add_tctx_node      __io_uring_add_tctx_node
> io_uring_alloc_task_context   io_uring_alloc_task_context
> io_init_wq_offload            io_init_wq_offload
> hash = kzalloc                hash = kzalloc
> ctx->hash_map = hash          ctx->hash_map = hash <- one of the hash is leaked
> 
> When calling io_uring_enter() in parallel, the 'hash_map' will be leaked, 
> add uring_lock to protect 'hash_map'.

Good catch! Applied, thanks.

-- 
Jens Axboe

