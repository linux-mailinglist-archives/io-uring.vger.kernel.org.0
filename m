Return-Path: <io-uring+bounces-1544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B2DD8A4B5E
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 11:23:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE0A41F2289A
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 09:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36D73D0D9;
	Mon, 15 Apr 2024 09:23:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5763BBF0
	for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 09:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713172999; cv=none; b=VBsxgY6sE88ewC0R5LJXiZW//I1Nt989qRXkcss1sjWDYBADFlvpF/XVtWkmu7urgy9FIKBjM3SJIzmwmcNz+cTWdRr691rJQ3bC04RqTI90sCyveDXv7VGCpbOmIgn+/FxBNtcZQsoP8CUb8v4AyjOBhwKHv6bbPgiWdCyCOsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713172999; c=relaxed/simple;
	bh=Dtu2WwxG/82/wQT7AK8oq6ICr8XKHDmANozQb8jsroo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Rd2VoFDSSinCzWoM5cj1P3s7R15vAldRdGmNDFbstj1M+KynE/clhIMuK1MWiF+ZLUn1hmvW4j0a6hBYfcLi//Kp8ukSHz0MGP1BC/z6pyyl5npUSL+Zp/XqwpNiGgR3CCZKykrAGPRSqo7o5H7OMn0GzQQU5HS6mIcAuINl9HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7d9913d3174so41113539f.0
        for <io-uring@vger.kernel.org>; Mon, 15 Apr 2024 02:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713172997; x=1713777797;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mUJMCxqfhE36FvyCjh56U6tHOcz17K7U0ebNl+J8Q7A=;
        b=Jfllro3YnKXN7TbKdaJ0Dy5EOo3kjmVJF4p7sJ+RccQ9kACkZKg0/rx8QMThL2rOQG
         9DGSOw4YiIb2ZQKw7YJuvLb/3MhewvVDhzWahJF8k3QKs4n2KRUE/hOE1U3MH7ysfwRS
         2r5tQLbKme48xaQzGvOQPIMssd/DubKo+adjOONuOxDwZnj7iXg5gMre8Due7D13tPMQ
         VkxV2bJQyPy8s/dcAoPyipKQXhoxfmXCaSQhysoBMrRpYluIA23wMzD4ZsKMr16Ioo9g
         tDdXS41wCR2jVDKNQtNRMznMA0iJJnaJsGJQDq/y+Hp3HMYBndMtHdk1Z/QASByiSDm1
         vmvg==
X-Forwarded-Encrypted: i=1; AJvYcCVLOsPRQZ5qPVr9TudKbN3gcKmoYegm5kmlDka/AnpFL7zpA56z+5jZ4rqICk9EcUYusO8P2EIsWTU9KITE56jFz6Ac/MYE1F8=
X-Gm-Message-State: AOJu0YyoQvdF+qa17T1sYNbpKcPr1YawfuIIrLNFw13jYvqY4L9n98hi
	7PnOU7xb6BOvEVP016i4WbULgnyhBdv4GcjgtaHfHL28eo3glY9gRgpuQT8s5A0z3EuAfxV0b0g
	dHjSkzdK9oOv1sSxFMzKIVVgjwR+eXa8B7kgvMzrJ3EK5hGJ2/J2Qsd0=
X-Google-Smtp-Source: AGHT+IFi4hD53iFoBFrBLy8U0xxpWWqjcClXfDsSB5XiPFaWFrDCq8Ebp2J2aKYfmncJOA6xLQuF0aQCj5/6c+i5NBdpEN28Sebq
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c567:0:b0:36a:686:bbb5 with SMTP id
 b7-20020a92c567000000b0036a0686bbb5mr755410ilj.3.1713172997501; Mon, 15 Apr
 2024 02:23:17 -0700 (PDT)
Date: Mon, 15 Apr 2024 02:23:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f4875e06161f2b0c@google.com>
Subject: [syzbot] Monthly io-uring report (Apr 2024)
From: syzbot <syzbot+listd5c9c3b310f9577a0430@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello io-uring maintainers/developers,

This is a 31-day syzbot report for the io-uring subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/io-uring

During the period, 3 new issues were detected and 1 were fixed.
In total, 5 issues are still open and 93 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 3525    Yes   general protection fault in try_to_wake_up (2)
                  https://syzkaller.appspot.com/bug?extid=b4a81dc8727e513f364d
<2> 2       No    WARNING in io_ring_exit_work (2)
                  https://syzkaller.appspot.com/bug?extid=557a278955ff3a4d3938
<3> 1       Yes   general protection fault in __ep_remove
                  https://syzkaller.appspot.com/bug?extid=045b454ab35fd82a35fb

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

