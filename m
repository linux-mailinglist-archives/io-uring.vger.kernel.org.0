Return-Path: <io-uring+bounces-11305-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A40DCDD642
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 08:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 752143019346
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 07:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59B2238C36;
	Thu, 25 Dec 2025 07:03:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7AB2727FC
	for <io-uring@vger.kernel.org>; Thu, 25 Dec 2025 07:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766646189; cv=none; b=OXQWBCXk2sL2wWlxqQ331/X8sLtlbADe5Y4Q/wimcjYWR5Hk7k/cKzDDz5K/rWZ72ZnjxyaHbSteF0dDqkCo45y8H0TKa+5stwHm0hL1mp3C56MVpHBduADj4k6c0xEwBpc6HFazv1ti8wW/5AUbgSzwy1+ZOAHL+1dYEtPsP0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766646189; c=relaxed/simple;
	bh=wn96RWDl5N1hOdjrqeg17LgWUNfNi+PhXsw6RX5sOZU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=n7775XPDLwirc26ovtzBtH+KTDR4LYebW9XxWv8O6V7mRkGmmoaBzxpb8LuxPFmNELkXpWdg+5dh2kBHRLO8TsU8Hp5WWH9OJU8fQyx/zPDzDnrtyeMd00gKkr+vdFk0y38as3lbR8MKyyPY/MqMjueTcynydXbQ5JLxbHQQ4g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-657486eb435so9507516eaf.1
        for <io-uring@vger.kernel.org>; Wed, 24 Dec 2025 23:03:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766646184; x=1767250984;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2KZIgj2KabdePGNXiH8PxxTMu0sC8Sc0rYJeYx3aeTA=;
        b=ASHcmqOJcQJU17YrU7LbYGrtdQso3G0Ytiobt1a1RnQdDoAItGFWYNg9ZcfgknjWVD
         nA1C3pWeq2kZpPcb7Plzcppuk+fkRAHohKLTHKWQgldl5/lyt09vZ+MejeWDdLxntMmO
         /tgnH6Lrpl61zl2iiHTxngS9ZgFgXsfnl2ssMnwN4GRSpdmZpH8S+SELJV4H8dNE+h2D
         3Mo0QjRrkr1i49szemSfnTcv3LRizSuP1A3tnMhlLTVOfGaDeAYSLt+k0BT0aaeuTFHp
         Jq+muTTrrgfmRcJ7J46XvOnMSEIyzy30NuuQiCaTRIEURAhW4SLIZ/u+bbqVxr7aQLLy
         U3Og==
X-Forwarded-Encrypted: i=1; AJvYcCW5t2l9R5IGzr3Qxinp4uk4fFzlV988Af35fTN8A08b3wGhPRNkC07tY/N72ERxVVnr5M5XdhRVDg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq6ll7msr2B+bd5dzAgEtxo6dp1wVR8k3PsU+fNsLi3W2cEIxw
	1OnmpgjBWkS6xHNnoOcrZO+uRdygnUZ6CRVkTFjqZ7v6UAPwFnyJtEADtp6mu7ekQMfmb24wl/h
	0hZ0Xc3nMb0SArM7etCWb+NPOoFMf+kTYAIT9MK4VzMkNr4ttn13Vugfn7iQ=
X-Google-Smtp-Source: AGHT+IHi94rnsICS/Ar5+vQ/0pN3IhewQdBMuKf5fC8S8WtfwHuHHXT+FBVN6Bpa1zZGiG33E+XO2qx6Yc7O5UmsyBDc9bR39Av9
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:dc4e:0:b0:659:9a49:8f33 with SMTP id
 006d021491bc7-65d0eae4877mr6631531eaf.68.1766646183915; Wed, 24 Dec 2025
 23:03:03 -0800 (PST)
Date: Wed, 24 Dec 2025 23:03:03 -0800
In-Reply-To: <20251225063402.19684-1-activprithvi@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694ce1a7.050a0220.35954c.0034.GAE@google.com>
Subject: Re: [syzbot] [fs?] memory leak in getname_flags
From: syzbot <syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com>
To: activprithvi@gmail.com, axboe@kernel.dk, brauner@kernel.org, 
	io-uring@vger.kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
Tested-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com

Tested on:

commit:         b9275466 Merge tag 'dma-mapping-6.19-2025-12-22' of gi..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=17332bb4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d60836e327fd6756
dashboard link: https://syzkaller.appspot.com/bug?extid=00e61c43eb5e4740438f
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1640c8fc580000

Note: testing is done by a robot and is best-effort only.

