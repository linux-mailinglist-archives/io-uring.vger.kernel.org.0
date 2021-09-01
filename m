Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539223FD3E9
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 08:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242336AbhIAGmF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 02:42:05 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:46695 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242238AbhIAGmF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 02:42:05 -0400
Received: by mail-io1-f71.google.com with SMTP id s6-20020a5ec646000000b005b7f88ffdd3so985557ioo.13
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 23:41:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=P/IMCvQrvg+8vgiRvuUq0CwJ8bLlyNbWMfPV5tYVEzM=;
        b=VEMuFjJIgi4hW/OFU5fYliIv0NVLt9vLS6hg2s9Sghhv/sWN1hoIYjGmWfRPy7rjG2
         E5uaV5wfPVB407cLY12KRMypaDf8C1Rzd6c3q6FdVOV3qkEhtY71R4+NcsFdPCBc2KP5
         MKTKw1IyJEWNHQFg5QRpWam3jPBM7vSEOcBO7BOhrkYtsd4aTXl4vSu7yHbDe1LO43SI
         ZIKwW3SIBgl2Nc+uCMeXCuoQX6S3h34YrKrAuv0Nu7z0VBuCr4YESSIDW2XhYxaAVrRG
         0aRtzXD/HdN1MBA+6Sea8bXr9/oSscwfiDW4XLNs/d8InMyZLT8eKHON8rcPgV4oEzAQ
         zpQQ==
X-Gm-Message-State: AOAM533wP5/6SRSLShSca6w+7QiBoJXPAQPxt7slPc1vZhMImiolaHxp
        HVEy61j3Y7eM56IEBv6ViB9QacvPupNPCKEsmJv5lWh9uLaA
X-Google-Smtp-Source: ABdhPJwjbVl36PRGrxPo3VWFpYPdF3rcxUyLcJL+kpHKRktKIhGPoUpcjjA/JpOC4UE7iVT+Raz2Xf8nGOR5VzvFVVs5vlXj6ozj
MIME-Version: 1.0
X-Received: by 2002:a6b:f908:: with SMTP id j8mr25814233iog.22.1630478468594;
 Tue, 31 Aug 2021 23:41:08 -0700 (PDT)
Date:   Tue, 31 Aug 2021 23:41:08 -0700
In-Reply-To: <0000000000006d354305cae2253f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ef423f05cae95929@google.com>
Subject: Re: [syzbot] general protection fault in __io_file_supports_nowait
From:   syzbot <syzbot+e51249708aaa9b0e4d2c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has bisected this issue to:

commit a8295b982c46d4a7c259a4cdd58a2681929068a9
Author: Hao Xu <haoxu@linux.alibaba.com>
Date:   Fri Aug 27 09:46:09 2021 +0000

    io_uring: fix failed linkchain code logic

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=147a8045300000
start commit:   b91db6a0b52e Merge tag 'for-5.15/io_uring-vfs-2021-08-30' ..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=167a8045300000
console output: https://syzkaller.appspot.com/x/log.txt?x=127a8045300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=961d30359ac81f8c
dashboard link: https://syzkaller.appspot.com/bug?extid=e51249708aaa9b0e4d2c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a91625300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12512291300000

Reported-by: syzbot+e51249708aaa9b0e4d2c@syzkaller.appspotmail.com
Fixes: a8295b982c46 ("io_uring: fix failed linkchain code logic")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
