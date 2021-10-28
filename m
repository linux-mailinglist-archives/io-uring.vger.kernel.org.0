Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB13F43F2D9
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 00:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhJ1Whj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 18:37:39 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:45796 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhJ1Whj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 18:37:39 -0400
Received: by mail-io1-f71.google.com with SMTP id r25-20020a5d9b99000000b005de9c9abc68so5141606iom.12
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 15:35:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=N9EOrS/2LnqMiI4SQz1TSOBHS3qpfSRUoJVqf+vmGnY=;
        b=cCvQe+KEJT6yHJq2aI0wVZ5Ljx9SSJJcdd0a+dM1Q5xEIeLvQrbC36wDOzPTyDfN7C
         UBThXKLTabiF1f2cVmCrrU6q4wyU4VVdCVi0Sonf/EXibiw9Vel2pygZjI4MYLZhx7AK
         XcdCKoMSyTPBeWOxG+riraVkkKXJng5TNVDVyGg64COq42FRxBl8vJL10yVJWU8tg3Zn
         D0wa2SQHBI8153mrQnvbkC/NNHf6CKRfNUz7puZyzSGzjYzofotDXM+gkfV6NOJtDz8U
         zk3gqo4vgwRllWZB5l8nxQVWNr1BFGZ1vnC2PgrJtNZRhZ+oIFgXyN7u001/t5PxZPQt
         tIsg==
X-Gm-Message-State: AOAM532Z1uL1vstBXANZP0ovlAVFpcNPVfOOZ/FlawhAOMT9H3hDVIPz
        6vn70dJn3f387dbQ8KR863mrzZqGlyfMGtW71bfB6W2DcNP7
X-Google-Smtp-Source: ABdhPJxugzRMQthei9yf9E8esqe3gS+EjBvi1+X3jXhL0239BRvPkn5bKFXqDB3+O+2rxAerku6rN1vKAPslwSeTkgvKXCwhF5fI
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:8b4:: with SMTP id a20mr5132740ilt.315.1635460511478;
 Thu, 28 Oct 2021 15:35:11 -0700 (PDT)
Date:   Thu, 28 Oct 2021 15:35:11 -0700
In-Reply-To: <2b0d6d98-b6f6-e1b1-1ea8-3126f41ec0ce@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d4b82205cf71522e@google.com>
Subject: Re: [syzbot] INFO: task hung in io_wqe_worker
From:   syzbot <syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com

Tested on:

commit:         5983fb88 io-wq: remove worker to owner dependency
git tree:       https://github.com/isilence/linux.git syz_coredump
kernel config:  https://syzkaller.appspot.com/x/.config?x=1f7f46d98a0da80e
dashboard link: https://syzkaller.appspot.com/bug?extid=27d62ee6f256b186883e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
