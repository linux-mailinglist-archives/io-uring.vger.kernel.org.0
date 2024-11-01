Return-Path: <io-uring+bounces-4327-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C1D9B9808
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 20:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E972BB2113A
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 19:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC124145324;
	Fri,  1 Nov 2024 19:02:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A16314B955
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 19:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730487725; cv=none; b=G4PFpeFNs5IPqO58gj2JT0gINBfUQmEVnTfL73imtg+2NY2UdA3GYK7Iab2ej6an//njsxEmCoWovUtoXeCS34pRmUYmW+ns1s/j6MoCtaPj5ahBjC3vmXaNjVsN6w3vS9J4H8E9kq5czEJKAH3QrbRx4UWxPYE6IK0Kt4iucHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730487725; c=relaxed/simple;
	bh=elZ2Y4xb+q6SBvsUbOv7WkDEkhV95Z7ralXEdDeVpjY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=k3GTAxYHsUgGAC1ld425Xl/jtw6E1bqghHjfX5GC8pDAAXu1tC5OLYffx7bGKTZnGqP5Bg5wiZPShz1f4SahPUnc/QAzGCLVvpoB8N/TIAfCYf0BQZEfHxy78eJsy6sRjnJBGQFV6H1wCXWQJbZVjmLXCw9HrTAIUPy1bMlfmgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83abef51173so254073239f.1
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 12:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730487723; x=1731092523;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zkQyL8Z38BSSMQu6LynWJn3lSRtW0cs0L7VxR/etyvA=;
        b=jDpJt3E23nhnCVxruCKLO7R8ctbooX82LpywgIptrDV8bQgxFZ2yit8uQONTuZOU+U
         mVsbG5xk2sVDWty+PxVAlm3+VXohi0A9QxEVZ4RqFBgJYC53kgzLdC1X9pkmD8wva6nO
         PdwJObLnELrRqPWwjt+keZ6MpdOZoJ0dpblVLxuZKKhvszZ6OybSpHKKDbARB36F7eoh
         8OVhL9Mbe7/+QXoMTy6uVgE04tYoMP9yXHY9DWCCclZVXYzPeCFT74GL8trf4bweu2AH
         zxPIOA0lsaAYnhsPa8HnhK+YyJ8AYKuRkBFqfovhHqwa8QHMoh2Nhq2ZtlandN8UWbPS
         dggQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqdrW37gNZH99vkfL8f8svcGaG9/QSDxWLQlnO24lq0D8hKCyocuWQb9NVVmrh5+Bd3guWSoq8hQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLPqp9owejei8M43IB+EglgniSpgzInMAsfc5KFilixlS6mSjG
	JeUm6OU+2M26MPeKclfBAwW0SWtoOhqNIDJjaaE9ozEzk4nN7MBGJ+yakorVu/CmIkcFNNCDb/1
	w2DWWbYmNXcX5ThKNEIAIBkAMRT49fTKKBwuPM/p8Xm/97X08wtaTVJM=
X-Google-Smtp-Source: AGHT+IGAv2HhohkX0XrPNPJ+o2V8MHjOmP7uaOrOTVGzBzWKsdOt4Xv7NrshNE9SbnJ3vohnl47a8/E4SzYiJhccPpqHWMjiQoYz
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cd88:0:b0:3a1:a619:203c with SMTP id
 e9e14a558f8ab-3a5e262e89cmr135256465ab.23.1730487723382; Fri, 01 Nov 2024
 12:02:03 -0700 (PDT)
Date: Fri, 01 Nov 2024 12:02:03 -0700
In-Reply-To: <4a7fe7a1-02d9-4488-8aef-b4c3851224ed@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672525ab.050a0220.529b6.0169.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_uring_show_fdinfo (2)
From: syzbot <syzbot+6cb1e1ecb22a749ef8e8@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+6cb1e1ecb22a749ef8e8@syzkaller.appspotmail.com
Tested-by: syzbot+6cb1e1ecb22a749ef8e8@syzkaller.appspotmail.com

Tested on:

commit:         4a8b9560 io_uring/fdinfo: fix sparse registered buffer..
git tree:       git://git.kernel.dk/linux for-6.13/io_uring
console output: https://syzkaller.appspot.com/x/log.txt?x=14016187980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=37061a3807403bdc
dashboard link: https://syzkaller.appspot.com/bug?extid=6cb1e1ecb22a749ef8e8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

