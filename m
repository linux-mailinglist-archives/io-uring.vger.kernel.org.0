Return-Path: <io-uring+bounces-6144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C1D9A1DB2A
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 18:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6990A16187A
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 17:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41B318A6A1;
	Mon, 27 Jan 2025 17:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aZEAU1Nz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0F87DA6A;
	Mon, 27 Jan 2025 17:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737998455; cv=none; b=lmdRBcANkeQtfylrMJpEkROvrgf/B3KdV/ztn4FRwek6Sr1IRvp+Sj/TV94ZuXPBfcRSUCROvmO9TcR1WkgJFqqyM2kiwo0JAvejC1IEN10hmhiZKQ6KnJKZn+aXh9woic6zj95UMrnjXbmQv66nRkWSC7Vi71wq5aRGjd+DPMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737998455; c=relaxed/simple;
	bh=yqPicxUgCQMEwQTzgfNwfR3qsG9uHV2+cIxR1WbFFdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xt1Qk3Wqg9+yM2L7EvCTph/FQ19QitgEAy20J/O+m9bWyZb3fmiSYGFkk1AfQ92plOrxRZiLwg5ajpdbJeKTm094bqHIsxIKBr+VA5hw1fAzt4IV2SD2dgHRo7w0ADWzjoetk8hqF4OOjeF3qXlnjHon4/XOVGub5GA9Z2Sf560=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aZEAU1Nz; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38a88ba968aso4688254f8f.3;
        Mon, 27 Jan 2025 09:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737998452; x=1738603252; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=28lhis4UtCxFF+i+kMA+ZCR2L5v7+n/05OVkMSX+dvk=;
        b=aZEAU1NzVfWX/jp6JXN+36bLm6uV+xO6jQAc8wzoPswud68o0+C7s/LIQQwTrceajF
         iGH1awH7Wx7qsm2B/a/hGs5kJw1Ko7cYMLdRXDHnrFkHC5Yg9XLrxcYFp//8yncWk8qH
         me+RddlXvfqCBmXgSRvnsPvJ8V0LB00IyS6tK9gIfPLS1ckkKHTzGVZ4BEqpXY6qc+hq
         ZMMTVM7yryIOataTpH5zSgG1PnvwJzV4Y6cpf8ySWoulK7NQ5OtOxWJ/TlXEu2cJ5wLf
         zDfaK3s9IJgzjTBffV4KGlTP3mPPUQQivwy2OSjOjkUVXf8UeO4iAy+Z4q8F2tVkr62i
         GF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737998452; x=1738603252;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=28lhis4UtCxFF+i+kMA+ZCR2L5v7+n/05OVkMSX+dvk=;
        b=h+w606sMtmlc+PNPwIC9kLzyNwNtavEmIbhKAP4wXs+Ul2kEsSOSGHIrym7EPj452I
         5/3j4bjM/M0jZ01dYPSwIsqU1mhhi/YvlDsXgcgeAOyZOb8y/unw4pC+aQtmOMhcDHGU
         nvZrJww7rvXSlaR0HONQTPnRMG1CxcVQb8ZXbYsQLPAiQqhAJadUpgS02wRd1z+LEwT7
         qpp4DxH0E+GIiE53J5QLSfGhTjmW9hXKV4i211OBS0+KkcPhmkpjMlzCylBNvJAtwLgE
         /HLCgYFdPv9twjiwCqZ4UYmJdC3ajcWYnbE6g3vZgDx5WZqAsRtwYqfP75vvkPFFxNQ6
         UZBA==
X-Forwarded-Encrypted: i=1; AJvYcCWdzKAF3ha+HEA85Kb4jNN5s5Gesg3vScMSHeCujVZ7CfervDAF64D8ZY0zNlbmdrNWr0vgRJ56P/x3/+dS@vger.kernel.org, AJvYcCXarY1c8uEGMEhVCHtxAvIYNfFXYSOcndRDlspB8Hv5B+nMqDfJefR+Qn30eg01ucTxUUamx/zwXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8gTRclvxuOMzULwEgp3Xccu+5UF14tO/kCeP0IBf3uiO94vBt
	1vP0nOBHIihGZYWlwxzVWGlLCtGR2T+yRgbjSCnbuu4KzFGld7QN
