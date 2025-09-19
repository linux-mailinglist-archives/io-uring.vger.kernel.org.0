Return-Path: <io-uring+bounces-9840-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94ACFB89339
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 13:10:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EA0B16913B
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 11:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1FC6309EF4;
	Fri, 19 Sep 2025 11:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZQDmJHt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EECE27E041
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 11:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758280235; cv=none; b=XCUEkK3TyxwUXh1mFu8b8KeJnWj0xB9uXuNhjj09os1L1KwKH2mDJYJe7htCduG0zSwoEz4g7fim1hzmErQV0HByuDG/zBVDMnRAWpEYbtLDgXvxODg0QLheBpJYSu95igxni+bwWzA7Madirjj6Mew6ajKl5rjAn2UUCyMWxto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758280235; c=relaxed/simple;
	bh=oKu7atLAG6LPmEPYAKxqnNmx3IYt6MSAI5bpa0oj8Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPUItInR065NyznuTxonnLiAOrnotBYKHkzGHA4AhwJkfJyqiU7ocIwnCLg/lZgzxTGRXUBkL4+G1C1ihUM3dY0n9pPNco53Hricp3GsqSubrvrQyA6Km7U06oSM4jO0RCuVGYAkzbfRmfzYNpRsWV+47Gv0eZF9w2sKqQEwqhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZQDmJHt; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45f2f10502fso12429235e9.0
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 04:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758280232; x=1758885032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71QUZUYdpoxS/oeyWbHPRvEOa6T5OhkcepctsG+PuRM=;
        b=dZQDmJHtmFGczVzMJcFbwNL9qkelaay12Tgz+lqfMctEnrfRajADsnEmhyUOLeFIVA
         fL0vthAPEcNsYcSzHPfeHoS7gAKPanpv8aZ1spAg/mBTj/PH/4E1/YrHmqI0u0ELVQXX
         8WfG827Ne8/Vyd3iVj5DlKGadJRBXUoG4wJQgZY2MiTR8L0xigr5zOWETaSjTASuWCNZ
         CbDWc0E1jLN7kewokAJEgclMpe+9uYpGKf4LXjuHENgcFayPjtlRwMSNFlg0+UIdTf5I
         WKQTcHblkbHp2R8jkhE5dNrRdBMcLuiidCqcUQQ9Yo7JksDM9yvCYolr/ckk7DyTwykp
         ybPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758280232; x=1758885032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=71QUZUYdpoxS/oeyWbHPRvEOa6T5OhkcepctsG+PuRM=;
        b=P7tm+uGK8tlv5XqgYAGAkZdb+lZcyiBlTI92twXi0Mjytfgz8OAcP8bPXR38h1av0v
         f/8/A17yd4DWsG1vF7zgZQkpNhJw+w/thwSVu5FylddfsW078ENFT77JfjstbJvSe7ST
         +yngM9aKI4r843asGVjMN28PFOn9g0x+Ci4XyixOynagw9B6fIu2b6YSXs1LJ+N5fAsK
         +y16I8qOWE0yF45ey5tB4bKGmYynDeq7fmqGF25pnBbZuAmF6DjLqoUpDAgIlQC2dWtF
         eG3+87Fo5Ps3g4KsUN+m5VuEMZcOK+duq0aXkI72x1UHNfwWS8i0jPoyE691+JEB4Fax
         Dewg==
X-Gm-Message-State: AOJu0YzoesXRCQhP0Zqib23OMM+oCMxHiLgTL34zJ0ta1wlewdxpooeo
	DFuT0VFrl1dIlg3wJTK64ORSduP1ee8Z40ljF8Z9Ti4LPUgDU6sESIYE9eTmBQ==
X-Gm-Gg: ASbGncvABFPAaos7+xrcODwBA82j7GiJpXD565tE1PR8E5Lc2xeZguNEbnj5ZJYpyjM
	rSC/iCnnHfJHk9zypgyyeHpkgLRImNiKsMDlXVfVtv6z0a2JFKy+7GJkggYqGFILRqL7/iGIK0g
	1ZgnyFya5mtvyQhlozKwmO2qu2SHxk46VcOlvb2fdN/ZemgzuksJURDQbPclHHc1oAO0ogbJQXr
	war5Al+PCoNOH6nye0RybgQEmTjs63doQ46w6/segenHMZUHGw2sSeictqyHQYmkuH7RtOy3tLk
	oeijIv1uDiikZPEGEirqpJ3x6xrNP8OniqxOyer+sk8lQpauqMCcz/GAjl5FQLgdwQqeeAac2D2
	KdeIwEQ==
X-Google-Smtp-Source: AGHT+IHw2oKVriYhybxMtrNN6G6x0bFCpkYJ0bqirmQpY02IBGoeVm3ER8YOwXz8D8eYbFoRoY5Swg==
X-Received: by 2002:a05:600c:a48:b0:45d:d19c:32fc with SMTP id 5b1f17b1804b1-467e78caa13mr27758395e9.10.1758280231803;
        Fri, 19 Sep 2025 04:10:31 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a294])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46706f755b1sm48776685e9.11.2025.09.19.04.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 04:10:31 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/2] io_uring/query: prevent infinite loops
Date: Fri, 19 Sep 2025 12:11:56 +0100
Message-ID: <f75507859ac323967db8b7801b82122aca4e2c84.1758278680.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758278680.git.asml.silence@gmail.com>
References: <cover.1758278680.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the query chain forms a cycle, the interface will loop indefinitely.
Make sure it handles fatal signals, so the user can kill the process and
hence break out of the infinite loop.

Fixes: c265ae75f900 ("io_uring: introduce io_uring querying")
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/query.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/query.c b/io_uring/query.c
index 9eed0f371956..c2183daf5a46 100644
--- a/io_uring/query.c
+++ b/io_uring/query.c
@@ -88,6 +88,10 @@ int io_query(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 		if (ret)
 			return ret;
 		uhdr = u64_to_user_ptr(next_hdr);
+
+		if (fatal_signal_pending(current))
+			return -EINTR;
+		cond_resched();
 	}
 	return 0;
 }
-- 
2.49.0


