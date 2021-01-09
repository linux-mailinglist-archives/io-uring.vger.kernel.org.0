Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3542F01F6
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 18:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbhAIRBs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 12:01:48 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:40921 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhAIRBp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 12:01:45 -0500
Received: by mail-il1-f197.google.com with SMTP id g1so13318414ilq.7
        for <io-uring@vger.kernel.org>; Sat, 09 Jan 2021 09:01:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TKUoXu927qEWQVV5Epbyzc7Ss7cy0HmJolu4+tIMmUI=;
        b=BzwEfjJz28zvCNVzkdmgIUVycWt/Wsy8cMjNvfe77mGLKU3V+9w/oEJr+0P3ggSMoX
         pbJlFGIWKPjVM9qBxP+AtbOArD3C+ZBCqK5NooA21Da+v5IqkkanS5S7smWF7deGc5To
         DhkKH1nqxJDcgn85ZoD/UlqSR/T7t/U7h9I4TYk4wA5GLXKb2+3Aunnw/S4S8GrlsDzE
         NHaOfRgxUq0/vYvdb2AzXm1mJQms9+7goSD9qZe4kmuuLUX+4rOJBfrzW6GCeiUDBLac
         mVLSC6kC6TK+mZs/0JeGnoF5FdD/WRv8ssa2pl+nxt2Y32wjOyDSgUW1aKuDqpDs1oFq
         PGLw==
X-Gm-Message-State: AOAM530rP+ai7jAzJhTMo6n/xp0HUCtt+pvsvDI99PHs6NyyM5/Aqbe/
        t4p0B08ZXr44PX+RM5eocYnFlPg6pO61NgOS7E6/BIks4/Tr
X-Google-Smtp-Source: ABdhPJwpCDQCauEE8T5RinO+sglwtX2Wf03+cIUORnl4QvxsgoLfN20TgVTsEVpOZ5X7+qwp6ZSWudIC7bxQVULggumWU5sdTQq8
MIME-Version: 1.0
X-Received: by 2002:a02:63cd:: with SMTP id j196mr8221257jac.61.1610211664742;
 Sat, 09 Jan 2021 09:01:04 -0800 (PST)
Date:   Sat, 09 Jan 2021 09:01:04 -0800
In-Reply-To: <06c3d80d-eb09-5cda-e0bf-862400d02433@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004a4ef105b87a9e10@google.com>
Subject: Re: BUG: unable to handle kernel paging request in percpu_ref_exit
From:   syzbot <syzbot+99ed55100402022a6276@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+99ed55100402022a6276@syzkaller.appspotmail.com

Tested on:

commit:         d9d05217 io_uring: stop SQPOLL submit on creator's death
git tree:       git://git.kernel.dk/linux-block
kernel config:  https://syzkaller.appspot.com/x/.config?x=2455d075a1c4afa8
dashboard link: https://syzkaller.appspot.com/bug?extid=99ed55100402022a6276
compiler:       gcc (GCC) 10.1.0-syz 20200507

Note: testing is done by a robot and is best-effort only.
