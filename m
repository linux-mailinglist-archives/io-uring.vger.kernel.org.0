Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B75376ED7
	for <lists+io-uring@lfdr.de>; Sat,  8 May 2021 04:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhEHCgT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 22:36:19 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:54019 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhEHCgR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 22:36:17 -0400
Received: by mail-il1-f197.google.com with SMTP id h8-20020a92c2680000b02901646ecac1e5so8671555ild.20
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 19:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=yRpfOOpyTTcZNtaZ5IFA1pZLlVZkx0zucBbPg4TfvcI=;
        b=XsrmU54SgvnV0oPH1ZZGRSU9OAg8Cgi71rd+NUa69fRRNFSBjyqC2yVg47bWxU3Ud/
         KIsWmMXywdiVP0ecVvzJBG9r7oPIwRcMTAerSU9Wp1MUuie5uNDKL/QPB4A3CbUkF3pV
         3D95ZmwkytkU0HM94uOZ6wyYcgzrpehGJuKkwdFWzgqFXc51+eCaW/datBSWkJq4auAE
         5LQl+E7IrJusnSaaR/CmIlCuwIZtpB0u5jn9mPSKoQXZLZ85UKLtNjz62hxDWJZnaOpf
         9izHTFx/i0gJoQq47hfomYkGsQgbHiWmCGD6X9BW/k9QPFcmYcTMZ2yIDQBRGJ95xaiG
         ws9g==
X-Gm-Message-State: AOAM532PQZFX+skiz1rguo4JrBi9edgjRG+U99ZEh/b1zEe/f+5likDF
        y7hkfrFaxAwnQXQkzE0maPi3SKlz6I9xkF7rC1rnNe13r8Xd
X-Google-Smtp-Source: ABdhPJzHX9c5ZG3/8fGP0JaqYE7j0K8Z0eec2LcJ8r2KtTJmomlFxyYd/fHhv36H4CjE56fnpZb8C22cwsFriCp5qltYrQjG8+au
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:685:: with SMTP id o5mr11998791ils.93.1620441315987;
 Fri, 07 May 2021 19:35:15 -0700 (PDT)
Date:   Fri, 07 May 2021 19:35:15 -0700
In-Reply-To: <c2cab9a3-b821-e4fa-3a8a-c66f15a642c3@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000004f05705c1c86547@google.com>
Subject: Re: [syzbot] INFO: task hung in __io_uring_cancel
From:   syzbot <syzbot+47fc00967b06a3019bd2@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+47fc00967b06a3019bd2@syzkaller.appspotmail.com

Tested on:

commit:         50b7b6f2 x86/process: setup io_threads more like normal us..
git tree:       git://git.kernel.dk/linux-block io_uring-5.13
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e1cf8ad694ca2e1
dashboard link: https://syzkaller.appspot.com/bug?extid=47fc00967b06a3019bd2
compiler:       

Note: testing is done by a robot and is best-effort only.
