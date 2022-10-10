Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404DC5F9EBE
	for <lists+io-uring@lfdr.de>; Mon, 10 Oct 2022 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbiJJMcV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 08:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiJJMcV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 08:32:21 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D669BE24
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 05:32:20 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id a17-20020a921a11000000b002fadf952565so4945533ila.0
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 05:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0NY4FKPwKQuedItLVi3ddA8KHRf2/cnLfGSPTAj8X78=;
        b=Tx/QD5r0RVM4mP5WKmXyl4t3VTaY0W3Lz32yv5cScCH4gVT0WKGgaSge08wrzvsGip
         Vd2kz9sk8Fc8BRD/BqxIea2nuaj9iRU1nHTlieha+PWSDO/1iHocn4eoxh9WDESMTEXg
         Q3mbcS1xEYbqvv9rdHpulD/gQbguQUtbpGZgOzJEjrr1jl1uyEYj55rsp5Dq2lz16YpP
         3ZuVBkTwt0j88iEzSOcHwZYgdLwedMrnx4rG+2+Kh3ZUmjpdLmOkgfADd0dGm8tNQqPD
         lStzK7MpQiv3mhN8BvEmedw+BBzhKoqpVsR4r2DeJwV1l3o0vlcLW56xREyqMBY5qFY5
         rYsg==
X-Gm-Message-State: ACrzQf03j4kLNQQe/g58j7XAMFGqSxAb7HjNc018bgniXI1qJ+aesDgb
        olXqBTCYCKKzlb+WjOgpX3sxB8GBJHNVsLGrcldA/K8N7ZYM
X-Google-Smtp-Source: AMsMyM5jh03YIS7EmROb7RsFjdg2nj8nmlQKfFmyPjc5sJRkvCc6DgygSncNwKc9jf1QRZdAWY2G5QyVcnaPFD6l8B+I99JJbIZ9
MIME-Version: 1.0
X-Received: by 2002:a92:b00d:0:b0:2f8:ed7d:88e7 with SMTP id
 x13-20020a92b00d000000b002f8ed7d88e7mr8563405ilh.61.1665405139626; Mon, 10
 Oct 2022 05:32:19 -0700 (PDT)
Date:   Mon, 10 Oct 2022 05:32:19 -0700
In-Reply-To: <a88a1cbd-2800-78a2-1651-ebac0736549b@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c1324205eaad5903@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Read in io_uring_show_fdinfo
From:   syzbot <syzbot+e5198737e8a2d23d958c@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+e5198737e8a2d23d958c@syzkaller.appspotmail.com

Tested on:

commit:         4f408867 io_uring: fix sq shifts in fdinfo
git tree:       https://github.com/isilence/linux.git io_uring/fdinfo_fix
console output: https://syzkaller.appspot.com/x/log.txt?x=1529d51a880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b87022a508b2913f
dashboard link: https://syzkaller.appspot.com/bug?extid=e5198737e8a2d23d958c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
