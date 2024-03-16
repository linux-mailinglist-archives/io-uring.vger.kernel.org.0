Return-Path: <io-uring+bounces-1042-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E24A87DB01
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 18:18:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D71E7281442
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD87F1BDDF;
	Sat, 16 Mar 2024 17:18:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C2F1BDD0
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 17:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710609483; cv=none; b=GxJSujT/QF65yAlPGuEgS4TNpG+I6J9vs9yjLD34P2SuAg87fhP8Y8UBusVewMgamNvxPXbDRK5Z+rCCiCWtZt0GG51j0xRkSlOFm9v04zLSx7bsZfgh5ucGpaeZrQrQtIG1IFev7nLfWszZTBv5MyKeRMaoFrDF9gmHqcQ+4kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710609483; c=relaxed/simple;
	bh=rdXGU4H11/Rq5F0nYUcD2gQwSnehnBMG7uxvjVyx7Mw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=UZD7vjwmGp3A0Nz3UoIUzAFhPRB6v0samTSTxwyeOId6vfU+CDaQHc46nq57aMFmyKyOhL67HzH5P5IrAFj4YkR8f0YM4LM9EWOa/2CCTpgmQfikasc7nAAVfxYqav1wVxAlmp+bsjSiTiPPekJcdisuCm1GXCioapGiqBOOt3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3657cf730a0so34628925ab.2
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 10:18:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710609481; x=1711214281;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xhM0gim6EF1YfH3MdtafDzmojNURjVNL+R2IpqotLCI=;
        b=MFpmXNPE/20/iFRRn09XlY16QnccnKKOUTn8LSVvinJfc9f5W3LqTmEAw0QA3Ib7mC
         gmL6aDj1yEg5C+Vwr9tw1BByslhfZXIZlj5UbUtU03qUSptcj4nEizmLpc6QT4+MTpF8
         fonjtgnFwXFZcXq2rLODLS18lUsXeJaK2iIdbqeUqautpeI4tb/KYPSK/+dMwGz9u1fg
         DeVRJnXCgwSegHhHOACs6W+3RxOUJ0gBHVDngYbrE4OrwDc7bNQvm2B5PUu668yYKyhx
         h+XcWl4Z2s87NO6RMjo27gVcgi1jpUByxE9vjCRi/IXNB0hBzZ//JUwuwNCLnS47x8pp
         obOg==
X-Forwarded-Encrypted: i=1; AJvYcCU1dbOOYoF6FVXtEBdP9G8zt7LyfDcL3njg6oiL0dI2yWcFczE19Be+kCgD1vVVC7VwHwvCFnR0j0tIoWCXeDNRo+rUM0MONQc=
X-Gm-Message-State: AOJu0Yyq5KguiiF3KR3VDfkBOy5s1DDibCjRntGzEZBCjBD+fw2T2u9c
	TmdLD8gOXeh1GtMQ0BBaZd3JvAacJqffHsrr/31RbGXKpXfvNOT+2/739B2acTVv213Bzi8NfXG
	vRtIjAhgnomDpSEy9wqpekgFS1ddSh5kZjDBdftcyRvprmGnxYlNnleM=
X-Google-Smtp-Source: AGHT+IGbh8CgYLlXYyb2rdwY1DPoaPJm+/aXkkT4BfWZP495D8dscBNjGHdwHaTcSCwqHIzyDWtSgRN34xGRThIX2K3Qd0gl10B7
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:b743:0:b0:366:a4df:fc93 with SMTP id
 c3-20020a92b743000000b00366a4dffc93mr94888ilm.6.1710609481540; Sat, 16 Mar
 2024 10:18:01 -0700 (PDT)
Date: Sat, 16 Mar 2024 10:18:01 -0700
In-Reply-To: <7c16c203-8b5f-41cd-8c86-cba36887b505@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007f33eb0613ca4e5c@google.com>
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in io_sendrecv_fail
From: syzbot <syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com

Tested on:

commit:         ae551333 io_uring: clear opcode specific data for an e..
git tree:       git://git.kernel.dk/linux.git io_uring-6.9
console output: https://syzkaller.appspot.com/x/log.txt?x=12656231180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a271c5dca0ff14df
dashboard link: https://syzkaller.appspot.com/bug?extid=f8e9a371388aa62ecab4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

