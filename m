Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9115F4404AA
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 23:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhJ2VNi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 17:13:38 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:54063 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbhJ2VNh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 17:13:37 -0400
Received: by mail-il1-f200.google.com with SMTP id x4-20020a923004000000b00258f6abf8feso6775653ile.20
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 14:11:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Ube9YO8E2J4s/t6BEWtg7056+gSWcIyQPYfWxy9j/A0=;
        b=dw605/FIXaQqVHYazCffdeYLFJ9Vzsff4tGNNgO37LpTbpBaAH/LueEJMyR4oaOnr7
         RJk/gnprHxDxmtywA5rdZGgqYihBOV1q4gYlqT9gAvgE2bb3Tx57QlCSfIkYSIQapVh3
         N8h3q1IFJZf7HDEAHfgncr37BE1C7iwYVj1Xqg9jYUc5eJCZecOIb3SfaP5PnGxMfPyd
         q8J0fHIj/bMoyeIWrs+vvwv/CmxeBxwOSFl8EGau9TLaDAyH7fwuSij1dUBdT/7/JkbC
         R6I1R9C6GsP4Wue3Htcr/vm29g7t//nldAG6tM6j+tJXZpKPaKbFTTvox/jw3bVQ90Uh
         nRIw==
X-Gm-Message-State: AOAM53362X8DFNPlN6nzpcVm9As3f9Oc/mXNpvkrLiBKvX7yTVD2uF+X
        BqWXIl7oeffqPYFJxN78RCzHHKL6oIgv1gv0/WrVseLxnD69
X-Google-Smtp-Source: ABdhPJzYnHs5ysePpw2kpjuQ4CgUKGe8Lhp2JQEBePrLF4wBTKVogqzTk584XPQJPbDBEcOc+CmhU/b89d3Ik/4MKxTheoJJ/hXf
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1214:: with SMTP id y20mr7561508iot.156.1635541868350;
 Fri, 29 Oct 2021 14:11:08 -0700 (PDT)
Date:   Fri, 29 Oct 2021 14:11:08 -0700
In-Reply-To: <949780a1-8768-830f-ff89-f6092037cb58@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014107b05cf844445@google.com>
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

commit:         3884b83d io_uring: don't assign write hint in the read..
git tree:       git://git.kernel.dk/linux-block
kernel config:  https://syzkaller.appspot.com/x/.config?x=10c050a45aafafcc
dashboard link: https://syzkaller.appspot.com/bug?extid=78b76ebc91042904f34e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
