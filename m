Return-Path: <io-uring+bounces-10505-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB29C494FA
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 21:53:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83F743A9D5B
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 20:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87EDD2F361F;
	Mon, 10 Nov 2025 20:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qd6VFs3T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB74221F03
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 20:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762807998; cv=none; b=qkyG9Qs0cFGcoJL38ezYtCd5HK8Y+dj0epUVeJMIxm/5zuGPm/xldcNauD10o9a5MW6OIGpN47umU8evfbV3TdM4xadxjRzboFii+CMArBlJyiPCMRAiHaJobvhZvbmC9mHJXTpAkgOxtPWr+2++AK2kHYVZJKvq+r5x/Snh+To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762807998; c=relaxed/simple;
	bh=JX9r00UWOioSGgY9OIngH/ryyDZlP1m8Vn4QG2kc5H4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M+m6GQeGn1WVBHdDaeZ0FG5bSEg6oRx07Dqr/c7J+xEyRSD6Wz8ZYLEudTiMcsA8dzOqgDgY9LiaU2JNBvFopqV9nDajHePNugGL+/MzmAIzvMHigV4hm4x0DCz7Nwstp1roU4wKXdH7A6BhVFtrwIMJJkV/lY2s8reodntB7UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qd6VFs3T; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b3c2c748bc8so441700166b.2
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 12:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762807994; x=1763412794; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Rf8vYmew6sPCWLS1uooTayzzz1zVmg4FNt5aKYULseU=;
        b=Qd6VFs3TxvI6RAwtYs1ZVMlo5MqNXGKafCSimE+UL3lr4j56Gi4npaf7LaXJUGAWnw
         pGBGsZve2wZXQOaZSuGnrhaUx5tYqmDUBFXAcGxHRl0FCTUUh033Z2FUEDhWV+84miF6
         UYLGXhWMlWsqER47+T8lKOStAJhHjq/QQRUhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762807994; x=1763412794;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rf8vYmew6sPCWLS1uooTayzzz1zVmg4FNt5aKYULseU=;
        b=Vmsd4vBo/FjgQEz89p0YjYg+i4oed5OQfz1DAQMJ4Jp5Jpl4EhjXOpmd/FkPM0ew2b
         O2R6EDE6cNYYTJJ7It9I/n9KN7CL7gb8bS1tEzltz8TN+SY2wQRmg7S/P/RanoRV3hmE
         93TaZAimvr0JbA8X1ZxOGFahe1U9PMii6rU9mNcD7eApKP06frVkLqbkyviFmi6mhI3u
         /HbGjaZNTDNQMe1vxSq3QHWEhxT6ZPGCdvBYY4Y9F5LtMEGVdZER7xxdY2MF3iC4iQe8
         yloP+HNcEcQTCUOiWl6Smzt5NvtdtYA/tgbzMBCcf2/7zGrRBKiGiwYoKUTCK+HYxtP4
         vX7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUyxsPLmmzR+MAD9BOZZxsBxiywmw/PzSL56IXdIOT9e76xhiLEontDkhA5+6/fbDy6v4r/f/eQMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMXFuK7n69A1+E/M95qXuCY2blRP4elrYuPJVLkD92M0/86/im
	u7zcIOwRi49PLdbnF5tscA1lYWPYKTeHzaE57hlGltFqnX/SX0P1Ys82froxLRCuFE40EPVz35z
	K5lGl+e8=
X-Gm-Gg: ASbGncumxBInK7OxfcazIYl9bfHhQwGiiaEKBJx2EIZK4OVVvQMgIbp601GUh1LmUlE
	eHDTV7xyIT6ZwfhQdjCjmyZtyiSspH5nGjKfrcbhwxuEjQplKlq3bbzP8eg3rCPl0cuZXuIVEDL
	DRul+ZcZYSf5kqNgEN19CmU0DXe1t/HzlRC/yvnQ8Gs2nLjvzyjaLkwSBOAPDrpcuFgPEMcWz74
	ESMpRiVTnNQDXQ+Wi0NjxMUiDj2J62PXw7qb+RnnE/eQ1gOtQLrGdahV9ed+7rxOJbwQrcq3LJ0
	AngakQzR10zf6v4TOGUnBDiRGN3TxC8hiYPemBY8KfQYlJCjUtgIBCyUwmH12n8Rv/BbeQHReOI
	HN0cEXqesm5tg8L4D6fbpVsD0fEkOcsJ+PZlx9/fOI6Rk3E/S7Idu/3tpJEEvcMuxU3bERYckan
	/Jr942zIvIqmxmouXoZKkgikcc8x8Va9PkkCvHIscPA5BQSSpIWd6ozkwIcVcv
X-Google-Smtp-Source: AGHT+IF74ntf3Ot1WQp8gzZaVkmYtKc3VPhgkHrNimlsBWWb0xBHnxY/oaZ4S/pL0hw06TeyV7e8Sw==
X-Received: by 2002:a17:907:7246:b0:b72:aab5:930e with SMTP id a640c23a62f3a-b72e030953amr1085943266b.16.1762807994467;
        Mon, 10 Nov 2025 12:53:14 -0800 (PST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bfa2510esm1162135666b.72.2025.11.10.12.53.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 12:53:13 -0800 (PST)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so5129054a12.3
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 12:53:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVguhlNtwZYqv5bsFqwJO/3CxIlHYTAXQm4mu+zXVi2IS5CAP/ASXbZbeswQkMewvuSAWqy2hvA/w==@vger.kernel.org
X-Received: by 2002:a17:907:7b96:b0:b40:fba8:4491 with SMTP id
 a640c23a62f3a-b72e0310d6fmr1100087666b.17.1762807993264; Mon, 10 Nov 2025
 12:53:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
 <20251110051748.GJ2441659@ZenIV> <CAHk-=wgBewVovNTK4=O=HNbCZSQZgQMsFjBTq6bNFW2FZJcxnQ@mail.gmail.com>
 <20251110195833.GN2441659@ZenIV>
In-Reply-To: <20251110195833.GN2441659@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Nov 2025 12:52:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi3vpw5W6rV6VKxa9PYF3Xwn5_6AT=OwqBWO79g6N1B_A@mail.gmail.com>
X-Gm-Features: AWmQ_blj7UCkHVNWD8MxILQgPkvzV6LzxIw6bD27yUdHSxmjHA7zzLofljDreO4
Message-ID: <CAHk-=wi3vpw5W6rV6VKxa9PYF3Xwn5_6AT=OwqBWO79g6N1B_A@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 10 Nov 2025 at 11:58, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> If we go that way, do you see any problems with treating
> osf_{ufs,cdfs}_mount() in the same manner?  Yes, these are pathnames,

Hmm. In those cases, the ENAMETOOLONG thing actually does make sense -
exactly because they are pathnames.

So I think that in those two places using getname() is fairly natural
and gets us the natural error handling too. No?

              Linus

