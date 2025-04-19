Return-Path: <io-uring+bounces-7570-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAF2CA944E6
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 19:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17C3E170E40
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 17:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8039E6F099;
	Sat, 19 Apr 2025 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ExmFf4fc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DA714601C
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 17:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745084772; cv=none; b=XttsdeuXmmN/8iEiAMYIw2MXDh2ADePwNemz/3SfkCJ4nsk+inQ5khaA2nW7O62D3SIVqlZeqkFX7bMW+hZvWYF+pRHdBUkLoJxLWQ738KXlIxa7uBB1rtNa9DmhhNVC6jBSjT3at8tnWqOwI++DzKPw5T3cpWlp+5o9haOidHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745084772; c=relaxed/simple;
	bh=GEo3hbBxiX9yehb7Io1ZqPQBbtoyGffMRK2AWnVRDrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiWs7rknQYMQKfseofDJ4u2kIQR0WIeLC76oTRP6JA+/FzCA3d5FpkywGXTO67luTNju6PYiKtFd88BltTdcT+gYjk//9wK42KrXMRrCLm0dAq0LkeUhndl6HttTOxmTG1lpsTM6gwzkzdZqDkqG/W6qNW9g3EI2wOBr97oplcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ExmFf4fc; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-39141ffa9fcso3381382f8f.0
        for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 10:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745084767; x=1745689567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjqqm4EuOu/YKHhUjF0IMWB4tDDdnkDhX2JFNNeOdUE=;
        b=ExmFf4fc5bE8BRcZ3BpCSuNKnHXaibUNyxaP494HCy6OOWs35qAfL7ZUDmrbFaHonN
         IjQB33Jql4IZuEHXsubUvnDpr7bBdktpbnXqiw+LeKZa3YeknoL/TdDqj/cZhp7ZEbuc
         WApcuTtvuAGVYAJ93yPlljm1kqTTDC3iie/D8EPzyhM7kU6LkJ0/xPXsIw5oFwg8eTJc
         ASP7GhiZjibpGsxhgND3F8CYlfE6BuhL4ULZJExvJLh9uqZHl2Rc3o6uPY07IK6Gq3Va
         1/HJRdD6HMIOHK798Edxn2dfosYgU9uHqJggbiCqyjcjMfIA89vFAV/CY83e2fZYEEFh
         nb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745084767; x=1745689567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjqqm4EuOu/YKHhUjF0IMWB4tDDdnkDhX2JFNNeOdUE=;
        b=ELFFAFAO0rlPRz9tAglOADil7qKMgXU/HNDRGIYhlz0PAYCxP/v8cs2wYe+1Za2o1I
         rUZMWqxJSFWGGuLqG52hus1CSWlQLfbiwAVofRQOeuRMp5h5h6Ei/LjHFW4PYZiumDkw
         NU2m04yYz7+B/iSv8PdqhlsMmis2CVP4jzI4q/j/A7nVvNJcb1UcAJkQZ+GYy15q573c
         9YtQBSUz7is1zPGQQTKq8qoeQdrMlgPUtBbHu2loS7t8bYYrJTi5jpfmZOSXEgxROalv
         gN3cNe/ShEEJRRcxMzGjF2O5mOrnx2crRFJ6zlh42lN/ENhWo7wsL26bOlWVW2qHDTnC
         O9tw==
X-Gm-Message-State: AOJu0Yw4N/lFX274pIofuZB7Z5x6XkZj7X+MwirHjjumx+EldX6kaZGq
	vmk/ixbaPTyRH+oaXX3Sz/AzLA2JYFnnEyDkGCRjP0c3K6asbNEdGu1PUw==
X-Gm-Gg: ASbGncvVrsXzWgCkNMS9KYCKj5jpzF9dsOwzyalFDtoIBL6Kl/WVkxEKUH7VDLxP3qH
	wQlsf9EJiwaHwI8houYeGYwiGCzgIpTWE1skKN+KgIBqPO/mRtnis5xg0W+40S5sFtQBD/6vUOd
	LXw/2uauybl6h2mgm2zAuopStZy5YNf5fY98YAMXyCII4DG+eP9b9rT1mw5mtOeij55vOLU046K
	48W0ieyxKmYncPZM0b8n6RX3Q9VEMbRi2CfuFkUNjWxl75r9KaihTTv+DrCNsC5DpqolK8s+Gl0
	ODLPvtWebI1y+ngpF7QZw7DxVCt5THwlyzUl2s2ub8rMnzAoaQFC5dpGsRKwq5o/
X-Google-Smtp-Source: AGHT+IFiEU5mHrn1N4pMKklwXSRsPZXUeuh49Zb+mLuRt7QK+oBAru7iDgf2pEZqQjc2njOIB0RBbw==
X-Received: by 2002:a5d:5849:0:b0:39a:c80b:8283 with SMTP id ffacd0b85a97d-39efba5b647mr5558810f8f.31.1745084767143;
        Sat, 19 Apr 2025 10:46:07 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d6dfe2esm69632785e9.34.2025.04.19.10.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Apr 2025 10:46:06 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/3] io_uring/rsrc: remove null check on import
Date: Sat, 19 Apr 2025 18:47:06 +0100
Message-ID: <3782c01e311dbd474bca45aefaf79a2f2822fafb.1745083025.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745083025.git.asml.silence@gmail.com>
References: <cover.1745083025.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

WARN_ON_ONCE() checking imu for NULL in io_import_fixed() is in the hot
path and too protective, it's time to get rid of it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 21613e6074d4..b2b9053b31c7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1058,8 +1058,6 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 	size_t offset;
 	int ret;
 
-	if (WARN_ON_ONCE(!imu))
-		return -EFAULT;
 	ret = validate_fixed_range(buf_addr, len, imu);
 	if (unlikely(ret))
 		return ret;
-- 
2.48.1


