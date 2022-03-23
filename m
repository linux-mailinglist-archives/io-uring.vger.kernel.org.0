Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC984E5BAA
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 00:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345420AbiCWXHq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 19:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345404AbiCWXHl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 19:07:41 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648939027C
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 16:06:10 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id z16-20020a05660217d000b006461c7cbee3so1957432iox.21
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 16:06:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=BPG9xBXVtHI7SqOcph7aAXtFUuz1YLWujJpqciFjI9s=;
        b=ihsD8A8eurr6vNYvGsSsBj9axPkM574f4n4dEGMzLK/eIQ0YU9gqmDF2Sf0eZ+Nc2h
         J8zF4/gD0wcSzTliT92S/uCqoblmo3eq+LzaHGZbuO593fsCTEvyxYVfuBCLdTwiG7j3
         E3jqOg2StqSmjazlHSmiQnu0Pb/U07y2ZiJ/UjEg8R94yWNXUdLKOgx96LOQem6/hbDA
         NPhdPcJAQWuhxPlKwqvj4gLWMcPKwKrVIR03eUaVGtL0guXFwPjo9RRAN+A/TWIMUrfJ
         1s4u2KsylahH/UpyU0LSQ21Bu9LCdHRHmDPSWHl+TA1UDddt5e5YSp8wKA1xiVYclc0g
         DkSw==
X-Gm-Message-State: AOAM533zWSB69DFh22sb6apsBr6BvPEUAFxpdad7olOFs58GTuW40ldz
        t7GwGBkaXuMxfFEmdmnKnGoq3eouMnLnHc6y99B6QlRQaY+L
X-Google-Smtp-Source: ABdhPJzW2hn6snXH4MD7PSQws9/2DRz6Xvw5AA+D5cJZRJZNriiYKzLQAWzd4d/nPqH37ZkTIQ41c21b7hthlOKbtjxJRGPTDpXK
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3711:b0:31a:e158:21ae with SMTP id
 k17-20020a056638371100b0031ae15821aemr1224335jav.4.1648076769765; Wed, 23 Mar
 2022 16:06:09 -0700 (PDT)
Date:   Wed, 23 Mar 2022 16:06:09 -0700
In-Reply-To: <fa4d06d8-ac33-07b3-de75-3e7512f0e41e@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006cac4e05daeac6e0@google.com>
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

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+f252f28df734e8521387@syzkaller.appspotmail.com

Tested on:

commit:         8a3e8ee5 io_uring: add flag for disabling provided buf..
git tree:       git://git.kernel.dk/linux-block for-5.18/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=173877d7a6cb7387
dashboard link: https://syzkaller.appspot.com/bug?extid=f252f28df734e8521387
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
