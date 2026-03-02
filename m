Return-Path: <io-uring+bounces-12505-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wOGoCqmMpWmoDgYAu9opvQ
	(envelope-from <io-uring+bounces-12505-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 14:12:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD7A1D98B1
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 14:12:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 06E673003508
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 13:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FCB3E0C6F;
	Mon,  2 Mar 2026 13:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RD0nmjDt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C9F3451A6
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 13:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457049; cv=none; b=cK+DZLUen9yZPcpoyaJ2ezBz2Yr7rN+awPrCoOV00NFnPfSLRFHq0Ua0rOmonD4SckHiEZzJ9pUevrpdSYMph5AUQbodBospNFYdb6eG2sR5JGq+ZQcYvQevOcrMxfti5DYeLJrLjxPOmVaSqdbYHiZYt2JfMRLKeNfVKSmSkMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457049; c=relaxed/simple;
	bh=Ns2B4QODT1Lw8WKGT5BjM0xeblriyj3rPXpWr2OUwNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWvekUviFavN9vwipwXXLdvYIIzPbHEIkurXZoeOGIi9AuBvWMi05K2fAdwhmfkbI9q6JxH1Gt8A8TluqsCLNYSlujDJxy4doWMQBis6twmBhbQvnFkmWiBtc4tzO4ec2XaCkyORcYG0WemzmYAbnxkKkC0v8JiLS+ZHJipo2LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RD0nmjDt; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-483bd7354efso59992225e9.2
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 05:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772457046; x=1773061846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SK6g0tzHt1H157t2w8lJaoJtSx/mDw4pY6xf8Wb0+Vg=;
        b=RD0nmjDtg0KWkGmKO3Gk4gz4u225zfFftfBqG6phFRDuT2eUqnoSfPulzamJGQNN/U
         KD4mtUEpjolosIARO6DSZN5yiTAztCXDkC3D9amPTvoltkH+36xHnnKft+HEOqA670lu
         AwsAPG+mjUAjLaesTEwMtKXVgJZc6SxHld73hpYWOGPeduzrNZ719ai0xD6Mo89+64op
         PzlcxFtJUGycPLpmv/zUyuFvh/kKBwtDeJkWzM7F69wf7+l+cr6DTGS3meWX9x+UQmzx
         1P2nSetX1AlN1+zNBpzaAHXl0LseTwKBjocy5U9AQH0CG7yuY7fsXEDoJ1/f/iojYnsb
         EE+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772457046; x=1773061846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SK6g0tzHt1H157t2w8lJaoJtSx/mDw4pY6xf8Wb0+Vg=;
        b=HO0JFCTnyAGzo17LgjuKM14zQZkEzamS3k0WVXyfYxiQIpb/FUoDVjJ+H+/N/X5f0G
         eUIE1OBuE6CJK7usgIcmEi/cpA3LiOrYlQzEBck44HV/+qPSxUCpPF+E3j0x0/cIugpM
         lQPAtlOf88GVHaF/pwC8c53/y0Z6OP3QPckKo921Cyq4VTjGZxK+kmJEggNYu3k+O53p
         7EQZTDFfUM9einHADVBzKGSfIu31yZ/5RAmJb7MrAR7FlD9EJJ1dBqPV0/ggFLQohUeD
         eJE+eP3QP2oijhbFppPPW2mv++LY/Ba5gzn9w/pVRfCAm0I7ZCHm+D34RErFuEODGYD8
         qLJw==
X-Gm-Message-State: AOJu0Yy23Dhpib1P/nFyVmREJi2ivyOvFKVYb8F0oIsqudHe896NXEff
	gPYOMZsUE9+vpf6JnZzM3fgYv/fDlmGbSg3fsS/NgT9WCTLssZP9T0mYLORUQg==
X-Gm-Gg: ATEYQzzQfQwLjwU42XlFlQ41RLbzP7sKnQ9VHe+mfezty5LKc//Lg9BR4hhUNz4adRN
	D4ttm4G2eTwQXAll6yQKr12uoHVyhsEh7eEn4VchcjG2nmwRXyMfG9g+MC3v4LMt32YoRLXY9JJ
	dwZc7Um3K9kez1JKIZQr/oSOTB0mp0Vr1DAdc4hz5rqqVYovF8JDTjoLTOlJ3HLNtAbeBYemLMp
	OTSUnDwhqNx4I4R8ID9okgn8vORzPYQN17qt6y2dXjvcESIiM2dZ8vuEetwfrotJamWo1kPLC9Y
	069PymaPDMo4BhNNTLWL27fpW71NbuoItLRWsVCbL5MTiMrCrN/wxcJ0NVtTKdzCJYos2WWiju0
	QefD2+ZUOZ/WM7OYCPkVluEuji6ah7GqM5K/kwFHuwPq/IuK+/k3ES3zeynEWtWptHVoumgwo45
	wQMchib8cgfw8HHYEE1zIvCoWilJ6oY/A4/Jrm/ZTKkZ5VFvY35kzvjkrYTBxQ5U6ZJ2Z0ktubR
	pZbc+iknQ==
X-Received: by 2002:a05:600c:5306:b0:483:6d42:25c6 with SMTP id 5b1f17b1804b1-483c9bc4210mr231386815e9.23.1772457045772;
        Mon, 02 Mar 2026 05:10:45 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:cad2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b346ccsm259935925e9.2.2026.03.02.05.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 05:10:45 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH v3 2/4] io_uring/timeout: add helper for parsing user time
