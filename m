Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64591663070
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 20:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbjAITd0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 14:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237640AbjAITdP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 14:33:15 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD53728A9
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 11:33:14 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id l14-20020a056e02066e00b0030bff7a1841so6883662ilt.23
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 11:33:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0v6Ib6qJOu7AodKwwz5adRPHTGtZvi3fgFZeXU6Mq1g=;
        b=bb1RgiivUZ4B5rrOnohiuSBM/eUj80gQ+WWoBCYrWLmRcFC2vH24koxWbiOS09ve3n
         8nzLAITKjwnTWCm+mXS9NigkUjl4IkkKX5GTjBL8dFOimlbQ5S32WcxbVIcEOvSwJNYV
         NQlPrbynAYVEuPsyKZVUiT1MZ1Kt27H0Hnc7kngpm5/ja9eHCaO+lUAdHKfco21zRprc
         LYikNGciU3osK2xutnceHGV+TUZ6rWqejCDsuWVUNTaVrycwiSXFHGPEgGy9hZTmUNZp
         C/LlFksorFUMsrKdfX4GD0Ns9Rvf14zsOQPygnl+Arid7hTHLTnpPWO4RZqULlALZ0sJ
         WJrQ==
X-Gm-Message-State: AFqh2kpJncNtqaB1FRigQ19f4ET8nDE7QOvR8R16HSDz2Nd//tpUCDp5
        87LXR1E5XWyYFqBISiDI28m2QaTx61a0rvvvnEYApFJ8Q8jc
X-Google-Smtp-Source: AMrXdXtWJTRBaXGAnyKbIcz7teP4r7Sn72lncO01Q19pK+qT/LSLqQvkiINwi0k31DS4R+s92+efZyGCP8DBYmanMxijU1szTtfC
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13ed:b0:30d:ad92:f236 with SMTP id
 w13-20020a056e0213ed00b0030dad92f236mr446484ilj.174.1673292794024; Mon, 09
 Jan 2023 11:33:14 -0800 (PST)
Date:   Mon, 09 Jan 2023 11:33:14 -0800
In-Reply-To: <da9e7c64-2187-5dfd-8d20-4d544778a109@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097da7005f1d9d61f@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_wq_worker_wake
From:   syzbot <syzbot+b3ba2408ce0c74bb9230@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+b3ba2408ce0c74bb9230@syzkaller.appspotmail.com

Tested on:

commit:         a4b98579 Merge branch 'io_uring-6.2' into syztest
git tree:       git://git.kernel.dk/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=1774afd6480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b79b14037065d92
dashboard link: https://syzkaller.appspot.com/bug?extid=b3ba2408ce0c74bb9230
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
