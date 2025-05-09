Return-Path: <io-uring+bounces-7921-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C231AAB1164
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 13:02:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 368554C4882
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 11:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD35228C99;
	Fri,  9 May 2025 11:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MXVNPpQF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3E713C816
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 11:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746788542; cv=none; b=qcJHG+NXNV7zW/rxhACuMjorguhlZmpVOmBoHD0hkPmVbL+C5ctdWIPZdRBhqoHI3INTwX71pY/Ng0ltkzAcJd9w3wo/EgCeTLKxOXEDCvNBKzXKWsLa6kL+mMmg6k5aR8UxUpBRyUdrqm003sIzIB0gCU5avGD/GXMurKMwqgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746788542; c=relaxed/simple;
	bh=N0DIGNtCuXOm+aqkuGWupdLUm5tbPsvHiiXru4ed/vc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fWeucODRiq8mV/eO/YgUuYg4Smc0mkeXjA/N0ZM2UT+e3o7h9BjpNTf0rugknQ0dObZQR3h0buxOkmyeyBqZmGsVvndkzpQavXwORqUXGCI3Lw5Fc+hBgBUM4FZRuIWOa2dk1MvMN907pk9kqmlTeEwXFYj4iPySXL8kndKheSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MXVNPpQF; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ace333d5f7bso338366466b.3
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 04:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746788539; x=1747393339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6GWgbStjtpmJ853FAj2szPu9xEcYkTPmp5iotdAMXFs=;
        b=MXVNPpQFh14xXdOEc0Pwq+ENeYGYXkEqHu/DubCGz119b1n1GPcsefC/pFZpmxZUNz
         8rE0PbQCzk95EJQpefOyEXSeba6FDysPBxF2Z/7iId/LuSIDEj8mTnbdbSDKIrHmSmS3
         9zZ9uv0HrPIAocToimDiCUjdxRU+CeafrUdfGzho2gtYAaryjfOQyJ571nNFyQbneiBH
         0xQJ3DIYhrtxVng6RQeA/GhZGYi/0Wr9gaAwVSYkct6ZiUqOfDa5OYnP5qqQL87NrBnH
         ka22oYvdZ2DpstmLLgT9yS0JZEb6wjrowFzjVWpeAMTP9fuMCw6Vm1Vwzn0q4s41Mj+u
         we+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746788539; x=1747393339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6GWgbStjtpmJ853FAj2szPu9xEcYkTPmp5iotdAMXFs=;
        b=OEmbqipZ/duJWOrR1TQ8dkOAVzAiS/+I1QGfKKRZD6HbYTxc9LQ7qkkTRbt+PtNT+8
         u7HdzC731xE8f9m4BNwB+jeuoMPBrsEFS/xxkmdMjQsdk5rUVl6hUTxBT+7VEIUZXDvn
         6b/Uu6KgQakLUp0lKLXTlnAe0e0w6WTuhNc9UxGabXV/u+VkBMCbU79TNH65SlaioZHo
         N78iwpTrbf5U9/gnFn2f5PhTdAoByNiTtWugVl/pDRjmlJ7D38XUdfLHx/+eXweS65o6
         e1LUphfa959EfriBwgJkj3PA9F2muBmPPbYtDih4cGDmEWomLaOsoKlM4BrtWH8JZRtf
         JGTw==
X-Gm-Message-State: AOJu0Ywgf76dGB+W9gi4OmFIpYeErDh3Z7lKt1xU57DMwekjlC5HOq/6
	NJtsjqCjlMkD94rLIoz72xyxT/hEV5UeKJwDTpytiyX0zbI6ADo3lPeqqw==
X-Gm-Gg: ASbGncua8i8I1n0bnItrbqz+bt7MBa02me8eCHOG/CamnjB1ltNUI0XiJesHIRbeQJu
	OvxgZOu8OTeUxXWgR+D7MCJhgpsU5cAzgHiaKFwuk1KWBbKvhDhSNYk7clBdjVcQBULJu0l+Kag
	AJqITf8FsDe/Ign1Ewzml5o/sbAPB5ngAYichklitWnSKWiskZ+wQ8GJeErUONjIvtSOU6fxiYF
	cXfkgdEhy2zc2l2CtsY2t8bEWB5AS3Mwfvbp+F+sVry3Hy68WNwv6RjNAOgEu/ePhVvOBGV83Fa
	xOT1w6FpwJlnMJLx39JK6rXp
X-Google-Smtp-Source: AGHT+IH5xBATmY8dqWT1Yi0KgSWMTeEzgYLugHexEJhg/IZG8aDrc2+gB2suoPsTn2SC4sW+b0btwA==
X-Received: by 2002:a17:907:d02:b0:ad2:15c4:e255 with SMTP id a640c23a62f3a-ad218f7c560mr324381066b.23.1746788538464;
        Fri, 09 May 2025 04:02:18 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a65])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad2193827f1sm133421866b.80.2025.05.09.04.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:02:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/net: move CONFIG_NET guards to Makefile
Date: Fri,  9 May 2025 12:03:28 +0100
Message-ID: <f466400e20c3f536191bfd559b1f3cd2a2ab5a1e.1746788579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
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


