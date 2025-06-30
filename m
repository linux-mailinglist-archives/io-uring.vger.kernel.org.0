Return-Path: <io-uring+bounces-8519-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16282AEE3CB
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA0851895A9D
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 16:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B32FE292917;
	Mon, 30 Jun 2025 16:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="baGaX36g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4D1291861
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 16:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751299670; cv=none; b=rPgDWG/yxcKQ3obwoCJE3lCWZuawFakBErVyhxaxXxfuo9rP3Qv9dWEpFlfLpidv00zOynceV/Md0weF1CyEfmQ3iIyKKTdhiN801py4Ueg6BpQbzxcGAeQRtZnf4oRpAZ8GfBKifVL+Ej3vnZWI8BuEN7dReiihPd4BiuDGGD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751299670; c=relaxed/simple;
	bh=4lt695JpIRW+BF71JvRx3u1AaOuAf1WCxdLCG1xpris=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XU8C3IkoulKwtG0p7plUp9IOxEd9k5nlFk0twKl0uA07t2BvHMe6OotjewhJMXhvSRH7vFu7hf0qmsLf9qyHT3teCdpLq0EOwKk+u8WiKGD/gjwNHkphfej2YlIPuHHQFmb6x04wcJKyi2NFyVk7Njn68OmUrnUn67klt/Cz9XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=baGaX36g; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7481600130eso2930871b3a.3
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 09:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751299668; x=1751904468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HxJaG6Pcd+l/zo+oVVi2Nypp5/beyUSh/rM/AROZix0=;
        b=baGaX36g63mzq7axsJFQj2JJjvUPTxArM3IclU7Vla2zRZJwY9DpK0O1hKbQ9fWUAP
         ukHh2IHsrjk2GFRwJdsfwW0GSwRYmOd/akY3teUeBX8yIFOr6u6nK8Uflyc8SOC6qyMO
         Q78Pba6z3ndumpIhNSgXsOglPTn6DjkCOBfNTvG9yIfR2sqSeZr4/Pb59jqmmfPj8KV1
         p7TLaRu7xTpwbRZ4Ttr9c5M+E7eobt0/5M3AsYUmTvmLtPAEDudgRyDw5WTpxksOI0/r
         5+SHw3rWrkKBj/9DxEhCFgA08+XKm+KGgbLZVT5rejXhCWEHvMJWmLnHktQcm+/iLVl/
         fniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751299668; x=1751904468;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HxJaG6Pcd+l/zo+oVVi2Nypp5/beyUSh/rM/AROZix0=;
        b=R9SPv4AKIBbs1U+Q3CBGVij9VqHnHQTUKHYUftRnpN6B6ToEK2HSVV4YtZzY2EDTfM
         V11ezxCGncUhy6vUIYphOsP1yzezsJ8LNgWF9ke7HQZk6vRHzJH2gz3CBkBIwaFzzzkW
         fAD25I1i5ga9XIpfURTLdtzsmtRwXimT0cp8sga+J17RGXEzikMDHWtzXP9luKnJb9BW
         jibNRWtVJQSTb1O3fSjcYrhnEdPQL1vScpngJfRU/HRZ/flXJisOqfQzLo3xKTSGbkIc
         kDs9pFT8tMFSzIlj0OIxrJ50ivfZhAgfBnaxa5Le+X5sgASVkDTk203rHpLTaDs9/esu
         R4Jg==
X-Gm-Message-State: AOJu0YyUDdfK/Frk0XYm0fwWhobv/HtyIWljFjMLI431T7jobUbHLlCc
	4+YEeDD0aU71EuN+OTMN8pvEimFpCnM86SvbibljHL/AXq+sxNaiZfx6zJW1wac4
X-Gm-Gg: ASbGncuBichKS1DfixdkayZzqXVUFukrM6OTTBCtdrWbIdGHlNprLHQEvaKSYb8PaxC
	dfg8ARf4fsiPf1pC0UYU+uIqLacdUVhMOETFAwTkF0Uter2gDLgf/+FPedFCVj9kLBDdytQ04Dk
	zHoU+O1VBT5BOowMl5JGbKfsKOzgVfMc3OYcKlga4WllN+NR5nTCpVfz1mV6j7ZPK/ibf1LM3zR
	TeJ96JGzRH1JXeY54ZPlZK7bqqh3mjnmymCVluSp6Q7H+jD6FOCsVu26Fe5+tU7qZOFP8Rl/oMx
	CplHvwb8R71PWd1N2kbsOUypNT4voeqdKIDea0JrLKk4gg==
X-Google-Smtp-Source: AGHT+IE+GZXfzyx5iSJCrV77PS2PQutSnCYDtDbnkNN5o2YEhIYj5kfWRxfyyHV5eYePouXkM35E4w==
X-Received: by 2002:a05:6a00:928d:b0:736:2a73:6756 with SMTP id d2e1a72fcca58-74af70a7cd5mr17013205b3a.21.1751299668117;
        Mon, 30 Jun 2025 09:07:48 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e320fc3bsm7577870a12.75.2025.06.30.09.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 09:07:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/2] add tx timestamp tests
Date: Mon, 30 Jun 2025 17:09:08 +0100
Message-ID: <cover.1751299730.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reworked into a liburing test selftest/.../txtimestamp.c

Pavel Begunkov (2):
  Sync io_uring.h with tx timestamp api
  tests: timestamp example

 src/include/liburing/io_uring.h |  16 ++
 test/Makefile                   |   1 +
 test/timestamp.c                | 376 ++++++++++++++++++++++++++++++++
 3 files changed, 393 insertions(+)
 create mode 100644 test/timestamp.c

-- 
2.49.0


