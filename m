Return-Path: <io-uring+bounces-7567-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 37EB2A944E3
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 19:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC2661897A1E
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 17:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C10013D8B1;
	Sat, 19 Apr 2025 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e4aNcBg3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABDD6F099
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 17:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745084766; cv=none; b=jqcL4HSbfqv7Mzdl4da16XRHNQHJwAlJOqz9hkzw8gTqhcL3t0WJ9I20lo/zBrNGcbW15CH4LvTC+p6c/jMBTNBN65a0mjabLEh3j1ZUj9KI0bHJoiP6jOgY8ymm5AYcqMGXQjY0Yf+/QSWixl60mlpFnlRd8AK1tvK9hhwxGUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745084766; c=relaxed/simple;
	bh=LqKLc95mgBB53QWDZ8ZPoTqolxdDPW9rbibtHtaUN+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h9NXn9MSfSsxpubgENbPkwczWLEoamaVS8+yrur9QBBj5MOTyrjGIwtVTQU72G7vFgtSIvtEIQ+IBxtXASlhBbwDfLkIK1Q/RaGIvky6eFwDJvHcRHfvUIf036sJgo+1OdtrulgCgnzNwvGshW18TyWNk7yV361TJ+JzXILni1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e4aNcBg3; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43ea40a6e98so24268685e9.1
        for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 10:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745084762; x=1745689562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SXCqVPkKKJ7Ydr2ptH2y/fqLUwND2dZgFub4hmlmzYE=;
        b=e4aNcBg3nNqUw3V70wutmT2lj4GSEXj6b1nP+xjI2zfObRzLMRC559fVASNVV0A2nA
         +cXq9YvjjI7sxLDf6BCzB+O1z8KGYo0OM9gtKf+FKkOoHZmF0SOtdWESw9Cz4l5Iv0HK
         lqRxNKdoobhZst/nSZrIQrtM5UIET4txkMRXep5AxR+cMv3WT/yENLBtF5uyP9gmFHdq
         ugXs1Haz2suDrXnuRTStbOs/gTeeDpYH7JFOdHN+3ryciCmgf+SEOY5ywhy2s35kkpXP
         wORq0CZ5sNYQO4UxyQUMEvZuN5ovqGAZyml3OtnhmytkpqLcMx/AY4QJ7wKiAlfhHbNp
         m4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745084762; x=1745689562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SXCqVPkKKJ7Ydr2ptH2y/fqLUwND2dZgFub4hmlmzYE=;
        b=XSHolBf+4yW0q1nQBjf3mfLvuwMbQrdpDXr09MhCtyJG+LPxPDV7Hpyp8+bHklLKcI
         5+ISw2hYuxln1N3EKYKygu6zM6LXg2aorxrBVfCmVsdVcqU8zwMZ7ci4k2cXta46V7Lp
         C0pj+yV/Q4In9ESX7SnQmsZRbXETDj9HMPCTW/x1q0wtTbn4ORIKJ43g9PiYG970qkU8
         7NEZDECdRNAWdIlmsDUV/AKitCOe3N2FbvBy6qrTRZcADi3RgrZfi6LDYgwP6Z6v8sJa
         xMbOv261lNpIxIS35259j/ysADqxi7JkVy1zAWdOl2ErTPwmyUWfdkEQisS7H+ZeSiaC
         rGTw==
X-Gm-Message-State: AOJu0YyxV60IrKNB9c0cDRGaUfd0MaVGeWo6BlZTNPdJ8YTh2Pyf2NZE
	IDi0NnyTqabgfnlsqZtTkI7hpbYPF2Va/5JDtrG2Yfh2wZiPuzfdxdZAUg==
X-Gm-Gg: ASbGncsbctp+y9Lf1HX5EgBNoQzQks+nHdWjVKeqIrBFDjCJiAO2O4qDq0CFvsyCMKl
	ITH/CCCYSCEeM+6c5+uiAC56t1TeUQowGSq0aSz/aSpDSkwOiWAAK8qYT7KBmVeopFkjNGEtjQS
	1v0nluCaGkpeowX5gjGbvNSrY4o6cVdqkiaGAE7xQYx97M2FKLvXBJeY8/ich+ncQ+B82CnLRG1
	GKX0yMOM0tKKDe02FsGE5j59758e6Nrpa4FPJt0O8ldSxLIhnXv8cI+uhEdhJ4bIvRD5QrelR4q
	dEOv+BNgNPCbSrX+WCDQIzXVBHyZuzyUG0diUO0KWdoQD8ngfVVauA==
X-Google-Smtp-Source: AGHT+IGM6jMQ0NEuv+eeQha2R+ooFGoONlW1QrNlu35MZvAN6xtefNY7CIo33f/lMiYxQNgPTP39Xw==
X-Received: by 2002:a05:600c:510d:b0:43c:f78d:82eb with SMTP id 5b1f17b1804b1-4406abb2066mr61343845e9.15.1745084762198;
        Sat, 19 Apr 2025 10:46:02 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d6dfe2esm69632785e9.34.2025.04.19.10.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Apr 2025 10:46:00 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/3] registrered buffer coalescing cleanup
Date: Sat, 19 Apr 2025 18:47:03 +0100
Message-ID: <cover.1745083025.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Improve how we handle huge page with registrered buffers, in particular
make io_coalesce_buffer() a bit more readable.

Pavel Begunkov (3):
  io_uring/rsrc: use unpin_user_folio
  io_uring/rsrc: clean up io_coalesce_buffer()
  io_uring/rsrc: remove null check on import

 io_uring/rsrc.c | 50 ++++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

-- 
2.48.1


