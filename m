Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E616BA72E
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 06:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjCOFfn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 01:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjCOFfm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 01:35:42 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B422A168
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 22:35:27 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id k13-20020a056e021a8d00b0031bae68b383so9370618ilv.18
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 22:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678858526;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ezVTqICDSiSn/372m2AODlES/x6h4w7Vq4yCunazgY=;
        b=bGAH1W5Vh8Dy43Bqb8pjge4FV+2ijYLdap5ZISnAKhaGXRBVKufpDaLmTR2IYBwuyk
         nWPHhcH0HSMOFlRn3Uv6AMnNMsE0NlQyTYSil6t265RjyvnI0AeqUgWK/jkufoKGxM4Z
         swCC+5pehHhDePaUXC2+TtH0konWFrGZV4Wjlwp2JlkfkxQFVDA3gUPAfvXc0B1qLQ0q
         ihEug6FtS7kONhZdCssU8Nr+yaxk1JmxqQQDgf+Hg8cSQz1pJEqZOkQl4gX8y1ZaU/1l
         lhDGGVGKdtrushm+s/+EObK4I5wAoJ9/TzFKPmTqxfXIAUxwljSLB8rHfV2tx7so/2eX
         FRpw==
X-Gm-Message-State: AO0yUKWwUgsJ9fU08rpqPvo5WlXl/JTeFailaGpgI/imD7P3bIoZqprn
        UqAv0P+Tm2sP3t+ilVXVmvmP63Twv3JWLE5pjBJ+s8rNtTJS
X-Google-Smtp-Source: AK7set+wuIJ21um9TSx52TdARHKOJQSeOjSvpUyJnZA7zidHuYslsh2kkedusXN9WdodJqH7DwtgLiy5GIKP5+DNpxLHiIWFE1Da
MIME-Version: 1.0
X-Received: by 2002:a6b:6a11:0:b0:745:68ef:e410 with SMTP id
 x17-20020a6b6a11000000b0074568efe410mr18224694iog.0.1678858526167; Tue, 14
 Mar 2023 22:35:26 -0700 (PDT)
Date:   Tue, 14 Mar 2023 22:35:26 -0700
In-Reply-To: <00000000000097fc2305f1ce87d9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001497d605f6e9b6e6@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: use-after-free Read in io_worker_get
From:   syzbot <syzbot+55cc59267340fad29512@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=108bc2e2c80000
start commit:   a689b938df39 Merge tag 'block-2023-01-06' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=33ad6720950f996d
dashboard link: https://syzkaller.appspot.com/bug?extid=55cc59267340fad29512
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1532ef72480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b43f3a480000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: io_uring/io-wq: only free worker if it was allocated for creation

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
