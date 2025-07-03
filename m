Return-Path: <io-uring+bounces-8603-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D60EEAF81D9
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 22:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB3AF1BC7D4C
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 20:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 935A02BE62C;
	Thu,  3 Jul 2025 20:20:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFC42BD5AB
	for <io-uring@vger.kernel.org>; Thu,  3 Jul 2025 20:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751574005; cv=none; b=SA0958DCT1x1yNfLDxdFOhggVMWK97OMUyq5OfpGqWzU5qa/k85KC2WPwUUFTCW8qK6XCaqilhjBogQC+KqfRs7rikfrlkwMk5Rx5bG8BZwLK9wnYPG2u4IxdgZVjtCV4tf1yX/oxc7QtEg/2psE5HMghArGA1GxjOm+/BTSmfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751574005; c=relaxed/simple;
	bh=ktUtWHn6ctGIrk0DA195Z10iPpgYiR4PsnMaxDvortA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=RSQ1//sPJ5cauM9dEYvd6NtAplVA4hNrGZ7Xu/l6ca/Y7C+nqQlvdJsGwbIaxF1/nkTVrWK8nLlvUaqnVQ2WFw1BwQYnEQP1lTkiyQiLau1DXDBpbuHEO0MHNRigwpNxOh3F6j0jiGj8iDc8DoNDCWxmRdALUGgEdJQccIE8MOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-86cf89ff625so25330439f.0
        for <io-uring@vger.kernel.org>; Thu, 03 Jul 2025 13:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751574003; x=1752178803;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMerz2n+tFN8TsF5zv7+dKlx5F1JGkpVWG+36MCX5+8=;
        b=u3rm4DyxABg9fgvdqznQIsj+QV+mxFuO81+tsUnqT3Y28t2cO24/aRB4cpv8ku4q8q
         5g9KgplIbbrcfJQy5Gj6QGBKLfNXIhRirisx6Tb2S4mPL8s1ySI7WDM1t1s889d4wY49
         QHNKlzK2j+bsOBi8Nd3PQ79OA00OmVwqwZfoElosrYRbslOnGj/ONWoT5VFYJsGriJOz
         mT7L+xXtBZSpm2tCvyNpqmR553vLgUN+xmASyx8zS+n/t8DEvkNnPlSVaIKlZRj9+l77
         Fe83J93VKQBdcnYXgWLUljDGKh7FfH5UmqkYo1Zt0PZoeMlibsVILdsT3ZYaqZ5CBfOM
         ldRA==
X-Forwarded-Encrypted: i=1; AJvYcCXFn6SipKRtN5/OHpSfRK8gzw+77qTP4xhq3sGOFP2Rx3OVkSxEJCVOaxCZqSYqZvC2dV2IcOv2+A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxoV183yxDfh3bRCOhcbxS4C7Yo+Ol2WIsJygNv2uUioZmTlRdU
	n4gcfq5766h0ByVRCSskQAhw8wJqzA16T+Wigj7N57F33cmnQG02e8nksmjLFoqWTBxLNoLVEcm
	uJKNhRANvzc0pToRWMK9pgQkKH3NP90J8TwVknoD+p/I1wJqiCDe7tcUQuhE=
X-Google-Smtp-Source: AGHT+IHSYeMvwEbudyKZxAAc16iQbkAMBdLxZVFQBfHXNJuS6bF4GAOQva2GfzxgT2xZB1qthR7gV5Llchlthg6MYhNLNnCBGksU
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3008:b0:3df:4ad5:3a71 with SMTP id
 e9e14a558f8ab-3e0549c5d57mr92223615ab.11.1751574003214; Thu, 03 Jul 2025
 13:20:03 -0700 (PDT)
Date: Thu, 03 Jul 2025 13:20:03 -0700
In-Reply-To: <f368bd06-73b4-47bb-acf1-b8eba2cfe669@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6866e5f3.050a0220.37fcff.0006.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in vfs_coredump
From: syzbot <syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, axboe@kernel.dk, frederic@kernel.org, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com
Tested-by: syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com

Tested on:

commit:         8d6c5833 Add linux-next specific files for 20250703
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11670582580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d7dc16394230c170
dashboard link: https://syzkaller.appspot.com/bug?extid=c29db0c6705a06cb65f2
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16837770580000

Note: testing is done by a robot and is best-effort only.

