Return-Path: <io-uring+bounces-6665-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79046A41FA0
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:52:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 579343B6614
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 12:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ECB223BD15;
	Mon, 24 Feb 2025 12:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kPHQ7DQp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A536423BCE5
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 12:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740400900; cv=none; b=TOxXKVgljoza1CZsKAicn6AGhQi7qcCcfMzGpnCpSQjTEsWy05NoU3idTHo9RFHKnPTR38vy5e2cfVyF2GzuK5AT40XMN44Mc7C4HOGnSbgWU1mxbApaZIV6bnvnR/d0wl3pUEM+Qk/1z9MrO5ovDCoyWFtvQk5YcSBmlyFuqfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740400900; c=relaxed/simple;
	bh=dfo7ORxeQnNkiO0yCRsn4mUmZSjPu3IlvKZs4DGD37M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbHdcj64fIlZGJlLPjUSyD2Uc1iwBTxrtbQEySveYl2xsWPxKPqqCxQEhMHHkEjZlCbyxMcSFZRg8lzIRlCEMJ/y1mjJO8ujo3aar/4LhPwRwbHteO2BFEoVwdldXbDJKXUoXY4HDv/o7OB/a1gLGPss3dVCm4wqZDz/ThJp7wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kPHQ7DQp; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5dca468c5e4so7795665a12.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740400896; x=1741005696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TeA492I5jGdk9YG+o5IQXdThhoW9fDkBeoIep9VFMIs=;
        b=kPHQ7DQpYxaq/6nwZZ9chVtUXf6U2NG/fpHu3L3Q5kfIgFhJ5kaw+ajqsaxKQNNdZc
         AjwiubhpyPYzg5cHtXoHk0446QWxbaIHz/ty9f8YHzarGxt8MSTIh9LhJlovLIX8zCZa
         N3UtCrhbT5jJeg2aIkNC5KardJHm9SMoUg6oyxTv5Y3R5d9UqnpA2h9pHjcSWLRKmIqx
         hZI22puk+9rrcDnagxfEgsevZTMyQqG87Zlu/1nF82J9MKw7peuR8EQSLIyYdEhbGav8
         ZVhg+50Ns+o4k6uL9c5vEfaIjRGqqAMRt+2rRZs/dzwKRMuQOfHOZoN6H0WFf3xXEf2J
         gNSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740400896; x=1741005696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TeA492I5jGdk9YG+o5IQXdThhoW9fDkBeoIep9VFMIs=;
        b=WSowfEew4jdZ4Fdna2Lpr2dv3YtN8Lmv5MLkE1nCyQwK/sDPsmGJZKnGhRltfeDBmh
         0RSnM0hbslvWM23xa8GLpmBoWF3cLjQ9GlwPzwSEhW6pVOmagTSzsRoirU+FZj8/IXrr
         5rpJKnKEEiuHC7J93xe3tMeWeMbolJAAm/4ONvvvSe1llVQjx83odt57B7ByTclS9nRq
         aBG/28jDyc/MYer+PqB9bu6Z0EeOj2hOlFhJXAU2UwdcmZIS/Y5uvvARZTzHhnDooFwo
         AIk+mC205Epyo/3pebrGBV+uFCzjYS0eiI9guZ/sm9jHzXCXKy0ZaPaq/2RlLVCZRhUi
         +Q+g==
X-Gm-Message-State: AOJu0Yy/g33TE+3UeVj2P+kENn5l0Uh/2UXxlgU2hTiPtojICcQvRVCx
	+lpNZZ9lZry3J1QybKG2pC+4IeKOTBPjC4TDweF4owAJbXfpCwO92CFR5A==
X-Gm-Gg: ASbGncsXMK1VgUzmT/8xfXTIRfBUlB3rOq8ifEXS/KWBIrAURdH0oShzO7Er8gVQy02
	ns28UECG0w8oBz/fwZexZKaOFpUAlSYwcP9lQfSblIYTdWx6jcK6xCrb+tqeV0nmddUonxMRt2w
	4L4FFFwo1kXWtOfSBExADBPV0zTDiZl83kAMLA4JXwaI/cN0AldFmvNTotSN4fTRYrccpG4Fa2O
	1KZfVxexBC8v7V4eE5CsKucAbphPymn7VbQHLkHHpRrPAsxf31zVWuEckisGQ+3I4RdsrUMHp4k
	nDLSMYU94A==
X-Google-Smtp-Source: AGHT+IEDxQeib5P8YEUXq6vIx8BmZ0YmygiL2mr8rxalYItyPfrp1rWLY8ZC2gUSFNu7IIUGTS0TRg==
X-Received: by 2002:a05:6402:43c8:b0:5e0:8b68:ffae with SMTP id 4fb4d7f45d1cf-5e0b70f9ac6mr12144417a12.17.1740400896162;
        Mon, 24 Feb 2025 04:41:36 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece1b4f65sm18165110a12.1.2025.02.24.04.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 04:41:35 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Anuj gupta <anuj1072538@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2 5/6] io_uring/waitid: use io_is_compat()
Date: Mon, 24 Feb 2025 12:42:23 +0000
Message-ID: <28c5b5f1f1bf7f4d18869dafe6e4147ce1bbf0f5.1740400452.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740400452.git.asml.silence@gmail.com>
References: <cover.1740400452.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use io_is_compat() for consistency.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/waitid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 347b8f53efa7..4034b7e3026f 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -78,7 +78,7 @@ static bool io_waitid_copy_si(struct io_kiocb *req, int signo)
 		return true;
 
 #ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
+	if (io_is_compat(req->ctx))
 		return io_waitid_compat_copy_si(iw, signo);
 #endif
 
-- 
2.48.1


