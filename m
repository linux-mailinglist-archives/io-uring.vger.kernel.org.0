Return-Path: <io-uring+bounces-1300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8BB8908A7
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 19:54:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E054C1C26E78
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 18:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE8113775A;
	Thu, 28 Mar 2024 18:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dlGuJs1q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695671311B5
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 18:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711652059; cv=none; b=smL3ivuqI5w80DTxWXA2s6YjLsbhpSXqX34gEo0wV4tT+wA38OyHBc7+eswZbi5HIiwxk0qnJAqLcHAsqU260qtrKhrFBoLEM8FwIOxMnaSLfn49e9DIpIOWnPKMqdb1ar2wK2qqz6pjAT6UjKMEKKaYtv7xCewwtdXbgGgJq98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711652059; c=relaxed/simple;
	bh=xQIq7pbSzFTyirjAKdgey3+ZNFlzHt8gP+0XwuZ4UaA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=q00/Nog75oQEY412AuPTf1PVCbh6g6tSTarLR+8lkdtJsAvms+c8Kj7fzoGVrfdIinq3ZuoCS94hlOc2lTfSuR49Q2Pao3+1Xd/Bd/1nOwvjSrpov8TpRmy8nHG4G7PISQu4Lp9taB3q/nHiMH3G4olKuI+2oyhERjPVSn20ggw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dlGuJs1q; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so316950b3a.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 11:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711652055; x=1712256855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=/BnypW2LILz4m5BH/bLJh+2iTr5yDHxwbmBQvrgmyPA=;
        b=dlGuJs1qaVYnVWIEB6qSaSW04EsU9/Q2MMuIv2P5Qb/fwE/W8H8jNNjDvOnTFIvcka
         ZhvVG21DkWy1I5LBT1L/qZLw4uNA7gF1NN3FDLHvlXcFm82pGpoCqikWewdK5fKTNfKA
         MbFjhOVCx4OfneSJYReXq4iA1zGjEKWXZTKkqNxMYBXVr744/w+r9f/YN4AcL/x2mEPA
         +jkO7yfbXYEVlYG2+n9Bs/sn7eIV9AhwJq7Sv6ZUJWgT5kyrh/TJaVhypWmU4qurNiyj
         qBqOWGf7pOeaVVavbeZgBnODQ+2tQjaudGpahbg3l5EdHz7ElZgcnbSSOYq1lzS6X/G9
         yX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711652055; x=1712256855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/BnypW2LILz4m5BH/bLJh+2iTr5yDHxwbmBQvrgmyPA=;
        b=lwXxOHfjR4s8+pFHxNVP8/C9Kh6fCENMZra+X9tm3m0mpzN6EYv0eHOFinhoAxFgv7
         XDpMFuzWkrw/+FbC8THT6EBaVD9uctutTXew1VLjJ1/HzCkdbbaF7Hd1Nn4M+ZELuDmH
         DqsH3ayuE3Ay8U3+p5AatVRI19nTI9/bYrQlPhuwxirzZ9T8sxWygxQZfVSHGjGe2/gS
         GIPrDRasn8omMZ69S3cTyMB5WPXC4+CvVcKKiMY56Hyi+pY8PaV4GUsAU01mVbrHuiR2
         Wti5RyvczVXyjt9QU56gxQ9b2EAjEjngGdB3IXpJjmbP+IPhlDj0N/Jr8cxmi5yPzu78
         5hYw==
X-Gm-Message-State: AOJu0Yxxfwf4v0IDZa6CGAT/e16ztuzxxTCY8Jp1zn+m0//PkcuAFIKw
	y6YjCgpPr9lemqevYRSnJpmxPuxLRLDmkMh5c9bcb3Epp/W9gg559Px2kVLiVvTAuCoBjZsauhN
	H
X-Google-Smtp-Source: AGHT+IEobSOeFCWDYJSoHmclQVQqvUtlKg7VlubFFEi+dhz2HNnpascJH9TsmSYimE92mvBqOcz5CA==
X-Received: by 2002:a05:6a00:bda:b0:6ea:d0b0:3f96 with SMTP id x26-20020a056a000bda00b006ead0b03f96mr179293pfu.1.1711652055268;
        Thu, 28 Mar 2024 11:54:15 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:b138])
        by smtp.gmail.com with ESMTPSA id v17-20020a056a00149100b006e631af9cefsm1717357pfu.62.2024.03.28.11.54.14
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 11:54:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Cleanup and improve MSG_RING performance
Date: Thu, 28 Mar 2024 12:52:42 -0600
Message-ID: <20240328185413.759531-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

MSG_RING rolls its own task_work handling, which there's really no need
for. Rather, it should use the generic io_uring infrastructure for this.

Add a helper for remote execution, and switch over MSG_RING to use it.
This both cleans up the code, and improves performance of this opcode
considerably.

 io_uring/io_uring.c | 27 +++++++++++++++++++--------
 io_uring/io_uring.h |  2 ++
 io_uring/msg_ring.c | 37 ++++++++++++++-----------------------
 3 files changed, 35 insertions(+), 31 deletions(-)

-- 
Jens Axboe


