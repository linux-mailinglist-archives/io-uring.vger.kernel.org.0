Return-Path: <io-uring+bounces-7685-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9168A99922
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 22:04:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCCB41B86D9B
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 20:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF97E223DFB;
	Wed, 23 Apr 2025 20:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U8OZlwgw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E54139566
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 20:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745438665; cv=none; b=LQtojInexjm0Re57QO8p2PeH7qemw209DeYsQjvOt/t6sPe67HM/Tj/2hkKx6Duefo1Qn43Z8bSxHb1QB43yXe2O5+sLxhB583gccMc/p842spM6FNBKxG6HFForvJiIplGluaOidJVocsgv/XwcnY+HkBTNwUZmzFLSQa31TW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745438665; c=relaxed/simple;
	bh=5B/ytQIN8u0/xUiidsYCHXvCS7SNIOfmw0gJz23kTUM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uQS4ebPaCI4c38USoEz5NLmC1rzEyZCLpqI+EfNZRajbl7oL683x4muT5qKRRxwrXMaNMl8PZxDE9QCxWqHlcVIynD1hGJFpNeMTqxnTWJ3jwTrmcibb4BcGrbG4dVdV26EasfFiTAAH5SFqF6oC7DT3f/RM40bznM1DTLqLczE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U8OZlwgw; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-85e73562577so22941239f.0
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 13:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745438663; x=1746043463; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+gfFJFRzMkUCxMhAHqd4T7/JPVWKKvwfUYLSZUhw95g=;
        b=U8OZlwgwy0i99QqYGCvMs6Gptptj+yd+KbqkwTcyGMV0k1C5S09SQibXq9Mz+YRk2t
         +mXaYkK682A34EuXkUMrG4o2rdjsLEDGQbZ7UjL77jSlpOaXb1OEOoBqp/L4yAD7EPYY
         kO1VTZ17eFl5fCEfGT1egRDDRssJGFwxbD3kTA4YJoWXXcoFpHRoYiSEEsDNJZg2WyW6
         zFgEaSKRm3oevMoMWr8xBLzY3mDBoqDeBxspPt7InWaprl0eZMsvTfWFFOe+98HEwn+c
         cBVNm60ValvXDlbouSc1iZ1Dat8S2i236a7Ecg7wsV8X2xm/njV+/y9mqceZld6oCVZQ
         QLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745438663; x=1746043463;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+gfFJFRzMkUCxMhAHqd4T7/JPVWKKvwfUYLSZUhw95g=;
        b=p+bQyMI8iFR1AgPT0E8aldRSe+YB2HEvBrfa9ixlfZcCXBsZwhpPZIrarKWmtDhhYS
         ZjsbIRH4DgaCPdKYDPQXVCQW8sfwfDsTByQ4jQM+9XNxOollci//a+/iOKHMLeDGET88
         p8upcUdYo1bifliDT+KvHIv0bzCe+E9lLlR1mtPVA4nR2DJoCZK4EJD3sM8WijtQ72SM
         zxqPpWpnh+SItxo2Aoag/szz+PPBIJSn8j8xQmdlkPJcWeqtjnwMrIeZtmVTNMk51zEw
         vsO6NixxqX0SRh8DCH4f03t3UGjX3rm+qPx4l+8xzn5V2+3xBZTCUDIHvdridSZiwJVf
         BTGA==
X-Gm-Message-State: AOJu0YxaZUTIHfNf3UCn1+WnbkO4fqhw0SvJ5KejNXPBbS6l2IU9FUD6
	lno/ovc70y5l7DS81uKU99lOj1cJpyBdhgmZF350IEVHB2wR512VdGpHSMazyN7qdx5FESQOx48
	b
X-Gm-Gg: ASbGncu6ApEdAdKgpryKAvhDyBudjD2NMURUnU3QWK2jAOsCjuqi8SJ53TDUWfjgbeH
	fL76sEr2P9Ctw9LEMG2rqpF1IDQ1DtLDO6iGe5U+XrppmJ7pmCV8Vt1oR8GYqYXFpKVDgKeBn9g
	a5IVuQRL/EQG+fs4AJSX/HnJTs/2XGbQH7rzTGlSGn4W9qV3K+xMYEO699i/e7BzZ8OwZnANXaQ
	54aq0VbB4QOMo4lS+EsNkdLJtWonIcNafNg6z6y8oTtOsXAEABsvNNdlnfduSglOO681y78PFcO
	mMn7wAmQQV48ifCtPXw27DtKhl7fsh4=
X-Google-Smtp-Source: AGHT+IGMNN5qwSbDOrOd69QlTEqV1pZQNFa8l1sOkIvQAc8vXbNi8scVyRFl7bpBHPBpLy5JKhS2VQ==
X-Received: by 2002:a05:6602:36c8:b0:864:47be:b560 with SMTP id ca18e2360f4ac-8644f9603demr32527539f.2.1745438662879;
        Wed, 23 Apr 2025 13:04:22 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a37cb943sm2933913173.4.2025.04.23.13.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 13:04:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Cc: gost.dev@samsung.com, nitheshshetty@gmail.com
In-Reply-To: <20250423132752.15622-1-nj.shetty@samsung.com>
References: <CGME20250423133628epcas5p2b4752a672a64bd2f1392f663a284f9f2@epcas5p2.samsung.com>
 <20250423132752.15622-1-nj.shetty@samsung.com>
Subject: Re: [PATCH liburing 0/3] test/fixed-seg: Add data verification and
Message-Id: <174543866212.541287.8947014567777273902.b4-ty@kernel.dk>
Date: Wed, 23 Apr 2025 14:04:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 23 Apr 2025 18:57:49 +0530, Nitesh Shetty wrote:
> Write data before issuing read and verify the data once read is
> completed. This makes sure we are failing if nr_seg is passed wrong,
> incase of offset is present.
> 
> At present test fails for block devices formatted with non 512 bytes.
> This allows to test 4k block devices. Some of the corner cases such as
> 3584 offset test are not valid for 4k, hence skipped.
> 
> [...]

Applied, thanks!

[1/3] test/fixed-seg: Prep patch, rename the vec to rvec.
      commit: f9f133fd9edbdd8e47b06739e0a2e4fa8da9c721
[2/3] test/fixed-seg: verify the data read
      commit: fcf273bbae7082fb6413c87c21f1d982ee6b9140
[3/3] test/fixed-seg: Support non 512 LBA format devices.
      commit: be5f31287825eb1f81813a15a28989b27627ac10

Best regards,
-- 
Jens Axboe




