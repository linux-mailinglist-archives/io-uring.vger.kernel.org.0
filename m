Return-Path: <io-uring+bounces-4363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 696279BA74A
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 18:51:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 111F4B2131D
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 17:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2119414F9E9;
	Sun,  3 Nov 2024 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GC5idoLC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870007080F
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 17:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730656276; cv=none; b=BnJzF4dH7T7ksmBDlXGPkrF7olfYH5QDKxZ0K36GJ4543rSqe5D01cv39xHQEz3ZNFPas29Cmdl9Pnk/11yu5tW3uqb9tFLcxHE79RqY+YuuMhiG7EyECWfpg6OZJGgaTj/1g7D6pggcn7E08yAxw+k7vDiOvlKbGu15FByux3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730656276; c=relaxed/simple;
	bh=PmxUJQSbVlLO0e/dkj54S+o9pTKrrNpkP4oDlhcpA2o=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=houJ1uEe2hxCfamB4wptmVyCdPQZIxZvGLe/3gMkmsKEiO6TJgqhIVGwAzM/Kz2mUXhM3leVL9v4X2wMClY/mS8kP82inX2jstZj4b7yHyeW3VRGHIUEzK83Z9y+MVlTjL5vOJBbQD0i0S5fX58+20ZQRGlssw6N5YtNv/Z+EjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GC5idoLC; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-71e8235f0b6so3041438b3a.3
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 09:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730656271; x=1731261071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=2VZs4mdP5sZ5FNpjnmjUvG2JRSK+jLV+aj2XQEurdwc=;
        b=GC5idoLCXc8IlOXnv4YmnUjkzUoOXCpiV13DxpREYZgUjiqTrhiBZa/qXAhfL9/G+h
         p4dpGu23+ngspYeA/qrglUiiH9nphTTbS97DbaJnK28yjkipFKRHnBz6OwP2MiS4EMC7
         +mvfRZlJJBwD+bTl+ozneZUQlLcxdjty9gIKOv30var0Rww3Cef3tVOfSGIdZ0jzuB0u
         D+o6R/rps0MKaXl0DFA7w7Fdon3TDQjDvEch9QN/v371cEHUqEdBQ9bQdbNrRPAXwziG
         UWryRN3jVtgvymrwWJWSovm8C/TElPcUBeq4E7BPnSVFAjuoRRXsqCmQGgrmdgj5N/Cr
         ZhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730656271; x=1731261071;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2VZs4mdP5sZ5FNpjnmjUvG2JRSK+jLV+aj2XQEurdwc=;
        b=iCLWj3oGEnEWD3guQf0zNq1qQ9u8j/Z042zu/NMb6lsnwz1uydNb0/cPgz6R2YMhuu
         laG81UOvoKDMSaO7oQpjD5PLNkqvEVxhiMJBKoLAxrid+tAL65xv2RIKaNx/KfDU+nMm
         w+DRb7jRyvJrFfcphyggSIMUbxb3cbgR2U/m16zuA3Z4HO7nCFiKzJW4C3Y6PirYRDBU
         c+GKjLaGiR49H4uZt6Kpz4pu9Zm4/7PM0xVJqDTtKfUhrDUXGOaYwugG//ZrSx+fWPYB
         b1B469cvb/SFK+DePVIo0umQxw/3O5Bnm2xK9HSmsX6cvprPVKdOWCDf2NB6hMHk+PMe
         rj7Q==
X-Gm-Message-State: AOJu0Yx3ZPABbjeTZ/XzpJQs7iALJyp5grlId7lSyCUFfpG7ZH6Wtmyg
	DHbBdTDg3pWVvovK33Mt6913qJLPuWJa2tj2N+mRqF5hFKlkVKQOMiEHQHHMIKAGOJt8u2ju4hw
	by7o=
X-Google-Smtp-Source: AGHT+IERsWiYHJ/LDLicU+/jXcy6seSee1Lb7APrdROfxrBGqST36V0L4YG9xLSihxw0C/Ukhd/wFA==
X-Received: by 2002:a05:6a00:4b02:b0:71e:693c:107c with SMTP id d2e1a72fcca58-720b9c045fbmr19118558b3a.11.1730656271389;
        Sun, 03 Nov 2024 09:51:11 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1ed4e6sm5875109b3a.80.2024.11.03.09.51.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 09:51:10 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Move io_kiocb from task_struct to io_uring_task
Date: Sun,  3 Nov 2024 10:49:32 -0700
Message-ID: <20241103175108.76460-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

To help avoid doing task_struct dereferences in the hot path, move
struct io_kiocb from stashing a task_struct pointer to an io_uring_task
pointer instead.

Patch 1 moves cancelations to key off io_uring_task rather than task,
patch 2 just cleans up an unnecessary helper, and patch 3 moves to
using io_uring_task in io_kiocb.

 include/linux/io_uring/cmd.h   |  2 +-
 include/linux/io_uring_types.h |  3 +-
 io_uring/cancel.c              |  2 +-
 io_uring/fdinfo.c              |  2 +-
 io_uring/futex.c               |  4 +-
 io_uring/futex.h               |  4 +-
 io_uring/io_uring.c            | 99 +++++++++++++++-------------------
 io_uring/io_uring.h            |  2 +-
 io_uring/msg_ring.c            |  4 +-
 io_uring/notif.c               |  4 +-
 io_uring/poll.c                |  7 ++-
 io_uring/poll.h                |  2 +-
 io_uring/rw.c                  |  2 +-
 io_uring/tctx.c                |  1 +
 io_uring/timeout.c             | 12 ++---
 io_uring/timeout.h             |  2 +-
 io_uring/uring_cmd.c           |  4 +-
 io_uring/uring_cmd.h           |  2 +-
 io_uring/waitid.c              |  6 +--
 io_uring/waitid.h              |  2 +-
 20 files changed, 76 insertions(+), 90 deletions(-)

-- 
Jens Axboe


