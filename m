Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160E35047EB
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 15:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbiDQNjs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 09:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbiDQNjr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 09:39:47 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EBE26F8
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 06:37:11 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id i14-20020a056e020ece00b002ca198245e6so6579501ilk.4
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 06:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wA0FmzGAcRTrX+FnNeAVQOC1kod7R+OPRg+GRTVqKh8=;
        b=yKiSETRYVkwFdsVU9ncAdu9dcXg3ZQp16N4CmlsxSGWlihGlmvWpotlcntbe0f/9s2
         OeKjQXAi/W/J1znHR9wBGEDciwXhlRWW0o3ajNK2hiA539fj93FCTc+TG63stqyuONzk
         2eGuF9wVfc38KKsZqYc60i1BoV2jHsYE0r8cdfXG/uARRO37h3QhiSfFXKOCWHdjk/ie
         fceYyBIjU+825f9Kpf7IMER+fq5k7bbxiC1C4ZgNXK2r6MMugy+cO+kj5Mak+oKVl/Kw
         JB/WZkqgJri8TYPjOAvXHqfssR2LCQRPQeJgthqxyc4w+RBQdLW7BzwiaFx/bM2PXkfN
         ebig==
X-Gm-Message-State: AOAM530bJ+e5ibKStxyDcxecA1NHSZ0z0sILqIUT4x5PcGJ9p/9imwJs
        ehjgHJMbqb7MwQQ73P8q/iQEN9CrxLMEOJucnV+GlIB9Z3fb
X-Google-Smtp-Source: ABdhPJzu8m14N1MFCoEmHDFz6ieSul9y+/6ERhmpPdxdOihDx3wppwzmzdQYIcOP91/UdZmPr8NDfGWK1J1CtfWUls48flDEJ4tM
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:214b:b0:2cc:1c95:8198 with SMTP id
 d11-20020a056e02214b00b002cc1c958198mr1316033ilv.231.1650202630786; Sun, 17
 Apr 2022 06:37:10 -0700 (PDT)
Date:   Sun, 17 Apr 2022 06:37:10 -0700
In-Reply-To: <6ab618f8-f88b-0771-a739-04cd9cdc1a3c@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009d92dd05dcd9bd1c@google.com>
Subject: Re: [syzbot] memory leak in iovec_from_user
From:   syzbot <syzbot+96b43810dfe9c3bb95ed@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+96b43810dfe9c3bb95ed@syzkaller.appspotmail.com

Tested on:

commit:         c0713540 io_uring: fix leaks on IOPOLL and CQE_SKIP
git tree:       git://git.kernel.dk/linux-block io_uring-5.18
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8f1a3425e05af27
dashboard link: https://syzkaller.appspot.com/bug?extid=96b43810dfe9c3bb95ed
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
