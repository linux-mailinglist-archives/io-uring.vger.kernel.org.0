Return-Path: <io-uring+bounces-10254-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76846C12265
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 01:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B7BC425373
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 00:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896681459F6;
	Tue, 28 Oct 2025 00:15:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F244D146A66
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 00:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761610505; cv=none; b=MxssrJcbKDb3/nwHG7Ca82AsspOEBksjB27N0FvlAIvsQevERrLZgVTSK/puI0eGgUC77uNsKzRH2rAszyAISIRCYo5SLW+u/WzWYgapmqfJn6NdI5kTy/MFdfpVmDeczISKgXG43KbTZ3fKWZ7KglJmiGf889JDQaR+4p+IJ5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761610505; c=relaxed/simple;
	bh=uzfnWLFxIvMtwFrEBCgYkHpW0/Ml5HKc3AfKArq9gC4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=YpgideHk6Vg8n7qAktnxjPPVvG5SBwyjUaiG8E7+kgMJfDT+p9Kyt2vtR0plNwtMx1EmxSs18USq4+EIbF7Z3D03lsf+UtTVUMOLhawNBa89s1YCzUbuA7KqtfzvDN/0duqr4tGRWwZMK3tuc9WrNkpfzamdBkfEb73yjFPXsX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-431d3a4db56so222913835ab.1
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 17:15:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761610503; x=1762215303;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jWf0kDp5y+5z/noBRXEEOc1QSCxShctYJXY20kNSuso=;
        b=v1uvkOMXu76Exl54IrRv9uP7RGOhdFA9oK+wRxYSTtimx+wqRmB/J2+LwDv0/Pb4Nx
         A0XeqC4XFBWgulzc4Hdp9zrzevVW2Fzd+6kw2Mbu/H7vVrcNS+He+lNMxTbsvBIINkt/
         1SaitH2hSqTvGOpdka2PzTjn2F7KXP1chJbcW6WITvLc5TKEZmlWB/sb8XlKrL1ckaze
         x5hMt3HQOiJGwt1qr/FqVvDlUtJyNvf0LYWfqQUfJB257NSxFupMrC1WtJDeX582Vm07
         j26aSSRTS7/F6hlmhA67n1zfgJ/pRqg0EAMpMGeNjsrBziHm7SNBLHISWLgbAD91GfeD
         hlTQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+UxTf0M+mpFzfK1ZMUuNtfLyeOiA7xd97zhnx2KbEwo1xgm8pX6WtCUYhymsCAQiut+o1n3NwdA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7HaBK6Q+8XQ6kCJcL7w3jmiJPY2BiLolKficPSJPC0boIfunM
	/rT+m+vqVy5+kxUxJjf+4KYasJiqcHBxaNj16PqgJnqYX7tpsi5/jLSHOQB5Mp4wuzO44CWujba
	E7XP9uNt/FdX67BcfedCAmhwd1TBECB+JPB3N5Odml3XLswuibi9T4IqGl00=
X-Google-Smtp-Source: AGHT+IF8CRJR1Iq8jPLjLMyPyrQUhbuWJoFMgf6BuOjoav38DajO1FcHJDoxD76vNlMPiIuXp17VmZ33Ezqng1wzdfsvWoSMyPLI
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cdaa:0:b0:430:a530:ede2 with SMTP id
 e9e14a558f8ab-4320f842c93mr27299765ab.24.1761610503213; Mon, 27 Oct 2025
 17:15:03 -0700 (PDT)
Date: Mon, 27 Oct 2025 17:15:03 -0700
In-Reply-To: <20251027222454.8795-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69000b07.050a0220.32483.00cb.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_uring_del_tctx_node (5)
From: syzbot <syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com>
To: axboe@kernel.dk, hdanton@sina.com, io-uring@vger.kernel.org, 
	kbusch@kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com
Tested-by: syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com

Tested on:

commit:         8fec172c Add linux-next specific files for 20251027
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=140bac92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9da2d5fce59079e1
dashboard link: https://syzkaller.appspot.com/bug?extid=10a9b495f54a17b607a6
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=148753cd980000

Note: testing is done by a robot and is best-effort only.

