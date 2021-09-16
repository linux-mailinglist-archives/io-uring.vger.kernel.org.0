Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F5240DC21
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 16:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbhIPOCe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Sep 2021 10:02:34 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:51097 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbhIPOCc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Sep 2021 10:02:32 -0400
Received: by mail-il1-f197.google.com with SMTP id x4-20020a92b004000000b0022b3cb3b4deso12397716ilh.17
        for <io-uring@vger.kernel.org>; Thu, 16 Sep 2021 07:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Rg5swG7vfZFIYVXMyonVSaWtcmV6xu8pi1vuSVxxgRg=;
        b=4RlFefyd3aH8gt7Rb9z4ySFDDLFqbWAErWCM8cuQSU8g8sK8LkjQyoZE1jJ6AD+z/2
         0x4XDgw4/hMYRHD8p0GeWMMIW3hzGAh6A4Gq6oMc0/zl8TftZUIkKmNg4gSbD8v+aHvY
         Y1+et9Q3pR+yucZjR2rQfWNhJF3o4MPg0qQTuQMbAhVgowqlTieiGvPt6W/vStgigP30
         +nL+muU9p+eqLW+6njUlCS4qddeVQdtoQazwq47vV0QsdkbakXsrm6/yMcs9j7NAdSKy
         jfHwyzIc4xKAQmZDQOwwPrPzZfYWgut/20Sh6X9mIIDQWl0euwnXmp6CngHiBT5y0kbi
         TVLw==
X-Gm-Message-State: AOAM531LBjJWeg4CuzemhWOXevGQTMqCPKXHRGdmrU/ol8EfrJ3DdU/w
        23SoDKoNGOLq45IcM6KwZpPWzWkTiRvtcueDTFgZxD+N7QfJ
X-Google-Smtp-Source: ABdhPJx1AQvYzhvk1chHxJ+OOacYbh2ToZzXsMDGRXSfvADJvc2UVKTiq8ZYqzGqE/bXmABIleNk1xHuK0ut39hBC0JzqvljvTE9
MIME-Version: 1.0
X-Received: by 2002:a92:cb87:: with SMTP id z7mr4244017ilo.315.1631800872036;
 Thu, 16 Sep 2021 07:01:12 -0700 (PDT)
Date:   Thu, 16 Sep 2021 07:01:12 -0700
In-Reply-To: <0ddad8d7-03c2-4432-64a4-b717bbc90fb4@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000526fb105cc1d3f5b@google.com>
Subject: Re: [syzbot] WARNING in __percpu_ref_exit (2)
From:   syzbot <syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, coreteam@netfilter.org,
        davem@davemloft.net, dsahern@kernel.org, dvyukov@google.com,
        fw@strlen.de, hdanton@sina.com, io-uring@vger.kernel.org,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, ming.lei@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+d6218cb2fae0b2411e9d@syzkaller.appspotmail.com

Tested on:

commit:         5318e5b9 io_uring: quiesce files reg
git tree:       https://github.com/isilence/linux.git syz_test_quiesce_files
kernel config:  https://syzkaller.appspot.com/x/.config?x=f7d9f99709463d21
dashboard link: https://syzkaller.appspot.com/bug?extid=d6218cb2fae0b2411e9d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
