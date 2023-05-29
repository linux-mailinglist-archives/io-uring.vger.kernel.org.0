Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D347145CC
	for <lists+io-uring@lfdr.de>; Mon, 29 May 2023 09:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjE2H6m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 May 2023 03:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjE2H6k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 May 2023 03:58:40 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD65A7
        for <io-uring@vger.kernel.org>; Mon, 29 May 2023 00:58:39 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-76c4c85d605so496106739f.0
        for <io-uring@vger.kernel.org>; Mon, 29 May 2023 00:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685347119; x=1687939119;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6glaZqXLdR/sqr43KU6Tb+HaCnc43Xn0goRWcqtcRyc=;
        b=javgGHMcq3oiQWoy1JRK7K4LU8Hfpta87WeSn2QAQv1W7C3GrCx54mVf+q8+l9bCMA
         DzYKTVdn1+UXr0eL/mMMHC2N1RR3mmTolEs3oIlZCjaDx/jalEYI0r2kHIXthSDccNKS
         v+kvSs/qs+hc74UPX3D6QGemmGil4bX/jFdMECZL0GE46ExduTrMsMaQkQRZ8h8whTs+
         sg7LdEEJ16pE0RHTDVI9/A9k2CPYYsiLOGkvR6Oeqo9+lpG1yXEjlF9zobfH43TyNS14
         1th1ViUewtUbJm6KgjY7pz3jkJKjWCMqedxzPLnPQMv4pdlPAJkoEAaTgkxCK/vxvHna
         7gfw==
X-Gm-Message-State: AC+VfDzsUSTCy3Vr/3vLDhne6Pd5L3wSSgG9yf3vGu76ahHPaKn3DOFd
        AYYC3MGMa2SFygJf0to6+ZQ2PFGtB+YDlsLnJpfN6phsHCsr
X-Google-Smtp-Source: ACHHUZ4MuBaRsJopnZiBm+6ufXaHSIG5lXU+lUdykELwTengmCKG9Deupzc7T4MRgR+haJxS4xX5eCIVMMG6ktdL/EfIcXF0qFza
MIME-Version: 1.0
X-Received: by 2002:a6b:7a08:0:b0:766:6741:8856 with SMTP id
 h8-20020a6b7a08000000b0076667418856mr3693372iom.4.1685347119096; Mon, 29 May
 2023 00:58:39 -0700 (PDT)
Date:   Mon, 29 May 2023 00:58:39 -0700
In-Reply-To: <0000000000005225a605bd97fa64@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005b688105fcd074af@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING in io_ring_exit_work
From:   syzbot <syzbot+00e15cda746c5bc70e24@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, deller@gmx.de,
        gregkh@linuxfoundation.org, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael@kernel.org, syzkaller-bugs@googlegroups.com
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

commit d808459b2e31bd5123a14258a7a529995db974c8
Author: Helge Deller <deller@gmx.de>
Date:   Thu Feb 16 08:09:38 2023 +0000

    io_uring: Adjust mapping wrt architecture aliasing requirements

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=145bb249280000
start commit:   7c6984405241 Merge tag 'iommu-fixes-v6.2-rc3' of git://git..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b6ecad960fc703e
dashboard link: https://syzkaller.appspot.com/bug?extid=00e15cda746c5bc70e24
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d5e97e480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1407c8da480000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: io_uring: Adjust mapping wrt architecture aliasing requirements

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
