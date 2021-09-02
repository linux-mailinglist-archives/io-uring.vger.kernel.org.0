Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECD93FF3F0
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 21:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347284AbhIBTPH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 15:15:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:38578 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347292AbhIBTPG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 15:15:06 -0400
Received: by mail-io1-f69.google.com with SMTP id n8-20020a6b7708000000b005bd491bdb6aso2110104iom.5
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 12:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lHEO6j/wPdM6LnGvV1Hipd6kqZE+sNmD8+mgNJqLZk4=;
        b=KoqgtHWBvQ+dkXNDMl9iOnUbWcSsKTWVX5q1wlgZ/K8AKzt09OxUBqOg6dw2k0+h33
         AniZ0IohTX0rpbHeJtW4YpBuWKBuq6xg7iQVFEEzUHCB6lqVtT9WTatrXj0bqlp9O2Lj
         ti9s6+a6wvOuW5NylD6Vs1oOBUwmuN4el7cHQzzLlQuAHMXOi8hBJ533rgXOAb+Tje5C
         +q0tWlZrwBUeSvPrsEBriMW5Nbh5dMk3frF0fsApLXsp9A+SkDFF4sGJTDiVydUZkuI8
         fteMsInI7FUQKEHLl/2vURCTQBAjQJHF6bpN4belNH4y3UCIRHDcysDmGHx9kX3BJxRE
         D/HQ==
X-Gm-Message-State: AOAM533TH1iKCJXiD9BXWKGzN3uizh5QnXZPu0vAYv9rekSI2i4jNWir
        zhhc1Jj1hHhDb1nnei6v4Onp6uGkv6dDyRd17LCesZyFi5l9
X-Google-Smtp-Source: ABdhPJxGjsrbI8ElYwmjAQu37MqywmihHOSkKWTcxafm3fLR8bAPLCN7f1Pvixq3+gIaNHWyY2Iqq74GTuldPLMjoJGTthAcFGl2
MIME-Version: 1.0
X-Received: by 2002:a6b:fb03:: with SMTP id h3mr4014831iog.198.1630610047629;
 Thu, 02 Sep 2021 12:14:07 -0700 (PDT)
Date:   Thu, 02 Sep 2021 12:14:07 -0700
In-Reply-To: <3d956ccb-8f2d-e3aa-eee3-254185314915@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a7fb9d05cb07fc90@google.com>
Subject: Re: [syzbot] general protection fault in io_issue_sqe
From:   syzbot <syzbot+de67aa0cf1053e405871@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+de67aa0cf1053e405871@syzkaller.appspotmail.com

Tested on:

commit:         dbce491b io_uring: prolong tctx_task_work() with flush..
git tree:       git://git.kernel.dk/linux-block for-5.15/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa8e68781da309a
dashboard link: https://syzkaller.appspot.com/bug?extid=de67aa0cf1053e405871
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
