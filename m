Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76EF3EE532
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 05:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhHQDum (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 23:50:42 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39813 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbhHQDum (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 23:50:42 -0400
Received: by mail-io1-f69.google.com with SMTP id u22-20020a5d9f560000b02905058dc6c376so10451886iot.6
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 20:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Fmzbu0SFDXh2Dg+PWBp1e31sM7UnYc4n5FDt0nlapDM=;
        b=T4EEeNB76LTZYnOwBWoB+fVyPjltaY7XsTWooQ5h8xfj3Lkl6fsNOQht7sfAlNcgAj
         pywqI0YeMDONwzIHDzf6wRALOtgQHEug0QMeuddLpVoSxFsWh5CMLIdRhTMMhYPJLiXf
         9llF+enwS16L0eMbG3tKGfiehD7A8/MXOIa4EWmsfG8VZboLpyJsk4Mi/E/NtwxVxg7S
         /Z1V3sEbhQf4QailvXZV3DbWS+9+12vuyl4fm80W3o0v3UNkhZ9VENKmjMWwgcw9y/Nq
         YNhjxii9b0XIXM7SxMZqRvEj8C8iSmP4kVm7y0oOc2EzufKLic1sI7CEvkYf2CaKzAeD
         y15w==
X-Gm-Message-State: AOAM532aK/EiTa5PgD4AkuaXX6tg0sp4NvDj6vo/Ut9oK+SsxdK292lN
        /WdQyxbKEk4ndcZvkO3oM3zodDUwIe25arbYxSUpPXYhakEB
X-Google-Smtp-Source: ABdhPJzFKLbgYkO4NO4IB3wMusTphhf8Fr7ByRK/bLbrWWNTuOexjXInxkN1IaI1LHp/wtuVHitVRLYN5+PbAgk9W4HftEBBUtwO
MIME-Version: 1.0
X-Received: by 2002:a02:a619:: with SMTP id c25mr1115878jam.1.1629172209472;
 Mon, 16 Aug 2021 20:50:09 -0700 (PDT)
Date:   Mon, 16 Aug 2021 20:50:09 -0700
In-Reply-To: <d13c4e6b-b935-c517-f90d-d8201861800f@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d2d86305c9b936e4@google.com>
Subject: Re: [syzbot] general protection fault in __io_queue_sqe
From:   syzbot <syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com

Tested on:

commit:         16a390b4 Merge branch 'for-5.15/io_uring' into for-next
git tree:       git://git.kernel.dk/linux-block
kernel config:  https://syzkaller.appspot.com/x/.config?x=605725d47562aa78
dashboard link: https://syzkaller.appspot.com/bug?extid=2b85e9379c34945fe38f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
