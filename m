Return-Path: <io-uring+bounces-9590-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1709DB4554E
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 12:49:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEF99A6564A
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 10:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBB630C638;
	Fri,  5 Sep 2025 10:48:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7885C30CDAA
	for <io-uring@vger.kernel.org>; Fri,  5 Sep 2025 10:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757069288; cv=none; b=DcDspIS2QoQmslgBpdjJuBKRfNWHsvn3NO8NOWS0jBW3Gku8+4eqVTb8A/ChMRPX4Yv5VHQCKEbeObD08j2bAOhi4zzM/qynX5mgqMEeEexSdeD2J3qKE+5MjlNI1u4u4N0JnTtNRTKnogWxWQYCUtg7t6aHBHF+hlzH7r925kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757069288; c=relaxed/simple;
	bh=NmYKRAAmq6S9/OlEpo6/iUNc8QiidY1CJ9QsoS/Qjik=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bBNZEwx/yqjQYeZMAmpVHWBrCFnz7ndIB+1q8gEJ3eMdmcSCPNVUpF5lxCj82kJ+LhqxVsJvc72PS7whRg4MviqwnONqIan+WSihW5GwnY7UCAxuWRl9vH0ZAINyOhL7R9rUmliuXVH47h151EYYgBVXjf3usA27LM9XAwe0LT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8871700ab43so251815739f.1
        for <io-uring@vger.kernel.org>; Fri, 05 Sep 2025 03:48:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757069285; x=1757674085;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8rYsdGmrF6iYwCUNd1971cTTtCRjr0XxFrK/sEXkTUg=;
        b=hqO+ryZPAIdOAt+tdwv2aHnDbVZSlo0lTb/gHeTCN9/Iv+shymsii+QFqHHXr0UYbp
         5I+T7saONsd9HYbvc2A9EghQj9brSMUPgwEQaP9XKf/BjxHKDuHriT/CKVc6Hp0Npf//
         6DuGKvhlb9gb0ws5qqQoQkR4G7nAqgRE1b0e1RMruwU+1p0NEMGwXfGF7vMHv9+ibbbU
         +Bewa5LoFG6N1kGrqApRY4YCI1w20Y+thOGpbnyAdCZwUyZv8Tf654E6H6KvtRYn7RV+
         Y+h+WNn6fsSw2pwGc7W7umVE3YKhG3GpKfhvEPThEm20wqQA7YS8pwfvR8gxI6yq6hMa
         lVUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJkHBKkL7ldj3tCkDYtRf0kJECD+tTH6/y+YZZVXluo45wSXU8sgIDwrX6fmG8N5llp7u2A2e32w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3Wy5EQZJwYWjTpYJ9XSVQPlFGhOVnBDB1OprWIlbS9oYeMda6
	Me0ssnvRZskn4AY2I3dRY06bP1Fw+DDf+8QjcZd2+A4sO54mAkXpw+W0M/n/cPqCLJ5gLiEDh6Y
	3hf2lK30aXv1aLOj9bzD+iKTO2+loYSDEgDKEPnhwuzOl/djyl6nRF2LQY4A=
X-Google-Smtp-Source: AGHT+IEEVqzPOhxCpPpHKlGrgT5f2MUOn4yyJ6sp4ZmwI2NMNbAtYmdpd/SxIRa4CgBpUT8AHoH6G+6763nAOE2lWUYDoaq6eth8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:486:b0:883:fc4a:ea55 with SMTP id
 ca18e2360f4ac-88767e26eb8mr470147239f.3.1757069285644; Fri, 05 Sep 2025
 03:48:05 -0700 (PDT)
Date: Fri, 05 Sep 2025 03:48:05 -0700
In-Reply-To: <6177c4fd-227a-4dc1-89cc-eec44300f6fa@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68babfe5.a00a0220.eb3d.0011.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Read in io_sqe_buffer_register
From: syzbot <syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk, david@redhat.com, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com
Tested-by: syzbot+1ab243d3eebb2aabf4a4@syzkaller.appspotmail.com

Tested on:

commit:         bfd07c99 fixup: mm/gup: remove record_subpages()
git tree:       https://github.com/davidhildenbrand/linux.git nth_page
console output: https://syzkaller.appspot.com/x/log.txt?x=15a5a134580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=366a4ffc91f4ab4
dashboard link: https://syzkaller.appspot.com/bug?extid=1ab243d3eebb2aabf4a4
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

