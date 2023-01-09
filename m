Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26DD662E19
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 19:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjAISGc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 13:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237502AbjAIR6o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 12:58:44 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA77E3D9F7
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 09:56:18 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id s22-20020a6bdc16000000b006e2d7c78010so5381695ioc.21
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 09:56:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ppmVtulyeyyJUenOxxEN7joUogVk28fABWLQtu+Zrk=;
        b=P8SGWlOFGvX344/wj5BAjokIrYAUg2vuYAplNCFC/zNDGX3Fw1JaqY+1xdy2XTGxZm
         AJebTdMZlDR73Q4yNexRoBOfWxZ2RwVCFAID1lhE0ZEYvrWuvK4fgOmKAaJkWqssjiD6
         RJWAkrpbfVVdDrHHd5YUfHrd0q5tW4QSx9b8/kUPjXHd8Ma7rLChCo5JhAjMQge0lX+Y
         q2uwzfP0/MeA7XOexqxBVfyCZosSNTyNfVH0A/TZPO2+Hu+PO51skJVuXCrl+upq0Ud2
         lzyzeVc0dhvMVBF0si3amzEPdnTco3mVjaYcQG4cafTCyCOeu+3q3tV2aJljdvRLH4bl
         CXBQ==
X-Gm-Message-State: AFqh2kp5GfSwUtyr8AZkA9KJwf2Nelmg/x4C2f1DVa9Uk1QXPTICWMUu
        aoV8rO+yql/25d2lBBrZTQbykSZ1qn7wSYAwWy3qOK/aa1ij
X-Google-Smtp-Source: AMrXdXuYn5bcOBvwGt+nMca2O36qYU0o+TCzNmgGZL6gmSSi0E53OgM5oym9IOF7D3MqME8LX2I4TvnlzFCiQxD1N4jO3YQ7Yu+Y
MIME-Version: 1.0
X-Received: by 2002:a02:a513:0:b0:38a:1e93:c32f with SMTP id
 e19-20020a02a513000000b0038a1e93c32fmr4554759jam.212.1673286978314; Mon, 09
 Jan 2023 09:56:18 -0800 (PST)
Date:   Mon, 09 Jan 2023 09:56:18 -0800
In-Reply-To: <000000000000f0fb6005f1cfc17f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f328e405f1d87b38@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_wq_worker_wake
From:   syzbot <syzbot+b3ba2408ce0c74bb9230@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has bisected this issue to:

commit af82425c6a2d2f347c79b63ce74fca6dc6be157f
Author: Jens Axboe <axboe@kernel.dk>
Date:   Mon Jan 2 23:49:46 2023 +0000

    io_uring/io-wq: free worker if task_work creation is canceled

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12cda5d2480000
start commit:   1fe4fd6f5cad Merge tag 'xfs-6.2-fixes-2' of git://git.kern..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11cda5d2480000
console output: https://syzkaller.appspot.com/x/log.txt?x=16cda5d2480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b79b14037065d92
dashboard link: https://syzkaller.appspot.com/bug?extid=b3ba2408ce0c74bb9230
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1388e5f2480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127f1aa4480000

Reported-by: syzbot+b3ba2408ce0c74bb9230@syzkaller.appspotmail.com
Fixes: af82425c6a2d ("io_uring/io-wq: free worker if task_work creation is canceled")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
