Return-Path: <io-uring+bounces-1135-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A52087F560
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 03:21:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19D98B22003
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 02:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927FE2F22;
	Tue, 19 Mar 2024 02:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lqlk7u6r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45BE657B7
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 02:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710814862; cv=none; b=hzMWohaZzMynqVkK8bKN5MdUn+GE5Xla5Yxf4ElyADEnqVwl1PMNUAz8AmbCL8n6tCtGP/jqYwD/LT+wvgLNPkrITglZ6BlRnCfQiBEmrWzRi5Jv1ElkebxTvoG+5Hn9K7PRjqf4Mb6sgILzP7e+7FejLzoY6zYgdBRDNn53xDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710814862; c=relaxed/simple;
	bh=RJMCoG+gNuaOQ/fHtjYkyFp6NW0NPbP9NY+sEji0LPU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=haidoJeRoe89G9O6pIMVG5hfnBzAFOw4gx8U0yZWPjgKjNEKqLR+uJ38mxMhsgglONz8a3MOgitl8gqBRUAThV31Hrnrm4jQRF/n8LMVoKpkyuqt+drlKNhwj5AZBTYGcwUJoxS5Tv2L8OccrKBk6Ca8SZRRYn6JwXnRjI51B6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lqlk7u6r; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-29c572d4b84so1711480a91.1
        for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 19:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710814860; x=1711419660; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2UTfysRerY+K+DNhqJUvMtMt7ExbS6u+xCls7XQC8Mc=;
        b=lqlk7u6r6dRWfcJ+M1qq0ZftyIvBWqk0WgYJVQemHXtMMzcWjYiDYDV44u7J+gBux1
         sr3juwa+kPMM/m+/XsY1RgnA9X0YJjRe6HqcFct+/kQBFvQroanSA24Ktyelpb5g6y1S
         yTsjdsZTmTQ4xsPgumbhAYGIZlU0VzjP/QJrIvPJyt4oe7l6OjLfIu4egPw5PhwoB1LR
         B7+h+IybEJjHVfWN/jBVyRzBgMxoZ7w+iV/oJ0AylOhAa/rUAqOBZBa+gk4x2/1WuuDU
         MOE1OLw2zUx7RbVo0J5YwgMSBiXqSDFy01S36xFwYwDNMe8rqyWHHA+blp6qmlPRh2a8
         qvLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710814860; x=1711419660;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2UTfysRerY+K+DNhqJUvMtMt7ExbS6u+xCls7XQC8Mc=;
        b=vZ3JBJB+63OC1LAFXH+Th5j4VEcaNMAZhrc1uGeaAhCcZRj6RWnQ4RENjauUKhTAlj
         Pvm8xj0JA1T3VEC+NW/DH4NExGRwyrH0LMg9FyCw5F+Q44ZKxZwnAaDsefkEQgoKG4f9
         a6bF+J9va8rSyzFM21HNYK6u8b24C+KN3aZR6jILx/xvYebwEFe2GsZlg/2Kivoyxajg
         5lLFI+4sJJ+ZKhum7j/efj2NWJv0NKakKhrPrrWIIfF6aiVqc0zD8wGkrDJR9MIlwb/C
         auHNiRdzK7GDjhisMorPMManSFy0eEbmpqftTSCsuroQ9/1GeVDAU8Yatstt0qhO+mnA
         IxNw==
X-Forwarded-Encrypted: i=1; AJvYcCVzdThA3XyMSIoLwnHAG1kP17H4SX9/kAw0VP7EWm8Pk+o+MxFGECiAaBu5+pY4MDOFJmNjhvxRHh+snNjrgPB03gUG77fS0Uw=
X-Gm-Message-State: AOJu0Yxb6ct1kCMLe285OtgTbLJPjl1ApsE/6/rpezgLkDklWEYE0YuE
	LPR5l6UNEnHZyP68zgfHar421xcFIrSY2deEKgmTnwFcsQVSTFWptSQZ+2euWXi5kxXE5oRwJhw
	w
X-Google-Smtp-Source: AGHT+IHo9nXoCDXp4LvQz5T/ZTk0dJ6XXWHITOS+gwbbfUncxJHwywMIrB8KXWTw3apUVNaSs9bi1w==
X-Received: by 2002:a05:6a00:4f8c:b0:6e7:2e3f:846f with SMTP id ld12-20020a056a004f8c00b006e72e3f846fmr1086518pfb.1.1710814859992;
        Mon, 18 Mar 2024 19:20:59 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id ks1-20020a056a004b8100b006e6cc458206sm8814226pfb.175.2024.03.18.19.20.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 19:20:59 -0700 (PDT)
Message-ID: <0a44c466-7a0c-4959-8c21-57249a87de05@kernel.dk>
Date: Mon, 18 Mar 2024 20:20:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] Kernel panic - not syncing: Fatal hardware error!
Content-Language: en-US
To: Changhui Zhong <czhong@redhat.com>, io-uring@vger.kernel.org
References: <CAGVVp+WOLnr9Hxd10Xwa8YpJ=W5Re9csPCMtNF8Ux0_zbg0ktA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAGVVp+WOLnr9Hxd10Xwa8YpJ=W5Re9csPCMtNF8Ux0_zbg0ktA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/18/24 3:50 AM, Changhui Zhong wrote:
> Hello,
> 
> found a kernel panic issue after add io_uring parameters to kernel
> cmdline and then reboot,
> please help check,
> 
> repo:https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> branch: master
> commit HEAD:f6cef5f8c37f58a3bc95b3754c3ae98e086631ca
> 
> grubby --args='io_uring.enable=y' --update-kernel=/boot/vmlinuz-6.8.0+
> grubby --args='sysctl.kernel.io_uring_disabled=0'
> --update-kernel=/boot/vmlinuz-6.8.0+
> reboot

Pretty dubious on that, should have no bearing or impact on that at
all. Does the same sha boot just fine multiple times without the
added parameters?

-- 
Jens Axboe



