Return-Path: <io-uring+bounces-9839-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ECC1B8933C
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 13:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4FF77A99A0
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 11:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD6D3093CF;
	Fri, 19 Sep 2025 11:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rz+rRSu4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4282230BE9
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 11:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758280234; cv=none; b=rNdNAXUo2s8ZE+0f4eJxz5QILJl4niTPe4EEWwaU8eGUx2FN9aHIKzXzlwanAsWb9HkmEDMSK0vf0gLLaGyF1nfntyB1+Kv+4PzSkffUfOSBhIypR50W2kFBsRuHVRom5je8ispzAiyk2NlKk48Xa2Go4p0kclPGhI7DPDDJ3u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758280234; c=relaxed/simple;
	bh=3KtTkWbyNtTuGzPQzOjAuEbj2yWE6tbUVjsC7wznwU4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AV+NsCL5sRBvHVCi01dcQsEf3BTM2AzcFyfD3uLXgz8bDC8waSQYARMDJRF9fZGiw6nF1T0OC3ua3bQofO40wn6yN3ULlyGeuUOzErQuTwUyUrvRqjile9YoT9cWCRYdpY7GzGolFR0qFLpPkZBBD9gHnknCN8SrElpq9ufB9ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rz+rRSu4; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45b9c35bc0aso20963635e9.2
        for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 04:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758280231; x=1758885031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tCJ4/WaPmMzKav4Evu/GcDqweld8snjWz9zCb7QY97E=;
        b=Rz+rRSu4SCFszjircgfSW9CgOdy8fmgrIEbxs7h/EarzzjfV7eJ1EcoiYM8uq9L1+6
         zk+awq8hNN6W3FaMb8x7QnR9HJv3EF7kBoRpinqu5HAEyWXT+vP8jPJNxmycvkLaNpjP
         S+NRF2oGNst49Kku1vg91+RcNLLE1pk0RLczzR3WlDyFmGHUQq23uIZn5SiAKN/WzLzO
         kS70mLr/rkO1ET8Q21gH2vdwgWv1qMbxmRa/Mx3Is9wf307lWy1HQWCPCb4suC0Pse4X
         4yXwTfEkvT9sAcmk1T4PpjYPzqA/651SoLYOvcUPic7jJQbNAhiVHslcjVz2GjPDT26B
         ueOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758280231; x=1758885031;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tCJ4/WaPmMzKav4Evu/GcDqweld8snjWz9zCb7QY97E=;
        b=sN7pbZcg+h6CWBnupl07toyMj3qWgSC51DxC/Uo1YW4XLMto9Jp6RoeFvTZ5VsUn82
         p7KHhuLGKDNPLV8uBqrDvGp66SzvcDbA9CL1ZzSu5Hfp3cZhua0t+r/qeX18cNc6RhCQ
         H81qqlQ759HqHn2WtR1uY3RBU8W4Qmlkq1BaB7N6UyvhKyAB6n4jLbORm+H3jhrK6bWf
         BkzxSFB3v5oZ46b6jK62f7D7AeVhT0CI0UyCeoUr7qdqpQiZg5AHNZl8aYmgSHelAje2
         +c5aCTzGgTqPeI4lMeS0mbQdxvDo3sdRyAnpFKbceSO94hKJX7yqq3R3zOVhnPreYfs4
         lcbg==
X-Gm-Message-State: AOJu0Yw0h1lHWdLui9PzdMUrO+uy0FaFSWUhdaWhyA79TpQ/5dnoWZYW
	zOwmeO9JUEBY7D6JZSKZfd1P2elz18FBBqzfeJ9meTWgb/lR/QrZAdwr2mnQxg==
X-Gm-Gg: ASbGncsBxQwP3vQF+BQQhdvY0STej65m1gBiNRFxwNTO357SAd9qrcUO0UIbFV51GN1
	DCZU/r9Z1xx7GNUmtREDvfh6NViCRnyTDeSZbdxdVOHZpdGeS/gir5qq/Y9pPGtEAn+ygAgOmz/
	QcTh1CGIG5IqcdJFd8o+RN9BlOAz3N2pn4R8lg904zU2rH+eSpJmiH1SL8f3aC3s6x4ebNpehFO
	eAeM82CLmRzaPSWU22hU3fivr+/vVebTyB4l38i5pWM4ElqpEea2nXVHUek6iy4N1G3l9Yw5bsY
	FoAhk5pDHgXE988NuTZhrahK4HPM09kqXypzbqAvMraHL1m+zUzFWBwkxeBRXj40ix7nscp/R40
	DLtR8Ng==
X-Google-Smtp-Source: AGHT+IHLLfNa9cyzc8b7jptm+PHDOrQmYGZMAsaiHhj/pgKVafXVDSPFmr3A3keO1VJ+hG75//w4GA==
X-Received: by 2002:a05:600c:350e:b0:45f:2bc1:22d0 with SMTP id 5b1f17b1804b1-467eb50e7d0mr21490785e9.33.1758280230671;
        Fri, 19 Sep 2025 04:10:30 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a294])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46706f755b1sm48776685e9.11.2025.09.19.04.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 04:10:30 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 0/2] query infinite loop prevention
Date: Fri, 19 Sep 2025 12:11:55 +0100
Message-ID: <cover.1758278680.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow users to kill the task while it's processing io_uring
queries, it specifically targets cases where the chain contains
a cycle that leads to an infinite loop. Also, limit the maximum
number of queries per call.

Pavel Begunkov (2):
  io_uring/query: prevent infinite loops
  io_uring/query: cap number of queries

 io_uring/query.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

-- 
2.49.0


