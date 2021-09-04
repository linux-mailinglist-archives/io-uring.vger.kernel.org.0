Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E705400B77
	for <lists+io-uring@lfdr.de>; Sat,  4 Sep 2021 15:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhIDNUW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Sep 2021 09:20:22 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:48118 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236645AbhIDNTQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Sep 2021 09:19:16 -0400
Received: by mail-il1-f197.google.com with SMTP id j17-20020a926e11000000b0022487646515so1231253ilc.14
        for <io-uring@vger.kernel.org>; Sat, 04 Sep 2021 06:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DTcitzNwwwfDLGiph5ugAcsPhJeXuriZRhOl1FDOjE4=;
        b=Hb1AsMLNJHfFDtq3xV/xxooSa+8W/7bBnXkzKoK6RODEJoMNU2Pto5MMhJSvxV1Jhg
         zWlifcdO7+O2jNsHAZN3/kH2Xu2/23d88awjYPqO9YJRuY6zLaUciuYDJOOPlzCy+eTg
         UlnrKjdb1AV4cvMjjyvR6nfMbD05ivBQydPYOFVDNN5HpK6G3XzTW5ipyAFXp1wUbEMn
         BTDPqYKktsYHlIxNnnzHLtzU4j2fR2gD649a/SWCysYd394GzPS8ckryFyC+oJg/eBDL
         5WbZWABnumE7iOK7/obX3RWkJnTJPOKmP/ipb00G7eimKlg8opzg3cqOuMDfj9vP5IZy
         nR1Q==
X-Gm-Message-State: AOAM532YSJCORDiTsyCwze5oQurPmQgWAhYzKt8d7coB47p8RrwMsl83
        /6EgHMuPeiCpmp/Fr3+mlqMxk/ChgLkzdjqufGhV6hdZreEX
X-Google-Smtp-Source: ABdhPJzzAYnXS6olwz1ENWgZc/oP4zhdHKTMsi9FQ/GneXxD1w35pB5VnWastbwjB53pyB+tq6s4U7H/8D++e7bR3Kd0e2tkGr8k
MIME-Version: 1.0
X-Received: by 2002:a92:c848:: with SMTP id b8mr2569244ilq.54.1630761494367;
 Sat, 04 Sep 2021 06:18:14 -0700 (PDT)
Date:   Sat, 04 Sep 2021 06:18:14 -0700
In-Reply-To: <00000000000010f70d05cb1d2407@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000095d18505cb2b3fd5@google.com>
Subject: Re: [syzbot] general protection fault in __io_arm_poll_handler
From:   syzbot <syzbot+ba74b85fa15fd7a96437@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, dhowells@redhat.com,
        dvyukov@google.com, gregkh@linuxfoundation.org,
        io-uring@vger.kernel.org, jlayton@redhat.com,
        linux-cachefs@redhat.com, linux-kernel@vger.kernel.org,
        rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has bisected this issue to:

commit 884a76881fc5f5c9c04de1b640bed2c340929842
Author: David Howells <dhowells@redhat.com>
Date:   Mon Feb 10 10:00:22 2020 +0000

    fscache: Procfile to display cookies

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114e665d300000
start commit:   a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=134e665d300000
console output: https://syzkaller.appspot.com/x/log.txt?x=154e665d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c84ed2c3f57ace
dashboard link: https://syzkaller.appspot.com/bug?extid=ba74b85fa15fd7a96437
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137a45a3300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105ba169300000

Reported-by: syzbot+ba74b85fa15fd7a96437@syzkaller.appspotmail.com
Fixes: 884a76881fc5 ("fscache: Procfile to display cookies")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
