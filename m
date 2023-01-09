Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4278661CD6
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 04:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbjAIDrS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Jan 2023 22:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbjAIDrR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Jan 2023 22:47:17 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C64388
        for <io-uring@vger.kernel.org>; Sun,  8 Jan 2023 19:47:16 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id t3-20020a6bc303000000b006f7844c6298so4179746iof.23
        for <io-uring@vger.kernel.org>; Sun, 08 Jan 2023 19:47:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E6PSNSHuzrJBJ/47W8KvJu4qLfm98K6cE9rADnwjx6Y=;
        b=0xBA0TaSVx2F+CA5QdSYef89F5Ur4cmtcOjg/CKNrJNl5dEkeKFyaSfCakFxmYIMSK
         I+R8U4n2wfZZ2sbAoRth6G9luhXT5yS40O6gW9Kj5Catf5K0otYeurdyb5GJSzpiwZJr
         GAA80s4jnIDxyZczS1I42+86cDhRsIEIiG4DF3gLsM5MCps52a/FcRK84hl5jP7TFnDa
         x2yWzb97KJfi7gjvHZQVAvK2BjIb19wqyWxEK1NRH92gu/rFRs4Hkhsr9kM5JH+3Z81N
         YChw6V82iPEfPJwLZGir0IrVSbL0gzXRxR90drPqE+Q994qnBg4CKwr0LphJrQbwy9IQ
         6njQ==
X-Gm-Message-State: AFqh2kqVNoc2HlcAuBFHSewdfrvJQW7MYo2J97LWxfN6F0hD4nGx8SLa
        C1HMOe0HFW7jCYHmFnJpnvcZzPzl7BLsCzDVY3X+c7K6M7xN
X-Google-Smtp-Source: AMrXdXvi2iDuNkvMJihht1FzczeqZ0AFlaBPeGXZ1mRxRpJ3AGgVatdbWS7VO7fy12IupJ4K0R7vk2GFTp6TstNz2IVpsPGEoeta
MIME-Version: 1.0
X-Received: by 2002:a05:6638:60a:b0:363:ae32:346f with SMTP id
 g10-20020a056638060a00b00363ae32346fmr7177789jar.31.1673236036189; Sun, 08
 Jan 2023 19:47:16 -0800 (PST)
Date:   Sun, 08 Jan 2023 19:47:16 -0800
In-Reply-To: <df7cb4c5-eae8-1aa4-2c1d-4cbf3c651c1a@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000090056605f1cc9f96@google.com>
Subject: Re: [syzbot] KASAN: wild-memory-access Read in io_wq_worker_running
From:   syzbot <syzbot+d56ec896af3637bdb7e4@syzkaller.appspotmail.com>
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

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: rcu detected stall in corrupted

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5561 } 2648 jiffies s: 2797 root: 0x0/T
rcu: blocking rcu_node structures (internal RCU debug):


Tested on:

commit:         a4b98579 Merge branch 'io_uring-6.2' into syztest
git tree:       git://git.kernel.dk/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=17668ed6480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b79b14037065d92
dashboard link: https://syzkaller.appspot.com/bug?extid=d56ec896af3637bdb7e4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
