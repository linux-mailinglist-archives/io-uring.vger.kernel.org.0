Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E484E4BFA
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 06:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241717AbiCWFBk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 01:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbiCWFBi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 01:01:38 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5154370CC1
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 22:00:09 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id q6-20020a056e0215c600b002c2c4091914so245327ilu.14
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 22:00:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6oYDZPp0LBPJzY6rTyL8BNLjnvNtQMaWxnBgcKEox94=;
        b=Kc0yHAUQXgP5TKHqqW126OxtI2SG5ROgKbul9Dxhh0q6B6/glMDeKctgyEm7/8L9/S
         L592WbgF0YSz0unv26i2wlz/ttRrLiduN8epZKcbq4cikbNOEKNBIDrEknoAiRVbcCLL
         90ct4KDKIfjCdsS98szBoxZT9OkujKA75GlVCA2ZN+87i4FC/NBbCnQZeHzBSAgzOsEB
         sjXbI6ta/kw5h3RMk0ahxXr2C3Mcfox51fKh0Oby0+0BSr1MAXA24pJdMuO0JoJthVc8
         OjYco2/oQuSyAbaAuE+aVJAiyr3U5LXCyHuDRpuJrxuaB6TP11tJXl217khs+sG9r+a1
         uMQQ==
X-Gm-Message-State: AOAM532CSvSp8nGn5uJndB4z6Hh8kJKLxSBrlYMaJNPRB1Sw9lYobabB
        C2uUI4rGwaxPro0q3O0pdnDr4CZsNNgVl/KJWauMRskwMKSz
X-Google-Smtp-Source: ABdhPJywpzb3LdIQOh5rVskDVLgV8tk+mcgnOSyT+AEYgYLttX0csyUGHT+zmnwungj8w2LzV7rYZny3xppw34szwOommpo4bzx2
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3052:b0:317:79e1:8b7f with SMTP id
 u18-20020a056638305200b0031779e18b7fmr15107849jak.239.1648011608670; Tue, 22
 Mar 2022 22:00:08 -0700 (PDT)
Date:   Tue, 22 Mar 2022 22:00:08 -0700
In-Reply-To: <64edb9d0-859d-c230-edc6-fba0f8a46b98@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000085454a05dadb9acd@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_poll_remove_entries
From:   syzbot <syzbot+cd301bb6523ea8cc8ca2@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+cd301bb6523ea8cc8ca2@syzkaller.appspotmail.com

Tested on:

commit:         7d58de1a io_uring: don't recycle provided buffer if pu..
git tree:       git://git.kernel.dk/linux-block for-5.18/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=198493467201ec16
dashboard link: https://syzkaller.appspot.com/bug?extid=cd301bb6523ea8cc8ca2
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
