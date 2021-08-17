Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332623EE518
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 05:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbhHQDdn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 23:33:43 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:39859 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbhHQDdm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 23:33:42 -0400
Received: by mail-io1-f70.google.com with SMTP id u22-20020a5d9f560000b02905058dc6c376so10428630iot.6
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 20:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=2+HkoneHNqETrotUNTZJ6m3XAQv66R/OQuXYnn+pD9I=;
        b=nnlOlfVUl3vxVDyJ157nqLvHJJmq3+8fhwz8V4M3kL5llQmel4MNdjTRgR2GTHBng3
         1sqlEXSGDNvelGVPojSm+0K+F1cUIC7ldQ5pObOvgLMHOPqNBWOSMVpyXpzXmIM6DXDS
         KN1mcwm6b4SScB9z7WNQ8M5/o4xSWmSTkXpR5UoZrZk8eCDIiYwEezepAQa7qhdE020P
         MjGXwdMDMo0CnbPG3JKn9s8F0IbarPc+QqACjmCefwfi/LNyqn8aH+tgrKW8Vm1wicWH
         HcK+74XAggpGCkvsjr/1Me98AfMjQ74RuNjsyUG6ncYzEWw0kBLmj1NEabNcB4icc6P9
         vdQA==
X-Gm-Message-State: AOAM530HEkc8gLHI2UNH+WAJTjwMXEv7oGZhcAhDqLGJrSItXmtTDRfz
        Vg3PHRoVH3qiAokFzhHpAu4cEXB+wjWm7mLyGgCyhej9qqgD
X-Google-Smtp-Source: ABdhPJyXBqIL3mBUbA0KhcVCXbRSKtEHCnXl+W/MPIhAJ1U6L/pF2ETxKqwEJbV7eqn1EbZC3BnxXHvqGSOZaH5BgvMOAVrZiGsk
MIME-Version: 1.0
X-Received: by 2002:a02:7094:: with SMTP id f142mr1044285jac.19.1629171190079;
 Mon, 16 Aug 2021 20:33:10 -0700 (PDT)
Date:   Mon, 16 Aug 2021 20:33:10 -0700
In-Reply-To: <8236fd18-bf97-b7c6-b2c7-84df0a9bd8e5@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000010269e05c9b8fac7@google.com>
Subject: Re: [syzbot] general protection fault in __io_queue_sqe
From:   syzbot <syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com

Tested on:

commit:         16a390b4 Merge branch 'for-5.15/io_uring' into for-next
git tree:       git://git.kernel.dk/linux-block for-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=605725d47562aa78
dashboard link: https://syzkaller.appspot.com/bug?extid=2b85e9379c34945fe38f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
