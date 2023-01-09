Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFCD662F5D
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 19:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbjAISlW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 13:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbjAISkm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 13:40:42 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5300D20C
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 10:40:19 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id g1-20020a92cda1000000b0030c45d93884so6685997ild.16
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 10:40:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vdozkht3DNskI0+rKd1YxGtR1GDDOg/Q1E8DUSg+rBs=;
        b=L4HP3W9r0jwPc077a2etVR/WukVR+4mGkdQbBRpygPyP4BqmYMKBA3/upPxyi88en7
         RQl9Zs4zLkmR6DPi748qkwa78gLjYgbjZwHXP4nLgsT1FvDH3ejJWYSJiK1rj4VYTL52
         YsjBqAPDa1SabvlrlyFvSk8vEGyXVhG6uNAvCK5XRjYRx+cOW7MIroqypdB+vZ7pWMtp
         JNvBrLH8oemGFNNLJVsU6fLd4l1dc4bXAVzm+gAyaiddh1cMJn3d4tuSoLhxa4jMvVrD
         78H0C3TijWwvDH7iDKW8NSL+1qa0Bbx/TRv/OG7LG9jsoNTYMYrfHvc+seA/js54EDJy
         uJEg==
X-Gm-Message-State: AFqh2kpmEy9JGnVFQDOIUVHgATPg52wQyozkBMPXsii1NuFk8Cf7QGuF
        PQYcAFZmAgM9ueMeKuGeCcymdn2tb4HbP05tbTGey68/Whe/
X-Google-Smtp-Source: AMrXdXt7Be4Hz9M5A+G9mfuyePIMJEOaigQw+rzHzModFUXa6OvX+N+Xndq1/IUECbf1mo6wYEYin+Nr3miqQbpAY8V+Qi8Vjx1b
MIME-Version: 1.0
X-Received: by 2002:a92:a007:0:b0:30c:1ec6:23d0 with SMTP id
 e7-20020a92a007000000b0030c1ec623d0mr4343045ili.134.1673289618727; Mon, 09
 Jan 2023 10:40:18 -0800 (PST)
Date:   Mon, 09 Jan 2023 10:40:18 -0800
In-Reply-To: <3b08247b-a645-db6a-aa20-ba77766730bc@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000054ace405f1d919f3@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_worker_get
From:   syzbot <syzbot+55cc59267340fad29512@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+55cc59267340fad29512@syzkaller.appspotmail.com

Tested on:

commit:         a4b98579 Merge branch 'io_uring-6.2' into syztest
git tree:       git://git.kernel.dk/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=165136a4480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=defbee0450ed9648
dashboard link: https://syzkaller.appspot.com/bug?extid=55cc59267340fad29512
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
