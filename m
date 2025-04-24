Return-Path: <io-uring+bounces-7717-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3970AA9BB13
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 01:09:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8455D4A2BBE
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 23:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F231228CF61;
	Thu, 24 Apr 2025 23:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="T9X3Dc4N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D8021FF4B
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 23:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745536172; cv=none; b=MQgr3s9Tetx89r58MACBOWF1I3/LR0qB8in0+vvyG6XjKJmgCOjUkIgRXANwyKVpOvVoNd4gJvYPXjLN19Jx9HRSA3E78JnyHcn/ZrESH4ih2S2rtZyHLxsw41skPjDb1EcpUotpX4DNnhxnWt/g+UWCRhB5m6thKLAWakF6JEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745536172; c=relaxed/simple;
	bh=LBAj35BXtPm72neUP6fWKKhui+OAcA6lM/hlfGmwp+8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BPgluVZzTZImnxU24EUUlpr8yMTm3x03StSaXUzVqBci2BwEfahNdt1bE0p0/i6MFSlrVYAUBLcNMGW2vU7DB/R5ntVzlGCzfGdErU6++p+IgPwKz7WxciC35eNJkRybXT+ilmD1VK05r4dSwZCfagQxvI40hx0rkRlqOGbRsgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=T9X3Dc4N; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d813c1c39eso13316315ab.0
        for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 16:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745536170; x=1746140970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJjb6BpJL6QKvLq7uGZb94kh5q9VZv1RBI7gdmZfS1s=;
        b=T9X3Dc4NEwuLh1xEy5ZOt9W45gZV8ejJw5cZKce6/nCy3xU+vWawF6UGjbfTIF7/8k
         eCxopddy1dqwLhxGpqZcF0g9BfMwjFOm8jDUCqYwSpGwCd7SOR7ooC6hmxM7PpXhyzcX
         m7ClQWBQoHTXIlq/K70mq/3EObJr4MoPHNcDD1BDBu+5QfIOMWsezPXof98/BcL5agxf
         jcFDBO3RDOqG9NMlcENP8655EDuAhsuycQyZCfFTQLd87HkqO5YKHXZF4Q3CuAiEFcg4
         M6o+FQKxSl3HsxlUwtLBqRRlOhxWGdTExQjuQyVbFgN5Tdxu94K1UC1GNPYMM72G69kZ
         8xgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745536170; x=1746140970;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LJjb6BpJL6QKvLq7uGZb94kh5q9VZv1RBI7gdmZfS1s=;
        b=GO48BAnsOO+bLivKWClTdUtYNRehaZ4Nq5hnaAbSJGILGHL5qkHBAOpRj/giUWkxp5
         FpkgiowiIfq/C2Lor30uYK/cK3S6UMus7/97nw0OcWkzZkXyqUQjhxJSP/D2sM8+T8Mx
         T2f07FTslwiD9GHcWt0VDS8ZWas/Fw/+yg65hHlxZ6JFd0zDb3wWDGDTh9wQ+wHNXLuh
         +cdecT+UFARUgaHs8f1RXe0QwFx89PARXvB0oBGLL/bOb4MxazMYBbdnFlStk+OcSj/B
         tz3LxEGmv5zZp0hldTnFlw6veskZJ+NlERkcQCP8Fbz6U0ts/HuMWB5zd4hpUT/ALy63
         maLg==
X-Gm-Message-State: AOJu0YyYHLGx6vJv6nBdcjzNJFpb6J8DfZnli4j8srj782fCJp1TPoEd
	tEzEbc9Temj40sBJqhd/fUbkzaLL4buB0IXnHVDmJ/Y9v0ApCCWen0P1LFtKOmA=
X-Gm-Gg: ASbGncv3JBeM4ri/fy6pGdlS+ooP5dCpLgj975gaho7/TtvQW1xYeXJ5sr2AuKzgPNZ
	ePrnSMxppHCpMQ7n/HysnDAO3DVvVP1dwE3DhXluoMv41fYYWteeUf7xXgNWvd+m02glpYAG95e
	wnCUM3HXr/1si9BA+yQqC2IZYGYvwUWQ0aBqlZnMDPWSNpQJX8RRtPIarqI9xrBnXn/JOxg3cZD
	6PWqUUFPZJ08SAg0yXy8Xe+a2/1YGhxRyDuqE/y/2Z0Ecgp2wRCuPklyZaJNQseoxR6XiV0sNAx
	XNu2Gk1QqOCX/lcovKd09csmfMvD8Vv90TMUlxhqD0M=
X-Google-Smtp-Source: AGHT+IFN4iX9Opo/jgx0my1Sh/OktR9LAH6c9SxUf0e5vgEkErJNPR+8tLRlz2/fbrwi+twY4MhFrw==
X-Received: by 2002:a05:6e02:19c7:b0:3d4:244b:db20 with SMTP id e9e14a558f8ab-3d93b5c8413mr1280655ab.16.1745536170090;
        Thu, 24 Apr 2025 16:09:30 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f824ba0ec4sm486419173.113.2025.04.24.16.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 16:09:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Haiyue Wang <haiyuewa@163.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, David Wei <dw@davidwei.uk>, 
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20250419141044.10304-1-haiyuewa@163.com>
References: <20250419141044.10304-1-haiyuewa@163.com>
Subject: Re: [PATCH v1] selftests: iou-zcrx: Get the page size at runtime
Message-Id: <174553616879.1018402.4580438030053211278.b4-ty@kernel.dk>
Date: Thu, 24 Apr 2025 17:09:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Sat, 19 Apr 2025 22:10:15 +0800, Haiyue Wang wrote:
> Use the API `sysconf()` to query page size at runtime, instead of using
> hard code number 4096.
> 
> And use `posix_memalign` to allocate the page size aligned momory.
> 
> 

Applied, thanks!

[1/1] selftests: iou-zcrx: Get the page size at runtime
      commit: 6f4cc653bf408ad0cc203c6ab3088b11f5da11df

Best regards,
-- 
Jens Axboe




