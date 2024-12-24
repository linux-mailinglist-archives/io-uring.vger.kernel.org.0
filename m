Return-Path: <io-uring+bounces-5600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E3A929FBEE0
	for <lists+io-uring@lfdr.de>; Tue, 24 Dec 2024 14:56:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 756DD7A1214
	for <lists+io-uring@lfdr.de>; Tue, 24 Dec 2024 13:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E29E192D76;
	Tue, 24 Dec 2024 13:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ejxdV5MN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EBB282F0;
	Tue, 24 Dec 2024 13:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735048580; cv=none; b=T4n5S7yDC391bl7zIlvRo9JgabuFFWUTUN6ocnRMOLmm2JE0n/w0oi4rXmKQWj3XZWDWWStfdvIw2bfiYa+B1+txuQhh7CQ7nwHUk5tMgA1I3vn50uf13nS9h+f6tdFYVSDh3eCObQGv5E2+K0UjRy2R9DE7t8OYI2R3FkIwQ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735048580; c=relaxed/simple;
	bh=1YFJUv3woduEH2qU0hAqzl7fVle9XNy3CK+9F9gCW8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N4oxbIsTNMyTTUO9rav3WJQqLzyehoLv5ZckRohzZUG1n9CXIj4naDT4e9OaXsKYl6iHuBz0coE03321HiNXE6cIY+nG3kTX5yc00vcKbwhjGK3JHNEL55snVrL9qMzbPYadmY313Mw0m/KkZhMzcxQ7oYTW+sc+Qi1zlzJokgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ejxdV5MN; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3862b364538so2897290f8f.1;
        Tue, 24 Dec 2024 05:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735048577; x=1735653377; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xXBpC5yBVFighvXdV71dWmS3VeVH7+AcnATJLZ/Z3DM=;
        b=ejxdV5MNKXgsL4Qo8csZF0yKSDKqxyFMlWlont7gg7tnxJ61rQleBNbbNs4KqJm4r5
         c2iG9ZXkkp7eLqVPhFmiUjnY600t44ja9yori3RdMZvpuKFXhGnr+O1xcDpb5/jxwUzs
         7M/1IzKxRjJAWjDKDJjceMHYxl6ZS7V9ss3hGK6H6A4gchwG/3/Lo0tgdMgFd+fHovWz
         1EP+kndQRxOoZaruxJ441WkxCVPnQBls/+btqa19i8tPjyjUfn3qgRQXH81e6uWztVMl
         PfsIndwtQk5sL6A3IAQnYJSPZKpoXZKkfi9BiAccFUCQH3Vg3g3fVr6/B71gclqw4kOR
         CVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735048577; x=1735653377;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xXBpC5yBVFighvXdV71dWmS3VeVH7+AcnATJLZ/Z3DM=;
        b=mWUVMLq+1303BkJvh5pYctrEVtJKfVfTeNJ0itjhleATb9ElqZRmvii8B2t1XoWNDY
         GMeYeFiz5iQPl3iI3KjfyEM9iT5XuhAvZ5iBpnTVloMLdygRVEIdQlw70iOlcjSllsBs
         ZYBZ48GyHjczA+gw6Vmffuabs5XE1LvY7ccTNSVROBewYOIKUI/Roi8Tu2Btg4VfEquZ
         d2Nun0v8Yo458Bty1vfnFStrk9DzVtrTAj0gwaPJpetv14gEyZXs0BxQZCGsxixMbpH7
         fW7tbZAaSxrcWA7+vPR6Msjsmizw+y1xcJGaWmoSy86DIla47hq/fiVvSOPFL0yQyHti
         dOog==
X-Forwarded-Encrypted: i=1; AJvYcCXU3mwjfglId+JLzdu/a7BDpQEmRSGaPdL9igc3MYu3KU/ta7U1F93t0iyj3/gnQBGEDmPhrVtK+uIunRQL@vger.kernel.org, AJvYcCXoPbtojuOwy70WjBntp9V3vL32q/S3QgnUx+NKpuMQe8bQyxyJl/1reabP//0mTLNPgVCa8cNZHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YybIQPJFFx8SZ5GiQfL9Bp4RzItUGZuU/95YtewjtQXkeCLFB/J
	Z90bBZ0pqI0c6Z3AFcY6rYv2yr2AUWOrlRgI1Z0SAYofz2Zagey4
X-Gm-Gg: ASbGncvvSKKRRAOfB8r4LlSpSz2mCSU7JZg3jt3yJQJqDtvAGMBOhmuIxovkwtKXsb+
	OO36JJKIcknijLC9PYS+Ceg3aBcq6zHyBICP/fe56J8WAjezJTZEjFoO1FJTh8sPkUvIMgACps7
	CN8sevnM+nqY8LQwxPfAaqHV5AWjeoQyHW7XqjC3oXuZmUbVnfBrzFCosGnimxiX/+QqNEqEvx/
	4i06jyhHLKS3KytXq7H6KUHCQqys9qXFtQ1jbZmYL0WE9q1k88Z1e9AedcrxksmYA==
X-Google-Smtp-Source: AGHT+IHajAuIyDQ+B7UVYH/AMIbfKlBZyeHzPzYZpCqZqdI6BoFmbpZf4JBbyBr3DrTsAdPq2rRbEg==
X-Received: by 2002:a5d:59a4:0:b0:385:df17:2148 with SMTP id ffacd0b85a97d-38a1a2641b7mr16885008f8f.20.1735048576796;
        Tue, 24 Dec 2024 05:56:16 -0800 (PST)
Received: from [192.168.42.157] ([185.69.144.85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656af6d02sm206138525e9.1.2024.12.24.05.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 05:56:16 -0800 (PST)
Message-ID: <62983fd8-d5f6-470e-88e2-6f4737bfed79@gmail.com>
Date: Tue, 24 Dec 2024 13:57:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in __io_submit_flush_completions
To: syzbot <syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6765b448.050a0220.15b956.00d4.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6765b448.050a0220.15b956.00d4.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/24 18:15, syzbot wrote:
> 
> HEAD commit:    8faabc041a00 Merge tag 'net-6.13-rc4' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13249e0f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c22efbd20f8da769
> dashboard link: https://syzkaller.appspot.com/bug?extid=1bcb75613069ad4957fc
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12172fe8580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111f92df980000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/0bdb6cecaf61/disk-8faabc04.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/98b22dfadac0/vmlinux-8faabc04.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/65a511d3ba7f/bzImage-8faabc04.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1bcb75613069ad4957fc@syzkaller.appspotmail.com

I can't reproduce but it makes sense. It shouldn't be a real
problem as it's protected by ->uring_lock

-- 
Pavel Begunkov


