Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194AB32CE6F
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 09:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbhCDI2N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 03:28:13 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:47242 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236742AbhCDI1u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 03:27:50 -0500
Received: by mail-il1-f199.google.com with SMTP id y12so19890130ilu.14
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 00:27:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6Z9uhMMGUlxMK9WR9njyeuEFP6BA8lotMFqvBRev/Ds=;
        b=B425slzeBPmVu83NNHoO2XbHzbaXMJoUpajhZqew/ue6WWKAkz9CTpjGM57GATULhZ
         7QTs9TBHEGTBCX+AHApnNMzLeLyRNhBSA+D8POX87Qdv5DJFnNrhxP4cLH29Ej8CY+1u
         aZVdh4a2yqYsgeg1YOkHN0K8/WKJ6cmDzOHLe2W7e3LXU4CzzMPQDUgX4wI2eHNfzYqW
         DX0YIkWQ4K5eDSiAxucbkdzxjTb4BZEq+6CZoEr+cQ+ukpEpcWh3jLWMi3OO7/pGeJQx
         6AA0jqCGZfkGl9iUpHrY9HkgdY88oVahsOHu2zya3iblQE92U66xj3ZbtuWeHWwOTbms
         g5qA==
X-Gm-Message-State: AOAM530MUswE3RKTQibaGIW7dPUklrBDfHS2ET5oM/r2zccKUCePQrRp
        6FMfHPAPA/M5RroiebUKPW6ni96EMn9qxQ3Qclqr/eUFVJfE
X-Google-Smtp-Source: ABdhPJwsIfXz6QM1K0WwnCEY1jn+iyk7Wg9ebm+n6fHKt4lFAt/z88NBe2s+PUYaxC9bnn3OGmJtWB1tIGvARGYbrHlRisIdqm86
MIME-Version: 1.0
X-Received: by 2002:a5e:c00a:: with SMTP id u10mr2646759iol.165.1614846430408;
 Thu, 04 Mar 2021 00:27:10 -0800 (PST)
Date:   Thu, 04 Mar 2021 00:27:10 -0800
In-Reply-To: <8494c673-180e-e0b9-4db7-04aed2aee791@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9f38005bcb1bbec@google.com>
Subject: Re: memory leak in io_submit_sqes (2)
From:   syzbot <syzbot+91b4b56ead187d35c9d3@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+91b4b56ead187d35c9d3@syzkaller.appspotmail.com

Tested on:

commit:         e64db150 io-wq: ensure all pending work is canceled on exit
git tree:       git://git.kernel.dk/linux-block leak
kernel config:  https://syzkaller.appspot.com/x/.config?x=c43bda1f1543d72b
dashboard link: https://syzkaller.appspot.com/bug?extid=91b4b56ead187d35c9d3
compiler:       

Note: testing is done by a robot and is best-effort only.
