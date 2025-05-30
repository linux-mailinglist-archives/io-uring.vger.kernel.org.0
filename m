Return-Path: <io-uring+bounces-8124-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC92CAC8A07
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 10:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A61284A608C
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 08:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 615D6215783;
	Fri, 30 May 2025 08:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R5z/2Ehi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5E638B
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 08:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748594230; cv=none; b=L3HgRBTSEZ0pcXO3ItOpTbplIzNpXxTxaiulgcMJKvEXZF8eIaP/aXpztkZYYaAm2ewx+VqTSr4mMR6JKXAwQrlkhtCecpLih8IivxbBiREwVb58ThUWpfkKAvVi6wLtWZZIf3Q+xRGrT7c4JZ63ru66gCmSOHYP2GjXZgmUnVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748594230; c=relaxed/simple;
	bh=By+2X/I57UFpaouZ9w5k/I+1pLgv5R9FRfU5dtf7Zu8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=db7Sa5F/7EQa2KW+geFqp4QjDh3DOvQTzV1BXy9YFHXCorD5evdUKggv+VrIGrS8avNpFOlBjE+gnO/U3B/AMhKgHraQbwNnXvmtJgZi/mP7uNtlGUPle5l7KZm5eXokcGvxTJmE9Iu+jO9WPOfJxWavfNaYidj/rJbSIwUevow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R5z/2Ehi; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-603fdd728ccso2943129a12.2
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 01:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748594226; x=1749199026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1uCyfZopTCUEXoFyFqVSj7MUC8sY4qI7mG/l/lU0zEA=;
        b=R5z/2Ehi1+fQngMiZ03kvU2GX1q4x+e7Tbvy/yBMv4VpOaQWGkjSWkc6HueM2gKt3G
         /vnSmtsmjud6w69IIOOnu7H6sgZrVYuGMxhOk9e1SXnqlHGOMFCoquJ7imvlSEWfdLJP
         60LA5wl+xw9hYWHQIi+rBjABow1kE6oLL0j8gm4oQ673VdtsbVrasNRrySCKs8iMMQQm
         rHxWXQbs5ershOVCn2FTjIOSlLdZ3KAIjnXJ42/s5a78k4LxHwkOJ2DQFgR69uENj66M
         joOmeNvPwVXQnF7Jy/n1clcfp250MrAocW3DpGvuPOB/N5/jr61IKSP+hUY1syoMg51q
         Lcrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748594226; x=1749199026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1uCyfZopTCUEXoFyFqVSj7MUC8sY4qI7mG/l/lU0zEA=;
        b=euHljjv/hZwyA1W7gsihdwqOwprEugbSpa0db9rJ9D95zwAwKAUQfWTKP6R1K20wnU
         B5CbeuJNboOYVC22AtYIiGkBh3Wez5XOA2zlZTtXx+Lw0sQ7D5onUFEOkY0plfTUOA93
         6EzMcR/wrVCnn5dHmkiCPOe9ctoHEtLFF2ZT21BBxlRa85DaVlbfDMbJ9no+qEwk0AtV
         /UgljHznOZvMGnEL6ENV9knGKVu4z9dvLz9uQWF55Xru4YXAQ5zVSeyT9ldOt7Q0ACUH
         ZAGTnFw8P8MUXv9nw4GsXJuDgr9IR5OmTpQv0WRd8WfsW0RDYO4kHVQs3dxAB3dPMtGK
         imog==
X-Gm-Message-State: AOJu0YzvkireMXlWzdh4ArkYhkjT3YYjevjLpt5dDGO2D+holkhvOH4G
	rAQ18brU6rwMckgMCjD+IkE7T0BL/i57p0aJTOIDoKD27cYVFJliTbynoQs7bw==
X-Gm-Gg: ASbGncsB2ELRfUlQVtdd88DEiFBew8Z5XJLT85SLkUjlA1QCyliM3x6SssomySv50ZU
	N1mv+tbOp5kp3m65sQCJZdC2TAM8UVDxp6ghPhWTmioQclbB6IUEZM9IkZvIkfH1kudflt5x6hk
	QlU1NpiflOsuDQUqcrciW0F7NLAL36eGjCD7uj55OfME/U539IFAPyF3/YgLFSgz5v7zMceRpoD
	1FGVb2LPuHu2HkKtihjrcSkk0mlCgdgWp+zT/d6n1L8HbP0b1E6WALeaDg7AN8JnRB2mLfGVRCO
	t26Tqcvh9xte5BlhQUFvHR+cOyKGX3x1dk4=
X-Google-Smtp-Source: AGHT+IHPdtulx+aVmNDpR42ycHYF+eX0ZeeHGkeV3//H8lBEs5TG2KGJ3D1MiTj5F5ObCXacVodYUw==
X-Received: by 2002:a17:907:db03:b0:ad2:28be:9a16 with SMTP id a640c23a62f3a-adb36c117ffmr120914966b.51.1748594226245;
        Fri, 30 May 2025 01:37:06 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:65cd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad696d1sm288126566b.161.2025.05.30.01.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 01:37:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 0/6] io_uring/mock: add basic infra for test mock files
Date: Fri, 30 May 2025 09:38:05 +0100
Message-ID: <cover.1748594274.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring commands provide an ioctl style interface for files to
implement file specific operations. io_uring provides many features and
advanced api to commands, and it's getting hard to test as it requires
specific files/devices.

Add basic infrastucture for creating special mock files that will be
implementing the cmd api and using various io_uring features we want to
test. It'll also be useful to test some more obscure read/write/polling
edge cases in the future, which was initially suggested by Chase.

v3: fix memleak, + release fop callback

v2: add rw support with basic options
    implement features not as bitmask but sequence number

Pavel Begunkov (6):
  io_uring/mock: add basic infra for test mock files
  io_uring/mock: add cmd using vectored regbufs
  io_uring/mock: add sync read/write
  io_uring/mock: allow to choose FMODE_NOWAIT
  io_uring/mock: support for async read/write
  io_uring: add trivial poll handler

 init/Kconfig         |  11 ++
 io_uring/Makefile    |   1 +
 io_uring/mock_file.c | 354 +++++++++++++++++++++++++++++++++++++++++++
 io_uring/mock_file.h |  47 ++++++
 4 files changed, 413 insertions(+)
 create mode 100644 io_uring/mock_file.c
 create mode 100644 io_uring/mock_file.h

-- 
2.49.0


