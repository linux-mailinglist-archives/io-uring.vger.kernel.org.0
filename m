Return-Path: <io-uring+bounces-469-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16EB2839C49
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 23:33:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C20D81F213BF
	for <lists+io-uring@lfdr.de>; Tue, 23 Jan 2024 22:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8021D50276;
	Tue, 23 Jan 2024 22:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLa2F2Kq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21EE20DEF
	for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 22:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706049233; cv=none; b=s3Xj8bbrFFJuOYr55zyJw/7xJceDBIsHFEsq10U4PBn6bUCt3NJKpzD+SgUh7x1Fe3Jz7L8hVDdXuLlHDgFHXIQzwECTiVpyQJo1iHucq7MYiVPseby6kA/cuH44jk12z4J5P4abR1l2fn41tYyBTfGN9QaAjsPwCwkWvvg4qD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706049233; c=relaxed/simple;
	bh=7RcA+wpBojN9P3jXK1BGmVym3oj7yCYu3G77e8mtEqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FnhEODxtoWT9z9ovwA67Y5ApcQujSXmjJJBwV6dsIf2Ey2bwtq39uf7oAPVDYt/UO3adV2PE6x5FwyHZAotlJX2pIETUT98CrS7AWz2dNeS1rdowpmlYSzVeT2OeZUFq7hzTKNqhguohXcy9dGCndTOsvTwOHTKp492Nfhl3p38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLa2F2Kq; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-33922d2cb92so4286383f8f.1
        for <io-uring@vger.kernel.org>; Tue, 23 Jan 2024 14:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706049230; x=1706654030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vvyjo+Vy7Kiu1/HrFUuG+G2GbaCsCbrc6C12lfTVfo0=;
        b=fLa2F2Kqg+hKojk2v79dmgjLLKuWgYI7K7tD/lcsAnYprsZp2wBMZypOC/uHjMa8un
         /GuO9VoHRJJvWY8aT00kmhOUIJuftGuMbylGbrlsVJnYE3J5wnwH7q2YkizobFhbc9Fk
         alm0wqIAspnHHQZaBo7TsL29zhyoY2r7OBWnsYmwyayIr7NMbwCb7NjcBPoynDO7Dp2p
         UXUSIKwRM2gsMya5UvT9eCCsoLRdtykU6F74CkKg71aPzEHGwNLFTgND07X1xTO8rwz1
         yzImSIeqRZHL+5ddnE7+M+k5QDBC0bXfk0GdIlU9JjbqpEhW30QPGhOTRfVdyw23kLoy
         1j/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706049230; x=1706654030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vvyjo+Vy7Kiu1/HrFUuG+G2GbaCsCbrc6C12lfTVfo0=;
        b=JzvimDiq8LT8CIxWxUImoCdmFNbfDP/xN8LrbASUomKyWgAFGqEFUf0A96QsuypLaF
         6PVHXxyJm/ga2kPP1bDu+KJWW2RTAaAJhnvgJl7WODuKBl6lEBtesZ/6SzDgOSjQL1zY
         b3mBlYb4AMMpb3r9Mud6mci7ctFTlNmHhGnuz7a3Ia3dIXstECdWGiw3oANosnaMzUPQ
         fOG/XYKxaHinuclBDaPl2ZYALfm6d0JSOTsDSygmiMA+o5KtpDgvqd6U+NBa9KaK8tpm
         Zk/OLbskRmSyh+nwrVngHJ+oQyxVTLsaelrX3hX8iTX0WuNuRJXn+NhFI2lyEejL0vyW
         Wlqw==
X-Gm-Message-State: AOJu0YywR5Cxt8tfuBL3PPyROEoThosPRZFXTycxCTkBnJF/wBjGafrx
	hUYt8PYIsS+fskcSnW5AO4MwiXfjjol4znvCPlJStqSDsAupE3HO
X-Google-Smtp-Source: AGHT+IEbIoTnVOEHkXwxUq17pFncyAShAiGDhYQS5bWCVEuc+9kWEJbTavZ5dNVpsfr0SggV0GbR8Q==
X-Received: by 2002:a5d:51d0:0:b0:337:c829:de48 with SMTP id n16-20020a5d51d0000000b00337c829de48mr1555545wrv.101.1706049230002;
        Tue, 23 Jan 2024 14:33:50 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id p12-20020adfce0c000000b0033865f08f2asm12436514wrn.34.2024.01.23.14.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 14:33:49 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk
Cc: krisman@suse.de,
	leitao@debian.org,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v4 0/2] io_uring: add support for ftruncate
Date: Wed, 24 Jan 2024 00:33:39 +0200
Message-Id: <20240123223341.14568-1-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123113333.79503-2-tony.solomonik@gmail.com>
References: <20240123113333.79503-2-tony.solomonik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds support for doing truncate through io_uring, eliminating
the need for applications to roll their own thread pool or offload
mechanism to be able to do non-blocking truncates.

Tony Solomonik (2):
  Add ftruncate_file that truncates a struct file
  io_uring: add support for ftruncate

 fs/internal.h                 |  1 +
 fs/open.c                     | 53 ++++++++++++++++++-----------------
 include/uapi/linux/io_uring.h |  1 +
 io_uring/Makefile             |  2 +-
 io_uring/opdef.c              | 10 +++++++
 io_uring/truncate.c           | 48 +++++++++++++++++++++++++++++++
 io_uring/truncate.h           |  4 +++
 7 files changed, 93 insertions(+), 26 deletions(-)
 create mode 100644 io_uring/truncate.c
 create mode 100644 io_uring/truncate.h


base-commit: d3fa86b1a7b4cdc4367acacea16b72e0a200b3d7
-- 
2.34.1


