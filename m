Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAA04731FF
	for <lists+io-uring@lfdr.de>; Mon, 13 Dec 2021 17:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhLMQkO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Dec 2021 11:40:14 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:49812 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240950AbhLMQkM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Dec 2021 11:40:12 -0500
Received: by mail-io1-f71.google.com with SMTP id g16-20020a05660203d000b005f7b3b0642eso5178272iov.16
        for <io-uring@vger.kernel.org>; Mon, 13 Dec 2021 08:40:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=3ID3XANipYuWRqgtPQ1BWFFiHhMGJojTDZG87ujp4KY=;
        b=149ook09NwBLRT9lknLuIGYw0zCXLzD7dnZHeohbOG7eWcI4JBoWyNGMvYBvVshj83
         K/u7DxNVMN+Ib0GRcrKv1VmHOBlDBLz85gdtVTUSUXJxnFSmDy1hbAAT4Yese8Cwc6h/
         R2PlbXXQMsWwyiJsMQmxsE+Co1O2UiO0dGk+wgCSFZ17c7IA0nMlvZnJoWJzXJwJgKH2
         8P1FSvZK5VL953p3MmgvnFWqIxW1j43HunFwxwYukCOHL6fUYGr8Pjml2lkpfg5s1bdN
         73TG3/bGAsdRE7D5nJqs8WbWSPej7/0h1PcgD4NLhg2hyxwOrIkWei1Rt+JvAEyCF0Iz
         dj4Q==
X-Gm-Message-State: AOAM533qqSPt/G8oaCTJ556JnzdZnYlgYU8svuMFQFLL0SAWlckFQ9aM
        OKaeA6m6IJAr77uN4TP4R2ANyvVhaUUrgDMGA5oybvZs8TuF
X-Google-Smtp-Source: ABdhPJxnluLGA2ihn4eZD4ifoLmKB715ATvxozGrTPZEpBkNwTIO3XvJfes46/CiIaBlqjUweE8RJD/5lOM7GyE7ylqU+tT2teSE
MIME-Version: 1.0
X-Received: by 2002:a92:d6c7:: with SMTP id z7mr35334339ilp.92.1639413611269;
 Mon, 13 Dec 2021 08:40:11 -0800 (PST)
Date:   Mon, 13 Dec 2021 08:40:11 -0800
In-Reply-To: <494d69b4-d9da-b698-39e6-ed41b64a09a7@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f0971c05d309b9c2@google.com>
Subject: Re: [syzbot] possible deadlock in io_worker_cancel_cb
From:   syzbot <syzbot+b18b8be69df33a3918e9@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+b18b8be69df33a3918e9@syzkaller.appspotmail.com

Tested on:

commit:         d800c65c io-wq: drop wqe lock before creating new worker
git tree:       git://git.kernel.dk/linux-block io_uring-5.16
kernel config:  https://syzkaller.appspot.com/x/.config?x=6c3ab72998e7f1a4
dashboard link: https://syzkaller.appspot.com/bug?extid=b18b8be69df33a3918e9
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Note: testing is done by a robot and is best-effort only.
