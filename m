Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23514045C9
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 08:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350567AbhIIGwX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 02:52:23 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:40799 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350474AbhIIGwX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 02:52:23 -0400
Received: by mail-il1-f199.google.com with SMTP id f13-20020a056e02168d00b002244a6aa233so1230341ila.7
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 23:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=kDkmBLWaDYRnrQjU0pW08RiRXMeXOiOOb1COf/LFO7U=;
        b=Yp/MnxyrVHrL+8zSZxS2pVqI8LkxIyK7BZrEOot4lcidbw9/fzwz61QgT5/KvUnRq0
         pVR5Y0dbk8FSLCxxxhOxw9b2xPOrQL/gpDur9Qi18kjf8vxWKfm3O1FX6rmGeEtgRoyW
         ocWzHJwpcENcoBMAj+zBlhGezl6BrxRDMhshpkZIochOB8Uw25a7Znu0YaOJOO25lw3K
         qxJGGOo8jRMmN//CkzjlzKb4RfGR57JsF7MY0FlVcChYUd6nnIakKsxNKLW3V5XeXN9b
         m43v96Z0hoIzrhjehdqMyqc863fpjKYFztYggSof4/7R0JxxQeMXqva2lPOuetgsDqf8
         /Zkw==
X-Gm-Message-State: AOAM530L4dbtJVBGL1EMZ9QuKrBFIetzTOGsECoF4L2UDm5Xvuw6n0Zu
        GS0qn9Nl2APiu0Ejqbp6NVba6bQ639+fdj4hDFHW8adfS0CZ
X-Google-Smtp-Source: ABdhPJzho46HFyo1dlf+WBjkzC2MnzGIgmkh9OHBrq8p1x32bpn2LBRKLLO/LQo4mQcInwQuDpOYrWCqCZfG3+LQIYK7sb2Q7O5E
MIME-Version: 1.0
X-Received: by 2002:a6b:e616:: with SMTP id g22mr1371654ioh.67.1631170274006;
 Wed, 08 Sep 2021 23:51:14 -0700 (PDT)
Date:   Wed, 08 Sep 2021 23:51:14 -0700
In-Reply-To: <9bef8d9e-7378-62e6-b78c-af3fceab2e46@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c01ddd05cb8a6ca0@google.com>
Subject: Re: [syzbot] INFO: task hung in io_wq_put_and_exit
From:   syzbot <syzbot+f62d3e0a4ea4f38f5326@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+f62d3e0a4ea4f38f5326@syzkaller.appspotmail.com

Tested on:

commit:         3b33e3f4 io-wq: fix silly logic error in io_task_work_..
git tree:       git://git.kernel.dk/linux-block io_uring-5.15
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9bfda6f9dee77cd
dashboard link: https://syzkaller.appspot.com/bug?extid=f62d3e0a4ea4f38f5326
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
