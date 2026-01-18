Return-Path: <io-uring+bounces-11806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F195FD3993C
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 19:44:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 44C0B3006631
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 18:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741D4301465;
	Sun, 18 Jan 2026 18:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EbZApvlI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C0D238C3B
	for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 18:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768761885; cv=none; b=oLFK1yAJtsd9S6MNoUudvx7Rj8OvNugOsPs3/eLj9Uq2pmKOZOWYHvUdOYrnGm/LpoJDuM3qMRGV5rXESJsbcsVAhGx62lhUBbzysxx1DrYVxdoVaBMfEULzV2SFOC6kwcpXgLLTTENnxQCECVrmx1k3np9hkAjnlK4I2n1KTE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768761885; c=relaxed/simple;
	bh=ah9zkvn2sdxtdgQXeDwzwbl/HApUeNuWXE8T7pG9ZhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sfqEyvr/ttHJkyc+wblS0FUwrDNNQe8QMxgyAItitFEuHgiCH4kOywf3d+3xI8+1NHr6s8F/gIJ/jfWavUOQ1kHRSf4uelIpHcKM/jsr8Kpj35G+vvXueHUjOAziY7p1/gwroYIfReZjWok+6pwgKW/db4RVjEZ+IAocPf0PbQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EbZApvlI; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-45c958d480aso1683436b6e.1
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 10:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768761882; x=1769366682; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hAo2393AyNYS+GfXkHGQ+o45VOiIKl347Ln7NhY8ziQ=;
        b=EbZApvlIC5LmLO0e6JADhQWenLqFj7gu7/z8tb07HF1mtqX0MkhYrEolyvnOhRbnTm
         gjyles/RgKMBDYzo69JmX9f2tU5nPGTfaD3BxTEoCsSvt5iBnPA4j4iCYWDNona14agc
         Kopetvaz5J5iuJom4iTyGJE1dgUW0vEU62Fw98ZslJDObPPzlWLKiYeVNW/vxsr6uy7Z
         ptUwO7CK4FccJ1kMphqTt9l0iyfnfm70r1+wnY/YHbBnBg/o6j44JM484df0FqFAg9k2
         jUadg4FyOG5/Vr/czIYoHZcxROhrZbRoj1yfnWrwkjNWDTYPMCKKAj5QnPM1HvqqPm4v
         2sEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768761882; x=1769366682;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hAo2393AyNYS+GfXkHGQ+o45VOiIKl347Ln7NhY8ziQ=;
        b=YRT6M1gznrHlbgkGaGSLkr9iE2w2PmYJxRMfhNAdoumtYB6BC/nzKGmMUbJJScjUvG
         M7cMMutzD0nXJ5XwaDz+t/KVRomTDrYezFb9pBJXiTxkCF+n3B2DilMjaEXOF8LVx3oi
         eJAyFsQ3hGQDFtWM27f9S9d0qMXUffUqtfJb2NReV0nsUCu8wF/9ZoJsptYdCmCzEpA6
         I1yl0mf7jlGINKvRsgUiRvIm3Rfhw906+8IOUIGse6lPnwfyZHiiGQFj4QGUKVDHXoIt
         GzZHMh/qLf8QHhh9FUrJMKMCvdTKsDgEprNL3C6/7UY/LXlX5pjwuT6VtLYiaUG+4kML
         G41Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLg98CaXb9xFXC8Jz1Zz0PUaH2QYEhM1BwabWgzwSt23HYeuOXP/Onpx0j56DMI5FFItwmQxU0Mg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxOrkOn5eXvgTZgo2rnClbwssZpOoj2I4nVgQjb9l8hber7W8vO
	fazpVwP92oj9BfpxmEtoeONUHjX8omMOaKXmkbFDzaohk1mebfIZOxJ31c/TuxZiAoAYoyP4MVR
	rMXWW
X-Gm-Gg: AY/fxX7GyjlEapDeawPkY5ZudW/qh0O8vy6D3toEpbatJ5uHNOHk1PqnRQWecS2YaF9
	1jxeC/7+s2xyY36zoYGzzaJcIUBGCsY5SANdeSCB80EGi+YBW1DtRCYY4nPKxfA1AzK19UtStcu
	o2zU4kvmsThcevKUYsk/ctgPH4YymO85FxzDKHVEc831ajnuoDK1OtY+0pWfdka+j3aoPNGBKqJ
	YriTywYZjsaklbx5NAiHfBT4YMZdptUb/NpvrUWgFF6Mx4OIsCZA1o9GpIF+gzazL0LaHzOlgUN
	SOUvEGYPwUiKIMwWXXF7Prm0G6BCGUeUGXBma3ZYM6r6APiBzu7Fkx6rDGjjfkZTiHB9jgjmYKx
	btTaViN5eklPMKe0UnAnyni1sXUVDY5YCODJBsGrbDhjlKzU1avHj2f15avm64RyuvhxK/uIfca
	mRs0Y4bgqgtiaobTPAXYMPPF+nMueg/qLXnL1iLpdjJ7FnyUgFVPgooihZKxGOgkY80zUpeg==
X-Received: by 2002:a05:6808:1a01:b0:45a:5584:b8ec with SMTP id 5614622812f47-45c9c0815cfmr3721930b6e.32.1768761882254;
        Sun, 18 Jan 2026 10:44:42 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9dff9789sm4451976b6e.13.2026.01.18.10.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 10:44:41 -0800 (PST)
Message-ID: <e54bb96f-9e18-4598-97a2-c835d9424a9d@kernel.dk>
Date: Sun, 18 Jan 2026 11:44:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] memory leak in iovec_from_user (5)
To: syzbot <syzbot+321914d39d7553cca1e7@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <696d2952.050a0220.3390f1.0022.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <696d2952.050a0220.3390f1.0022.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

To the syzbot people:

https://lore.kernel.org/io-uring/9e600e62-499c-4f4f-a4fc-846bb0afb110@kernel.dk/

can we please ensure this is done before posting more of these? At least on
my end, these aren't reliable at all.

#syz invalid

-- 
Jens Axboe


