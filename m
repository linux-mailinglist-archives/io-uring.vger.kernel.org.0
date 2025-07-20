Return-Path: <io-uring+bounces-8748-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ADD9B0B7E9
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 21:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7227E3A82E9
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 19:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 157891D5154;
	Sun, 20 Jul 2025 19:19:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF231191F89
	for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 19:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753039146; cv=none; b=VOArzJ88SUCd9CofS0NZhwmZRWYgsbBUT941oCLi9PcneOXHhxaYGR6zY2m/TXZqUVvugpaKjy1n6c+wKf4/VAf8ociJt3tH1Yud5WbU39Ljf3V3lLfI5teUWBpOnIsCn7ASp7hk/n7pyl/++MN6FflGMQgNRxPcjO0XzTobHa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753039146; c=relaxed/simple;
	bh=VtKbQ9+qN6GIwu4xdclsdbcCWXd5POtHOdGN/lRTarY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=HL/3u8yJKjZJ+5JRmDDNtGczgCMcEV1fOahpY2M8cZBPJVhicT3NEPE1UzTkRqzk5Orh4PjbdvvpEWKHu6QMSru6Kng4j1/bZBIEpTBIA5iX8KoxJcLkEne/kjnHr8NxghuSuQFuYm6S/KErlf887lpCe8P3JRLUGbwDvLY9MsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ddbfe1fc8fso84399995ab.2
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 12:19:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753039143; x=1753643943;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m8SLuQddmzuP2cZ8NG8v4gcEdsMfVVRurSpgt90oFhs=;
        b=rl+5ifYScRz6qWy/FRYR9fIEHGkQF9/vVa/tAYALy9+Ng4ZK/ZM13I3UbPsT7lzdJV
         g76GUZ6FGciAUv1wkB7mgEYrmN8c5iC+YSh59gQxFHdeFPskzgDiwjYkkOZzE/bZ/DIh
         aDmclfDn3ZKW11DeKx0AsMzpC6rwOfTZXI7HeXZtgAnJRpoAN9xViL8Y+yW0qT55fzy3
         EWklDn67zHUgwmjga8aV35nbENWx46zTwuUcYGmoBpABycBEQo4pklmp1ttlellcOudT
         frcz37qP6yw1KL/togcH/+MOut1LlJkM0UO7kBP9YuzNi7Cz/WkIgA4nmzQaOslkqXq+
         ordw==
X-Forwarded-Encrypted: i=1; AJvYcCWs7vv1TovSHqeoj61DHrKfUKwIHlks8KFdi9e5Er2/pCrLpzC2frhUeSjvtnljenvmBUoH/Gxulw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYX5L4ndHJZZTD/eB1Ts6VVaB/JGOtQP8e39/FbutVGaj4kB/s
	NL9pb6av8YmikU/RJRM5mLLxNW1kgbEZJSrtVr7xNaexCz+jeqJaElCAhtiuUsqnRYOy5HEmkIA
	nFKgK2FfFwPjvSGF54zFkTIx77nLRcHgbbJVTGfXjsKlGN9sBhUtCEp/uDuc=
X-Google-Smtp-Source: AGHT+IHUEHGbb1K9tPl/x0VXd051QPTbaul9g8Q9CEbZnpqU49syP8s07upj66fYqx72+o1caTSr8ZqheeYbvUoDj1cHpAnDxFwq
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cb:b0:3dd:be49:9278 with SMTP id
 e9e14a558f8ab-3e2821ddae3mr182023245ab.0.1753039143001; Sun, 20 Jul 2025
 12:19:03 -0700 (PDT)
Date: Sun, 20 Jul 2025 12:19:02 -0700
In-Reply-To: <d407c9f1-e625-4153-930f-6e44d82b32b5@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687d4126.a70a0220.693ce.00d4.GAE@google.com>
Subject: Re: [syzbot] [kernel] KASAN: slab-use-after-free Read in io_poll_remove_entries
From: syzbot <syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com>
To: abbotti@mev.co.uk, axboe@kernel.dk, gregkh@linuxfoundation.org, 
	hsweeten@visionengravers.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com
Tested-by: syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com

Tested on:

commit:         07fa9cad Merge tag 'x86-urgent-2025-07-20' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1086638c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa738a4418f051ee
dashboard link: https://syzkaller.appspot.com/bug?extid=01523a0ae5600aef5895
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16a8cb82580000

Note: testing is done by a robot and is best-effort only.

