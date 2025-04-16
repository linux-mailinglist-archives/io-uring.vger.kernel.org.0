Return-Path: <io-uring+bounces-7475-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A581A8B493
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 11:00:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE9E83BFFFC
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 09:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5062343AE;
	Wed, 16 Apr 2025 09:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mOplLyAI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8035233717
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 09:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744794015; cv=none; b=gT+Zwn7cEIcQzmk5+tCVLte6bQApO4X3q9f8JD2j2tEd9Ku4cQHct3YKlnahor2QPr5U4DlsHUKBMz8xqk9qqBfdc2LCb8rj7k9PEJcvSFuxqznkMy3yhBcBavvtTRcx8jmKBm8NyLMSiIGKBOugKltSGR4fG/XQsfVXlpWe7Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744794015; c=relaxed/simple;
	bh=RflQH5E5A4INnP/UebG7qS3clD3C6CQd0sYjyDzuwBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ci1EiHStV0xqqvzYSWRYMT7xgfh/KQnptws6OBqlmiRnJm/reo7ayNy4r4SAk02EacHtRNgNntkhFfwS3lFqkuj28MIQEQq+5E/iCG6BOalGVy0G/kN76khXQOBrtNPg3XsTJYfDYYaSrC+Plc4yGmX36RLqcWlkSo1CUn9Fz+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mOplLyAI; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5ed43460d6bso10176018a12.0
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 02:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744794011; x=1745398811; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cml3q2kt+CNzf0K9Xi08J8LURjZHmk2BdFfx+bQo13Y=;
        b=mOplLyAIWxtmE8j52fvUITmoGT+iwPx8URva8QAil2fQvQwexTCM2w1mg1gYE55jkg
         RzfbMQOhuqKNJCFql6J5tdpY7en0RnvnrwXE4CgK8jgyT3+h7/Wh/eM0qMk3z+Uyez1G
         Dog5TkK0Im5xfXNmo30fQhBpCuuivwe5s3xIksK06SLfbS5TgJI/t9ajDI6zR7Wwk8kh
         xjc0nFYFUNc3iXo0ESGGDfPkm6boZwc9HMMIYUvwIlMXWIhCmx7SS1YJoyMhGz5Hx8Eo
         fIR8XeLhonkbRuVoPJkV1M3Ndq2G4EtgFaiLtFD0WpHcB1+0UDMBu7q+fcLOSn+pLXYg
         BfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744794011; x=1745398811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cml3q2kt+CNzf0K9Xi08J8LURjZHmk2BdFfx+bQo13Y=;
        b=j1P4VVzK3nDXgsdT6sB/K9VGFm8leAxI/h5nrWVuA6KcDdrTpQTKDFtr03IPXjC8DA
         PFpuV3/ZXXjswensk8DJKDkDM1ifM1FwxZdBDkE/jH/EhrHkyAi6UJw2W1UwNlzIWRI5
         PDKRb7sd+vp0S+Oi7UrSsgyhho5Sr88ojVNrgfV14Vdd18hteyVGSNDY3iar/lxeyEZm
         6+aptvtXXVWy5UmLyCnLTMvyXtQbslaALzwBaQ3696zBM1GaYBqhYLPlm2j+muDO3hc7
         NLD2DzG5lAZQwMWZrmgZnlICth/mhA5q3trAdqpgL09Ad+pAPkikGd8DUT9C3ErRPgkO
         By7w==
X-Gm-Message-State: AOJu0YxrGY5j57+Scaw4s+Dqa2E8bdgxnzV3vSoxNhqvGiAra/IWieCa
	crNVb6VOfxTRRFyLCwgDLvdPNtCAmK8k9iDPyTTi4B3Q/Fl4F6QwlRkg3g==
X-Gm-Gg: ASbGncuDzqc3hirTpnLFe1ZBDQaJTXmzkhnqLLwMU75AfYmJx3H8ObeJ8c0e86p+uCj
	DFRaofHPyNN5GKP4bMeVe/nzcVvydOW53UYHLIpS7hQ38BH55Z372rvL0+EJJePz2IuT43V4nm4
	aJUEZSJL6/o9fi3wvxz9TNVY+kHLfqmq4sOu5GU4SO15a77a3PhlkcRDfN5i3nsA/ekJ1tI/DR+
	vWepp6JULLsXPWKlKEmOxLGdcfn1ZxoRC09OFhhPVnK0Kq8sy3G9kqtvNJ/hLxPPAQZno630ZJl
	/8HrrLwRTRve0lC83SEsjZ/F
X-Google-Smtp-Source: AGHT+IGaaQijiBH7/sgWABVgaimXZAVBnW47B1IFeW6M2wzxAwBFSCPnFHTL7i9Dd0QJNrZKfgLMFw==
X-Received: by 2002:a05:6402:2391:b0:5f3:9bd5:117f with SMTP id 4fb4d7f45d1cf-5f4b71e2ce4mr694503a12.3.1744794011186;
        Wed, 16 Apr 2025 02:00:11 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:d39e])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f45bc75b4fsm3378097a12.18.2025.04.16.02.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 02:00:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 1/5] Update io_uring.h for zcrx
Date: Wed, 16 Apr 2025 10:01:13 +0100
Message-ID: <b7905d6bfe567634e027b3656ffc52d2bb468fc7.1744793980.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744793980.git.asml.silence@gmail.com>
References: <cover.1744793980.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pull in an updated version if struct io_uring_zcrx_ifq_reg

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index cb9f82fa..572ff59f 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -977,7 +977,9 @@ struct io_uring_zcrx_ifq_reg {
 	__u64	region_ptr; /* struct io_uring_region_desc * */
 
 	struct io_uring_zcrx_offsets offsets;
-	__u64	__resv[4];
+	__u32	zcrx_id;
+	__u32	__resv2;
+	__u64	__resv[3];
 };
 
 #ifdef __cplusplus
-- 
2.48.1


