Return-Path: <io-uring+bounces-8398-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05FE7ADD097
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:54:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09EFF400E6C
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF0F22D790;
	Tue, 17 Jun 2025 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UNxCBTxS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11879227E8A
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 14:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171651; cv=none; b=OBrQRXp0QA1cTb11AIYntlzv8wxOjEcD4R0XJMbdIfeMAXELG9YoTKEQuO1LK8wY5T1mdZoQ61+/fBl/XyIx6FSzWRXoldZzu/5+JIahXhtEl0rXx7EISKNStYd/alB+ZIlRLRT7u6XmzaISTYGud7AYVg2yCYXVUwt4AZ60Csw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171651; c=relaxed/simple;
	bh=D1qsO2F/ucfK1Ma/JjogAAYZfVv5EdIAHf5AKtLZZa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjcU2EqFkpvJ1xTC0+0rmRpcDwL4PbxPbVolQZvRhwrmFH6nK+ryu0k9k2nedcI5qQs/qhUjPaVl0LWHVh/zMQ6y5+I/sps0+mGtXUIeMZqxSifdzXrUDyznXoaS3FoN/Dn1WlhSg3jto+ooe0wdiWAShmm9NKoZIsG3kszoZT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UNxCBTxS; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ade5ca8bc69so890262366b.0
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 07:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750171648; x=1750776448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzgTUG324TmGAMew1PkuXFM2bLztRXhENF6myID8qE0=;
        b=UNxCBTxSPwOHZkjeuTrFzREF/W9XrpJ5CmlpCjM7F6rvlWJepLqIWUhUQPwynIJQDW
         WHL3/KZINDepsneaU4E8X6z+PvtundSLoms/oX1cDr6xkFdxl9rpLFPs1Jlrvh7dx+2x
         orvQZmuF70fM5H4nMNriBeSFscEFBuJjq1zpnIuUd1Qou+FImuxd8ZtuB65FiH1ayFEV
         rMoiLZG6742qjmJI92Cwb35WFY3SdyI4qF36g6ZeVFEEgx9PNt1GvCKYW2Q2Lfhz5PB1
         rEu5758EEhe0akreBug/W8d2J/q/ctv6gqg9kjzrBXakN2ZSA3lX0Up59aMfxuWkR2iI
         +mwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750171648; x=1750776448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hzgTUG324TmGAMew1PkuXFM2bLztRXhENF6myID8qE0=;
        b=QEhl6k9xCDwSW5g0DJKBrghindHe70McjUybEXalTiPxX1os/fkYkwxfnw4m5OkjjX
         LxaISCvAH8m3pi/wE3yU4bBSHbre4sQxsk+GE/qQ2UR3ff5QiPhjkJOyL1rOlpvEe3oF
         pdPMzoteKA2k9+PlXuK901F+n785G5FqqKQlfPrdmRqRJXavDLxC3iINcbWpsLep7Cw3
         bGwZM/eiMHldhLcb3ylKs7ds0kvrYQ1l8lxz3POOwlY8Qfy9gI8kLKxXs98BGnGEDVtC
         aHq4NQbEjmxaUtIumIa1/uOVl+J330ODctXW+BglGKCoqYXWaKvt+dx5/OZJjfHGxhV7
         gwmw==
X-Gm-Message-State: AOJu0Yw9pyQCL8ICAjirVlJr5UQ1fcAakao5qQeN4Fe3oeYobV8ngTT7
	ijgeQK1QworedQx9dhPJa86RYADCLRhJX1IABclc50aXDTj9jl/1jG5K38uc6g==
X-Gm-Gg: ASbGncv4URa+IN54My0iiQPavpMmqs1PO1MUPeAjW/07X0+NdhIdDIhB3tIYhdhKHfl
	3tNfej82WLWNA7M30id9DtieW5Szu8FUkoWm1uM1qLmmQhhUdQTilgeIwWn/KmJnUNqbGf+hT1o
	fhIOQuA0lrf7Zw9Gpx+0bZzVYdiLN7CwkcBIl4KmX00FYsAPIOnuMON6M73KRWeVTONEQVidvSi
	k7YDz6UKCAdgzZ3I1yBW/q5WSppScI325qRL6w3yHLZ1eAcfiOwlyNyonNappLkgpnmR96IeN91
	vcJE7reLstLiIo4+tKD/dnt/hLIJQLmdSD4Fds0K7prQxw==
X-Google-Smtp-Source: AGHT+IETD9cgfxqq/+G6/7p4uipwuNbpspxqNjb3R2a2/0TI2K/ElIil/52Dd4Nw75PZMQURqUiv1w==
X-Received: by 2002:a17:907:3c8d:b0:ada:6adb:cca with SMTP id a640c23a62f3a-adfad363e89mr1276940466b.6.1750171647684;
        Tue, 17 Jun 2025 07:47:27 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b491])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608b4a9288csm7951040a12.57.2025.06.17.07.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 07:47:26 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 7/8] io_uring: export io_coalesce_buffer()
Date: Tue, 17 Jun 2025 15:48:25 +0100
Message-ID: <f99797fe001da865532e20fe9d5877abefbe9aaf.1750171297.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750171297.git.asml.silence@gmail.com>
References: <cover.1750171297.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We'll need io_coalesce_buffer() in the next patch for zcrx, export it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 2 +-
 io_uring/rsrc.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c592ceace97d..bab0ea45046d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -684,7 +684,7 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
-static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
+bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
 				struct io_imu_folio_data *data)
 {
 	struct page **page_array = *pages, **new_array = NULL;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 0d2138f16322..4dcedfa69b8c 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -87,6 +87,8 @@ int io_validate_user_buf_range(u64 uaddr, u64 ulen);
 
 bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 			      struct io_imu_folio_data *data);
+bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
+			struct io_imu_folio_data *data);
 
 static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
 						       int index)
-- 
2.49.0


