Return-Path: <io-uring+bounces-4501-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 082FD9BF09D
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:46:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F8AC1C21C30
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5951C3F27;
	Wed,  6 Nov 2024 14:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="I05jRsPp"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BEBF1DE3B1
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730904379; cv=none; b=PRsxk1YEjOnyAQtpWU8GUoE0jD0h/E4bE2b7Hwsjm4FzAIBrzbH/SRwCBZfnsQWEmE3dqJQRq8Cpfdj9vj1bkZbOzwcTzuGrXRR4V/Wazyt1U3/Hl81Lw4WxAcacpUeK26suOZ+YOuFbuM2fr+iCYG47zmOxWyWPn0w4EAWrc9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730904379; c=relaxed/simple;
	bh=95QezPw9dVMZB62WuWYkZ1e+Ta6s35ztszBbsAjUAqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSHamgPxJWXOYnJJe2wWban7+IESH8Q62uEm4YQQuXUIFSZ+LFE+noovp5rOMcV0VhbvaxnzoSIJVArXQhIkL2Yn3vH+TDR5e9vpr1Bx0/tC6PWiVrWWNnRQ1zWU+cTQYiIoFOCbKz5aOglc63QHkcARxq9BtEH32//+oYKvdSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=I05jRsPp; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=Hoq6p
	S8ti9Ct5OMW5TxzWrM+F4MQRyWsOobJEkad4O8=; b=I05jRsPp4qLPlJsTe8JFD
	z094YEe4gj7fVGie1yXODfDL66HbDwXh5zbD4OD0I0fcD9TQd++j2af9p7CHh0fl
	kqbvaVin6rUHgNA7DPwygHEkGSdJn9zvZpbbVAy1ClkAYBBY32HFee4tecnnhX1Z
	P4lFzuRPAiUuhOyZkesOqs=
Received: from localhost.localdomain (unknown [114.86.104.95])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wAnLw8zgStnNMASBA--.8628S3;
	Wed, 06 Nov 2024 22:46:12 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH liburing v1 2/2] .gitignore: Add compilation database file and directory
Date: Wed,  6 Nov 2024 22:45:28 +0800
Message-ID: <20241106144545.6476-2-haiyuewa@163.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106144545.6476-1-haiyuewa@163.com>
References: <20241106144545.6476-1-haiyuewa@163.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnLw8zgStnNMASBA--.8628S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF43tryDJryxGw45Jr1xGrg_yoWfJrbEgr
	1xCF1kW3sxGr1vkF15Jrs3Ar4Fk3ykJrW8ArsxAr1rA3sYywnxJwn8Wa13WF1rWF4UWF4a
	kr93Wr4rCFySyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUSAp5UUUUU==
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiLwKPa2crT6j55wACs+

The tool 'bear'[1] can be used to generate the C language server protocol
database file while compiling: 'bear -- make -j $(nproc)'

Add the database file into .gitignore as Linux Kernel [2] does.

The clangd will parse the compile_commands.json language metadata into the
.cache directory. Add it for clean git status track.

[1]: https://github.com/rizsotto/Bear
[2]: https://git.kernel.org/torvalds/c/26c4c71bcd9a

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 .gitignore | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/.gitignore b/.gitignore
index 7bcc514..4148091 100644
--- a/.gitignore
+++ b/.gitignore
@@ -33,6 +33,10 @@
 /test/*.dmesg
 /test/output/
 
+# Clang's compilation database file and directory.
+/.cache
+/compile_commands.json
+
 config-host.h
 config-host.mak
 config.log
-- 
2.47.0


