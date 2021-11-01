Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9817144200B
	for <lists+io-uring@lfdr.de>; Mon,  1 Nov 2021 19:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhKAScr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Nov 2021 14:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhKAScq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Nov 2021 14:32:46 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC5CC061714
        for <io-uring@vger.kernel.org>; Mon,  1 Nov 2021 11:30:12 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id j28so13017809ila.1
        for <io-uring@vger.kernel.org>; Mon, 01 Nov 2021 11:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/OdvGRGPu0zDVBrtV3KLjsx6ZoiLAgQ4dU32aGnds/Q=;
        b=pQAxahXBIfbwdOIYt/l59ZH82L0ST1pPCyL09hl00FzeH/EiHYLnoWeUmTP7+u+9OP
         FmyXJCT40tP63vQ1vKYAseaud6pMZGfj6IhEqZhDQdiSn2mTecmq1MN226dOtFFaGBJf
         kgOu/BNs/2dZanENMcs/KAcUgKmDj9lysRcqikWdoRufMgQ4mZgOcyapwC6B9vtrZzVu
         1r0LuTsis5xSTORf7z9vd0tcaOKW4BiiO+4rXrQsepRivuCgyVB/njT88xfNtYm0YdwT
         AC0YoApL2W7X84spkh/R30RrR8oXYgq/8MjnBbN/vakcuSQG6caY/vI51wBH8Qh9Ra0s
         CYRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/OdvGRGPu0zDVBrtV3KLjsx6ZoiLAgQ4dU32aGnds/Q=;
        b=RdVkWPqYrYa3ey4xHyC3+ZDrvJOCRK6Ni4y8e/hwuMtLKT1qjs8YgY2L6JJP3mnlWX
         Znee8rhu8bdyRmmdP/vTzucCEZJGzNYbgV2Z9PJjdFDCNtC3S+bPmAdZ+2022HoAbjqk
         ky3IMplfAHTa+OkdBg63DnBvYn0vPYXp5Qml9hg37IjTjkDI0177Nf151L1GWStpuY+Y
         7VhRh8VCv80wJqBuCJ0bkQQ35QU1reVik9RXAgZlsIrNtn3iuxSsF2kAX1VBLKGzJQsg
         mHZz1XrgFQPr5fSz2hY4TlsRxWJY2fELxnxGPUBPGKUCfLUQgTD33C7RX3Vc7798tqZR
         sYlw==
X-Gm-Message-State: AOAM532M+ws4XI1iMhoyr44vyJxe5Twbpel7oDs8ag1mT4QqA6rgX9/4
        SNbRfbOzFRpYvA+S7fWkcHnl3Hvy/xxUzA==
X-Google-Smtp-Source: ABdhPJzm/F7/ygI9I4QcM9qe4P/bULdDiNQ8WQzJYyeUU3GutDtK1TvphmEsYcNN2yF2kXMKJxjQdA==
X-Received: by 2002:a05:6e02:2143:: with SMTP id d3mr4228107ilv.241.1635791411720;
        Mon, 01 Nov 2021 11:30:11 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s3sm5657737ilv.61.2021.11.01.11.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 11:30:11 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_poll_task_func
To:     syzbot <syzbot+50a186b2a3a0139929ab@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiaoguang.wang@linux.alibaba.com
References: <000000000000e8ad6005cfbe4960@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a24e8fb9-f378-5308-8956-718c390c6c82@kernel.dk>
Date:   Mon, 1 Nov 2021 12:30:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000e8ad6005cfbe4960@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/1/21 12:24 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    bdcc9f6a5682 Add linux-next specific files for 20211029
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=142531f4b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4b504bcb4c507265
> dashboard link: https://syzkaller.appspot.com/bug?extid=50a186b2a3a0139929ab
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177a979ab00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1636cc5f300000
> 
> The issue was bisected to:
> 
> commit 34ced75ca1f63fac6148497971212583aa0f7a87
> Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> Date:   Mon Oct 25 05:38:48 2021 +0000
> 
>     io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request

#syz invalid

Please stop testing this old branch, as mentioned the patches causing this
have been dropped.

-- 
Jens Axboe

