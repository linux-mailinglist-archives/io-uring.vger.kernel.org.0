Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E16037A033
	for <lists+io-uring@lfdr.de>; Tue, 11 May 2021 08:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhEKG7M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 May 2021 02:59:12 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:53174 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhEKG7L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 May 2021 02:59:11 -0400
Received: by mail-io1-f70.google.com with SMTP id o6-20020a05660213c6b0290438e33a3335so6865546iov.19
        for <io-uring@vger.kernel.org>; Mon, 10 May 2021 23:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WAlEVy0ZMfNVjKlh40M9CEJnUjL9y5ekxYFhQsRtRM8=;
        b=BTV9NjJPrujeF/+qYK6+ZQjXyw3cNQ7JryInObBxfdSiha2ywBl69bnEVoLuRnXUeK
         hcqKpDTT5Eg/rcDrdMrZToCu/XmpE4OBWb0L3VIDEyvmX79DhX2ZaAEFgNcooektCf/s
         Ixg0TJcgHp4ZuEF5QeeA6dTq7bwCEV2JiWyVMQ51om2SJwtSgGWdpAQeCcqPVPPmbP9S
         h0HrKv7CKm7yqaQe28fgy391wqYVH1jnYBO1HMATFCVPQUL6MaprL5n0dG7fvYqYxwMW
         t+iyKq8QvWZZvcEmqwf7Yp6yrICO6+eQBaXkTQkeoNHCl/QovMDYgjVHZxWmER2TqQtC
         QsAQ==
X-Gm-Message-State: AOAM530nWPjSQyFo09hay64Ci+Rvh93GZEmzNTwwqqS2uoL4eCNQU1n7
        WdbUOerUXuXlUL3kIeu21nl20hBuVzZJ3vdvR+TFgKx47cuf
X-Google-Smtp-Source: ABdhPJy1+7M05LR396Fy+WAxn+ZHCqn77sqp5GoH6r5WKwYW5bJvDqONdE4jmh/SCNdH5aovFYTBZFc/A80DtjSEiAYMyZW+NOLF
MIME-Version: 1.0
X-Received: by 2002:a92:de49:: with SMTP id e9mr23983574ilr.132.1620716285105;
 Mon, 10 May 2021 23:58:05 -0700 (PDT)
Date:   Mon, 10 May 2021 23:58:05 -0700
In-Reply-To: <000000000000b304d505bc3e5b3a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000749f0605c2086a95@google.com>
Subject: Re: [syzbot] general protection fault in try_to_wake_up (2)
From:   syzbot <syzbot+b4a81dc8727e513f364d@syzkaller.appspotmail.com>
To:     alaaemadhossney.ae@gmail.com, asml.silence@gmail.com,
        axboe@kernel.dk, christian@brauner.io, gregkh@linuxfoundation.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        shankarkoli@quadrogen.com, shuah@kernel.org,
        skhan@linuxfoundation.org, syzkaller-bugs@googlegroups.com,
        valentina.manea.m@gmail.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 363eaa3a450abb4e63bd6e3ad79d1f7a0f717814
Author: Shuah Khan <skhan@linuxfoundation.org>
Date:   Tue Mar 30 01:36:51 2021 +0000

    usbip: synchronize event handler with sysfs code paths

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114c0579d00000
start commit:   d4961772 Merge tag 'clk-fixes-for-linus' of git://git.kern..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=9320464bf47598bd
dashboard link: https://syzkaller.appspot.com/bug?extid=b4a81dc8727e513f364d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126d1de9d00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: usbip: synchronize event handler with sysfs code paths

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
