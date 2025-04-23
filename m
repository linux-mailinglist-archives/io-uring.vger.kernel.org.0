Return-Path: <io-uring+bounces-7662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A0AA98900
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 13:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BBF83BE65D
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 11:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E400019F13F;
	Wed, 23 Apr 2025 11:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bN7hr0Hk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2DD242D66
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 11:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745409458; cv=none; b=CjShrcZv7NgyzQ8icBnyehqYUqfYKwkU9K4uF8s6Czd8/WPrTNSM9p/E49HTerexk8pZEEJQUatMm0GlLELzhvDh15tdxrMnm545hzRXboH/b2+DiVkn0ypgnaTWG1N/Vki6gWxC/R81Angi6hTc1mPlWRl1lg1zieoX7rl9Uxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745409458; c=relaxed/simple;
	bh=0BQ1vPMJYogRC1K2mk5NhEZiPAzPE936GW9caipKQvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sH9kWB61Crdxcq4PiDsv7C7FJpAcEn8Bl9AN0uDgJ7x4CJvfZeTjs72ULftv59YkO+s8xLqVFehQljLZKtj8f9K76XScYRiwef6N+Vlil0MWaal9XWa/PEivboR9HD7xD43D+VEKTi9cEwFhMNuGWV8MjvDmDzKTm4JI0p5T7W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bN7hr0Hk; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac3b12e8518so1026646666b.0
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 04:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745409455; x=1746014255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kACugjyP3Hc2XmHnLPKXBNBr3yCGB9ogK8TZ5FaiMo=;
        b=bN7hr0Hkf0n8cUQ4qgPWxPpKiCJy1qj5AvuQhAiq4YYTisJI15dLNPtd4/2iyC0AZX
         1emAvaUPZmsz+lhf5gg62lUGQi+WK3yBn3AtSSn4OK+MGC3fs3Yib1BBLR0CepU9i8rJ
         MhLzWHVkD6EVsM7Iqd0j/3guE5BZIPjo62Nwbnldd6hTszFUI0HwIj3Z9jzaHYITAkGT
         npooYwhA2hH8KvuJlmLlOwzEJQN49s50HgZRNmcf8+0WrjQHfDVC9Wj91qyx4UdGsb+I
         WBDwwcGhDanUfzPEStH8CxqDMRau/LvtO9gm7AngfaHQRhoTItzTbtUxssqbcqJlD/1N
         lgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745409455; x=1746014255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kACugjyP3Hc2XmHnLPKXBNBr3yCGB9ogK8TZ5FaiMo=;
        b=xHLBVLtCmnHruDsBuTNtNn7oHhHryofnSwkBdYHI7fDYBhUEHn6IPG+LQxKEj8greE
         MJRp9w+gRTRT4XT74v9UERwqEDOcSkj7duuiEJGBM4GIEGYmzbrl5hdTjyMF4Kp1tNhx
         WiEemLi4+dp2Qd1e0FEEEhoe8U8Ao7NAT/SZF40VUT2rdGK1Day9n89LOHxyO/IO2viP
         uDbpF4byOFN3/p8/WI6CVm0pxBXWCaDF+dSfhEZA08oMDUiVdZ2Wjd0YrL2aSVDcOfAT
         AxuAku/A3H9nwRe7Lm0CChPrys3eyn6w71CBW3n95MYjI9WXnMBEjHeMVewTDqw8irQ/
         C7VA==
X-Gm-Message-State: AOJu0YzHXKFKMhfHjXj3bZ+LdZn2iUHddC5zcRk1BgTts9QjGB/MFUE6
	EPLn/SRwCJkRbe6LQ2boFskveot9qqgVp9B+ToHvRVABSXIlgucHtAyO/g==
X-Gm-Gg: ASbGncvVaDi3DwokQVPpjrq0QJG1HDJMETGhqEbRJhKhFSEhtD3zRB84kUfFmjydsNO
	jYEcEftRhZ6YKE2L/pmNML6Vbl3t7qK+dXpKe+zpPWwWHmU97n8H4951NQIOsS2afJs6JqMJE2m
	JIJFVf9PuVOVmswVT6U6zGhj0nPZv8JU7XbT95n8pY/S7J+IWW85lcsL6E25O7VfRzujTgTIdJh
	YO2OI2Z5YLd+dWedwQhu9bDlKf3CKZunBENHAtqB6zlkSe1o1XzUytVdkDZs4z05f6UB8BXthIQ
	yWZ9VcTv/u+fWbbHppk1fiw28i0RwL1gO5GZW7/LfhhPMrYUFnyVx70=
X-Google-Smtp-Source: AGHT+IGbNqxRXjII9UpmkZCDXSBel3IDcsY+K6IMAgkj4ZO00RPbpp/gHC3ct2rXlIYyPcqz4hmduQ==
X-Received: by 2002:a17:907:6e8a:b0:aca:d4f0:2b9f with SMTP id a640c23a62f3a-acb74ad8451mr1613276666b.10.1745409454824;
        Wed, 23 Apr 2025 04:57:34 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.217])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f6258340c8sm7350983a12.58.2025.04.23.04.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 04:57:33 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH liburing 1/2] examples/zcrx: fix final recvzc CQE handling
Date: Wed, 23 Apr 2025 12:58:37 +0100
Message-ID: <678348ee0d2bff1aca3753d9f31a3affe135f0f4.1745409376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745409376.git.asml.silence@gmail.com>
References: <cover.1745409376.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The last CQE of a zcrx request, i.e. without IORING_CQE_F_MORE,
doesn't have a buffer attached, don't fall through to buffer handling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/zcrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 40a4f0ad..3073c4c5 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -220,6 +220,7 @@ static void process_recvzc(struct io_uring __attribute__((unused)) *ring,
 			t_error(1, 0, "total receive size mismatch %lu / %lu",
 				received, cfg_size);
 		stop = true;
+		return;
 	}
 	if (cqe->res < 0)
 		t_error(1, 0, "recvzc(): %d", cqe->res);
-- 
2.48.1


