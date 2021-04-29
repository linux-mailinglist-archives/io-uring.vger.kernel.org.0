Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6A936EC3C
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 16:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhD2OS4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 10:18:56 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:42501 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbhD2OSz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 10:18:55 -0400
Received: by mail-io1-f71.google.com with SMTP id v3-20020a5d90430000b02903da4a3efc9dso36213761ioq.9
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 07:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Ol3FICnYJQdFXP8aGYDo9pndJt2yyzEHkFMgQR8y69o=;
        b=LrQ6vV2EbU2A2s++NUphkXbLbTSbUVRaIQYhcO43PQr81oXzSqIKF5tKMoEMz4mKpS
         X7RfBdpFifChMu9O+MF0v7zEUWqUfHPTTjx3qDRl3/Dh2jo/j+r2/ebTYpp9yAIpJuA5
         cz5n8eQUw07SnXOy1xEv4Kxs5+LBP8i7LIur6drWiGrPjOXv8EP75JQg8NR64J3qifU0
         JgmtGslQFchVvtK88ekdfzhyeGEDiooLPSoENtJ66/a0lgzT73/C/DMckrv2F7GsYc0a
         8/Gz2Ocv2zIF4wLRKmrF81h4td3K/a0mfWQoUAbuISTGkjsZEw5r7JJ4yx07ze1qfZVO
         zA5g==
X-Gm-Message-State: AOAM533rifnDmb2jmRARH/KhTPus6t6G35bVJahBSLkRCKjkMB/V6CBT
        cZyiZBneU/1fXmUYe44xoL423qyo1yTKTCBaShNzTJKTLWkw
X-Google-Smtp-Source: ABdhPJwNDr/qiNG74QRIq6/oPCyd607LZke6i+enHOPBDanqDiOuDmiArvw8Ojk8rH8fewVJ6bL5aEd0TuiEOR4nZywQFl37x0HF
MIME-Version: 1.0
X-Received: by 2002:a02:a695:: with SMTP id j21mr88590jam.29.1619705888636;
 Thu, 29 Apr 2021 07:18:08 -0700 (PDT)
Date:   Thu, 29 Apr 2021 07:18:08 -0700
In-Reply-To: <311be205-e56a-cc06-dfed-df9aef527268@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002202fb05c11d2a78@google.com>
Subject: Re: [syzbot] WARNING in io_rsrc_node_switch
From:   syzbot <syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com

Tested on:

commit:         ccb5e40e io_uring: Fix premature return from loop and memo..
git tree:       https://github.com/isilence/linux.git syz_test4
kernel config:  https://syzkaller.appspot.com/x/.config?x=601d16d8cd22e315
dashboard link: https://syzkaller.appspot.com/bug?extid=a4715dd4b7c866136f79
compiler:       

Note: testing is done by a robot and is best-effort only.
