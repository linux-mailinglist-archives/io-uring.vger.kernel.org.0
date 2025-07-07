Return-Path: <io-uring+bounces-8610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD47AFB893
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 18:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A83163ACE13
	for <lists+io-uring@lfdr.de>; Mon,  7 Jul 2025 16:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C37021B9D6;
	Mon,  7 Jul 2025 16:27:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B442135CE
	for <io-uring@vger.kernel.org>; Mon,  7 Jul 2025 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751905625; cv=none; b=sSaOllJzF1eMJ8spNkLReaCu0a92SOFWevd2NVAagYkemT/NIxbAyDmVsuPFwFMKwVl/qr6+YsJysAxzC4tp6cZ9QpYzZVvnyZ4njN91tY4O92oTO2bbcPUvaRhfvk/bbvpWSj6Hou19wfmRMlIMCV64xIq4WjtaI9Oye58UUwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751905625; c=relaxed/simple;
	bh=tc7S7/eJ+4S+9/JAOptsRxuYDB7uxt0LSF1mHlb94MA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MUPWzhrqLlv3tgvk4KYqGwQFknXi24ak26VY0YgNCdoCAkPosG1F6tCDFcbbXRo2MJDafdHOFfTHSOex2Cgavc8aStTDDdH12v0Y+M+YRlwggfBegCTvASWZsjbUzygdcZc083IunA0uagIGGoIk7tUVb3pR4vHPykjznZuZTSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e0574d6a99so39187535ab.3
        for <io-uring@vger.kernel.org>; Mon, 07 Jul 2025 09:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751905623; x=1752510423;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xd4C3A0IQjFn8w25wCpwJKDvBmxbazZS3RQuLT16nfA=;
        b=THHGqC93ksN95MfXfGQFaCL7c4bjFcKS/F+NIcOmhCA2PWi+IE0t+H1QynYNmhsVEF
         ehtJ1Slw8sqz1upNC2lgc4pgeVlTc6dXw92FV2EYDTLVNS/WJO2SgFsuz4xifTkq3VOv
         nH6+lqubGedLK1TI2mLGGZvoFUeSwOvJ/JQEv7X3ST6Jtfg7yFuU7EFEvB/APmxMZo24
         WmaPanygWTTIsXNsPtopXujl/uqixIb6tFRrGJUzdamzhCxnlk3xRm40ByyarzC7W94I
         H3Imv2viZfKTF+aTwF63JFFx2hNHuwe6QII2ybJwyePiObECqiM7AU1KuzXwScz2YYsU
         Ul9g==
X-Forwarded-Encrypted: i=1; AJvYcCW8/Ri1YXqwMVwtcaSVp9htLhcG3rP3gKabxHI5SW6xqgECvBAXI784IIRiYfJbhXo/e77Hlob6kQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjtfOi5EbkQxM2t+YO6+MlHRiVlrVt6yHkmA5Krob81YSbCadI
	6CShM2w3e5HW1LArWH4iP6wmrXg5pYFdcobnSZ8FGYd4tLGQtJiJZdWfY8wF8Fhdc/C2tNwbOMM
	1HB0SoP3NWtH7DaBpNWURZZf42z2CfljwxxCbLYCcAFJVkjlWMjK5CVfe6EM=
X-Google-Smtp-Source: AGHT+IHzzX7Mg4FWi1z+qau3zmFOwheiXBj8VZFTP5NPpqzbwVV1SNLfCRtgBd4ZnG2nf2LTtvp0fsLXmVTgqzJqinccbR/z9+l3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c2a:b0:3df:49fa:7af5 with SMTP id
 e9e14a558f8ab-3e153a55f96mr3025755ab.21.1751905622720; Mon, 07 Jul 2025
 09:27:02 -0700 (PDT)
Date: Mon, 07 Jul 2025 09:27:02 -0700
In-Reply-To: <6710d2a2.050a0220.d9b66.0189.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686bf556.a70a0220.29fe6c.0b0e.GAE@google.com>
Subject: Re: [syzbot] [fs?] INFO: task hung in do_coredump (3)
From: syzbot <syzbot+a8cdfe2d8ad35db3a7fd@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, asml.silence@gmail.com, axboe@kernel.dk, 
	brauner@kernel.org, frederic@kernel.org, gregkh@linuxfoundation.org, 
	hdanton@sina.com, io-uring@vger.kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, luto@kernel.org, 
	peterz@infradead.org, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	tj@kernel.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 2af89abda7d9c2aeb573677e2c498ddb09f8058a
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Thu Aug 24 22:53:32 2023 +0000

    io_uring: add option to remove SQ indirection

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14ec9582580000
start commit:   05df91921da6 Merge tag 'v6.16-rc4-smb3-client-fixes' of gi..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16ec9582580000
console output: https://syzkaller.appspot.com/x/log.txt?x=12ec9582580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45bd916a213c79bb
dashboard link: https://syzkaller.appspot.com/bug?extid=a8cdfe2d8ad35db3a7fd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a2228c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d48bd4580000

Reported-by: syzbot+a8cdfe2d8ad35db3a7fd@syzkaller.appspotmail.com
Fixes: 2af89abda7d9 ("io_uring: add option to remove SQ indirection")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

