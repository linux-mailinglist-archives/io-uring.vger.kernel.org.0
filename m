Return-Path: <io-uring+bounces-2561-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E4E93B030
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:16:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 196C81F21138
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 11:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9485F156886;
	Wed, 24 Jul 2024 11:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GZLKv4IQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA5314A4EF
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 11:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819766; cv=none; b=GoXdQERwlVd2sH7bJrlHDbk7i80K481uCjOL+iU2RrHwftGOi4cYzPbqtlS04mQQnmzSnJzsc/9RJOTlXsMPPMtF8Sl9n0HZ9TnrhQDfNUVeZM2kz+pgsI41S+/UxwjayQ2Cn0C/rOGO5RSXApUMBFVhg+vw5qF5IA/yOCRmimI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819766; c=relaxed/simple;
	bh=VHH41eB4EScBBahgjb8NsNxPK3YWvwZmPyX5RYPUZeU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ND6MUGkaYw2lGMgUaHQ51a0zJCIMcnAHpYvLHkZqFRpzP25H8QrvWk9swiInJGWhzJ2kYRs4LHbA0FGa5MZq9PsODVpzzrZHXOf4/QPu+A76LigCmboyVM3gNwfkKrj62lWnI5qfmFmoq5J8XkGdXMMuxAmRxQ3VXKdZQiTay9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GZLKv4IQ; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-59589a9be92so6447436a12.2
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 04:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721819763; x=1722424563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=342zt4B2hTNru3LF/SrR83XQVeVLEP1z6FixsZHOCVc=;
        b=GZLKv4IQOSBDhS8o7RLLvZUA5tjUtE9deFXXHJCS2ipp16TuWS9pVkomRULZBY/YNI
         PTdn4zwDPJGf/NOwS2bAElMsQeo0bjfdR+kxepLKby3EIerZ8H6Qkbz9SBY09WDSS6UN
         3O+Kfm18gq1i9X6Njfj1upIQSnLTZHADslowskqRIYyhOAOujWB370ocYRJHu7GNukcq
         cFM70EX5WXO9UQvviC41Ia7Lc0uq1Fb+05dB/UdRmh+IfbCs6DivL3oi+DJQqwFZvDG3
         IXRLY3kGMw5YVeAXlrZbZBk03LBnyLxip/88cdXzo53QoMZIxVsRXEaN6CfXeJTQZt7a
         Jl6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721819763; x=1722424563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=342zt4B2hTNru3LF/SrR83XQVeVLEP1z6FixsZHOCVc=;
        b=E4bGvKjpU/AKBZUt0sMOV7yJLxExJEmiRmGctr7z/0jRGHl3J5SE5q77v3wV6KwOFl
         EaWByRmjEdCLFlWyJDaKgudV992f0lniDDgulJgVix6FNBUZ3qTX/RFit/kYBjGwb+IA
         oyVygv8eaPeb0kJ16QS407TLJ2hgdV9XJIckAPnpNSabto3iDbYAs3i30g1KvSCbWY7e
         /UBr3UPqPd3DRf34+l548c2cKTleaitd5GF2Q6nQQ/SyMOA6n9Zd1wvu2t2kXkAOBXwb
         fdUzoej8P7HPRe/9teLp8i9jyIxdyDLx8ip/WznUhi0Xp+y6J7xdyL/FUYHeyI4RsSp0
         bCug==
X-Gm-Message-State: AOJu0YzVzJwo30ZWNd2fwhSeRFl+acPNUPubT1gm4nopgICn98D55PPr
	Yc0g0sp4O8YmEEvii+7bITTiO75fPwT2MGQ4BovR9FMggkbQOnZyOm2g1Q==
X-Google-Smtp-Source: AGHT+IGzj8GN3lj4M/PET1n2oeU7fKyoVbgeN6bIsh1/wM+MS1eGHnv05/5pDJ6nsJUMsZmrlbWHvw==
X-Received: by 2002:a05:6402:40ce:b0:5a7:464a:ac0 with SMTP id 4fb4d7f45d1cf-5aaec763522mr1354605a12.11.1721819762923;
        Wed, 24 Jul 2024 04:16:02 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a745917f82sm5006310a12.85.2024.07.24.04.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 04:16:02 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 0/6] random fixes and patches for io_uring
Date: Wed, 24 Jul 2024 12:16:15 +0100
Message-ID: <cover.1721819383.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 improves task exit cancellation. The problem is a mind
experiment, I haven't seen it anywhere, and should be rare as
it involves io_uring polling another io_uring.

Patch 2 fails netpolling with IOPOLL, as it's not supported

The rest is random cleanups.

Pavel Begunkov (6):
  io_uring: tighten task exit cancellations
  io_uring: don't allow netpolling with SETUP_IOPOLL
  io_uring: fix io_match_task must_hold
  io_uring: simplify io_uring_cmd return
  io_uring: kill REQ_F_CANCEL_SEQ
  io_uring: align iowq and task request error handling

 include/linux/io_uring_types.h | 3 ---
 io_uring/io_uring.c            | 7 +++++--
 io_uring/napi.c                | 2 ++
 io_uring/timeout.c             | 2 +-
 io_uring/uring_cmd.c           | 2 +-
 5 files changed, 9 insertions(+), 7 deletions(-)

-- 
2.44.0


