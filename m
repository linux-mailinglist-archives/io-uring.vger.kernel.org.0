Return-Path: <io-uring+bounces-9838-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F80FB88818
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 11:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59B4D5A062D
	for <lists+io-uring@lfdr.de>; Fri, 19 Sep 2025 09:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3281CEACB;
	Fri, 19 Sep 2025 09:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LvIvj/2Y"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847EB1C6FE5
	for <io-uring@vger.kernel.org>; Fri, 19 Sep 2025 09:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758272676; cv=none; b=nVengqYBHaWMzaWTEbpxtByDwnsO377UWw8GcXhcbEYuER2l1cfRw8MBUVPc06/LTf8/2hDtjLBmFBsvwKa68edOUrVkB4o8rsv3cTmuc8jcw5EIT/vQY50mg5hF2YmJY3+AcPnLXEnNW0sOHevErr9yALp01jK8gHi9rWu4SNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758272676; c=relaxed/simple;
	bh=p96dtqbhzi+9WsYHK6xa7P9QMa2meF8KJl7qjrM+TrY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fr9/E5YbLIqZtUpd+gu0XFppHliZY/HY6VFCMxRdYb84q9mjQMYUrhHoo6iXLdHNnjyACPJr5cBrC7tTmJxUqCH2pTpifLKx5o5T+MT2l0fbd8gVKLWE4b9/5UaQJ6igEsBNGxSPASsOWYawTUWAq/ICg1Lf5TeiEdxPiaq4yuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LvIvj/2Y; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=T2
	C5IFN6zJFI3M+hAspZT1UMuIVbbCElh6aZubkUSzk=; b=LvIvj/2YfLQh9gMPNY
	oVwzNsiK9utF5P64y2Jl9wE9cj/prR8FacKKgeyu+ooIneDiRNu/wbVuYh3XW2kn
	IW7ir3mJTNI1qnBZa6hXaD5eRaALAUBJULZuej5mJOAcSVYTjVBmEQz1G+NlzOpY
	0WCGNlXui53DyNP6LLBqpGyaE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3Z5qEHM1oTvOQCQ--.7054S2;
	Fri, 19 Sep 2025 17:04:04 +0800 (CST)
From: Yang Xiuwei <yangxiuwei2025@163.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH] io_uring: fix incorrect io_kiocb reference in io_link_skb
Date: Fri, 19 Sep 2025 17:03:52 +0800
Message-Id: <20250919090352.2725950-1-yangxiuwei2025@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3Z5qEHM1oTvOQCQ--.7054S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF1DJF1fWF4xXF1rKrWktFb_yoWDGrcE9r
	1UXrWkuF4agFWYvrZ5Cw4rZ34avw4j93yUuw4xZ3yDAF95AFs8XrWDZw4vyrsrX39rGrW5
	Gan8Zr13tw1avjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjApnJUUUUU==
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/1tbiIBPNkGjNHC8ODAAAs6

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

In io_link_skb function, there is a bug where prev_notif is incorrectly
assigned using 'nd' instead of 'prev_nd'. This causes the context
validation check to compare the current notification with itself instead
of comparing it with the previous notification.

Fix by using the correct prev_nd parameter when obtaining prev_notif.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 9a6f6e92d742..ea9c0116cec2 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -85,7 +85,7 @@ static int io_link_skb(struct sk_buff *skb, struct ubuf_info *uarg)
 		return -EEXIST;
 
 	prev_nd = container_of(prev_uarg, struct io_notif_data, uarg);
-	prev_notif = cmd_to_io_kiocb(nd);
+	prev_notif = cmd_to_io_kiocb(prev_nd);
 
 	/* make sure all noifications can be finished in the same task_work */
 	if (unlikely(notif->ctx != prev_notif->ctx ||
-- 
2.25.1


