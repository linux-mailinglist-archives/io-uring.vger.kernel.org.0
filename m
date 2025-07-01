Return-Path: <io-uring+bounces-8552-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 04DFBAEFA8F
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 15:30:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3831A1C07F2C
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 13:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A98D3275B19;
	Tue,  1 Jul 2025 13:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NvwMqsBh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A432737F3
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 13:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751376379; cv=none; b=PGGP/Y4Jqzdz3C1iP3ArOkxID45Cyx4th7A6YTivXVeiFB+pvphjP3IWYudS8ISbbgAqzXK/uNo6xcsYh+gU8KFPdnEN8vwSOIUFy4thPxI+NmnY7AvC1GlRDDEPeCsIey1E6rhT67J6TC9vWLpn7E7MDohmopepuRIIbG47diE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751376379; c=relaxed/simple;
	bh=p6YmmT5HT4B6WH4G/+KDEYzYtszHwlmj9R5Dr3O4PVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m28YRWRcHg7/pxfwe0bfKtOHEQzfCEyivQXt/gfQVOxZ5jJEjUeaa9C3wAQl8r9e0C9qVeHEh3F89DGALh+7cgOq12llU7fDObyS3t+tndlQpphrMhP7yB2YMz8gAuC3LG536qCB4eswxBAWzXgPld2aMtT2KmwxIQeNP1dHrXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NvwMqsBh; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-74af4af04fdso4074976b3a.1
        for <io-uring@vger.kernel.org>; Tue, 01 Jul 2025 06:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751376376; x=1751981176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YVZm1Vdvp/4lfQIsk8FrZGuLki1LTvXVsBDcE5Xypjk=;
        b=NvwMqsBhrHc5nnbz6/fjkn0QiH/4yCI1OAgbQ3zqWj+DCZOs/Wg06QrXLdzLkd3I5p
         kbD18i/EIdGfXLpi+dot1gXmUgfig89TMhRQPSjYHcbOicdbLV2ltngpwWYUIB5wTBPe
         Wbx5czxxe32fuVNnDgxo1Lfsul3E1lj5/7g2UzhD3k3pCt17JTQkBL2TriwSo04Nd9h3
         e79zMUpF9EthTRZDDxE/g6z+xA4a67MLyJ19RCxMdfrjv+Xdi/pT8Zh9j3cYVMWSCH8W
         KnjVekOdupC1r96aibAkC12Cb6XFZ9txAXgxMaG9DjNmPoh6igIFsta/XcZVBCuBZzJ0
         o64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751376376; x=1751981176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YVZm1Vdvp/4lfQIsk8FrZGuLki1LTvXVsBDcE5Xypjk=;
        b=XJ1gfAnyK202VWUgp14X/M0A9XmfoHq+kRCkmn5aPpfq8oeItDbBrAoCZzd+WkVa6R
         1uSE9qXW0LPFLEnWa1ZqJ9XK0bZpepvx//YXfncjVQJH+CC20XUwo9qOjZ0LBcO9IVw+
         /g1g76Xk+bLgrQ4y6MFkBILzy0g0V6il5MG7O4Iqha2FKjb+I4D1YhYEyJ97bpKKMgNa
         WnM4Ep7ZwdnVy5CidmAciw7ZBj4Dr1KxaZr5sq+w60r9O8PY7ePv89UIhLnpjTfGnVFd
         3PnGzJ0gbvhaWal3msmqDZQyJLhPiWoKIyqeNzp1ND0O1O1AG6rHYPmRMPtiSznEKlWO
         WmDg==
X-Gm-Message-State: AOJu0Yzh0CweKPpgnZGOxp17QCfP/VjOmKiPTZ7IQlSLT5ez3KzC8mSu
	bQK1bBMMursZVCoMPl5BkIhvmX/fs1cqR2Y1clOKLve+AKp35veGTb8pIJcMWTBA
X-Gm-Gg: ASbGncue5NU5NwANRcmcsfKEJ9QTynRi3ZPX54CRjWpqswhuVJS5az+sT51rdNRhFqA
	NC6C7KdmAklO7IjtnJ5UQWk600g6wzj27fNVV1DhvTTPHogHZQ2CBHIMq/xBoK2Znpimjd1BBpS
	Xc1hvLi0h9QCgKWPD/rBrTP/ecz1wHlVT60eeLW2xU7gIfX2jHqEYQd9u1mpV+SveeRDwxl4pKC
	LTut+cOsKcDy/1JFMBPdjYpRI2PFuUwA4H47Ugw4qefaIpWxSCMgT9dY7VqYJxObS+Vl2sRPEoP
	LnKYJ9exT3qsIzduiircBA7gIJL4hYy6qr9bDkOXh+mHUfNl5sEsQkOZvj1AbkpyVuDZKg==
X-Google-Smtp-Source: AGHT+IH/0fkg9rxs/dIAoWumrwIHVfFhUQYD8yYA6N9YnZ93kvway1ux8L+9iw2+bI/oUrAHWsstIg==
X-Received: by 2002:a05:6a21:62c1:b0:220:98bc:e0ce with SMTP id adf61e73a8af0-222c9964a6amr6616565637.1.1751376376091;
        Tue, 01 Jul 2025 06:26:16 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557439csm11788025b3a.80.2025.07.01.06.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 06:26:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 0/6] zcrx huge pages support Vol 1
Date: Tue,  1 Jul 2025 14:27:26 +0100
Message-ID: <cover.1751376214.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use sgtable as the common format b/w dmabuf and user pages, deduplicate
dma address propagation handling, and use it to omptimise dma mappings.
It also prepares it for larger size for NIC pages.

v2: Don't coalesce into folios, just use sg_alloc_table_from_pages()
    for now. Coalescing will return back later.

    Improve some fallback copy code. Patch 1, and Patch 6 adding a
    helper to work with larger pages, which also allows to get rid
    of skb_frag_foreach_page.

    Return copy fallback helpers back to pages instead of folios,
    the latter wouldn't be correct in all cases.

Pavel Begunkov (6):
  io_uring/zcrx: always pass page to io_zcrx_copy_chunk
  io_uring/zcrx: return error from io_zcrx_map_area_*
  io_uring/zcrx: introduce io_populate_area_dma
  io_uring/zcrx: allocate sgtable for umem areas
  io_uring/zcrx: assert area type in io_zcrx_iov_page
  io_uring/zcrx: prepare fallback for larger chunks

 io_uring/zcrx.c | 240 +++++++++++++++++++++++++-----------------------
 io_uring/zcrx.h |   1 +
 2 files changed, 127 insertions(+), 114 deletions(-)

-- 
2.49.0


