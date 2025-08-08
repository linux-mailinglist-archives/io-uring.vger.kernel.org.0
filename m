Return-Path: <io-uring+bounces-8903-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A065CB1E87C
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 14:38:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 577A87B2BA9
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 12:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D138279787;
	Fri,  8 Aug 2025 12:38:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1943A2367B6
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 12:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754656685; cv=none; b=DsuPQOKCS9qvlgBm2MA/7C2rWK0G7SIh1fF5gWWYqJjrDsFJp+wy/1h7E+KJdAPwTs9uqnADGAKMYxriIf5yXALG5TbN/d/vN5tdIUxYwmF+NAmeTIyUILBCI/NTAJ7WYT4VJww4w+yng65R9ZM3k0IBNLxinYbslx5efZi4Irw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754656685; c=relaxed/simple;
	bh=MQF7QyOgSa+2BXdyyStEjlrYVR7UqSRX6YiqJl/QaFw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=a3tMIjQQdDdpC+rZswlbEmaPNN0pNNcnf5002YYRwMSibrfB+fwETm8Lgv/yhk9YFKUQCBLg73A1meBfxZ22IfyT05R9cEWg5kYXaLFue20iavFPCDUxbchXWDfys2gZtaMztAalGPW+Y2wh9l/q66IdIP4JpnXqXa7l9L9FbI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8760733a107so223399239f.3
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 05:38:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754656683; x=1755261483;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L2nN6/Vrn1CTTUYbb30bQYJ4+V55aZvqm3UjxERjUs4=;
        b=XumKVS4o7pkciXiacFPD0axba0E3QSHLMzpg4DVRLYNqU7afJ8bkhKsIMvR5fFgQ4F
         vUgUajtsh3hkF5t8gZ5huqHszE55xV3ZHlv1Xo9cZHQb1bb19R//YwVnu84AjUd77ayK
         Yr2c68GOgRIxWk+XDBxQmfR+yhkDhtP4zV1njIowJwZrEVlV5LHew5am90/iv7EGd0T8
         XE01/q4N/D2iG3Sk77oAwbDKSXufCAHnzyYWZvocX27Gkt8o+/C1nNJDVYejq8mBbaA3
         mC49nmrlkYI3H7MIU/7klnqlpKhSpjMychrMh+OZ+170dcaAnRd/uUowY04wFQl0LgU+
         nL6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQSR0q12O7bzrAl/TCR3ofR8dn1k4rFoHyzKxVdxPvxmiP/QzWnlMAljWhjnip+rQC2UZOv/kHJg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKrt6AcgJ1/ncptwKZnqjk2AAYjXYbJZpQgEFCpf64NNUoL1tR
	a0w3vlgcfog5G/s5WJPeOuaMq0qGrMUp7Thse9KF/+OQvQJyDJr/siz+Ewb1xB+dSmO2rhaQ1Zy
	zFlp7yb68ujZ0VfDA5aXaYn9luMo2ZIZZrnMhqxgSIejaJOApK4KNQjxghvA=
X-Google-Smtp-Source: AGHT+IG+DZJpNS408k3+BBE9D+TBgofSkxsBw3hgke++VWUqClU2Hm07u+NviVTHRUE5LaenWKhGjmxjPAktEbdZ0kEcB/dNZBy1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1591:b0:87c:72f3:d5d7 with SMTP id
 ca18e2360f4ac-883f1268931mr550396739f.13.1754656683260; Fri, 08 Aug 2025
 05:38:03 -0700 (PDT)
Date: Fri, 08 Aug 2025 05:38:03 -0700
In-Reply-To: <c04ad55a-7c66-4e30-bc22-e05682eeb10e@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6895efab.050a0220.7f033.0063.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] WARNING in __vmap_pages_range_noflush
From: syzbot <syzbot+23727438116feb13df15@syzkaller.appspotmail.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> On 8/8/25 6:34 AM, syzbot wrote:
>>> On 8/8/25 2:17 AM, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    6e64f4580381 Merge tag 'input-for-v6.17-rc0' of git://git...
>>>> git tree:       upstream
>>>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=166ceea2580000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=5549e3e577d8650d
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=23727438116feb13df15
>>>> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10202ea2580000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140a9042580000
>>>
>>> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git> 
>> 
>> want either no args or 2 args (repo, branch), got 5
>
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

want either no args or 2 args (repo, branch), got 5

>
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

