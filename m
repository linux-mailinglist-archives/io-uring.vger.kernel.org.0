Return-Path: <io-uring+bounces-8391-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5804DADD091
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99296405C84
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C02419ADA2;
	Tue, 17 Jun 2025 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZDATHiL6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D1B18DB35
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171643; cv=none; b=U3OS06ZHWP0poEjEqKyKbS6vU7IFxuW/caGr45wgkIpX643TXd70F+Wg9qwsW/TJVP4mP4tm0rDtmOnoQnkj0+SGIuw3mfPg8GUtlmgkWoPITaPjv1Fuy/xr66d1AaEP/meieT8dyQlj4s573JOunGCtx2GgltEyS92WjqqhRx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171643; c=relaxed/simple;
	bh=5ir9lcFSuB1/9oHiMfwjQb6l78IHhdIRKBF2CmnTTkE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pX+SJ2p1vQ0VX9XQBBApAj02fmSD9+3smT9pgIFQB1TcbXGgKK0PELKPgQ4tD9fqsBbS9qeff/JEO7tTiiW+7YFjPafp6CTIrQFXIDnDLGttPVOLYtJyRO3L275MB/sKp/Q24CGtIHu+I7eEG9WGlM88u1UvlUq8OSxbNdWWCU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZDATHiL6; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-60780d74c85so8842922a12.2
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 07:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750171640; x=1750776440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WZbJuqV1M7gAFwECZiqRSGSeR2kkeU697UqFXeZzSTY=;
        b=ZDATHiL6leEJeDSos3TMwVPW+urZ+/7wVcrVkJWdJeDQ4I3J3VhitTEXM9YAVNFQk3
         CWRVgQ47V8UvE9B3fUeTyTP0EN/by6n7mmO1/LonsMcdtIItWn3mpTxgGiS6NVgtNIEp
         RxpwOdPPYWk2rfgxFQkTRZ9lZpOfLVRogSqUmK7SzWZQi0iDT726zdlEQarybdROe/Yz
         dyzTgQJHDHec3CNHkvzw6xOMvjTSRNqyvln/jdO8gy3aiPul+OduaYj4SxAkUPes+86M
         LQeCQp4pp5ph/+J3RF0+ElumFbW+C6Z5e8N6EZVJtrk/EQQyTx6AzNFjQ/1l/a2QKnl7
         GJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750171640; x=1750776440;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WZbJuqV1M7gAFwECZiqRSGSeR2kkeU697UqFXeZzSTY=;
        b=qmCCWbBKNllXMD1mybqSQ8gQTzhYn1RN3eZicO6zfSXXayz7ADAOZvWpczhoBmQrW0
         3Tsa3jZ4iQe9EKptX7t2jkdUU/GpKOtQHgnZSBlKlzksz4ERKFxADX2NBqU/kUwDQ/hJ
         9+qWr4jDjhCQQelIvk+2ZAjRXVHoEyETXGLngV0smcjAhrwIkgTRuTqZljbSkPUGnKG7
         FSaBMoLRhMrQdY9vDR/meidc4sH5W5sgOokIFoTzs0jGewLt2H8Nx8PCFim9qSvsPeL3
         TueFttoECo6scrHxz2JC0PxdpNPWtRWBJ0bcSpyA9axVuenBfR2k757s0lRc7foo6+O2
         AEyw==
X-Gm-Message-State: AOJu0YxeKo/yygUclJEK49KMnzQYkvLbZJHGU2ENJmIdRhfTMkTiwndE
	1csm63oKAay4vETGKSBJlcSdHGMUIA4H3pRlw58CtwyqK2BpPsR4r8AMLZZnvg==
X-Gm-Gg: ASbGncv+TqGepLXt27X02IJdUfI0Nut1X2S7swIViK66akScDNqn2sBv99sGymDD8y+
	EmWajQBXZrtIz5pawTzaYqV+mhxj57gOhPYHPBDJv2k4ycj5a4i2BisKgKLHNcPyMZGqs1gquAD
	WxQHJMkfIpPltD25nodk3etywMfBCRzr6Jw8JwnnyTj4vjf1ulNhrLYeugt7tDmmHrbN39AQbvs
	Uv4OxbXDM6Vz2p8JYzCbBSYotpy3ZRsCfVtaelRAWcIUasyv0F0somkJU3niIlK6T/uFfvZhFib
	yAU1c+g9t4ngaf4rd2TxFrenkH/VsprdHLr4VMxCi13qrw==
X-Google-Smtp-Source: AGHT+IFogVvyIDtQyuh4zx4zmsd7FY7qq1kOz7zKpGUVqbC3WREBDQBC/cIYUn3R9gYGr4QXsiuhsQ==
X-Received: by 2002:a05:6402:27c8:b0:607:ec18:9410 with SMTP id 4fb4d7f45d1cf-608d08901damr13124382a12.3.1750171640013;
        Tue, 17 Jun 2025 07:47:20 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b491])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608b4a9288csm7951040a12.57.2025.06.17.07.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 07:47:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 0/8] zcrx huge pages support Vol 1
Date: Tue, 17 Jun 2025 15:48:18 +0100
Message-ID: <cover.1750171297.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Deduplicate some umem vs dmabuf code by creating sg_table for umem areas,
and add huge page coalescing on top. It improves iommu mapping and
compacts the page array, but leaves optimising the NIC page sizes to
follow ups.

Pavel Begunkov (8):
  io_uring/zcrx: return error from io_zcrx_map_area_*
  io_uring/zcrx: introduce io_populate_area_dma
  io_uring/zcrx: allocate sgtable for umem areas
  io_uring/zcrx: assert area type in io_zcrx_iov_page
  io_uring/zcrx: convert io_zcrx_iov_page to use folios
  io_uring/zcrx: add infra for large pages
  io_uring: export io_coalesce_buffer()
  io_uring/zcrx: try to coalesce area pages

 io_uring/rsrc.c |   2 +-
 io_uring/rsrc.h |   2 +
 io_uring/zcrx.c | 179 +++++++++++++++++++++++++-----------------------
 io_uring/zcrx.h |   2 +
 4 files changed, 98 insertions(+), 87 deletions(-)

-- 
2.49.0


