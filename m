Return-Path: <io-uring+bounces-7192-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94380A6C875
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 10:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0361E3B9752
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 09:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565271D618E;
	Sat, 22 Mar 2025 09:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CeNcQz4g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFFF1D5150;
	Sat, 22 Mar 2025 09:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742634249; cv=none; b=nTssPOanw2lC8HfhnjffA6CYo0JU72NlaOveEpLZwFN96p/z1yqIcBXWVSWt9h+7V3+jiQvEMyM5tGpycdKcsUuJanrgZfe/0fx0Fp0usOcvA0md1tReijnHR+FDls4Ee8WTpsu/JPWFCYe/7heTAOMYQTHWfMIbh7AOH+0E4iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742634249; c=relaxed/simple;
	bh=zIjQ0cg5IqIYk981aMy87lHSgY0ETLH+gn+iWicm35E=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Z4kMGLb6XhsYGLyQ3daxjNuZpWtqhMgRO54s3Xf2Tvg3xJita4pH8qWyzqM0xm+DTHWK9mVYO4zKVMgIQ2BTz3Aelgi2IGdhrKRtV5q25C/Gqaft3tz0Df98hatKsDZ7/FW4/I93uD5v/SeOlJrifxoztQT84bI4X3vUU5gFpQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CeNcQz4g; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e5e22e6ed2so4175967a12.3;
        Sat, 22 Mar 2025 02:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742634246; x=1743239046; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0WEFLg15YuRe24Thp6xqZzaXDWK7siM/NvEMGctFLYg=;
        b=CeNcQz4gZi+IK5GzskwBmxc57klkGRsjoq5OUS2gl9MxVGuMKnj+ExNO0YRgTXYGuY
         7VacE98C2WQm49o/NTRjDIwaGbXwYsGu8DR9rcEXVc7e8B5MAL90ZA8+u6TC/lb41zkK
         0LyJ/4bY55kS9o7l7eW3vJZ5I/YzWi4gm6X9yK4nk2CANx13d9O2EtIfJufj0DRTDVS4
         0xBj390zi9vU7qg90zNhj0VlBIntDo/J19wHPirrb5Qa7q2G75XKdxe9DO4vR0IJoPql
         CXL3LxkxqDnqxBDs5vJsRyhZYEWpyLULolYlV9m/YImRMnS6zZDqVL8KJcgmZbY8ckmS
         1QRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742634246; x=1743239046;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0WEFLg15YuRe24Thp6xqZzaXDWK7siM/NvEMGctFLYg=;
        b=tKq16O+8bPjlpAw7wVxGgAUvMmTbKCEjnhTc4Du8R//rvVJ4MHqUEyqyMgPa2UHBw3
         gew3+zUGhOMGsG3laLuggtQvXhMTJJAOp2nfvlqxQSmrzr9VhK8ciSSZD9A5LuK0XrEp
         ftriFYWCUTiA5n/l2N4xPcz8A7ToN0HvnldCwVdyScWA7y0eiOW1Hp3zRjahWm93g3xX
         851wIb/VmzLXSvihrfVzdCiUAqWIdpn5UZmstr0VBaKjQ31Zl6x7IB6wBojuLRfr3WHP
         nD8hwjwAwyC75gO0llTGidqjIZm0tyPa1YtuibedojU5veGBIAYT/det0oTpBDiffZAr
         5yxg==
X-Forwarded-Encrypted: i=1; AJvYcCUfrqWzWsGFJ8Z8uDg0GnX0MtLNae9Wm9+WjBSRuRczFp4tExjucQ79dAr6b8fusyzaw2zSkUbTVMviwCPx@vger.kernel.org, AJvYcCVW07dd008mqoIwyNghLYZqklVFUa4NHeYhggf/kYUtZ2GvnK/BoIXyDt36kNzxXjPD8CYHCGx9Fw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFx46aSTD1Fz46HSybq9RGKyDXiVjbqYyEcXE7zaW+u8x6eGC6
	hvVxBpA0KsCof7sa9C+uW+bN+yaMd5C4eo8zeNxUqDfHayVWEZmvCO05Zg==
X-Gm-Gg: ASbGncseSZiONzS0tHb6bro5iBIYvrwENXPhz2Mb3XpdWSo3Jum2mDRao7sVCZij38o
	ByF41wVB6lcsEiXEqcCNJGwbIl6HZfWYwupY0++FDqT2cv16eQI3BWk0FQ5MTWfP07vYxYD0hhy
	ctrbEs2nbJCKfrrr7zC3SEf4OunDiKr7EcxfWeigdgTGhrlKoy0TNEk0gn08C+v075m0+P3Dwnh
	Cku3nE3wRJbtWEAdqCSCQUZ4nJo0TE5x4XGF3wP5sH1wyh1wwYxPCVksOZ+88136jEjfkgdlgzC
	0zvmrIowlkm/J92G0hoUzLuxWCSysOq+H9Wr9NI9rd947geTvvWw
X-Google-Smtp-Source: AGHT+IFP9ujnHjmjshZeTc91ysg4uZGIc326Y2yqI/cgoniP+AIRlORhe5RjfRk2QcWAFdPbWYP/Bg==
X-Received: by 2002:a05:6402:2349:b0:5e4:cbee:234c with SMTP id 4fb4d7f45d1cf-5ebcd426839mr5193159a12.10.1742634245427;
        Sat, 22 Mar 2025 02:04:05 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.37])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efd56a09sm307877366b.172.2025.03.22.02.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Mar 2025 02:04:04 -0700 (PDT)
Message-ID: <fde4a18e-0376-4c3f-9b27-b644c211618e@gmail.com>
Date: Sat, 22 Mar 2025 09:04:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING: refcount bug in io_send_zc_cleanup
 (2)
To: syzbot <syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <67de616f.050a0220.31a16b.002b.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <67de616f.050a0220.31a16b.002b.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/22/25 07:06, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d07de43e3f05 Merge tag 'io_uring-6.14-20250321' of git://g..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=14223004580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=620facf12ff15d10
> dashboard link: https://syzkaller.appspot.com/bug?extid=cf285a028ffba71b2ef5
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16be1c4c580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12223004580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/a241563b93db/disk-d07de43e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6c435395db14/vmlinux-d07de43e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/59fc4b510cae/bzImage-d07de43e.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cf285a028ffba71b2ef5@syzkaller.appspotmail.com

#syz test: https://github.com/isilence/linux.git syz/sendzc-cleanup


-- 
Pavel Begunkov


