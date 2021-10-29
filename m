Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224D3440462
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 22:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhJ2Uzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 16:55:39 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:33519 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhJ2Uzj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 16:55:39 -0400
Received: by mail-io1-f69.google.com with SMTP id f19-20020a6b6213000000b005ddc4ce4deeso7627775iog.0
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 13:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=mZR1Ffgh9GUeY1nvfeVVdOqzzFuN2C/+L0bUpcqSOr4=;
        b=IuRIPchQExYEhk4gCCdKcG0W3IKJ2z23+dIfZLPIPnHekQxBhfiji8I63FrxCLejMf
         vX3Yf+piDLmng6W2v4dnd80n7jnkPuzaHOGDlROzkeoBDJl3juhi0lPOOKKrLYyaL5G3
         pnYrFEWXCMtXtkozo3V6ZoEyCmWKFsUCVRgwkP+cZ8Q0EbwVPlwcXBN4tg//j/If6/Gk
         9gLLIoQgooTxhQ7RLAC/fEMeDz1d0bLDnMNxZTy1bL33l+MEce6IZNLjrbgmWoiL3zvt
         gbIx8gbk6aHgxZeuEGR9LK7Wbd5UZwuuACPC0Nhb3vv8PYTlaWsYQnL7gtl6j0Yr6e1L
         7h8A==
X-Gm-Message-State: AOAM531AJHsE6C2BlAK0R4IgIl1MOQYKHmjgOR3NR3RnJ0r8TvA3l9fG
        sGb6JWc7CshKIyo4fnUoIxVcyuu0Ofm2F7J0buy+Gz96pKd5
X-Google-Smtp-Source: ABdhPJyg7+CkIZhRFcuuSE69HNyMf6UDU7ZvRRKf1co95w/1Krr48Gg72H+2mTFxBZR0Aql8UGNCzvAEgwqDLIoCoGWEBKHdw9ya
MIME-Version: 1.0
X-Received: by 2002:a5d:80d6:: with SMTP id h22mr9940649ior.152.1635540790308;
 Fri, 29 Oct 2021 13:53:10 -0700 (PDT)
Date:   Fri, 29 Oct 2021 13:53:10 -0700
In-Reply-To: <ef640d96-750f-d92e-50ff-27c97f6dcc51@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d2737805cf8403c9@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in __io_free_req
From:   syzbot <syzbot+78b76ebc91042904f34e@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+78b76ebc91042904f34e@syzkaller.appspotmail.com

Tested on:

commit:         1d5f5ea7 io-wq: remove worker to owner tw dependency
git tree:       git://git.kernel.dk/linux-block for-5.16/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=10c050a45aafafcc
dashboard link: https://syzkaller.appspot.com/bug?extid=78b76ebc91042904f34e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
