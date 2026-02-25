Return-Path: <io-uring+bounces-12413-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AP+tJarQnmnwXQQAu9opvQ
	(envelope-from <io-uring+bounces-12413-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 11:36:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE2B195D74
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 11:36:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B9F323023D91
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 10:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7359392C4D;
	Wed, 25 Feb 2026 10:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eGVg7/V3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3975B392C42
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 10:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772015769; cv=none; b=VKr3uOKcS/n5kY7jM61hk4ZfwZmMww1s1UuF+FLXZ/NW+aKMigXezc+cPOyLq86OEEDTgT5SDcO6m7DC/SeoJEkYUvnlVSVlm0nQ7qW8tfyvhsRy/IK7n7oPnD+We+69k+EgjBXS8+X96B6QH7dHd0xGAgAsmZ9OcrJmkLHV68E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772015769; c=relaxed/simple;
	bh=7dRXnwEGFVBahHLo76zDqxOgTm4xqFVpHwJx9aQHFec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZX/P89U1r+9amLUJ2+rZ5Cge8lNBWQzPLtvLgASQt6A/aK5AUHO9zheTCpx8oiOElm4h9i0klvMF1GMUalx+MpIWRYTuFsFuumKrYGfeK807hIaBdIbtm5u4pojV7qyOIWinN8niUh29vci/gtELRX9cffUDh7jQiN+AtU8VRJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eGVg7/V3; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65b9608a9adso11027677a12.3
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 02:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772015766; x=1772620566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVzKpJIWgdMORkPYbORzW1qgQsmkmrWMR+G9vGAk6g4=;
        b=eGVg7/V3hQz2diwRm8v9oPCasdhbWd1KkTOgPyYZZLWx1BnMLuJ1UJmGTN0sEZYhVU
         wvbx3dugQbDaTPZ3xJxeIOn0JTv9VNIrbmw2bnTUvoFMlck4nRDdGxrtzH5YN0sZcRPr
         V7HDhKGb3/n8cgL9HdXZMK025nTOJPEzpDsme4ZtOq8GNLoN5yAY3b5LELE2cInOoB+A
         wtJ3/if0WXtd80RprYIUTzU+Rmlx5WE5XbrU8pmf8awEper8ey9mgzA3kBEyEA2uRAMG
         nF7cvJbBGwjE8emuibBdcmLyCyvSj50ymjjJTyDCcAPSub4fr+W+/gfxiLvOrW2DgL4F
         Hipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772015766; x=1772620566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wVzKpJIWgdMORkPYbORzW1qgQsmkmrWMR+G9vGAk6g4=;
        b=k3DvHOtYeAdH/0ZLtBO+iONelRwl4nm37ZBIf4cNNF6CIoyXiB0daibb0R5TdMyQTI
         OWxQgVLuLUwJkYFG328JvCUhg50h4s0oo9ZS3AKNFml5bL14QDKVlp30QAAnsHS6uZ8v
         c0+F6CnzhRiQfiRfFIBpXoqZlnWTquJAA3g00+E6W2Sq22Uk4Umt4GrUjuCfkfuVrZYF
         4iqaW7Iq1iMl/xt70T6iuwVgJRthZGNSUKv5efL/02hQl1nJJQdZh69CE3/IX3pNMiPw
         6I8Ro7AKN8fIBgtSQ8kx3DdbqjB0iee8hOgHo+3NiM7QNIksfqM6gyF6JVUSAyQ4AOng
         2jlw==
X-Gm-Message-State: AOJu0YwUUU56qyL7zRQRIYw6BDubqqqdqsSwcjhWO8Wcwf60hHnvSmXy
	lOJtPSECRgq7y2MtZx6z0fd/Erqo5sFcJsVfuzJityaC1r9s+ZKAO0ejERm4RA==
X-Gm-Gg: ATEYQzzfLCC/NJp8GWa/3B5n4odD1HqXR1GtzdKKDdyHCkXYqiYvVctOdLRUJYKrg1m
	gDtXuZ2hmfcrSIHCN2DJeMtdOHqfJKKCWX26C63XaLb7YifpYajaGgHaJxxpjNgyuItOTUrPooP
	yA+mvcHYYYIxOFJ5U3ORzLpaIDXKP2u+VtkfMcOI8zkMKmquMwny6gF7AW+h/SyXj/rVBazUX92
	2C84JV6kf9fVp+/fgjwockvj53QBt4lf6g3DFFJKFfMYfIDLjMUfuIZelZtKq2gfPd/4rc/5SB8
	IcQs9wfjd0bvrG02ELqE57RpXV1vjtbBltTJAwWqgAV5GFxlHNE0FfKr/aRaiDb+NnCdYLTZ3nn
	K11uJiiEZ2NEBE7qa/W+Fa2ZgYYu6GgVEAfWCSN5G9E4sfqsCmDqvIlOMvG3Q+lRMGjk+BuyxUJ
	da2Mm+b4yqzrakJPvGZs0vInVttZzNkhXgmOccz7e9IC2K4fEeSSFo5wAYvWVvGGQRrPHuMy+9a
	wNidaX4PyGo9FGUEEr+h3V3/Z+wwLMCK5ZMbM/lGTqMUSl9b3Fp7Oybsb0B
X-Received: by 2002:a17:907:3f8e:b0:b87:117f:b6f9 with SMTP id a640c23a62f3a-b93417cd69dmr109152166b.8.1772015765880;
        Wed, 25 Feb 2026 02:36:05 -0800 (PST)
Received: from 127.0.0.1localhost (82-132-214-161.dab.02.net. [82.132.214.161])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c82495sm500530666b.20.2026.02.25.02.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 02:36:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH v2 1/2] io_uring/timeout: READ_ONCE sqe->addr
Date: Wed, 25 Feb 2026 10:35:57 +0000
Message-ID: <d226c51afd0e0404ac9e09e7f2939febe97fdd94.1772015321.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772015321.git.asml.silence@gmail.com>
References: <cover.1772015321.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,kernel.org];
	TAGGED_FROM(0.00)[bounces-12413-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4FE2B195D74
X-Rspamd-Action: no action

We should use READ_ONCE when reading from a SQE, make sure timeout gets
a stable timespec address.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 84dda24f3eb2..cb61d4862fc6 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -462,7 +462,7 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			tr->ltimeout = true;
 		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
 			return -EINVAL;
-		if (get_timespec64(&tr->ts, u64_to_user_ptr(sqe->addr2)))
+		if (get_timespec64(&tr->ts, u64_to_user_ptr(READ_ONCE(sqe->addr2))))
 			return -EFAULT;
 		if (tr->ts.tv_sec < 0 || tr->ts.tv_nsec < 0)
 			return -EINVAL;
@@ -557,7 +557,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	data->req = req;
 	data->flags = flags;
 
-	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
+	if (get_timespec64(&data->ts, u64_to_user_ptr(READ_ONCE(sqe->addr))))
 		return -EFAULT;
 
 	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
-- 
2.53.0


