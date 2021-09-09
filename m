Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FD4404272
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 02:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348866AbhIIA5R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 20:57:17 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:34570 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348811AbhIIA5Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 20:57:16 -0400
Received: by mail-il1-f199.google.com with SMTP id d17-20020a9287510000b0290223c9088c96so313912ilm.1
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 17:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1rqEkrZfLlbZFMVjLu3WxnoW6fuQQaO6COqDb9D7ihA=;
        b=L2zMN4avoiv7h843T/ZRun5Xv6f1YuVVdgbK26wlNwnb5sPrP4dSot41WWBsyqUgnL
         i/OMhPeHbZOs1uBrC31M33I/sF+2KbMnprMZGoE9KrTwqw5QCdA6R85O2rButhIXqF24
         k5/E/22CsCzxd67mgZvr9NJWtdn7880qxmq5ZkC+AYtaHIggvjGUHJqhqGYsYTnO2Pqz
         6suCHcakw3F06Mx0EYLo5gUM3dAZ9JNvjcqUBWCstBK0goSVeY57baE+uM+CuFp+1IF0
         MWpFJapKGV3Ek4rug3deA11gweTrKlfoBxXWVdVjbrSHKG9yYA4pQ9UiV4LXtOLuhvq+
         SGAQ==
X-Gm-Message-State: AOAM530wetKaGmMHvR3Byx2F7dUqF/RExqBW0ljG+44tNLdy8p3FJ8e+
        AI1jn/Ow6H4zhvC3XNah+B6SvYhOY/UsE3wNZA0zhTOC6Bot
X-Google-Smtp-Source: ABdhPJwrvx/OBoqSlMgQCtxiPhSXc/a63Cq70bYPiOz3kuHakcizjVsAXGVS1e5fCnNZ8t6xmOSAFultwQMqsqPwQ/EtD7w0Y/w9
MIME-Version: 1.0
X-Received: by 2002:a02:630f:: with SMTP id j15mr357790jac.62.1631148967991;
 Wed, 08 Sep 2021 17:56:07 -0700 (PDT)
Date:   Wed, 08 Sep 2021 17:56:07 -0700
In-Reply-To: <3ba69d23-26d0-9c94-bf9d-a0db2bef2ed4@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d0227205cb85760c@google.com>
Subject: Re: [syzbot] WARNING in io_wq_submit_work (2)
From:   syzbot <syzbot+bc2d90f602545761f287@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+bc2d90f602545761f287@syzkaller.appspotmail.com

Tested on:

commit:         c57a91fb io_uring: fix missing mb() before waitqueue_a..
git tree:       git://git.kernel.dk/linux-block io_uring-5.15
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9bfda6f9dee77cd
dashboard link: https://syzkaller.appspot.com/bug?extid=bc2d90f602545761f287
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
