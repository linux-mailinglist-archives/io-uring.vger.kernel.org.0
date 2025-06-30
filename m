Return-Path: <io-uring+bounces-8528-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 83465AEE55E
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 19:09:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B6887A5BCF
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 17:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5DF293B7F;
	Mon, 30 Jun 2025 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2+itUVw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DB1293469
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 17:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751303354; cv=none; b=RJEtPSlcQgsbvXU5VDUqVRnz8veB4vsk1SZcNAn3vsVa5klKK4iN3dEMCSieFreSx1D9usC1Nvahf0+sv3zBvioShmTjg0Us9ou2tB7fTTShLgo+HGwQ3QUruHCNCb7PrxvYicQ6zRwW3pEW99VkPASsqg0jTT5GNzrhnl6tuDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751303354; c=relaxed/simple;
	bh=Ne3+5n+KVL0tsAmZpcZX9OKrDrZYXgfPWL22pCR1kzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VTc644HeEyTiw0/CKTt4HXqxtRrrcxhf4Ax/hgefK58mv7f1lG9sbL3zcUnSZqT46Whfx/Ir7wUEdBN+6VqCcPUPkOpfLubg2wZaJzNBqlb7qNTQ78wlI4ipgucbDeTYZp22oZSNCT8oUQvSI2IBwyioB7JrczQDFOmk8XG3nW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J2+itUVw; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-234c5b57557so21205095ad.3
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 10:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751303352; x=1751908152; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MI04kBm25A1fDD8Hhss3Z0Nk9JbnVoN/eUMS+dpmOjQ=;
        b=J2+itUVw4zNIhnRMPSvilA6DU0eR81548Z2VxCVrWZcb9JhMqVmEasDnJGpcBN+O0m
         RMoKwJ6X5t2TMUyMxYcyH/kKpsicK/wGnkqhkpEALow3ebbvxUOwWHkmy3e9IFmapYE4
         l2r5OBxoBa+7nk0cBRRXs2Wq7HPlbbtiioqmj9ZGddg/ubNj1RgBt9XOJwYCzY6oERlq
         DMCZNvDCdcInOSLhGwKYCTprmhWBzLD7+6iAUNv/2BmhOUcXEbZURYErPqmip1sGF/JN
         0b/zAEOW7jknulK6FMxsTZvUVae9XWe+nZuUdeDeGUk+Dvminp1oY3sHxylARoLBcq0y
         ZlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751303352; x=1751908152;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MI04kBm25A1fDD8Hhss3Z0Nk9JbnVoN/eUMS+dpmOjQ=;
        b=gEofRyyd/3VIoVHUr9ZURojaD2VZPGm+62bpqkiH3l7auhWZd2iJUnabIKCedlgme1
         S054YfTisr2DOC/cxkYDfUwB5aRDRXdoMPf6GNyoSi6XBeeh+2odSnfxqwh4XUA0WCkV
         J+glmfLr2nnK0CmKIJizSxYar0nJFSMzAasIBxsIgupD4iFRJ9fYy9eXHFzsG180c7PA
         ok/TOHY/OTWtV9d9tkbSR8FyFVPaHAKgJ0FlVTHJ4MhqpsYVB/mlQImMzLB2stDIA49g
         v34rmObhO5+ro8anWUWUgmjPppyYce8NBb5D4OTv+D+/BTM/M2vE0xVFZP0XZ+W8d5pF
         1Jow==
X-Gm-Message-State: AOJu0YzzdGyl56WE6BwwtqqaQe+fB7m1SHx3FUW6Ehz7nrsvpotN/1Ol
	r5Z1UaBoOcSES6gR3+tUaC/3IkQLX9GCJExY+WON/yt6MpZF5Pgd4AqWE7ficDEK
X-Gm-Gg: ASbGncu9CjiTC9NIvUk3WxCl5hVZACAREtVD2Yq45VSgymUwRpL3rj6y4qndIU0fExM
	yUdEL1Wts7gwxNS6KakGsFPKECsdivfUAoqMjcIWOYAqpRYx9Moa4opxv5TJ8mt3W+06uT6aGME
	TAMpPGmavgR0/UNXWbTyj+70jaxVt30JfDdYnWTzik5J52lbn34QpgRjKiCsPUTVSvkdRVRUNjZ
	Rb/9ZsZFPbOIARm1QVdXTnybEgVdwE1bHGbDcVSpqwhrDPiLwwRDg8oZutj5Ld0GBl/Xmfq1ymU
	9t0Jimhs504J2jDvPUeB1OjQUfAmKp2ek6CBF9qXabaT+kYMhI6V7B85
X-Google-Smtp-Source: AGHT+IE4XBAvkTEZVL3EtdaGAeydpJWQpPgSY5Io+X70P9ZcshrT1lWb/1RKE8S+L7T7mFJAbHmRBg==
X-Received: by 2002:a17:903:3bc6:b0:237:de7e:5bbc with SMTP id d9443c01a7336-23ac4665e18mr219067775ad.49.1751303351968;
        Mon, 30 Jun 2025 10:09:11 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f2239sm89182395ad.81.2025.06.30.10.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 10:09:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 0/2] add tx timestamp tests
Date: Mon, 30 Jun 2025 18:10:29 +0100
Message-ID: <cover.1751303417.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add definitions / tests test for tx timestamping io_uring API. See

https://lore.kernel.org/all/cover.1750065793.git.asml.silence@gmail.com/

Pavel Begunkov (2):
  Sync io_uring.h with tx timestamp api
  tests: add a tx timestamp test

 src/include/liburing/io_uring.h |  16 ++
 test/Makefile                   |   1 +
 test/timestamp.c                | 373 ++++++++++++++++++++++++++++++++
 3 files changed, 390 insertions(+)
 create mode 100644 test/timestamp.c

-- 
2.49.0


