Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E61C413535
	for <lists+io-uring@lfdr.de>; Tue, 21 Sep 2021 16:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhIUOVZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Sep 2021 10:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbhIUOVX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Sep 2021 10:21:23 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F99C061574
        for <io-uring@vger.kernel.org>; Tue, 21 Sep 2021 07:19:54 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id 134so3670171iou.12
        for <io-uring@vger.kernel.org>; Tue, 21 Sep 2021 07:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L6cMCcAIo7KH0KMFbWbMA5w3LGos7A/YhE4lv06lqTk=;
        b=cbUvQ3z/K/LWGiERkpyrzezFvqqTSNEU/GZMcgE4u1DOmL1Tc225YQUHTOFCzko3I+
         WA10vzJ4foto+NT/wTTQUrEDH/h2iso7yh30lKNVQB7GtbKYJic/iiDQQLoZawWZfzRy
         ah//EUhjHm+rzZfH+eHa6UIR4VJ94dHQoQB6Sc65xjAVNMG9sSLbxxADM/AB96+fI3Nu
         dwhpU7QYPjwmt0yMhYkimqX39pPNFgloBuGjpo5z1RoFsZgjs04TDcbGFSt0x3yuAhDE
         KqiK1NmoOA1pr0Ky6uMx5DQqlh1OBHel6Uo8OjnjC4d+0AiDS4vxsE+WeGvrcVOsfHm9
         dE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L6cMCcAIo7KH0KMFbWbMA5w3LGos7A/YhE4lv06lqTk=;
        b=2zZqVIMrvxZ3rSx7uPBNKQWg+yTXVlkq/6xwy0ITcnPpk830FyPLcOfBZZGzOe58ov
         mJVGY6Lr/Fl+UcCT+XevJMRy+h//zACN9reOu0kvV49KLNR4Dkola5OJx+BIlxQXicLj
         /htwzIy9d5OKA5x4AMdGE0ZBcIBvXIegHGey0YkERTsAgBtIzfWlS+CT5r9aCDU98ZxU
         Ke2BUKeVcXbXm9qdOqAWwzapzIF029M55tbuzTYDmiOEPjgU8q3jnz1Q5BZb4JdZmH3L
         27k5obwmfG3BNTkBt1AMPpdlIb1q3rKF5HQbSUKjR06/Uf/OEDCs5xIuqfsdi5ekXuVa
         VRxQ==
X-Gm-Message-State: AOAM531Q1qz8BwP+IBdRAR6gV2fGNiwRXgOTESXKhZ+41WD1HM3DjGOG
        QpWmwf5cEyUFjmyxtS3vjyGOXZbfTxvimofToTk=
X-Google-Smtp-Source: ABdhPJzNQMYpQ/2eh1k4bkyCOOdQbxRkfP7kD2l0yogibSLmRI6EmHCdrcW8tpHivCVs1CC6xxbCSQ==
X-Received: by 2002:a05:6638:3881:: with SMTP id b1mr162756jav.119.1632233994218;
        Tue, 21 Sep 2021 07:19:54 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f7sm3786898ilc.82.2021.09.21.07.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 07:19:53 -0700 (PDT)
Subject: Re: [5.15-rc1 regression] io_uring: fsstress hangs in do_coredump()
 on exit
From:   Jens Axboe <axboe@kernel.dk>
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20210921064032.GW2361455@dread.disaster.area>
 <d9d2255c-fbac-3259-243a-2934b7ed0293@kernel.dk>
Message-ID: <c97707cf-c543-52cd-5066-76b639f4f087@kernel.dk>
Date:   Tue, 21 Sep 2021 08:19:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d9d2255c-fbac-3259-243a-2934b7ed0293@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/21/21 7:25 AM, Jens Axboe wrote:
> On 9/21/21 12:40 AM, Dave Chinner wrote:
>> Hi Jens,
>>
>> I updated all my trees from 5.14 to 5.15-rc2 this morning and
>> immediately had problems running the recoveryloop fstest group on
>> them. These tests have a typical pattern of "run load in the
>> background, shutdown the filesystem, kill load, unmount and test
>> recovery".
>>
>> Whent eh load includes fsstress, and it gets killed after shutdown,
>> it hangs on exit like so:
>>
>> # echo w > /proc/sysrq-trigger 
>> [  370.669482] sysrq: Show Blocked State
>> [  370.671732] task:fsstress        state:D stack:11088 pid: 9619 ppid:  9615 flags:0x00000000
>> [  370.675870] Call Trace:
>> [  370.677067]  __schedule+0x310/0x9f0
>> [  370.678564]  schedule+0x67/0xe0
>> [  370.679545]  schedule_timeout+0x114/0x160
>> [  370.682002]  __wait_for_common+0xc0/0x160
>> [  370.684274]  wait_for_completion+0x24/0x30
>> [  370.685471]  do_coredump+0x202/0x1150
>> [  370.690270]  get_signal+0x4c2/0x900
>> [  370.691305]  arch_do_signal_or_restart+0x106/0x7a0
>> [  370.693888]  exit_to_user_mode_prepare+0xfb/0x1d0
>> [  370.695241]  syscall_exit_to_user_mode+0x17/0x40
>> [  370.696572]  do_syscall_64+0x42/0x80
>> [  370.697620]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> It's 100% reproducable on one of my test machines, but only one of
>> them. That one machine is running fstests on pmem, so it has
>> synchronous storage. Every other test machine using normal async
>> storage (nvme, iscsi, etc) and none of them are hanging.
>>
>> A quick troll of the commit history between 5.14 and 5.15-rc2
>> indicates a couple of potential candidates. The 5th kernel build
>> (instead of ~16 for a bisect) told me that commit 15e20db2e0ce
>> ("io-wq: only exit on fatal signals") is the cause of the
>> regression. I've confirmed that this is the first commit where the
>> problem shows up.
> 
> Thanks for the report Dave, I'll take a look. Can you elaborate on
> exactly what is being run? And when killed, it's a non-fatal signal?

Can you try with this patch?

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b5fd015268d7..1e55a0a2a217 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -586,7 +586,8 @@ static int io_wqe_worker(void *data)
 
 			if (!get_signal(&ksig))
 				continue;
-			if (fatal_signal_pending(current))
+			if (fatal_signal_pending(current) ||
+			    signal_group_exit(current->signal)) {
 				break;
 			continue;
 		}

-- 
Jens Axboe

