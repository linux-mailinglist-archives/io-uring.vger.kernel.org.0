Return-Path: <io-uring+bounces-8102-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56AD8AC2BE7
	for <lists+io-uring@lfdr.de>; Sat, 24 May 2025 00:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13FFA160D29
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 22:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF74C215F48;
	Fri, 23 May 2025 22:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lt/MKm77"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166AB214A74
	for <io-uring@vger.kernel.org>; Fri, 23 May 2025 22:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748039788; cv=none; b=bMdSYKtq0wxVcE3BE6EEiBQdTVAFwC+7I4YfnOuO0tJaPfPMgiw/HX5mq94woQI21g9A1+1AOp1f+21a72dT0Pza5YwcBkWHjQ22ocYLONKMbL8aPtlEUEapCrQ/GzGHbVI/Zb0Cele3ro+nRiwlVyUjRdKdb7QaHW5mQNK9aZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748039788; c=relaxed/simple;
	bh=4vWFm/92tF3sNv5XIfg4quQfi/l1PMHnOEaR3CzCzRs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kCKjLzHzbNOAtxtgobzp6gEP1vRxl7LDxP5apc83GANBz13MDiG/lla17yTctBfWzoShmk+xsJD7P48PBJfD3Km+e5mWpkSlpgadiUeXz8YGNaU3v13uqMieLMglnlV4u+A5rkod2wMTBx1z3VZyWKyd5hV+2UimpG7Vj0GgxVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lt/MKm77; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-60119cd50b6so584915a12.0
        for <io-uring@vger.kernel.org>; Fri, 23 May 2025 15:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748039785; x=1748644585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YUrqCbp721pqeadPf0Zg7vIQ58ztGOPrVM6jUOoJbOA=;
        b=lt/MKm77HT97AgAlfj9sWzEVb+GrG08jFEZO9GK2aYflvbA5cvn+LyAjrZwKo1UXaj
         mRQXc2GF9++GKzjAa2nj6YfcpC89QJrmUGemmzV7Ets0aS0exNbgew4vNiBK4YcwWLZP
         vyi+JD1jV5c3CnHCGe9AegXQVwmciS4erKIGhtkmv9LtbDH1LWwMIF5qJuJasi+w+VX6
         A7dDgQwlitdY+L8v6EtRM0LTdhHClZ26UhgFy0RZ/oEJE6O0wRCRGXXv/wnuNf9mNSNu
         QT5EMWfaj7isFNxNSSkI2jGUQ0nF82tWYQwKlQQIxNjc2dVHRhmJ5+fTSZ+x8ntoWPTC
         7SWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748039785; x=1748644585;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YUrqCbp721pqeadPf0Zg7vIQ58ztGOPrVM6jUOoJbOA=;
        b=dN4k+w7bffsuFVlQ3/x51FYXTi8n0KRdpQ/H0GL9XT/OCB9rhfPxI+U0ju6ENiLvKe
         5zpPOI9URSLa4LpIU/i39HGmLdqaEWskLPpb4cndjYsQ6QfmJgplj2iILSkqo8Tx8YsQ
         CuxUMBywYX1AISS+v76kyJ9fOBUwwBJ3nJteNLHjHgWqUw+G2iNjTU5ilM1vTYWWKAyT
         4+Ob0g9an1m5jOUPoEXfSGL1fZCQfPwdVZsgYMCEj+gUmALnxy1M1UFYP+T56xcX2+5J
         QxzpAAZVLPzE53sawL1/R15QcGjsrRU2P0d40JR+fMflSykCgaYOIY+NOX+TyorlwQ98
         86Qw==
X-Gm-Message-State: AOJu0YxOMSCIjPWeIgFBU6dYvlElt5tPQ0hXBs7p1rJ3cVTufvktxTAA
	UnB7zl1CZdZs5kGxFkr9Hi6r35k+bWNLcUoo0W4wrkZ72XWB8WWriuhgTM3rdQ==
X-Gm-Gg: ASbGncvKWGNxeLiL3ahWUvyJYqOQLHcQYavNStO2lQZ0r4yGT7GZja4Yfa5VZCM9Vk/
	0wmcUWGsYJ+B3FzD147nVUlsqjj3w6alotx/DXn1S2Kt27JPq2SrkBz2HTuEP2uvevjyxA6++lt
	dsSraCmWHDP5urmJudBgln41VEAzpfyHkkImC/G6jYPXYButnq51czBJb+464Bj+x2JSqnnl0p5
	p/kMr1dgW7urlieNjhAg4h7tzh6zBY46mVH7CaeGX92FRPS5jvzHTUsbRcCh7R1qvbfwYZ34j4O
	QLInnLC+NQK3VCEL+iKpCN1IivwKWvhleN84c57mJ7Yd9zrJDAbqac9vEGBITHUHaQ==
X-Google-Smtp-Source: AGHT+IEJdSwbqlnScHJW2aXMXMrjgaRjv79SB44TsE4kWsMAjhJv9z+hGsy2Dx5XN/3mXwc3b2JRtQ==
X-Received: by 2002:a17:906:dc8a:b0:ad5:7732:675b with SMTP id a640c23a62f3a-ad85b255080mr76618166b.40.1748039784865;
        Fri, 23 May 2025 15:36:24 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.123])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d4d27e8sm1307382966b.174.2025.05.23.15.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 15:36:24 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/1] MAINTAINERS: remove myself from io_uring
Date: Fri, 23 May 2025 23:37:39 +0100
Message-ID: <814ec73b73323a8e1c87643d193a73f467fb191f.1748034476.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Disassociate my name from the project over disagreements on development
practices.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fa1e04e87d1d..692bf3671214 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12459,7 +12459,6 @@ F:	include/linux/iosys-map.h
 
 IO_URING
 M:	Jens Axboe <axboe@kernel.dk>
-M:	Pavel Begunkov <asml.silence@gmail.com>
 L:	io-uring@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.dk/linux-block
-- 
2.49.0


