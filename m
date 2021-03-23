Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257EE3460B9
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 15:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhCWN7Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 09:59:25 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:49561 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhCWN7H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 09:59:07 -0400
Received: by mail-io1-f71.google.com with SMTP id d4so1919182ioc.16
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 06:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=IhKG3MYgdHkC79O+28ScN5gOw2LVA4+B7uHCcbfLc28=;
        b=TUY4OTD+2pFGC8j/uWcR1Ejm7KZk87ZGzSlm4osI5LKT1ivhigfU2rGvD4nzs45pRY
         J+Hpl3fXjxkrQTBGw/hI3IxtpB4Oce/5c5zszlkqGo4BDrRsrJBFtcABj86yvnQBJzDH
         zKs2FFxxxDnK/221sz/EsdBJ8atJOZ5G9kqiYqNY+vMkayj5ekkjFU0fjS8jw3htTBVq
         /Vxkm1QaH5vG4dS/fQNFcyQ655fz1b/Mb4j+/U39/FZzzwL6kJlEXFdrmee5ln7ydzRI
         9txNGmOwjUIBuaZGkTr4BB9bD+7miIK5siuJPy9oT4vAIQfA+7cH1Vkq5D3YQA9ZMcVY
         DYTA==
X-Gm-Message-State: AOAM532B4OEuCS3ogAgiaR6MpHGwdAnNa+RFgY57BZyhRqwBfIMh3biR
        HvX8ppWT928Q6TwPfF0OUlv/eS8p0BWVRF2Nw2cK/mJJ82tS
X-Google-Smtp-Source: ABdhPJznONeEXXNXWc8KKHAP754N/Il2V1ODQj7xOqaRoQuL//ZMBvASsl6/iQv87QKzZzrkRCzzIVZkmvMQ88laL/n9jzENPm85
MIME-Version: 1.0
X-Received: by 2002:a02:8545:: with SMTP id g63mr4590835jai.79.1616507947073;
 Tue, 23 Mar 2021 06:59:07 -0700 (PDT)
Date:   Tue, 23 Mar 2021 06:59:07 -0700
In-Reply-To: <e339a963-8ccf-eb47-c155-640b848f29a7@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f6475505be3495c0@google.com>
Subject: Re: [syzbot] WARNING in io_wq_destroy
From:   syzbot <syzbot+831debb250650baf4827@syzkaller.appspotmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> #syz test: git://git.kernel.dk/linux-block wq-no-manager

This crash does not have a reproducer. I cannot test it.

>
> -- 
> Jens Axboe
>
