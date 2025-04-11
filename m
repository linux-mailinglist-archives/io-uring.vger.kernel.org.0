Return-Path: <io-uring+bounces-7454-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F20A860CA
	for <lists+io-uring@lfdr.de>; Fri, 11 Apr 2025 16:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A4AC4A8B80
	for <lists+io-uring@lfdr.de>; Fri, 11 Apr 2025 14:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3C761F7575;
	Fri, 11 Apr 2025 14:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CyHHiE6/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA431F91F6
	for <io-uring@vger.kernel.org>; Fri, 11 Apr 2025 14:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744382277; cv=none; b=CjSy6QJgleKHaGl/PGxIlYPunhVEwwAi8o9qIbUbp59ccBAa2nlLveWNfSzE+DiDjmU9JSZehxHNh0aW7/QE8uMESQ2oY25hJpIQYX7Thn5DDtTbhPT/eYftBMpFv9RXrG6t7X5z8xR1HOUbN40LVGd0PHyyh2v7XwpUYkPqc5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744382277; c=relaxed/simple;
	bh=2LERUFr/wQhDkFwYICYrlJcPEQbXMIMG1NYz4MJH+zo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MtrMWnRNB2tnNUnx/L/8p9AWx7EoqA6zpAvgXeV/hVq78g1xwR9PZaAedtQjxDkovympTHKoHd58BQxP5sG13e+cXMCJqGM22NYMedQZBwST3O6q1jQTQW2bCs4109+6mspo+WvB841bPnsn5VjwtVFt96N9FNXi5mh9OIKMbhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CyHHiE6/; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-85e1b1f08a5so52486639f.2
        for <io-uring@vger.kernel.org>; Fri, 11 Apr 2025 07:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744382273; x=1744987073; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j1eWCMTidsdTrjz4Yo+Jb0xH3fGdUIK64yZp6T6k7Tw=;
        b=CyHHiE6/TJyJZGmAZtseCOKNN3ypO2jx9TBUpiORWqVm1x2PgO8FaeLlFv2F7eGjAc
         ICtm98Svsj1+bp3z1GZ9MEhE/bDq53agGompGhCGyqm1lFqYON1NAcP/SsTU05adqELT
         onvJM5KMOduZDgPflZynQMtcbSzAEnHe76fqgi3Td5vONFyvOHfd1+7JcdeiiWD4a1Nd
         0YE/RL/tzuUBCHqlppNFbxgZcy0z5QlRwSC8NStqakJweQ8NNXaaRAlT8i9lgFRivV5K
         R3uLBfDksxA/MMaxv7vtCwz1ct84AqLXUoWhvUxwQFILc5ft0AI4y+SiokqzmudUOaWv
         uUCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744382273; x=1744987073;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j1eWCMTidsdTrjz4Yo+Jb0xH3fGdUIK64yZp6T6k7Tw=;
        b=Bzu1RLFYINrX4XXpKnIkzsGlYCwEJunNhXtC3/5VIUZ3i3552STh0iq0UkCnv3i0Et
         w4ohBvsutwkCW2eQkTCrKPhsRdmm2O/J3plUedJLd0R1/x1OjUkztKl3QL14Q88SPnba
         QNpW6JF7yTHdWqGI/sM4Oswku4X3kwPEipH4CS7rKUHQUi103vvGxBUGiSRpJXY1PNRx
         dFQWUDhLNTNKhGoKkPTHWXY3Zw1ap5HmA/5ZsqrltFHWir4M2JAl+c9XD5CG7Xk2+DFQ
         eeGaQLmmOU5QEFXde4lqDlKV6mtWnR2um2eBM1CVedepDPw+aUU3f7iWXJ+0Rk9WzTG7
         n5Zw==
X-Gm-Message-State: AOJu0Yzq9pjPAu4YRE6TdxLjELkISwaU3eM14PgcRZgJ/DX41DnHozYe
	4xTc2siWZ4BPAe2/69bRtiy35H5IST9+U6N++9YmlerwEFPmAFDiTHb3BxSqL9g=
X-Gm-Gg: ASbGncsq42VieXGqdNXt5jvkjJGpfEnR4Tk30j4AQp7kQ6yq4HfsyVN5wBDqfN/A1/R
	8Hf/NVf4lraKiOlh02OHLnBl33if8tiML6s8wQAwUFLW0/eVQJXI1WpkCh9Qgxix+ByOGQOxdvA
	zM+Qt2D0skWsY3gpQSakTrfv6r0ijKIygsMj24lPgFvEUx0mXxqOQQAgenxhTNyNYRi2G58Foyh
	vSqb9T/0UsTdCjEscqJgSowD1CpD5hTuOmXAwA/oYTDa207bP8mQWg3NNhYF/d09sEv82YBVvmH
	f5ErDmLc5m+8WHSH0K6fTt0q8cayHUkGxbMR
X-Google-Smtp-Source: AGHT+IF95Fx+kdzXvOEQIuN4oN7RmOOKwm5acciBtYGnI/O5+u9w/LJUzrtkBGQao587PgFtViqHCg==
X-Received: by 2002:a05:6e02:b2f:b0:3d5:d743:8089 with SMTP id e9e14a558f8ab-3d7ec1fd1fdmr31616045ab.7.1744382273155;
        Fri, 11 Apr 2025 07:37:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d7dc591b9bsm12948295ab.60.2025.04.11.07.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Apr 2025 07:37:52 -0700 (PDT)
Message-ID: <87fcae79-674c-4eea-8e65-4763c6fced44@kernel.dk>
Date: Fri, 11 Apr 2025 08:37:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] fs: gate final fput task_work on PF_NO_TASKWORK
To: Christian Brauner <brauner@kernel.org>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com,
 linux-fsdevel@vger.kernel.org
References: <20250409134057.198671-1-axboe@kernel.dk>
 <20250409134057.198671-2-axboe@kernel.dk>
 <20250411-teebeutel-begibt-7d9c0323954b@brauner>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250411-teebeutel-begibt-7d9c0323954b@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/25 7:48 AM, Christian Brauner wrote:
> Seems fine. Although it has some potential for abuse. So maybe a
> VFS_WARN_ON_ONCE() that PF_NO_TASKWORK is only used with PF_KTHREAD
> would make sense.

Can certainly add that. You'd want that before the check for
in_interrupt and PF_NO_TASKWORK? Something ala

	/* PF_NO_TASKWORK should only be used with PF_KTHREAD */
	VFS_WARN_ON_ONCE((task->flags & PF_NO_TASKWORK) && !(task->flags & PF_KTHREAD));

?

> Acked-by: Christian Brauner <brauner@kernel.org>

Thanks!

-- 
Jens Axboe

