Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B52279A0E
	for <lists+io-uring@lfdr.de>; Sat, 26 Sep 2020 16:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgIZOPK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Sep 2020 10:15:10 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:50369 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIZOPJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Sep 2020 10:15:09 -0400
Received: by mail-il1-f200.google.com with SMTP id u20so4722782ilk.17
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 07:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=HwmCPWTIkgbEGZ/8XPswh0ymyUWqTxojzs4EteOI0oI=;
        b=WvcPxhEgI0PS4zU93jdsIO0nidyU8de24izCFb0EilPUYTEWY5cOjJbLC0mhLuWNfv
         mkppeDYiygmq3lbd4aaAazbajNgUFnay5NcNtb/CwtCnN+nLgCZnlazeH/5CDP54D4X0
         Wzosictw0J9Kfr34CKKVLaJ0Be0jJvmF3/A8t1rYem4xEbulsYo+koi7QfHZ0pas8mE3
         CttMy/pbBOQmOYOEwMPmWiXjN3hk5Ok8YNd0gbcX97VrCztZmfaH6nE9pFdCUKYHaJGN
         FljldGFk3XHnNAeLQua9btCiBkobFYzBNAJvMZdW4/1UuYibRY8VOBH7ULkjJApb2O/8
         ha3g==
X-Gm-Message-State: AOAM531GklXXYlJ5oyD+8gt5olfbBUOz2/a5Wbxow3450HUy45+rgScM
        rDEr4Yrq5Wf5GkgfnWNcoBJF37gzDRVTMAclOvTa7lCocpfD
X-Google-Smtp-Source: ABdhPJzP66eKvWYkv61MfW0FnGK+nWFCGDClVgDMl1tg7kxSm9jI8sqCeWZEobb84wJHGaCWQIJpQrNgfTmvYXb6PJHaAILdZudU
MIME-Version: 1.0
X-Received: by 2002:a5e:8e0a:: with SMTP id a10mr2298570ion.200.1601129709294;
 Sat, 26 Sep 2020 07:15:09 -0700 (PDT)
Date:   Sat, 26 Sep 2020 07:15:09 -0700
In-Reply-To: <35306a33-70b5-5e7d-a582-4ba5235953a8@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008fddee05b0380f03@google.com>
Subject: Re: KASAN: use-after-free Read in io_wqe_worker
From:   syzbot <syzbot+9af99580130003da82b1@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+9af99580130003da82b1@syzkaller.appspotmail.com

Tested on:

commit:         41d5f92f io-wq: fix worker refcount race
git tree:       git://git.kernel.dk/linux-block.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=d31db37354c30905
dashboard link: https://syzkaller.appspot.com/bug?extid=9af99580130003da82b1
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Note: testing is done by a robot and is best-effort only.
