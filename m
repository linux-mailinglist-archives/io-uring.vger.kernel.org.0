Return-Path: <io-uring+bounces-7193-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F218A6C8B4
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 10:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9D454608A4
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 09:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8471D88D0;
	Sat, 22 Mar 2025 09:28:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51642127E18
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 09:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742635684; cv=none; b=VixLcJRgWQHre6vwKa8kOm4LKtvtNHkT9DWjt/SNwwgIK/Oc5f3x7HZqEMU+xlB8nlWspG/1uzO3cdgKTQ6mX+BPd5f9lFYor2Pmpzo6HS0F5NLE8dB3M6lfjm59W1SW4a/VyeGv5HAGK9mB0VjfHqU5Ve97q9uPa23zC+xXRa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742635684; c=relaxed/simple;
	bh=YvP5plOupe1A1k9EZ7yU2X0y7ycDWIcFtZyz/cs0EWs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NDyY78wxfuMgWXAcq7DhHnRgCoqNXWViePVVT761k+JEUWbzUlKpJvGECg9RwzN317Mw6mOSZlWeLheTJO8wzx3jNOcxlUYO+Q/0E4kCMDQc3NQsUYwoJE/egdikG0p70Lr1WLEwPRjAIgdzUi8MWSxzpmWNNs4v6/f7IyhSP9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-85b3f480d86so223484739f.3
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 02:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742635682; x=1743240482;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T/1/8NSp23q/ACQLJxacEQ6xVJJpFBAovimyCbTcpNc=;
        b=YeQ//yFDVvNOhdMz3tyrkmlrEtI9elKd/TRAgQvcPFPHcNm95HgXL8/EBJ2t7jjUyT
         70Rh/K7OGQ+Url3w49RDsmR+pWh8PGEGS/cvjIS2RM2t/KjoARPyggdV9m2VfVbgC5fr
         sM9tESHpWH3rSV7gDa0p7Fk8CbtwONCeR/tGkHyT+Dl5q3b7LpHxwBFjWqrltcHdsCX9
         t8WKi+ipEH5bFoAPcIpjnAxj6BtyNsL9rR5K6uRFG4dHEC7PuAsJzzn8BiHt2Aq46qHv
         zFWAaH0BpyBkKlAG80Pl2qNKIFFCd/GEpkW6BsaMoU+C54GjQTqMrvmvaEvIfnCw4KgP
         JUNA==
X-Forwarded-Encrypted: i=1; AJvYcCWBoI4atJCpBuWIVGO+X/E3iCSFsKioyDypuhDtMrJ1wxYPxiLwfDB2QPgkC3AwUFLkCwAO1ZzqAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxGzsC5wmctyFnAD+RpbBuwclDlhnUmAQfIhRMcDEP5C+50LAc
	6PsbX/kzohMXbQxQQtjMJ07o6IjDedxxv0ppOnUHkFdha5yTtewsNqlsEh3YAjfe2oxgJy3uK/a
	knD7yBrbc28Hd113HJa1KhyEW5iOBUTy9cVBdO8Yhab3UO4/l4i5mVvQ=
X-Google-Smtp-Source: AGHT+IFsGhUOtcYYvOrW0tXzabFLcCZgbkG7y/DFv1qHp9uYbi8OSs02v+7vcOGJWwbwXCdClCGkWwkdlJZzy90RPDkfS+SkGEki
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:220f:b0:3d5:7f32:8d24 with SMTP id
 e9e14a558f8ab-3d59616b952mr65624375ab.15.1742635682477; Sat, 22 Mar 2025
 02:28:02 -0700 (PDT)
Date: Sat, 22 Mar 2025 02:28:02 -0700
In-Reply-To: <fde4a18e-0376-4c3f-9b27-b644c211618e@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67de82a2.050a0220.31a16b.002e.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING: refcount bug in io_send_zc_cleanup (2)
From: syzbot <syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com
Tested-by: syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com

Tested on:

commit:         e1306007 io_uring/net: fix sendzc double notif flush
git tree:       https://github.com/isilence/linux.git syz/sendzc-cleanup
console output: https://syzkaller.appspot.com/x/log.txt?x=15809c4c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6fa548b75e783182
dashboard link: https://syzkaller.appspot.com/bug?extid=cf285a028ffba71b2ef5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

