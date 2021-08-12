Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F713EABDD
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 22:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhHLUge (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 16:36:34 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:57101 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhHLUge (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 16:36:34 -0400
Received: by mail-il1-f199.google.com with SMTP id u2-20020a056e021a42b0290221b4e6b2c8so3796547ilv.23
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 13:36:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=sBYzu++XtTyiMNxgm0IaBQVBwqzw9O6kfSOlaQ8ZUzI=;
        b=pRNqB2YCsPh3Sv9zhLWtePsjrT/rLtrgyjPxGxfv+twWjo6u63kiFzjMtxD6Sc2mvb
         YB6oRv5FSiyG5gmEIAT+ub+unj3YaEmXpOiuiKcql7LKdxMDrD/SL3L2mPyaQ+Uvas8m
         AVtCoSITtnHlpxW6VhWOo3Ie1vDIhCFUv+pq30LQgFlBdP7VKpe4Q6iOryW7cF0DoAhI
         1XgqQZSUVxg6Q5zshYHtOZ/wHPSV6JTn2/802o4Gm5BbQPNLl32PCD1e7AbTyRT26+RI
         KmCC1jEUPD9DhLUikjHMJNkogKxpCLj2U50bJwxfZ+R8tMlSZAbJn0G5/JfmuZ5q6iX9
         9sig==
X-Gm-Message-State: AOAM533jSH3+NUwJVhx33LcCLVeTG4xWVx0GdD4nRPyv6AAB+Y8rGALH
        A6FUaUXlN6VsOXL4tnONkCPBmGnnYqQsmG/vBw0PAriuAuxB
X-Google-Smtp-Source: ABdhPJw3XIRV+yx+RFhY33oFm2MfAtk/nwcxE0vdHJIYzGW+3k2IatJ4phFZ9UIf7JXcgVp/MEmL09rGjcQb9UcVNC5Ho6FryfrD
MIME-Version: 1.0
X-Received: by 2002:a6b:ba02:: with SMTP id k2mr4427251iof.164.1628800568256;
 Thu, 12 Aug 2021 13:36:08 -0700 (PDT)
Date:   Thu, 12 Aug 2021 13:36:08 -0700
In-Reply-To: <6f7d4c1d-f923-3ab1-c525-45316b973c72@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000047f3b805c962affb@google.com>
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

commit:         bff2c168 io_uring: don't retry with truncated iter
git tree:       https://github.com/isilence/linux.git truncate
kernel config:  https://syzkaller.appspot.com/x/.config?x=730106bfb5bf8ace
dashboard link: https://syzkaller.appspot.com/bug?extid=9671693590ef5aad8953
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
