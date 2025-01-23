Return-Path: <io-uring+bounces-6053-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6867DA19BCB
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 01:31:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C7F2188AC38
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 00:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A70F629;
	Thu, 23 Jan 2025 00:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gSVXHgTM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70373C2F2
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 00:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737592257; cv=none; b=XcX848l8O85PLNJFUPdirbUNsaBxEws3NdwA1ffViwsscCbZUWE/KRTGcYhShp+6CKQHsbgVgJujh2pVBrK/XY9Q4lh3Hn/FEiLkWkqAau5UKqgdkMlQkP8Iei/v2u9eXjar0sJUMqXYpxfWXn2BxMCs5c1t1riAxNI9hGkj2Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737592257; c=relaxed/simple;
	bh=8w0WzRWG1JUDMfFuY8GlHO7wEpY0ELt3y2ely4WzXM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XJogW+anHI6ymVndRuRG5WKfAXpOPxTBEzTZ55s43l5JWsuBxzBKIpCK3D+JbwJrwPBd6XO2yQwjDJ8WzkdLtbVwHww37i4CCyCN8+bJLXkF2WUAKBaCCYD6l3XOKH2AXDrjuHNLgKG2Mlf2rXjnVfCdJSqHmUmQrRY+7SWqGgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gSVXHgTM; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-386329da1d9so144577f8f.1
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2025 16:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737592254; x=1738197054; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TlyF3A7iWxJgBpbZ0AbsidMyRgT8ns9L7HfdBSRmgms=;
        b=gSVXHgTMug7kw3rPq7w5cvAtu1GJphhh2k1QB5ROWkbDXjkFsNJWgaKhEUSU2xr94t
         M3RMhp1dojoRppLha1ldRwmFA7r+DyM9/FElIurKOrZow8ELAviZw6LKLer41Z7vIIw0
         PKKZI9f9vL4KuuxLANuf73Htsp0HIE6wQqkVtorlB7at/PNOXd3mDNUhwTaQkKXx+1Y2
         KXRBfkv8ahTV62vQ7lrS6e4oOU2cFveXcIgQ1l6t+NnP//3rIv2nZR75dHDqZ9Qja8RO
         WrpT2JVT0LXEaxRXttrohIb4xvcQqdlFMCrctZgcqp3jqJ5zlWB19N4rQQ4P8HDwTgja
         I/Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737592254; x=1738197054;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TlyF3A7iWxJgBpbZ0AbsidMyRgT8ns9L7HfdBSRmgms=;
        b=uX1NeJmoY1gAyan9RrQJD2xcSBaQuvkF/5NHP33Vo52cP6ec9rV/rnr+qd3KbZ94df
         IRS/BZ+hzGLfIENVW5ZgvUAbMTinpfj4mcO4/YIrHpIluhRQtMvy8ZRJTV/6lD5bX676
         0Dj2Kk03AioNeB8SJdPX6wQfZaseZ3dHLA11vWWgxZwGxFQjZIaBT4Vu2LXVfrQXgGRx
         0VNWunhPsMBeoy6lMV4JXetFeTH2HFfJ66pBuErV57QrcOZ3iSNnHFY1Zs1F0ez9fAvQ
         EKTUKrJsMzxShRUqf9dmy29PlxrTVtKYtaZX7L3kkVrhWtaUzSj/ggY1yXZX3GvSMNl4
         d8Nw==
X-Forwarded-Encrypted: i=1; AJvYcCWhmrnZEbsNNpNmKHdNg7AbE7r6rVfggiwCHKN9NLlD/Q2Z7dPLqEjNxN/OuUCIU7mOsr00OVa9aw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yys09oeSHy+p/qiBWpGDPI4gOCkcsJUvjOIKhljbZdevjVrg2M+
	WiAvzgmzI46R8z2Pq2b8eDRfI/2L1a9eAMHDpNcufwHuy0QAFqDu
X-Gm-Gg: ASbGnctEkwbINVUdPO6Eo8RsApmZLwJit/qlUCB3BCeomXSUi+PX0bsfn16BMel5tfz
	fcsP/8R36JjEGamozmuErNx1ivLGMIG1uDUoD/KZl9hGjenECLEhU7A9FsC8xmMYzf9Jzhf7b1l
	SCAZ32n/4bsW8jde/BWDKg+TgOXnsxVx2CG4XU+Lxdu4fJwEYw7VYMgRVVknfwoQwEGtXM9Ubxp
	jY+iha2+qVIzNJjTvYutiLKk5xoaQByzAlPYCY7ypXoSfsn/72LQo3qK7y+coEH88jJ+IG49Kt5
	zH9v
X-Google-Smtp-Source: AGHT+IHUZ87TmoAr0o8SrgXTRrH4jWo6maM2h2b17u2DM0wM2s6oJ69y0WbNvzCTtEHbkTI2EEvTuA==
X-Received: by 2002:a05:6000:2c2:b0:385:e8ff:b9c9 with SMTP id ffacd0b85a97d-38bf57a9599mr17221052f8f.42.1737592253502;
        Wed, 22 Jan 2025 16:30:53 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf322236csm17838004f8f.39.2025.01.22.16.30.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 16:30:53 -0800 (PST)
Message-ID: <ce08e62b-0439-4968-8b1e-510c8bacbf3a@gmail.com>
Date: Thu, 23 Jan 2025 00:31:26 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
To: Askar Safin <safinaskar@zohomail.com>
Cc: axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
 josh <josh@joshtriplett.org>, krisman <krisman@suse.de>
References: <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
 <20250118223309.3930747-1-safinaskar@zohomail.com>
 <9ee30fc7-0329-4a69-b686-3131ce323c97@gmail.com>
 <194906b5253.5821bf1b68241.219025268281574714@zohomail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <194906b5253.5821bf1b68241.219025268281574714@zohomail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/22/25 23:49, Askar Safin wrote:
>   ---- On Sun, 19 Jan 2025 07:03:51 +0400  Pavel Begunkov  wrote ---
>   > I also wonder, if copying the page table is a performance problem, why
>   > CLONE_VM + exec is not an option?
> 
> Do you mean CLONE_VFORK? Anyway, CLONE_VM surprisingly turns out

No, vfork is troublesome. What I mean is a task that shares
the page table, or in other words a vfork that doesn't block
and has a dedicated stack.

> to be a good solution. So thank you!
> 
> There is a bug in libc or in Linux: https://sourceware.org/bugzilla/show_bug.cgi?id=32565 .
> 
> I suspect this is actually a Linux bug.
> 
> After receiving your letter I decided to try CLONE_VM. And it works!
> There is no bug in CLONE_VM version! You can see more details here:
> https://www.openwall.com/lists/musl/2025/01/22/1

I haven't looked at the bug, but IIUC fundamentally posix_spawn()
does the same thing, and if so it's likely that any problem you
have with posix_spawn() could be triggered for your hand crafted
version.

-- 
Pavel Begunkov


