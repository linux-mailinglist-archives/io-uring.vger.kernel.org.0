Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388D54E58A7
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 19:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbiCWSso (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 14:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbiCWSso (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 14:48:44 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A4889334
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 11:47:14 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id w25-20020a6bd619000000b00640ddd0ad11so1660616ioa.2
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 11:47:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=pYu8i4bCyQkvLkE2p2XwJd7jMwp1xPlmh43gdxxjfcs=;
        b=j+0F4AnWRsw1ExdB4rydrjZz4YbowK20K+nSilt3wp0Rsl+0URM1mm0lILuCB4yGJu
         ZXwx1RfI98K7EcS+pib2YrtV7DWH76IEFjcHAQn5K2zwgtwLdyJr9Gn18YRixaPp/w0y
         VaAE71L2Cnq0ZCZ/oMG+v/cmFXu8YTr0ry2qpc6kiTw2b74sC4XZdMkH9JFVlfyKx30b
         sc/KcdwPG5E+k//g+zUIaNSNOckgH1/dYPXsPa0mzjN1Zbi4dIiXnUPH9LKGM+mJc7kH
         GDUwRe4fyEBBeByN5qpiNRpCEuGERvrMzXCmXZAT5U0IZLv/38cPMmaMYM+xq2oMJ2M+
         CzqQ==
X-Gm-Message-State: AOAM533dPuXsAmXTbi9KlFnxBNKIx7UMwa92VZl16T01JGPFhOXJVQLN
        JjdnzfMsWeO1Tss4ovAs9FZu0+FLgJG+7o79clpYjdRfbyok
X-Google-Smtp-Source: ABdhPJyBbjyelOm6XZrSiqfFQ4vxrm4HvKy9Vh/Bx4jgt2Ms1B6Km+omLeQZEYQAxGGY4jCyHzAymP+ofR1jf/WmN1zVDe0wFM6d
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1655:b0:319:a174:6ba0 with SMTP id
 a21-20020a056638165500b00319a1746ba0mr722356jat.195.1648061233677; Wed, 23
 Mar 2022 11:47:13 -0700 (PDT)
Date:   Wed, 23 Mar 2022 11:47:13 -0700
In-Reply-To: <000000000000a0506305dae664f2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000066cd8205dae72838@google.com>
Subject: Re: [syzbot] general protection fault in io_kill_timeouts
From:   syzbot <syzbot+f252f28df734e8521387@syzkaller.appspotmail.com>
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

syzbot has bisected this issue to:

commit c9be622494c012d56c71e00cb90be841820c3e34
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Mar 21 22:02:20 2022 +0000

    io_uring: remove extra ifs around io_commit_cqring

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a04739700000
start commit:   b61581ae229d Add linux-next specific files for 20220323
git tree:       linux-next
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17a04739700000
console output: https://syzkaller.appspot.com/x/log.txt?x=13a04739700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=def28433baf109ed
dashboard link: https://syzkaller.appspot.com/bug?extid=f252f28df734e8521387
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117d3a43700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15538925700000

Reported-by: syzbot+f252f28df734e8521387@syzkaller.appspotmail.com
Fixes: c9be622494c0 ("io_uring: remove extra ifs around io_commit_cqring")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
