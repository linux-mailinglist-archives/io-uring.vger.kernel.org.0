Return-Path: <io-uring+bounces-5619-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 783D19FDBC5
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 18:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB3AC3A13E7
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2024 17:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ACF218EFC1;
	Sat, 28 Dec 2024 17:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qtp4LE/M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715AA18C939
	for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 17:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735407852; cv=none; b=c2t9FmkBMUEiK/lfZpjwLPO3HR22ocQcYwInSAwEDYtNSyqX+MFwS9/Nafps/sR3ejpoa9rWkB750sfvXer9Kh+gN1gqCmyJUQ7aMDa5d3wIYqei8KfZ4M3RRlW94Y9Dr9HZQDVt1M7miKkCrFny3LeSVojOX9IXQfHK2rCYwpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735407852; c=relaxed/simple;
	bh=jG5q/jsmxTPEPBmys0DQP+hqfmDGfyZSc5AFcar6E5M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c8pyM0roa5YH8yjz4D0ahjJrOfd4PIF2VqKbhBO6S40ZQ+q/OeqC7JailJgU3R8aYCpARgOHrXFK2xw8NdFXUKS3y/wyY42nA+YGf3avunzy0cl5E8JX4IOdmIEc28wfCKgf2OSfEeZfEafNaRH/Pa6enSydUJe55iGL1q0b8Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qtp4LE/M; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-436341f575fso85009575e9.1
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2024 09:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735407848; x=1736012648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LRkme6iHsQIYuAJqk8sx/ssjB2nI3JcusLOxWUeUQ4c=;
        b=Qtp4LE/MtmCyTh3ka3Gch091sBfXTRTKxWrhLkqTq7g+QC49Ko4rJ+bwwFKASjlqz4
         0FAwMa+NuqH90ZpdBpzIrrvuyGNiP99Ds6yXlOw+MKrlnZvUfyWyw0mndIMeySNvpiFO
         +dEc/83M3kWt4uIcOaeZ640qVJCkU+juL4rPtFs+lBzYNPWTrh9qlISFYeGKszKqj0E6
         Z6bxchcvyugyGZSsZ4I98Qh0TnLlp8jnDKLrb8AYHa83lGduDBCmxSnBC8NJ+xXweGVk
         1kx2ZWGAIKDqO38WlZ3Z3+oHrjnuECE1a48n+yskxhdx8QfXtSukHJeNT2w1ib7IDUPX
         65Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735407848; x=1736012648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LRkme6iHsQIYuAJqk8sx/ssjB2nI3JcusLOxWUeUQ4c=;
        b=W2OjnjtK/oIEQ3txJ2LIDgdacOSo/EXsimkX6GpybzqeTklY7lLqUqeINnw5ondL+V
         J8Yfaj2gZiyRjhQWasNV+BNPYxppQoCW0CgTZDmFNxcsEKXZXVaW04cuusD0p3G8/EQM
         Q8Y67GD6T8R8+KkCjOgETPJM7ACg3LQeW7RlNbJanOumKaDwZOpyydwmLc/ukjESqLIf
         OcrA3yf0qYOLZ7sqDp69g8htkquECLKyZPcMTMTpLD37M/m6Gt7X0taPaBelw7qo3OLq
         /J5rYusBuGxw16pJ1r+U6uA9pX79hYxddiwmM9+taIatrgJtGK56hGnT/CRSsbChthvh
         X1dg==
X-Gm-Message-State: AOJu0YwPI6sNQToomW1l3HkeJjHQuKSA8SvUc4UJbbTlRHji9twk470b
	Q9ETl/xWV+RUC+i8FL0og4XAtEFcSzwAf6GnEfCKn43y4Wp58Ubr5W2XoQ==
X-Gm-Gg: ASbGncscf6J9ymjMZMZffazuyIOlW6XiEZOg6bL5RI0+ciQ5KyyWj+nGYlzlO/5Repx
	fy23U05gmYZL9w+GU5Fb6vpIV7IwpXmC+wqDtJR/JjQnmL2iASp8DTBwm0SRsT17oPnb9Lwyf9q
	m1UFdosv+NIAuUvsxXIZMbkE7sCnG0kxHrIdk7DTMvAsZPz42z68+bOvzWvQ53CULbYiKfAB9jt
	63kwsHxSDXeazMQnZCAIjnUpRixnGDzq0e2Y2KgP9fa0eQsDIHOMmjIQRdi1EMyy5+UhJs=
X-Google-Smtp-Source: AGHT+IGB+jrK/1ld31yDbpEOcAhAPzwcLMrOEa0dDZKmggBm+FshV4jb83m6dw7fJi9spdDZ5gQDpg==
X-Received: by 2002:a05:600c:4f49:b0:436:6460:e67a with SMTP id 5b1f17b1804b1-43668a3a334mr230619155e9.25.1735407848239;
        Sat, 28 Dec 2024 09:44:08 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b119d7sm335386795e9.20.2024.12.28.09.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2024 09:44:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH v2 1/1] io_uring/rw: fix downgraded mshot read
Date: Sat, 28 Dec 2024 17:44:52 +0000
Message-ID: <c5c8c4a50a882fd581257b81bf52eee260ac29fd.1735407848.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iowq path can downgrade a multishot request to the oneshot mode,
however io_read_mshot() doesn't handle that and would still post
multiple CQEs. That's not allowed, because io_req_post_cqe() requires
stricter context requirements.

The described can only happen with pollable files that don't support
FMODE_NOWAIT, which is an odd combination, so if even allowed it should
be fairly rare.

Cc: stable@vger.kernel.org
Reported-by: chase xd <sl1589472800@gmail.com>
Fixes: bee1d5becdf5b ("io_uring: disable io-wq execution of multishot NOWAIT requests")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: inverse the if condition

 io_uring/rw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index b1db4595788b..be176f4828e2 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1066,6 +1066,8 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		io_kbuf_recycle(req, issue_flags);
 		if (ret < 0)
 			req_set_fail(req);
+	} else if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
+		cflags = io_put_kbuf(req, ret, issue_flags);
 	} else {
 		/*
 		 * Any successful return value will keep the multishot read
-- 
2.47.1


