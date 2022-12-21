Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425336533C7
	for <lists+io-uring@lfdr.de>; Wed, 21 Dec 2022 17:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiLUQKb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Dec 2022 11:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiLUQKa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Dec 2022 11:10:30 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1508218B1
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 08:10:29 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id o16-20020a056602225000b006e032e361ccso7000071ioo.13
        for <io-uring@vger.kernel.org>; Wed, 21 Dec 2022 08:10:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=la4vkjbmp/hoBiwyPidnlDXslDjnZqNzD4iiQiAwR94=;
        b=gVSuPQXwpu0IhiXKj0lLZrigIxEO+R41qV11WXbTum6caaep4TMI88FN5GcviXc2ry
         R7cQcnBVRTpKkZD5wRy96Ru89k7RRjzn9xzETQUZrhrVD8FssaMFVfosou5haYfFZemb
         ag5Zyw+7toRog8kL6pZ3PiL3WSIcP3T+tqLD9fgegXKPM+xOcWwAUu5Z7hq7HXW9iHzo
         LYCvcMSEKz6a5IBscTKp6RseEByh5IhhZ48uOAlJB5KdX7MfCBfun5RB4AxBHX36YbSF
         A3GmuGnWWZNTwKGBHxE8dfcdT1juxwnoL5gueQiszILuOvXj9LOGt/UE7RtpELQaYTfK
         58CQ==
X-Gm-Message-State: AFqh2kpN9dbLAM3PNPbKSEK8pDQoDIfflJrjIz+3oFfrL7q/FMR4QEP6
        iHp77Dp6blRmDwZk2jqicndFHv8a0zNFQ/ZcfsFltVORVC3/
X-Google-Smtp-Source: AMrXdXvTaIHDV02F+gBN/7BxU/Jg7ssMmiZ9326P326GYCmN7SMnumn5KR5+R2sxh6DqFQF8gNFqXa0r5U+3Zef+PScetgItthKv
MIME-Version: 1.0
X-Received: by 2002:a92:d602:0:b0:30b:dae5:c56 with SMTP id
 w2-20020a92d602000000b0030bdae50c56mr101654ilm.99.1671639029041; Wed, 21 Dec
 2022 08:10:29 -0800 (PST)
Date:   Wed, 21 Dec 2022 08:10:29 -0800
In-Reply-To: <7c89b1c8-f012-3965-ab77-3bc19b3cedaa@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000084d53b05f058cabc@google.com>
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

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5778 } 2634 jiffies s: 2893 root: 0x0/T
rcu: blocking rcu_node structures (internal RCU debug):


Tested on:

commit:         071531e9 io_uring/cancel: mark task running before re-..
git tree:       git://git.kernel.dk/linux.git io_uring-6.2
console output: https://syzkaller.appspot.com/x/log.txt?x=13042ae8480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2edd87fe5cbdf43f
dashboard link: https://syzkaller.appspot.com/bug?extid=7df055631cd1be4586fd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
