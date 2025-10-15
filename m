Return-Path: <io-uring+bounces-10020-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90845BDEECF
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 16:07:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92C3E486392
	for <lists+io-uring@lfdr.de>; Wed, 15 Oct 2025 14:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD5C24E016;
	Wed, 15 Oct 2025 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="k7fyomyO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5106924DFF4
	for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760536968; cv=none; b=fpXSCHJA7OF8SGufS6Z16Qhwb7IkxizCwf0y70KVfEnNpuatu5FtyOffHv8UVb/INyHObbFXq7sbzGDlXKoPLYYNJkdOch9CVTPhbHBn3pyHYVbcaaapsj8bCauItb+h4Vb8CdT8/x6qL1/RaxdGr34T7loUM4yArYaZDAsWDtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760536968; c=relaxed/simple;
	bh=gl4PlaAA6VZTFBd4RkL6hvoWXrUm5lhEUJWR9qKwuo8=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LWNwNGMVBAXNw1t+JPUDtpPVFwPcAdTBVyv2gE3XiJA2uMQHaMTimxRXrqwg73IEZBGwA3lnsQGjVBi7Mx7F5DZJvwtQPfpwd69re1VL6QNeywgI93woHrFoCRj+wsoYstI+dMgdRrZnc40pxc4Zl3gRWl/2RexDo6nobyuZT5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=k7fyomyO; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-42f9353c810so27187235ab.0
        for <io-uring@vger.kernel.org>; Wed, 15 Oct 2025 07:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760536965; x=1761141765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nnZVjGbCPwt4KTHzYlDNOekbWMJbJn5nbibFrmCFk1Q=;
        b=k7fyomyOSFWsK7Pi7VdGtMvh4nrXXfnzPK9OtH09yeMGSoFyErFcKod16W0mqOdRaL
         xVkDlILsFs2YmHSIowiSjUp0UxKugfKHxSgTZLnnpGGc2/vxHkl3zmjNFc3MSXt13cgI
         w/vTqhgjkT/jO4V7r4sKfeGUMr1QltpFtgRz1lH3owxt8qwrK3UXZFTZ6jtDwq7W2noB
         etG6Bl1WdFBaDvhci7DVjdH3TMM1RVUSDDD7kIlzPlPSJ3S5f99n12fXsn0qaYJYS9Kh
         ouBxSGRgYgAR6eZ08mIZ8uOW748peK3RYKlPCRBfXup9dxKdjkqj8lMcgosTZ5TFtpjC
         h70A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760536965; x=1761141765;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nnZVjGbCPwt4KTHzYlDNOekbWMJbJn5nbibFrmCFk1Q=;
        b=vVvSVumryXleaIpDh2hQMRzcoydBlhI3x6OxyrfNckq2KAmnrwqbkHrk4Y688EH0ce
         GGoy6fs6scA+E0VeRN4424TO2Vd5f046IGzPDY5UpBhhli+YickNUkuFnX5fSlojU/ZL
         UlyIhzQMKdPFvj0g1/cWgeyi3HdF4522KeevEtgTr3EZzsuqj5VlAWjIorc8HvNVuxzl
         A4jC9fC7+I9VAYSfO68/tun+2I4QdjqYmUoaLqnZeYExJKHzkP4LeyLGSHw+5aPm4WiK
         OdIjCz3pOUVuqWv7FrQZ9KlniTQ5636zq1Q7SroyUWITWYmmaUsY9nxEuyP3t+1VOJNB
         M+dg==
X-Gm-Message-State: AOJu0YxGkX8oekwvGUkKINrhADztEYAC2gC7/95pWg2oSTi5PDJMXoyp
	P5nMvXi7zB0ucwHdgBvSWM/viWRBncCjIQVgOYRThRWwFxYnk29t51QPZcy3Gy6V2h6hMEldYN4
	2jfI3yto=
X-Gm-Gg: ASbGncsrDN30zRCqjK0A3VplbGFo6py6cQuDguidCe/ZETXXVTcuNtyCVc9F+Gi73+7
	9VFeqR4zGRkxW9czrul4ZAHnDVtPrPatTCh+lLyZdA5+7KeucP/Lemw1rBBFuWn/t78vf1iDO2a
	ZunqtvMzCAm0IlXjV6f1pi4xQG09Mk/I2FLctHyhv6gZQ3TTUib+MyUo921JZ5MG2uVPJe8qrZb
	Pjs491z8naMKDPhUNw3iwb3EKP/XIraEM4wcHkS+XQHnkLhfpZYWabn8H6SR8EYQa8ysKvoukPP
	IlhWCpnjZIEVABi98i4gNN3papUWz7ZZNdBKGxnvlmm8dc8Y7L+PRhc8zrllqkP4B+7I4zpK+AN
	H0ZybQguck4KTiXVOH6R5mVrnyvBlJbzqzZa8LGQF6y0=
X-Google-Smtp-Source: AGHT+IHIN5GqE45lQi8Ac76yAe05RaWZmhMgA4g3e8yiN9O13IIdhFqC1SjtQQ69iqqXGInRBGS2Ug==
X-Received: by 2002:a05:6e02:1c04:b0:430:b3e2:a981 with SMTP id e9e14a558f8ab-430b3e2ab9emr5297415ab.15.1760536965037;
        Wed, 15 Oct 2025 07:02:45 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f90386a49sm71031005ab.35.2025.10.15.07.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 07:02:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c75fe1c497a86daf2b989de48c13e02be263f1a9.1760529983.git.asml.silence@gmail.com>
References: <c75fe1c497a86daf2b989de48c13e02be263f1a9.1760529983.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix unexpected placement on same size
 resizing
Message-Id: <176053694922.32600.17715110340305736436.b4-ty@kernel.dk>
Date: Wed, 15 Oct 2025 08:02:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Wed, 15 Oct 2025 13:10:31 +0100, Pavel Begunkov wrote:
> There might be many reasons why a user is resizing a ring, e.g. moving
> to huge pages or for some memory compaction using IORING_SETUP_NO_MMAP.
> Don't bypass resizing, the user will definitely be surprised seeing 0
> while the rings weren't actually moved to a new place.
> 
> 

Applied, thanks!

[1/1] io_uring: fix unexpected placement on same size resizing
      commit: 437c23357d897f5b5b7d297c477da44b56654d46

Best regards,
-- 
Jens Axboe




