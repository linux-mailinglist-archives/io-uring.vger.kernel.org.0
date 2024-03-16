Return-Path: <io-uring+bounces-1021-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB91387DA8E
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 16:20:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 670131C209D5
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 15:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E37199B4;
	Sat, 16 Mar 2024 15:20:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB0A18EA1
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 15:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710602405; cv=none; b=pz0t/SWlzIOpYB5N1MYw9Vh5O7MHtONrdc76zMva9WqWnpkXv0/0CAtbtSCitMwMElZs2CR1GEvyOBWuq5uN/au9pcYfjXHK5lZIvlvJV6zNbKH6e8NGF5taftCkSxjVitgGie3S0J+qMC+GNp33PzpHM/7JgQy6pnpt1ls410Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710602405; c=relaxed/simple;
	bh=po6C+6UERN35FXCr59wZF6It8p90ooJtSle5rHvyZsI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=M2Cqw5luaUY355v061bKb5KSs5rEyMGNrGZ+1MvPVTkyw2pbuJrke7ecD+tmDlm5MQf4pUDc92fhKcfFXZW5FLGhO+D442YRO0hEPIKtOEjwIN1sGFRa7T5qKocVn9TFdEeJOs+gfr8/1OfW3sjXxDNV+Fg2vNkwYV//hTAN02Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7c49c867608so272668239f.3
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 08:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710602403; x=1711207203;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/sqHBBaMOeAnurYIhwPVCqQ5vnkrKRfkMuwUxyQYMH0=;
        b=au6yPeGuo5TCXHt7S7cRTwEikGHTTSarLCEo7eFNkOYlDMhpdhl5XEH/HS9suqkEEb
         YBVflM7A0SGI9+AmI8ktwVJ+g5RIRAfz9th3HRx03NnlT1LrBR/tjR0pK5R1aVen6nwa
         Rq8zZfI76yZooV7Mkjj64QtUBhney6b6V5R3njNUX0DUn0lJNJZaT0Xk+Xcyr2JLq2oq
         F3NoeA8sziFs02IM8Q93aEOgvlArpp//bCcOKGuQyOKOgrkjtLZMUgmj5FKnZXdC8EQW
         de26/tEY7yOSpyJCdOivdiciMLBUnbkV2NsJOIEQJ61InGW/b1u/O3rb0TcoZYztKrGc
         S3HQ==
X-Forwarded-Encrypted: i=1; AJvYcCUviFtdUBTmtw9qaLNdLnMoDxbYj069/V0FDIXpDfYJ35lO+rjgexp2Xd/I+t+5VfXzJoNcrLbSDD6XKDkS1Zaf9j85dTNmU8c=
X-Gm-Message-State: AOJu0YynfcsfamUQd/nIiwc+bdmR1/Y6Cge0E9iEbJ1XF2Kqusj5ag0N
	rUHJpJzfOLZneB1p973anqy+E47x99LNsANoFNRb928j1CxN5vsCTOs9+flBRoPNwCDiVQdc0uQ
	jpxFRA34VY3npkBoLO5+cGkatcOCyqQ5Np1U901HhQuscjM3HunMp2hc=
X-Google-Smtp-Source: AGHT+IG/nqTTOwQfXe2tKerJxpBXR+GKZ4ab+GuQzTv0EBBAIn/L0gzKbUC3pLyBBeAw374/WnlvnAcl3JF9YpuJT74s/yM6a3Ik
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2b21:b0:477:3040:5856 with SMTP id
 fm33-20020a0566382b2100b0047730405856mr311449jab.0.1710602403066; Sat, 16 Mar
 2024 08:20:03 -0700 (PDT)
Date: Sat, 16 Mar 2024 08:20:03 -0700
In-Reply-To: <8e639192-cb6b-40c3-9892-db0ac0cbae52@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000964cf40613c8a85f@google.com>
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_sendrecv_fail
From: syzbot <syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com

Tested on:

commit:         c9285260 io_uring/net: ensure async prep handlers alwa..
git tree:       git://git.kernel.dk/linux.git io_uring-6.9
console output: https://syzkaller.appspot.com/x/log.txt?x=162a6711180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a271c5dca0ff14df
dashboard link: https://syzkaller.appspot.com/bug?extid=f8e9a371388aa62ecab4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

