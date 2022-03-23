Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1364E4A2E
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 01:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240590AbiCWAth (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 20:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233175AbiCWAth (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 20:49:37 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46901E3F3
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 17:48:07 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id h13-20020a056e021d8d00b002c7fb1ec601so18685ila.6
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 17:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=MG5Y8xILdnFlJljeDRhJEgQB6FlTo+9PoQNjAE5QtFg=;
        b=yiCH29UbrmDDtFWJjxpFUrN9nM2L7GDJOoKgZMY4IxUw8haenkh1xvEEDwU2YNZ78e
         c+IPAv594RFiab+NQ8WBV+ffTaIdaMEveWSffSbKFCRu9nYiOJfauv5LAUCPLlCIrUi6
         7QPcEV+K24bHY0rIggaJ3nXZe37opffL+Q5xArsUF3bmHC1+rnQwC5b8UEUMWwg2sT64
         ZTFXl3AaVSLz9cpN6kzakB2zSWqcQAApSWnAf7EVDqbPntE9T7ycEVjqHdbdQzDYkHU1
         YNlUQKYsa4WfiZwkLaKcyis3Y6r9BrftcOiMAWrESdBkg8KqpVdKG7Xfg5AUsPh+NfAf
         VhMw==
X-Gm-Message-State: AOAM531AdTfqoaXGxmwnnygIUkBJ9xRvg4zI1InJ0LSX21OzrhcBhRwA
        zFP31j1N9+1g0Eva+zXv5KmJhdsGCodz/LNJB1+t+89Yg5+y
X-Google-Smtp-Source: ABdhPJzptHHQrN8r1mX3409unrkLHPcL2SBen3Iw3BjiPGI4qJqSBSa7xKT6pKtQAVfZwGv1L/fSJM4YvdlQx/82p0qPPCGBE8T6
MIME-Version: 1.0
X-Received: by 2002:a05:6638:22e:b0:321:675d:aa77 with SMTP id
 f14-20020a056638022e00b00321675daa77mr1273076jaq.152.1647996487309; Tue, 22
 Mar 2022 17:48:07 -0700 (PDT)
Date:   Tue, 22 Mar 2022 17:48:07 -0700
In-Reply-To: <8bcf2234-983e-171f-90dd-ff0c07412b46@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000379f1d05dad8157a@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in add_wait_queue
From:   syzbot <syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk,
        gregkh@linuxfoundation.org, io-uring@vger.kernel.org,
        jirislaby@kernel.org, linux-kernel@vger.kernel.org,
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

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com

Tested on:

commit:         7d58de1a io_uring: don't recycle provided buffer if pu..
git tree:       git://git.kernel.dk/linux-block for-5.18/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=3172c0bf8614827
dashboard link: https://syzkaller.appspot.com/bug?extid=950cee6d91e62329be2c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
