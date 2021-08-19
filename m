Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58A53F1F04
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 19:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhHSRZo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 13:25:44 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:45613 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbhHSRZn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 13:25:43 -0400
Received: by mail-il1-f198.google.com with SMTP id o12-20020a92dacc000000b00224baf7b16fso2646748ilq.12
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 10:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=IP7asdtdFlXOxOEQ1U/M8uS3b6zpj0naPI5qY7HFuyk=;
        b=oKnF3t92ciDDWWyWa+yZZjmRJqWC9CowcYBYsJB3KlN51q09IRpH5jwfxZs3QuuB4q
         MzeluGk6yID+11DpWrNtSs1VxhoYAqa6tKRv0EDhd4GoY1MKM6QdnlY97Zmi3kiV5MY9
         2nybFk+X1P1F4TQP0RL+gPpkdYP7IVM/6AtxwmOuL8RRyxqci8JH9ScaH3egKzePvbHo
         jUCDzannD611Dg+qGV9dOy+cPlWLMDRsUFzTC13vlglIWUUU+qmsHnW4Sw70lJxyCiUs
         44WewnEpi1cSo9kmyeIeUoc+xmlLpQBlV64c9cL4e5aODalpWtpacSj6HEy1X7JHq5xJ
         BOqQ==
X-Gm-Message-State: AOAM530YE5tlpgHW1nMA6Rqzw+rW+97oq2odqBcMpsYuo/G+PKBfVymZ
        W6JuWaQM9hYYgJ2B6x7LQjdYWuRWcEIspVaNN11VLrNKSH+z
X-Google-Smtp-Source: ABdhPJz8Eh1WAR5J1R4msOtBq6GuxBX1ajRoAfCtPA8fNLrLBK7DYhscYHz2hkMGcWd3N5eUqC3mwBzGD+WrIO8BgUyaftSYHgNl
MIME-Version: 1.0
X-Received: by 2002:a6b:fb03:: with SMTP id h3mr12381959iog.198.1629393907150;
 Thu, 19 Aug 2021 10:25:07 -0700 (PDT)
Date:   Thu, 19 Aug 2021 10:25:07 -0700
In-Reply-To: <da19f91c-1257-e6b8-7fc7-7f852a489cd8@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000008f3c605c9ecd545@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in tctx_task_work (2)
From:   syzbot <syzbot+9c3492b27d10dc49ffa6@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+9c3492b27d10dc49ffa6@syzkaller.appspotmail.com

Tested on:

commit:         923ffe35 Revert "io_uring: improve tctx_task_work() ct..
git tree:       https://github.com/isilence/linux.git syztest_ctx_tw
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb4282936412304f
dashboard link: https://syzkaller.appspot.com/bug?extid=9c3492b27d10dc49ffa6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
