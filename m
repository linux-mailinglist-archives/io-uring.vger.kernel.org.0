Return-Path: <io-uring+bounces-7321-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0326CA76CFE
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 20:39:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7ACA167C48
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 18:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE46D1527B4;
	Mon, 31 Mar 2025 18:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DK4iyXoi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF3C757F3
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 18:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743446349; cv=none; b=nHCddUpq1Vm0vNO2Iunn5BFDB05w1P6qXKAWPKOYfmRDlXmqXZruVfutSNzaMH7IxM1fB7aRYCcTaVb0Ko33b1yUSu+vkhE8OCyVbLTfENlkitYbqvZWe/RtkKjMKK42uMVzi20NjNHAy95gXHxAc+9vHJZe7WKeh8MTnnHE+SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743446349; c=relaxed/simple;
	bh=l7RDT03FkYwSrnNa09BcIdbjYID2CplPLWvcpDXLXc4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uNsDopteaDanxaRbouKwIwpS1rd+y9BuQirfyOAaRuSUISykgREwDNtdey6A/L+HAqVJd7uNzyC4vZjAulEoHCbl/n6iPF2xZb1V6HyM2GRI0y0woeCfrPjjxXyOGXiJtIlY6MUQLcDUkOwpnk3tXK7jLw+/AauK71u/H/7I6vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DK4iyXoi; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac2a9a74d9cso912234066b.1
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 11:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743446346; x=1744051146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2rHhrN3memnriChxp8awOxyKeBqT2I3r1JlG8/jF77s=;
        b=DK4iyXoicmP5KcbdL0be6HozFsCvSk1Ka9dSuSKxr9n088fh2LQfIFM3DcQwWjAWjW
         FqRYIND+vQO558ibPIaYmmebMc19sWnwcQyWGhCTnfi6G/zp6ccZ2F+7Nshwt66WG47p
         rJ2KXPpeokPIhKMaW3WhW4Yz3KKoH4Ze4pcOSjhStSReIHER6Knl3nzdLXBJB7bYDE68
         WhVIf93LBkaiPWi22TR6vTQw5KMpoVXn//Bqdre3P3yz+6RNccFKPIN2OMwawy8zSjS4
         sMIqV9NewmG/QTTpwk+GbvvaRiSvH0qhOExIQq0klJFELVIrdWaqnfcr8SsyDmGVg5Qq
         eEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743446346; x=1744051146;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2rHhrN3memnriChxp8awOxyKeBqT2I3r1JlG8/jF77s=;
        b=w2VgKycyWEH6kr0wKRRZzc4Ld1+GQp1nMMxvriFPVQhbctieNPCvc4Wjlx0kiGqJ1g
         Gln0WetZgVsnjJRQyqo3cEUGSoVYaZ2sT2oh8wutQvKOxQGUodEDk0ipsUBiCttwYspR
         g8f4LZMtH8glyCA3qlSSoUuiUwWXlWT0RZRG6xLylCgHmo8nLx221FaBfn4jpOMNAxQF
         nP+71bExlwJ1IS5ZpgQ32qVnZEyACY8DMWuXmemdfkzwvCQyJYDn9OfzIUXpvZICcq8Z
         f5Cw8Au3fs1l+CK7BzuoR4lKeb+X9NXNap9Wx5M2yPJpSmtP7cYgIgF9WkiJy2H65a2z
         RRhg==
X-Gm-Message-State: AOJu0Yw/mK/CyrcET/MoC5liJePKq/Dryv2hjEFEIMO6aY8Or3HUlml0
	1cq2sh3R8AwVYHK4ubA37ITnGt93EL2CtH72FjfBGW8YtygEiRV5VlYb1w==
X-Gm-Gg: ASbGncua2Jt8CoDpNfWw2+zmS5xWhCvF4j6FAMxclW/eM6CxVhQj2yQg32meNS1ogHC
	/TOMVXWSHJxq1ji5Z2KdjP7esP6O5y8J8AYJuubeGpZoa33ASwY0xC6v7HRaTyVfEzR68QpLUlI
	NqVPGGCzhTYVtL7cHuy32EQay/wDOdEOflGMSfhSOAc1leTW/ndMRKNvkcnX3DeLiXorPAt/FMX
	OHPtYodlAVLJqb/jb0AHNwyFtNWNWv38zxZsgTmYlSEKYuaoC1whQsOQ1Ky9tgnPVyvkmiqcpFs
	SDOCRs4A1BlVVXx6E/lNVz1ZKtkO0NWMpZn/XyqXZW6o7vpXWiFEeH9tl/4=
X-Google-Smtp-Source: AGHT+IEFWW+PUrMcBF0X7d6pAO2IeGeOnfcNM57pp144oPwEWutwkdlYIaTyLS1+mqn7d3ObKsaW4w==
X-Received: by 2002:a17:906:4fd5:b0:abf:51b7:608a with SMTP id a640c23a62f3a-ac782af6e52mr19381266b.5.1743446345474;
        Mon, 31 Mar 2025 11:39:05 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.143])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edcaac38f4sm5295324a12.10.2025.03.31.11.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 11:39:04 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/rsrc: check size when importing reg buffer
Date: Mon, 31 Mar 2025 19:40:21 +0100
Message-ID: <f9c2c75ec4d356a0c61289073f68d98e8a9db190.1743446271.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're relying on callers to verify the IO size, do it inside of
io_import_fixed() instead. It's safer, easier to deal with, and more
consistent as now it's done close to the iter init site.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 607b09bd8374..6a449d108234 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1016,6 +1016,8 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 	/* not inside the mapped region */
 	if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
 		return -EFAULT;
+	if (unlikely(len > MAX_RW_COUNT))
+		return -EFAULT;
 	if (!(imu->dir & (1 << ddir)))
 		return -EFAULT;
 
-- 
2.48.1


