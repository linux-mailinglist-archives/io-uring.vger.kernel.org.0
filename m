Return-Path: <io-uring+bounces-2775-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 918119537F3
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 18:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E6FCB24F29
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 16:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79BA91B1514;
	Thu, 15 Aug 2024 16:10:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1161A76B2
	for <io-uring@vger.kernel.org>; Thu, 15 Aug 2024 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723738205; cv=none; b=bWga7hb4krnzozPTbiUDE+ogH2nFC+KaaE25CVwnAiMnzfaxNpvL21tOo4cR2WiyrmzwkqHTOQDONcidDhmmtbcjkmMUJLXW4QLV4BIBoRxv+AgEYqP6VVHe+zr/K/kpYKJeX60xf/wxYkBbM3RpP64nZQpE2JvQomqi8UpctzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723738205; c=relaxed/simple;
	bh=j2uYupfeKSgh0DfZRYYlMyC99HExdau3jIZqN4BrbAk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=A1xM8khtX3sP3kwwlB32iDOVZrGMwAaZc96q8Mhl8cDATmc20fArKQKW2ZcNz7rxXs14ja5coams8Q6bJvx5cqZWVWzOldKlq+uGLlO6dYWxRXr4LHtDNIpxewOPo8eMVyuRXVL4QAGg06blBKztJoLOpAO84jXiw2y3zB6NLnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3962d4671c7so12775455ab.2
        for <io-uring@vger.kernel.org>; Thu, 15 Aug 2024 09:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723738203; x=1724343003;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+48SOAuLFWa3vOYJchc0yB8E8pO6GvAZqc/FFORHhSw=;
        b=Qe5nvqs0uKX6450w3af/8YWXEoxlRvfUTeNO/9KlDNIsL7rqPv04uDNISVy06r/2cs
         cWjU7rZpomkaKccDmr0I8ODpzMclSU/gwcwr0SMFHz/sKpY2l0ddve/oJis2WLtjJv+a
         Y4H21UWwkojrp6lDbOB/uyBwtaxAojOmGSTE50Lkd9tNj00MotyqeiXIvZQhiGzaGgti
         YYeOcHDs7U4/cZ9nAL1jNXyT8Wgq3Ih33XQKXAyW+TT52KfGfzJ4UsdW3d1F7lvFo5YK
         QD3zHtpOeNnTVX78HKyM87wIab/1mGmi3ieWMs8I0u27JIleJX9A5/UdiZa2KgzcL/Ps
         Xe+w==
X-Forwarded-Encrypted: i=1; AJvYcCW7dN93TKQmVPcimSTvE0GLjf4vIlCiEb3QWgmeXQWsiRfBE15FSB+gd0NjGa9vsov8cAhHswlFS47Zt2DRkYo7uwkJtmyl2JA=
X-Gm-Message-State: AOJu0YySa81odthzT53X6S5rTje5wn+kfpLjuWQS7LK1+gYgiDIU6Et6
	i9WdRK781yStWh0rEhfAGtY1WSvLpfuKPgnp5wdZfJhJNX+B35SWo4wOS64QVbEiji16p9goQAL
	nEaqiJVxv02IxDNQYJejBB8tUAJaBH7/fLBcAPgLec3kf/3rN2/A47d8=
X-Google-Smtp-Source: AGHT+IFhijMKxOHvEmejfGCrN0UCTcPcB8Qp17m0Xsh3eQixZLpUkNfc3bISLAfaoqkI5L5Rer4110AXeccsAco0NPqCdduTR/JH
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:164c:b0:397:95c7:6f72 with SMTP id
 e9e14a558f8ab-39d26d95de3mr190845ab.6.1723738203044; Thu, 15 Aug 2024
 09:10:03 -0700 (PDT)
Date: Thu, 15 Aug 2024 09:10:03 -0700
In-Reply-To: <0000000000006923bb06178ce04a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004754de061fbb1356@google.com>
Subject: Re: [syzbot] [mm?] WARNING in hpage_collapse_scan_pmd (2)
From: syzbot <syzbot+5ea2845f44caa77f5543@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, borntraeger@linux.ibm.com, 
	david@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	io-uring@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	peterx@redhat.com, shuah@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit c88033efe9a391e72ba6b5df4b01d6e628f4e734
Author: Peter Xu <peterx@redhat.com>
Date:   Mon Apr 22 13:33:11 2024 +0000

    mm/userfaultfd: reset ptes when close() for wr-protected ones

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12f2396b980000
start commit:   e67572cd2204 Linux 6.9-rc6
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=3310e643b6ef5d69
dashboard link: https://syzkaller.appspot.com/bug?extid=5ea2845f44caa77f5543
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10874a40980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: mm/userfaultfd: reset ptes when close() for wr-protected ones

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

