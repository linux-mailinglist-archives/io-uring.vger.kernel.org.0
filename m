Return-Path: <io-uring+bounces-8642-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31939B00F36
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 01:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA5FA1C4039E
	for <lists+io-uring@lfdr.de>; Thu, 10 Jul 2025 23:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20BF2291C11;
	Thu, 10 Jul 2025 23:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Uf6AxtQ7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CED235BE2
	for <io-uring@vger.kernel.org>; Thu, 10 Jul 2025 23:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752188637; cv=none; b=Fil1+Qoe20PA+ePQDWdkRS2V5LjGJE932uuCTW+OPrGKLd/W9aU2X6G8MeroJdfAeX6K7KoS3JCTpCTzMmVfrccK4rWCyd3L9eHaDVmIMDc53PjPXj8g4aDBHU0E/3rMekUxFUwZkJlOxFIQPgxmkQJdHGMwjpMlMPzoZB5qAj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752188637; c=relaxed/simple;
	bh=2ozQxcXrSsB6hxlvVxa5vn8vLPtgAClSg2bXK/ua/FM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=a6EbOlyAUYh3mV3buDnRQ1IAwsYPLw/ZGWSoCILQPooLVLE3dOd1aXm474nd5/isDD2LWOg90xZ4LywrZCW1HGT9yKYCV6iK4IRzdAvcpjTpS5m329y8MxnlsJEr0ywe3kj3IiyRZwzYrv083Lb7iJht8U6fkJicvXw2ZhccvV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Uf6AxtQ7; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-875acfc133dso63116439f.1
        for <io-uring@vger.kernel.org>; Thu, 10 Jul 2025 16:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752188633; x=1752793433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NgvPqkcFQWrOIbdO1eoUJrM69HgzvQkAAI7Iu+y3QxU=;
        b=Uf6AxtQ7T7MTM6htdFtrAca5oFfLn9fobRXX7RYsBq7lH1hSCp7vAs0zwA4nmUF03X
         370pLORXZzj9GkcgaWAXNk9oO8VoloP5JQjnUURpVFWy8m0eKQybuoZKLNHyQlp96zZU
         JutNMyaepi8oOGf6IufqH3LvckkIOX0e+rhxycxpt78bdGgV/jrBSyEa3Jf+7n7MRJ5J
         qJ1CdyN4vvum/3Xz388hb/RIVoge1SMNDgbboX/g7w63VePeA/vpkMxumfJPJeOoumRv
         YpFFpQ5NwRYNYJ5h0y4/z+56oBtlfHhfxmEbwgEhBtMLn430is39Tan6y8c1sQbM9NLh
         VHjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752188633; x=1752793433;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NgvPqkcFQWrOIbdO1eoUJrM69HgzvQkAAI7Iu+y3QxU=;
        b=Sx0dq97J0jXarMWJlFa9WzVjIBRp0hBhapNaGlS77/T//c/5Ho7xbHx0AFxqZ0nuuT
         aS+84kXZCHIQqlJ02lAaUnihuLeJfO90dViYNuHG+wh0SkimQE18KNNOFXXrO+9yJotd
         moyqS20M+GvQJ4Q39VvjnPRnQtYWUgN42Q5SBUJmwoJfbL/ORX1QVqK21a4hAKnV4Gls
         0k2KZhba/4Lssu/hn5ABE3VuAokcM1iQ5xsi62WI75bmL/OsjdF5Pxq2d3rxT9HjPEi4
         hdVqDhAgXW+MUX9cxbFhtPF93TfVnHXoVsdLuXVx517GvZ/KjKRcZk7TfLIgAZIFz5L3
         CxRg==
X-Forwarded-Encrypted: i=1; AJvYcCXuE0H+S6MtbCyr5Gus/3x9D1We+An2+s2uQJVukx1cY7D7pAn/IiGqXivA8QqW1GzFiW6VL+NDmw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5j0W+OS2zx/mbIY3SYysF98bghbfLsiZEMmipptERFbUJLYnf
	4ORH8fsBDpjZFvkGyIon2UM46FZ++7W8h5OEuPqYiig6vY6raXcttT5sWQj1A4rl9nk=
X-Gm-Gg: ASbGncvR0tllnCPgFbQofPaZ9+ccdcwgKgEiKPruOsEufbV3/hbTMdfMMZ3fNIJRY75
	+9DS8WJA+S+yf2OEdDYk6+Qe3WTws48gIxSNGvhiW6dAnLRC6RTzY8BLZtbcbbAiwFwGvWBI4rn
	+bBbqx1MK6Xvl26Y58HeTFsyxwFyhGoZpVwh7vMCup/C2nQXuniuTsra3hsJCLlUqsDingGi2WT
	lZb/j9n+duf3uH7QpmYvC/OVSySj5lHvTriTvPeYwRGeW7F7yWfh50N8rTwhueEfpViPQHZxk7V
	fQ3u9FWKNdZHBsU2SZpzre9MHt1wSReT+ZPbxhc/c9BlWdQS5IYLg+7nGgOxOqB9inRTLl6DNcy
	2Syt8hJ6umSYGizaGJg==
X-Google-Smtp-Source: AGHT+IFZqw44B0Vv6nW/9xk7N7AD2QRT2sevfcK//8EjnadmBtjNxPnTSOaCyE2oZgHFeOuiaMaoDQ==
X-Received: by 2002:a05:6602:7181:b0:876:8cb1:a010 with SMTP id ca18e2360f4ac-87977f6b28cmr167309939f.7.1752188633464;
        Thu, 10 Jul 2025 16:03:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc13542sm61861439f.30.2025.07.10.16.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jul 2025 16:03:52 -0700 (PDT)
Message-ID: <b3b56a18-fdaf-4d62-946b-89dfba89f044@kernel.dk>
Date: Thu, 10 Jul 2025 17:03:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in vfs_coredump
To: syzbot <syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com>,
 anna-maria@linutronix.de, frederic@kernel.org, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 tglx@linutronix.de
References: <687040ca.a00a0220.26a83e.0026.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <687040ca.a00a0220.26a83e.0026.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/10/25 4:38 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-by: syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com
> Tested-by: syzbot+c29db0c6705a06cb65f2@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         5f9df768 Merge branch 'mm-everything' of git://git.ker..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git --
> console output: https://syzkaller.appspot.com/x/log.txt?x=137fc0f0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=44a6ca1881a12208
> dashboard link: https://syzkaller.appspot.com/bug?extid=c29db0c6705a06cb65f2
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> 
> Note: no patches were applied.
> Note: testing is done by a robot and is best-effort only.

Pretty sure this was a fluke in linux-next, as it triggered around
that coredump rework, but then stopped triggering.

#syz invalid

-- 
Jens Axboe


