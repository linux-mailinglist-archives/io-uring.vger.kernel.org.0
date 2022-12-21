Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCA56532BB
	for <lists+io-uring@lfdr.de>; Wed, 21 Dec 2022 15:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiLUOy0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Dec 2022 09:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLUOyR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Dec 2022 09:54:17 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA8623BED
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 06:54:17 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id i7-20020a056e021b0700b003033a763270so10228903ilv.19
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 06:54:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ncSeTwbLadKn3wNuLy2HS0xfl0a6ATAu3DqDAaOjRuE=;
        b=B7Hff2i1hIwLLIzxGhtHxxejV8N1ueklF7Z53ANIHa83Jy4Pebe23kG+mA8gvHx6Mq
         qJkwAbQdRGPe4cucZxzKAHN6xeahhjxg68gV1FB+z0BBKhCxUhBrJKizKir8p3tsr1Jz
         yWZDDtnQDSRU6Izk7pHneoqnTO9W5STRmQpzDoEQ921VdCM+wfLUHOd+X5wwelqGWFKa
         4FWW9B1I9FNoflVgV5221wUbo1BjBgfW6t61HAdpWUDHBSNvWsWgALnbWIWxT8F6RzkN
         +MVaxhL7fiU+O9JA764hdYHjIirTA9JLJReIiy/pS/kOQPcpAeyFgi1dkUod4C4LTHHT
         aXhg==
X-Gm-Message-State: AFqh2kpkX9hb3AXBeFGHNBsNOx66tkCrZVk7vfzBDqY8oiaIZaT+k0Ly
        3uEkRZhBJ0itDxF/ksAcFw9OAUSxTOKQf3a9+NcLhZJXa7kl
X-Google-Smtp-Source: AMrXdXs5FMQGwFBz4UgYM987y3oY26sjKoRjEu1FX60WJzlzd8Lnkcr9MsN3Cv1OywZHjFSQ+FmvWibKnYZ2feSbNJcpbmnNtL5K
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3487:b0:30b:b488:ff6f with SMTP id
 bp7-20020a056e02348700b0030bb488ff6fmr234459ilb.19.1671634456112; Wed, 21 Dec
 2022 06:54:16 -0800 (PST)
Date:   Wed, 21 Dec 2022 06:54:16 -0800
In-Reply-To: <11a32a29-fbe6-3e00-9f76-36bcd305ea94@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f375c805f057b929@google.com>
Subject: Re: [syzbot] WARNING in io_cqring_overflow_flush
From:   syzbot <syzbot+cf6ea1d6bb30a4ce10b2@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+cf6ea1d6bb30a4ce10b2@syzkaller.appspotmail.com

Tested on:

commit:         d1f53b3e io_uring/cancel: mark task running before re-..
git tree:       git://git.kernel.dk/linux.git io_uring-6.2
console output: https://syzkaller.appspot.com/x/log.txt?x=107ab1c8480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2edd87fe5cbdf43f
dashboard link: https://syzkaller.appspot.com/bug?extid=cf6ea1d6bb30a4ce10b2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
