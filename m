Return-Path: <io-uring+bounces-408-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1520582FE21
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 01:59:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91E601F2567F
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 00:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B3010F7;
	Wed, 17 Jan 2024 00:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ipeVW2Ts"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95AD10E9
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 00:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705453167; cv=none; b=TjlvW1cfYnHJ8AdW2epOFH9NKo+zWoaCaTC9c0yWSzDrEnOoZL3xfcps0BUcn91Hfoy2Cy8jbOxoZ9FVr5vz+gKBZOGQEmpprmdk4Kn/zNf9QtG6ZHo2Xp1zwnwp91eDIrIvABF+/vQ/437ZwRWvt3a0eUk9TO9vChsObQjzhtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705453167; c=relaxed/simple;
	bh=PVANu8Rzt6jbBQaLmmYaObo4y4ltJv6WohfpawhNMOs=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding; b=oWgdGg2cFNEC7f/UiDLn66Q2HJEpM/aiTLi8oVsfBcwHQqNAp6mFo4/SabqIhApD2k0Kjvj8xEFH5qtcfCueoTMW0pxrnOpRGh3XxZ8Th+6tnSSE7+fIdGEs8aVwnsROcbsuygSmP4al8XHnP5/hnUYYe9CILxODnKlxgrNU49E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ipeVW2Ts; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a277339dcf4so1169415466b.2
        for <io-uring@vger.kernel.org>; Tue, 16 Jan 2024 16:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705453163; x=1706057963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PW72W3hfrxG+/r74H9q4Es4+RCPQPMVqzD5AhF5J/Dw=;
        b=ipeVW2TsASYYO6mQyw3wSkJC6bCfmdaUMELeDyAaaKa2BYRFVcc7U57LA1c42VRFvo
         VgtTz5MVGJ5BAtKmd3N599R+MOLs22y8zwU6WGI7G73JnqSAl9dU7Uc1NRKdenoAvDtb
         ny69cAIQDPCMv5/YJR8DzFXaLNTi5yOVnvANmE7j4gaEJ242foSzP1b4TxOJzDeRhQT4
         EgsUJozL8Eg7zalwgPpWVQRwYOkaUseHW6plQDVqjqVbmq04rZLfNEoBngz/mP/ksiHR
         BE9gRnxKfG+hJxeBMZ67OrRs4KLNGCG+4f9204Mwt/XL6CYIZaggT8+fqDIN+ruemvSd
         HqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705453163; x=1706057963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PW72W3hfrxG+/r74H9q4Es4+RCPQPMVqzD5AhF5J/Dw=;
        b=I089pVMdfkmoXKzLkK0QLE4c8cH6tOX7crZEklBdnywvD1nmWddJanHol7NmSAm0GK
         KEepS2++Cm/Wz+ZuJ++RVzD/tLbo+fA7BQUtO06VjJNsNt/aGCCOoKgLw12yvXCBueW0
         FIDdUXxwPwcfje96ya9BCxMb9nP1u8MUxcWqaOiMlrIfilOGvoG6vRUJkRSXnPM0i1f+
         s+jnrrmMg3rv7lIfHRedvpNdfk1eiIWh0Wjllz6u0MNp6LbMvzUzME3l5GCFMgcp/cQy
         vRJ7FkfcJDix2hHH6KGY9dD/dtWIGNP7h1ptBCxh9cXkblJwJxBEdL526rdjFAdzpo5z
         VxyQ==
X-Gm-Message-State: AOJu0YyI3OtzEchL7wM0ChNTCKBcOjuXLMuHIrUbX8nu9CwU1hIut9nR
	MpZ1OlLLVXuT989CneUzB6zCyeF3jRY=
X-Google-Smtp-Source: AGHT+IFOje3oKMeAknGZ5K6jItlOYXFlHRvQp2lcJanl9x7Vr5OKfAvABRnkptyb7DkIgVc8MR547w==
X-Received: by 2002:a17:906:6546:b0:a27:9365:ef73 with SMTP id u6-20020a170906654600b00a279365ef73mr3951618ejn.38.1705453163168;
        Tue, 16 Jan 2024 16:59:23 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.96])
        by smtp.gmail.com with ESMTPSA id t15-20020a17090605cf00b00a28aa4871c7sm7038982ejt.205.2024.01.16.16.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jan 2024 16:59:22 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 0/4] clean up deferred tw wakeups
Date: Wed, 17 Jan 2024 00:57:25 +0000
Message-ID: <cover.1705438669.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While reviewing io_req_local_work_add() I haven't found any real problems,
but there are defintely rought edges. Remove one extra smp_mb__after_atomic(),
add comments about how the synchronisation works, and improve mixing lazy with
non-lazy work items.

Pavel Begunkov (4):
  io_uring: adjust defer tw counting
  io_uring: clean up local tw add-wait sync
  io_uring: clean *local_work_add var naming
  io_uring: combine cq_wait_nr checks

 io_uring/io_uring.c | 58 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 16 deletions(-)

-- 
2.43.0


