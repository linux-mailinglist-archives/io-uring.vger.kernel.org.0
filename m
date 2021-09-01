Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BCE3FD1D7
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 05:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241626AbhIADfC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 23:35:02 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:42589 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241617AbhIADfC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 23:35:02 -0400
Received: by mail-io1-f70.google.com with SMTP id i78-20020a6b3b51000000b005b8dd0f9e76so784942ioa.9
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 20:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Ruk1eNA61TEh1q3FM3cLWHsGyGqg/VpTBs16qFZP0nA=;
        b=RfE9lyFIOzq/0Se4aU1EmeKO9qX6FnwKTIokxK2MmtB0RAckXTh/yrDI/wOmWcZJTw
         5dxGxkzQ+okTAn9wqI2PTpJOo2PQuPX7tO5N1eH9vaoH5yDnvbjUqkKtRqUw+C4tUvfY
         QiwpTUoJ72ZsnIKqv7i2JWxnt4uR/NW3SpvZHcyCFNXcVNJsHxwNRKYffmmlTR40Av6H
         TvQskqJ3+N3ZXbAjSQXwb5ZlE23nzsMsanEW83CjrNRwcIw961iSGI3w3rlpb1JoqYdJ
         1wgiO+li8zLdjmO26GCbkeJqsjpdgy6uTftHw56J2aAOB4LPim7u6vGBmnxX+IhfTiH2
         oPHw==
X-Gm-Message-State: AOAM532b3oPScfvyuUuodJk9Zgxy4Ue0UoIQ0MRkG1mIBK21HdZP4u6S
        2557ClCeJkpbyXJ6ms+vhMQ/s4KF/893QFGAgbbxOkaxPfVh
X-Google-Smtp-Source: ABdhPJxQOY9wix7ZpJL/KvZsxmj0PrK5sksw1XSgKwr6SC5NM7n0xv3FKu683GMXeJ7sEK2iB+oEduv9uMiPd3dXRDqifN6lcB5B
MIME-Version: 1.0
X-Received: by 2002:a5d:9da4:: with SMTP id ay36mr10369641iob.153.1630467245981;
 Tue, 31 Aug 2021 20:34:05 -0700 (PDT)
Date:   Tue, 31 Aug 2021 20:34:05 -0700
In-Reply-To: <b4305afc-ff25-8388-1ba2-e761129a509a@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000003c81405cae6bdfd@google.com>
Subject: Re: [syzbot] general protection fault in __io_file_supports_nowait
From:   syzbot <syzbot+e51249708aaa9b0e4d2c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+e51249708aaa9b0e4d2c@syzkaller.appspotmail.com

Tested on:

commit:         a64296d7 io-wq: split bounded and unbounded work into ..
git tree:       git://git.kernel.dk/linux-block for-5.15/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=765eea9a273a8879
dashboard link: https://syzkaller.appspot.com/bug?extid=e51249708aaa9b0e4d2c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Note: testing is done by a robot and is best-effort only.
