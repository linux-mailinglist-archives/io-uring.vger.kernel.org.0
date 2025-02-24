Return-Path: <io-uring+bounces-6681-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BD59A42789
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:12:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B5123A7FB7
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DEA0261575;
	Mon, 24 Feb 2025 16:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EtRsTTbC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905E3261585
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 16:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740413199; cv=none; b=sCjC8Rvzk0lpdY3bAjuKr+KkKzQuGmDnTsqMTDCNgQtiGlqilOIwAAIMRcBKEOkiBqoPcxSlMlJlb2O1kO5Wguhmt1o5v21d5BXmUrpi7uOmSuTQfGZN7OXkZ8yHEjIDPI7ILPBsp5yIuiRG0u29S3p04R/w76eLpQQifGCXj10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740413199; c=relaxed/simple;
	bh=84eXTaRf5cAJTLpv6OrTQmTn/wY9nC/YdF7ygYWvLvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KMPC+pkdVtVCxqIysowRYVDN59rmlDl2gp3SphEnVhvA3Q2JIzkoxaG1IxLc1ajh0kjohOa28ZFqIAzNxWB3L1ehfmZr/5QFVuLlF1uXMkpJbhPSXrpZ88tQrHT9iA5vAZt5RIZH/exy9eaOsWm+cuOHMvhP/4+B4yex3W0xZeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EtRsTTbC; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ab7430e27b2so723273266b.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 08:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740413195; x=1741017995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ru/js+03sdBf7Y37HRlu5JNxsWqpGf4edNXIyInWAMI=;
        b=EtRsTTbCVNDRiK31K9w5hyUTbPrdcPP6LsD+PWVlKHCiFrWCzy8dJ1iU+CWBTkfFn3
         AxyXxMnyzAHTPv/xVG6taHySBoyEhp/bR+FAyMlEW2Al9Y07vUBC3oagLHeGw95f/2Na
         OgRhMwBdM9J5FafS+Itc/33dHX+WVJTxuA7uMhpjrT6dtiAC10llWLONtZtmKTnK0MZi
         dnw1oza1z4nxrDvrmV7k81PeL1wJHod8U4LQHHuvQVPysmoh+mHA+OifyfpMxsGQIRsj
         LX3xcG9R+Xbh9ljdnw6RNnI0LAmxwr2pmMZUfRaeafvG+of48p8tK64qe8d+3g4t6Ck1
         Qg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740413195; x=1741017995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ru/js+03sdBf7Y37HRlu5JNxsWqpGf4edNXIyInWAMI=;
        b=KJBFSjp4svcCkwSGJKJLuc3w1SoPUdmkdNH6g5mEh4/Uf7FJCtwm3aM+OnunRmiT4+
         yhp9siqqw/ATgO1j/PK2VIS4FdDvCGLuqdVWnNmuDqbivL/e8YSAEFsXS5d8BoDaHZZS
         qX4FVMY8jw7qaAcxAtH2gVKSoQddUbsY1MFNisIjMEeCFg7SqLeKR71iC1hGtyqDNdJT
         +28I/qZ1gC/SlJTEQY0Pt2brHj9nhXEIICcPUErsGrsNn+GOy2Ro7h0to8h+2ZZVq4et
         1AE7hZtJTeAi7N0mV2JNAsWRWyAccAri1Sfrbm9jKdMc14vO9gwh71YXhjxFOzjcmVJf
         +9OQ==
X-Gm-Message-State: AOJu0Yx1qcUOeBzom3AcMV6yl78eb0mh/ZQv4JHKuHfYeQ6FfEih6oN6
	Trdk+lqN6cVt21uzN9QWEG4BuR4x3kNT2OrZrJuJTeBm6s9KKmCBP8IaiA==
X-Gm-Gg: ASbGnctA++BFNWYb+JJS9lOIml2lcqTJWHt7beVzbv1Pqmzh5RLty2iTWQvjk0EUHnD
	qHE4VGRCXwefynigOL7iiTgHoXNeVYOs4SSyDx4s+C4CSPXv6asGOWH8/jnCIcWlvmvrRFFtWmr
	gdbxPY//fbmCdwfSYU7StrIMmNTr0v7FK6GMKlXgJouq4/Yv/zOHMcygWeEmsF3QaJr630rLROH
	aUx/4RmnXZ+ax9A0mCkDBRmnYzz4vL1fssUsDZIkkHFJbJYIFktY72KXepZOo6ODrGslWFqqtv6
	Ta8Q9gLkJQ==
X-Google-Smtp-Source: AGHT+IEN5nTwtihkzd+O5NfJCh5SKOivglaTriL7uIQfRdPyl7aqaeZscqm87RLNeYKnG0EPAQ0Xlg==
X-Received: by 2002:a17:907:7808:b0:abb:4802:709e with SMTP id a640c23a62f3a-abc0de13481mr1210509366b.42.1740413195126;
        Mon, 24 Feb 2025 08:06:35 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abb95cc7451sm1664684566b.92.2025.02.24.08.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 08:06:34 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/4] clean up rw buffer import
Date: Mon, 24 Feb 2025 16:07:21 +0000
Message-ID: <cover.1740412523.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do some minor brushing for read/write prep. It might need more work,
but should be a cleaner base for changes around how we import buffers.

Pavel Begunkov (4):
  io_uring/rw: allocate async data in io_prep_rw()
  io_uring/rw: rename io_import_iovec()
  io_uring/rw: extract helper for iovec import
  io_uring/rw: open code io_prep_rw_setup()

 io_uring/rw.c | 94 +++++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 48 deletions(-)

-- 
2.48.1


