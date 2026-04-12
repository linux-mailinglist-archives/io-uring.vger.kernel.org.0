Return-Path: <io-uring+bounces-13027-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIW8Lyxa22nPAgkAu9opvQ
	(envelope-from <io-uring+bounces-13027-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 10:39:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 05F903E31B1
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 10:39:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F1B33014956
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 08:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFBE430C34A;
	Sun, 12 Apr 2026 08:38:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.76.78.106])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44754212548
	for <io-uring@vger.kernel.org>; Sun, 12 Apr 2026 08:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.76.78.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775983116; cv=none; b=L5x5f5nKeXVktgOwWTEI6QtNTrgmPx7wcLnGv43JHx3ejAxse6zgJGaQTLFzdHJtx8BtBo/vwStjYMlTKbveaPxcdSPBMgXhM3oyZ5ZUmV6fDjJI+Rf3eXN0OJpkvVWNqeNkX9XQk+uwhGPkcG9eoogj+QuvsG31zy6OCaR2Irk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775983116; c=relaxed/simple;
	bh=DKN6YU0SimhT3DhkpgcXh5IvJYUmKGjwwJMGwXY0E+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uif6hmphp73KoShnlwN43lJ3DYq5XNtrvfpz3e6+0+DR044aP1ZmkzAUg+NsEy+wJ0SJPHu9O2t+iQVcD+nzms8TGS5JqLiEDHbosTY7GvMxRRexmdrP9nkkg7y25S5LMUmyhblwDpvEgatt4L+yPaBtjXL1UP3UMcNcrfJw8EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=13.76.78.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowADHOPn9WdtpBq69AA--.9034S3;
	Sun, 12 Apr 2026 16:38:23 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	yuantan098@gmail.com,
	bird@lzu.edu.cn,
	zcliangcn@gmail.com,
	ylong030@ucr.edu,
	n05ec@lzu.edu.cn
Subject: [PATCH 1/1] io_uring/poll: fix signed comparison in io_poll_get_ownership()
Date: Sun, 12 Apr 2026 16:38:20 +0800
Message-ID: <3a3508b08bcd7f1bc3beff848ae6e1d73d355043.1775965597.git.ylong030@ucr.edu>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1775965597.git.ylong030@ucr.edu>
References: <cover.1775965597.git.ylong030@ucr.edu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowADHOPn9WdtpBq69AA--.9034S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw1furWfCrW8JFyDKr1fCrg_yoW8Aw43pr
	4YyryDKFZ8tF17J390yF1rZFWrAr1kAa4xJr93G3y3u3ZrWF45J340gFy3Wry0yry0kayY
	vFsF9asxWws8Ca7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEPCWnaCt8K4QAAsL
X-Spamd-Result: default: False [0.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_FROM(0.00)[bounces-13027-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,lzu.edu.cn,ucr.edu];
	DMARC_NA(0.00)[lzu.edu.cn];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[n05ec@lzu.edu.cn,io-uring@vger.kernel.org];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 05F903E31B1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Longxuan Yu <ylong030@ucr.edu>

io_poll_get_ownership() uses a signed comparison to check whether
poll_refs has reached the threshold for the slowpath:

    if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))

atomic_read() returns int (signed). When IO_POLL_CANCEL_FLAG
(BIT(31)) is set in poll_refs, the value becomes negative in
signed arithmetic, so the >= 128 comparison always evaluates to
false and the slowpath is never taken.

Fix this by casting the atomic_read() result to unsigned int
before the comparison, so that the cancel flag is treated as a
large positive value and correctly triggers the slowpath.

Fixes: aa43477b0402 ("io_uring: poll rework")
Cc: stable@vger.kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Longxuan Yu <ylong030@ucr.edu>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 io_uring/poll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 2e9ee47d7..b98439107 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -93,7 +93,7 @@ static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
-	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+	if (unlikely((unsigned int)atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
 		return io_poll_get_ownership_slowpath(req);
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }
-- 
2.43.0


