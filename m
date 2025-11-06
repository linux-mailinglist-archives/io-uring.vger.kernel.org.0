Return-Path: <io-uring+bounces-10411-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EC67BC3CB4B
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:06:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7231F4E7B10
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ECCC343D8C;
	Thu,  6 Nov 2025 17:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MHqxXQUd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98D934CFDC
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448526; cv=none; b=Znt1bUSiXFT5gs+CbRYIjTRyE0G0vnS71pZWsgivYuaogDQF3P00rvt4UGLvZVPfsZppL4RF5FvhFDk4CqwPgyFTpwoJS/xrpFX6TAMo0Wzs1Luv2fc2ZqIwNyxtV2OcBOFJCGklUIpPpWBO2yPODYKPDDFeMkbgmt6tN3nNRUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448526; c=relaxed/simple;
	bh=8kSiFvXVZO4acO2iRfRptdFmA25kqCn60PjGPbrH4qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulplhF/4g2x9nqQ36p6bMOAu8PzJCd5b6dGyPlzMJj+HBpUfh98dBTnq19C32U8sq4iZc+l7y8OJVlq9gGZmmi2AEpsCZySPJHv7vdgfJ6OTlQS+chqiFZmhDQnqs4HJU9NPE1u5NzClaK81JofnyNHIbHRBNiZ1/GyyVNtSfDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MHqxXQUd; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477563e28a3so9845345e9.1
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448523; x=1763053323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHH+8AwFoAIbABQkyQV2qJJkiLShSJYFxA9Z+5tq6J4=;
        b=MHqxXQUdep+bguzkRcfv9jc/q9p8WFyty49BmZEyXD2/D5bqdRZ+qjthlh+gKOG98k
         3JasJdmImi7W8QhnS9IBFp+AVQ4yU6g02bDfZ2ZK46rCPwaYBCwWSE3K9c2qtAIs+WQa
         OUsYuXhyMKa+T2vWBapsppWPaEM0WWJqzv0qSARMdn0EdJKEfKd8BbGlsN5+3bJqhLO5
         TqTgcLCruvkGkZIDCjx4waaJrw/igzs2ZhKjFZzKpp8oleWcghIDD1C7/jYsYgXeln4o
         pfqv+jUNAD9YyuSv//JzArrxBgTcWnOk6qHQsCJ0se6uKAj72vU2m25BgX62RRKX8uKG
         jC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448523; x=1763053323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kHH+8AwFoAIbABQkyQV2qJJkiLShSJYFxA9Z+5tq6J4=;
        b=wTeUYqA/6fJNE/JQURVOJPX6E4R2+djEoO6E7mgQqLDyieYV8lDJchFrf5N0aVXmeu
         dOBN06Aqmky9X9yzWoBXePcvFJvIwKH6Rc8qg9xI5kiKXukbtCR5oqt4MO+pTepDTCPz
         QhN5eGrGlXQ3WJeEwk57kTtZp0CyfnDvvx9WJ7X0RDaPLRtknNwdlVYcKRbChIHVfNX7
         lLFASXhx94msm3+TS9J1JYrb1H1tsRVF+Sq8N5jWLWL6wo/NhkLltZM6KlMW61ejJg4J
         jOflHVlg27DCPw85lg0ugUkoUp8fqLBmWc5b62w0iVhxKBaTv5Az/JKt09ouxD3NviAe
         4SQw==
X-Gm-Message-State: AOJu0Yw56NVWs/4PDugM91x9DeuskVoG8fEBkpw5z2CDrnlUNJN4Sz5I
	SJGP2D7PJQxy5AzMtn0h/ccx1DXyeG9cOt9J5M9Vn1pfR/xc0UEwyVZ7SjwCAg==
X-Gm-Gg: ASbGncsBMuz72I1xbDM3AHZa7mIg1DKMvBG6ipGTn+Eb1mPUeAOnzv4SNTQuJkW+S6P
	Hn8V67jQyuIul6evuyPxElF26fX8a6Lc02Nd0/jc9QucP72KvQdkKJAcYK2iTGcthpBUajsyqcB
	rKMwhxYZVqp7FrjEDRn/FaqXzSuZMgrOBg2ZkiPJx8mKXHbgSuKJ/U4+H3snG6lHrUKKfaLsWPE
	DBFEhrtA75Ia67BWkiD2crJ9blrnpiN2AjxteaGCkIrAcH0HUDsvng8hCIkz7Td9BxCjmwPQM1G
	Tw/sdkoLFKO5T2M76jLzCQrQkc20ZdFg2Co6cpMsOKzwVl1EVc/Q7vCF/KGqSGwkR41hWxgOJXr
	rOPNj5NPFJeJAYq+3PegzISlZGoeXMEsADfOkAcNppuNohAYOctiAmM0Y9WCCsy409TrCZeKKxC
	GohjU=
X-Google-Smtp-Source: AGHT+IHhfnhxgGXoB4iJnIbIgUvmhko+Z9LrAGgROcddKU95BTPDCYHbLvQwx9q53IJQlG/pc5IlWA==
X-Received: by 2002:a05:600c:4f8f:b0:45f:29eb:2148 with SMTP id 5b1f17b1804b1-4776ba7b960mr2266685e9.7.1762448522605;
        Thu, 06 Nov 2025 09:02:02 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 03/16] io_uring: use mem_is_zero to check ring params
Date: Thu,  6 Nov 2025 17:01:42 +0000
Message-ID: <956cbb09a6631883d6e4166593684ac2fd382c4d.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mem_is_zero() does the job without hand rolled loops, use that to verify
reserved fields of ring params.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index eae1ad3cd02e..dec37cf7c62c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3689,14 +3689,12 @@ static __cold int io_uring_create(struct io_uring_params *p,
 static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 {
 	struct io_uring_params p;
-	int i;
 
 	if (copy_from_user(&p, params, sizeof(p)))
 		return -EFAULT;
-	for (i = 0; i < ARRAY_SIZE(p.resv); i++) {
-		if (p.resv[i])
-			return -EINVAL;
-	}
+
+	if (!mem_is_zero(&p.resv, sizeof(p.resv)))
+		return -EINVAL;
 
 	if (p.flags & ~IORING_SETUP_FLAGS)
 		return -EINVAL;
-- 
2.49.0


