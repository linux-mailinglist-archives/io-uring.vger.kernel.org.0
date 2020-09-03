Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CAF25C742
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 18:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgICQnh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 12:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728780AbgICQnf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 12:43:35 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B4CC061244
        for <io-uring@vger.kernel.org>; Thu,  3 Sep 2020 09:43:35 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g14so3674123iom.0
        for <io-uring@vger.kernel.org>; Thu, 03 Sep 2020 09:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=eHkxiuk1eSm1DePy7YCsS54Z9TU/8bBeG5Oe2ljkq7Y=;
        b=FNoXoEQUsIGmKdirDIyIBrPfQP2wgWg1cVLcNLAiVqHCfrTDP3ItcQFySMk5RjhWM/
         /l6R126vUtILPRQesX/lurW+hA8HqodCLtnvRsW21xlnMeeIRD+8wXHzDcQgP+v5Rhcp
         xvJ+t65aaeumRtWuAeAnavcY+ip67+jHciSTijtOWjzmn8VcPJKDTIiLWvMki6ckfBFZ
         wYpO7gdQKNIe69RIUfwaky3oV32mqjm3QVrwMh9nRyymASrtAxDywMbh5M08TgHDMvkG
         IY1alpeoELbc5vmd5TMQlPbP603as/I79FsvFD1CpUsRi+yAzIA0i89Clym5Mx0SuSY7
         Syhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eHkxiuk1eSm1DePy7YCsS54Z9TU/8bBeG5Oe2ljkq7Y=;
        b=JUXn1pYMqsP3o3gKiGLDcMXVnOAXj6tJOffV1WB230iVvYfsUTyEw9m50gGZo+7WMs
         aYF6IzLBdgK09CZ/dVvX7caqLpTSAnKyys8UnH31/r204UIx6WCY+4sVa+30lKCxDT1r
         rdKpkXHM34Rg1NtGnF3OxqOG4lGfeVzDdv8+EqZqWUUP0jfOHGXpKIY0fp+nqRN4FLjd
         jaXxTQqd4+P/v7f7IkbxZsVj3J57MIi/cGKZkvDiBKLWIUKOOdfIo5ouTsN5Swu7Boqz
         S4F4mXaEWNWBxOYtISe3N6B1mOgIsdKOClS71CwuqWRUXQx/UedRpBDp6rWCK0FzggJw
         SE3w==
X-Gm-Message-State: AOAM531N5PxiANNsniH2LgubSjxf4y+ZW8VOvqxZJz6AtTn5YXE5tbp+
        oO7masVe6650Kdw1nCZlMz/M+Q==
X-Google-Smtp-Source: ABdhPJz1yx++v0gHT7j6NwFr744737j20etIRTYuc5PbNzrbNVzAPFSHvc6bMtQwSLgZXe9aZTma9A==
X-Received: by 2002:a05:6638:611:: with SMTP id g17mr4115533jar.40.1599151415003;
        Thu, 03 Sep 2020 09:43:35 -0700 (PDT)
Received: from [192.168.1.117] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p18sm1417264iog.1.2020.09.03.09.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 09:43:34 -0700 (PDT)
Subject: Re: INFO: task can't die in io_uring_setup
To:     syzbot <syzbot+3227d097b95b4207b570@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, keescook@chromium.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgarzare@redhat.com, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <0000000000003d90ba05ae6b3d5f@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ebe53b3d-5bc6-5092-be03-f49bf49fa7df@kernel.dk>
Date:   Thu, 3 Sep 2020 10:43:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000003d90ba05ae6b3d5f@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/20 10:28 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4442749a Add linux-next specific files for 20200902
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=138e7285900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=39134fcec6c78e33
> dashboard link: https://syzkaller.appspot.com/bug?extid=3227d097b95b4207b570
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15306279900000
> 
> The issue was bisected to:
> 
> commit dfe127799f8e663c7e3e48b5275ca538b278177b
> Author: Stefano Garzarella <sgarzare@redhat.com>
> Date:   Thu Aug 27 14:58:31 2020 +0000
> 
>     io_uring: allow disabling rings during the creation
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15b09115900000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=17b09115900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13b09115900000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3227d097b95b4207b570@syzkaller.appspotmail.com
> Fixes: dfe127799f8e ("io_uring: allow disabling rings during the creation")
> 
> INFO: task syz-executor.0:28543 can't die for more than 143 seconds.
> task:syz-executor.0  state:D stack:28824 pid:28543 ppid:  6864 flags:0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:3777 [inline]
>  __schedule+0xea9/0x2230 kernel/sched/core.c:4526
>  schedule+0xd0/0x2a0 kernel/sched/core.c:4601
>  schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
>  io_sq_thread_stop fs/io_uring.c:6906 [inline]
>  io_finish_async fs/io_uring.c:6920 [inline]
>  io_sq_offload_create fs/io_uring.c:7595 [inline]
>  io_uring_create fs/io_uring.c:8671 [inline]
>  io_uring_setup+0x1495/0x29a0 fs/io_uring.c:8744
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9

This very much looks like a dupe of the issue that Hillf already
fixed, but as there's no C reproducer yet, I can't verify.

-- 
Jens Axboe

