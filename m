Return-Path: <io-uring+bounces-4760-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7AF39D00F8
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 22:27:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 669F1B23A6A
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 21:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1C61A3BA1;
	Sat, 16 Nov 2024 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nW4tmSfe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C1B19ABCB
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 21:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731792436; cv=none; b=blbdV+e6aNFUYu0Rb3HPIlUvMmMIpsTUrtUivlb0yn9ujqnDAoX6polLvh6NOK6b9GXEmsu/YT/lbppRLNYpI0/RYUzpMK/cod4h21nMYa1fM+blMUJe+Rzjy7XfeOSwzROrhrDmxdHVbhZAZzjcN2uK1qgPgJ56Y5zaw025aZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731792436; c=relaxed/simple;
	bh=0oquaQSJronYWIIv+ITe/LbMsasUYJPeto+6SMQsExA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajT8gvHxLzz+R2I9OjDcg4qDihdvvZTm4GYilT/RaAg6Lf9pxMq+FFA3T23UKL6KVw9AWpbHYH/xmjvwnuB5W7Xps/O+hC0D2gyOpyk53MjhRf9+dBbQKfN/iXAYxgaD9xYnNUwWv9TFR80FRdCMuABJi9gaZsjay89JEXrJ6UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nW4tmSfe; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4315f24a6bbso24046485e9.1
        for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 13:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731792433; x=1732397233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eh8S1ft0d/EV8XH2TSFyBR9s0X7trD21Wxf8HXk8GL0=;
        b=nW4tmSfejr5NdT+lUjM/MZCrakcsSWfFv4tjAaF6dFtj6OwO2eYuVhfKbn0FzzkK4b
         8YMjQpJ2Avhn/MblDn3766BqhP7ooZqJA7J9ozzt/zW+LMEIrudVgYKV7lGnsMzE/aIq
         IeKSBRO2eBflBGKACCWT+6L7xGk6WcrQbNgWzzK8MycCU/8y38OBWZFo0N50+gcv6JTp
         N00K2tHhwtffL3qcOyZMcdNPD819JhdGNKA61ORGoR5hbUaBr7izN7jps5g8JrOJUASC
         6d/tSns77qzziKV49XSLunI3tb8lnutgWyFnishxIhNQMzGbS+FgbDMXaNoA2rSd/Hd0
         sXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731792433; x=1732397233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eh8S1ft0d/EV8XH2TSFyBR9s0X7trD21Wxf8HXk8GL0=;
        b=LaNOU5xVqs5e6rclXXi7TVuYFTjHfXGM9xdqSEDhnyhK7vtgY815b6jlxYENYeyix3
         Jco9zeYV8jQK2GYlveuparFfreI72Mht8sP41AQUNd11IbM1JC8XmsSeiaCRwk+YzHnv
         3N/GWw3ODOt814yvNf3lC4O8vYX5yUL3b2PpmLF2H4CPd1EtEU78u+eSE7nXjthB5reg
         dycDyTw0w9J59vSYl0hy5MnqFuXVwAVEMr3Yh4kSgfLAgnwzNRuzpzorolnHn1cIn20X
         5Qt6luWEzFjmGXJfcXiPNXJGvAM76BG82GFY+CL3TrlVBX8a30flZeoX15GYtc7Mu7dI
         Rfcg==
X-Gm-Message-State: AOJu0Yy/n59nHmg2yoGNlL4kWVkTAI5EsnzhqUlaAtpmHvnrjuBCfu5h
	BaySFI48H3pKqTVT+JtE/xo76JrFBnJx4bBG6nW2viwbJ93lyqRBysctvQ==
X-Google-Smtp-Source: AGHT+IEF66p13O7uX6kntjHoqnD9DDnSKhCnzsqXH8UgNOulvn5QjB5WjfHgl/Bb5cnEJ4RLN/B2Yw==
X-Received: by 2002:a05:600c:1e11:b0:431:52c4:1069 with SMTP id 5b1f17b1804b1-432df72a7ffmr63948325e9.8.1731792432711;
        Sat, 16 Nov 2024 13:27:12 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac0aef0sm101071325e9.28.2024.11.16.13.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 13:27:11 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 4/8] test/reg-wait: skip when R_DISABLED is not supported
Date: Sat, 16 Nov 2024 21:27:44 +0000
Message-ID: <0552baa20df1d23eb05f585cd45ed75ce2c7e277.1731792294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731792294.git.asml.silence@gmail.com>
References: <cover.1731792294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index 6cf47bf..c4e5863 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -234,8 +234,9 @@ static int test_try_register_region(struct io_uring_mem_region_reg *pr,
 
 	ret = io_uring_queue_init(8, &ring, flags);
 	if (ret) {
-		fprintf(stderr, "ring setup failed: %d\n", ret);
-		return 1;
+		if (ret != -EINVAL)
+			fprintf(stderr, "ring setup failed: %d\n", ret);
+		return ret;
 	}
 
 	ret = io_uring_register_region(&ring, pr);
-- 
2.46.0


