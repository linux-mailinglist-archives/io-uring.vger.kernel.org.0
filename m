Return-Path: <io-uring+bounces-10307-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA72C22BF1
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 00:56:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B875424E09
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 23:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267593396EE;
	Thu, 30 Oct 2025 23:56:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABDE2ED15D
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 23:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761868571; cv=none; b=M+3p1PzHpm140h5Ol9pKtCxpGjjjvRZWDUSuiPkwn0PLvg/He1ELTxgr8EpBFRJTMzRgl3I3qgcdSeBCgmKjqT29qdvizHOJD3dT3hDsN11N14kHf/uwIPW26wn8jY/POSqyMRHcCzbwfukcKoaZr19KK6v7VDVKsONdPpfUID8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761868571; c=relaxed/simple;
	bh=o/OZIeDeXH8K1U+tFWTSwF6pEz06nnG1mnkwjBolS64=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Nr+IhUeaClFf/ykwBgjlL+EGPu3NpiClF0JEJzpf9dcbo64Gx2QgFmuvcJruc/cEC0/X0vhbpzzf7Uja4EqkQ0OFDvPxLhHZjm9wBerX6qP4btlYgng6vfoAWzoy5qIMf+oMoPO5I2vwQXkHIvCAb6XPVPXj0CQGaHj7L3VZaeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-431db4650b7so26518755ab.1
        for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 16:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761868567; x=1762473367;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AWFFh2AXjRlq7SHpupGD3VhFF3GWWQYUnN0po0lMdKg=;
        b=FvuFc8ApmWOySX3Boa0EEgBor6Z+j3AwlXQg4O+NhhRhoiDxRFSzFQHNbJC2GmAEFQ
         cFtDD0c8Cqb3wNJtO9RrKOQOF2LxfQGlVzyBUjoIooGGCFIXlvpkfUqf3Ooe6ooa/rHX
         nSOlpPosCtlZsYARpD3qPfu0V+WdHfqJ2ozLyGaLB+lEPE3DNAdbv27qDNkQMVUCVht9
         pQ/2hsye4Gx5ZorZ+W9LAhi3NVFhxfPpQlcUX8j8/evMg+y0Oz8PS9vheuyTaO0bICio
         mDpaVIVCYhcBKe7Ify4V25RUQHSBwxbIu4yJispgQCNmshleNjHd4YyGfT7woelBJNkI
         iBow==
X-Forwarded-Encrypted: i=1; AJvYcCXYa9bx/7nLRXOuDd/ICRrZHgidKLg0KJoouyn0rT5xEkOhqqm1pXJCxqR3qM50FaNs4weA6kDd5w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwM4svvZcnqOdkYRAUKlkuGXKSzYPnvxss7GjqgS2bHLTI6V96X
	cLnsM1yeijpAd7j5PFjGuDSySFtaKizKP/zqesRMNTawEfHM7T20dOBG/4JXvMHrWKRrETlRAmD
	0J0XSPOrWdeCmSJFOvAINf3w7pDxjNP90zkuVlZPsOv/jugapCzKY6bXOrTc=
X-Google-Smtp-Source: AGHT+IHqiMcWp7EqPrUBWuBLmjvttYI4FjxzoJg7ua+iAbHyuBvbfyJP0CEj9c2u6CJn7uZASV5/amkI/1bY3RWJbeK8Y2qM9vT3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:214a:b0:431:d726:9efd with SMTP id
 e9e14a558f8ab-4330d138fccmr27431235ab.12.1761868567707; Thu, 30 Oct 2025
 16:56:07 -0700 (PDT)
Date: Thu, 30 Oct 2025 16:56:07 -0700
In-Reply-To: <132ed630-d885-4fb7-9f85-0d8ce8f25fbb@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6903fb17.050a0220.32483.0231.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: global-out-of-bounds Read in io_uring_show_fdinfo
From: syzbot <syzbot+b883b008a0b1067d5833@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, kbusch@kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+b883b008a0b1067d5833@syzkaller.appspotmail.com
Tested-by: syzbot+b883b008a0b1067d5833@syzkaller.appspotmail.com

Tested on:

commit:         0b447e53 Merge branch 'for-6.19/io_uring' into for-next
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15d34e14580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7c3bc5e43bf487cd
dashboard link: https://syzkaller.appspot.com/bug?extid=b883b008a0b1067d5833
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

