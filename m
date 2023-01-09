Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22359662F94
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 19:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbjAISzX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 13:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbjAISzW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 13:55:22 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA6026DD
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 10:55:22 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id i14-20020a056e020d8e00b003034b93bd07so6705354ilj.14
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 10:55:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hZ2myS91auaAPOzUbacG8wfmkGsOxK+7+KK8Wi7uEtk=;
        b=BxhmCSVcK8VoWJrpcU2FdU56rA2GfnU/p4QUQiphBgxRiR7ojE/wnkw22cZ5RiMCAB
         OX1FpKz0fwqMrbXZm+Ss/sKjY8exs1dh3fMyVp2/gLGWZEJ8hgRvNlA22o7VkJ3stMcy
         ABHsHQux+SF1WmB7dbpGoOQLEiUSXCRk1SioDCnA6qhuORB4MBhLsaOUC37suhsGPNye
         ZBaeCngdA8cNWfsimqi/YTH+WtkP9p6i+VapjYufZfd5h8TvwTc9Lz9fnDEWOqetmPDo
         BLyrREOnSq7oomPzimZmf3bsw+PgRZZphmefcOw3jHa+uqhHr0yCdhmYbxBGAIWQhoKf
         +jOg==
X-Gm-Message-State: AFqh2kpG503FzO0ohxo8+XEdVmad+Rmyg9gaalLkU2BeRLTJllLbfqKy
        re6EOmvmdAKmATOpSbjPJc6gmskGNAS58W4rof6Y9cmco5aQ
X-Google-Smtp-Source: AMrXdXtmXqKmSIDKVAPjJ4BWYHm/KidAV+MsbsgLKVCZKGN4pDAUj08f5RekwiqOZhBguvx5a47fGiraS5NViND0cXBxZpoQ5/D0
MIME-Version: 1.0
X-Received: by 2002:a92:d5cf:0:b0:30b:b741:205c with SMTP id
 d15-20020a92d5cf000000b0030bb741205cmr6207437ilq.113.1673290521494; Mon, 09
 Jan 2023 10:55:21 -0800 (PST)
Date:   Mon, 09 Jan 2023 10:55:21 -0800
In-Reply-To: <36d665d6-3cd7-ffa8-da4f-1ceb67052ce7@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000023cc9d05f1d94f29@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_wqe_worker (2)
From:   syzbot <syzbot+ad53b671c30ddaba634d@syzkaller.appspotmail.com>
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

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5550 } 2678 jiffies s: 2801 root: 0x0/T
rcu: blocking rcu_node structures (internal RCU debug):


Tested on:

commit:         a4b98579 Merge branch 'io_uring-6.2' into syztest
git tree:       git://git.kernel.dk/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=1490bc16480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b79b14037065d92
dashboard link: https://syzkaller.appspot.com/bug?extid=ad53b671c30ddaba634d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
