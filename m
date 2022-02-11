Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3BC4B2134
	for <lists+io-uring@lfdr.de>; Fri, 11 Feb 2022 10:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243239AbiBKJNJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Feb 2022 04:13:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBKJNI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Feb 2022 04:13:08 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38602F69
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 01:13:08 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id p16-20020a927410000000b002be8797ac0bso5490304ilc.7
        for <io-uring@vger.kernel.org>; Fri, 11 Feb 2022 01:13:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DsxbeR1l3tRF+9DPLDGsjVsnknNa637pd3J+B6ACmng=;
        b=wxQkgyBqzGcZj+IszVBKkR20evTtoM3ANw/l9qsWE6tYKg5BbzWuQ7Jq0FFWw2xjWX
         e01xjyLIbymJPR1TthoDs0GvSsy1E3eCR5q7J/sVO/BFsQTkt32co2q9EcF0Vlnm/aPf
         EJi1v06yE2llweqR7euy86kRGh7Jf3gWzV7uvvYTTKmEQFPbpHZlpCiZ9w51lEY1Wad8
         NfJ9TtwTOqT+M9DYCEeU4wPVB3rH+Uou3C7Etv3KqaBrNTAQz0ybjjmjU8UTXrK5lM9m
         rPwo9kQ4w3M1ctjXIzZRx4JcQDPs7UbQrOjiS1MuREcyS6cN52lgj8ZhVbpegOCls1C9
         5HvQ==
X-Gm-Message-State: AOAM530Wb4UVyUeuD4hvonL31x51q13U+NLAk6dR/yNBzyrHR2mhtR/8
        ToN7jnqrUUU1zoEVSeNCapxoGH3LtEse/Bq6jUcEW4/NvHNa
X-Google-Smtp-Source: ABdhPJyAlGmMp8F7U7k+cHSU2CYS73uf0jYpgEQvmOWeay1LyK2Krk2chHwJZC38Nk2WYShiX2szVfhC+S2lgXl8gW9XCHvJOoKT
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1345:: with SMTP id i5mr346782iov.143.1644570787508;
 Fri, 11 Feb 2022 01:13:07 -0800 (PST)
Date:   Fri, 11 Feb 2022 01:13:07 -0800
In-Reply-To: <000000000000d5358b05bfe10354@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000098f75305d7ba7942@google.com>
Subject: Re: [syzbot] possible deadlock in io_poll_double_wake (3)
From:   syzbot <syzbot+e654d4e15e6b3b9deb53@syzkaller.appspotmail.com>
To:     alaaemadhossney.ae@gmail.com, asml.silence@gmail.com,
        axboe@kernel.dk, dvyukov@google.com, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
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

syzbot suspects this issue was fixed by commit:

commit aa43477b040251f451db0d844073ac00a8ab66ee
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed Dec 15 22:08:48 2021 +0000

    io_uring: poll rework

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=110d0baa700000
start commit:   c9e6606c7fe9 Linux 5.16-rc8
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=4772459294eb89cc
dashboard link: https://syzkaller.appspot.com/bug?extid=e654d4e15e6b3b9deb53
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f87335b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ac8a73b00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: io_uring: poll rework

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
