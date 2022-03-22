Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6A64E480B
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 22:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiCVVEj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 17:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbiCVVEh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 17:04:37 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F55A13E92
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 14:03:07 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id z15-20020a92d6cf000000b002c811796c23so4326928ilp.3
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 14:03:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=A7UVHLa5gEcZxIqWogg32nPbf3+g0qv3P5D2guYzwY4=;
        b=PNQ+eSckMFLsFfqAosYnfATn6fJ3OjMeXwS6kyi43JXmLZX0O4G5MW0kCpJmoPTpy3
         6gyiv8lZHZ55HChMKPdYg5o5SeePBipVhnIIO2axprAh7E8fB9nLE7Y+tE07db9aSlLR
         pbem9xUOqHYEwBjsyLLCZUMh3zfNEYg8m44rr84qt1eri7hMKbV7UXNY8pg5mH5HADPi
         OoSE+BNZ5LEKpADcae5yM4Sl2bRj80CHarvyexwvCCEsow4+lxeA5z7MZmjm0kKZDrXs
         9hgOncBgPF852SuJQQ9OEg3STa+Bp0O/RD55GHH8f44nXNP4bLA1F6Xo5R4dQI4mulNN
         4Z2A==
X-Gm-Message-State: AOAM533WFNRrErAmkhl5Fj+/LR2jKdUCePBoUrh0vKTLz/Ao+Bgi1pLw
        rUluP81B4OSXNuG9WzaYiae4eYxu5+Kz4ck/J7hKCQF4J63d
X-Google-Smtp-Source: ABdhPJwOfvu/x2/eqvCqjcEw4w1ZMKJoI29/lmOcDU7xrUFNR8S2tLZ5XFHn2Mb7ejfSZWlcNOOTFpKWGoNgGamzY32N5Dvw4jq9
MIME-Version: 1.0
X-Received: by 2002:a6b:1495:0:b0:645:b115:611c with SMTP id
 143-20020a6b1495000000b00645b115611cmr13475591iou.199.1647982986421; Tue, 22
 Mar 2022 14:03:06 -0700 (PDT)
Date:   Tue, 22 Mar 2022 14:03:06 -0700
In-Reply-To: <0cd64678-f4de-0e30-87d2-01f32311ee98@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000806a2d05dad4f0e1@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in tty_release
From:   syzbot <syzbot+09ad4050dd3a120bfccd@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk,
        gregkh@linuxfoundation.org, io-uring@vger.kernel.org,
        jirislaby@kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
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

Reported-and-tested-by: syzbot+09ad4050dd3a120bfccd@syzkaller.appspotmail.com

Tested on:

commit:         7d58de1a io_uring: don't recycle provided buffer if pu..
git tree:       git://git.kernel.dk/linux-block for-5.18/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=e8bdba3010ab9145
dashboard link: https://syzkaller.appspot.com/bug?extid=09ad4050dd3a120bfccd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
