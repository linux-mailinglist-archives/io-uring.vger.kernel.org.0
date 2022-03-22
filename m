Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063D34E49B4
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 00:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240561AbiCVXkF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 19:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241009AbiCVXif (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 19:38:35 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA076E29C
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 16:37:07 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id m3-20020a056e02158300b002b6e3d1f97cso9997209ilu.19
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 16:37:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=nxTGya4rQb08tK4gHJKHSTw3wZe8r7lubNldP0E5UM0=;
        b=dSoIlnjBeO8ssPLj/G/DSbsRNPdBuyN/SYX70izozZSXCXi19PsWhN200llabGlXg+
         QwaNxqN4DtJQRaZ+lnhVuygSrK8J3h0J54f5oDpyluFYz0sAFBIb0XkHMRUrQclg0KWO
         re3O0ZVeENFgyMVuUceIJXkBbFHjohtoz+y9CnMqGtASnOl29H0q7d6WUjDAZ10xxLdZ
         SNEq/Tc2NfGEfJZ1TDyls/AHbLHAp1n8ZEsnvuKbka0xDppD86df3oAfsK7D+R0p3ivV
         JQq/7zXzHYqibtyQ8KzuElGfVgEDul2LoVGkusadxtrAPCcWscppd2Uf+dS/WHh4JBs7
         DzPg==
X-Gm-Message-State: AOAM530FHcBBx2ZvNsLCyeFKtslW5K4bAQ9zoh8EMykZD5q1QHgb+ScH
        fZch7mZwfUbgbNIc83RiakdZGS2Q5oRvYzFDgdaavLe1gy71
X-Google-Smtp-Source: ABdhPJxkBIOSGWs6S8nhxejuf9nHwhVtj7JyAqCDEH/z3FhT2iqZsZ6dhC1IxoNid3/SYYBBE6W47SN+xfAXn5CzD4+KmXXPCsmG
MIME-Version: 1.0
X-Received: by 2002:a92:6012:0:b0:2bd:fb5f:d627 with SMTP id
 u18-20020a926012000000b002bdfb5fd627mr13275273ilb.86.1647992226627; Tue, 22
 Mar 2022 16:37:06 -0700 (PDT)
Date:   Tue, 22 Mar 2022 16:37:06 -0700
In-Reply-To: <00000000000012e22c05dacabb11@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000042c81b05dad717e6@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in add_wait_queue
From:   syzbot <syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk,
        gregkh@linuxfoundation.org, io-uring@vger.kernel.org,
        jirislaby@kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
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

syzbot has bisected this issue to:

commit 91eac1c69c202d9dad8bf717ae5b92db70bfe5cf
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Mar 16 22:59:10 2022 +0000

    io_uring: cache poll/double-poll state with a request flag

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1280c825700000
start commit:   b47d5a4f6b8d Merge tag 'audit-pr-20220321' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1180c825700000
console output: https://syzkaller.appspot.com/x/log.txt?x=1680c825700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=63af44f0631a5c3a
dashboard link: https://syzkaller.appspot.com/bug?extid=950cee6d91e62329be2c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14506ddb700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139b2093700000

Reported-by: syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com
Fixes: 91eac1c69c20 ("io_uring: cache poll/double-poll state with a request flag")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
