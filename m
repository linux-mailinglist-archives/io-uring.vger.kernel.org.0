Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4935A4EE158
	for <lists+io-uring@lfdr.de>; Thu, 31 Mar 2022 21:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbiCaTIg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Mar 2022 15:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239933AbiCaTID (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Mar 2022 15:08:03 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD58221BA9
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 12:06:14 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id y19-20020a056e02119300b002c2d3ef05bfso378271ili.18
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 12:06:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=r/0Q/v7LxnQii6Wat+1eXZLZ1gIDdS2hR5mCVVjGKVU=;
        b=aUhGWJkQwW3TPjC49+TJmOJ0L7O8FvSWKiPMzff0Nb8R5wgMcOHljusl2aEt8ktS2F
         VbtVMJsa+FJFJME10uCuuyO2lnbFDwcLEI7B5Gd1sz2pVsztMvAf4sMVwAQQG5vY906F
         vOJHpQNZ7JgJKrZkrh7eUUmhO81g3l22yOXhzy4+xIgMSla1C3nTOFSPGLyxkGuHvcfs
         2RuNX847XVuNzsarDnu23PnOm+GK9p6b8r/eie3XSM+Ml7Sf5h7beLxE7Ds4P99WVyPe
         j1b5ITOnXMk16fIEFcfKkx86/VcZir67gRYfokA+ztBx/pur/hejxPgizXSx6eq7cqvh
         WJcw==
X-Gm-Message-State: AOAM531Hs/X0W2imoIPmTStTusYce644cc0pEOUlVLeYQLRSUd0FMvy8
        L6BhFeACzOCmWXx5I2wLC2YgZtQa57RG1rYCBmy2Ltysh1pd
X-Google-Smtp-Source: ABdhPJxhLwKFZ45jya0LVhjew/uXFv5NxVPTM0yGlD2OYJVrGpYWtkpe4WTktB5ooY57V7udWcsSpk1vZJPjYdvTK/6ygZ7oJpx1
MIME-Version: 1.0
X-Received: by 2002:a02:b10f:0:b0:323:9bba:a956 with SMTP id
 r15-20020a02b10f000000b003239bbaa956mr3701828jah.313.1648753574205; Thu, 31
 Mar 2022 12:06:14 -0700 (PDT)
Date:   Thu, 31 Mar 2022 12:06:14 -0700
In-Reply-To: <7f56f140-ecf0-d72b-b891-171a0aaf21ca@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001ce19705db885baa@google.com>
Subject: Re: [syzbot] KASAN: null-ptr-deref Write in io_file_get_normal
From:   syzbot <syzbot+c4b9303500a21750b250@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+c4b9303500a21750b250@syzkaller.appspotmail.com

Tested on:

commit:         9570a845 Merge branch 'for-5.18/io_uring' into for-next
git tree:       git://git.kernel.dk/linux-block for-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a82c1abd4cbb9ee
dashboard link: https://syzkaller.appspot.com/bug?extid=c4b9303500a21750b250
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
