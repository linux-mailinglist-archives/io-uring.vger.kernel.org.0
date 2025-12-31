Return-Path: <io-uring+bounces-11337-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 60FC3CEB035
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 02:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 91BC7301A1D9
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 01:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95A481A9FBC;
	Wed, 31 Dec 2025 01:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BlmMzXzc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09FB189906
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 01:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767145865; cv=none; b=f5hmW8pEoDXAWbG5L89gE9Npq/AUQwnuXlVh09ZZ+NtsQQpqBxBLPa+ZJyaAq/P9KLNFtz9R75flXbrC5MIS3chLFDv5A6CM3RPnO6/YgudVcBimWm7yehdnvA6La0lRxPg7GTiJQAZqhjjYCfAdsbDFgE6F9AtigskcovCa1oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767145865; c=relaxed/simple;
	bh=6Rqu8bNjDfz7V76quRApGeOvWDaXvbO7VOppEEJfNBc=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=trC54vXJrb48v4Xlp2jiRXZRQPnHnyOplWpOEbJwxQA+nwLw6f0A4af9I7CSxN34fRA+Xe4Nl0biy5aEbK6MKXB1PlCegFrlAOQnZXF75Nk8ftjcBkMPm1Y8vbdQt0jjx3V2xnVxEj0IXL4W4z++BcYSbdn27u23WSyK81MWnew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BlmMzXzc; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-450b2715b6cso6220906b6e.0
        for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 17:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767145861; x=1767750661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8SuoU27L+fsbCL5CgXdl2telrpyeGmfbQJUue0wD/ck=;
        b=BlmMzXzcjUXrX7XJQEAzv1+RW1GgGHjOSx39hkbcsq333MC12SYmPUR/DkzvCo2slX
         t2lm8eAJZqzuM4RWeP1nn0gJs+DLEe/SR2sEGie0/9IONi9Aw9Np5CX3VQm3SJjiCkv9
         mwz7tpnUwCdOe/D/WjcYC1p7sMREGiGaoa5xdJaGwGxmcbGoadMRZ5hyNvoQ+75jbrCT
         fn8dj3sVxHI2tzxmyNAr10YB+n/ICGVUPTAeWCvQ1UqovUe39vXMPz0/Ypfr3G1VNNQ6
         n0Mcdqd8GTjQTEcxJ99n9sE875tKrPhRSBdFwEnz6pSnrzs+IT867Poq4SqmmnAC90wU
         DDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767145861; x=1767750661;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8SuoU27L+fsbCL5CgXdl2telrpyeGmfbQJUue0wD/ck=;
        b=dv5T77ZD9iTUcy3GN+2RdVj+hq+tx9ztXbYmfMIC82tUbfoqafkxNve22K2UU/onSE
         6ESiNuVmZbDuVIT9LdZPbxXDNVYU/G+UIHnLeN6L1tF6UjbrlQv1XOOI2eAtWuVZg8CT
         b2M+dbUruoEDRPgJ0CoTM91myRwzS9oVL8C4gqEOGQmN1SsrJ2OTJCpIi2SB2zOzYXVL
         WvikKuLgCC1Vl+52lMhHmzOfuxPj5sO0BbK1ZXaY/XbY/qb2UmPY1DRZGEvYAkI4ivqF
         b6ICxtriisBHvzsPFYm8RofBUd/A09DHWF7x0ogLycVEt6jt6cDvlq7zJZI4DJrRSC0A
         jDvQ==
X-Gm-Message-State: AOJu0YwUk+5bSgSbXCLKH7Od1M5K6qVOnbaqoHX5qt+Ip0kwuXu08zS+
	cobS+nd/VBIVwNYi6SsYo7aRXeZw875QYyH9G6pRh2xZf7rT8V4ZNNLbHEUDXpOzGNwxJxQo9qr
	PpMur
X-Gm-Gg: AY/fxX4p/0jDDd60XTc1nE/hQ7qEr4GftK0ygtyArB4Kk9Lbq4mRTfXGm5lgy/4opKz
	BNhtZ7ZsNO/lsX+2vLjbfc26Clm6xAQqhB+keBVuC+TCMvtzSLmCwuLWLkRypRFhVl2KMfsnC2G
	hubX9qL6STUupvoyeYTczi1LIHy8iA0bzvXGhXFcxH5NwbKzf1uzqU0Zt0BpFLVqm/00EqdneY0
	bayGGZXMRpB+EhLBf2qfSMdRXGR9GeIIffwwRShYZ01jhLWXQsgFbfTYQ8M8MAlZzt0zgCsCWDR
	NTEDWrmz9xqW61zKWuf9L+CHo4SYVead1XZaprmzBoLyvKYMvtgmPAppQvIiNHPooDuN47rbK//
	CPv9socw6zdGuefupDHtV/YkmszJS7qFd4cHpogdu3bYxMf4xSmddKFggYcJyTaaHOdbuipwvvp
	qR0Qc=
X-Google-Smtp-Source: AGHT+IFuVO2NN4e5glbTps0hcx9qJkSL6z+d81prsoeMUIUxhdBrrqlY8Pc/qRXal+d5c+crGW4+ag==
X-Received: by 2002:a05:6808:181e:b0:450:340:2693 with SMTP id 5614622812f47-457b2120fecmr15184108b6e.42.1767145860840;
        Tue, 30 Dec 2025 17:51:00 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc667f958asm23226244a34.27.2025.12.30.17.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 17:51:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Alexandre Negrel <alexandre@negrel.dev>
In-Reply-To: <20251230190909.557152-1-alexandre@negrel.dev>
References: <20251230190909.557152-1-alexandre@negrel.dev>
Subject: Re: [PATCH v2] io_uring: drop overflowing CQE instead of exceeding
 memory limits
Message-Id: <176714585945.414491.8962578639891621014.b4-ty@kernel.dk>
Date: Tue, 30 Dec 2025 18:50:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 30 Dec 2025 19:57:28 +0100, Alexandre Negrel wrote:
> Allocate the overflowing CQE with GFP_NOWAIT instead of GFP_ATOMIC. This
> changes causes allocations to fail in out-of-memory situations,
> resulting in CQE being dropped. Using GFP_ATOMIC allows a process to
> exceed memory limits.
> 
> 

Applied, thanks!

[1/1] io_uring: drop overflowing CQE instead of exceeding memory limits
      (no commit info)

Best regards,
-- 
Jens Axboe




