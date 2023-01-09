Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40DDF6633B9
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 23:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbjAIWM0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 17:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbjAIWMZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 17:12:25 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85B71EEDA
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 14:12:23 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id 16-20020a5d9c10000000b00702de2ee669so5186438ioe.10
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 14:12:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DTUK3cZDq7+5e5U091ru+GvF8C+iMdCzHADni7W4eDI=;
        b=f7VOGbMMjLvJH0E/iisQuzWYmeJ6dhtJW+2ZvjjTLkWwpbI/TSlPZKh30U2RrKLERg
         avtPCFzDXzAPe42lGak9hy278wwfdyPCNunQyZW8scv/5tISQB6WEClDbRNP8T1ILpFF
         10Jz7GCDejOaq8WUYtRQrXr2N1Up3AZigI8aQvBke2Ynr3mK5Rm0WuPO0gkO5Lv0ruPY
         SkKgQwZiNHREq58zW7vTORJ+1JfdCFXavtEq4o6PR/L69FaeN89UcuL5dJqR1GH3mqOO
         gKawlHfQo9oPjsC3d81QeUznDzaSx43MxDyDQeD9EA6xzw4bTGsVlqB1O3fgCKKtU1hX
         aJLQ==
X-Gm-Message-State: AFqh2kqpKh8Q8BeMkENQDnYFRc0bU7ZWFMnOyXG0mM3tMjyC9F2MxtuD
        y5VU2a2uBKpaHnh0IavlceXPw+o+gX0+KRCfGU/msrfFXJ2b
X-Google-Smtp-Source: AMrXdXt22QvHMfgLmlMKJ4fSPICEnPJL8xHSmNJ/v5/CvyV6F7eDLPbLBcUQgUfuus7Oa0Foa7X9MTvgJeY8H6S/U9vanvNTKuMu
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:927:b0:30d:96b6:5cd2 with SMTP id
 o7-20020a056e02092700b0030d96b65cd2mr1750200ilt.31.1673302343067; Mon, 09 Jan
 2023 14:12:23 -0800 (PST)
Date:   Mon, 09 Jan 2023 14:12:23 -0800
In-Reply-To: <e3029146-e399-aaaf-6192-2af8f1c1e131@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c2b1b505f1dc0f10@google.com>
Subject: Re: [syzbot] memory leak in io_submit_sqes (4)
From:   syzbot <syzbot+6c95df01470a47fc3af4@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+6c95df01470a47fc3af4@syzkaller.appspotmail.com

Tested on:

commit:         0af4af97 io_uring/poll: add hash if ready poll request..
git tree:       git://git.kernel.dk/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=1105391c480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=72a4287b7f412c8a
dashboard link: https://syzkaller.appspot.com/bug?extid=6c95df01470a47fc3af4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
