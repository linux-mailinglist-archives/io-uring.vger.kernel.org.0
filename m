Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3F640A24B
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 03:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbhINBFZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 21:05:25 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:46863 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236719AbhINBFY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 21:05:24 -0400
Received: by mail-io1-f69.google.com with SMTP id s6-20020a5ec646000000b005b7f88ffdd3so15202298ioo.13
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 18:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lkuAH26yQOlGfKXblDYiAOWW8Flrjdt2FI+BYcMEb54=;
        b=QZ31PFnX2BjHUWnQEusPNqCPVQcWIR8R5f6bqIbrp0tlPHEmpNBvI1G53W1xrNbrPP
         xFhvU+vGi7oBJfGn3I1sK2YbY43B8fBecY7iA/BrehnO54Vb1BcSEPacD6yYol27h4qP
         GXWclJ8IjXrDw5M8SLnT7vsuu9rAWeEoDoH7Qi4o7FEXsZDfyZxxfXxG75ij5twRKVto
         UYre5naCrxdgVy8T9uOxQ9hEGaB0xHx4DUQja6EsJLAUF7lj74+/QN0wNNKQnuu+DQTZ
         XlsZ/rvw2PdnbwDLeDrfUFnK8vDL2HTSVKA2EpL8LobKIfQMkkcOok4bLEiAOzg2FJ49
         RP6g==
X-Gm-Message-State: AOAM5323k30WDqZYUWkhAyvRbiTFBYzGeDAIxNJ3cxKxp0poTPHP6w0z
        DkuTSZs5nTO/FjBOR/TBTLbsIOvffELrfUb9p1MTDS/D7a/h
X-Google-Smtp-Source: ABdhPJxnMCzs9SaZqkSRrEgYOeXV7AsHgsGgbPXcL7CkduBMcsrSHeR0/8S3Lqjt096iy0RNiUzERIAUlcC1IXMPzHhlgR3GG4T8
MIME-Version: 1.0
X-Received: by 2002:a6b:b88a:: with SMTP id i132mr11300524iof.215.1631581448021;
 Mon, 13 Sep 2021 18:04:08 -0700 (PDT)
Date:   Mon, 13 Sep 2021 18:04:08 -0700
In-Reply-To: <8428f733-ae95-f57b-8d42-6c7a279f4d84@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a1b11505cbea28c2@google.com>
Subject: Re: [syzbot] general protection fault in io_uring_register
From:   syzbot <syzbot+337de45f13a4fd54d708@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        johalun0@gmail.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+337de45f13a4fd54d708@syzkaller.appspotmail.com

Tested on:

commit:         7981f41e io_uring: pin SQPOLL data before unlocking ri..
git tree:       git://git.kernel.dk/linux-block io_uring-5.15
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d93fe4341f98704
dashboard link: https://syzkaller.appspot.com/bug?extid=337de45f13a4fd54d708
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
