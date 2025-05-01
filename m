Return-Path: <io-uring+bounces-7808-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B8C6AA6340
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 20:55:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C4933BABC1
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 18:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAA511EDA2B;
	Thu,  1 May 2025 18:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="krhReQw2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90C6218E97
	for <io-uring@vger.kernel.org>; Thu,  1 May 2025 18:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746125750; cv=none; b=NR0xlt5hqIFELJEQmX6mbT/QcWKcEg+7WJExdCNS/Ltmv87sEDMkY1z0pr7EolSwcR5wv7CdRRMl8QXvd2A7E0OvdOtMJddqOZp+D1G6p2SHKkCVj889YXMDv5dA/HDC68ibm5IWStswpekGmzauok+dvLho1e+PTmiEGAJ+kl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746125750; c=relaxed/simple;
	bh=ODHogYgVvrw8rSRkvQNEylVsp7RpVglbU4vEXJCrb0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boOQBJ7wCe1Nt8weUXLh5n0chPNP+mPURGF/nMxJPvU3JbOm6FBHY9SjNhzBiu3WZT++yfBtM/E/rHGNRit2Tf8CNV8BuQov4ztV4cnMwD5acxF9YIRXXjkMHzYWwmzgHg1dfvi81bWCNUTMgtGJGfRxMCgbGobIQqhO4Dh9T0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=krhReQw2; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-acb415dd8faso181280066b.2
        for <io-uring@vger.kernel.org>; Thu, 01 May 2025 11:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746125747; x=1746730547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wl/cUXdUUYZ2aIEQWAfOu8wHk2T488QYCfdLI8jqnrY=;
        b=krhReQw2Xqy4mSh7CU47kZyp8RQn7Z9Fq22DYdUBCH9kKQm+7ajs6JG7ffXlmA+APA
         i04H9JzZ5HTSnAxtXmDhUyvNpiVKMEoo+t+WmF7Zq6mXqRYOiyBaLEP0M0rytGtcXTRT
         NKMx06QcuVWjyk0oQCT/waRGtc2MbWj3YSupAkGc67U2xcAtL8KAlbYWbDVx7/kxmy8y
         bVxfGdCts+Z8Je5m0gU+kCObam2WwLts88aTXGRqrxuzs/Ik8jV4VWwyPzNkTwfnk+YT
         DwwbuCeBVofws8GB+TbUT2MeG+VXcfnbNX244WMBR4RJRIS+QWX11dHWVjeqRS0y4OMt
         xtAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746125747; x=1746730547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wl/cUXdUUYZ2aIEQWAfOu8wHk2T488QYCfdLI8jqnrY=;
        b=B5tlJrHlsL9EYgr8gEj5F6zF3mpUaXtpYZammKq2yPWNwBKcc7p0qpw89CFDhE17ae
         mzu4DALo2Nn/8bXEW5Ovi9O5q+uaBq9tFcieiyuQ0BmlyC96ScEN29q9AhkvJWudf8Hf
         FWH2d1tdQ8ynCHMWkL9KS+axEHBZHAY9CB8cQ4nYDU/mzKm39ibZ40iFgIyUpwiPI7fh
         CnQlaViXywFEkQEaOmxciQTeYTT2KN6h8ompEqF0sS47LPI99GN1Tr+Vj/f7Ho0/qJkK
         hSrNaaifPAbUUERKFltQ5L5nfCjP0SLCgPQKTQUJ9uDaDrYEcPX2l+v2NM4P6xdcyxt/
         6Mkg==
X-Gm-Message-State: AOJu0YwGEJnm5rWh+iMHTtFd6RjqCBycr/DwTQK+yb/Z3xzBBwqX8uH1
	ktMRH7+gk8wogcc9HuOcaiRnTbatEBqDYsn3ts65vyPBn6noWvNg3ZRu8A==
X-Gm-Gg: ASbGnctE1fWJi7E+NflsGeRzdMg1v84z58EFKX/R6LXiGB3gLkuWvIwQtV7ra+u+DyU
	90nnKBYCu5NSIOkJOdXopMxlNMrqFDiaYGtCnWURO8cjS0fzfdW1k1oXQ6VK7OmQnqQaiT3E7gC
	m/U6ArZ8RjIdf63zgalr9fCpekNkheaWjHIbwxTjqTBSR7AOUmCPChSV8+I6ytQZTIjegauFnkd
	kdtMgAwh+Hvlw8KG6WhXyl/S2S/B7luuILeIPnrmF73odJbbjUYqxT7oqIby74J4IbLz0fXyUXB
	T1cqsYI92r/TakLz+mFkkd0mnAA6Ff1eZqXZ5Bm9C5RlQpit4B3HPA==
X-Google-Smtp-Source: AGHT+IG4BhnFykLgdOeMKJ1X6sjl1psJKw4vU8C6331oW+CuscXKj2+lBZ6ih9/P2zKvzAqmvaQxWQ==
X-Received: by 2002:a17:907:6d06:b0:ac7:efee:d256 with SMTP id a640c23a62f3a-ad17af7eccbmr31162166b.59.1746125746714;
        Thu, 01 May 2025 11:55:46 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad0c70d3955sm79059566b.7.2025.05.01.11.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 11:55:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 4/4] examples/zcrx: be more verbose on verification failure
Date: Thu,  1 May 2025 19:56:38 +0100
Message-ID: <82dca90f38375622d328f663f6281be265d423a5.1746125619.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746125619.git.asml.silence@gmail.com>
References: <cover.1746125619.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print additional info if data verification fails.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/zcrx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index d31c5b36..6b06e4fa 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -216,7 +216,8 @@ static void verify_data(char *data, size_t size, unsigned long seq)
 		char expected = 'a' + (seq + i) % 26;
 
 		if (data[i] != expected)
-			t_error(1, 0, "payload mismatch at %i", i);
+			t_error(1, 0, "payload mismatch at %i: expected %i vs got %i, seq %li",
+				i, expected, data[i], seq);
 	}
 }
 
-- 
2.48.1


