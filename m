Return-Path: <io-uring+bounces-7425-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D74FA7E219
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 16:39:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8F463AB216
	for <lists+io-uring@lfdr.de>; Mon,  7 Apr 2025 14:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 014D31FE479;
	Mon,  7 Apr 2025 14:25:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D711FDA9E
	for <io-uring@vger.kernel.org>; Mon,  7 Apr 2025 14:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744035905; cv=none; b=OPGkUKcoi//3lLIATJums2uLeX+SqiyW4m7ieSmcrKpoiOt7vwnoiyLsencgR0ChteTvVdoFimdlTh+yPK79TszY3FCrObiEYC9m0G4p+5Q8jzFvVllysFn92jjGfpIns2dyYUXKF+BqyZfPJJbtU05nf/7x1XB1ihEHI1UTC2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744035905; c=relaxed/simple;
	bh=Bzr+yAT5FWXC67pNcy4DdnOEcNRHfP3unZIeNg0Lls8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=UeeVXzwWfQI8H+OEwtDPfDHMrqKYX905w8htwFvVuU6nLWMDo4ZTXGxTAwNhD1+OF04BXqGVqTIWLuNUDfJ4uReQVQIYRTHf4dLwmI0ApnCfK6tCwjpoVqNJvylACRi19w9TDcax1PbfzaPsauZUn9iyw4fyoc4E/wLAq8O+K1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d43b460970so95173935ab.2
        for <io-uring@vger.kernel.org>; Mon, 07 Apr 2025 07:25:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744035902; x=1744640702;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XqylPtsJUGhPnDo877vCDGCeTK9eTWpi2VA5wUt1hxk=;
        b=Zl6q576d4ch7Wo5QLeduaKEgv50rKsqmWufLMIsaowSRMtZjSnSJcRbxVcfD1Ywl1Z
         kUyllzFs2VQ4UDknkFiVKFCEvlhWHDugw9IMZ9ioaC1N4ZOP0jU1Gn8Xn249TUhvYCY8
         36/XXpvyCoqL8UZIvmS3D24xg6WQMq2Dc+JesUjph2DHWZsoHJhlgBFcdtAGdRZtdO5l
         H5X4rk3AtVibkr/iNgTC+P8Y7SZVk6ufbnh7b8Ejrjv2/1QZmCVfIREy39wO0lpRZDvC
         lIYiCU7BcJWZfZ1KLngsqHnScvh+JIKeHyx79fmrvfl6oziDfSMdbx9b05vKfJ0zh32V
         P0/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWd0BCtOY1X1BvSPiz9wZWUYV9nMIJ5BqZALYeUq1OxAr8EWWl3bQ6nyhw2hH9bVAZaOfcLUlppSg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzepMRg2tbBf+/CN4vANStvE7MK3ZeYkscnvIZKYHugha+8EnB6
	B7jZjZ7QYeC4ml/hdssT9CyCNr5587itCDFf+iEPaKL9dKT3cgZsvhQIAjKaRsDqh0G1clxArWi
	vVxEFI+DEtsyzyUJBQR7bWyrDC5CbkrWCJiGqS4Cyte84JXrYPgB8zJg=
X-Google-Smtp-Source: AGHT+IE+CDycwgO/6G3EPIE0hT1ZFJznfTWuSqkY0aiAwqTMSDuWhisnHSKLp+mYWuCkfjfMTgBml3N7diPwWBcZZhI+/n83hKbl
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cd87:0:b0:3d3:d07d:20a3 with SMTP id
 e9e14a558f8ab-3d6e533d0aemr118537635ab.10.1744035902466; Mon, 07 Apr 2025
 07:25:02 -0700 (PDT)
Date: Mon, 07 Apr 2025 07:25:02 -0700
In-Reply-To: <7bcb21c4-4ce1-43fd-8adc-c22684cbf0e7@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f3e03e.050a0220.107db6.059e.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (4)
From: syzbot <syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com
Tested-by: syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com

Tested on:

commit:         881bc75c io_uring/kbuf: reject zero sized provided buf..
git tree:       git://git.kernel.dk/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=17420070580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a3f7ddbc4e0c74f1
dashboard link: https://syzkaller.appspot.com/bug?extid=58928048fd1416f1457c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

