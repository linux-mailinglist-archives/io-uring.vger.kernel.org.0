Return-Path: <io-uring+bounces-8460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0786EAE6289
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2C4A16C9CB
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 10:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FF12820A5;
	Tue, 24 Jun 2025 10:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHc8bQL6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E2A257440
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 10:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750761248; cv=none; b=HSp6BVvOyDGdsKR90khpN0k4/ac4orZP/1x7yQhX/nmZPMMM6ZNKCbtmnn6Bf2K5CRb/cndN+OnFQs+HPP5w7IzRIfwsNbCnsVyma1+Qt1GMxkKbSk/Hc47E4x7L6D5r3I/jE3eOttvSmi5hhBrR6InHcAZmINF385kivy864AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750761248; c=relaxed/simple;
	bh=PpkVmyHt/wF2wrbECFhH369SHeRELY4x+QHt6iA4hwk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ryi5phsseJ8+NcDDbxf0gugzDAQrpiJMC0C/rtR+Vbng8MQajPJ+5n8fLfGhxqe9iIcpty8VIf9hqu0Esw8MD7I+9adKX8kfmPlV562Z7P6u4weBkKiUISyr3P+RtrM29+PABqvS6mLH0XmP0CvHyuZPV32Zlz9LG7xC1M9waNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JHc8bQL6; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-60c01b983b6so2073944a12.0
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 03:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750761245; x=1751366045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cqrO6rTsRo6ST5TebzyTpGZXLxtyFwlkXMuLbC3BZjY=;
        b=JHc8bQL6GfMsOX/aimxl4n0ldphH6GkAMNbw7Rg4FdfK/j2mANukQAbg/z1/1yAcKt
         DfMOS5O3CJwv3796mMvP0FhOQOX9vLFSXSrvhU6GrDSL5EkpOPTTJM9Kao8zxcDOvDkQ
         N3YGfjiTNYF4NTaIZC3tEAtvGRKKq4K6EPZ4w/6MKwsow4HHicKYpLIVANS2ylz/BAjj
         afrpefWPX1Y2/BRk1dY7+w2Es7rJs6kwUWjKYfzIMaGaaWS69yWuz9nZize+RshxiGGU
         JvXN6PVT4ynl7x/3Jw56gP/f2R86IZ6mfLBJyZnZy+2+wKZdxsTG2DpCADhBcqDrDb4e
         rpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750761245; x=1751366045;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cqrO6rTsRo6ST5TebzyTpGZXLxtyFwlkXMuLbC3BZjY=;
        b=W0lJKOZsuc1Ef9K85axLcrUb01IfSXxFqkKQc/WrnTL9Y39OCrqiRPfHG/jiqxtaui
         guMdIMa4UCYI0RSZsO1WJ47NHyKhAm0fg+v8JuVLWNvl6OfbI+P+uD+pM33IIpvHlwny
         C3FRxEHwTPFqtBuykKbDtIMLSmdJuNM+F1/KUIpNe0lsbOaVUG7jur8KZ3yPqT881JaV
         h1BZJGz/FAzephPWTlSgpJclAoW1W2GO1+JzUIPZNbv4h550pX1YH5VkjRSKQ4gWroyP
         zprWw31sPDJtoVj73K3YehQQxEPxmuXmUx1sGqsNtUOlKNhKNpH08vk2cvd2nT8eq40P
         rNdg==
X-Gm-Message-State: AOJu0YyxVoSRhAdjF4he9RoIvPaf8dsBs6PbFYqYHIxOghEz8NQ6ewat
	uWLK62dIW8dZTaNDrgGBFOvSWxtojhdVY4ixbrG8xdo21FDCynXO1e0kflMHMw==
X-Gm-Gg: ASbGncvWjHjQKpgsTfQgZ82uDahc0SmvQgiD90pPTa3GSlaSjO5Ut6Uuv21wVefxVGS
	uCU5PWz7z0PklA6oTh2TfZ0Sc4q9vsP05XYtMsRfXL6upRuOigRh3eEKnfgDDQENRwcEhr08xFB
	nduo18iKfokew8scYKyDBVJdgl28twv4un3LtHH2pVCoojuUKcxzTy3yElu1XmE7LS5kqudzYEn
	ZGR+bkHN/4/uXBni5ntfAaDsmhxpr3CllmWIClsozayJL9ykYiabLCcgSfOsdV31XVeUwGKOTm1
	ODJ4vmwliRHHWN65i1EDlYS7i1BgA1Ii6naK+pOOhBBI1A==
X-Google-Smtp-Source: AGHT+IHk8GpRpwILOjSKgrC+EgtQL/39SJgS4B6qMi746W9MNJjPHWKa+7IJ5kQwuUPD6CAO2OVlDw==
X-Received: by 2002:a05:6402:27d0:b0:608:f816:1f88 with SMTP id 4fb4d7f45d1cf-60c18e8030cmr2814030a12.6.1750761244517;
        Tue, 24 Jun 2025 03:34:04 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c3c213b1dsm320999a12.54.2025.06.24.03.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 03:34:03 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 0/3] io_uring mm related abuses 
Date: Tue, 24 Jun 2025 11:35:18 +0100
Message-ID: <cover.1750760501.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 uses unpin_user_folio instead of the page variant.
Patches 2-3 make sure io_uring doesn't make any assumptions
about user pointer alignments.

Pavel Begunkov (3):
  io_uring/rsrc: fix folio unpinning
  io_uring/rsrc: don't rely on user vaddr alignment
  io_uring: don't assume uaddr alignment in io_vec_fill_bvec

 io_uring/rsrc.c | 28 +++++++++++++++++++++-------
 io_uring/rsrc.h |  1 +
 2 files changed, 22 insertions(+), 7 deletions(-)

-- 
2.49.0


