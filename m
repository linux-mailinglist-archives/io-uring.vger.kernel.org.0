Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39478376EF8
	for <lists+io-uring@lfdr.de>; Sat,  8 May 2021 04:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhEHCvK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 22:51:10 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:47968 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhEHCvJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 22:51:09 -0400
Received: by mail-il1-f200.google.com with SMTP id m18-20020a056e020df2b02901a467726f49so8706704ilj.14
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 19:50:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Ep5Ziog6b4PKDEAUjUK1xGZkkgiBko+vVQSZys20w/w=;
        b=FkVo64mElMrcvGIMlcbDhfY6sCNYyL4UnFjkGO0WQ1SxsfjLqpXFpJXNRP26BDjwhv
         puPvAAVirHLAo8k1rpAxGO6ZWLXkztMY7UYh7O/rICb347KdcU7uutk1BN3qeiW4LiSd
         95xD2zdY/LRaITRqgcD+J9KNEMn/3f2Bkkcxzjr1nos+K/ceX/9sDha/7cDywtLSgIOa
         S/OpPJ8T4dphfFP1UpQ0DX3tRrEjMCH5b359mUIJWFAh07htNZysxbrE9t4Yci9Hgg00
         zdXOauSB3JMJkMu/bw5dNTeWhnZ0xdX1i/1f7xzBpewL2nQRtxNZZu5vL42UeBJwcYSA
         k9RA==
X-Gm-Message-State: AOAM531zCd09ozf9kIGoZhIp/KtmtjJlFiyWBybdShCJs0sgcqXMRXa4
        rwdm77nKDFOmS1kUaJAvitefb7ZvOddZKnXQJMv+o760O7Vb
X-Google-Smtp-Source: ABdhPJxJyzmD1z8zzw7DF6Q34svdnXoJ9Xh8K888+JYMQuz28+XX+2x/TaSJClKQ4EyWMRjU8m0a1b7xCm9QrsSB+vQf1gKpJGhg
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:de7:: with SMTP id m7mr3239161ilj.76.1620442207980;
 Fri, 07 May 2021 19:50:07 -0700 (PDT)
Date:   Fri, 07 May 2021 19:50:07 -0700
In-Reply-To: <e2fe2053-c413-daa4-1151-c4476d32d23a@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002f920305c1c89a25@google.com>
Subject: Re: [syzbot] INFO: task hung in io_ring_exit_work
From:   syzbot <syzbot+93f72b3885406bb09e0d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+93f72b3885406bb09e0d@syzkaller.appspotmail.com

Tested on:

commit:         50b7b6f2 x86/process: setup io_threads more like normal us..
git tree:       git://git.kernel.dk/linux-block io_uring-5.13
kernel config:  https://syzkaller.appspot.com/x/.config?x=f81a36128b448b98
dashboard link: https://syzkaller.appspot.com/bug?extid=93f72b3885406bb09e0d
compiler:       

Note: testing is done by a robot and is best-effort only.
