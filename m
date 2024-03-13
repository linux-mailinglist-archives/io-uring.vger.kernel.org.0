Return-Path: <io-uring+bounces-922-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D3CC87AAE6
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 17:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 064F2B217DF
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 16:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE0B47F7A;
	Wed, 13 Mar 2024 16:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W0M04uR0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF41482D4
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710345983; cv=none; b=thCwMFhJoPghrx+v0pKMiM0N1Wl91VeEOPm0O0F8O/g6kf+apIG+QevCqw89CKxByIgcHmhf5GvgkdztqBPVGG2pg9Lr95+G8W2cxf36DsWSbk6BuDR3yslyRcvshxlALmHwUxcJUbZ0yrPhcpEu0qCSUxqeIQcV5Xkt9IjNuwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710345983; c=relaxed/simple;
	bh=56PS2uUv5D/XpSG1P4YjumZE+UBYxFvQD4M0HkMPk+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fGkgSeDnlCi54df1YOwE8dtpJQH/swljV1GxOBAjzHEaVbd3mUo1Hx2J9JHfUw3gf8zMS9mChwjFJj8qBReDv1XxGEAhJUU8Yos6NbZ6lsC3PfkxQt6I4CEBmN9bBfAzug44EMxKRHOVVmr1pbc8UIOuYqCXLWy97WL/6FAH6lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W0M04uR0; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a466a1f9ea0so52766b.1
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 09:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710345975; x=1710950775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bgzyh5d8LhTz9uYH2p650WVQj8jVsmRi5cht21MxeRw=;
        b=W0M04uR002W9n6gw9LNzlhe85vKxT+4lOabhL779LymNZiLBKuDbwy2chy/IoGIAWw
         FWL4LjGDvdP6MEoO5n0vORjw4kXHCHlg5znGLlxCTuXplQ0I6F9y7y7G613R+xMKNIbP
         UII+3AxodLLt5kIQXbbmj/Co5nXrmcB5WHnAtmrlw8FXUQ6+5UcBu+V7tkdS62/OViwH
         Fej13uLuKQOr+/bg4rnZmqJJGY2lLfU4KhDavIM1entvGYlo8h0An4+vGswNufIp+2DP
         KXelc4PFNWPwYzQjIViQLW1J1zxigl5US1ptRp+EAyahmbamTV/P0NfB/Dqy9By4WaXQ
         kasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710345975; x=1710950775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bgzyh5d8LhTz9uYH2p650WVQj8jVsmRi5cht21MxeRw=;
        b=ITKV8x24OwlNoLpntcfxrdWrmGJW7EqGNYfqdcnzONnlxG2fPRaQVF+N1hjfWf8J7v
         G3R9PeFzcTc7636zT+a8Of0cSQhQY3BM2Shfdd1U2d3hThUbZ3MhytCcBmggz1jKkOF7
         RtP349Zf+iPlhSGeeqLtuhc9M81TLaW43ekhMDzBYmC54AJUHuUy0DSOOBqtoqG9a/QE
         Y6tMD5d5Ig8y66VlS7zxBboZf2e2s8lbzDP3bN41c/3xXAltqBlyrPxrQ0CILbPL5QTV
         yhkGE6rKjcI4+7uqdc1walQ/7qabJxzPn3OdYng6nMZXpjw1NoC3fmlD8LvNEABXoNnl
         k5mg==
X-Gm-Message-State: AOJu0YyQ2lR/XNwzxr3khqTO26I7fP9ZbdoyBhm+H8HOXtTozFuCl/N8
	j8fASJB/1B9mjlWGa16Beck59FeKA69psna7l10f+vhOk7OSERGrZ0j1OCci
X-Google-Smtp-Source: AGHT+IHce/Ki3GHt0IRXcNrBU/TXEqHHG/04N3DCvD731LiZZ4UEMAQmg4ZO8XVcTB05B5ZvEDCVZQ==
X-Received: by 2002:a17:906:5642:b0:a44:74f6:a004 with SMTP id v2-20020a170906564200b00a4474f6a004mr8351207ejr.26.1710345975460;
        Wed, 13 Mar 2024 09:06:15 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7461])
        by smtp.gmail.com with ESMTPSA id k16-20020a1709067ad000b00a4655976025sm798328ejo.82.2024.03.13.09.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 09:06:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 0/3] small rings clean up
Date: Wed, 13 Mar 2024 15:52:38 +0000
Message-ID: <cover.1710343154.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some disconnected cleanup patches split out of a larger series
as they make sense by themselves.

Pavel Begunkov (3):
  io_uring: simplify io_mem_alloc return values
  io_uring: simplify io_pages_free
  io_uring/kbuf: rename is_mapped

 io_uring/io_uring.c | 20 ++++++--------------
 io_uring/kbuf.c     | 24 ++++++++++++------------
 io_uring/kbuf.h     |  2 +-
 3 files changed, 19 insertions(+), 27 deletions(-)

-- 
2.43.0


