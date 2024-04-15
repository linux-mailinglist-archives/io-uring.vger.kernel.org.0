Return-Path: <io-uring+bounces-1554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7D68A55C3
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 16:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29A691F22DC5
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 14:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46122757FC;
	Mon, 15 Apr 2024 14:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gLTvyBIq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B8314265;
	Mon, 15 Apr 2024 14:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713193052; cv=none; b=caUR1kGq0iWSYEyCUNRCkVAkzWNXdR8ai1jXlX1ZxNtka0lPX95uHSS0hjs1vGapyfcdv3sC+RLThAMxdv+H+L1HGYL78su/LL6T3mrcowg0nKrOudxoUAuNeBYPG5Qrg+qBhFFxdTW5JxFpBlp0l42eAhj4EOvnmX+ufBkLp+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713193052; c=relaxed/simple;
	bh=it8vL95SeO1Kze2kPrYp/vf3C/bUFowyLoc95jrBu04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ka4h18IZc3Ge8e24k+44TuCy4d/BEkrUaDXJX9+cqFDaJz8YqcqjFetu+KUu2C+6zvyBV0eFwTSJ9av9N69vq4sI0URGucQC6CTPwhzggGdY/gRcePMbn6YxV76f44IKpGkot6N7GXSiAEa8q1sUG/59AoYoXpAHnVUnQ76Y4Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gLTvyBIq; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-418671bac0aso4604165e9.1;
        Mon, 15 Apr 2024 07:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713193049; x=1713797849; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n6XiDaUHJc2KqHPIUYapgvvVLyg/91OK3jfwQB5JqD8=;
        b=gLTvyBIq3Xb2e/3D5HpmRV9bTZBxU9pOvDXKDpG+exxpUHBEBctszPoHqseEIr18pI
         xdBDka4Lg8PmuHG45nIqGsOcX1Vr7kwCTKX8M25FKltOWy26RlLtITos8Yovk99oyAaZ
         5wkgOhAetHtAq362kFbJpSFv9DHTYXHByUKK6wAq9jOJ6nxmnNBsW7oiO7qH9MD14Ess
         nM4HQRLxlvclhqr+JIWC0tYLEIASGCR2XDBiF/wbjAOMPxR//wHNkFhlIAvzjv6OSK4c
         0NG3E3tJEg0D3dGlNmat/m4XRH6Is3JIbShWcQWve4MDPcMJ9TAmHU4yC1eWI1Kwqhwd
         HEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713193049; x=1713797849;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n6XiDaUHJc2KqHPIUYapgvvVLyg/91OK3jfwQB5JqD8=;
        b=dZIjG1h40qHoKdSb1vowxkye82iAX6gZ7NndFRaDxqz3bPUdQ3r5iGwx2+gNcYbwpM
         5n5ewpovFErDGo52eXfYja+Vn6C3U13PXMguWftHtxBygfwu7yAKujQTyw79VB9UM2MQ
         RmKxrYXRlLsvmOnj7cM0h7zoDicutjT2nRZfkImzQhIuGO24XuUoKOS03GZ4cnOE2DUX
         k6m5qvwagtHPsQvxX880P7T1DQvsbQtUc8aJRhwiYLpC0wldKLsj3VcqYHw8lShXTbnI
         Q/U8PdU5ZUl/l/8dDUgX+DbN8OmXxWNVW+35CRQTuJPefNTzH6P5WcfK9DexU2G5YoKr
         Z8pw==
X-Forwarded-Encrypted: i=1; AJvYcCW1DyIlvQFrfORW4olUlJRnJWz0JFCn7psT57gWw1U5h+IuTckboRVn2jZ6tw+5UIX2lKFBxQs/38K3lnfOANU0lUkhnCC5Qp5pFFqY0qnH/g0hWIRHJ3MuWY99blGq51x3EOEv78dmrbXKhVWanHEXvGmLyfgBLpKIwy/LX7JwRth5zC3B
X-Gm-Message-State: AOJu0YxqlemfQ86txLSeDJdrupPbA8ZPVCcj/XLOATiuIMtXcpZhTUZF
	8OlbaIXnIhEIsNWXTqazMqkoADCyjSc4+MTkwZZzFY7yxcdrG8GR
X-Google-Smtp-Source: AGHT+IGTqgGcDxnillobZL+k23P7Mv6jGmBPtXSM+MvlpKvc7MbGFzp1V2apgyhUcEcUgPNQcHYDgg==
X-Received: by 2002:a05:600c:3148:b0:418:4303:65e5 with SMTP id h8-20020a05600c314800b00418430365e5mr3595304wmo.38.1713193048803;
        Mon, 15 Apr 2024 07:57:28 -0700 (PDT)
Received: from [192.168.42.203] (82-132-213-93.dab.02.net. [82.132.213.93])
        by smtp.gmail.com with ESMTPSA id bi27-20020a05600c3d9b00b004187c57e161sm1377859wmb.0.2024.04.15.07.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 07:57:28 -0700 (PDT)
Message-ID: <d019fca3-0dc5-4569-847f-13800519fdc1@gmail.com>
Date: Mon, 15 Apr 2024 15:57:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [fs?] [io-uring?] general protection fault in
 __ep_remove
To: Jens Axboe <axboe@kernel.dk>,
 syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, io-uring@vger.kernel.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <0000000000002d631f0615918f1e@google.com>
 <a81c7a79-44ce-44fb-8b33-4753d491bcec@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a81c7a79-44ce-44fb-8b33-4753d491bcec@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/15/24 15:31, Jens Axboe wrote:
> This isn't related to io_uring at all, not sure why syzbot has this idea
> that anything that involves task_work is iouring.

The repro does send an IORING_OP_READ, but I haven't looked deeper
to say if it's anything meaningful.


> #syz set subsystems: fs
> 

-- 
Pavel Begunkov

