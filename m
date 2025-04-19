Return-Path: <io-uring+bounces-7568-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7BE7A944E4
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 19:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 916981897AB6
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 17:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE57186E26;
	Sat, 19 Apr 2025 17:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGnOH4ku"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E256F099
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745084768; cv=none; b=G0jZXgtXZsgOCFp1RqWd/AuloNQDoAG086hUsdTJ6HPmH4tdmCtQq/QJ28gym3Q9EH9oRszvaIOdqxPeDEbMV7IGHW1BXjkeildWc4kDQzIL/hb3pwfiKAd+W4Mub241Cin8l9DHWWGjKrGxbnLhi2h2/loFwRzXpVnsf0NM98s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745084768; c=relaxed/simple;
	bh=F1HFflMSmL7tJYDbSTar6k6pFA+j8psKp0cqQFX3K7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prx51AQSXFanyxZzkcGL2f0Z03BF880ONQkAQmotJSE6oCgYCfwrvtftSTmoaIhGFgsKsCFj4yVD3dxEwoJHc6Oseo5rOiNgPuv+jUM3NgR97C0cj+CZHbcz3OaYOY/sP0KxZs5JD+3WQ0hTbTzlPVm+8PtiQdmRSlerxWkTdBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGnOH4ku; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3912fdddf8fso2539706f8f.1
        for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 10:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745084765; x=1745689565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DT70DF6KQmD2cG3pCjP1KCm/JJF0iWQMN932x1Ui1/A=;
        b=jGnOH4kujyjpCx3m6KolbKbE0gimV49KOKrEhzql09mlkuXvVnq30YD3BjDKds8Ezw
         dcEvghmRDZ7GgeYiG5BdK60vLMlQIAIfsveC5uGF2ME7Ll6nYjRQzBUY0onNFXcgM5hu
         eZKrZqaqswnHQXVljLT639LFdu4x8GiCzqBEX6YJ04vNhxZ3WB+1B3ZG9vfdy9xwA7LW
         aHEAbkJVt4EoujRLQMd2aZ2DgyQ26sMWurFcB1PybgRPPguLYF+V8pwRmfA1WsNOvBX3
         8OEqz/4RiW/saP8w70GevbYh+TzzqNDHfbplbdqE+9Fnxu4tvH4YO+NvzwuRa3UPJR5p
         0KEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745084765; x=1745689565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DT70DF6KQmD2cG3pCjP1KCm/JJF0iWQMN932x1Ui1/A=;
        b=EZAbit6e3zEN+g4TVb8+hhiHn3NlNjurOvQYDo4H9h2+v30mCBE6fMsHK+BQ1dOlY8
         aex1fKZceI2PE+5cwvbyNmIwpR7ZzRk+/o6fbEux/tkrzCfKvfMwrZ3X9PzBH4QUwe0Z
         jGKWpxFsbAKUSKhCSzIm1+4RvoAo6MmLk90fFgL9s9anbjCEt6YwUcqsfOeZnOp4J3eq
         ljU8fE5rA9gjuP4ggKX2fTmtA2d6h7tCphdisBcjXJTeIff0NRZj/Svym9XU9V4pzxub
         F4z9CHnVWpPvoTvqgW1zkBxPygYGuRNKtT05eYoAyT9jRmzRf9dY7L/efCS4Jq5uXuoA
         s+Iw==
X-Gm-Message-State: AOJu0YzWxg9b7Y0uAVQlzzfX4r2yttRjLP5NUFVSVptLTVbCn1qgtiwj
	slBTKTfMQTkpJpyNqlyiPT+ls8zCxdKlEGaD+rQDa7RRPc51OsXasvMbOw==
X-Gm-Gg: ASbGncsQ/Yz8qjIiSwU4/eC9fLvVp4PW3mlq1rtiQjELMlhV69TyqME2ycnCr3DfTzR
	JOh7RJpDT2gkpssXJWDOD9Gy4J3hAoc6HE67iHe0XNmZPe/W4d7n3fy/502Xp0jO+gy2wtOasSQ
	07HxcDmAJEF0aS12ZhZk3xbIA7iZcyEMM28nkABSAUpfq4mrbdlprKEfrTiKhwB/Z6LazxCpzFG
	oBwJXkvMQmSmROFTHghp962jT4gY2f1f0EBGcdQ6zggYJ0E2NRAq199jB8GJELJXkAwTKIfUAvI
	oWUwIBPbVzBD0H0e9O51r4xiT4p3KmQmLPQfdJ5QF6C2XKrDt3KxZw==
X-Google-Smtp-Source: AGHT+IE84WNK+aJIuK2nXZnQs5or5slEJiNtI7G1PP277y10aKodBcqhLjj5002wxokGL9w0ampHDg==
X-Received: by 2002:a5d:64c2:0:b0:38d:e0a9:7e5e with SMTP id ffacd0b85a97d-39ef89b5dabmr5715001f8f.6.1745084764443;
        Sat, 19 Apr 2025 10:46:04 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d6dfe2esm69632785e9.34.2025.04.19.10.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Apr 2025 10:46:03 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/3] io_uring/rsrc: use unpin_user_folio
Date: Sat, 19 Apr 2025 18:47:04 +0100
Message-ID: <e0b2be8f9ea68f6b351ec3bb046f04f437f68491.1745083025.git.asml.silence@gmail.com>
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

We want to have a full folio to be left pinned but with only one
reference, for that we "unpin" all but the first page with
unpin_user_pages(), which can be confusing. There is a new helper to
achieve that called unpin_user_folio(), so use that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f80a77c4973f..40061a31cc1f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -699,10 +699,9 @@ static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
 	 * The pages are bound to the folio, it doesn't
 	 * actually unpin them but drops all but one reference,
 	 * which is usually put down by io_buffer_unmap().
-	 * Note, needs a better helper.
 	 */
 	if (data->nr_pages_head > 1)
-		unpin_user_pages(&page_array[1], data->nr_pages_head - 1);
+		unpin_user_folio(page_folio(new_array[0]), data->nr_pages_head - 1);
 
 	j = data->nr_pages_head;
 	nr_pages_left -= data->nr_pages_head;
@@ -713,7 +712,7 @@ static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
 		nr_unpin = min_t(unsigned int, nr_pages_left - 1,
 					data->nr_pages_mid - 1);
 		if (nr_unpin)
-			unpin_user_pages(&page_array[j+1], nr_unpin);
+			unpin_user_folio(page_folio(new_array[i]), nr_unpin);
 		j += data->nr_pages_mid;
 		nr_pages_left -= data->nr_pages_mid;
 	}
-- 
2.48.1


