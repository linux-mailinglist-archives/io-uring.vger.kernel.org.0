Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8D053DDA2
	for <lists+io-uring@lfdr.de>; Sun,  5 Jun 2022 20:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346824AbiFES3L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jun 2022 14:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346809AbiFES3K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jun 2022 14:29:10 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A4412AAF
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 11:29:09 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id y18-20020a927d12000000b002d3dd2a5d53so9692123ilc.0
        for <io-uring@vger.kernel.org>; Sun, 05 Jun 2022 11:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=cOxqeJ/JYbi6sFMPo1alnVEMhCg5I3K/OxKpxuWXTYI=;
        b=7lxRhtgRpK43I4zuj7Mrs0ADIveUDuDw6dmQYdwugHUtKG+CDD8bR9fP5CRgRLhT8S
         ayIdhhSO1ZL4M0iaHB4vyyYnA1fI0dABoawyF6ejtSR7/Beuf+OCKFZJO+mY9wZNU9hh
         ISAhVLqKcBmSX2Zn9mqzBuQD4EGJtlSpoFWp98hRA7l28e6PdL0Ej9NCYDJMSULmqhj4
         59SI+6An9cG00tRkws/xwKOvNCdGfTqAwZpxr7Cz+mg/gKhDqvUbkBqfwaF/rglfqsI9
         Fk1XQMcBd/PNzJBQjkNbppV1wrGqIC7xXV0fb+8rpQQbRvB9z1SnUptngwSpFRwSMVHf
         J/nA==
X-Gm-Message-State: AOAM533PjJtP7xsnjPhL0zhQ1sIRjve8qmTsMEbu1yyPtdOfKI4KI/Xu
        jePNXN69nfiz5YjrubpbJfMSjMDLb2hFqK5mlzGLncUwBNRP
X-Google-Smtp-Source: ABdhPJyq9YrZ+fId6i8Q08L+Nm7sWYRLuY83ASTXFEaAfmlxLjokGP1QyIr4HShjlItpecypP1C3Nd3mZ90/8AIoQlqzT3E5roFs
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3792:b0:331:884c:d9af with SMTP id
 w18-20020a056638379200b00331884cd9afmr5005004jal.257.1654453748639; Sun, 05
 Jun 2022 11:29:08 -0700 (PDT)
Date:   Sun, 05 Jun 2022 11:29:08 -0700
In-Reply-To: <YpzxhRLKyETOtUeH@zeniv-ca.linux.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fc2dfb05e0b7873b@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in filp_close
From:   syzbot <syzbot+47dd250f527cb7bebf24@syzkaller.appspotmail.com>
To:     arve@android.com, asml.silence@gmail.com, axboe@kernel.dk,
        brauner@kernel.org, gregkh@linuxfoundation.org, hdanton@sina.com,
        hridya@google.com, io-uring@vger.kernel.org,
        joel@joelfernandes.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, maco@android.com, surenb@google.com,
        syzkaller-bugs@googlegroups.com, tkjos@android.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+47dd250f527cb7bebf24@syzkaller.appspotmail.com

Tested on:

commit:         6dda6985 fix the breakage in close_fd_get_file() calli..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git work.fd
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4042ecb71632a26
dashboard link: https://syzkaller.appspot.com/bug?extid=47dd250f527cb7bebf24
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
