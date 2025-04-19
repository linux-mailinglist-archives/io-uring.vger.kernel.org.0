Return-Path: <io-uring+bounces-7560-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F163DA9437A
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 14:53:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27FAB17AFB4
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 12:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8BFC8F77;
	Sat, 19 Apr 2025 12:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SNrB5V/L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFC13FE4
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 12:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745067210; cv=none; b=ebNZApnIB/4DFurwpKlXU2nUt8jhiwtQV+JiuwzeS7sDcQwBr/MkxlWjWlh9kkpjaMkJgO3V/KajluWhd7FXJ1mDUbjCtm1XqwBihDNxhQTfrXpKzItiNi3F4T1nYxNXCLlKEfYXy6oV95eiRhdZDdXOxUhJeTNJc7Dc4iVmPD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745067210; c=relaxed/simple;
	bh=OeKwo0gUt+TqIUB2ffCn1uT8JKTR+SP/HDA4H9dDZ9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XgyKrQ4npTJpgLeEi3Mi/hdiu5hJCCH03NgM9z8FMa4c4HacB+bTFFMZJ0Vo2KDBAoCbtnkhGKN8emELkCs9hEOhkhvQEHv+WIVDFgSDzXeETNYak6A2AazbKDVEUEp7vy1i9VbWO1ZvRou1M9XOqi7SABxqZb3p9GP+BttlWi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SNrB5V/L; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d6d162e516so21331335ab.1
        for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 05:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745067208; x=1745672008; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cLRoFBpm0sLlkZbmqETcZd2LDZTVEqL0XhWGB7aPPR0=;
        b=SNrB5V/L43d03Z3obGU3YxAybA0mMrlpL4fahoJdMu2txOFJyjwUfHGc51+tSZ9EDI
         jRu06+CrIrVnNbTIMT3rL6f9EinbNWeKbcy4J1tUF5Z+K+Ol/50AVmO+N8gJsoAAinJl
         jqWM/uKmqj2v7CqXtZLInCEvICUgKtV3oq3Bg9k3a7LHhl9/sBe0j1k+plZWX3tu5HgH
         HNk/9Uutu1sgc3ACbysUNHefvubaKlLxdnGStHIInmofWJ/YSGVGInKOAtLcpdyUlQ8z
         vX7qpf7QmSXr1hgnw9BApV79mhRFYQnMkJBnfHCHmhT8yWJfDlpnSHz30Weg0ivFlhXx
         9KOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745067208; x=1745672008;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cLRoFBpm0sLlkZbmqETcZd2LDZTVEqL0XhWGB7aPPR0=;
        b=pRXxfnI2uT3HeAg/tOB72vJKyn/vsVrh1pNjFSf4Fg4OFBPiOrr886jGddyY9P9bSp
         zfLl7QwsnxFAM5bjPJkG2TwC0c83UpylkW9nSF4Zju6YyWF6kL38v1PAC5wWdAgX1Ys9
         5xCEnehqJTp4AGsyvElo55lfRmbMY5WvTcKK7BZiBsd06gNK2nBbBASJMJLOXN3M4fBL
         tqa1i+kVMuYm82z+uS0+Qszcg/MmVjDRMtGwt9TKMmBBLrffeHyI+QfgtLXx4e7/S2Z0
         f9jxhGNw7R5U5SyzhiNWBOqGwlVHbDdLjgJ1G55PN17ivkUqf/at+kXBevcdr+J7Oddm
         goJA==
X-Forwarded-Encrypted: i=1; AJvYcCUsUR9u8sYXGQu4hvnb5GYtG/CWlyrTBQqPNEEycl6XGSVwdDKku7W2AN70pRg5BkJcdL7RN/0d0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzU2s7/RnS/gtBXSIRR0s+IU7bAv0Lhop8p0FiBxjI5jwZ9BBXO
	z1IJU6bHuRuOgjmrJHFeOWqnKdZpZxdSaoBhDlGKAnS1IBa+Kef35luqJKGO+bk=
X-Gm-Gg: ASbGncs9s0niSKe9RIav4QLvJmVQ4yMcvknpc/Y8ttmVUDskQmeeNNCbzRm2IAK7a0m
	c4m6D/o0JbGigvUbt4+ppnmsAqvbCubFYxennqs3MNfB9LQx+ROP+0GNGKklovymda6+sqKrJyH
	JGfgu3jxaPB6eLPZDkZGLugYe51Cco8V0xugUXCDophYPHAVB6gvnfXhe5EPfTfXlEwoSL0lANc
	zxAK8RUMnPJDH7WHUQ0uenXLApLhKUXlXQvq/pETJfAbSqj/pqh5Nn6SEMB4sgrvGgMS+b/Pb0R
	iecA8e9e2lbFcdnoISr2+raEnLPAccg6Rb1lTQ==
X-Google-Smtp-Source: AGHT+IFUNihnw0uH049Q+r1Cq1voywyA4aRwtv2UnBhupvRkAVE02BneVuzX6gjPSF7zreROuuFljQ==
X-Received: by 2002:a92:cd8d:0:b0:3d8:5fac:1146 with SMTP id e9e14a558f8ab-3d88ed7c580mr59420005ab.3.1745067207961;
        Sat, 19 Apr 2025 05:53:27 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a39335efsm900434173.79.2025.04.19.05.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Apr 2025 05:53:27 -0700 (PDT)
Message-ID: <75a68330-96ce-49a8-bc63-519baa480710@kernel.dk>
Date: Sat, 19 Apr 2025 06:53:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] selftests: io_uring/zcrx: Use PAGE_SIZE for ring
 refill alignment
To: Haiyue Wang <haiyuewa@163.com>, io-uring@vger.kernel.org
References: <20250419095801.4162-1-haiyuewa@163.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250419095801.4162-1-haiyuewa@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/19/25 3:57 AM, Haiyue Wang wrote:
> According to the 'Create refill ring' section in [1], use the macro
> PAGE_SIZE instead of 4096 hard code number.
> 
> [1]: https://www.kernel.org/doc/html/latest/networking/iou-zcrx.html

Same here, should use a runtime query to get it. This is not like
in-kernel code where PAGE_SIZE can indeed be used.

-- 
Jens Axboe


