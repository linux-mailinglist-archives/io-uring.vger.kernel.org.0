Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE813E2D7B
	for <lists+io-uring@lfdr.de>; Fri,  6 Aug 2021 17:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244153AbhHFPVb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Aug 2021 11:21:31 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:44906 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244128AbhHFPVa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Aug 2021 11:21:30 -0400
Received: by mail-il1-f199.google.com with SMTP id m12-20020a056e021c2cb029022262095ea1so4753569ilh.11
        for <io-uring@vger.kernel.org>; Fri, 06 Aug 2021 08:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=tu7Kevvl3zuTnuTFnD3tZ2U7expM8FEkIre095hhtro=;
        b=UAW8t3VIDeGSkjdw9cLRNKfCSq8q+g4zyFDqF7/+MLz1uaN0F/V/X7eNLVNIxFCRhK
         ZwonepSnsVryhnYcuRiQabZlu8UAo7BgQkrcKvlBvz+BKrVmDL/4B+zFKpcOpgxaoRdI
         GLS+LvLODPT0SiDqDc8yucfGzdPOb+FQLOblz2Mo2CXCdw/ATD7h+41YAr9e2Swm7T9X
         YA7Vzd3L9SX1eAinysxLyibLddbFxDVjfA93U8+5OciQKQrweBLAYFOESGvQFcFBmKDg
         yT76ju2kdhNXfBN5jt656rKb9dINKYWedgb7mR8QIPSEHZykTfVVj5e/yCKumW0Y56F8
         n1Pw==
X-Gm-Message-State: AOAM531s2r9BUlhtfd5zyc3rso89oDxASqjUhXMbL/g09OtGX/21BIYf
        uI10EInlsWC8NfgAq9i0mJ4soMXrj6/qm1UCCa3qwUIyze5x
X-Google-Smtp-Source: ABdhPJzRyaRqX3bqJM1PUFwXIk5cTd4rpXA8+uJtjupvW4ZoQyD7Kk3vsUjzUlKGyNdoAvTiT+iOT7Cnjbsxim5TH68BMhXjdPlN
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2f09:: with SMTP id q9mr1312428iow.196.1628263274697;
 Fri, 06 Aug 2021 08:21:14 -0700 (PDT)
Date:   Fri, 06 Aug 2021 08:21:14 -0700
In-Reply-To: <0000000000005225a605bd97fa64@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000016db0205c8e5967e@google.com>
Subject: Re: [syzbot] WARNING in io_ring_exit_work
From:   syzbot <syzbot+00e15cda746c5bc70e24@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk,
        gregkh@linuxfoundation.org, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has bisected this issue to:

commit 6c2450ae55656f6b0370bfd4cb52ec8a4ecd0916
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Tue Feb 23 12:40:22 2021 +0000

    io_uring: allocate memory for overflowed CQEs

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=138a96e6300000
start commit:   8d4b477da1a8 Add linux-next specific files for 20210730
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=104a96e6300000
console output: https://syzkaller.appspot.com/x/log.txt?x=178a96e6300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4adf4987f875c210
dashboard link: https://syzkaller.appspot.com/bug?extid=00e15cda746c5bc70e24
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d5cd96300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1798471e300000

Reported-by: syzbot+00e15cda746c5bc70e24@syzkaller.appspotmail.com
Fixes: 6c2450ae5565 ("io_uring: allocate memory for overflowed CQEs")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
