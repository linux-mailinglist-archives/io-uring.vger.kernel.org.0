Return-Path: <io-uring+bounces-1043-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCD7087DB16
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 18:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 712961F21B5E
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3AE1BDE2;
	Sat, 16 Mar 2024 17:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dcHcldcH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85D81BDD3
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 17:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710610270; cv=none; b=c5HQ+WfoQ4uCBE0JWps00p/NE3BZOUj9VT+VR78i2DqmNy2gl9h2Tc5COVyw2OEsDPCrJmJl29Vb8X6YPn6N8Ivbe34S9xWFHD877k8Zr/qs4Bb9UDpZwgGa0ngWsJ26aNKCBxSdCJtAh0FnwMR2AYe0VGE5rMSZiL76IhZq9bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710610270; c=relaxed/simple;
	bh=BShAo4bCoc6d6gQwIk7oPd7OeIUwKqJXBKg18wCdI2E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LmQ+vHIIt0Baep/6vkUB3NvvYlg3TGydr3rf7hIzvo68JnMpQL7Lg8wF83W+5Tv/sxAVkbYOhO+Xetu2hhLyPnxSxWXZ/DHb7sRSdGVv1izZq5aDuPlE1HTMQMw541js+9z5XSTYj73ok6DflTUaNIIEGmGeYOk7i6OoShAJI/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dcHcldcH; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so891229b3a.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 10:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710610267; x=1711215067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ar4TLNmMTvD5uB+S4QMGYdxvd/zaeHWIC2KITjJ4AYk=;
        b=dcHcldcHAKIZjiHnjzI46QMduAKbBBeB04WzZXZ7B5u8bz8WiNGOHCGMjeM6UKSCHl
         AY3AEx52tnmSsPGrUEnzAdt+fF6+Vv97SuG5dFwRxFO0/FHhrwF6iZ80on32vqC+YRF2
         wVl6oQnXooPPfEaZ53Z/gVW2VTlQW9ag+t0TV8aCuccvTWw0/u7LkGCbbydJtA4ia/aU
         ejkbQwZWu3s1lxo71iCTFoxgeQZkkItlaoU07iJWg59Xq9x4gaS+oa/2reZYsuuwOdza
         rkaUprXFgbe0f3iIchyGwQknvzRICXsOC8AjJPL7163/FM7YLgAwjX19ITtMlb1imcQO
         cc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710610267; x=1711215067;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ar4TLNmMTvD5uB+S4QMGYdxvd/zaeHWIC2KITjJ4AYk=;
        b=bFtk6FRRkCRPmirXwcUTH5ivBLR8Hfs79Hz/06mz/CdniaQZjsZhs0r3CoTXyM+u2d
         UejXNGGPvqCZY4d913AN/+tZtI46VVt91sXJUUcAm2pgzuhEvGYPjY7QjEugyON1Njpr
         1I3rilliAWDjabyjh/u7ZpF6+2ehF2RfUW/GudncEshVz3tdfBnombepfSN7qcaq0KMr
         Ayd5X2T3OD/xM+Szn9Yp0TC6xu7NFH+atHR42AClpRT5hkmKKZOOcwLHpREpTGdSsm1B
         4pMHRmI5nnIbQlMkgFJ6V3jHA+K+nVMkGjfw/1jEyJXGfrw1Xz1dghdE2X4tJKIWZCRP
         4f3Q==
X-Gm-Message-State: AOJu0Yx38MdHCgt/xNYnn7OPzsRCER5hkpqEcZPvkhj7XLd02Hwlf5L5
	bpokDGCZaSHRQgPfv27OXRecsFTe8/qqthIxkF7XGJszxt1k8Yqo64e9plnG8s3BcODgc3w56rK
	C
X-Google-Smtp-Source: AGHT+IHl0/UhMeEe72Gcg41S/QHF036Tc7pWck4MgPDhMTnliYfskXaYmRHnFgzYTVpr0Pg+yIoVxQ==
X-Received: by 2002:a05:6a21:3a45:b0:1a1:4534:bc45 with SMTP id zu5-20020a056a213a4500b001a14534bc45mr9280410pzb.6.1710610266639;
        Sat, 16 Mar 2024 10:31:06 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id nd16-20020a17090b4cd000b0029deb85bfedsm3978567pjb.28.2024.03.16.10.31.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Mar 2024 10:31:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Sanitize request setup
Date: Sat, 16 Mar 2024 11:29:33 -0600
Message-ID: <20240316173104.577959-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Just two minor patches, one ensuring the networking side preps anything
in req->cmd upfront (more of a cleanup to be nice), and one fixing
calling into ->fail() if prep hasn't been run yet. The nice thing about
patch 2 is that it moves the error stuff mostly ouside of the
io_init_req() hot path, and as a result reduces the text size by 232 bytes.

-- 
Jens Axboe


