Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07E534DC85
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 01:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhC2XdY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 19:33:24 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:46480 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhC2XdI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 19:33:08 -0400
Received: by mail-io1-f72.google.com with SMTP id w8so12018075iox.13
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 16:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lMlioT72BHXScbFHNZMJLoPdODEiwb40F9vPrqeqLoM=;
        b=N++F85TmF7bMyzmtq1HdQdUQCH8DKjfy+qocjqr/jjtN5hvKzcqshg9B98/PXspEKq
         WQFyMpDxMgXxB2vXH8U4PzKg0LbK6j7a1skSh0ae8vWEUVeYXQvzcLc+1SqCwPsXP9p6
         ZfYub5NjW3qemFbLIIBLfgQSywlP7SYl9zDrQ/FYGeOytpoUQICc7XNFzAMYP9C2Z9Dy
         VDMnhUO//3QAeCjFZPsBB2lHeMHwLI1f3ozl7KYHX6ts6Gn6nmlPmQM59yXbCJfcdUUy
         zaJgpiHGinw19AAHxSmySCKiqUAwoSvbjvhvder293sH9SfeAEvnGBcRrQzp72UuvbYl
         B4hQ==
X-Gm-Message-State: AOAM533t4Llv0jBAT7XJiKUSeMPwhzvoOdrx/8nVpgi/uy+dQQ+zC9kJ
        /MSSXMpO43t1ziHQLfD20CbYiH0Z7Mi9p6Vhl/lQi/ziwMrd
X-Google-Smtp-Source: ABdhPJwbpo1qBtqFDEAozEtKpv7+6pbc039Tmkz4JX4dPkyQ4fE1JV42MwydMp0mlXFrwMNWtxLegYbPzDkz6Bc18A4ABmxVHB+9
MIME-Version: 1.0
X-Received: by 2002:a05:6638:378c:: with SMTP id w12mr26304998jal.127.1617060787957;
 Mon, 29 Mar 2021 16:33:07 -0700 (PDT)
Date:   Mon, 29 Mar 2021 16:33:07 -0700
In-Reply-To: <f96bff2f-bcd5-a04f-4130-1c3a933f97a2@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d8bb1905beb54dcf@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in create_worker_cb
From:   syzbot <syzbot+099593561bbd1805b839@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+099593561bbd1805b839@syzkaller.appspotmail.com

Tested on:

commit:         24996dbd io_uring: reg buffer overflow checks hardening
git tree:       git://git.kernel.dk/linux-block for-5.13/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbb3af9ca0d22f7a
dashboard link: https://syzkaller.appspot.com/bug?extid=099593561bbd1805b839
compiler:       

Note: testing is done by a robot and is best-effort only.
