Return-Path: <io-uring+bounces-4505-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6469BF133
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 16:08:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 334191F21EAF
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234412022EE;
	Wed,  6 Nov 2024 15:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NBOAWqv8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15122537FF
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730905684; cv=none; b=scLigQVz9UpFHAYk0sjdhrztGmZ4EYLohRoq+ajs4KUNEn3J5uWOEsBMjkju+YKY/qOEb7j2P3qDjemMI2/UEtZY1c1ua5DZOzSWpa3uCbTkWluhZGCafGBlHSreGOgm4mNY1wah748FS5tmlmGeuIHHnnEBT2lEsTndf1LYHNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730905684; c=relaxed/simple;
	bh=vdLAz1IinJz+0iRckOt1TyiyBF+HrXN7qNLkRIYqB5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n2TwFdv8M471GkFK7zJ+xBd/ZrfoflhSILtOKv5JnnsnUsWm2Oh/B/hqwi+P0WhvWnLykWPagF+6aMyxCFp+3aN3d1DlYQDrHQRvWP61Jv+JNIaYrXN6wrzd6HQycLKt0YodNLj37vUs9bsoj8UquutNCiW1rspUu+xGur55iSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NBOAWqv8; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-83abcfb9f37so274067639f.1
        for <io-uring@vger.kernel.org>; Wed, 06 Nov 2024 07:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730905681; x=1731510481; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dHsExB+1JzBfhLG8VKbByJMpSayH48lldkdC4B5gvfQ=;
        b=NBOAWqv8VvPq+7+7IeBWf0rHkdLN6UrZ6BCdYWzPUqAxH2P1jY9Hm1wDvX7arHLrh4
         LJNsVZNAu2do/LEvq5JgyuMy9xrWZbyULZ/IBNfNheCvM3NlYTkBHaZPhMzRE+hgpbQw
         yl0+dH30Xs2i1m2GU0+VI0HXG4PepW0lKnf17iW1MUtYvCZeGU5u1wj6OrCVCcXEKMn3
         aTMpTK/tA5hjWPKxd+n56LuTp2l2j/YSw++OEz0GGpZRQ9TrFu5lWegIE9XsjlTQF+Jg
         ag4qCK6om9e1epoF7IKcpago4PPyQMvd4WVSmPmf/Cl0kdhqV0v4lND8b6trxaeMXil8
         nxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730905681; x=1731510481;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dHsExB+1JzBfhLG8VKbByJMpSayH48lldkdC4B5gvfQ=;
        b=GhY5g0jORkaNmKTdB7KUPyLdriViKaDV2ys9aHgaVTBsf9mFpnXpOEhhRVWSAr5aGK
         NpqPttCqJ0z/V0jXU27Lp6a7Rt+NmYzL2Gojaq6ez8L3NhlkcEQ7coXxwefA33/vRW8k
         1qaVUnCDya9BHqUOeptXcFJ083RORqCvy94YS40TnQxD9aET1jiUunK1NkWRyRCl0hG6
         szv6R4Wko8fgp489fWusT176a8gZZqlr+vlGgMSf3Qx5NL2rQXUYXg9eydkt5AQESf5S
         Ew/gf0xjA/yX2P6xiKheq9JDNUXwYJa37lSEU+BRKbtwIyF+hHWUKTNiWmoR6WQxWhgv
         WQNA==
X-Forwarded-Encrypted: i=1; AJvYcCU4KcP4ix6XcPjGOHtDeDUGzgZornTvRsiMQjGz9HSC0mJ7sZ2/fS7bQ20jHqoKJbI13Kf2S9XlOg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVrIAYmKq7nLpMwmbNDG6U1rmMfSO9vCLY5/ydGr2QQcFoaA1K
	QmZsMvOX5cx/2ZLmP+Hegl3tEpbG2oYffp+CxPSJRvjfddGQumOpIbEaXgvFCzA=
X-Google-Smtp-Source: AGHT+IG6GdNxJPDRJCmGTOZeetX9a2jEZTw1EHq4ee/Atv0LYpYLmNOmWLhoyqaYUPjpZEKtGMLiFQ==
X-Received: by 2002:a05:6602:6420:b0:83a:c4e1:7d69 with SMTP id ca18e2360f4ac-83b1c3b78c2mr3998925939f.1.1730905681218;
        Wed, 06 Nov 2024 07:08:01 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b67ccb076sm314495739f.50.2024.11.06.07.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 07:08:00 -0800 (PST)
Message-ID: <0e9d2ee4-13dd-4890-97a7-eafd83b2b840@kernel.dk>
Date: Wed, 6 Nov 2024 08:07:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 2/7] io_uring: rename ubuf of io_mapped_buf as start
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241106122659.730712-1-ming.lei@redhat.com>
 <20241106122659.730712-3-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241106122659.730712-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/24 5:26 AM, Ming Lei wrote:
> ->ubuf of `io_mapped_buf` stores the start address of userspace fixed
> buffer. `io_mapped_buf` will be extended for covering kernel buffer,
> so rename ->ubuf as ->start.

Minor nit, but I'd probably rename it to 'addr' instead.

-- 
Jens Axboe


