Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22D6502127
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 06:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349327AbiDOEGf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 00:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349310AbiDOEGe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 00:06:34 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA96AAC8B
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 21:04:07 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id x16-20020a6bfe10000000b006409f03e39eso4216736ioh.7
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 21:04:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=GOM/u/LjYywzIfgQEbQmUfvSEjGD9tJ5Gw1F0/rgW7U=;
        b=cgkJ/CGjoCVCKiPXKgM4e6MOQ0mzGww4QiZ3KA6wYT1O+OT4H5j2coycOg0/7Qr7ct
         5X78GRlg1pHK01FEaag8uIIy5NlPsE+0KZIC32AfPd33EfIy8uA7bq0+AlAkvNcZbytP
         xGSNvnkbB/0n1yziZt/RFMYm9AuJjcK8/uOoXvMxBFpnd+EkjH/u0lOXvOvr824U+z5O
         FuuiTex461086OtcwZIC2pTrombPJTe41YMJ0zBPXjU7Edk0v81RvlG8VkpzK7l5iy+j
         ojgUPYX8MnDhbVO9sbDHQnWDtR+aQzh9OzmfMLr/r1HbLZtZQzNe7Ivp9KhcUVV4jmGM
         N6yA==
X-Gm-Message-State: AOAM5301C5l3poLkh0XsDU62wlGZMSgcgb8gORzTBJZEoNIsSWysYd4R
        5qC2rL8j2UIslt6/FKHXU+NBYeLRjyIlZkC+S26QvL4m/K6X
X-Google-Smtp-Source: ABdhPJw43wBjC+s6gCr8+BHHrKq5QX38deICyV9LuvBjQTDqr8QEpp3b9kxO6bRNBDo5jzXDiHROM8noDKB/FBRT5WnYRAELj7O0
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3c5:b0:64c:727d:6e95 with SMTP id
 g5-20020a05660203c500b0064c727d6e95mr2731705iov.118.1649995447343; Thu, 14
 Apr 2022 21:04:07 -0700 (PDT)
Date:   Thu, 14 Apr 2022 21:04:07 -0700
In-Reply-To: <c122ba3e-ef7b-0f70-1972-1bae0ddff651@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000851e4705dca980e9@google.com>
Subject: Re: [syzbot] kernel BUG in commit_creds
From:   syzbot <syzbot+60c52ca98513a8760a91@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, ebiederm@xmission.com,
        io-uring@vger.kernel.org, legion@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
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

Reported-and-tested-by: syzbot+60c52ca98513a8760a91@syzkaller.appspotmail.com

Tested on:

commit:         70152140 io_uring: abort file assignment prior to assi..
git tree:       git://git.kernel.dk/linux-block io_uring-5.18
kernel config:  https://syzkaller.appspot.com/x/.config?x=eb177500e563582f
dashboard link: https://syzkaller.appspot.com/bug?extid=60c52ca98513a8760a91
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
