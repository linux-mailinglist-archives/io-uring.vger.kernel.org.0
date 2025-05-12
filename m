Return-Path: <io-uring+bounces-7956-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B45AAAB3BF3
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 17:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F1FC189E864
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 15:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BA922A1E5;
	Mon, 12 May 2025 15:24:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A322E81720
	for <io-uring@vger.kernel.org>; Mon, 12 May 2025 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063446; cv=none; b=lCcc8gOLqOy+jsK3Fp2k0U0LTtWrarlSYmLKOv7dW/B2MpS5yiT9b07GOgEX14KWQNGJEWB8J0CpDxDJXThynv/CL7dnLodQwXj64VQt03KQeSlRrjbUyHI8ZskkN/0dBZ1OZQX0f62uuJZafVS/yCtbX0+PZIdF12zxT7M3Bxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063446; c=relaxed/simple;
	bh=H0DDwxrK4nk014vG2Rrw9izMLB2qZ9CfadQdCTvwcJQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Xwv2Ag9L5uzBE840iNAalhCC/OXyq57d1K3EH3V2DtTcJLIoWo+Nk6YVBYXUluEHxDChUVAQm0rROzZpEsxThqxL0s6jdeKTR98Afvu1+8c2HD+W3BzC/s4voHJUfRAUPHeqJDPJTI2Ye9WUcHAVxj3jk6OPgNliTnQcB0RnCcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3da6fe3c8e7so51835715ab.3
        for <io-uring@vger.kernel.org>; Mon, 12 May 2025 08:24:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747063444; x=1747668244;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZmZA9Uj9z247LJvGyARI22vNBWgiru+KG5DXuI+cuLw=;
        b=JTQmXC87GbQR5m7NsbIhJDCf2GblG/7r8AqN+VwBglX6fH/CjZW6cnrmqmq9yl8bAz
         bGDU6phtO7vXlOAsB/2rE/BVmmPPIevyqsuGzJMwcq3g+ACYuUiNzh0U5ejNTiX/jB16
         wonLhNn4kx49waN0tpexKiwRall3aoAZVuqdYRHCbx9cFtO9pb4HZcLSIJ2LdQyA35RT
         PRwu2J0o1O0jr6XnsY1g9wQZD1PJ41cK9CIs3Ygozf1o1kejdSN6WqSUaaI9x5FCrXpz
         0mv0vW/l6/3NMhH7FNUwYaAKNX+qDbU37Fse5+0HTvfPu0eZZbMEvJaf2uOvSmy9AgvJ
         8hvw==
X-Forwarded-Encrypted: i=1; AJvYcCUXZlnk5ej3UNJZEhqInkiPA9lTkOWYavvtmHJ83PVEF6IgykXSPrKdtN4fYMoV+ycf7nWapMGPWA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2mWZXuWn5HijG7tLQulxBYZHgfk9ZSJMsMPG3ECGZ7Ay/vijC
	wwJvKXunko0/B4RkxTnVY3H2rd4vxrS4R81+Q30n62EtuHc/Mkm6zaIE+Xg3ExEMuZDjs470yhN
	cpGdaVtHSf1FbFr1qCN/HN3kN+XV+wp0rtzO1MJd4wLPnVF5qs4bM0Dg=
X-Google-Smtp-Source: AGHT+IHu0Dta9/E7nRFPcyxr7oyq3qbqYdYtoC7Z89KJRIQJ3EjxyX5ClU0EGCzh4poDNIDgPJdtUW+g/kURo8K62UjQCfEKu2wf
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c26d:0:b0:3d9:64e7:959f with SMTP id
 e9e14a558f8ab-3da7e217255mr169104815ab.21.1747063443783; Mon, 12 May 2025
 08:24:03 -0700 (PDT)
Date: Mon, 12 May 2025 08:24:03 -0700
In-Reply-To: <89a530de-83a9-498c-bc8b-844ed0d183a7@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68221293.050a0220.f2294.006a.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in io_buffer_select
From: syzbot <syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com
Tested-by: syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com

Tested on:

commit:         5a479bcf syztest
git tree:       git://git.kernel.dk/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=108f92f4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a2f09b26321f0ad5
dashboard link: https://syzkaller.appspot.com/bug?extid=6456a99dfdc2e78c4feb
compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

