Return-Path: <io-uring+bounces-7924-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 424AAAB11E7
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 13:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AB101B605B5
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 11:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62BB628F925;
	Fri,  9 May 2025 11:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MZq657k6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A78E227EA1
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 11:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746789109; cv=none; b=iNOqUSXA6DP2XQ6BuTwc3v3DuVp++xbm81OBBXL1epjB7cjT4vLjzDqv4Ve3keYPybNQjs8JGmO+SGyf/ix1fksab/urcpmFIHM7KV9FXf5wtglzVPm7vHfwqV8NCoPS8Im3Z6igE+9A7zoBGd4mWMngOG/SdwTfZExV7jWceKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746789109; c=relaxed/simple;
	bh=fAccs1r4wd4ULNZ1sw8Jsx0NTBNp7ATbj++uRpBezPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttxGoc2JwvSQg0LDfuQSziS0KsQgVYls79wv3UouXBm7U0Ffjz3eh1hCTuMAHmP/pnnBGcm0PNs8H2NbUn1a3J3xYkOCHhxRoLHgz3sO89ZqUiQ3LgGcwJc1JiQf85IkNbJLW2MlWjA+IECZT/GWP5iE3TRZ4ST48pANOr6a8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MZq657k6; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ad1f6aa2f84so429833766b.0
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 04:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746789105; x=1747393905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ETeWRBQLsXP0DiigyP/+8qFoUBT2JsovPh3YXcYfB+g=;
        b=MZq657k6YUdHKRw36inySfF29aUMRrTuhEghgzZqz7IbxSKIQOSx+/8SrgYOEzrIzR
         l7z76XDoeJeH0XUVGM71TUsuAJpn/9jaoF7CfHygfyS5q2EXmYajRI3MTieiyKdQBOp5
         oyWOOxTNKvnmm4W2vSgP/GfMbJglThDmpbjwq75wVim7HLwmScTu1vpy2ek2DT2i7KQs
         EOXFlha3oiWIC46fC54wogcpIyJ2h1aKjT7JAkfS8C3O5s2mHMikAZWWlI0Hi2KjRy6D
         n2x80HR59pwPmgLFZKAPg5n7bX4gA+tzvfGoaK5/X5MbggII8pw1Am/RFImJ/KwrOUyq
         Pf1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746789105; x=1747393905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ETeWRBQLsXP0DiigyP/+8qFoUBT2JsovPh3YXcYfB+g=;
        b=YvSYSEmPe90+Y1jeJrjk/LmMerOJKlqHD5rFgeZNN02d6Eh8kbZdZQr3/UZP7dDEkm
         n2nanT01/oPCE0gsKea6706DSE4KU864wGSaiZIJ8hdm3jQnGAhfOWFUhnED7kvfqIX7
         8b1GKJYmymmLl4tASSRx2196mVpWJ1ONpBM0wZaZu9tZFL4XQm6bJcqv2Uip/WJvxz2g
         9TD6rexOsJxkO1r1QGL9JcWMaVi8BUQFXBJbwkBewFTY/gkauuzgtrWHFM/rMIvj5Teo
         bd9524zDB+42x4OojTcjxLDcQtUkL2bK147HshQAOEWp4jgFaWF4QggHVlWLEH8ycrJT
         8JCg==
X-Gm-Message-State: AOJu0YyeXRytw7QnwntR0OYCvya7x95Hos+BBTf2YkV9HFbl6BZv5tR7
	DN3+Smo6OusbHtlTu6xSWn8i2kMKwc2QTfyal8wkfmbKA7yUcjZ7kDO3+Q==
X-Gm-Gg: ASbGncsL6SnhbXpla2LYmPWPKV5OVDCHgW6j7nq8Cu7GL9NqORrmoIn1MCcDL5CeKxE
	fHViJ81HmgxKPEj8FQPYGFkCZ7gvthqyqwKi6npnbC2CG5PYeHJvB5GHoqSR9uFl/9dn86+10C+
	yGVKN/tI0+miwh0IlZ98igsecJ2bzZNvj7fLoO/wKHpIYuk8sSY+4ND1KT4tk7ar6V8H7g5DZty
	eDu3rVXwBkL1h/G/fR9bods9UW2f0biW2qzACQEEKurn70iwcXnQPmRUIemxyA88BIhzyf2GGh8
	9pxAQXq98v1yJwLXPXnnp4nm
X-Google-Smtp-Source: AGHT+IHh8b2seweNAMB0mkKkhho+ISXROSmVQaY64XUEI/23gVd+ieE2sOymylfFbPNzg7KtzvBvlg==
X-Received: by 2002:a17:906:c111:b0:ac7:2fbb:ba5 with SMTP id a640c23a62f3a-ad1fca0b654mr720585666b.7.1746789105232;
        Fri, 09 May 2025 04:11:45 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a65])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad219746dfasm132717066b.119.2025.05.09.04.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:11:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 1/8] io_uring: account drain memory to cgroup
Date: Fri,  9 May 2025 12:12:47 +0100
Message-ID: <f8dfdbd755c41fd9c75d12b858af07dfba5bbb68.1746788718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746788718.git.asml.silence@gmail.com>
References: <cover.1746788718.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Account drain allocations against memcg. It's not a big problem as each
such allocation is paired with a request, which is accounted, but it's
nicer to follow the limits more closely.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0d051476008c..23e283e65eeb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1672,7 +1672,7 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	spin_unlock(&ctx->completion_lock);
 
 	io_prep_async_link(req);
-	de = kmalloc(sizeof(*de), GFP_KERNEL);
+	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
 		ret = -ENOMEM;
 		io_req_defer_failed(req, ret);
-- 
2.49.0


