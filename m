Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56F53C6F13
	for <lists+io-uring@lfdr.de>; Tue, 13 Jul 2021 13:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbhGMLE4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Jul 2021 07:04:56 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:43976 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235390AbhGMLE4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Jul 2021 07:04:56 -0400
Received: by mail-io1-f72.google.com with SMTP id p7-20020a5d8d070000b02904c0978ed194so14034174ioj.10
        for <io-uring@vger.kernel.org>; Tue, 13 Jul 2021 04:02:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=QhU+r1WicMQK4omfjynROwaD0hxIgZ6hUq3jENUSY5o=;
        b=AKg3ayZI9wzXJaby3gjTPgmsqQyEzslY4Fbgj7ZFg+xs2XTnOeEuq+8psJcf6KEnX+
         uvyyhl0eEIGq5QXKpRmalhyPYWhGlws7iW2F5zA3psnYYqL9R+SschdhGuv5lSIiPzvB
         84jlBbNDoHFdUV+MlnsaMC8gdLnVR9SeTMIKulRh2gnGF6L3SgBWEzv6APbFcOxVeigi
         PYrbbX+cpsy+cI4bSOtlPuvf5Mqgv6a2R/Z6huyVfhwWjClCCrDTIEKhDDeW51HVosBR
         /+JY4se4j0b3TI3uzUJMTxgm5nLewxhxJcFTEOyq73vE9b9JVsLg7ot3vEyucH1MLBAJ
         D6Xw==
X-Gm-Message-State: AOAM533rSFJ1EnS55rTk3puOS6qiO9LwcFNG9C5vxgbcMTcV8ShHMJX3
        MC7/29AulVP/elbfewg5tfMvZo/83Uc/PWXcSkaxmXUEOKCN
X-Google-Smtp-Source: ABdhPJzMq+q3vPQW5aNE1RNIzO4Gb0NMwpl4gl/8IWFtj5s9PlEpBuPn/bgSJCJIL5wYoiNxnDx4exNYoDCYFAHZLFI3aqNtw0vS
MIME-Version: 1.0
X-Received: by 2002:a6b:da10:: with SMTP id x16mr2725486iob.48.1626174126826;
 Tue, 13 Jul 2021 04:02:06 -0700 (PDT)
Date:   Tue, 13 Jul 2021 04:02:06 -0700
In-Reply-To: <d4edc90a-23bc-34b3-4490-03cce2846283@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002c2e2305c6ff2b5e@google.com>
Subject: Re: [syzbot] kernel BUG in io_queue_async_work
From:   syzbot <syzbot+d50e4f20cfad4510ec22@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+d50e4f20cfad4510ec22@syzkaller.appspotmail.com

Tested on:

commit:         66af6ccf io_uring: fix io_drain_req()
git tree:       https://github.com/isilence/linux.git drain_fix_syztest
kernel config:  https://syzkaller.appspot.com/x/.config?x=77d8505826d1a1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=d50e4f20cfad4510ec22
compiler:       

Note: testing is done by a robot and is best-effort only.
