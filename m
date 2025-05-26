Return-Path: <io-uring+bounces-8113-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B73EEAC3BFA
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 10:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 710A33ACA78
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 08:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF6271E5B95;
	Mon, 26 May 2025 08:50:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240B91E47A8
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 08:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748249417; cv=none; b=SLYD0R9oF1wDvwlM3LxiP+2yB9lZx7M+RD1Z+LBcRpUMYaC73Qt6GSbaKq1GsbmESuWERWsVwNM6gfi2mIh5vlNC8CKBhrGa18ChzfUcPzH95efhrgOVFqnCMbLirziqi29wgbLEwsVDHoiXmwXo8+ejcywk6QB3QWRsUK7TcrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748249417; c=relaxed/simple;
	bh=7r8aRdMgPggrmvpJvLCdX0/pBmsKKNimBRQjqP19w0Y=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=SSTrdx6yvuUohrpZsImMvSp/RKLmuua6HGhWLKuPQVwGy9/bVVKIzF1jAj5x8Rz9ZbjetBxmoEc3lIDKOVVpn7GR0BRX5NlcVj/OFrPYCZmCQfFZcSwWFjPN3TfbWwCAMpBCXCm+CE0jOWwAXc0bIEKzJL+CdxWMvz03JlxeACM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-85ed07f832dso164756839f.2
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 01:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748249415; x=1748854215;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7r8aRdMgPggrmvpJvLCdX0/pBmsKKNimBRQjqP19w0Y=;
        b=CXXykvopnV78rfxVAs33Vzx2ozFnnqOhwpIEvOPeXRKqu5ynLtucJLcBxppdGf/3zZ
         wWPyQmz7TFPsn+iyoLnUgzvcS82xqdN0Zk6LOD4I+AoLEBcSTuSuUnjgsWbocLuHpEoX
         7bC6hnsECkqcUXSB8gHa0RxQXApMOC5f9cVl7zCXcoMs6pGn7A2g0MBnhOdb/eFBY92+
         bL+PrPuKh8tPWxOW3fq+FbbkWgpvZi4tXGCbl+HXMszQFTq55l7Anpumwm23bn6g1EIM
         jtdVaDWK9caBv5LLdH7LYdTcVa0bWfl1Ii3W9vY8FLWrNpiAsTi1YPkMZNk8cukXGpMW
         TGjw==
X-Forwarded-Encrypted: i=1; AJvYcCUVMa4eZDZODcnRZfiNQNznd8BrfeiSMEwK6sDjssGNVnIW9whp3qjLodTYcazQs+OfaC6cYoLaVA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPYEut9vyuvJ3wUZMBcDUgl1DKPDvfFpVs0zJNHMZACpzujJ35
	N4YHK7InUqQJupw8A0N5Nm7JqFQmlLgSh4rahGx77eB7JKIb4BJEqwJLB9Ib8b5Rsg/ND8Bhg4n
	eWOjb5QRoKoNCrvwktYj2+0twXEdRJyN2PpIZ2FeCavoSY75+RPDusHzy6Tg=
X-Google-Smtp-Source: AGHT+IGOo2lmULrjR/iwGplRL30bkcEhPuZyxc72lp41LzzTtXiefpjNjJTk+foGvQNbtScr17PtZxNvTpCgIG9KaABh//fr/chr
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3e98:b0:86a:24a7:cecb with SMTP id
 ca18e2360f4ac-86cbb7da7c2mr1179440439f.4.1748249415172; Mon, 26 May 2025
 01:50:15 -0700 (PDT)
Date: Mon, 26 May 2025 01:50:15 -0700
In-Reply-To: <67bd7af0.050a0220.bbfd1.009e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68342b47.a70a0220.253bc2.0090.GAE@google.com>
Subject: Re: [syzbot] general protection fault in lock_vma_under_rcu
From: syzbot <syzbot+556fda2d78f9b0daa141@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, asml.silence@gmail.com, axboe@kernel.dk, 
	eadavis@qq.com, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, shivankg@amd.com, surenb@google.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

This bug is marked as fixed by commit:
mm: fix a crash due to vma_end_read() that should have been removed

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Linux
Dashboard link: https://syzkaller.appspot.com/bug?extid=556fda2d78f9b0daa141

---
[1] I expect the commit to be present in:

1. for-kernelci branch of
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git

2. master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

3. master branch of
git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

4. main branch of
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git

The full list of 10 trees can be found at
https://syzkaller.appspot.com/upstream/repos

