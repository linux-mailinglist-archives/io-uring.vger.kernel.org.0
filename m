Return-Path: <io-uring+bounces-808-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F164586E399
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 15:43:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CD101C216D1
	for <lists+io-uring@lfdr.de>; Fri,  1 Mar 2024 14:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4747B1F95F;
	Fri,  1 Mar 2024 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="tnjThimi"
X-Original-To: io-uring@vger.kernel.org
Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [46.235.227.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B688423DE;
	Fri,  1 Mar 2024 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.227.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709304213; cv=none; b=c4gBPdTucYUP/iDlx13lTGrpWHQexG8hqu/XqgQB0rO50p/j3ugwrnca0pRNxF9J6kopFXgB9FWb3FiVyPvRSEq3/2UxhQj/nFizPAYVw133uFfnkeBvg3lud8n+j80ecqokOp78K38HaNPr4xiDZOAaQcGiEEYZOrV+O2JZ9g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709304213; c=relaxed/simple;
	bh=OnTKFgas6IdFh92/KQpHTR95vTLrd8aWhLoDrIWhXy8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Bds4z7t3DDUlZpZTpQ5zH7B6k+ZzIqZhDJYoPoV0umRx3gtICvoDA6Dxdbb3PqaOUREfpPx40oNrIHnCmgpxDRQ9/XtkjDMMZ3D7QVOzqdEYrj9IQJuknpMcBEX9ikXv/Rzeu8CFLUB0V3pG3uJVi6i8eLoO+e15EU7wx1UQCQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=tnjThimi; arc=none smtp.client-ip=46.235.227.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1709304210;
	bh=OnTKFgas6IdFh92/KQpHTR95vTLrd8aWhLoDrIWhXy8=;
	h=From:To:Cc:Subject:Date:From;
	b=tnjThimieXpRL4nOo0zsMGwlIFay9Xm5OlmUmjLNGWcSHgokdjjc9caUXHWIDGrG7
	 ngSyAK1rY1EyjDaFXXusw+/PuGXNUTPPO6Q5EU29IrKxq1K/EvrUKeEO+pH/ckes//
	 +eFUPxkQxC2qkeMF6n97lN2+vGQ/olRAhQzUaZH7QTIeiLbJLvpsw9mvDJXuYiyOEZ
	 IPVdzMhnqYlJ3I3t/DjqaV8n326Yuj4LmRU500cnLWJlcPcxxrK1RG14k7Qq8vGOus
	 h27yHz2YzQ0dol8nQxGXdAaKcj5+wGafWPDcilgO1MEzveyLWkz67pQq9wClDgSzD5
	 C1/vAcmct4GPA==
Received: from localhost.localdomain (broslavsky.collaboradmins.com [68.183.210.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id B331A37803EE;
	Fri,  1 Mar 2024 14:43:27 +0000 (UTC)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com,
	kernel-janitors@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH io_uring/net: correct the type of variable
Date: Fri,  1 Mar 2024 19:43:48 +0500
Message-Id: <20240301144349.2807544-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The namelen is of type int. It shouldn't be made size_t which is
unsigned. The signed number is needed for error checking before use.

Fixes: c55978024d12 ("io_uring/net: move receive multishot out of the generic msghdr path")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 926d1fb0335de..b4ca803d85e23 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -551,7 +551,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_recvmsg_mshot_prep(struct io_kiocb *req,
 				 struct io_async_msghdr *iomsg,
-				 size_t namelen, size_t controllen)
+				 int namelen, size_t controllen)
 {
 	if ((req->flags & (REQ_F_APOLL_MULTISHOT|REQ_F_BUFFER_SELECT)) ==
 			  (REQ_F_APOLL_MULTISHOT|REQ_F_BUFFER_SELECT)) {
-- 
2.39.2


