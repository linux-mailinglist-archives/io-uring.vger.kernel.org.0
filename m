Return-Path: <io-uring+bounces-6503-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8683A3A384
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 18:05:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C2D23A5C9A
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 17:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC93326FA4B;
	Tue, 18 Feb 2025 17:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rg+tZBqq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AD126BDBD
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739898285; cv=none; b=TzKsWkFOIVqT0/MbtiJDFamBoTbbP/ivCiDLslIa6VpTZF4iwRoEY38UaALGPe6SPD5+0YqW2a7sMkBW+dUOVwhoS494NY3kmVSN9HlkqmdbmCfGOUmsIcNkmyAIZrBWjvbRpvwbloe2kBaW/EUYfY5dfuLAkQY/i5Y9dkQmEpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739898285; c=relaxed/simple;
	bh=sXOZmBUjIk6YVE0ba/ZQx/9TWFjrpBK1pLYexKw07Og=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PyJt7p0pu2BiMHfkElOOaneAP08PUqGx8mvVqhrp5NrpAYAXQNYNdoYkKaJyxKprboiWPBRBwbn2ti32BavXa1RPHcCksrLFbNp+iq+qvz1cz/fSt6xECVtdLXzeicFaHA8nwHavALtvdhm9/EnbTwa8xA7vkfLaYXcr9kortl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rg+tZBqq; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-854a682d2b6so426998139f.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 09:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739898282; x=1740503082; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MQzsCcgHsjra1mEeOiT2QVVnRrMJpzmF0298h5KtFWo=;
        b=rg+tZBqqxGx5aM/Fuxa2ON1ghxsAlvfL9x8/94eYujW8ZeUesjy3R7CSHfrvRXfX/V
         SoX61O7A5DzDX1+UujWodEErEJlWbvZRkXXtRr6AXxi8Krvds/mk5bUQin2lR9z57yyp
         un6zDJYMQYCi1QNTLaDqAks/ZFZocZrpn/Ua0phKtkL8GlKHWTRnCIL1BoHzHyjiIuDa
         mpZb8pOatelSJLvxy8sw6QA+6C5kvFyDRr5lQGwz5btNpExtcJjBo8iLRaPWgKTcv1L5
         tWC/7VZr0h9TZ//nd3bKac2HaiGOHQuhnw9OKzPpQwd4qo5QH1HgzQrfcGwP9Z7kyw5T
         GPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739898282; x=1740503082;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MQzsCcgHsjra1mEeOiT2QVVnRrMJpzmF0298h5KtFWo=;
        b=E1fZn1+J8mxkRhSrI/SZ2V85Yzfo8oANhbpNO7f9HYhj22CMUNTNd4TKxIvknTr2BC
         XowBLm15apgUCQ6DIsMC5hMu2A/a41Kd+AnyeWbTlNb8feiwQYpf8aGORdc+iy1tFDzp
         ttYNzcmsIRZ1kGd86aTl4W3HBFTagAGpT7hiWI2LOyIwMyIRADkPD3xBv4YpdbLRbng8
         nJZPg//ggWdvvI6D18CZnRjgaNEQeWeay7yF5N/lIUBBnD8oP5VXpz4hdHibGwPDgz/i
         fUjBx/AxLZpYWKjYfTJeI0pp4z1zNB7fZRYqepDBSGLlH2fZMYz2s8bXsDhnqHV7sdDS
         P8KQ==
X-Forwarded-Encrypted: i=1; AJvYcCXv9XPjcMGxYbEsJH9h3ic+OMeLGp863HLSSCN7wc6CRuypif1rPT3y8s6Q8V6kuudy0+P7UBpp4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvlWalF0gvIL2vdhvsth1FujfENx7+7b6DgFopah196Fr4zco0
	VDW/cN+iYPsOROxgt2fDteOilhNKnTVO1qhgybJ1F/lCqyy7Y5XOJ07In9FGYqg=
X-Gm-Gg: ASbGncsaiSoxMoqvDIGcbPVypBwVCBC74vTSeixM1/Eef31CJ9hEuye1+a9g46MJcr7
	mDnU4bg126ssn/cbznmRCZuR81wUTsC2ALD7tOr8jL1qM3JPTilPOUWdszuJV6oNu6TZrFFNXl5
	33Azi/tOvgKOdHKuTaZCJbP1URABFiYI402vJMsOSIoYwFiXDxhRJzgWFYS8bfswhqe0r5RQ/75
	BJxrqiEa2je7/BBt44LMMgJsXWLChKXa56fsJa3XkxWh8CoBxwuuEDBHUs7PpcMB8FiEJBJ0aLR
	YLkTAlweEVOk
X-Google-Smtp-Source: AGHT+IFSUIlvQ+UDMcQ1wDp2DLJbGgs+j60z6jcpsURp/9jlYrO5pRo0iAanlBmEPgvht0bB9gOLDw==
X-Received: by 2002:a05:6602:6d11:b0:855:670a:e687 with SMTP id ca18e2360f4ac-855b396d596mr20596939f.3.1739898281826;
        Tue, 18 Feb 2025 09:04:41 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-855a6239691sm36648439f.22.2025.02.18.09.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 09:04:41 -0800 (PST)
Message-ID: <ef292951-e868-4740-8d98-3beed25f81a9@kernel.dk>
Date: Tue, 18 Feb 2025 10:04:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1 1/3] zcrx: sync kernel headers
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20250215041857.2108684-1-dw@davidwei.uk>
 <20250215041857.2108684-2-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250215041857.2108684-2-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/14/25 9:18 PM, David Wei wrote:
> Sync linux/io_uring.h with zcrx changes.

Some of these hunks seem like generic changes from io_uring.h not
related to the zcrx work? Not a huge deal, but would be nice if they
were split from the main change.

-- 
Jens Axboe

