Return-Path: <io-uring+bounces-7842-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D74AAAC131
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 206241C27BBF
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 10:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5038B272E7E;
	Tue,  6 May 2025 10:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZgNfHffL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9547726FD81
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 10:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746526843; cv=none; b=b08oBUNNKXHXMcOoC9Y6S0EPTWOSQPLP5Vnybup7Z47jo6U34SYASbj9LHCNc62y9nbWdZtZVZqPR3EkUZnSYcVaqzykbFHtsiOpOeIlMngcHMSwkn/l4xAs802DXKH0G1mpfo53bQ55IZjzbCND75g3gxSynzyqQ8B96YVlesg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746526843; c=relaxed/simple;
	bh=hfVjSiYypSwhaxXTn0kMe0N3QAhbXCgTuCLA0VRq4Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUuk73XMRLPN0wpTQcUBWwYr+Ik+mL0gsagu75M/TjunhmpYXux2OEJv2dnnOmj8DquviYu6slHSWX5Cs9uHTnONWJHkqrQbkoF5q2HPE3CEkEOmUW8aOEOB5cj8g6ekMu/vLTn3UGvv8fYVJOVJXtGRLXzMkfM7lHwOkfdjD4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZgNfHffL; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-acae7e7587dso883377666b.2
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 03:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746526839; x=1747131639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jhXqUA56y1piABD9BUSgrZ9fK1unko5oumkItqOBRm8=;
        b=ZgNfHffL9cAsqURI+bV22GUm/mGfK5pVCeS4TjN6Soqg/mf/fQHi3uzf29C4/O2VbQ
         OedxLZE0+nuf04sV1vxxcivwQ4OEC5dXaQR7MZaZAQj6j4bocPWoXjRU98hMnTnx+Lsz
         rOWhTuDoYN6iKzZDPzYQMX7etqETMCytV0H5OXQJ9K9ritdpyRBkke7SjXIH4msRHdqL
         l0MQAzl0UCpQnUuGdOsAi6+PIHk6aOSrJzc7A3X37ROO89XrpbBa39qkyER7CZW+8ycp
         dZJYLInI3uLShnVi6GOUgZSDaovRBIBo2DbsdsnIlSK+O/87I4UH/1lriO7nukhmkaaE
         kYkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746526839; x=1747131639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jhXqUA56y1piABD9BUSgrZ9fK1unko5oumkItqOBRm8=;
        b=RUlGoAuM/fJLZ7hNwlN0WipNQ6h3QZZyIYAUStMAAA9gfMnpIyzx3elSMq2JnfO44v
         bRDlbKzrdNYWvdYxjHjKFHIfFOewfOFsU77snsqzzmZoi1iQrKYh8BKqUXW7tDAbQ0Q+
         TgdYQR+mAgccFm2Kf1myOHgSaTYJnXPZeXidp1WWSIYG9I3cRR4bY8ksaDjZb3GQYWdy
         GD5rDJAawAsI7bCCPXoavjgL9T57379b+Zje3r3jgWatgZdvS09JEAHVlY98lO8oDCkm
         HQs6YrZph5anZzcpv1cZ3QB9dTPJSOekKu9V3U5GENXj7/n2fpMetTnSYJwFD4QQVNsK
         IZPA==
X-Gm-Message-State: AOJu0YyIWTEBCNM/MQwQ6v9twTKzBuM6F5WftEWIMEK2yo0jYd4kai7G
	rDmR8cC8G6s+rATHtuDLLrDBljdElWwrassxsdCW553SCOdIskWoGcTHPQ==
X-Gm-Gg: ASbGncsg++q/D6xnJ0FY5TeWh2803Psw0bTqSLIxMFzqeqT8UQWur0HQGF+BRcWhnrs
	eCjOVqREtKlwnRgXgI04D6PnGs5uHn7E3Z9W5nL4VQMbIBJSgav6hBq80Z3RZ1d9mD7hkwoAtSI
	rEM5vm3XOpq+kSR6/eYU+eGguMjqqowFjdz3uucRaUvitD5vKtDxC8L0Vuh9dzR7RqtTIvAWC+A
	90Ni+m24+tcI6n7XmalLUEuCN6g2D+MjTJyBDH7jCQJ9XHlh11LJEEBscdAASRclshnIvu11acX
	jDYD2kbUbAeXdQ7tfjDorrGkgPc9AzTLx64=
X-Google-Smtp-Source: AGHT+IGsGdE3pSRve/1pOVPfjaGicJaHnDZLbsbRaDHIEAlD9ugNsE+dJM1GtoAShAJrAEhDsg5Qqw==
X-Received: by 2002:a17:907:3e09:b0:acb:b900:2bca with SMTP id a640c23a62f3a-ad1a45a1dc7mr897008066b.0.1746526839225;
        Tue, 06 May 2025 03:20:39 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b5bd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad1891a2df5sm671750566b.38.2025.05.06.03.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 03:20:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/2] Update io_uring.h with zcrx dmabuf interface
Date: Tue,  6 May 2025 11:21:50 +0100
Message-ID: <7a4bc74622f8386b2197105d91c20f22c35762d2.1746526793.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746526793.git.asml.silence@gmail.com>
References: <cover.1746526793.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 572ff59f..0baa3272 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -955,12 +955,16 @@ struct io_uring_zcrx_offsets {
 	__u64	__resv[2];
 };
 
+enum io_uring_zcrx_area_flags {
+	IORING_ZCRX_AREA_DMABUF		= 1,
+};
+
 struct io_uring_zcrx_area_reg {
 	__u64	addr;
 	__u64	len;
 	__u64	rq_area_token;
 	__u32	flags;
-	__u32	__resv1;
+	__u32	dmabuf_fd;
 	__u64	__resv2[2];
 };
 
-- 
2.48.1


