Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E31B334187
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 16:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhCJP32 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 10:29:28 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:55041 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbhCJP3I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 10:29:08 -0500
Received: by mail-il1-f198.google.com with SMTP id w8so13082673ilg.21
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 07:29:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=K6Wm1ki0OuY/h4OHfpHCmRiUcTgPHLwbneYsELCaWwg=;
        b=EukAB2HorKPIr9QA+20gYqkWu6UGsn6xm6T5oNQhvHefZkv2+r6+w4oygIjI/YU5dt
         hGX4NnVJasWnD1TP5SLUuODnZOA+hHR4ZoU4yiVnXTpwV6i5xHiKtiet78YUcwt1oBGl
         LfeB7MYeaRPBsFTLg/YZeUqewh1QsZK5x/yJd5oGtFP9+xiGGZMm6wzIiTVkAcov1vyZ
         TDnnW5X++s7Ww87nlET8RzHvfa8RXRb7ig4FvZvytU002ong1O/fEZnmapkBKOG+uAGW
         QIqHt4xOuVzQn4NvwhbwIAxxmdW1tIp1JC5TIek1KhTdXW9HGta5IH7kZARhJZsKd4nz
         U3YA==
X-Gm-Message-State: AOAM530qMGUJU5b2AB7QUDGEcKVXTF1RIElMpNaGZkYdBjBn8mT7ZGvL
        UEuDfaSyKiCcysHM6eb2euUGl4z8A/fB6GQasjE1kutIREtt
X-Google-Smtp-Source: ABdhPJxkmz59adw2FmI+wtjU9F8hGi5CsBgfa+Lt2Ud8V9Yi1BwLSSQKFpesfuxmMpT07ysaEjv62L0NUSLB5mdzmPeiCU6m/InK
MIME-Version: 1.0
X-Received: by 2002:a92:cda2:: with SMTP id g2mr3026959ild.297.1615390148344;
 Wed, 10 Mar 2021 07:29:08 -0800 (PST)
Date:   Wed, 10 Mar 2021 07:29:08 -0800
In-Reply-To: <82aa1cb7-9ac4-6c7f-f6c6-baeca226365f@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f7411105bd30538c@google.com>
Subject: Re: [syzbot] possible deadlock in io_sq_thread_finish
From:   syzbot <syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com

Tested on:

commit:         7d41e854 io_uring: remove indirect ctx into sqo injection
git tree:       git://git.kernel.dk/linux-block io_uring-5.12
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3c6cab008c50864
dashboard link: https://syzkaller.appspot.com/bug?extid=ac39856cb1b332dbbdda
compiler:       

Note: testing is done by a robot and is best-effort only.
