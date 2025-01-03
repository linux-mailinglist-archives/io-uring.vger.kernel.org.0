Return-Path: <io-uring+bounces-5656-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E141A001EF
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 01:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2BF0188346E
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 00:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1510217C7C;
	Fri,  3 Jan 2025 00:20:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84F9F9DA
	for <io-uring@vger.kernel.org>; Fri,  3 Jan 2025 00:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735863606; cv=none; b=rXaSmcnqwbzW3DVWQm+ciS4FobqZDkeY1K7WjsjkCdL3TdgBekixKVpdDrHkdkbU3X2kcVIu1LY7YIVUHpXnAJkyPb54dbz7Jt1Zv7xl1dOf2c3L5b2xTv/RYmsCZv2ruJFp8iyiT3itiM1ejixXoW5p1cAuHH8GIa3NDO+qhq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735863606; c=relaxed/simple;
	bh=WWcp0irU0J5yGtPT5dDZbYP07eJRcIp0iDYISTNZCWY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=c3hS+AzJQ2NcXqw/1yetCLSOeOmBfF78yjJ9V2Uy8zIahcECjdTNIVryrb/Ol5a5498kvfzTzTx2NIcmmB/EL81rb6NHT9GWK7kPhndQDEcFHoHe0QzOpfBoRADyZOYeftdZQ/dgub8LelOVdC3/mgRJuF+iGaJg0eIgp2cTQ9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-844d02766f9so1003398539f.1
        for <io-uring@vger.kernel.org>; Thu, 02 Jan 2025 16:20:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735863603; x=1736468403;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XISUtGMZwvOxE/3eJlDsq1s1rOR7WzfL2zvWZEQxPKI=;
        b=uOHQHaw/Bj/fFMwEwZNefnp0q8rH27AK2XePowLdR3VjNoKYmlHqp2K0EnlGNqTMO0
         2m7prF7joFDCLWGGP5BSpK+EDnbf/DPjUVT0Qi8JSu2zHLIjyKyVI+KXVdTbQKIFZyAm
         ufRO7xqC3puXSNHzMMDvvUq4A7ycBVOuoAnluvWzOiEg74IdgAKuiKFcSIoPVse3XB9p
         suqfJ+46+1Ir4dCqDZHTlkBFvJJnBX2vuGu3JX51WAyF4e8UsvOkLCwI22GoNqYAaIXK
         r+WVAlnKxbgIub/dTzA+CeOdhsI7dTeYh70z1D8rsvxqOOrJiBbMggik9gHuXwfC7c85
         wvBg==
X-Forwarded-Encrypted: i=1; AJvYcCXqnuRnK1SuTcTTAmmLUHCqFLlYXL8OU9p2+mxDVE6h8yDvNvCt/TQG4HqD3/7YtMEK8dEw3edc+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5Fd90cWhiquXnzyrOv/WACXyisTPnFBwoTPLBlNx0EEOYHc54
	4niT+8RHNLnucMm6xG/2xkGrIiK1aFrLIl1W2L500In/XPP5GiaZk7D3OsoGIGWjD8RZuZEmAxI
	Q8C+VNDbCSJ0yus8swYZisuqlW/8n4Um5gskMieiB5Xb/nOzX6P1zlxc=
X-Google-Smtp-Source: AGHT+IGlLNkaQjv9q0k3luV0vr59CtP+LszpXsq9XEUU4WMYgppxAYPpZ3UyCt5dn/eyZZjk1Feah3QbEiZu9H4M++b+uPa2kA6z
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3b84:b0:3a7:bcbf:ba99 with SMTP id
 e9e14a558f8ab-3c2d2272e92mr443826935ab.6.1735863602999; Thu, 02 Jan 2025
 16:20:02 -0800 (PST)
Date: Thu, 02 Jan 2025 16:20:02 -0800
In-Reply-To: <a6602071-9c8d-4a53-8cb2-29ec75ca73ee@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67772d32.050a0220.3a8527.0057.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_recv
From: syzbot <syzbot+068ff190354d2f74892f@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+068ff190354d2f74892f@syzkaller.appspotmail.com
Tested-by: syzbot+068ff190354d2f74892f@syzkaller.appspotmail.com

Tested on:

commit:         c6e60a0a io_uring/net: always initialize kmsg->msg.msg..
git tree:       git://git.kernel.dk/linux io_uring-6.13
console output: https://syzkaller.appspot.com/x/log.txt?x=12de98b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=96ee18b6611821ab
dashboard link: https://syzkaller.appspot.com/bug?extid=068ff190354d2f74892f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

