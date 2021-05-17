Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6417382B4E
	for <lists+io-uring@lfdr.de>; Mon, 17 May 2021 13:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236849AbhEQLkY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 May 2021 07:40:24 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:53100 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236785AbhEQLkX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 May 2021 07:40:23 -0400
Received: by mail-io1-f72.google.com with SMTP id o6-20020a05660213c6b0290438e33a3335so3067572iov.19
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 04:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=64ByleF0eKIUeLMwAQcZCrEU9s7jm+g71Yg7H37B1eE=;
        b=CyBfGOwJ9dkwNm8tP9Qgn4tfJc742TxgvFy0VN6SJFvfaWdcDZ1DwLIccEm6WzSSvM
         cCrsv+GhuVXq0hmJkBsXBCFo4oU8FmeyF6LCTtKO7ou+RIlkYizxl7dT4rEzOz85JfB3
         g7L3+4xcr6gjayX0eGG94HDwG5qUWnlcCN+Ib7GCIW4GYa7Y1KGciLrC/nZPfBn1HKTO
         RLEkgPwtbQPWBwpRWEdWRoPUC2xp3BEVLn9ChXdmpeqASzq0qyjgGamJxRjWJ9VPqfkB
         eqA1MJbcS5Nrnw7ZnbTTxbF+EZU5x+D8UuLoncyscm2bjFT7cAtdcLhSuNzdwj3KGMBA
         DByg==
X-Gm-Message-State: AOAM533H1KdONNKEpA9Hhjs8BBmPZ78sMQcsZeX1GXqZgzAA0dDCKWO9
        3iBr8aZonF8DK5MqBueaAwO2DRFX3HUXn4naRVrghBuAtOA4
X-Google-Smtp-Source: ABdhPJxdR1T5mJ0Hz94LylFjjrFcVztce0EuuJVoIk6yn6ufYbfAnVpUJDXApHuCLfnDF/bIaK/55SNcREKfnVW4XoHmzI3nOeXD
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c5:: with SMTP id i5mr2362132ilm.101.1621251546286;
 Mon, 17 May 2021 04:39:06 -0700 (PDT)
Date:   Mon, 17 May 2021 04:39:06 -0700
In-Reply-To: <a6a87693-f994-6e56-78a2-6e39e1060484@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000820f7005c2850ab5@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in corrupted (3)
From:   syzbot <syzbot+a84b8783366ecb1c65d0@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+a84b8783366ecb1c65d0@syzkaller.appspotmail.com

Tested on:

commit:         667dd097 io_uring: don't modify req->poll for rw
git tree:       https://github.com/isilence/linux.git syz_test10
kernel config:  https://syzkaller.appspot.com/x/.config?x=ae2e6c63d6410fd3
dashboard link: https://syzkaller.appspot.com/bug?extid=a84b8783366ecb1c65d0
compiler:       

Note: testing is done by a robot and is best-effort only.