Date: Mon,  2 Mar 2026 13:10:35 +0000
Message-ID: <d531c4d13b66c33cc452694346c68d8d9e42fff4.1772456786.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772456786.git.asml.silence@gmail.com>
References: <cover.1772456786.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12505-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8FD7A1D98B1
X-Rspamd-Action: no action

There is some duplication for timespec checks that can be deduplicated
with a new function, and it'll be extended in next patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index e3815e3465dd..f6520599e3e8 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -35,6 +35,18 @@ struct io_timeout_rem {
 	bool				ltimeout;
 };
 
+static int io_parse_user_time(struct timespec64 *ts_out, u64 arg)
+{
+	struct timespec64 ts;
+
+	if (get_timespec64(&ts, u64_to_user_ptr(arg)))
+		return -EFAULT;
+	if (ts.tv_sec < 0 || ts.tv_nsec < 0)
+		return -EINVAL;
+	*ts_out = ts;
+	return 0;
+}
+
 static struct io_kiocb *__io_disarm_linked_timeout(struct io_kiocb *req,
 						   struct io_kiocb *link);
 
@@ -446,6 +458,7 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_timeout_rem *tr = io_kiocb_to_cmd(req, struct io_timeout_rem);
+	int ret;
 
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
@@ -464,10 +477,9 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			tr->ltimeout = true;
 		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
 			return -EINVAL;
-		if (get_timespec64(&tr->ts, u64_to_user_ptr(READ_ONCE(sqe->addr2))))
-			return -EFAULT;
-		if (tr->ts.tv_sec < 0 || tr->ts.tv_nsec < 0)
-			return -EINVAL;
+		ret = io_parse_user_time(&tr->ts, READ_ONCE(sqe->addr2));
+		if (ret)
+			return ret;
 	} else if (tr->flags) {
 		/* timeout removal doesn't support flags */
 		return -EINVAL;
@@ -522,6 +534,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	struct io_timeout_data *data;
 	unsigned flags;
 	u32 off = READ_ONCE(sqe->off);
+	int ret;
 
 	if (sqe->addr3 || sqe->__pad2[0])
 		return -EINVAL;
@@ -561,11 +574,9 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	data->req = req;
 	data->flags = flags;
 
-	if (get_timespec64(&data->ts, u64_to_user_ptr(READ_ONCE(sqe->addr))))
-		return -EFAULT;
-
-	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
-		return -EINVAL;
+	ret = io_parse_user_time(&data->ts, READ_ONCE(sqe->addr));
+	if (ret)
+		return ret;
 
 	data->mode = io_translate_timeout_mode(flags);
 
-- 
2.53.0


