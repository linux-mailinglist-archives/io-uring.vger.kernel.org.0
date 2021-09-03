Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0ED140080E
	for <lists+io-uring@lfdr.de>; Sat,  4 Sep 2021 01:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349849AbhICXJ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 19:09:29 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:35496 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245474AbhICXJK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 19:09:10 -0400
Received: by mail-il1-f198.google.com with SMTP id x3-20020a92de03000000b0022458d4e768so450258ilm.2
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 16:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=N5d093UwZv3h4qJ5IEJdxCx1t3C+wte7ngv0XxPDuyU=;
        b=VJei+y4UuXQIP66eLVBv9Yl2ZRNllprAziltIaRPAPkcBSsfdY0THmD3oCmuZp+O+w
         0AYiaAZPr3li7nIC54j40uXwnNDtvR1EW0hsXR06aH3Hd/Y2pWvwNRGRTY433dXAHA3r
         nUaAPgLlJD8onV50sfdnOgtkkAcP4nLlUm4vNiQj92QuQVYonMPpMvRR/T2O/M5apLHS
         T9PFEzigHgGvra52UQ1GJL2i8LIXGoouBBSKxxL6rfRXVj9bbXk0ukJb8y8tyzjrIgQs
         jsT6C8dT4gx7dV6IXgVNxQ4Lda9urXezqHBHVbKmeHGp6YWh4aw5H0dnCpOtd0ENA+RD
         0mmQ==
X-Gm-Message-State: AOAM530+GnGpH7ood0ME8YUUOzL/pz0Jy4eMjbZNKyztghWUmk/Ei2wD
        OO4l7/J60jMYoszjh5oSY3mZ2AFX6qQG7rTLSZ/xnVKibM+3
X-Google-Smtp-Source: ABdhPJwc7eZ+XDxlXIWj9wtCGs/WMLS+ApAM+Q60oiBtj0cht9k5RDlrRhqVvFCAanCbKgrGN5gUcz90yu9AHhgymHP7ZUqHOJak
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:198d:: with SMTP id g13mr902366ilf.319.1630710487901;
 Fri, 03 Sep 2021 16:08:07 -0700 (PDT)
Date:   Fri, 03 Sep 2021 16:08:07 -0700
In-Reply-To: <5a93ff90-98be-b5af-29e9-a2f8cca82458@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005ceb2c05cb1f5fad@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in kiocb_done
From:   syzbot <syzbot+726f2ce6dbbf2ad8d133@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+726f2ce6dbbf2ad8d133@syzkaller.appspotmail.com

Tested on:

commit:         31efe48e io_uring: fix possible poll event lost in mul..
git tree:       git://git.kernel.dk/linux-block for-5.15/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa8e68781da309a
dashboard link: https://syzkaller.appspot.com/bug?extid=726f2ce6dbbf2ad8d133
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
