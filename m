Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CB546EE61
	for <lists+io-uring@lfdr.de>; Thu,  9 Dec 2021 17:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241362AbhLIRAC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Dec 2021 12:00:02 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:35563 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241719AbhLIQ7q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Dec 2021 11:59:46 -0500
Received: by mail-il1-f198.google.com with SMTP id m9-20020a056e021c2900b002a1d679b412so7781523ilh.2
        for <io-uring@vger.kernel.org>; Thu, 09 Dec 2021 08:56:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=StI9htrsT9nAfOWxOwIUSz384tvOEJibgAyyKfuu94M=;
        b=K1amPROUoAc3Ws0UtEggDXLp/HPbffXv6ulTbP/pplpgppIFGe4zY0qiBDHgeNhKdW
         /jsx6H1rr/h66nMIXyGGUZV7/aJOJJJurxJz6uW5hNOYzxxskEugC/vyxt41vc/EvOv3
         nvpXoEtohuL193SYfhhNKlms/9EGTgeirRpyzfrFkqKNQFnGhOJl1iVRQ5nSJ9PQepQp
         b4V2Ug+G4q4HZDhZGtwDEQxslGp6yEtD1PGe7kIa6Eu8lWu+JjfemVSq2O9TiA3Q7TJ7
         Dbg3iPTaoHsLjVPuAs2bpRnGKUkhIjy8yxBzGddn8IshAVsa75L68tz00xrNDl9UUXEe
         WcBQ==
X-Gm-Message-State: AOAM530/pwmHqFnSiYc1lrfM4HL+SzWCLEEN4mp9Sya1XQrR1Z48PL8N
        zWzqAH4FnHVd1OBqF/EW4fXn/ztPSSAMJXImgtLO+VV23go+
X-Google-Smtp-Source: ABdhPJylw/81I/nLoI8OtCd07PKPJbCgDmiv6LeRlCXOeEfrSkyRuz/Sv5bVLCazKWZhGEFvDxMAvkeWWZnUE5ePteGtDwJXoKnS
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160d:: with SMTP id t13mr14013859ilu.306.1639068972803;
 Thu, 09 Dec 2021 08:56:12 -0800 (PST)
Date:   Thu, 09 Dec 2021 08:56:12 -0800
In-Reply-To: <053430b4-8b7a-249e-19a9-17752b47504a@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e2eddb05d2b97be5@google.com>
Subject: Re: [syzbot] INFO: task hung in io_uring_cancel_generic (2)
From:   syzbot <syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com

Tested on:

commit:         59614c5c io_uring: ensure task_work gets run as part o..
git tree:       git://git.kernel.dk/linux-block io_uring-5.16
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7264d1cb8ba2795
dashboard link: https://syzkaller.appspot.com/bug?extid=21e6887c0be14181206d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
