Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2927453DC1D
	for <lists+io-uring@lfdr.de>; Sun,  5 Jun 2022 16:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244504AbiFEOEO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jun 2022 10:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240521AbiFEOEN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jun 2022 10:04:13 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7CBD13C
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 07:04:11 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id c1-20020a928e01000000b002d1b20aa761so10088755ild.6
        for <io-uring@vger.kernel.org>; Sun, 05 Jun 2022 07:04:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4D4EPvBGgDbUWnPc5BEACuk6+5YNX+C0cKGERi/DBJ8=;
        b=kDfHUez49h6J2qTHsX/PtzhAaXq9Z7sntX9cbwqtOFnS1eLgLzYDxQ5gZboXO0LkWf
         6EtDiGCYXon3yded8JTn6DUssDwREyoDrtf9ZJDvOMm0Ph4dpFX6/W1q6ti75j456c9m
         rvuRoBG+KEq4DdGGRAJsWUvunnu1jGGav1ix+FvttdlEnrNSL5p9fpficEzhZ7t6yrtj
         cLTT5pyhRyMZ3OqjrD/9olDAO/SOnRoU2GXxh0fI0F/PQJh5dzZy6vpZ2AsONzH7KPpA
         Lvd1fuzUxgjEL3L4rjRBN7wCarTwUc6NJ6kAK1RaWw55h0K1ygJ98AFg0ky7zk3Z7/Nj
         iRhQ==
X-Gm-Message-State: AOAM5300892kB/cagPKVZc/KQ107Xj7HFDVdED87fEOYlP2DEYZ+eiB2
        UIwwitcqkjPjB+6ST6uiLFKofIw0EZPamHA94M6BawzM4xAf
X-Google-Smtp-Source: ABdhPJw5RtAjJ9sH9FoXUF1lunz8h/glEZDtAHgB703YQ4wP1RQFdYHVIOF7ajjSeAi+NBHPw38zIhXd/rAHATUj+4708B4jtkFf
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d13:b0:665:6e8b:7d84 with SMTP id
 c19-20020a0566022d1300b006656e8b7d84mr8694210iow.133.1654437850502; Sun, 05
 Jun 2022 07:04:10 -0700 (PDT)
Date:   Sun, 05 Jun 2022 07:04:10 -0700
In-Reply-To: <000000000000fd54f805e0351875@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000061dcef05e0b3d4e3@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in filp_close
From:   syzbot <syzbot+47dd250f527cb7bebf24@syzkaller.appspotmail.com>
To:     arve@android.com, asml.silence@gmail.com, axboe@kernel.dk,
        brauner@kernel.org, gregkh@linuxfoundation.org, hdanton@sina.com,
        hridya@google.com, io-uring@vger.kernel.org,
        joel@joelfernandes.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, maco@android.com, surenb@google.com,
        syzkaller-bugs@googlegroups.com, tkjos@android.com,
        viro@zeniv.linux.org.uk
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

commit 6319194ec57b0452dcda4589d24c4e7db299c5bf
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu May 12 21:08:03 2022 +0000

    Unify the primitives for file descriptor closing

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=134cbe4ff00000
start commit:   952923ddc011 Merge tag 'pull-18-rc1-work.namei' of git://g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10ccbe4ff00000
console output: https://syzkaller.appspot.com/x/log.txt?x=174cbe4ff00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3096247591885bfa
dashboard link: https://syzkaller.appspot.com/bug?extid=47dd250f527cb7bebf24
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114f7bcdf00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1659a94ff00000

Reported-by: syzbot+47dd250f527cb7bebf24@syzkaller.appspotmail.com
Fixes: 6319194ec57b ("Unify the primitives for file descriptor closing")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
