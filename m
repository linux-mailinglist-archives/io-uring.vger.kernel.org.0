Return-Path: <io-uring+bounces-10110-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C7F3BFCAA9
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:50:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42DEC624AC6
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 14:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0541434845B;
	Wed, 22 Oct 2025 14:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dp5c5CcJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D8F288D2
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761143752; cv=none; b=JYX+sNB/+ptgyoE/Pr1c4kUuJmq0iGMaz9oRngZLpaXoq8yrVP/xfHneby60/LZQ6A1EQe9Z2t1MFZ/mQA/lDRqUte0M99gQ5tOyoVQV5vu1qs0AOJVVVGqwdr8bdTfpGOSN+BVp9JR8bpmmIldOvAb8813IwBWMwI0G7J3FqOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761143752; c=relaxed/simple;
	bh=n0+FVFMo3bxk2B1drC/UjH6vvWV9aCmMZ27jl1iDwkE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l0ke4o0MVWAs9lozlEvkMuTxcyZthinFsxKu+JEFgcTn1nTPExizRFHBZ+RZWp851qQ9HAbwLUEtAk2xf3JSN99Nm7IJHtkbXEYuUDjzoGV/wAxpiqSbqNvTQKgpCHW3afU4TsZEOJGOd9OeL8BsbNaU+PqcF0AOoPaQOyD2gtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dp5c5CcJ; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-92aee734585so304880439f.3
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 07:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761143750; x=1761748550; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mspyCYDPZYp41/uackHpPucgl+4rC18nGgCm/5Ygfa8=;
        b=dp5c5CcJ1aHWns1OShkxQ44FKGjDCm+hqOWOqE1HgRd72EF8UaPGXWSbYHM7r8B+6d
         HJdvFk57BhSq4MFWPfJ/8M29DvwOmdOr363tQhnK9xSpWyC7n0mcCs6dYJzLWOrY9mBQ
         Ps5WfsaaBEbVRhriZC5MnoBcDvefEoQXJB19DZ7nvXyqqP6xCsJ4uwqCVufrdPPs4B5f
         SL6sZRHYHTPKzg4CaJpc41Dx9tDSZ7SSxwdtXB0T+/8IsH+AHzhZwcemUdVt3bgQ3ddr
         c3tH3k8lHDKn+dVNaV7BBZNGofeImBghsCRad3wSP3U90koPnkZ1nkFORFBXOcfY6Mm5
         diBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761143750; x=1761748550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mspyCYDPZYp41/uackHpPucgl+4rC18nGgCm/5Ygfa8=;
        b=QrL6iBEfHRL3WPCB8Tf2GpfGg+/zzBUVMGtBH9qWw84KsF9GvZTHnLjx5G2+pBeLRc
         u/tJxqkKQlK0zTtvV8M/dENzr3FOHVevNGoJdPwFJtP2ITf8V5f1m9ayX+2b4nrGWoDT
         t12ZYtUa7BG9VUeNiWifPxX/C/vGTI60CxdoCBG9QL6AveLceGX0t6k1HVIuvYOmTVvE
         wDEkj9hIZ1q906pi3Wt2UZErSvR5dSIGcLICN30szHE3gJT6X+6bhHJL91nleUuHNBC/
         f8swOZJSwRkf1JKkW1zU2tWHvubMUzAMtPqwku6CQu78O7H2+IZ7KOFwxu31Ohb6i72b
         aqkQ==
X-Gm-Message-State: AOJu0YwEw7a+bnhFnth4YmzNjX6rf0GcaO1VWopwZzDzbPQxbw91eRF4
	TcDyIeOwaQG6wrywRc9TfhvsBS6/uJinlh7G31Yj+2dqwXkA3g3z/HbBvjZJUUXnuBgShQRaGf+
	SjI3kgXE=
X-Gm-Gg: ASbGnctnD4IyU/z2VU4jX9xLySxBDTFoG/KRlTnFzm8Q+m0+Xl3iFEVKTdfvB4SoUle
	PRQv3+teMsh3Md0ttjWEYGTZoj7ozxRFDtR06YLt2RM3ZRWcwfxN3QxhLXnWBUEvdVAS80OxJ68
	2LJguqfu9FtvqZ6Pr/ORjX2xBJNiccW4cIqO9fJWh30zqJtUQVKv/AjwPR18H8BLQvWPqgduZOi
	Wa+2w0ZT3Mgik3ifr4BbRtSLCScCbEtSYitX4vGJOqLNPecEoa5pw7/xRoN4p9TsScRf4XqdkFg
	WjUUuEkhtMBLvXKCT1rk/xmt33OaIMqwGURVk+D5NaDqurIaY25qszx1wJrUFJSzmo+5VSWkl4d
	aZGypVFwxhHu9O5Ia0Xr38qq7SBUJkaCFSdlN56J5pDh+sI/x5jBpgQlenA/CFfJf0aL+EOjDjy
	lZSchZRGQ=
X-Google-Smtp-Source: AGHT+IGN4eJTVT+2/UI7BLnlYma5IHsr43gRsfgtrYleslJZuc6r9UKlrGWP+OpvLZfJIaoiMTRG8Q==
X-Received: by 2002:a05:6e02:1445:b0:430:aec5:9bee with SMTP id e9e14a558f8ab-430c524ce96mr85904905ab.7.1761143750419;
        Wed, 22 Oct 2025 07:35:50 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a9797c36sm4973736173.56.2025.10.22.07.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 07:35:49 -0700 (PDT)
Message-ID: <89b2ece7-e1a5-4936-b5d5-7b484e004d1a@kernel.dk>
Date: Wed, 22 Oct 2025 08:35:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring zcrx: add MAINTAINERS entry
To: Keith Busch <kbusch@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20251021202944.3877502-1-dw@davidwei.uk>
 <aPjqn2kdgfQctr-0@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aPjqn2kdgfQctr-0@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/25 8:30 AM, Keith Busch wrote:
> On Tue, Oct 21, 2025 at 01:29:44PM -0700, David Wei wrote:
>> +IO_URING ZCRX
>> +M:	Pavel Begunkov <asml.silence@gmail.com>
>> +L:	io-uring@vger.kernel.org
>> +L:	netdev@vger.kernel.org
>> +T:	git https://github.com/isilence/linux.git zcrx/for-next
>> +T:	git git://git.kernel.dk/linux-block
> 
> Is git.kernel.dk still correct? Just mentioning it since Jens recently
> changed io-uring's tree to git.kernel.org. I see that kernel.dk is
> currently up again, so maybe it's fine.

Yeah true, it is not. I missed that. David, see the io_uring MAINTAINERS
entry for the correct URLs. But I can just hand edit that, no need to
resend anything.

-- 
Jens Axboe

