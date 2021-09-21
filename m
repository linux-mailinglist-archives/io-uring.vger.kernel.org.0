Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF151413401
	for <lists+io-uring@lfdr.de>; Tue, 21 Sep 2021 15:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhIUN0t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Sep 2021 09:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbhIUN0s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Sep 2021 09:26:48 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4249C061574
        for <io-uring@vger.kernel.org>; Tue, 21 Sep 2021 06:25:20 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id a15so26857192iot.2
        for <io-uring@vger.kernel.org>; Tue, 21 Sep 2021 06:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cwmswst5kJrAM2nn0VJL/xiETxBOzg10iSbgL/hoHx4=;
        b=BCW/vHyUj3DI5Wh+s6/fHAoB58Wsd8XH53tlmUwNgVW6+5m++vca7WpI59nEG8BjAA
         WtAyimp8JHXrV81uFFBiJLLkbrTAxt/+sqWNsCinWqjRN1T9DaFrvP2EvmgnVC53EdWa
         KgTSMbGZ6Ui+whXuiGSnfhYDywVzKjayv4+H0xmE378TXVdBWkK3gDvr6ar7qIVpNO6k
         VzOozL78PE10YtmcjLZeJjy9Slxgf1erkYBwVzvRB8ux0Jgett9hj81Hbnxq5DOEv/4K
         Pc3hu9UV/5WIArwFhUAYcSADUxxUB5LbQ+3lxL6ZcjKf6cXlNM9Su18jPiwtDwkS7GIi
         pAdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cwmswst5kJrAM2nn0VJL/xiETxBOzg10iSbgL/hoHx4=;
        b=uKlQDrcrF8MyVPDq3Rbaz/kCEtiALvTcAAEjYHxaiOONKclySLC0EW+zmxc/AJtlTn
         F/YLpFDl32Pp5MDln1dtEu6AshWdiCQU6kxhYBqsCW0TUKyPoNLCtQ+UXEhfg9EPgU/d
         rFQ+VfMnP6H2tVWjSZJ6Ky1nl40zVJdoidG87djQhaNmyRZjioENjC4Dl7Y74mvTTBqs
         o249ganpuPCdyM3nfH83g4zMdej70dRrsarCSfTz0nn+j8if1kOXZYM1jrnTtA6AmLml
         CUPQ/DuXK6etyBDVJKHORU4Fb4sfZx9EENja+XKrNmk0KlnHGC9zSf62BespgeS7G9xr
         SMTQ==
X-Gm-Message-State: AOAM530mWt9Brw3Wi+JI2lei5ds0J8v+d+IUJL9UtAyAgca56IFULl+w
        UQe/GA+IwubPYAJuYFDdfKTSjrAInxlc3AUi8Rg=
X-Google-Smtp-Source: ABdhPJwUpjmu74tGL/pQCBaZYX+IaiZEVY3COYFdS+OU7bz1alDHtneqxHFLl0YYQuSlOHkysY/epw==
X-Received: by 2002:a05:6602:2243:: with SMTP id o3mr13598017ioo.10.1632230719881;
        Tue, 21 Sep 2021 06:25:19 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z4sm10098188ioj.45.2021.09.21.06.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 06:25:19 -0700 (PDT)
Subject: Re: [5.15-rc1 regression] io_uring: fsstress hangs in do_coredump()
 on exit
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20210921064032.GW2361455@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d9d2255c-fbac-3259-243a-2934b7ed0293@kernel.dk>
Date:   Tue, 21 Sep 2021 07:25:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210921064032.GW2361455@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/21/21 12:40 AM, Dave Chinner wrote:
> Hi Jens,
> 
> I updated all my trees from 5.14 to 5.15-rc2 this morning and
> immediately had problems running the recoveryloop fstest group on
> them. These tests have a typical pattern of "run load in the
> background, shutdown the filesystem, kill load, unmount and test
> recovery".
> 
> Whent eh load includes fsstress, and it gets killed after shutdown,
> it hangs on exit like so:
> 
> # echo w > /proc/sysrq-trigger 
> [  370.669482] sysrq: Show Blocked State
> [  370.671732] task:fsstress        state:D stack:11088 pid: 9619 ppid:  9615 flags:0x00000000
> [  370.675870] Call Trace:
> [  370.677067]  __schedule+0x310/0x9f0
> [  370.678564]  schedule+0x67/0xe0
> [  370.679545]  schedule_timeout+0x114/0x160
> [  370.682002]  __wait_for_common+0xc0/0x160
> [  370.684274]  wait_for_completion+0x24/0x30
> [  370.685471]  do_coredump+0x202/0x1150
> [  370.690270]  get_signal+0x4c2/0x900
> [  370.691305]  arch_do_signal_or_restart+0x106/0x7a0
> [  370.693888]  exit_to_user_mode_prepare+0xfb/0x1d0
> [  370.695241]  syscall_exit_to_user_mode+0x17/0x40
> [  370.696572]  do_syscall_64+0x42/0x80
> [  370.697620]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> It's 100% reproducable on one of my test machines, but only one of
> them. That one machine is running fstests on pmem, so it has
> synchronous storage. Every other test machine using normal async
> storage (nvme, iscsi, etc) and none of them are hanging.
> 
> A quick troll of the commit history between 5.14 and 5.15-rc2
> indicates a couple of potential candidates. The 5th kernel build
> (instead of ~16 for a bisect) told me that commit 15e20db2e0ce
> ("io-wq: only exit on fatal signals") is the cause of the
> regression. I've confirmed that this is the first commit where the
> problem shows up.

Thanks for the report Dave, I'll take a look. Can you elaborate on
exactly what is being run? And when killed, it's a non-fatal signal?

-- 
Jens Axboe

