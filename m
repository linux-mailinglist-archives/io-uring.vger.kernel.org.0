Return-Path: <io-uring+bounces-10509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC6C3C4974E
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 22:55:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3A641887F39
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 21:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD202F6582;
	Mon, 10 Nov 2025 21:55:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50A92E7F03
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 21:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762811705; cv=none; b=bG+4Bbyt6JbRpMbupo5m7SvvLYiuMENT8Kwv7B5Qqpj/yxp399xS9an1rT47LJRhFo4afOHTzBbTQ+o2fakTILEqQtnVIvp323vabFvGNcGB1FD+hIni1iNS1tVQz0y4bxM+KkAGvIZVpnoI/XK+3LrLHTJC20vAbQnCMlCjbFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762811705; c=relaxed/simple;
	bh=vU0TO8BD+idNrc28jXRVI8wWAlZ+X0qdYCZvmkn0T6Y=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=UIy7Gpjy47CrDL+1tivEpPz//UWcxw/hRHo/zRwWpK1nZqY6ciyhl6P/jfk+w9nzkKZOyMc4uD2p/XQYt7pVAaM7bG/soAq/S1VLaMLMTfNc/+8UBsD55DZFAEoQCT0oTUvqNYpHfeVNXHgcNwYiDoPQ4ZfUfVDmx7DUfE0n44M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-937e5f9ea74so449994739f.1
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 13:55:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762811703; x=1763416503;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ie2/PeJ0jgx5E8HiVBVNYjG7K8kqqreSpRHnsimU148=;
        b=bkhLXjKXcIhuvQiT6pz1Alc4rQfjtdydaZQxcf9BFQHcMTTxF45omS56rttT20DFce
         A1pnbRYd7UrQHQMxKgGJvbhzJaXgKO/coFSVpPsRiMf5mYwwOFOaxzOG639ojDM++j9d
         MAEBUZwPDOAqCbea7yBj0CT60McxgquBsYH80ig7xdpWKZ5QlNdVcuhKkARxQjw42Z+z
         pxJNV1C3EmupphueNPNSCFCJCgxxICy8PjWh2dQvmGvDOUdV3tUuWuWJhc4X9teo8s00
         3gHFDZEgz0fWz2d9ecjapjzExqgVkuBcL4QMHV5620d7ecWt3E3ZmMesWoKvIAug2sO/
         YNQA==
X-Forwarded-Encrypted: i=1; AJvYcCUo/g4kcfu5H3PdmW2rU5B9o4Y5rITmXJ8p3B5+8cT02LKIyw3in+BTwoXo4Fha4xXJU8YQy44Ogw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqo8TRIMyHTD86AO8+330xgNzLWXRfRIkk6lI1sI0sfQnz1lod
	TkJvrJDptgjJPNh0yu+PAdUfU8Bn1UnQzj9EPtbbuoMWaMFQT5nyQmPsKUm/gyOHAXTB01ySt74
	O9HZJ5XzT3SEwGvl390silUY7O2lFhXMDTxaaTKrmIfm58c/PzHKUytgqsyI=
X-Google-Smtp-Source: AGHT+IFUrp0LeNJfpbbEEybABNZcxFBbxPlCJBUWD2fXo9BWxHePezzLCfZ2+zOMd0I93Borf/de7KfAOoL7fCFMbpQmMLnNo9Xv
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a81:b0:433:773d:adc0 with SMTP id
 e9e14a558f8ab-433773db12amr116490455ab.17.1762811702828; Mon, 10 Nov 2025
 13:55:02 -0800 (PST)
Date: Mon, 10 Nov 2025 13:55:02 -0800
In-Reply-To: <d9753537-b2d6-450e-bd7f-7bd86dfbb7fe@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69125f36.a70a0220.22f260.010e.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] memory leak in iovec_from_user (2)
From: syzbot <syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com
Tested-by: syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com

Tested on:

commit:         4ff33a31 io_uring/rw: ensure allocated iovec gets clea..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git io_uring-6.18
console output: https://syzkaller.appspot.com/x/log.txt?x=174a317c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa4513d3a243489e
dashboard link: https://syzkaller.appspot.com/bug?extid=3c93637d7648c24e1fd0
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

