Return-Path: <io-uring+bounces-5666-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B200A00D45
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 18:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48B021884225
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 17:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93EE1B87FA;
	Fri,  3 Jan 2025 17:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LDxoTqSo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3798411CA0
	for <io-uring@vger.kernel.org>; Fri,  3 Jan 2025 17:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735926946; cv=none; b=jEdUb33pJdFHlNJ1qrgGMmcZHqqa9Kq3s2OaeHDq6kwOLw9EiId2KLOV/n/3G39/QYAF53XAgJHW7+fghhsQfqQUpclfkVOG4esYl/1A26S1EyPl5h5U3daosExkpoZdg0ozfbTMrmHjLiKFUxsb7DfwQcGboPkguHofX/i5kq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735926946; c=relaxed/simple;
	bh=gPoST/jt5WBqySZv7iVYaQ2xz57myOmE5UZ/PJ6KVNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lssxpytN5Adj1C46aRdG4KpIBm45mMxWg2wF19BnQ8NM6KUdH4tD1obKa/StHr9QuYPGKf47peVLxMAFIryexUOuuvLZvLuougkMNp6FCjqjrAlJkDXo2RPDLWGyXMIeomASidQm4/Y7X5rXmXm/Rwq3MW1xNrB29pEzuq8ibbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LDxoTqSo; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21669fd5c7cso176994295ad.3
        for <io-uring@vger.kernel.org>; Fri, 03 Jan 2025 09:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735926944; x=1736531744; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tPsZYH6BNmlb0EtgXt0Wn++FQ1eCSgqp7vMNq661tIQ=;
        b=LDxoTqSoHe8f4qhIlb0lHmtb11ubKnBOepVVfWfFC9XS3NKUqcq68rTyNPIy6gvCgP
         IN2Es2Ge6ltNLGtrgL6kgISZO5AVxNhrebZV/xG6Rw6Airkv6ooBtZY8lZGGIdoN1gMc
         K0nptYPQisY8BG+ccqBCKhNBZq3E0G2JXBBK0FMe8v9Vron1rpkZGDaLgeBkz4PyEGUK
         46tV2Wmcrxe02qndLu61zqw/VwGx1mleptGQfbJ8wB4kr+USXzxyfLHE7xHXoY4IYgSy
         to9/ckqmqk9tVIreo7j8s2wJk4tix0RFs6WJ/Q+F9flFjENR/HAjN8JtqzXpeIx+4Uwe
         X4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735926944; x=1736531744;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tPsZYH6BNmlb0EtgXt0Wn++FQ1eCSgqp7vMNq661tIQ=;
        b=PlIllE1OCB7uTSlAgNZim8q5TNabtZdICDmdC94O9Uy1DSYO/5HnLENWCJh9rs1MVT
         gv/jxuQPOB5NRyrCgN38HMXSrL2PDsBqR5rqETLSk/DhgmVMVX9eJmP3qK3nJxpS5CM7
         MgASjhLSEzSCwoUjNsN+5yirLHvhje5275TheqGBb1jnnplLyavj8EJdtCELBxcQYwrm
         /YLhJT1hNm46tgCdfaUWUoPXQWPclqlZSLm0QFBjF9hgHztUhGCl4eyRcKTJWGer3Ysf
         5ZwMO/YheMaLiMVcFOCpXs9HrkI1cDmJJBNZwHPkql2wPzqH1Y/IgzswxQW1OpRE8FML
         +RNg==
X-Forwarded-Encrypted: i=1; AJvYcCUwIl6el09keOcTiatMoCeFNb5sYfM9jEe6QaiMMuxNKZqJMe6heJbclJQ/IDBTU6EyNuCzB33DTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIQBjCVD2pieCgYiaG1m0IlETITbdOzDC3q+JxNahSHIbTJ9cO
	TlNC2XL2NbGWJ2nd/2IlToFanBpduo3NWJoC7kKMaR3wNCwMoiqYuAuxQAGMXT8=
X-Gm-Gg: ASbGncvFNxdmqeMxoRCCGXc0fucbvyRCk/ILfmksXZ0KhqNFATEqfbdmeRsprm73bYW
	W+q7JsOMFaHTKRdAR4wPy+DIt65kZJZM36btbN8hojnmeqazOUCtofudLPQerr3NEE5guYSIDtI
	F1S7GXuM1HRANqCzu7v4pxbEWswowY7VVOXJlCI/3cDafzGamiq9SorgKej2njSz8WWA6KAVgM1
	GCA1XMUTz2vM37xtglx9JswHaZR2swyRlaE+lyS/gApc6C+grhrsA==
X-Google-Smtp-Source: AGHT+IGpjDAj7wrf2YpqomVMGgMN9e4h2te9bODPZwdcmhZJW8ZzR5Neau+h12vSaifj5qtJCGCreA==
X-Received: by 2002:a17:903:2449:b0:218:a43c:571e with SMTP id d9443c01a7336-219e6ebd140mr764868055ad.28.1735926944525;
        Fri, 03 Jan 2025 09:55:44 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a1773c654sm142231765ad.29.2025.01.03.09.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2025 09:55:43 -0800 (PST)
Message-ID: <679a18ab-13ab-4a77-9274-7de4fd0d175e@kernel.dk>
Date: Fri, 3 Jan 2025 10:55:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] btrfs: fix reading from userspace in
 btrfs_uring_encoded_read()
To: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250103150233.2340306-1-maharmstone@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250103150233.2340306-1-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/3/25 8:02 AM, Mark Harmstone wrote:
> Version 4 of mine and Jens' patches, to make sure that when our io_uring
> function gets called a second time, it doesn't accidentally read
> something from userspace that's gone out of scope or otherwise gotten
> corrupted.
> 
> I sent a version 3 on December 17, but it looks like that got forgotten
> about over Christmas (unsurprisingly). Version 4 fixes a problem that I
> noticed, namely that we weren't taking a copy of the iovs, which also
> necessitated creating a struct to store these things in. This does
> simplify things by removing the need for the kmemdup, however.
> 
> I also have a patch for io_uring encoded writes ready to go, but it's
> waiting on some of the stuff introduced here.

Looks fine to me, and we really should get this into 6.13. The encoded
reads are somewhat broken without it, violating the usual expectations
on how persistent passed in data should be.

-- 
Jens Axboe


