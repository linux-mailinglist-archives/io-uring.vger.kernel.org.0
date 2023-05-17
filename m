Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64F67067DD
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 14:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjEQMTg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 08:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjEQMTg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 08:19:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D86D9;
        Wed, 17 May 2023 05:19:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC0C263BAB;
        Wed, 17 May 2023 12:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FE9C433D2;
        Wed, 17 May 2023 12:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1684325974;
        bh=mItlZnYtrwGQ9B8PLNTsZ5u2ZdPyslqk4le+U6TLCsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z4+2ExgiCJt5044cWrMwQQsXW2eDTh0Ti8sd49biAvjSM4bH92sUS1JnPOKFHKumQ
         rjZwbRnGUt7lrR3WmnJ2nb901P8nQry2MBYd5ET1NAAdCQM57yDUrC2Ctx6sVTJT8l
         Uzi62R6MRXEI4IM0nvLZ0MG45eqXh9BKg8ASJdvo=
Date:   Wed, 17 May 2023 14:19:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yang lan <lanyang0908@gmail.com>
Cc:     axboe@kernel.dk, sashal@kernel.org, asml.silence@gmail.com,
        dylany@fb.com, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [Bug report] kernel panic: System is deadlocked on memory
Message-ID: <2023051752-strategy-aorta-cf01@gregkh>
References: <CAAehj2kcgtRta0ou6KQiyz33O4hf+_7jgndzV_neyQRj5BjSJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAehj2kcgtRta0ou6KQiyz33O4hf+_7jgndzV_neyQRj5BjSJQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 17, 2023 at 08:02:38PM +0800, yang lan wrote:
> Hi,
> 
> We use our modified Syzkaller to fuzz the Linux kernel and found the
> following issue:
> 
> Head Commit: f1b32fda06d2cfb8eea9680b0ba7a8b0d5b81eeb
> Git Tree: stable
> 
> Console output: https://pastebin.com/raw/Ssz6eVA6
> Kernel config: https://pastebin.com/raw/BiggLxRg
> C reproducer: https://pastebin.com/raw/tM1iyfjr
> Syz reproducer: https://pastebin.com/raw/CEF1R2jg
> 
> root@syzkaller:~# uname -a
> Linux syzkaller 5.10.179 #5 SMP PREEMPT Mon May 1 23:59:32 CST 2023

Does this also happen on 6.4-rc2?


> x86_64 GNU/Linux
> root@syzkaller:~# gcc poc_io_uring_enter.c -o poc_io_uring_enter
> root@syzkaller:~# ./poc_io_uring_enter
> ...
> [  244.945440][ T3106]
> oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0-1,global_oom,task_memcg=/,task=dhclient,pid=4526,uid=0
> [  244.946537][ T3106] Out of memory: Killed process 4526 (dhclient)

Is this using fault injection, or a normal operation?

thanks,

greg k-h
