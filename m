Return-Path: <io-uring+bounces-1347-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7189F894481
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 19:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2E651C21238
	for <lists+io-uring@lfdr.de>; Mon,  1 Apr 2024 17:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB2D54D9E7;
	Mon,  1 Apr 2024 17:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HS+N/XM5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16FA1DFE3
	for <io-uring@vger.kernel.org>; Mon,  1 Apr 2024 17:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711993991; cv=none; b=AX9T1p35h89zmAxWxJVNRuHs8CnsKn1iN5dbPVVS6QOGnb4PKysW3ngQm8g0fk/jjJqkQfPX2mxoUaSUFkKenpaGS8v1m2rtSrG8JhmsFHsW0RSeYI24szYp7QJuSM+7H7I0vY6mVy50a8Ojzoa5cb2DKPwnupzIcq3S8rQfgGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711993991; c=relaxed/simple;
	bh=PAXX4OGGvT6wZR27kR4gaCEP5WIDA34SlY8TNLf1qis=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=b68aVJfQCHd/T5Gx1Ps6ekUv5g85eabwPsvs0Ddg5YvHtySPDxv9GjRfJ2mrRMHcuhIxt4iGQi5W0KsZ7CRP5XmBTYOxEDpmfKe7xUOQYqOfjpbJZWZgCKKf2SOUjGq8VIJ6U2VkuNLA4xmr1NBdydVGUT1MXYejoNNIUIE5y/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HS+N/XM5; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-369c4242a9eso600915ab.0
        for <io-uring@vger.kernel.org>; Mon, 01 Apr 2024 10:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711993988; x=1712598788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=SU5IWgM4tN24BeeKxyGK/yKBN/LPah5gLfQIXNq7CTg=;
        b=HS+N/XM5hsixi3R7SmoDLEMJfKW0ovr5z3iInPgm/LTS5bOOHzXje2G3XrBe1mM1JV
         9tXy7q8328yTz+Ok+fuoGPCUi3Jog9fvdPjn7id99Xjbr7xw+qDNbijomEb8g1Ov7vFD
         FlPEyi8+nl5a9AyA8SrwIbGH01ilfiAb25jaMcEFw0YeYbhzCdNJUP8K4IryKcPUW3hD
         +1q2axwUTv9QpbPggLiaZ5UOVVwVUO1cjziSDZavEIfc0RMYyVHgYzciDhojMJ/M43Ez
         5iKVLlLT7pXwEVLLPa6sXmDK01JsnFuCptHAHNtchdn3RJ2S3QeQvJdJv3XFNEub7Obm
         nntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711993988; x=1712598788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SU5IWgM4tN24BeeKxyGK/yKBN/LPah5gLfQIXNq7CTg=;
        b=K836J7L1P6EibL0/kqYvbvUugn8iaMNjJQoOhxL3v+Bp4UFYZsaXgCFowx3YvfaCXg
         MbOI4trhuEjEDuwFoYb6sKq6hJi/9ugxczzuynmi3POpQbEKkjsew1yF7KF/ddjzQY6K
         kSkeh1M18ZwNz3ruVg4UylNUDnnAOi7VOr2K6LkT/yiJcmz0e53Nn2u0M7TSIOWzTxyw
         I4m/B+QhDANOmzbsSVY2mQrrwfGHYTU/dJYLpPBjtGz9SxiS3yjvyIyXcLHNPr0etHOr
         uEaAN7S1K2sUSBOxmzhHS+0nZQlrJ6uuTGRJjQpoIbw8DQcPV6rwnQnL32JqKOT3NKPG
         KDcw==
X-Gm-Message-State: AOJu0Yw2pTLkRE2HsBAbOedeTtnX5wGVFttbn0lhP4Sboq++4RCE1Nst
	8DNaV8TdQ3+T5O0JH4RfIYUm3MqOCOJpCuouHjp3pi4KAAHHMu5jzKmt9CMZxRvEqtWOdHbCSoL
	B
X-Google-Smtp-Source: AGHT+IGVsTHIrgHGG0VfcWmu349iiu4pjRERewifYqrReahCC/LCzUpFX7i1U5nlzkWTciSg/qM7xQ==
X-Received: by 2002:a05:6e02:108:b0:366:b0bd:3a1a with SMTP id t8-20020a056e02010800b00366b0bd3a1amr10293295ilm.1.1711993988354;
        Mon, 01 Apr 2024 10:53:08 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id gm14-20020a0566382b8e00b004773d7a010dsm2663829jab.76.2024.04.01.10.53.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 10:53:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Multishot read tweaks
Date: Mon,  1 Apr 2024 11:49:14 -0600
Message-ID: <20240401175306.1051122-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

We can't properly support multishot reads unless one of the following
conditions are true:

1) The file supports proper FMODE_NOWAIT
2) Barring proper FMODE_NOWAIT support, the file must be opened in
   non-blocking O_NONBLOCK mode

Without either one of those, non-blocking retries cannot be attempted.
And without that, it's pointless to support multishot reads.

If this is attempted, fall back to singleshot mode. This will properly
do the initial CQE posting, but will not set IORING_CQE_F_MORE as we
can't reliably perform the retries that multishot requires.

 io_uring/io_uring.c | 13 +++++++++----
 io_uring/rw.c       |  9 ++++++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

-- 
Jens Axboe


