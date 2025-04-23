Return-Path: <io-uring+bounces-7661-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CDA0A988FD
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 13:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2993F1B65FDF
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 11:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89EBD265CAD;
	Wed, 23 Apr 2025 11:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eCrIMFQv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79F7242D66
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 11:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745409456; cv=none; b=Wk2kaN+C/jEXJIePPJdk6uw7YS9xnrayd24xMenFLZHbRdsY2LZLiCPhoiUwAlzK5fZwEcDSmHITsM8gn3motlAwKz4ex7gtTh7XUeVDHESEnrd2cBydk00aXCoYKgMt6TixHtLnT5FmmF8YtgbHZtD6cLI8u1rlpnP4jjEbfPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745409456; c=relaxed/simple;
	bh=8pUvAJwCxwEMGSTtCQmZuFNMDNaMudxQnPzv0puwZjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N9iHzmvVfZeZ4Qx1JAoW1ZdVhZN43jY0/5OcXMv/w+f+NH0488qlzYXLe38dW1uUjrf1jTlJ9+2Hx8nWNdPVZsN9TtSacXeMHUSaONrsHSLlTnQ+JgmEiHMXgYs7rn8iqmMia6PnIy5AQV33RIdCFSspJyxLu1sBmrIIlCchcRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eCrIMFQv; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e5cded3e2eso9958203a12.0
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 04:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745409452; x=1746014252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sbz9IRA136DhY+sErg/R5oqpLjVbQ/KWMARsBFA9Ds4=;
        b=eCrIMFQvdHbocbUvKHEmNlkXB6DItNF5icCbhtGb2y3PD8vQyYnDDnd0ZXYE67Zbx4
         jA7Ww+95ty+gBOPLu1dY7eXasEUuOOq73DfFIV35HGsb6/ymBew+Dj+jm8zkqOiXYLYV
         wdh595233KPWIsYzzv7NKAZ9T2oNowe1yCFUj8gJyjf9jW4d2MWX7iyn77R5npzjXcmm
         YQ3tMIO8T0IiYPiIn/ISlMEktej+ZPhQNggYZ5kK6wG+o55m4Ai5egIZNBf9XnYvqbnE
         zT0X35I4QphAkqy2oUnXTaeFNdRkYKnmrHZuW5yDLvmp9A56eqPOBUDknQwDjKLwFpVJ
         lG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745409452; x=1746014252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sbz9IRA136DhY+sErg/R5oqpLjVbQ/KWMARsBFA9Ds4=;
        b=j517ZrDCeU/LeiAJ3mL9mCPLk2otRJOVJQ7MeR9d8yybqLUgjYbKv7dxBckR47Pclp
         vNTMfIu/oUg7Zs0qsySya5jsyKG2jl7XvSsQC+4BaL40FT3GVorKTCoxJoGu6Y7zDm7b
         fDQza3llG+As2K9fJZJpxyv2F/4MdFZ5gS+2R/RCYb6gi7UoFuT1oKcxaBUVeOEZhxwx
         +/UJ840Q3PUYyUoG99mbsuNUQ8jWsv0sJCuhS/Lguavw4llE8YmO2B2uywwFTTcAP3x/
         VRBg5ho07hWvrwlQbgBLI46yWucoX6VKUuJGLsS13EF18gdInEImsbO+NdXOZ4qGrId7
         k9UQ==
X-Gm-Message-State: AOJu0Yxip/Uasbh287uikYTakI6qMNAdKo5LG+zlZBt8w6wdtVuzk+nk
	YBsPJkbEmETrWEwDGktfV+a+/mIVeqAjYC5vOqCRpZ7sdT/8iK51UWmbdg==
X-Gm-Gg: ASbGncviwrmoGO4+5gxxZmQl65kcZB8W1My07pGmI1aeyuPO8lW2qlHRdYTMWVL/4zD
	ucx1ER+FNT8fz7s/Iw1D8eCCU51gyJZTfN189kn98hOwxrZkgoJkdxViPFufpZQYp13GzAk12eJ
	OwY3zMVboMReKoKWfpZ3fScSEYXQyf4iJ+9q//5gZ8RymhI8op7b+HNBzlp7FJw+hHaXFyr07gw
	uWc9AkAavfr6RJS6kUJHklf9dNBLQn7nSy9eRaD9KTyWm2gj1gY4qUNE5yJsJdTSE/xAmpYOX7h
	yfubC5amLcdDLJx9+sb8kaik20fOI5qi3SJQOmFFVS0vNo6QtSdq/NY=
X-Google-Smtp-Source: AGHT+IFTMjcqqNWpEpv85fdQpmEDAeWlREaZrSkbK/r1pR8V9BX+/auPeFOxpGFB1cIB8TO8WF4jhg==
X-Received: by 2002:a05:6402:274c:b0:5f0:8551:9790 with SMTP id 4fb4d7f45d1cf-5f628546063mr16051631a12.16.1745409451520;
        Wed, 23 Apr 2025 04:57:31 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.217])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f6258340c8sm7350983a12.58.2025.04.23.04.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 04:57:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 0/2] huge page support for the zcrx examples
Date: Wed, 23 Apr 2025 12:58:36 +0100
Message-ID: <cover.1745409376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 is a fix, followed by adding an option to allocate the area
as huge pages.

Pavel Begunkov (2):
  examples/zcrx: fix final recvzc CQE handling
  examples/zcrx: add huge page backed areas

 examples/zcrx.c | 58 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 18 deletions(-)

-- 
2.48.1


