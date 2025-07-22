Return-Path: <io-uring+bounces-8773-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 393CCB0DA8F
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 15:14:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F9C41890142
	for <lists+io-uring@lfdr.de>; Tue, 22 Jul 2025 13:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5B62E9EBC;
	Tue, 22 Jul 2025 13:14:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8996246770
	for <io-uring@vger.kernel.org>; Tue, 22 Jul 2025 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753190047; cv=none; b=KISJ97eZWPPI1b4rs1+M36aEurXbmcIVYnX0rA4bAMGEkG5fuvg3Xyf6b7JtQycSO21BWvtSgo9ZXnoDges/uaslhx/VoibG5VeonIuGilYdyt+a/RFPwXibNBlmDtMyNQbQVboHqol4EYWSjmq/ltvSw+5bZLa9MLuv584nYf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753190047; c=relaxed/simple;
	bh=wQL9RZiqmv2J4tT1vLX3wh8pDTuNjMTc5ALQpqpom6w=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=FP/jyBvD3btkWZSFkNvxcYF19dtAregWY1zu8pU9lbog2amQUfxUVsB5RnMgrr/ZAlxqUjJJqgke+TkAbyb74n4uY2ai4SoTZD9dF1hFtv2728bQtMCOmRdmOhlOan8dq05o0dyeRMnQ6Rha4ENcL2CYnnHqSrOX1YBZFJ9n/Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-87c056ae7c0so1000538639f.2
        for <io-uring@vger.kernel.org>; Tue, 22 Jul 2025 06:14:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753190045; x=1753794845;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiR6ctww0qSKcSywG2l39+m7qh7QrL5zsr/Nu/Xh+do=;
        b=cR1qRIGhWdOapIboKU2iVPvq47b4NQhYV176KKQJ1lLnmfuMYG9drxSTpQ0LeInv7N
         bdr+m3TQecjEloQrInJlJlCyGLTHg8+URq/4omXI4xH4mqt/u2jFZJhlumJq2wCj/zi2
         uVw0Zo4KQpaWHw8jQu44y+fFTO1eR3AjXMfUebR1HmvTrd3D82m7hohX6UbSqLxIQhry
         HqPdlrUrbfMcXXpEP4jbjE9lvytiavzEsxKqPIVNn55p5QpOrnD2KYG6pTJUuB6e3Nyz
         5A1nh4xLGGcRnB8uMrhoit8ewH/4HaNWfXOl5hHFsovckNEDRfGSWulQGMcKMU1+u5QG
         DOqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqbyaZ1eJEavXcQW8SdfKkV53Xmh61G4F4pSM8sIGBLJZvfoD1m6W+3YInu1TKI7Ps7mYRuGhD2w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJEkr4x2RE9Vv4bUvZcmorTTuAvy46hhx5KZkqlZtTXH5BnO2q
	dDDhCDXyGI+hVrlDllfirRcrNtGD1V9gMnk4vKSfSvfugOQ2uUhe3KMYxTw+tYcaXgPbFSlFdyD
	Ax1jm6oUoeNVDdj1yn0HNdrMMWeIgfpsk46GdnBy2gJEgcVcua6hJdcUWsTg=
X-Google-Smtp-Source: AGHT+IEgkNvzb/wDkbygt3hT/c/l8powZYWGAu7q2mXKyeewStKY0dhh0A1IyDnOieB2ou3KBMKN9RtlTugwh4oGJPH2DsYkeP7n
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3fc2:b0:87c:3417:cc11 with SMTP id
 ca18e2360f4ac-87c3417cf50mr1388116939f.1.1753190044896; Tue, 22 Jul 2025
 06:14:04 -0700 (PDT)
Date: Tue, 22 Jul 2025 06:14:04 -0700
In-Reply-To: <cf0447d1-3590-4540-932d-4be299edc432@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687f8e9c.a70a0220.21b99c.000c.GAE@google.com>
Subject: Re: [syzbot] [kernel] KASAN: slab-use-after-free Read in io_poll_remove_entries
From: syzbot <syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com
Tested-by: syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com

Tested on:

commit:         89be9a83 Linux 6.16-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ee5f22580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=186272c644ef9aa3
dashboard link: https://syzkaller.appspot.com/bug?extid=01523a0ae5600aef5895
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15cf24f0580000

Note: testing is done by a robot and is best-effort only.

