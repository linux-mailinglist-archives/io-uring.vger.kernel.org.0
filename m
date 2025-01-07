Return-Path: <io-uring+bounces-5726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4594DA041EE
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 15:15:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CB07167DFB
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 14:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B84911F4262;
	Tue,  7 Jan 2025 14:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsxJ7uib"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408001F2C45
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 14:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736259071; cv=none; b=XyieqgdPlvr6/kK+xwjnInSHi1TyN2fxiqQvP90qv++V5bjhUSaA1DMxkrDXLMqPI1slUdNV/5YiQSyrnmXiNeyoxvxqCVtYJWVXJ2gsEmamuyR9WDFPzsa2pxfWCtk4JH67FySP/HdWuPsbo7YRn8n2l+5aBvtKHrWy7HIPNYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736259071; c=relaxed/simple;
	bh=/OEpI+hErthwQr6/ZeGti7oaesYJnfHzyWz/+GNh+q4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I2v7O7p7FRGH/tH93s9ylz922xklx4bBv9M9Hju33wU9RKKOUSkq/iDa37Q89xU4Esnc+OczZ35OXIBTbW82ipopUX/2CKevJVcI0LgglCSoVdSTw8SpW8mAqpd+X9CgIJuZpkTsD2aD0wepqbpGvv84N+y9ywsbWZM6f+fSoqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dsxJ7uib; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa67f31a858so2806650566b.2
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2025 06:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736259063; x=1736863863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UGh/tgXi2Vy9Zhpo6lxTL6CZsFAYLpfoWGWSZG6TQUo=;
        b=dsxJ7uibsdmwYkhC0xaX81SVAZL5wDWK4SE5lvulrCCxmSAqwpoho+OFC+vn3UpO/0
         l7ADws6bZFHsvMyqlj8s2PRRSseLXCwbE8z9+W0niav2fFPv+0NBP/98y4zj6+rL4kLg
         wWgZrxha5TcbRJG5/ZlCpLtEB6vjsCufLcWetRChMWznCL9jjeX1tbdC3TJz9cRz5XVM
         VE1OIy77omAfiuSiQfimjsDW8pHkcR81yaDDlLCB5b4WLXwRwVoQJB2O2G2dGLMcyO4V
         arMZ8BWYwDBBpWsmAx7Lbc/KJUIn/6bnfi4ShAGCLzLzYsWrf4eeXl9UsqMGZiAZvQPl
         7N1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736259063; x=1736863863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UGh/tgXi2Vy9Zhpo6lxTL6CZsFAYLpfoWGWSZG6TQUo=;
        b=ZyC/mBcqy4sLDUDPNIWBDiJAOSNfua8x1TOt32iq88kli+nimqxc8mjVXL+UvnLh7l
         gAWuh7jrgTVr/LDKmmt3DJfwv+bbNGhAcV53XE8oWpRQNtXkGZtT+ak7AmrL2rekvDdI
         8PODBteQApRSOpaetrxC+vXZLH9YrW/tdHaQrR8M2O5asBAP4NOL1/1axTUqPR7GV0gF
         bxZxtnylcFv8AuvVho4SJJ4EF7A92Lwq3NGBfTnmu8tHbllO/5IPI7aeEJoCMsnZK4zr
         525w/aKGgEOeZSWVOKsYJ/y/cMzZLVlxX/QUvlkFcT4NQ5be0C39VzoUuiaO3tN6fupk
         D5qA==
X-Gm-Message-State: AOJu0YwucDiRVuOa36AdulU11VR+RgnceZ8jwbQnyW0sfynaXdxbVbW3
	QyWxaz+/tfbiDKHtXeQ6CIojHhSkllZjWY7cyrCXO11g8leXvT8/DCnoXQ==
X-Gm-Gg: ASbGncv5890/Kotl2Xwf/dubAOXiJAYnSR/Me6XKRO8KvVLohTRfM6OlF/tWOzpz9b1
	2DdcgIOKXbBrjaerzP4HYRr/QJbmn7Ouuj4+gZi5u6tjsex9W29JuQxZsmO1bHT4cCKpqWXL4FQ
	FRkBGa2rPxkGLt9aC0/TNeDkfbDYZMa4Xvvwx8/FinWpvFs82qYUmYMg4qK3V7laSQw9CeL7Ekg
	y85tV1iWjI8IfAE7idwWYsFqzHJpoOxxe2f7Sy0
X-Google-Smtp-Source: AGHT+IEoXNEf0YMpc1CzUA2RJnjGcwlXUGNdqzzAGBKI3BVknq4EeuV9piv3pqiZEVn9tF/2zYHilA==
X-Received: by 2002:a17:907:3f87:b0:aa6:a732:212b with SMTP id a640c23a62f3a-aac3365de80mr5683534866b.58.1736259062767;
        Tue, 07 Jan 2025 06:11:02 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7fae])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e82f58asm2390451166b.39.2025.01.07.06.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 06:11:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/rw: reissue only from the same task
Date: Tue,  7 Jan 2025 14:11:56 +0000
Message-ID: <e769b0d12b3c70861c2144b3ea58d3f08d542bbc.1736259071.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_rw_should_reissue() tries to propagate EAGAIN back to io_uring when
happens off the submission path, which is when it's staying within the
same task, and so thread group checks don't make much sense.

Cc: stable@vger.kernel.org
Fixes: ef04688871f33 ("io_uring: don't block level reissue off completion path")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index ca1b19d3d142..4d5aeff79130 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -485,7 +485,7 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	 * Play it safe and assume not safe to re-import and reissue if we're
 	 * not in the original thread group (or in task context).
 	 */
-	if (!same_thread_group(req->tctx->task, current) || !in_task())
+	if (req->tctx->task != current || !in_task())
 		return false;
 	return true;
 }
-- 
2.47.1


