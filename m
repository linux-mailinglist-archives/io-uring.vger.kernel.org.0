Return-Path: <io-uring+bounces-11714-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B9317D201F0
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 17:15:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 130C9305CE7E
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 16:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF5A3A1E60;
	Wed, 14 Jan 2026 16:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ekoj3vYQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C60C3A1E6E
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 16:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768406994; cv=none; b=JwBC21l6ciHYAqNe1PEUPrUxLosZo1h+IpmSHcH6AcmTEquC2O1um2DzOZ3H9Q+FxwrE8nYhEac9tutjWPmHhzSnVMcCQfvgBHGqWoJaHiGtjb+ZFGlN66Vssu85XXM7zfXxjhg4tD5FvINtKY+xdtfyUBh5lfjXZku6lxozdvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768406994; c=relaxed/simple;
	bh=io/s/3iiTlGiCEs45YILiC51yUViVAjsVzx8sNaLg6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TFIOv5u61C7hqhMcYhJtrfv6OH54eRXRuMImH9CVoUdEgmUCs/PyvzYGC/qmvCscJqQ2gJZJ/T1khqCtU3OuOytrnyAOIlMqjIYH6P4Pf46kEDzoWdGAdaYv6/LHygV/0KLFVZ6O513b2kuFA0l2jPnAZRkFHvcvgPsDMVeS/Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ekoj3vYQ; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-3ec47e4c20eso5593347fac.1
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 08:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768406990; x=1769011790; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UoE1HR4tF88XtdOXlpm6mAruAKIaW+5i3etkCa48H6s=;
        b=Ekoj3vYQLp5Wj1X0STS4d9Ee2mF00Uyl/99f2oFcWds6RA6YZ+WjjD79kBVic2Lwl9
         tDOzykDOtULLa99T5w32k59SBOFtf1H8okRplf6sXMecLQJwBqK5WXh2dqkcflOVbE8U
         AycC7yaCPk4r2PJZFKtUwpMh4+P/rknypMFyb9UTN+wOv9EXD7+FRfWQ0ChyXyqjG18q
         RjdPBtP+h0Lp2G/NT33Amyasnua8ZR0XBPMT8F/2LiTzjh29szMwgllME+8jWb9lTeUv
         dpNPph1PPEs8jwQTILMeHCSHMmh5OHzsnG/qBFhGHF1AKIunSZW7VTwXrps4a7un+E78
         g5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768406990; x=1769011790;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UoE1HR4tF88XtdOXlpm6mAruAKIaW+5i3etkCa48H6s=;
        b=d7UtrvnxbofQoBgMvFcv7i31RmnA+SlymE8XgNh/MfV3eEqND39Guv+1dcSdJ7gm9A
         FUBUc+wOkiUjT5vgpmX9ybapF/5inbHWfa0GkXeibOnfCZHIiNFaZbRU+mrXNWaZcGJa
         3IW+FaY/joyRbJ8UMUfwuN91dUTcfd2w9psaRPLUzvvhGpZNV4K4CG2juQrifNqs4R+q
         d1xGSRV/80VoTuchyw0Lg1OiZcOj4ETakyCC0r0+o1J3hdfd2zH/55Lz99z8ncZKh+5R
         xdqxKfZDTjt4khCDwPg4C9xu0rqSmbb9xUDDseR492pMszyTXu40RWxL0ctgS/OhFnhU
         yPjA==
X-Forwarded-Encrypted: i=1; AJvYcCWXzMFD6ef4tjG5sxRluUdSGI/kx+4y5Ek4IyuwE6tEl3SwvVI1WwF33TWxMXVZVf7j6pVDp041lw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuzOSQBGSZqkOaWxVEdv+J1TqAhzRgOdE+8GpDec+CFvgvnBCN
	V5yocSEM47YI84NUpgSo8JTRvZFn2AsgTH0hO/9j+zI5z/vz8c0ymz3H2enXInkn71o=
X-Gm-Gg: AY/fxX70fUoT8raVwB+Hua96hi65Y3zb5MaTCYgjy+bGCJ3+X92bgHbva+MSM6IiwBm
	bL2JgLscl1SYkgZ6FmRi6+AM8KgA+p/mQuZvCU+t89zyJUbEUSXjI/tmv+ju5Fl+FCJHoDIzKT4
	glNsHpWtumuvIB9q2YdiIz19f/cK6XnPx+IkQDahh81hk2vDEzYLZKGHIgJZTZb477FACMsBRo4
	MBXuPXRLXjMFqG5BxDV1GMQGANDB3eKixaQLLlgp2u+G0TiWBQiCB5vrBAQH5hQn1ENap0P4f/q
	JToyxTmbpgqPX9ykuy0E2i7cq9obwZB6fNuNRzlaqsOl/T/Jy3pq26EECycFyHJsY1IIDCi6h4F
	Z+6BzY6Z0kPVrH72O9k6GMVMoBNuu+97Jx9nhhy5eJbNjx7Pc705awhDyb7plO9K2fSFJG5G/7e
	4Am+Y3vVk=
X-Received: by 2002:a05:6870:2115:b0:3d9:158e:d943 with SMTP id 586e51a60fabf-4040ba29da3mr1858233fac.9.1768406989847;
        Wed, 14 Jan 2026 08:09:49 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-403fa2058f5sm3130208fac.13.2026.01.14.08.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 08:09:49 -0800 (PST)
Message-ID: <9e600e62-499c-4f4f-a4fc-846bb0afb110@kernel.dk>
Date: Wed, 14 Jan 2026 09:09:48 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] memory leak in iovec_from_user (4)
To: syzbot <syzbot+df0b387708573ad096ce@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6967554e.a70a0220.1aa68e.0004.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6967554e.a70a0220.1aa68e.0004.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/26 1:35 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b54345928fa1 Merge tag 'gfs2-for-6.19-rc6' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15f82052580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=87bc41cae23d2144
> dashboard link: https://syzkaller.appspot.com/bug?extid=df0b387708573ad096ce
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147ef99a580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109655fa580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/23b084ff7602/disk-b5434592.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3ecd3b0e8e34/vmlinux-b5434592.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b42ab3574030/bzImage-b5434592.xz

I still think these are false positives, and forcing another kmemleak scan
would make them go away. Which the syzbot reproducers should arguably just
do. As mentioned in the email from this week, I ran into various others
of these, all of them invalid. A rescan sorts it out.

#syz invalid

-- 
Jens Axboe


