Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621DB346164
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 15:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhCWOXK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 10:23:10 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:34898 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbhCWOXF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 10:23:05 -0400
Received: by mail-il1-f200.google.com with SMTP id y8so1870965ill.2
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=2CgcKrHeCWGBs2yP0zbh1B1ArVXrjGOfPGKUarVfunQ=;
        b=VsmVFDMZkqPrjdU9XWCY5gG8rQtovdjprXXL+dWEloHSJfqzqDaxp1HQlG9wpPLJME
         pVNiLXJQuqxrTypsc4QKgjN3rGQA3hOyrHHoHFDB3rl1Gq1t2ADGCygwvsjPdFgRsN+F
         mO8L/jKsrUtS1iTrmHyKMEzTOMnYCCrLKnkKhf6veDWiZjTLCjIZiFgmoSLbpKf4eB8g
         SXjuVmgyaNS/nkyjgq/87gIsP2huQ7rvyKRuXJEFeOxl87LieFqO3qJkG2Nhd1ve/urz
         NpDudubf64lN94kfvUNu9EeZ0H9vnmG18m0Z1wJroox6Y9GWv7HFbiTcgQPkddv75oag
         7+0Q==
X-Gm-Message-State: AOAM5331skdG7lhS0vasnN9uP5OK6YlpRWw0O1ESZl+Jho9PCi9j1DNb
        K/gUPbefYo1RRWGNPM+jt32Ppfvz5QE3dUGLgTZePXlH+gp4
X-Google-Smtp-Source: ABdhPJzgwzFP6+3QtkQvdgHTxAvfMkCaGRBXU5kycZm2+e6m/Rd9tLH2IWwqzc64Az8TvaRN7DDSTSnNIy8qnY2e68q1xXxjnlh2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c21:: with SMTP id m1mr5184931ilh.204.1616509384532;
 Tue, 23 Mar 2021 07:23:04 -0700 (PDT)
Date:   Tue, 23 Mar 2021 07:23:04 -0700
In-Reply-To: <08603c70-64df-5dcc-f5c7-1646056af74b@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a427e805be34eb03@google.com>
Subject: Re: [syzbot] WARNING in io_wq_put
From:   syzbot <syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com

Tested on:

commit:         c95a47c2 io-wq: eliminate the need for a manager thread
git tree:       git://git.kernel.dk/linux-block wq-no-manager
kernel config:  https://syzkaller.appspot.com/x/.config?x=175bf2d0517d3b04
dashboard link: https://syzkaller.appspot.com/bug?extid=77a738a6bc947bf639ca
compiler:       Debian clang version 11.0.1-2

Note: testing is done by a robot and is best-effort only.
