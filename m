Return-Path: <io-uring+bounces-4941-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8314B9D5289
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 19:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DF21280E83
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 18:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99BA21C8FC8;
	Thu, 21 Nov 2024 18:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SKtjep3O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFA81C5799;
	Thu, 21 Nov 2024 18:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732213804; cv=none; b=T/MNTfyx5lJy0B4gVSEaA4pVYu0Ln+P4btuGHK0Tnn+CCMZDUBX61huSuNTneVF73mRfL/FAu7vUntwPwmDDGejxqRD2q6xweM70vOW3MUBN3AEnvzbKUMsqeN1TWXdpE910GByJdZxuY0MKNGGXD7wZn17k3KolCkRhH58Htus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732213804; c=relaxed/simple;
	bh=fzBMHyBPmOcnPSKvdX8ScUW0W9JnhS02LVLMWZ4aCts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MAvhYG739rTjnTJp4WGJz71QhAgVqWPro4M4UYJeP460GbxAWcfTMOEaG4AdTyHuDYSHMiwsozULey7uUHwSVgavxGJCL/XZS0yY2xjIm9kSCb6Xayw6+XxQdRdAoz78KPeSFjFrWPmzREmE3BRHvLtbOD/XslKHb+26ee38TZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SKtjep3O; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20cdb889222so12559735ad.3;
        Thu, 21 Nov 2024 10:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732213802; x=1732818602; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YhmbgbKDuSc1xVxpykJYeJe5ug61FuTdvle5K3IjcWg=;
        b=SKtjep3OY7MBgJXRexqKQmpg+7X5jyTbhqGa6StEGCmIt4fC8UwER8Gpe8hyWYqtOZ
         63U+BwFUcjZbamJDoy3BWhQpCpeDNAydWl5sCOvUW/bsqwA3xQds94zHzhAdXYacuqTt
         JhLyNS27KM0XjDZhB4eAYLzgh2Tp5RIOQ3FM5p5yYiucFOv3m+f3B7M+Pzy+XroIBRyx
         WO/0I5aqsDzrSfkCEOGp7DqVcaHWD++KE1+HLJ+UtLO3L3s8m+bZDfVOi5+8KEnRqCBi
         91x1aAoHrGMm6h4fq7tlj3K6+2yZaza9O06CMCH7RH+s349uvEKHlrtgH33I9Re0PC0K
         8ZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732213802; x=1732818602;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YhmbgbKDuSc1xVxpykJYeJe5ug61FuTdvle5K3IjcWg=;
        b=Wu8MwWi/0JdAEjTXZqyFlVmG3Z8kOcM1GDl0ZUwEFixB33hnJfw2Y6YucXZnuLPhK8
         Znlmj/jOD8yh4zqwxmIULIuSA8uaAd2jzSFjb5ZI2Jo/YPfgM/3Xs5T1x4n1ylR65yK8
         l6VS6CB2LHS7mGGdDENgGg43+1pEJry6MdaEczIU/chzrVLXP/OrURrcn9AfPLLfHWy9
         ninmtVSICE9BNKyB3Ima7y1FE1GSKxO88ew68HH9bg5kYTwoO71IS1hT1G7D6uUwSJ2s
         d/arHGSr0F2349RP6/sByG8dCHdRtVN4JGnLi13DXEJp2KfcQ8Wd82cgEbn3EKXK5IYx
         I9QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVhme4z0Km7HUEM98jsGtSvEpoovpgXf0LAbFNWCUkNxZnAyBF6U7TgA8zboWp4vP8Q8xiR/yF7Bxw+w==@vger.kernel.org, AJvYcCX19+kv/+bPEXpkhdzsGwljZEcd0tuyAULowtl6tGt9nzSQL9YRDuS11biYuRLNEHpqTJJkLQGrAg==@vger.kernel.org, AJvYcCX5Bnsmxgi9ztP3BIg1ksJDRVwIn/9wgTcDfb0UXvbOuUIlQNYrc/7MfWZ1nxgJc5F76sQWpDJaZ45aH2SE@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3yNUEeHzDXouvzKWOlShjd6fOjg+yCRHsJoQ7fcQeszWo4tk8
	9Z63MoKXzgSveEjfWtitd5KTX81gWB+l+tj32IGKMyXdbUXQwxPS
X-Gm-Gg: ASbGnctHcyxhkjV+0qJ3OwqrmKAz1QxnOgjkpDkc7Gcoj6WejqgCy8U4h0Nsgh9j2g/
	5NinQ8OVoHbl4Hb4LFsKRrjz0nHrK5pIG8AH0sFo0M+ErwGoKUzWOVQid8kykJ0K3MWK9KLiQGs
	fDFX9nXZAwPv9hUBe7+S8p9/RsxJV5eNwHE/64MWJKF8sxPmdI266A6WL3IQwI91VjP5yrZ95x5
	K4FZ+u+D+rMMPZvOaHXFEbuvCvkPTaAmMizMhhf3m/vP2IfdjwasVFvv96BZlo=
X-Google-Smtp-Source: AGHT+IHs0C5RMruMnzg4VLJfmLHCfX9KqLLttit2qp3jnsKRaWQ2sRHsg4Ye0SOzyMU+ihT6ZLzkaA==
X-Received: by 2002:a17:903:22ca:b0:20b:ce30:878d with SMTP id d9443c01a7336-2129f426cecmr49455ad.23.1732213801735;
        Thu, 21 Nov 2024 10:30:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dc2aad7sm1310415ad.279.2024.11.21.10.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 10:30:01 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Nov 2024 10:30:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
Message-ID: <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
 <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
 <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
 <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org>

On Thu, Nov 21, 2024 at 09:23:28AM -0800, Christoph Lameter (Ampere) wrote:
> On Thu, 21 Nov 2024, Geert Uytterhoeven wrote:
> 
> > Linux has supported m68k since last century.
> 
> Yeah I fondly remember the 80s where 68K systems were always out of reach
> for me to have. The dream system that I never could get my hands on. The
> creme de la creme du jour. I just had to be content with the 6800 and
> 6502 processors. Then IBM started the sick road down the 8088, 8086
> that led from crap to more crap. Sigh.
> 
> > Any new such assumptions are fixed quickly (at least in the kernel).
> > If you need a specific alignment, make sure to use __aligned and/or
> > appropriate padding in structures.
> > And yes, the compiler knows, and provides __alignof__.
> >
> > > How do you deal with torn reads/writes in such a scenario? Is this UP
> > > only?
> >
> > Linux does not support (rate) SMP m68k machines.
> 
> Ah. Ok that explains it.
> 
> Do we really need to maintain support for a platform that has been
> obsolete for decade and does not even support SMP?

Since this keeps coming up, I think there is a much more important
question to ask:

Do we really need to continue supporting nommu machines ? Is anyone
but me even boot testing those ?

Guenter

