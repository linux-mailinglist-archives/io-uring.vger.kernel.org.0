Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449F73CE819
	for <lists+io-uring@lfdr.de>; Mon, 19 Jul 2021 19:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242591AbhGSQhs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jul 2021 12:37:48 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:56064 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352833AbhGSQe3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jul 2021 12:34:29 -0400
Received: by mail-il1-f198.google.com with SMTP id i22-20020a056e021d16b02902166568c213so3236098ila.22
        for <io-uring@vger.kernel.org>; Mon, 19 Jul 2021 10:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lKM2UD/yHgWjmA2szMEkHx9fCrO+nHy0wS5xCM2jOV0=;
        b=OyfksTQmN7d3tCjAWoqZ7SCLrnMa4o+WKNDoK63x2Tnsrx9TZ6FLsauC0HKJJRik+j
         zZ/DPGVGKOOKhvCbEz9Fmo1gUZcpowYEyGcvv9mJ4PpD02jAdNL/vaabskiiZyCNyYW9
         yM9/RYIJswxsOFai1yUZmu0WeWdpRFFkGUHRjRzm+NxBLN+7W6NKjLlUgXHnu5Wypi4D
         OajlQGKeOfgvx7SW7EoVgiOPXptjdgumz4tq+wM62CCVmFQJH1mhDsmgNVRe2t/1/PdK
         1bliJSh70WlOcKfgigcgA/A/LbKnVXzTll190ct/UdknDyiHyF62dR15uBP3diMfAfKd
         a09A==
X-Gm-Message-State: AOAM532KvtCYpXh6o6vGeRgCLsf5PpuRL6mYHHB+FLkjN47ZFi3kC1h6
        sCjHLcJxSXV15Fb2AHM59gyY8r5pmEPz/O1yJ+a0mDR7Iohj
X-Google-Smtp-Source: ABdhPJwZFFssLOoNLjRgimHgZ+etxG2tvmGaw4gHR0vTxbgH8LEXycoYsMuGqxgNsK4/cw1XQ5fBDAiLlYO2sfpx4t7XP/Ndktqa
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1142:: with SMTP id o2mr18396207ill.277.1626714909265;
 Mon, 19 Jul 2021 10:15:09 -0700 (PDT)
Date:   Mon, 19 Jul 2021 10:15:09 -0700
In-Reply-To: <c57f80f7-440b-9f12-a7b7-a58ed7ab400a@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000051553205c77d143c@google.com>
Subject: Re: [syzbot] INFO: task hung in io_sq_thread_park (2)
From:   syzbot <syzbot+ac957324022b7132accf@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+ac957324022b7132accf@syzkaller.appspotmail.com

Tested on:

commit:         61d27d88 io_uring: double remove on poll arm failure
git tree:       https://github.com/isilence/linux.git syztest_sqpoll_hang
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfe2c0e42bc9993d
dashboard link: https://syzkaller.appspot.com/bug?extid=ac957324022b7132accf
compiler:       

Note: testing is done by a robot and is best-effort only.
