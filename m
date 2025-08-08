Return-Path: <io-uring+bounces-8902-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE7EB1E869
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 14:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B83E3BD34D
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 12:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A0227814C;
	Fri,  8 Aug 2025 12:34:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1167F25D1F5
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 12:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754656447; cv=none; b=AO4jRrH6a14uMAeuWXTRGFwkfJAIc0qAz2OFBEcl4AM25z0zMFxWM1j+VqFOnU7AQ5i7COGEwI5A2rl3UUiq1zw/i9psJZgIax/QkFTl6Jli0ZU+8KJSuJMUa7NaIhYIscNHeggraY3UXb7uLFgFQbomiTmN/TyeEft25oci7UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754656447; c=relaxed/simple;
	bh=xGj2r9yQ1Wt1TFQZQve671G0WdSK9M1huBggd4W4EdM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=JegOn8VYJNrt/MjJbTXCBt/BzS36tHOIuTl1xvVeL8NsMLevzTKzUB1lGJM8df/HV94mzJsaFd1CyD6Ui5tZkukHzheYvRTYwGtAXeFI/eNxq9c/Uu+hyRBTfHmgCiVhaVmrqGpmatk6jvZmSk5TI1uhjPZZThWHoashkq8/WrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e52c9fc37bso33819865ab.0
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 05:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754656445; x=1755261245;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L303936goaW8DRBeh1Tb7JruAw41qWahy4Yr8OwMpP0=;
        b=doQ10reV7e143MOTBRLIPGJOCxHA0yedRu6nPsCtJp7WjExtKYUQBJN3Nac6C89jjq
         OdKtHWbaMmTX8NDnkMmnxmSyMJBhlwUNDhEu2PV19W8cl0tfH9JY5tu1B+OeY6xKYZ5p
         dfDazCS6WZR6Fr2eASCoCwHU4yoeIGopCcZa2xnm305R0oc3l4YmWk8JKyY5eqm/axT9
         bp/q8ExjKQJlA3RkrmC/lf0z1i0jJShJs4kS6AwucAAjc65B9x6/s9u/b2sLAThqGJQS
         eEUsN2pwCTyijomAq4dGgYKmMaKN6Jqa/nc7Kza2fpIqWI14cAEq8pkorUM9OErZwOnl
         WDMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMwAfU/+mLckMNvncpN/kHV4yEsXec/SuAJkjEYtVQ0siBICREPolINdPLU3W9huoIbu/Z/Eg0FQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXcR3J0v6nZ/7eMBJi/goObBOa/XdvVxVi7RZRSYuJDYKV6ClA
	0Q6gPwYN4PoiAnZa7rxhwsiWeKvack4yBXq/zapeXKq9CgKfsPTuTHyxBNm6+KNGGUwJ41di9Od
	hKxhk97KGlzK96MiVOMm/Qfc5Z86ufL8h3RZn59UWWUpRjWk82XG64CjvO9A=
X-Google-Smtp-Source: AGHT+IGZwq70OCelaUCm+iF1G+3p85RF3a+RFQWMGMHQznr+vFTf3cT2gyZAAw7PR4k0BFLHgihAA/KtR62JrneyLO6PYFDfMlS/
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1687:b0:3e3:cc3b:4c67 with SMTP id
 e9e14a558f8ab-3e5330b656emr50445175ab.8.1754656444643; Fri, 08 Aug 2025
 05:34:04 -0700 (PDT)
Date: Fri, 08 Aug 2025 05:34:04 -0700
In-Reply-To: <af7cf1fe-3019-40f2-9650-d3e82c6c5294@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6895eebc.050a0220.7f033.0061.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush
From: syzbot <syzbot+23727438116feb13df15@syzkaller.appspotmail.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> On 8/8/25 2:17 AM, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    6e64f4580381 Merge tag 'input-for-v6.17-rc0' of git://git...
>> git tree:       upstream
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=166ceea2580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5549e3e577d8650d
>> dashboard link: https://syzkaller.appspot.com/bug?extid=23727438116feb13df15
>> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10202ea2580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140a9042580000
>
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git> 

want either no args or 2 args (repo, branch), got 5

>
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index 725dc0bec24c..2e99dffddfc5 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -156,7 +156,7 @@ static int io_region_allocate_pages(struct io_ring_ctx *ctx,
>  				    unsigned long mmap_offset)
>  {
>  	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
> -	unsigned long size = mr->nr_pages << PAGE_SHIFT;
> +	size_t size = (size_t) mr->nr_pages << PAGE_SHIFT;
>  	unsigned long nr_allocated;
>  	struct page **pages;
>  	void *p;
>
> -- 
> Jens Axboe

