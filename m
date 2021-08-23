Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E0E3F42A5
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 02:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhHWAoq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Aug 2021 20:44:46 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:54268 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhHWAop (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Aug 2021 20:44:45 -0400
Received: by mail-io1-f70.google.com with SMTP id n189-20020a6b8bc6000000b005b92c64b625so7532364iod.20
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 17:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Uwxvn5atNhE0NIH/RYoJlbaLRjbzmMnZlC4pPIKHaCg=;
        b=r+EIsFF3RekNwHFc8GlgD26nd9w2gnWIAhANEnNVccgYGcAloAD/IDFKokC1q1BoqT
         ZiB0JpdweB2vqMooMXd2KH7IC7NmXzu1xsCysYg4wiV+sR0mWBIk/DmePCzAyGGwtBqW
         FiLfRY/o+L3cdUS9JnfL53GSF0IOoxxnk9pRj2wT2Sr4yNO2PFRPbfACqOP0dBGpzqVu
         iTLhOYxpQHl9vFTzmk8Otv+r3DKVJSC/UAHvYIUTUwvsYdizau+ZnkqFDMDZNco9WOrC
         t8OrzcSd7VKVNR3z1OVBc51pwDHbswXo93ZbRPYPZ1pwC6iOAiUPvxHk8QNnh9ussUX3
         anrg==
X-Gm-Message-State: AOAM531MHrO/t2LYUjGaoGv71ZXVDS3wvV9LYsfR3w2v1WrnTIP/JdRg
        sedTY9HL0LqdDV+s8O1VAiR5nRrdWKt0L0kzDdfTAqnVnXEQ
X-Google-Smtp-Source: ABdhPJzRzRs/Duz0wgM23JTziNfzEd6x9/41lSnGWLMkUw4RlM/yKekx0NVzSt7Y6yEF9dPTYoeP0ODdMtKxgxe5AaTww1CkJUtS
MIME-Version: 1.0
X-Received: by 2002:a02:2a88:: with SMTP id w130mr27207095jaw.60.1629679443921;
 Sun, 22 Aug 2021 17:44:03 -0700 (PDT)
Date:   Sun, 22 Aug 2021 17:44:03 -0700
In-Reply-To: <6e5f874d-ac61-9556-8d7e-575ec7d9682a@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005a4e8105ca2f509c@google.com>
Subject: Re: [syzbot] KASAN: stack-out-of-bounds Read in iov_iter_revert
From:   syzbot <syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com

Tested on:

commit:         b917c794 io_uring: fix revert truncated vecs
git tree:       https://github.com/isilence/linux.git syztest_trunc2
kernel config:  https://syzkaller.appspot.com/x/.config?x=4aa932b5eaeee9ef
dashboard link: https://syzkaller.appspot.com/bug?extid=9671693590ef5aad8953
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
