Return-Path: <io-uring+bounces-7914-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA4FAAF927
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 13:51:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB2E93BA3B6
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 11:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87CBC223701;
	Thu,  8 May 2025 11:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DUCcviKb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C630D223702
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 11:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746705085; cv=none; b=Acgns2AAj0oit9mz779VKEONLEZbavjwH35I7o6/iSpYY6ksPwtPTc4+CgwVeTYoJLjxKZYHy3BKfY3zT4n5GMQS+bIuup3vmdAThJKdyWSQLNeOkqfgP47TITRV/HXJw9t7rmixUT3s0d+XEwGKny1Uvd0saMmihcAARf7jBxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746705085; c=relaxed/simple;
	bh=N0DIGNtCuXOm+aqkuGWupdLUm5tbPsvHiiXru4ed/vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k41OviMNObSxcyn5hlgru4s0Pnu71fGFRLt4/ZigpfdjDVXyMvkxa8YFkpmTJeuZ7nwm2d7hN5E0/O2nid1gJ9zzf3f8nhiKP6iHSl/gLi91hBty3Fw3/zwmybryl4xHx8x8Ubbf30psn/YyHoJXXZTIS+J1VW9R0ufKjvWmRNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DUCcviKb; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5fbed53b421so1386031a12.0
        for <io-uring@vger.kernel.org>; Thu, 08 May 2025 04:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746705082; x=1747309882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GWgbStjtpmJ853FAj2szPu9xEcYkTPmp5iotdAMXFs=;
        b=DUCcviKbCirPIYajsz1QfrAb4+ZJFQWUaB1WF6J3qYuUKY4MwfRB7cmppLCcBMHAPV
         pEn1Xq3WqDSV07Ia5uKRvxVfvoEBB5We8TL6fQty6Ih+9FvvPaZqqBJ66FQ2VWAImDFz
         R+ipz9JVV7Lkk1NnBeQX+K17r6rauH8xfAcUTO0wSKHGf9CIfSq9YyK4MbsqntDpSbE/
         NQYbmImFaoSLGSftUMBewij2rZJhkVS9rdTeKrp/BLlfNwetbwwfHv3AxPaDV6B3BswP
         ON46wkER+NX3EUsG2SGibX55LFhYj/0BTbixKMNsw060JVgb6yt3+diAy4LTN1u59yBr
         yn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746705082; x=1747309882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6GWgbStjtpmJ853FAj2szPu9xEcYkTPmp5iotdAMXFs=;
        b=HNz5X9gc984WbbkQFqnrVPIjWmC+tk0RTHES/jmKPbJy7mpaZnkswnwdt+i/9LyJxL
         UgThjyjdY39DtwKlXZOEQ2bMncDmIIj+Kr4wHO9u/EA8+dFUS5LWNOyCQbk50KsW8xjx
         YqGIJwYgy/3qn1TSUvo/S8O2phFQaIjElS6noAFBeGiaR2Lg2Ecvhfy6hKDJac2TM51P
         iwNLoANfMpV99Zn7v3Izo7bpf1Q71nbZ/vaHesQVFU6KqjsvVQh6Ghs4OofT+eRKl1bP
         ofSxW/w6TNHAVviptsoO7fDnPkbaavQjSdlkHt7MAJYyux2zN4tuMMOPLBN8Cb9woGhL
         9YoA==
X-Gm-Message-State: AOJu0Yz92eWZb/peTn6ziAhSTLYx5wvWBBNGFDSj00rqncAuNJDsaJkO
	d83En8tVvcvJRCCjFOHb0Dr3yghks0ubnihDmQXhPgjeGDd35p2em4WARA==
X-Gm-Gg: ASbGncs5pq2u5qpPD6QSZaNWvEODwyUCZQwLue629MBA/v1nBZ4N0fjJUUIyMWbLNEf
	B6pWWyEsFPKRLfa3Y4XkdbZMrUuuaCvmgmM3stizy/Bx3A0Dtdsu1Tog9KUe2s2ntz23ts9aHz7
	ZXByjTUsAIHX3os5jcS1DY/txUUS/6B+Y6KFplgoNeaZ45pZXaxKn1x0jVTLJW05/skfZ6LoMKC
	k8yJy41dt0RWrv7fE+G+vDKyMDMO/UuFCIgmiku79fKCWzj1WWTRTt/1OPreXuRdO6qRgozN5a+
	PyoN2jVNUvAFgKtQLOZnMtnq
X-Google-Smtp-Source: AGHT+IGkl7q51zQMnBFvfcSsFM1Q4Lb+gKgXIZddX1vnb4VoXDjaGtKD0cfMqxXdQ3o5P3FgBAzXdg==
X-Received: by 2002:a05:6402:524f:b0:5f6:1edc:bd37 with SMTP id 4fb4d7f45d1cf-5fc34e7967amr2800533a12.12.1746705081379;
        Thu, 08 May 2025 04:51:21 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2cb4])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fc8d6f65d6sm677051a12.13.2025.05.08.04.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 04:51:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 5/6] io_uring/net: move CONFIG_NET guards to Makefile
Date: Thu,  8 May 2025 12:52:25 +0100
Message-ID: <6b0e152402ea2e6f4acb27afbd2a27c440f736f7.1746702098.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746702098.git.asml.silence@gmail.com>
References: <cover.1746702098.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instruct Makefile to never try to compile net.c without CONFIG_NET and
kill ifdefs in the file.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/Makefile | 4 ++--
 io_uring/net.c    | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/Makefile b/io_uring/Makefile
index 75e0ca795685..11a739927a62 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -7,7 +7,7 @@ GCOV_PROFILE := y
 endif
 
 obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
-					tctx.o filetable.o rw.o net.o poll.o \
+					tctx.o filetable.o rw.o poll.o \
 					eventfd.o uring_cmd.o openclose.o \
 					sqpoll.o xattr.o nop.o fs.o splice.o \
 					sync.o msg_ring.o advise.o openclose.o \
@@ -19,4 +19,4 @@ obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
 obj-$(CONFIG_EPOLL)		+= epoll.o
 obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
-obj-$(CONFIG_NET) += cmd_net.o
+obj-$(CONFIG_NET) += net.o cmd_net.o
diff --git a/io_uring/net.c b/io_uring/net.c
index b3a643675ce8..1fbdb2bbb3f3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -18,7 +18,6 @@
 #include "rsrc.h"
 #include "zcrx.h"
 
-#if defined(CONFIG_NET)
 struct io_shutdown {
 	struct file			*file;
 	int				how;
@@ -1836,4 +1835,3 @@ void io_netmsg_cache_free(const void *entry)
 	io_vec_free(&kmsg->vec);
 	kfree(kmsg);
 }
-#endif
-- 
2.49.0


