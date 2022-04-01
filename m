Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3F04EF729
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 18:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbiDAPyg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 11:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355700AbiDAPY0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 11:24:26 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A7D261DE4
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 08:04:10 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id g7-20020a056e02198700b002c9f4289eecso1958218ilf.13
        for <io-uring@vger.kernel.org>; Fri, 01 Apr 2022 08:04:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8yOa6HuejIm3U0gNOJjgRXpDANw22tjwWXr0RnAzX2s=;
        b=NinvqCYLWRsbj1rltfTmtuqkxh4bV6m3OX1tP3CEouatfmktkjytka7SO1PaiWn10c
         Zy79AxUGz3PS/FPf/hvOj3ioN50V7UPY/yOme1MmQysKBuLMyxnNyYNI0uh6OvmiD86c
         ObrWLle245C8KEoHo6dy6VordDlUjLtDO2G8ATWuxoB16ohGBaZD2l3JUR4sXMivV7nj
         6gNYCL8jTVmNHvkauAcul80jteiAV5NGnIba3u1S51Z7UiTnvs4qP0OagKCFHixKTRzF
         c77BNlhHWh3tMoMTSSRRJmZ9d9GhOryZ6lxaxMTjWJYCRJcWUA9MQWriubxYJpr3cODd
         zi9g==
X-Gm-Message-State: AOAM5318C4613CR4v2+y72xR8v1wkIOpt+YdqdpcPd+d/7ZeTJ8Wny1p
        41ro3Zdjs3IE41iI2LzG/upldrQk9G4cB73RjSiex42jRZYm
X-Google-Smtp-Source: ABdhPJxa9ojKHbnUmgR7t9lYZnxwOCkuUIvhZfL6KP42GkZa8nGSHMXgp/UMJ4S1OFAapqRreVi4WGT3Y3CqCnKT2X6BNLVTqxkj
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160d:b0:2c9:eef2:3a28 with SMTP id
 t13-20020a056e02160d00b002c9eef23a28mr102625ilu.306.1648825449333; Fri, 01
 Apr 2022 08:04:09 -0700 (PDT)
Date:   Fri, 01 Apr 2022 08:04:09 -0700
In-Reply-To: <d713dcc7-cdae-0834-f10a-c3cdcb6fa301@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000350bc805db9917de@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_poll_check_events
From:   syzbot <syzbot+edb9c7738ba8cbdbf197@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+edb9c7738ba8cbdbf197@syzkaller.appspotmail.com

Tested on:

commit:         787c2499 Merge branch 'for-5.18/drivers' into for-next
git tree:       git://git.kernel.dk/linux-block for-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a82c1abd4cbb9ee
dashboard link: https://syzkaller.appspot.com/bug?extid=edb9c7738ba8cbdbf197
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
