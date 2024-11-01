Return-Path: <io-uring+bounces-4302-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CD39B92CC
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 15:06:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 522581F22EFF
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 14:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C77817C7BD;
	Fri,  1 Nov 2024 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VS609FzX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FA5168DA
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 14:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730470011; cv=none; b=Bw37tsKGHI1irG1hPIaDSHhyU5Xg7Nc3sqE2l3EOCM6HT6r1qKQ3u/mYkwWvSbvwe8oLVEbvnyG5Zpgli6LR71pV8EV+BaQ0Dpb5mWN5CE4Z8uxwU1gYfRIa5C+panOIJ/pg/vJAtyLnioBoRvIb/J4CPr9ErJJZArRH5meEqs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730470011; c=relaxed/simple;
	bh=9LQJ4wXLQ6cVARl7oC8LrR0Q3kNk4H04I5XhPBBRE0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AWnScCSzJqr1oXg32rHpQJyd9jmevY72W/gvNuDwcjchImTXPSdQ9LdWMShc2alyZSJY81lyXxVpcy9/2tXqkJPG1vqhi5a6CCvBnLQC4Bu1DzDayNQ7Ro8T/HOZbHhI8Bobz7Fqp3GvwZUSMfgAMfNklnpQCuOfAXaioSInAjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VS609FzX; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2e2b549799eso1535435a91.3
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 07:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730470009; x=1731074809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bVcbhRmhKCemj4U6MSE4gRuucOO//csTNTbnt0iLHS8=;
        b=VS609FzXnsJ7hRrkvFyv436veQDZ8/tsJFBYZu2wZttezmvWMh6faMsPK/J0mmZKwZ
         mN+My5XcYc3Bv9/ttCrXVQUWrEOmyXJJUbowHH0GrMHw47g2JMhDWdKhiJ7DCSAaQAs6
         554XnuVlzT7UN/TyOh7vNFI9rrrdtuAQxSaNQ8n8DK9/D7GO2OvyGEJdcHs+1cYjUPV8
         q3Lvjla7SCsQHiMLEO9D0v+iV/WEx4r2a1GbOpC5SKEe7KZoiYLXtcSPQzLQCyFabuEY
         OhwqodLAMFmteDW1sF+7oW7IjZD+RAW731Z9qrWSQFMq2eTgfmoVDCBjTIhn4qt4OA67
         8Tcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730470009; x=1731074809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bVcbhRmhKCemj4U6MSE4gRuucOO//csTNTbnt0iLHS8=;
        b=rfjoRE4ElYQEbFJG+z+RP7CycFWTUGDaCZO4VbMpZh2JYPkqmAiVFxQpG6aYm57lTR
         cYqfhRq1n9IFOLM7pKuAHVfvYAi8l7wTLU3Xi3HFEAkhWfaY0CLzr0B9H84gNQh0TFYK
         BEfOABmfjy2rlcBWQMb8WCLflGDkBhSkN3eSw378lFocW1HylHxRF+uVlN/nbw1RbTQY
         5dEdDn+3ghO7OJnxWtD8t2ab74NfVHnvDS6vS8pIIIA88ugEyNCABLVPLbte57IXwV2T
         QZpg9+BDAb4ii+KpngIvEaO+V+fNooNyT4KvaaKdLnielYtFzJ5jxl+rFlDXi4b9zV50
         lCHw==
X-Gm-Message-State: AOJu0YwUfFvpoeo6XnVQDOtM+L5cXbpQAePcM4g7drkwX2LrhgYQ7pPx
	MRhMWTVtei0WSROWLcDlqr/Qv4x3kScqiPQ+5vns2gco9M61gZdJJ+UVN/OdFd8=
X-Google-Smtp-Source: AGHT+IH83Y7D5tzgzoL8Skxu77Glh8axk07cgao+mR/QcJ3UP9depKKR7FBKRICMJGK2P/DAcw86tA==
X-Received: by 2002:a17:90b:3886:b0:2e2:b281:536e with SMTP id 98e67ed59e1d1-2e94c2bddd7mr5033214a91.15.1730470008853;
        Fri, 01 Nov 2024 07:06:48 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa24ad2sm5011638a91.14.2024.11.01.07.06.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 07:06:48 -0700 (PDT)
Message-ID: <a9b7a578-cf47-474f-8714-297437b385cd@kernel.dk>
Date: Fri, 1 Nov 2024 08:06:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/1] io_uring: releasing CPU resources when polling
To: hexue <xue01.he@samsung.com>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241101091957.564220-1-xue01.he@samsung.com>
 <CGME20241101092009epcas5p117843070fa5edd377469f13af388fc06@epcas5p1.samsung.com>
 <20241101091957.564220-2-xue01.he@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241101091957.564220-2-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/1/24 3:19 AM, hexue wrote:
> A new hybrid poll is implemented on the io_uring layer. Once IO issued,
> it will not polling immediately, but block first and re-run before IO
> complete, then poll to reap IO. This poll function could be a suboptimal
> solution when running on a single thread, it offers the performance lower
> than regular polling but higher than IRQ, and CPU utilization is also lower
> than polling.

This looks much better now.

Do you have a patch for liburing to enable testing of hybrid polling
as well? Don't care about perf numbers for that, but it should get
exercised.

-- 
Jens Axboe


