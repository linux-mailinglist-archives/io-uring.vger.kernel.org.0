Return-Path: <io-uring+bounces-5212-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D07F69E4276
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:55:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B3D7284169
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02844212B0B;
	Wed,  4 Dec 2024 17:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HSMKow+V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203482391B5
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332500; cv=none; b=HWSzCCcypXpiZlby0e6c4VaDyf+EnUPi3rADG0111vmZcEjAbwoKWR3rfIXOIGX1iMMwbmm0fsz2fNdImBAN51bk4fqvAI/dxwLac8rvNCqmiGsr3cqaYy7APPCSj/UBNmdH5pNTYix7e9A4bFccd4V040wb9u+9F0goXz/UuiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332500; c=relaxed/simple;
	bh=oRh+4j/GgOIJhFfck3kU0IcbRnoakstTGeiTJ014bCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KHWdbcCwJAd21eRL0Zw0UlUyzXwMxpQ3nGgYXmQ4pYGeiAB5hTJyzhEn4zASvkA0ZjabapQaAYY2YjMKUoDEmPhs2s4ejFL9ss9FhF5Vxyqx0GDhDZej+K92gm6+xJ6ImhfTH0BEKguaBuW6/OsU5DdYN22EAXypiYLZnDNBUEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HSMKow+V; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-85b0a934a17so547675241.1
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1733332498; x=1733937298; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dzk90c0GQxgRHOCsDrxKEl9Uy8NC4dJyzqrN7VeRC2w=;
        b=HSMKow+VRuhwxyWb237D/46BOIL2/UcOQcdXw3Z7gXtbuoFXzXAYIcSAwKvxjyeIWG
         qjr5TAmFh3DDBaVlXg4Z6vFZo+fuCxj8jC+YVOBnEYz84pW0jlXC97DcZBQp1H9b/xBp
         ydJf7CMoU1IL6X3bz4l8BAN5FtnDjvLdaYCXtVZA8ZygFCv3UGdxRIF7QuZqmhfMoXPI
         fLemiUu82b3OY6yWh/45I/9xXcPUsnYEXZppZMGT00aWa2KibpnU6S8nJWq1jZvrxgnd
         iCXaeFIen6NyULS3QphAkr7uuKQ1TO2pH1jDIQdw8rB7wfJlP4DLHhDNta3nHO1cAFQH
         vz9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332498; x=1733937298;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dzk90c0GQxgRHOCsDrxKEl9Uy8NC4dJyzqrN7VeRC2w=;
        b=YDT7ZtFULnIyfd56Kw/feQro95GE9bf0CHw+AQrwFifrM++3zGqGxoTdH2Nz/rZU5J
         9QpNGDQ1pfmhlue5uHLyVz8h+3/zCeOmwlIIHaccZr4A78d9nQKq25VIi+oKWS83eAVN
         L2YUo3oN8NOf/WZoDr6B1Tq4cxq932ILKfBjrRwd+bOT0urzi7RFLkePuG+qmsQDP1Hr
         5CPY0zWwC7d9M+AKy+4fr9HJyqIixfGt+4iKQ+eKwKjqsAoORDjyABRMYqIikmRcf5Gy
         EMtXojwndU6r6TEjiLr4QMYQpeW/XdjQ9r4sU+bG7UAoaKSmYXY2b6B/OEn0nKaHhUXV
         O0pA==
X-Forwarded-Encrypted: i=1; AJvYcCU/SyLQdKm7lAZJ5Cdl9A7v8FYDOmGWcV+X2P6ze8qDHb+jUGBUxg954l1763P9S8wtPeKayuuhJA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwdRe2q1SN+LxWjPAw3FrrvLEMzRvdOaVSbL/OBw6M+v61tcU7N
	VtLqpxCsaF3+smT+aXdz++VHdvxpWuvgqse8XbOWlVBSdpbwYNGE466KC0Yoce8wW0g6bIrCr+t
	7
X-Gm-Gg: ASbGnctp9oWe9XQicl1xI4NLNJd7fGCNn4epeOUtTaFvotCskPEQHCPQtslLb59fCEh
	hImSRtLzOBhmSFwuCo0M1M4ZFzDR1ucsfPrAtwkKOQsXIE9gW00lKfcl5R30pdxXP/0XctbTBEy
	4XBXzfdu0fewj7PLMNWFmPDX//2dHtgXsxpvhJtWGu9IVu7N+gQ28mwtIbDuiGs2wvw6kBHuq/D
	OWBLTe/ZKZTvx58rWMwmUOdnnarQpRK6o1JxtOr8XYa38ZKqPMKP7xlsw==
X-Google-Smtp-Source: AGHT+IHBt5UzfAv+PxR3SAoeVjIi3Nv045+sXhtCM1sXI+ESypaB+D6z7xn3nscOvrxNGu+pH9IrHg==
X-Received: by 2002:a17:903:22c9:b0:215:58be:3350 with SMTP id d9443c01a7336-215f3c69d29mr2273995ad.8.1733332485916;
        Wed, 04 Dec 2024 09:14:45 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:a7a9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215714b4f77sm68395025ad.202.2024.12.04.09.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 09:14:45 -0800 (PST)
Message-ID: <9e8ccb61-e77a-4354-a848-81242625658c@kernel.dk>
Date: Wed, 4 Dec 2024 10:14:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] general protection fault in
 io_sqe_buffer_register
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <67253504.050a0220.3c8d68.08e1.GAE@google.com>
 <67272d83.050a0220.35b515.0198.GAE@google.com>
 <1ce3a220-7f68-4a68-a76c-b37fdf9bfc70@kernel.dk>
 <CANp29Y5U3oMc3jYkxmnfd_9YYvWK3TwUhAbhA111k57AYRLd+A@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANp29Y5U3oMc3jYkxmnfd_9YYvWK3TwUhAbhA111k57AYRLd+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/4/24 10:11 AM, Aleksandr Nogikh wrote:
> Hi Jens,
> 
> Just in case:
> 
> Syzbot reported this commit as the result of the cause (bug origin)
> bisection, not as the commit after which the problem was gone. So
> (unless it actually is a fixing commit) reporting it back via #syz fix
> is not correct.

The commit got fixed, and hence there isn't a good way to convey this
to syzbot as far as I can tell. Just marking the updated one as the
fixer seems to be the best/closest option.

Other option is to mark it as invalid, but that also doesn't seem right.

I'm fine doing whatever to get issues like this closed, but it's not
an uncommon thing to have a buggy commit that's not upstream yet be
fixed up and hence not have the issue anymore.

-- 
Jens Axboe


