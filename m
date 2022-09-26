Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAA95EABAC
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbiIZPxD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbiIZPwd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:52:33 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974CD8FD7E
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:40:19 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id k6-20020a92c246000000b002f80993e780so4615105ilo.13
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 07:40:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ng/WLGY7e/twhA8GiPNA9Temvif9bAJ4lIqtpvMFShs=;
        b=y2TFEOvA9TvS/Qrfv2FuYIQxwrveb320qDSr+3Jmyt+4x0FYmoVArceuYdenKJ7O1j
         2z4OJW58VuyZkaTp1boV9db4bLvcFgw1AvVU67R/P5ip+rBVGqpgNMR/qgewYF5rop2q
         PXSoe4wbjqh7fV2YmHnJchUEyL6ywqN2Ger5OWS68U5KXbXJ5m17kHY7RfH1dS3jgSYb
         7KL/nCBCySazQx0aJNybCzipTxGkpyTQl3EvgZD5b8axXU3Hk8oGZ53ViIGcMub7HgM9
         N5PmE4oMxL4xF8YuIPQ7R9ApWnmzt5cTJcf2KC8QbePn7C+WIIgUxG5L85JAzyElJOvB
         CW7w==
X-Gm-Message-State: ACrzQf0qN486nBBr/j79gUJBMHb4Ds2/FW/cljguEiDhs9xhy3N8kihU
        eqFR9FwHsw0b+dhKCbrsTL5Ha10DbPosWgtE+6ULHA10gRIh
X-Google-Smtp-Source: AMsMyM62K5wgeVkJhA1nQ1HJUjj8Yz+G+91GaXIoM1LGdh7k20zDaYb/G/y8rK3pCmogwop2Xyn0KJ+OcIUH0OrgLZ8A4JCkz+z3
MIME-Version: 1.0
X-Received: by 2002:a92:c24a:0:b0:2f8:16a6:e0e2 with SMTP id
 k10-20020a92c24a000000b002f816a6e0e2mr5257616ilo.291.1664203218789; Mon, 26
 Sep 2022 07:40:18 -0700 (PDT)
Date:   Mon, 26 Sep 2022 07:40:18 -0700
In-Reply-To: <ee12470f-4fca-a036-1195-d68a3ca1f3f9@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b0ab5505e995814a@google.com>
Subject: Re: [syzbot] KASAN: invalid-free in io_clean_op
From:   syzbot <syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com>
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

Reported-and-tested-by: syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com

Tested on:

commit:         f159b763 io_uring/net: fix cleanup double free free_io..
git tree:       https://github.com/isilence/linux.git io_uring/net-free-iov-bug
console output: https://syzkaller.appspot.com/x/log.txt?x=15697b18880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3521db70c6a595c4
dashboard link: https://syzkaller.appspot.com/bug?extid=edfd15cd4246a3fc615a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
