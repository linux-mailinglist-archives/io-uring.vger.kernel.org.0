Return-Path: <io-uring+bounces-7620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D98C1A96F28
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:43:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC8DC3A5449
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 14:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0FC28CF7E;
	Tue, 22 Apr 2025 14:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csPOa7Yy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818F428CF74
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745333015; cv=none; b=CCB2SRvSY06fzhEJFdPQBVSiYnmRo5TPEL3a4O+W8LdlIIwss3DPQPcwTSyqgKPjz22oFrqJduX8mpIb+V0+XsLRLww5FLEt+TEl57atPt8h4y3EhqymWHkx6rx/AoluqAlQRHxlv4Lbz1TsijFIBA+Md3byNXW6gflnc7KiIr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745333015; c=relaxed/simple;
	bh=FCA1qFckXpgdeXr5/1f8MN0bu6mhD16piPlvKHLscpE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OXlVIarQntuU5tWINRnmlm+gzl2/rUKJ+6CMJRqZl400HN0eJL4VFQXpk///fgkj7S2xWleG5lS6TgS/q37n3Un64LehKIQfDNBErkghjDSK/4wHbtLVNhYsIPCoWaMmgs9j98hLsUcxVHH9X9mIp81aU5T+5WfaqPVaOqBH87M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=csPOa7Yy; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ac7bd86f637so1141289766b.1
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 07:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745333011; x=1745937811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=x/y/b0lmXl08QtqaLBSvEVb2dHfd0dRjhy8lIGx6XD4=;
        b=csPOa7Yy7nrbrDt+TREieoizs3zTnbVjzMjN60olF06AX5YUNKm/jWu1B9YirKb2Nk
         thNdgahoEGw17DR47dg7fhJ8JK477VnLh9PQEFs446hQGl+05INPpkACUx6DPtpjYfCG
         9NkB7lixm24VXuTKlAlGuipPxKBQEVEyqGNg7SuL5h0mgOU9yjk9K1pEZT04TpUCFYjj
         xmQvrA5G+sPbM0hu6yI9/vLwihYgSfEJAfGc9/lrmpHfx5qbGbH/fmkVrYis/2bgPl0m
         GFWGEULq08Rb3rEbHqpk3TdRGmM74Ld/pUEonngWzzB3AtysDeSaStaJ+eQX5GtvorG5
         En7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745333011; x=1745937811;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x/y/b0lmXl08QtqaLBSvEVb2dHfd0dRjhy8lIGx6XD4=;
        b=xKJq8cT1w5ud0aFooZjYOO1m1rNPLWEpa06lmE4DgiYvkw706M/aMAH5bNIReTb3d/
         YCAvQGIf50gXLuQxUZY2DUR+/lB/Qoc7i/tKp+asdKG37Z3wJ7hLapDM8h6Rqp7rsXCq
         f7zzmWgbFYzyREn7XAGpLO3hiGKgFYNZg3nH7ORQjCRCA+W6kMEHfTIJPc6YKNAbiHl5
         uE83oUQ1XPkptJ8B4wcp7WL1ng68ddZhXM5+meTm5jgRK+A9AcOrRUq+2py8S3Gc2Etd
         z1plIBo1P5AWRLZ3SlSFctZFkRIY7qs3NBCGb10WBSy2x6X6qNlNavGOHzP6YeXwiNjG
         1qyQ==
X-Gm-Message-State: AOJu0YxnTmopsnnsJcnJ6VdzDkqJfqpfLWFPvAuDmQWS3RNiO4vprlXi
	wQlU/KxDFF2JIBBTP980565ueFMb6mXR+F0eJzt0bPlF4wkO/XB67mVxTA==
X-Gm-Gg: ASbGncuktCpn7Wydf8kEg3KNgErOK7OR7hWyZv6ijWmnaav+sqwMSJ3wvcu++AnW08F
	2sUPoEAcUdipvrwBGiPeFIGLdghvwvP00KOmRtURmOzeV4cry+vV6laX22W9H8a6IVI8OIEwPoq
	fg+NA1AicwUskJ3bEI4GfrjLd0IVcwR/2VaUEc+1Z0hbJPIKtP3Uz7dxnDPm+3UUh8z8bu1gga1
	xStZB/jPVdH+LGXnJV95/0GYlnFBbNoTIAU/PtzwhzfyYFSs3XyPoMKlLkQU/WT84rNydlWVZQe
	H9fbXqd67mAtEGp0bmkQ7ieV
X-Google-Smtp-Source: AGHT+IH18RY1u+yE46ma4TnofwPQJB2NndnA0/HJArabBVAx1kPHDyYACrEw0ldqeoLDVjWS/ujHgg==
X-Received: by 2002:a17:907:9494:b0:ac3:ed4d:c9a1 with SMTP id a640c23a62f3a-acb751721e5mr1607664966b.17.1745333011143;
        Tue, 22 Apr 2025 07:43:31 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:be5e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ef475c1sm655374966b.126.2025.04.22.07.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 07:43:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 0/4] preparation for zcrx with huge pages
Date: Tue, 22 Apr 2025 15:44:40 +0100
Message-ID: <cover.1745328503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add barebone support for huge pages for zcrx, with the only real
effect is shrinking the page array. However, it's a prerequisite
for other huge page optimisations, like improved dma mappings and
large page pool allocation sizes.

There is no new uapi, but there is a basic example:

https://github.com/isilence/liburing/tree/zcrx-huge-page

Pavel Begunkov (4):
  io_uring/zcrx: add helper for importing user memory
  io_uring/zcrx: add initial infra for large pages
  io_uring: export io_coalesce_buffer()
  io_uring/zcrx: coalesce areas with huge pages

 io_uring/rsrc.c |  2 +-
 io_uring/rsrc.h |  2 ++
 io_uring/zcrx.c | 88 +++++++++++++++++++++++++++++++++++++------------
 io_uring/zcrx.h |  3 ++
 4 files changed, 73 insertions(+), 22 deletions(-)

-- 
2.48.1


