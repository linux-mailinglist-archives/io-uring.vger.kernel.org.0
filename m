Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CF1470564
	for <lists+io-uring@lfdr.de>; Fri, 10 Dec 2021 17:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbhLJQSo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Dec 2021 11:18:44 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:44000 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236753AbhLJQSo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Dec 2021 11:18:44 -0500
Received: by mail-il1-f200.google.com with SMTP id j1-20020a056e02154100b002a181a1ce89so10756908ilu.10
        for <io-uring@vger.kernel.org>; Fri, 10 Dec 2021 08:15:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hCvnT54V6dz5hU6SrRLw5pSFpj+AS8Nd4KGYLHFcp0Y=;
        b=XYiwV6VWEPFV153g7lHq1BA5gYMNqL6ebiQvQLYjg0M2X6P2C5JigBCl5rnlGF6GLF
         frof7htCzJns1k+Eonaucr9gf2qP2cryM56dylAxlSmbqlaENUUBVu0BPn2SpsqVbC0u
         LoMdN9+z24IEELFyYikPnK2CJ3GtJty/m6Xl4ACJYZb0W2Yf6U+3yAKcHjfa1wfaibX2
         UHIj9XEC9w0gZR0bb7NlcCTPeRfad4AY3m0bbiStbLWDZG5pko7sFfc5JlILRf7Au8cV
         35Sus04UZEVKHqVyaRJQ1ITHl0VZg0fna/9ZtQxHOGA/QJrBbMNMD5tZXTC2iCCDhfhX
         iLtA==
X-Gm-Message-State: AOAM531GkXPz+Xt8Vas+rPke0b+YgKkqZvW4PRAJSzKpvGg+McqvN7oq
        LxGGq0AY9vYPCd46a3JM8nsuWe9fh2y1CFLe02jlwsY71w/M
X-Google-Smtp-Source: ABdhPJy0+1Kzubb2wOyqTwA+WeSKW/Ony0nSbvBW6B2pEY/r1R4dlA0k9FeachkuKy5dZIjLG6abPYZiWcQpTE+gWzMTJVMs9Ewh
MIME-Version: 1.0
X-Received: by 2002:a92:d28d:: with SMTP id p13mr24204351ilp.163.1639152908858;
 Fri, 10 Dec 2021 08:15:08 -0800 (PST)
Date:   Fri, 10 Dec 2021 08:15:08 -0800
In-Reply-To: <8544854b-226d-befd-bd91-5af182c2b03d@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd7d7e05d2cd063a@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in io_queue_worker_create
From:   syzbot <syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com

Tested on:

commit:         263568d1 io-wq: check for wq exit after adding new wor..
git tree:       git://git.kernel.dk/linux-block io_uring-5.16
kernel config:  https://syzkaller.appspot.com/x/.config?x=6c3ab72998e7f1a4
dashboard link: https://syzkaller.appspot.com/bug?extid=b60c982cb0efc5e05a47
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
