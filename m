Return-Path: <io-uring+bounces-7823-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30767AA77CB
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 18:54:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 254251C2053D
	for <lists+io-uring@lfdr.de>; Fri,  2 May 2025 16:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 286952690F2;
	Fri,  2 May 2025 16:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCd2h52Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE0E267AEA
	for <io-uring@vger.kernel.org>; Fri,  2 May 2025 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746204790; cv=none; b=WfouwmbuZq4A2zg9PuN9l2n2IhFSyW04G9Irk49+UEQ8BgBZepvPc/pGrmulKx/bP88VDQ4TgVSU74kNvzWScIYE7OfzjByE9sAc+XXEipEmbzqI72RIJoBpX2XFWyOrqA8wmkYxecgd+aLayMakrdXzFPx42GoD1m3X8YiPBTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746204790; c=relaxed/simple;
	bh=ODHogYgVvrw8rSRkvQNEylVsp7RpVglbU4vEXJCrb0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1lzNQjkSGqhBAeJCfKswQc7eo7iIjk85iCrHNGVCKcJuGmhcPYAJ5pWMxekgoZEQg+r0CWqzG7sam41hk6ZxRwPd20ctyORaRUZ2kgBoa1CS2MrvaRBPYNU2v767JCWyd41RTVt/yGHHDvWYMj5V+faDN/jOvZycmAlLIS6IOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dCd2h52Y; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-39129fc51f8so1424520f8f.0
        for <io-uring@vger.kernel.org>; Fri, 02 May 2025 09:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746204786; x=1746809586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wl/cUXdUUYZ2aIEQWAfOu8wHk2T488QYCfdLI8jqnrY=;
        b=dCd2h52YPNCcpaYwNQOpwEKzHBWXc9looWYbjdOLMToAiYiqVObgs93gBpl5m/v3hY
         Nd7vMi6lfkexRR2w5Zua7gOJU8feZZ/b6NTXqIuaFcVNKjtp8s75DIq1ukmukYCw+Beg
         ScT1/StApufnWFDT85YfwKkAluoI7ugIESOWH1mq4BjiEGe1HUTi9bY9FM1CyiiGnwOP
         1F4YZZrl/XImqozmupXsbnLMMz6zHv1MdL/G5LmqTTSeGtnxcTB0V0LbdNb0++hohFYA
         fNfUHvJGjn//nuEZ0/pvKqjkluBBPIR5SOk3cn9+NMFa2F9IqjSBBC9f4xdW6gZpW57l
         0/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746204786; x=1746809586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wl/cUXdUUYZ2aIEQWAfOu8wHk2T488QYCfdLI8jqnrY=;
        b=WVrE34Dsj0nxNa9QRaVOm+N0/73op9Dm0P89T4RbswVKY8fUcSXHTHB22p5QHCn8dh
         LoLEnCpmTbBl0UKt8fWn6MQMG1g8kJtQEFENrwsiNsyPASwBZKf9Q/e8hMkwco43xKNO
         Hk9Ij/o5V82pACcnO3O9PLvFl52tIHkBt32B+opg5XdHKTJmscMaw4IDUhmcU+NDAIzt
         uwclPaO62fxei8VcKXYVstNmzz4a4NfXwPKBUH0tdTa/cDsO+CLqVJ8gOz5yBzL0iPLz
         MOuTVWIKbrZLN4dhLbAmn+iMkgzfJy6pef4wL8Sq7Dc+URJhIxsIqik5ExFHkbz2EWU2
         9QEw==
X-Gm-Message-State: AOJu0Yx+J4QgbOCYh7QXtNQP3+i1ZoXPrxtKj46l/EZvofMgQ7esn5Ex
	f6I4Qf768ndsGEnPtt4ddBligSrCCG2doaoMwrGe/C/8kMLkNp4JORQDYQ==
X-Gm-Gg: ASbGncscA4q4LWv1Zd8mBb3LhWiSrNHdglrQzuTOe6Gk01XawQTyLL+c+khx4EQcXWF
	8smhv4b/LRCOOkUEbko1DiQF4CR0MU6GDaTAuR662KQUNVSnwOTYjCYEq0xyhX4M6VLvQ+TUTfK
	SrIa3acde0wgM5DhOGgoUhVTsoG0h5ee2mHpWy3haYhM0KxAuyD7yVO6tnKrwwTnZkDIPsw5HUb
	+9CZgGUy45MTH+2lHfVuBzExnasLMmtXwk3g5DUXNc8IrblTBxBbeICg7BlOvyfRqJbQ8CP/Dya
	n4yuByoCqGTgDEqBb63ZmdjV1ggJXGMRQaV1BLl1uRZJpMrIRb4ssP8=
X-Google-Smtp-Source: AGHT+IHr5+348Y56a/80OdFkrBIWxBbdUqHKJ+leIe3CwviR+q0szalEM+M1oc7RQpkUozgg4ISPmQ==
X-Received: by 2002:a05:6000:4008:b0:39c:30fc:20 with SMTP id ffacd0b85a97d-3a099aee04dmr2267869f8f.37.1746204786035;
        Fri, 02 May 2025 09:53:06 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099b0f125sm2586013f8f.72.2025.05.02.09.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 09:53:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 5/5] examples/zcrx: be more verbose on verification failure
Date: Fri,  2 May 2025 17:54:02 +0100
Message-ID: <f6e452e4d555d96ed9c02f9f110ab8c8edcd00a3.1746204705.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746204705.git.asml.silence@gmail.com>
References: <cover.1746204705.git.asml.silence@gmail.com>
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


