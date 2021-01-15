Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675D72F7045
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 02:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731738AbhAOB4u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 20:56:50 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:45891 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731674AbhAOB4t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 20:56:49 -0500
Received: by mail-io1-f70.google.com with SMTP id x7so11693341ion.12
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 17:56:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ncZ/WzJQUIaZu3+7m5TtE1ri5ZOaqLZKDq6RjJFvj+w=;
        b=h4eEQoVrdDJ5fKugSzKwEzA/AMsLqjLGLVBuqHr2xMXNUZ22/Sj/7f+u5VWKXrSMuo
         9yOwya8eLgODQFTlq7Gq+TxlUCnTmZkBzh/ETfXdPD2KvDtgbhh2Db4NKDL7VeckKns7
         ohqW/MIIaGaHIJn4Vr5VgOB6xT2aV4+hsrYehG21rDkFayW81CqjAtVQsgHey7g2Eq+9
         rbr/EF2SUT5wozC+jgicoc0p5pVR30YYbpBJCWS0G9XB8pQi+aGlgdSmWxIDk+MRP2iP
         NRMCH2B+UOiPtpN8mZrW3sPVMmkyLOoIJ7Am/qWYiCOOmvw9AYOgGjhIEDAvzWPKnjOX
         Nv/Q==
X-Gm-Message-State: AOAM532zzV+s35c+UJh4DltkwCSm2Lz/u+1ivBZa3D65K4yL2QrOlVsZ
        chExBEz9WJa/BaOojwY8i8fECHgCAkdFTAE+R1We0E90sM4m
X-Google-Smtp-Source: ABdhPJzcQ8wyRdLc8a7inJRiioJ0+IrT14u7jjxP9VGFzlE0bTFYJ0MvV9pxct46dDj7tGP4U7c/A90KqTlPUY7sdjqxkbRGNE+f
MIME-Version: 1.0
X-Received: by 2002:a92:1589:: with SMTP id 9mr8729309ilv.39.1610675768680;
 Thu, 14 Jan 2021 17:56:08 -0800 (PST)
Date:   Thu, 14 Jan 2021 17:56:08 -0800
In-Reply-To: <f45bb2df-5ef0-bc36-8afb-2c03257cc2c1@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000a65ee05b8e6adc1@google.com>
Subject: Re: general protection fault in io_uring_setup
From:   syzbot <syzbot+06b7d55a62acca161485@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+06b7d55a62acca161485@syzkaller.appspotmail.com

Tested on:

commit:         06585c49 io_uring: do sqo disable on install_fd error
git tree:       git://git.kernel.dk/linux-block
kernel config:  https://syzkaller.appspot.com/x/.config?x=54595eacbd613c0d
dashboard link: https://syzkaller.appspot.com/bug?extid=06b7d55a62acca161485
compiler:       clang version 11.0.1

Note: testing is done by a robot and is best-effort only.
