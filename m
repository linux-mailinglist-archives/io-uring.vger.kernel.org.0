Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A18F400863
	for <lists+io-uring@lfdr.de>; Sat,  4 Sep 2021 01:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241161AbhICXsK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 19:48:10 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:49680 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350498AbhICXsK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 19:48:10 -0400
Received: by mail-io1-f72.google.com with SMTP id k6-20020a6b3c060000b0290568c2302268so449416iob.16
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 16:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=49GVSL+8Ju2B1QUqKAewsys4rafDwru1aSMpQywZS0A=;
        b=NzIUgyoZ1rmq656Lx6KVOo2aguc3zdfsZEWWGJUfhBAvq7XWELPKZVB/EGIqdAgMMO
         7ruNo/zwXKda8rEAyj6XU3Y1QGnYqjxUc0ieY+rEc2FTKNiTB2ieoMsTCnZZvzrexTWW
         p/vJ1JOfv4tESu5LKMY38+iwdRk9d6eieg2hZg0MczP2tGaESdf4z4EYHINuH6fTkdSy
         AUWUWS5E9OJRAHlcOscnjw7OLSrPQ7vGH9y3lDY9F5vA6Ec5VAc3k0dVpxHpiOxy1ynM
         MH+VstdWnXH5r5je4X7Q4iumqXv4fCepJXuNdgDG3sSVR4kJKp43h5VpyznRpdD2W/Ee
         HZVw==
X-Gm-Message-State: AOAM532sia+45tB5rJrlmQHJEJAcaBe2STV8xl2rJlI/nMhCcr89moJo
        CPw0xZ+4VmZFQsAgl5T0rRoTFkpBYz0D4Ig0oIkkGDUZ/n53
X-Google-Smtp-Source: ABdhPJxqPcg1k7hijBbzqBZIjUclFN4DkzgpDyRmu2xAWHNnxpFouyfcVn8OUI3wvoEPs0CIY5ocITh0LQ7SVO8c1NZ35abXF4Sk
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d06:: with SMTP id i6mr1009436ila.113.1630712829629;
 Fri, 03 Sep 2021 16:47:09 -0700 (PDT)
Date:   Fri, 03 Sep 2021 16:47:09 -0700
In-Reply-To: <2b424f91-0382-d3ab-26c3-52cf03dab999@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f0da6305cb1feacb@google.com>
Subject: Re: [syzbot] general protection fault in __io_arm_poll_handler
From:   syzbot <syzbot+ba74b85fa15fd7a96437@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+ba74b85fa15fd7a96437@syzkaller.appspotmail.com

Tested on:

commit:         31efe48e io_uring: fix possible poll event lost in mul..
git tree:       git://git.kernel.dk/linux-block for-5.15/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=914bb805fa8e8da9
dashboard link: https://syzkaller.appspot.com/bug?extid=ba74b85fa15fd7a96437
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