X-Gm-Gg: ASbGncudzSoHKceiJVcxZGtMbfWBSWWaOXoID+Dm2GJln9FrA52Y/7WZVgsGuvd/xYZ
	96FkkTwE31f09TD6BlxbvYNYHPlwki2HiODw/eCsPoAzIP39RXAyWqLDWq+h28s67TUTILTARIo
	6ojIAn18CA5WeuMEblsYQ+jtTQFBLT7fVZ6CNYAWlHejkH23J7CegAymgz4FGQ5AhKpYdJozXV7
	+edyiuOJYJuzqswwIGrqarQM9/0Ofa5QL6ePwpGT2ZdhIQn5xeEMQQaWqBoNTntMnWx3V5/cz9I
	bSYf2Tj1OnS2ZQ==
X-Google-Smtp-Source: AGHT+IFIGDGFCCTrTcCnx+mL8c9X5JFtSEWhZsxLfsbzes6Hwq8V9rn2BPbiep8h5DEXXBw5N3/J6w==
X-Received: by 2002:a05:6000:2a9:b0:38a:50f7:24fa with SMTP id ffacd0b85a97d-38bf57bed8emr43897711f8f.54.1737998452253;
        Mon, 27 Jan 2025 09:20:52 -0800 (PST)
Received: from [192.168.8.100] ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab675e64da5sm618850466b.60.2025.01.27.09.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2025 09:20:51 -0800 (PST)
Message-ID: <999aeda3-5565-44a3-96d4-00dcd91a4cbd@gmail.com>
Date: Mon, 27 Jan 2025 17:21:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
To: Xan Charbonnet <xan@charbonnet.com>, Jens Axboe <axboe@kernel.dk>,
 Salvatore Bonaccorso <carnil@debian.org>
Cc: 1093243@bugs.debian.org, Bernhard Schmidt <berni@debian.org>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
 <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
 <Z5MkJ5sV-PK1m6_H@eldamar.lan>
 <a29ad9ab-15c2-4788-a839-009ca6fdd00f@gmail.com>
 <df3b4c93-ea70-4b66-9bb5-b5cf6193190e@charbonnet.com>
 <8af1733b-95a8-4ac9-b931-6a403f5b1652@gmail.com>
 <Z5P5FNVjn9dq5AYL@eldamar.lan>
 <13ba3fc4-eea3-48b1-8076-6089aaa978fb@kernel.dk>
 <a2f5ea66-7506-4256-b69c-a2d6c2f72eb4@charbonnet.com>
 <dfc6006d-10cf-4090-aafd-77d62c341911@charbonnet.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <dfc6006d-10cf-4090-aafd-77d62c341911@charbonnet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/27/25 16:38, Xan Charbonnet wrote:
> The MariaDB developers are wondering whether another corruption bug, MDEV-35334 ( https://jira.mariadb.org/browse/MDEV-35334 ) might be related.
> 
> The symptom was described as:
> the first 1 byte of a .ibd file is changed from 0 to 1, or the first 4 bytes are changed from 0 0 0 0 to 1 0 0 0.
> 
> Is it possible that an io_uring issue might be causing that as well? Thanks.

The hang bug is just that, waiters not waking up. The completions
users get back should still be correct when they get them, and it's
not even close to code that might corrupt data.

I believe someone mentioned corruption reports from killing the hang
task, I'd assume it should tolerate even sigkills (?). It's much more
likely it's either some other kernel or even io_uring issue, or the
db doesn't handle it right since the update. For that other report,
did they update the kernel? I don't see a dmesg log in the report,
that could also be useful to have in case some subsystem complained.

-- 
Pavel Begunkov


