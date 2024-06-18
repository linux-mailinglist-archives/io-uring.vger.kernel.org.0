Return-Path: <io-uring+bounces-2250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38F8190DBD6
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 20:47:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0D9D284735
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 18:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B3A14F9E6;
	Tue, 18 Jun 2024 18:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="17XPRY9q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A341171C
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 18:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718736420; cv=none; b=G1NzUHG8AnPNM21eM8R2u/KE6kvWkZ9ViJeOqW+7zIsnP1NTkUW+cUxr1hbHBIXaiapWXmfwR7lmZbJjh/0JnPSEvqIcHgi4kpMQeyYqt6gWeO/f1bY94eg1Oc/V6h3v5mL+nMaphmLavTZLGKJ4CmN35KIRqFYVVulpz0vSgoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718736420; c=relaxed/simple;
	bh=qc+1HGFpfJL/Wknb4BblstV9QAFxrOc224wL7UUT2yI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Udt/CuA1aZX3UsO6nqbGhuGmN6p8ZimtTgyaSh5eLpGTL+2MJn41Ys1W/1hX+1Xdr7Jll2xueCRww4d8y9dbXzp4KgVQI3AjiWAr2uegBI1rno3wFBqsUHvtzLkvBy3jhqJcpmauXGw544+3WirPTBc/jmmlu9m0DkY6qqiI8dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=17XPRY9q; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3d1b6b6b2c5so218370b6e.0
        for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 11:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718736415; x=1719341215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gPWnOQT8PxiAuIaOunKL4XepfKhGVzy+4mOjTdDY0sU=;
        b=17XPRY9q/551FDvTFKJ7dXKSgQ7GwCSkOiGS/hqI0CbktvdvOyInJufhBe1bsCheUm
         zKfrU6nWhFuthW7XyOfqsJXMMMfvdQ6J1jW6cY6MvzjHCAMvEJFw58aYhEhNFIjC3/ct
         Pnernqct0BzD3e7pEji61pHFM7FW+RwUMtBYUgbc6Z3I7eeobGjRJdWYX/X3DEDdbTRt
         pYg2a/DaM5uIT1aKzxOQXpLU9LAUsE0RsSRFfRtJRhS5GXmH7f5W1gTHLHyc41uzC9X9
         iADSjbSVuizBmbPSBRMg/fAKjFSlLCTRuyGJHdLpmfvf09kVcqiRLs/gC2uNp7hiyIAm
         4uWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718736415; x=1719341215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gPWnOQT8PxiAuIaOunKL4XepfKhGVzy+4mOjTdDY0sU=;
        b=JvFXWUt+xkM/Vs5AoGRSpXh0ILcX0Efs6TC0oYHK8MeMr9AUTDBhnmYdmgQzXQiMzU
         kU3Mz3PsHoXNN6sRxa53b13rTOEkQXO1KeudG2Mde8fWQPT3yXiVGTO+KCj0s77SC2x7
         if3YztijHD+0rJTyZlDyE3kdX5c5Minu4vivMW4zbQPeXP1VOrrvIoVHz8zkryq3dHZd
         ad4fCFcbiZnozNLaGMm98qfeaSomfV+LAeLE4XP+6x2gMMFCvP33ac2WL7oDXXZWpXh8
         YYLmYZ5RKjfUwT8Alzh8/Vu2ncJo4aQ+gpzjf4xn9iQOdxqnstXFxv3l/Or8QnGs46LB
         60Vw==
X-Gm-Message-State: AOJu0YxK2IJwzkwQ8vnM6DVQS+xlCv55yohxsIUutHDYbrK82n6ZRimh
	WB84P/n8/ATBaSIgqV+Pbtg1C/0UewlbIlk4W/CDbTp9JUuRZbPx46b3/s/X1rYMsrmP3Ma9uWG
	g
X-Google-Smtp-Source: AGHT+IH4mL3TXwUZbNLMx1+MK1cHY8CQPbkJCg6lNbuesReXNbETPB1dD6b2FpqPZHXGasIS14SVcQ==
X-Received: by 2002:a05:6870:6490:b0:254:7dbe:1b89 with SMTP id 586e51a60fabf-25c948c42c8mr723055fac.1.1718736415026;
        Tue, 18 Jun 2024 11:46:55 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2567aa5e68asm3297475fac.30.2024.06.18.11.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 11:46:54 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH for-next 0/3] Misc fixes and cleanups
Date: Tue, 18 Jun 2024 12:43:50 -0600
Message-ID: <20240618184652.71433-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

No real theme to these patches, but sending them out together to make
my life a bit easier.

Patch 1 is just a cleanup.

Patch 2 moves io-wq work struct flags to atomics. Again no real reason
to do this outside of making KxSAN happier, but it's prudent to do and
has no real downside.

Patch 3 cleans up a fix that went into 6.10-rc, removing a
__set_current_state() that is bogus and fixing up the additional one to
simply use the usual finish_wait() helper.

-- 
Jens Axboe


