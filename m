Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260D66689BA
	for <lists+io-uring@lfdr.de>; Fri, 13 Jan 2023 03:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjAMCvc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 21:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbjAMCvY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 21:51:24 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E676959F9E
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 18:51:18 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id be25-20020a056602379900b006f166af94d6so12441263iob.8
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 18:51:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4kHpmFrlXNh10xHxDPEpwrHdPzPE2XyL+lKjHsMt0bk=;
        b=aUqM9HkczmUb/lD6v142U4tff1VUz6vrXMPqiNoWv5O6YU1X5pMS0/pPwAJnnhZzOm
         8OUqCMibaq8oLhqMR2zk1fsZMTrSNsWdH2GPs8oPefZRqhO7goGsSvk7RDqG6Z5qEpzQ
         MHIHJh/DNn9xGmG1422Kj8xTinCte/n0b4SeiMssB3QRo6FfRlNqPjVDjr+kIqgpVYgb
         xcGmOMDZQyb7yCWYV4r4LAVtco2cdkJ0wpQIYjqz0EVuJWfoz8lmssC0KrZhFxxl5ZBj
         XJNmM2bMKGxmKHpPFytzVpEh5CYM4DY/V7/6wd/tDegTzBwQbPQbM2Ps1PI/qMDfL/73
         eMoQ==
X-Gm-Message-State: AFqh2kpqixzBHRzLGQZa0MCGMtBe+oqa2WTu8D00rAxd678KQUuBzsTO
        wiQ8rraadIDP4ZumK0Y19rfYI90x0QevLTExFLxdQHrVaH4D
X-Google-Smtp-Source: AMrXdXuQpLmbHOvL5SrId88JUPVFYPBRH7F8fF7X4NcoS8UFWJlXQ70LUW9hQmi8sZe3CB1wD2GcxzPd8gUX64uH9g17YUBGxLmW
MIME-Version: 1.0
X-Received: by 2002:a92:c0c4:0:b0:30c:46af:56fb with SMTP id
 t4-20020a92c0c4000000b0030c46af56fbmr5681253ilf.12.1673578278270; Thu, 12 Jan
 2023 18:51:18 -0800 (PST)
Date:   Thu, 12 Jan 2023 18:51:18 -0800
In-Reply-To: <746dc294-385c-3ebb-6b8e-7e01e9d54df5@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c7bf6a05f21c4e23@google.com>
Subject: Re: [syzbot] WARNING in io_cqring_event_overflow
From:   syzbot <syzbot+6805087452d72929404e@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+6805087452d72929404e@syzkaller.appspotmail.com

Tested on:

commit:         7b9484d4 io_uring: lock overflowing for IOPOLL
git tree:       https://github.com/isilence/linux.git overflow-lock
console output: https://syzkaller.appspot.com/x/log.txt?x=177064a6480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5bdd5369dfff2192
dashboard link: https://syzkaller.appspot.com/bug?extid=6805087452d72929404e
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
