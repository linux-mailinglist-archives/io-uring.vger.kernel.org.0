Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64F54042AE
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 03:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348907AbhIIBQ0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 21:16:26 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:56001 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236691AbhIIBQX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 21:16:23 -0400
Received: by mail-il1-f198.google.com with SMTP id m15-20020a056e021c2f00b0022c598b86c3so298587ilh.22
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 18:15:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=pKMCZVg6cR9WvW2VYzENzm73CCK4MaLG6KWqwM4tTuM=;
        b=FFtaaj3g6r7imbMoTvaIQiuCUmJMapu8qclz7C7Lv0mRDTHmbmbAjcwdWsDlWjyA51
         Tgt6d/gERJ+cqFm5qVD2qkLsut1a5hFg2mM/BmJd3hmy96jEJtXm3UVT/lSnUq9xreEW
         su5lSiwUVQORihwOmcU5EmYLoQllSZRl3cHSCMmPL45CXRAc5iD5fHCDV0llJ2JwULDm
         ui/OtS5D1kXuQj59VSQd3BUgkqWryhe4wLC4BN6dYGPoWvIe77+H/h8H8VrELQETFuvg
         f6quzoYb7l0Niso5O4+GfJmICEhC6Wv5U7EwZG7YTr57Kj+8QekElYkzTARDkeDSDAgU
         /ATw==
X-Gm-Message-State: AOAM530zvy6vnzbBsGDEoRIyhwFcB4YEB4ToTiIjIJty1swPjEt5jKLK
        fAyr/1vYDPZzGJVy1kg8rFnf2FoeRXhkPkSaSOJPg8r+6kuU
X-Google-Smtp-Source: ABdhPJzK8JlpHcQNND2R0juetArIP0azEXM9Eh+omcDscivIcYmXECYKvxpKS3o7G98SXfgzw05ubafLATGIlGlGe56cfOT7ZJCu
MIME-Version: 1.0
X-Received: by 2002:a6b:6f18:: with SMTP id k24mr378847ioc.196.1631150114505;
 Wed, 08 Sep 2021 18:15:14 -0700 (PDT)
Date:   Wed, 08 Sep 2021 18:15:14 -0700
In-Reply-To: <1ec6e8e0-d253-5f84-982e-4146db278655@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000026886605cb85bbf5@google.com>
Subject: Re: [syzbot] INFO: task hung in io_wq_put_and_exit
From:   syzbot <syzbot+f62d3e0a4ea4f38f5326@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+f62d3e0a4ea4f38f5326@syzkaller.appspotmail.com

Tested on:

commit:         cee36720 Revert "io-wq: make worker creation resilient..
git tree:       https://github.com/isilence/linux.git syztest_iowq_workers
kernel config:  https://syzkaller.appspot.com/x/.config?x=f9bfda6f9dee77cd
dashboard link: https://syzkaller.appspot.com/bug?extid=f62d3e0a4ea4f38f5326
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
