Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E6252AB65
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 21:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352449AbiEQTCM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 15:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352396AbiEQTCL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 15:02:11 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FD43F30C
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 12:02:10 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id q6-20020a056e0215c600b002c2c4091914so9975682ilu.14
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 12:02:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=trJlUoBsAU0Gfja7NVm8U0mdQqxyIpgiYU5DZakIhBI=;
        b=xcucdOjDbIntFVQ90Omn1JuoWEed82stwcX0759c9PyfCYs8KB3MuxhcEkzzoa8HN6
         ZBLgZOSxyEtGHxs1pDV2AxQ5RpTKUpKCuWQyWfi8Wpaefdk8+av5b1KECbPieA8RB7oq
         0yn/SmqOuHMKR70p4ce/YZii/Z9rXzoBPhee2VeFNu6UzI6LwboAWHJPRoM5hKNWtZ2L
         ss7/N1Vs1pR5a0y7QML7nST1MqVIt9RPil4aVWTqrpaGoEUt0NEVj3PYhO03A/NQUR96
         HHFIX31+MAW2O9SXPzeDyx8YfkGu5+Nwhxlf4lBDGaVYYoCxbl/J8Zykt5/nDu12gvID
         Z2lQ==
X-Gm-Message-State: AOAM532iSLNYHAFnvbVzFc+or5uPCx75BvSFeZLE9uY3/wnUwYbiCu3r
        YE0jzT+hX1JL5fzGAYyfDsYNxEMowGMyqyPjbwH2H4IGByMf
X-Google-Smtp-Source: ABdhPJzi+HvE6EnVZG74GdN+JteT30NG17qd1T8Fck4gK/b02ljT7Ivc1HOnroXCMXiZvdak88P7i4HRbU5ddf6lP8jLjD9XV1eY
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d13:b0:32b:cf94:275b with SMTP id
 q19-20020a0566380d1300b0032bcf94275bmr13195448jaj.22.1652814130055; Tue, 17
 May 2022 12:02:10 -0700 (PDT)
Date:   Tue, 17 May 2022 12:02:10 -0700
In-Reply-To: <b6f36795-97ac-fac0-ab07-98de8255e4f9@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001a0dba05df39c7d3@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in io_do_iopoll
From:   syzbot <syzbot+1a0a53300ce782f8b3ad@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+1a0a53300ce782f8b3ad@syzkaller.appspotmail.com

Tested on:

commit:         aa184e86 io_uring: don't attempt to IOPOLL for MSG_RIN..
git tree:       git://git.kernel.dk/linux-block io_uring-5.18
kernel config:  https://syzkaller.appspot.com/x/.config?x=e408a5da421f07d4
dashboard link: https://syzkaller.appspot.com/bug?extid=1a0a53300ce782f8b3ad
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
