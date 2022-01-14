Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB05D48E264
	for <lists+io-uring@lfdr.de>; Fri, 14 Jan 2022 03:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbiANCJI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jan 2022 21:09:08 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:50937 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238442AbiANCJI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jan 2022 21:09:08 -0500
Received: by mail-il1-f200.google.com with SMTP id x13-20020a056e021bcd00b002b7f0aa0034so4110912ilv.17
        for <io-uring@vger.kernel.org>; Thu, 13 Jan 2022 18:09:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=l+R7nWMxKcU084x0V/7GNQbj65lf2ts3dJyo3gy3f6s=;
        b=lGXrOgFhXERJ1DV/pdd6USt970zgmqCPyvbpelbP4+b/wEfopJHQbR7VB4IYab6VDg
         AFux5umgbbBht5hi7aYWxuS2uZW0qoXCJzKUndPU+i2sVo+SSOT6flHt9tPynLvQleo2
         eNvTxpzpnjYd4xfqqT9JXZmwuaRx66/s1Qove4lp3RcF99v8wHJ3lVATbdcbA2Z8OON1
         YKs8iIw34zd/nBEwVrOeYsKsYoIs9Rvuz+lUI23wmQfttkF9k6tr7SITQ+U7RxPaXkOf
         xT0jjlOroxrVnmLN59D4JZvzQ9QmeXezt9LhL2kcnID5HhbiLdIB5n8+8L9aMhSS7VUM
         ZwvA==
X-Gm-Message-State: AOAM5323ZjLDGIh204+aiqRe+s/eQHgebxDpEvDcbaouXaymJisppBzN
        iSiTk9ckuZ3WzpMoc3qwO+Ti52t35WyeUIUndWKMgcQIcCYg
X-Google-Smtp-Source: ABdhPJybKJOsrE+8Vo8gzVZrp2mTACAvXMUTRVRTzELPcrK9to/GJshkwEJEUMZmSYSGqFeYj8NqLtMD/0Cl7x2d2cUB4f5x7AlY
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18ce:: with SMTP id s14mr4007528ilu.0.1642126147538;
 Thu, 13 Jan 2022 18:09:07 -0800 (PST)
Date:   Thu, 13 Jan 2022 18:09:07 -0800
In-Reply-To: <998e645c-b300-9e58-eb02-3005667dcfe2@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b355a205d58149fd@google.com>
Subject: Re: [syzbot] WARNING in signalfd_cleanup
From:   syzbot <syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, changbin.du@intel.com,
        daniel@iogearbox.net, davem@davemloft.net, ebiggers@kernel.org,
        edumazet@google.com, hkallweit1@gmail.com,
        io-uring@vger.kernel.org, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com

Tested on:

commit:         59fb37ef io_uring: pollfree
git tree:       https://github.com/isilence/linux.git pollfree_test1
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aaa2946b030309
dashboard link: https://syzkaller.appspot.com/bug?extid=5426c7ed6868c705ca14
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
