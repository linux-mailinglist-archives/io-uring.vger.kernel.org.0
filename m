Return-Path: <io-uring+bounces-6358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59629A3287A
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 15:31:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E11D4188254B
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 14:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB59720A5D9;
	Wed, 12 Feb 2025 14:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rhXyZ2R4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608402101A0
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 14:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739370698; cv=none; b=V2zeXPK40Gbd12umuiPv75gMb+k2VpdiPPk30OppF9nQjUt2UdxQX4efhQBj//lXEfa8nsc/bPfMWt7JlSi6eWoDx8PmRX+U7A2Jh4UFBgROkaoYHLHce7xWFfK/zcksILQToOzpnE85ydCHo2KgqRjjJIgMLLE7sDa/44Nz264=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739370698; c=relaxed/simple;
	bh=BV9yHQ4CcI0kkdl7spY0bEOrdW5AimaJnh/Yg4230Pg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yz3haLJqxITXmVmvq5hvQyaNPpBBI8rWqnufHok43NFMx9TdjCs+4l96Ih4l8NiofbOJhaIGrymjf5vdCnzvQpjRVbztTQSjnfGHDXhGZC+5mYk4KY66p356idxraFogM5yM7QmHH6X4OTwtB5M5vUJMcfvIy2VQGhkGiQF9mUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rhXyZ2R4; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-8553d7576daso87726139f.2
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 06:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739370695; x=1739975495; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rI26amO3eEYeEbua7SiltttLtUI+x1T9T59al1sHHoM=;
        b=rhXyZ2R4OB/AYoskMpT+y07rAYQonBQ/0Rrx0kfOIbZ847I8hva9MLkgoxu14tNbk9
         bhKDT2izPE8GRAl9xRlBtRM3ISpkTs97AmCRMubgyH4Yf81+Wo7nq/Qj1K79tXqDnavr
         7MPksNW5uxlABnqKY7K5xgSOCV32Azg9Oju0aQoql0GwlIlgqBkqaHFzmBjGg1eEvAzw
         JeDE40BFoZJC3ii1PhZ4ZZ3Bc5GBcOzoJgrSWJdm+BrX1y7FL5eJ58WHhIP2hx0EZmf2
         tOD2AtBNFkmWYP8oXtoOXVim3kwddlt1l/HlSwg8FmAfGp1c3dXOmghqkxXEonee9l9g
         BQPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739370695; x=1739975495;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rI26amO3eEYeEbua7SiltttLtUI+x1T9T59al1sHHoM=;
        b=o9PYCyEkS7Dsf1p5OZ9b2X6nIeK04wjWXZFv70XUUpuokMd/wZYU9O63mO9hspLh5e
         Oy85R6Af1tFCceSWnn+/2dPbvMoW4b0ih/yzkNndZZYEsEKSkaEFy+FOyM4o8QerkNyW
         zRcSL4FirCJUgkxdvqj09BOK4Oq1XXysdgDVkKQbrJwjuryYSvcgTkN8EYfxLZYxX+ns
         CwN0EtBak8WE9O+8+CGoItx0Y+pre6H8yQpE5rAhAJSd4XqLOB6lnLwNR7qu+YJbn+pA
         dUPB68l38D8oEUf+GPKlE75GVLHumXHl2wDiKnsNbdffpXC6yfRtj2Dzx04WnKxFE+UW
         aD7g==
X-Forwarded-Encrypted: i=1; AJvYcCVu2NXh7RfCJOoO41RgYJur9oez6kCGt8CpK+YPYV5/jgY/R57M+y8u4uOx9RxDmKt/ZCzV3JddPA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq+dXvYVwckGy/pbmSrwb09HC1WXu8QCv/Lnmh3U9m9oA03ljD
	qMPHJPiWHahb2fJ669LeKkfh1cDWZ0Pr2VfFzxhZejmrMuaQsZfz1rT1BKr1jXE=
X-Gm-Gg: ASbGncserFE3+qq80VsqUmEIeIDIa/iYrguPS0PMHh04PgtSUYXHwpq3Ao9NBLNdhyc
	v0VaPssLcegz5CihPPAYti7gWPtwJFCtNzXv1pUzDRYKiRZIJwiBWFb715fihNZmq6zIg8b1HC7
	UY2BZnE0vC8K2fmg4t2eDs9Xjvs6QmviJJoBIC/EmDZCQ9SxyoH7q9jpouXuQ2KYW7Pi8b0xzHN
	R3Zw+KkizDWHj4ZeGYrBVTeKXp/Fdg5wBMEW2RjnVozSQrFDlH4W6TCNtSwnbgPXZUMDLorMSr0
	89CsNGUjGS8=
X-Google-Smtp-Source: AGHT+IFOCTkHKl9COTRV3a2w/g5SCBTRjFt4GzvoMLe44UeSsqglQdw480DxONSw/iq1vlkb7lMjVA==
X-Received: by 2002:a05:6602:154a:b0:855:3ed8:ee82 with SMTP id ca18e2360f4ac-85555cd8d32mr358083239f.7.1739370695427;
        Wed, 12 Feb 2025 06:31:35 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed1dc9fa41sm227410173.27.2025.02.12.06.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 06:31:34 -0800 (PST)
Message-ID: <f77e9bfc-0a10-487a-9d24-8ac5a3bbf239@kernel.dk>
Date: Wed, 12 Feb 2025 07:31:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/kbuf: reallocate buf lists on upgrade
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Pumpkin Chang <pumpkin@devco.re>
References: <40d7284c871172f948f490a92c59a9a50a9ca3fc.1739367903.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <40d7284c871172f948f490a92c59a9a50a9ca3fc.1739367903.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/12/25 6:46 AM, Pavel Begunkov wrote:
> IORING_REGISTER_PBUF_RING can reuse an old struct io_buffer_list if it
> was created for legacy selected buffer and has been emptied. It violates
> the requirement that most of the field should stay stable after publish.
> Always reallocate it instead.

Applied, thanks.

-- 
Jens Axboe

