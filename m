Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6836EF5D
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 20:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhD2SP5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 14:15:57 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:35338 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241100AbhD2SP5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 14:15:57 -0400
Received: by mail-il1-f200.google.com with SMTP id x7-20020a056e021ca7b029016344dffb7bso35702152ill.2
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 11:15:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=r/V3F/1bnZMKmRFzFAEWeq/yoMvyb9wXT3VqY/klpPk=;
        b=NHtepQFtpIs3tMgo6H2huD7WfbYKjxRT94Y/Gcl0ApqGRK3HxAkZZejMKrTtofGDqW
         Q0w616bLiW8GKsMaTXLZ5fn+E3XnNkpsruKbamF4TSmf2mJ7UEmFgQUMVvm4npdw6GAN
         djYDDgj0EzstivBcR2hMFCCOPDvw2XOvPZVdnXtSB+36MMbHkYcwBeIuUecq2dfJnigk
         jxQ32/n4xPFPIYc8wTxHhy5p5tT1ZQzBkTwfM36yYmLYeaYotShSOY2oH5IgkKZLz8wB
         0wdPdiNayvJRT8LJOXD8TTV2jMpW/6hMtM6/oSkqHzIMBZYKbsC0rJaP2aPvXubIlBkD
         43vw==
X-Gm-Message-State: AOAM5335NGV84YvseuD4f2j4Y4W23AmNcyH5mUuFXdFjzs0RRcvA4wYE
        MIOPjCP06wWxBL17+rE/6TBK3spAWdVnrT33TsMankSn6ZOI
X-Google-Smtp-Source: ABdhPJz3StFhNnV44iXyZPONVHe2gH61CmFOR+bR9R3jyr3oDcfWqc6XJwXqpimXGBIbR3inwZ0QiSVjwFQKvxz712vOlhvYPyjS
MIME-Version: 1.0
X-Received: by 2002:a02:ac05:: with SMTP id a5mr1042298jao.89.1619720108542;
 Thu, 29 Apr 2021 11:15:08 -0700 (PDT)
Date:   Thu, 29 Apr 2021 11:15:08 -0700
In-Reply-To: <8eec9ad4-3341-f136-0983-52f3c687f9da@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b48d0f05c1207964@google.com>
Subject: Re: [syzbot] WARNING in io_uring_setup (2)
From:   syzbot <syzbot+1eca5b0d7ac82b74d347@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+1eca5b0d7ac82b74d347@syzkaller.appspotmail.com

Tested on:

commit:         0c8ceb80 io_uring: Fix premature return from loop and memo..
git tree:       git://git.kernel.dk/linux-block io_uring-5.13
kernel config:  https://syzkaller.appspot.com/x/.config?x=3d4238f574736e51
dashboard link: https://syzkaller.appspot.com/bug?extid=1eca5b0d7ac82b74d347
compiler:       Debian clang version 11.0.1-2

Note: testing is done by a robot and is best-effort only.
