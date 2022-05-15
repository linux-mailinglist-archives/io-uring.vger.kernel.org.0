Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2EA5278EF
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 19:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235834AbiEORmQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 13:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbiEORmP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 13:42:15 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF0B6269
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 10:42:14 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id ay38-20020a5d9da6000000b0065adc1f932bso8958099iob.11
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 10:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FLJhACA2WCCPpt63FKh/N0iBuVYXMyOOU24UofBXW/4=;
        b=qZv3yA/qCwBLNsE36xz/lWSBS0RTu1TiMt/cLmqkqdVJeeIEyxBP6Qwk1+s0jEavJo
         Mp72gVUKuOBA+gcVZIIiDffVnp0mE6dtfRjc7u/LB6vqgY2N8RM91saGgJBY5fGbeRAh
         YMFvLcrPkA64M/7EZ6FPF9AgRkmy16GhCMCotiMsqRD2TvoiyIgf13iQg6HBk3WPe76I
         2sWgi+J2QMWNgPT6aQ58uLESMMHhcXZj1SguFYSEh0bG9FRgZX7lHbAGDQ/WBcUjA46b
         9UxG7bFh/bIPwPkqNoWq0uhni9CQVEjHDhxgjUTUi0FSn0+USm59wY9v8XEHNnZv3DQW
         m/Qw==
X-Gm-Message-State: AOAM532B9xgRrMxeVwTnvjTX/v5t7j/0l/AwxijqIKgFlzkx4su7fGih
        2J875X6sIR/yi9MdIWEqrk3Tat1OzWXM6BKb+bDu00jDxaXM
X-Google-Smtp-Source: ABdhPJzmeXSeCCucyWuyZDdwkScKpp7ELoVA01UVPHfwLT6FwozWYBNRXRE3gA+sDPySsQEI8U8mFI/WEIhU1AEKSBgke8SGbY4t
MIME-Version: 1.0
X-Received: by 2002:a05:6638:25d3:b0:32b:7413:a64f with SMTP id
 u19-20020a05663825d300b0032b7413a64fmr7491272jat.268.1652636533601; Sun, 15
 May 2022 10:42:13 -0700 (PDT)
Date:   Sun, 15 May 2022 10:42:13 -0700
In-Reply-To: <de26ea1c-c263-0418-ba79-e9dfa85a3abd@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000873bb305df106d47@google.com>
Subject: Re: [syzbot] WARNING: still has locks held in io_ring_submit_lock
From:   syzbot <syzbot+987d7bb19195ae45208c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, f.fainelli@gmail.com,
        io-uring@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, olteanv@gmail.com,
        syzkaller-bugs@googlegroups.com, xiam0nd.tong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING: still has locks held in io_ring_submit_lock

====================================
WARNING: iou-wrk-4175/4176 still has locks held!
5.18.0-rc6-syzkaller-00294-gdf8dc7004331 #0 Not tainted
------------------------------------
1 lock held by iou-wrk-4175/4176:
 #0: ffff888019d050a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_ring_submit_lock+0x75/0xc0 fs/io_uring.c:1500

stack backtrace:
CPU: 1 PID: 4176 Comm: iou-wrk-4175 Not tainted 5.18.0-rc6-syzkaller-00294-gdf8dc7004331 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 try_to_freeze include/linux/freezer.h:66 [inline]
 get_signal+0x17bb/0x24c0 kernel/signal.c:2654
 io_wqe_worker+0x64b/0xdb0 fs/io-wq.c:663
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>


Tested on:

commit:         df8dc700 Merge branch 'for-5.19/block' into for-next
git tree:       git://git.kernel.dk/linux-block.git for-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1275d495f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7b4d7b33ae78f4c2
dashboard link: https://syzkaller.appspot.com/bug?extid=987d7bb19195ae45208c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
