Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB53D4F24BD
	for <lists+io-uring@lfdr.de>; Tue,  5 Apr 2022 09:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiDEHkF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Apr 2022 03:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiDEHkE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Apr 2022 03:40:04 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF5BBCA3
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 00:38:07 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id u18-20020a5d8712000000b0064c7a7c497aso7841343iom.18
        for <io-uring@vger.kernel.org>; Tue, 05 Apr 2022 00:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=wcyi7XrZQP853dByi9+1YxDyQa3+xhgfC53tgafqARg=;
        b=3wQosTKj4INS4HRjmle9Mds1os8Z9vPbB0rVKsk1JvEZL/FiGP2BcY06cgbjgJSGpC
         WdvJN9ZL3wzfUhMBf0TIlYij4gcZx9FBUEUglCDjtn0ssJscZw/UN2rC3BglDIWNI/hg
         OmGeqfPRlYjCVl61YohZ+u1/b5S6Du0qSrT755X9MlFK7qQodSDIGbu7XBHFi5oXgKlQ
         UQZjMq6VjwMg5H7ZynOoBwriJ0JFismhkctNX2AS+oV0oeMtnDERxxwBPkqloWKueLNx
         ZeNxEHvuNYxNITnuSfAs4g7nZxWS+nfWAb4DQhv2OIQ9eRVKno6RmMPOGI9KzXwHiTVH
         0AzQ==
X-Gm-Message-State: AOAM531VZNFHNH7nr/tAEuf0HkQDtb0PWXGKPKY4EBypl9xhBCyt+Br8
        4Sgk7v9NdHaYgez9K5Ti1hz7wB2OJz60QSZNd8fA8LYYfPmR
X-Google-Smtp-Source: ABdhPJylwAgh1hTPED7kBLSTNMTi5KhXxeEahh2ttq/LYtuLKAfNNHO6HKO8c5krILmrEuJME3L2D43vjv+w9+R5yfXJVTS9+bYv
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d8e:b0:2ca:41bf:554a with SMTP id
 h14-20020a056e021d8e00b002ca41bf554amr1051738ila.128.1649144286768; Tue, 05
 Apr 2022 00:38:06 -0700 (PDT)
Date:   Tue, 05 Apr 2022 00:38:06 -0700
In-Reply-To: <0000000000001779fd05a46b001f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006574b705dbe3533f@google.com>
Subject: Re: [syzbot] INFO: task hung in linkwatch_event (2)
From:   syzbot <syzbot+96ff6cfc4551fcc29342@syzkaller.appspotmail.com>
To:     allison@lohutok.net, andrew@lunn.ch, aviad.krawczyk@huawei.com,
        axboe@kernel.dk, davem@davemloft.net, gregkh@linuxfoundation.org,
        hdanton@sina.com, io-uring@vger.kernel.org,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linyunsheng@huawei.com, luobin9@huawei.com, netdev@vger.kernel.org,
        pabeni@redhat.com, phind.uet@gmail.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, xiaoguang.wang@linux.alibaba.com
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

commit 563fbefed46ae4c1f70cffb8eb54c02df480b2c2
Author: Nguyen Dinh Phi <phind.uet@gmail.com>
Date:   Wed Oct 27 17:37:22 2021 +0000

    cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1048725f700000
start commit:   dd86e7fa07a3 Merge tag 'pci-v5.11-fixes-2' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e83e68d0a6aba5f6
dashboard link: https://syzkaller.appspot.com/bug?extid=96ff6cfc4551fcc29342
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11847bc4d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1267e5a0d00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: cfg80211: call cfg80211_stop_ap when switch from P2P_GO type

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
