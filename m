Return-Path: <io-uring+bounces-3336-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D8398AE95
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 22:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1BC8B21183
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7353A1A0AFA;
	Mon, 30 Sep 2024 20:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="af9OdeL+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78EB21373
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 20:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727728826; cv=none; b=lpIDBssCQ/360WVB5+1WZN1AsjMounRE8IkpNG001rYLlQkcFyS9/X6NnMT68HFzKDa6yUbXSU1CQidVixSB75ooG85sp+gHEG0/Iltg0H9Y7SxquK8QuEIhFwZkehmlKPUFspu/2syKf62veFratERWM6WFNO/DqHAsgFKVBG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727728826; c=relaxed/simple;
	bh=vQ3zaIDVpwh4XJXMsSwy9Dd0StEpkg/ZPYZX5LPBqCQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=NbiB6Nri+z6y2yBt7EEmSWYIjc8SsvopG3J/Sv95973Dc5+i9sP40sPYGLwl6AELTzX/ImGMjIU190ts+VADNZ/+AT4hJ0KuGRqV6aWn7Suv7Ktuz04Y4dB5Ftskn6N87L9Ohy+ekkLKFQGLZvp27wff4Bd9b4gpSUEBURzRPQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=af9OdeL+; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-82ceab75c27so297906339f.1
        for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 13:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727728821; x=1728333621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=txApjyXSysZwC4UfqHBlblWFW1ISmVCRGz86SxPfEdI=;
        b=af9OdeL+HESep5lWLSfvdsgwg+6Ub3PkSmzjIv3LnzSDbANNjMOIAcYqXkuAFJTppK
         tsMlSx6NkBuj1ECK1/lCWyK2ug56ktoDFsarLwScHvRuQh1BFqdKGy7+gRRWheqFpW/r
         cR+wEf/pCs5lbgHhU3U9nfrUc7wJWHVEEKknXMBnVg4Chs94INlWbebADfd1XjgoEh/q
         t6N0/peSaEdbkOhaKKh21VyPlOAtwqT0dbWxVvrfa2nTOirdg1KNVpqwMzykUUVfYTiz
         5QCIsWoAkfBXr9ifGHz71YR2xqTX+f0nalkzcuxeyGLOFH6pKwR9mUHdP/DarfwWFCA5
         PU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727728821; x=1728333621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=txApjyXSysZwC4UfqHBlblWFW1ISmVCRGz86SxPfEdI=;
        b=HZt8Qn9h3SnRmT3MP8pkYT+ClJkitgOeRFMPxN3cN+GD5RPRecRnEqUoV3UaGoSXMb
         gzgQDIVyzzGbV8oX2GR6iVziGpGaUDJy9CYrrQ4KMPz89FCd95CdUv/UYWkyJULNNT0O
         zZoeIgLFDrPlV93jXEsURaXXQtPyi5Lyt4jGg3aj/tg1b6qiW21I540DnNaXzw/WknJ8
         OeAlDHNV+CN/x+y3ISbRVLSZTNwaXvAiojHulrGvl0pXoSfLA9zY/jhB6lQ8/qKc1LSd
         OKv49EKEzSyTbHvJT3kQizHbMjU/9vm6TaPBxDNbwymvw8+oyQNqtPJNWJQHqCwxltMD
         l/8g==
X-Gm-Message-State: AOJu0Yz9ZrVk5HaqIGal8fFMu1A+Xwc+e44Vxkh4iBafn4qTOm7lOtEM
	XiB1j3kPfFRZ26lGiGCtjQd1R/OHC6Ziwod/QMn8YYyDW5urmNDta+cnPtSe9rbWUZ5jl173oHS
	ajko=
X-Google-Smtp-Source: AGHT+IGpIz1ku5qTFeFZwA6uvzIrxYml09K42UPrsIQCE0GsdJaNpxZFGlAlcFJ6EYNWrhU44/Ku7A==
X-Received: by 2002:a05:6e02:13a5:b0:3a0:90c7:f0f with SMTP id e9e14a558f8ab-3a345181626mr129774415ab.15.1727728821059;
        Mon, 30 Sep 2024 13:40:21 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344d60728sm26430175ab.2.2024.09.30.13.40.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 13:40:20 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/5] Poll cleanups and unlocked table removal
Date: Mon, 30 Sep 2024 14:37:44 -0600
Message-ID: <20240930204018.109617-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patchset gets rid of the distinction between the locked and
unlocked hashed cancel table, by simply ensuring that the unlocked
issuer grabs the lock. That then enables us to drop a bunch of code and
helpers (and even a request flag), which is always nice.

Ran this through the usual testing, no issues observed.

 include/linux/io_uring_types.h |   7 +-
 io_uring/cancel.c              |  10 --
 io_uring/cancel.h              |   1 -
 io_uring/fdinfo.c              |  11 +--
 io_uring/io_uring.c            |   8 +-
 io_uring/poll.c                | 173 +++++++--------------------------
 6 files changed, 40 insertions(+), 170 deletions(-)

-- 
Jens Axboe


