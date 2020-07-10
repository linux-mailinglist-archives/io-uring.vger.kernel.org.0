Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAED21B71F
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 15:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgGJNvV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 09:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgGJNvU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 09:51:20 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB3DC08C5CE
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2020 06:51:20 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v8so6090101iox.2
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2020 06:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QeRVYBt393FV/Oy9pMvr9BzFrA2Q5Owg6rz86iAAWvE=;
        b=VqgkTfuUQIcolaNHige2EiKE+2/CTrpTLBXlNHkj1GNhd0yPvPs/rsMb22SsAuQ/1i
         A5kpASJycDfU0lbTd/SpKfYLz2ZLowaOGTagkeRszZroijTZWTbd7ghljYnqIfkxMO6R
         dKV11gpnG+BgwvHYPLzJw9thHUnn23e4Vqyc16b1Pt2zmV7nikEFzDlLV2iS9AyzkHSc
         OEgJtEV6eYALfaTbs4uX2+0MvJ4efqCNYyd8wAhlGIiWve6vmV6KAXm3zPf2eKs0QLL/
         NyDMjhMfLqyvb965h74p/V86AAWMQdgiJmeSZTABomzPgkPeBmz5aAbCH2BRSCPf9/nZ
         sNfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QeRVYBt393FV/Oy9pMvr9BzFrA2Q5Owg6rz86iAAWvE=;
        b=jFVLUaEHz+L8gHzaKEeYZlqpSI59Bz6bVtczQ4AUSNCQ7risiuMszlxTiG1Vw1qb9B
         /SbLv9LBY8zlje3ks7Z7EFl/HIwmVOXOQaT/CmzejuQ8N5AogeT2+gV0pvBbl1Rgiwra
         sheqr/Gm4dOWpSUMyCS54R3P9iAQmiqHSv/jnQXIwxzd2Y6h62jTb9NTHorBo54rdBsI
         BtS9u++yBklFpZRGSI1aBYt//RIFmuDDowbc+oewncb44WjnwfVmAPA0v4nZ9f5C0si6
         S6JYc5SKa+8VjLdmoAJyDDGKp4fTb2uutKXJDiOV+egySV6JZpuJuham0X8xkXZ0I5Hj
         EzXQ==
X-Gm-Message-State: AOAM5322UIEaXns35fEn9Mef9QfGc2phJUWo52IO2nA6hJLPbhrHqxad
        RHyNXdN0v6MKEjLP8zM5KH8pog==
X-Google-Smtp-Source: ABdhPJwt1qfIrP+mCXUhdLt9LSYLo0v7L6vhgNKaZKXOlsiRI441lAOnv681pvZAX3lENvsiALwJOQ==
X-Received: by 2002:a6b:8d4d:: with SMTP id p74mr440340iod.173.1594389079396;
        Fri, 10 Jul 2020 06:51:19 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c29sm3652762ilg.53.2020.07.10.06.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 06:51:18 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix memleak in io_sqe_files_register()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200710141420.3987063-1-yangyingliang@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <65c82eaf-3f95-9280-3dc4-25b9e0781213@kernel.dk>
Date:   Fri, 10 Jul 2020 07:51:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710141420.3987063-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/10/20 8:14 AM, Yang Yingliang wrote:
> I got a memleak report when doing some fuzz test:
> 
> BUG: memory leak
> unreferenced object 0x607eeac06e78 (size 8):
>   comm "test", pid 295, jiffies 4294735835 (age 31.745s)
>   hex dump (first 8 bytes):
>     00 00 00 00 00 00 00 00                          ........
>   backtrace:
>     [<00000000932632e6>] percpu_ref_init+0x2a/0x1b0
>     [<0000000092ddb796>] __io_uring_register+0x111d/0x22a0
>     [<00000000eadd6c77>] __x64_sys_io_uring_register+0x17b/0x480
>     [<00000000591b89a6>] do_syscall_64+0x56/0xa0
>     [<00000000864a281d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> 
> Call percpu_ref_exit() on error path to avoid
> refcount memleak.

Applied, thanks.

-- 
Jens Axboe

