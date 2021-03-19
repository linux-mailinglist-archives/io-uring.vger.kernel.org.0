Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE38341ABD
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 12:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCSLCU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 07:02:20 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:42889 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhCSLCM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 07:02:12 -0400
Received: by mail-il1-f199.google.com with SMTP id r16so24562485ilj.9
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 04:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=3kE9urkd9NS2DuoN7WUKMGk6xYQqlb0lhJPiUJGc07Q=;
        b=MPtZccur1BMnR9Mzt25ZCSpjppNxmKZ09ph757CVDJeYDlMyPkZqVNcT9uMI8QD/aZ
         jyelPNpDYJxzfpfj1UyG6rMaeHhl3mMHilbm/S984UXUC9fiU8AnIQIZFmzr9zueIdt1
         /e6WO2+J5Oso1DBqCtqL+jqrwMoFvSPsZ936L1dw6gqNNv7wtRcbmy4CEjHMAmVScalM
         rvdZbOjWkn/xv6Fdu7U2elMbYAnwUxhvZTTwk5m/BT877OuB+5OtdriAKrw+gT/x5K4S
         nW65JTre9VMH3J9vllFVbo/cVQsRhTHp98C7ceVAlnaz9R21VxJ5mgoUOy2IoO7Y8fX1
         Yu2g==
X-Gm-Message-State: AOAM533UWF+dde5erIevl+LuX5h5BZOZr5hLl3ZgdvHQUx3G6XC3DYbE
        4HwN2iSvuui8fJON3H8vUrl4TNQbm+OhPgfAqNX12KzYUMzX
X-Google-Smtp-Source: ABdhPJz+kK4gMhywPYy9lQKtIKqExdj6dBXtuhCNKCvGyX4ec6P8xmes238+oDV+K8NqRw7qdQfcXpEuNSpryoDeSuUPHnN4TqSf
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2141:: with SMTP id d1mr2302995ilv.85.1616151731732;
 Fri, 19 Mar 2021 04:02:11 -0700 (PDT)
Date:   Fri, 19 Mar 2021 04:02:11 -0700
In-Reply-To: <cd88eb14-f250-54d1-d36b-7af3917d3bec@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000df888f05bde1a5b4@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in idr_for_each (2)
From:   syzbot <syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com

Tested on:

commit:         ece5fae7 io_uring: don't leak creds on SQO attach error
git tree:       git://git.kernel.dk/linux-block io_uring-5.12
kernel config:  https://syzkaller.appspot.com/x/.config?x=28f8268e740d48dd
dashboard link: https://syzkaller.appspot.com/bug?extid=12056a09a0311d758e60
compiler:       

Note: testing is done by a robot and is best-effort only.
