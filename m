Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5006B7A5C
	for <lists+io-uring@lfdr.de>; Mon, 13 Mar 2023 15:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjCMOc0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Mar 2023 10:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjCMOcZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Mar 2023 10:32:25 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5C7580C0
        for <io-uring@vger.kernel.org>; Mon, 13 Mar 2023 07:32:24 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id y6-20020a056602120600b0074c87f954bfso6466028iot.4
        for <io-uring@vger.kernel.org>; Mon, 13 Mar 2023 07:32:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678717944;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4y/5zA6M4Bgo32w3DEC2QVqTxoqFR5HvYaARqLXL8ek=;
        b=IUqdKwKv8Z9gnW10eq6inLObTVGikuOmLs58ZVKclTvgpctl3C2LnatYqH5x9HwOgF
         tJ7OTmIHXFcBa7k+Azg76MNZttAilhKiU26c1a7r6NVSBn/R5IbfpJ7R4Juw1mAUFBwD
         TTOXVtwYwiWGEhzopQ2SkwsQmBexGT4ZjtwGFr0DovCfp88QckOSRnD0/YmMrRxUH4yH
         YQZiAyKg1ZJi3MTJ/x12Lcno7zsnY7CcDeauNsZF+bI8YYIKLL4Say25awSi2Puz3WPH
         MrP4XqlCQd4RJNC3raeZFbm2l8tdw8DXG7LQSbhx0h/Mr5cBZVmI5VVx9XoOsEUKyJkr
         MZQQ==
X-Gm-Message-State: AO0yUKVtm9yKSgY96QoXwcDA5cEBw2MU+gezXkU+sBdolTwAw4aTqbKF
        LPLhPpu2pMgjzl3m2THv4MYdRWjsuMCuLqBBt/gOu2cBPPGi
X-Google-Smtp-Source: AK7set//Vxwu9cDJinI5+BoatG3+ShJiVgoRfhjdyDSgiMrcH7fhxRJ3a933Uwu++c+91ZnsWuj/l+LRUU8CbGVvI5Y+IF2T/veh
MIME-Version: 1.0
X-Received: by 2002:a6b:7902:0:b0:745:70d7:4962 with SMTP id
 i2-20020a6b7902000000b0074570d74962mr15645557iop.0.1678717944153; Mon, 13 Mar
 2023 07:32:24 -0700 (PDT)
Date:   Mon, 13 Mar 2023 07:32:24 -0700
In-Reply-To: <000000000000f0fb6005f1cfc17f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd527205f6c8fa41@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: use-after-free Read in io_wq_worker_wake
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

syzbot suspects this issue was fixed by commit:

commit e6db6f9398dadcbc06318a133d4c44a2d3844e61
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sun Jan 8 17:39:17 2023 +0000

    io_uring/io-wq: only free worker if it was allocated for creation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=113a76fac80000
start commit:   1fe4fd6f5cad Merge tag 'xfs-6.2-fixes-2' of git://git.kern..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b79b14037065d92
dashboard link: https://syzkaller.appspot.com/bug?extid=b3ba2408ce0c74bb9230
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1388e5f2480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127f1aa4480000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: io_uring/io-wq: only free worker if it was allocated for creation

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
