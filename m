Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39EE7653BE3
	for <lists+io-uring@lfdr.de>; Thu, 22 Dec 2022 06:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbiLVFwZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Dec 2022 00:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiLVFwY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Dec 2022 00:52:24 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161662D7
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 21:52:23 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id n15-20020a056e021baf00b0030387c2e1d3so600599ili.5
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 21:52:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e0HQGrdqJixrhdOrjNj9VTj7M2P/qvbFLcOLscg9OvY=;
        b=UBDoWv57NO4um6XSAafZCOl2OdQ0oOzc+H4iNikAd+mO5zxVOq15JY5tPQ0X13V3Q4
         LDFDZOhppREBi1sJIjsnC0afkN0Br5t1khWqyxcI0+7noaBcV6xtyy/ylAnHG5NwnHcE
         mM1ex6B+n0G6CxNquoJTdaWzm4PpbGaclYP4W2ydeUOGe5eQwFIQQkJSTjdT7+YpmoLO
         FvCN0pt9tWZ0TfY45fGFDPrk1Qk1xqMbSfcH6MO2uiu88QViWc9cIujRhxPRemzRuLaw
         n+l/EulykLJJvBY6aWrxSpCWfBO6nkf9Axs2NNB7nwPNU2ha4RMitiweipNQBRIhTwqa
         i5vA==
X-Gm-Message-State: AFqh2krJIIbRYlyLGPvII77kU+VFACwU2ybQvTJKn7ANZKZoZeNxcsnb
        gNSUuJ5jQGiXyaLd0qI34WcI0dlh2LhsJdna7nkm75B306e5
X-Google-Smtp-Source: AMrXdXvP6OVOCDeSRwhm8Qt0v/xnV3oCy2eqg9BSp87fwiPJmAjz7Sj0sURWcN5gDtVAxphpoKq/J1+ppbDOW0JX/prJSpEaBtak
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d8f:b0:30b:df09:de12 with SMTP id
 i15-20020a056e020d8f00b0030bdf09de12mr84538ilj.244.1671688342447; Wed, 21 Dec
 2022 21:52:22 -0800 (PST)
Date:   Wed, 21 Dec 2022 21:52:22 -0800
In-Reply-To: <0021f079-0d7e-0c51-64ad-9d9d17652e88@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3af6205f0644515@google.com>
Subject: Re: [syzbot] WARNING in io_sync_cancel
From:   syzbot <syzbot+7df055631cd1be4586fd@syzkaller.appspotmail.com>
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

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5772 } 2680 jiffies s: 2845 root: 0x0/T
rcu: blocking rcu_node structures (internal RCU debug):


Tested on:

commit:         23fffb2f io_uring/cancel: re-grab ctx mutex after fini..
git tree:       git://git.kernel.dk/linux.git io_uring-6.2
console output: https://syzkaller.appspot.com/x/log.txt?x=15bf7bf0480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2edd87fe5cbdf43f
dashboard link: https://syzkaller.appspot.com/bug?extid=7df055631cd1be4586fd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
