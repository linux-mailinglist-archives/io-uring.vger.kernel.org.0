Return-Path: <io-uring+bounces-1877-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 262398C3295
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 18:49:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B6A7B213E1
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 16:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A2E18054;
	Sat, 11 May 2024 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yJ9AYnfw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14347F
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715446152; cv=none; b=ed5kjZU6aJAcszkXnMhJ8vhQjHKfQBnzBGQ+unfkrHDsLc3FERCKsMNuhQnuD3Qaus2HHzXX5K8wgrKeQi5+e8x5Zhq6pWzoS8vjdF4SA0fvkezX2y1O9hGSJZCvMtIt7Vcu2dTVEy6LvG70AlbG+v9yYg/jOF4Y9vu6C+IE3Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715446152; c=relaxed/simple;
	bh=AQfYYhhXT94CnQ5n1Dr2jiBbYxAUCDtPqFtXD7ETE1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ITYcItAMr5GxW4x0Ep8pc9Ej/ZPC+mCtH2s35zAbl2wxHitI65FIM38PDgQORx3HrwKdQ+fHt5+mzr08nqFOOKhdli2benu8VK3lAvQ4BpL+vNpMkc4mRpGbiaPTC0RLcLYpQ6OSDVqjuGxstI1ojzdZ7M+E3R9opJKGca+f3rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yJ9AYnfw; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2b516b36acfso787965a91.2
        for <io-uring@vger.kernel.org>; Sat, 11 May 2024 09:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715446150; x=1716050950; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oE5GY4dg8rCApE4xWDxgBDcp4FnAQBPmRCc+c6IQkz0=;
        b=yJ9AYnfwkXhbLPW1OdY5Jz2Zba4Lo2PObkI699kCcO3Le6z9OZ6e2lydZA4IO6g5SZ
         ZTQtJJmwWAPdWV1+mQC0WAhsvRqZC2nC9dFkPPdNJf4+rMub3CJ0drH0NViVEzjbe+8F
         WOI1aejUjWCVwbbwuqtjfq+yxztXBfkIkY/iIWe7+EV5O89GshbWiOma6zFlQ056JbF5
         dA78vklM2xSqGk7BIx0HK8s+1W8LprrYpFGH601DDtEMZh9atbKqFe/IHXLFSUDgxrps
         wJlO/gKSuQ/eLTvPBjoGMwQgPPe+/rP4nzgO4GWQMrpmR1E9rvpXff71wQC/HDHV3F2t
         z/jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715446150; x=1716050950;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oE5GY4dg8rCApE4xWDxgBDcp4FnAQBPmRCc+c6IQkz0=;
        b=NjumNwEZ2IB/6upm4fBszH4D+iwN8NXUqNls80wggNj+iKoNLiJGRSvw8IkjtKcB5t
         ZyGjGOK4F3T7HisyVOjJR+0azAteATvTXPmQg1b06ltFAvvNWJ5tzs6uXqFHFAaPca5U
         UeD2eZs/Yjoo0XKHTrV+xbLuYfQ4Ft2zLTG3w4IHP5d5dicjMv4KaxMB2YWf1gyUOczC
         dpNmrMDgD40hz+DeKMcWOPVvjjD5WVIOtbZ3jdQlqYUg4yXJjo3vsuYzH0BtT045X64x
         us3l1HdwsIc+MMSA7R4+2StZel2j+Z+0Bb3SK4xHhf6hapHupGt2bUFDeCgW+DeWPWMV
         NBOA==
X-Gm-Message-State: AOJu0YxRedR3v2AY5tG4TpXxddisM85rD40HkcvU6CA6072QZmxHVqpb
	RvNBLEf31N2Cw5cgF7ujgFnQJmOM9abbcD4hEff1X3UpqkOf/ct04yd/jZ7hf6Yl9IuO547VHYZ
	X
X-Google-Smtp-Source: AGHT+IGktp83OSK30sYjkPdMAvS6T9SKblE1FlfyEzUBgJKvbcHA8q/LmfuIzwIYMM7iDO96Kk2npA==
X-Received: by 2002:a05:6a21:32a7:b0:1af:d9a3:f3a3 with SMTP id adf61e73a8af0-1afde22ff06mr6720007637.4.1715446149865;
        Sat, 11 May 2024 09:49:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2af52b4sm4799096b3a.174.2024.05.11.09.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 May 2024 09:49:09 -0700 (PDT)
Message-ID: <b06760fa-761d-4135-886c-fa0c50013808@kernel.dk>
Date: Sat, 11 May 2024 10:49:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
To: Chenliang Li <cliang01.li@samsung.com>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, gost.dev@samsung.com
References: <20240511055229.352481-1-cliang01.li@samsung.com>
 <CGME20240511055248epcas5p287b7dfdab3162033744badc71fd084e1@epcas5p2.samsung.com>
 <20240511055229.352481-5-cliang01.li@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240511055229.352481-5-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/10/24 11:52 PM, Chenliang Li wrote:
> This patch depends on patch 1, 2, 3.

Same comment.

> It modifies the original buffer

Modify the original buffer

-- 
Jens Axboe


