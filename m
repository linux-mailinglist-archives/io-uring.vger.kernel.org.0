Return-Path: <io-uring+bounces-9957-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C3CCBCA63F
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 19:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EB05188FAA3
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 17:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D9354654;
	Thu,  9 Oct 2025 17:36:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150FC245033
	for <io-uring@vger.kernel.org>; Thu,  9 Oct 2025 17:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760031368; cv=none; b=g1p8TewDvG7w8RJgHbHB6tMensc+n4CTZsnxF73Ae3rV7AOA83eFPDuc+Gcup2cobq7aKVerJ7Bq7Rq3XNC1RP0YQUajmqVP+EELgY54o1dHj/1ZdWpHxbNVBFyB4hRZqRZPqEa/YBx5I/x7pN/pL+dxFJmJLeq/31+r6sqwruU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760031368; c=relaxed/simple;
	bh=OpV4TsGF92X3oiskZRRC6V3HdMHdVZa3kcGuZNK4DV8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=GLaGOvsJj7HSXtR3x1F1PcR4pwcn0YgRam0mcK+hZl2f0iMkYBFS29lz7wfLxzjHF+U64SpOAx6jGs2AaBiVOvcuJmW4nYrZCkYWvTTH0wd2BuE1vqHSRZQoS8O9S9HliKkTYhY4LVAMY9C4aa+MQC1dHmt/6DDZQvqaa1C3jAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-8877131dec5so264850439f.2
        for <io-uring@vger.kernel.org>; Thu, 09 Oct 2025 10:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760031363; x=1760636163;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k4/wNl39+2c4C44X8Q+rbUZnGlTwKglY852L6exZeSg=;
        b=jzu1bKHQWZ/TBXMK42HgjY9bOaKH8FrRNOWjjBwC7yAHzMmNiBBycZWpOc/AFcM24J
         x2+S36Oyicz6G+VzoNN1+azzbaVELQ/sFNrSVPOW2bAd2IHjVbKLrfCFp3tigtSTJyhM
         H43vgR3ZQw2HPRWIersG1B9sYViciFrtHoO79tiacbw25Sq2QJ3Io1l40iOQEJOfKspU
         zpiGRv7pCWRmzhCOZdxIH0B5HjQiAzfASQKXy5H22pad56/b1jjP/KN+qLwKpfi5IJcS
         FfHqj0Zncf7AB/lSUq52nGTR1MxWNpESaHeGdLjiXAI0ODgt4RhjLeZfnwUQqisa3Bio
         xIdw==
X-Forwarded-Encrypted: i=1; AJvYcCVTFMZHM+LeFXKGwNpFoQcvJCjZeE/fzzJUeKoxZmO2qOSPD9T/TSLBZ2fb7ReLrTbFfVJlxjDM4g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIAmm2UDlOWaZ1M1i/Ci9gIaz4T6W2K8IuZgaKaKDwAx5EHexo
	ZGw0gJqsM3osYmU/0xwhJpTXOfcewDYziUEzZ16+/6t8uBb4GwzBWMvAjqV5xPZ1BAjoF9D8aNi
	0ixaqmXTqikMunwCmKxqQNHJOFdosDrSSctJ+fe5cJxfqXWdshyexnuyfqCA=
X-Google-Smtp-Source: AGHT+IFyyeL+us2LF1YiBURzVWw058rW2fTifH+zt9ge+YLvksn3kTnKBmg033NPurehAtV13ccGg8ZWLR65I3gruITP4jFbFG/L
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18c7:b0:42d:8a3f:ec8b with SMTP id
 e9e14a558f8ab-42f87362229mr74454055ab.3.1760031363121; Thu, 09 Oct 2025
 10:36:03 -0700 (PDT)
Date: Thu, 09 Oct 2025 10:36:03 -0700
In-Reply-To: <d9f47040-4a12-4584-8293-8bc2719cf263@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e7f283.050a0220.91a22.000b.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in io_waitid_wait
From: syzbot <syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com
Tested-by: syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com

Tested on:

commit:         554d1823 io_uring/waitid: use io_waitid_remove_wq() co..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=10fe1304580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6da9233e22696ba7
dashboard link: https://syzkaller.appspot.com/bug?extid=b9e83021d9c642a33d8c
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

