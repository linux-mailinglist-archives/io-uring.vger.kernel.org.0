Return-Path: <io-uring+bounces-12925-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cHBMHiRYzWk5cAYAu9opvQ
	(envelope-from <io-uring+bounces-12925-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 19:38:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EBAED37EBA2
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 19:38:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CC6FB300340B
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 17:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2900347DD46;
	Wed,  1 Apr 2026 17:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHVSJWgj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D352F9984
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 17:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775064965; cv=none; b=k88hrskOLEzkyCGiY+nSCwMavGW1tULocyrfFOZoHMNPl3lpVBHpPblgfUhi1ELqbU6+eIU96G2zndan6o34twRm8nDdNZdnmuMBMQITG9e+arJRBWbfOVFo1ckhx+UVkMNN5kqtspTvs1CiURXIzC6sVZHgRfSweQ++cLAmV+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775064965; c=relaxed/simple;
	bh=eLSBqH1oYyfQDf8diiLGJZcIZg5SpaWLPTXV+wGFx9s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BvxhYyBGkaTrd5MxfVes+Itnsf8e/3rXgL6Qe7v8vA7G2fbTLy5leao2bLiaokQ+ici05sXEH4x20hPTn8hh4KkaehzoLwUFQOkzSnnLwGPg49j/WrAhg3fLIPECILUTda76kbLB03SNQI07QduYwyJw0JyllAjJzGsPOKZ2S8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RHVSJWgj; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c736261ee8dso2605873a12.1
        for <io-uring@vger.kernel.org>; Wed, 01 Apr 2026 10:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775064963; x=1775669763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IF6/5nQ4kVW9vaC6CpwG50My/JJfeN+FrBUv9tEDJUc=;
        b=RHVSJWgjVRrMj95mKZ8tkjug4Myfj0USRVg2L41e+ju3gr13+l9MJ5sr4D6F3F/nQL
         1p8uzllo3xaXjIJs5fbFB5eB12njrZxN72IwUbHQqs9cnqQ2vxnaY5OG70lRFqgNMLAD
         kBSO5KBKINKrv2NGFeiXfjfhkZ4LNkXdVwFijU2xXb7w8/V9FHH0ni61OUjUEmpHTZBB
         864n7AlAZrRnjKMgulWqAQ9TOVXJojdpKLsudGQUj7rudoKbpiBb1iAPMwf3B24GVZgQ
         ecflzx4piebqiB4Pn9+18GrRcpsA8Zt0HbkkloM1nvGhvMBOk+NKHeoKPemvDrQoCNtG
         NQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775064963; x=1775669763;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IF6/5nQ4kVW9vaC6CpwG50My/JJfeN+FrBUv9tEDJUc=;
        b=PYpnFSn+QKYd4ntOGfSpRMrD3nTEP6OSBMhHNVbggFtDvVgznrpU219U1IGgU1ijSU
         wDQST/IaA6UxpBFjw3vKczgBKJE52rIbjBGEK7EwyZaCdgu50rZArW3/diL6cC7iISd5
         Ua7fjkue9+Mm18Y7yKn+sR3V2kM/hEtuj4EQd5StenBaf7TIpXdh2Yb+LOYbo3OSeh9Y
         CflKVBkSAhACfLNf89u+MfVJOivEIQ1mh2znCm20m9YPdeJbxlHTzxj0eNQ3BaM+iRAX
         hlonqgyfQlUcgH0pfm6wf/9g1mbBMpIdJmyTDEI/mCllgsEEwxt6BzpoD+zhiU4vvdie
         SQaA==
X-Gm-Message-State: AOJu0YxZGgHHteHraXX9mMtSQ9BobO5GoPaUxsXCt7DynvzdAVXqZ5Fe
	U0DGVLxSwH0m6JcxKtnT4uogqAQTtGL53E7cwM8TRI75DNywhX3EosC+uVsdlw==
X-Gm-Gg: ATEYQzwp8x1WiCI28HcMo3pDrHJ0JLStHoh7nlMWPYRGQ/pivIDsCm9SgJP4b21YTUP
	qLu5njQzL36J8lbIEbecg1De7f5vb9xx3c77yCUSWe7YGGpt7yoaNtsrHew3kDftos/n3Lt9CUR
	ruWCenErY8hqtrZMYJiIFZQ04k2dvFfM4zvlC8b5uIJ6JPRe2pgxDNV4kHVIcvEtXtBGGcW6AMA
	PZz0OsJmbeMjhFkziM/oXHdM4+kEJNNbOAZFT8zQqTXR/QjxuvvpuAeer9mcFBFOhOci6CWmBEe
	wU4rn/m5MhrYih4+koFVIhTJlskusBy1xK84PEyptYZdjbJqtJvaUPAw46aC3z6t90XoQbd+Scz
	tn4W6sz6FTnxfcUm4lgVVCbxthjzotmGEWhAqTCCGL3CmyYLxre2r+KnMY7htktxXXku1OZpTHh
	VXkSN64f2l0Wm29yoKOA==
X-Received: by 2002:a05:6a20:11a7:b0:39e:f994:f681 with SMTP id adf61e73a8af0-39ef99502c9mr3058337637.0.1775064963119;
        Wed, 01 Apr 2026 10:36:03 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:46::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c6372078sm501410a12.0.2026.04.01.10.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 10:36:02 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: [PATCH v1] io_uring/rw: clean up __io_read() obsolete comment and early returns
Date: Wed,  1 Apr 2026 10:35:11 -0700
Message-ID: <20260401173511.4052303-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_FROM(0.00)[bounces-12925-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EBAED37EBA2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

After commit a9165b83c193 ("io_uring/rw: always setup io_async_rw for
read/write requests") which moved the iovec allocation into the prep
path and stores it in req->async_data where it now gets freed as part of
the request lifecycle, this comment is now outdated.

Remove it and clean up the goto as well.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/rw.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 046f76a71b9c..20654deff84d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -962,13 +962,13 @@ static int __io_read(struct io_kiocb *req, struct io_br_sel *sel,
 	if (ret == -EAGAIN) {
 		/* If we can poll, just do that. */
 		if (io_file_can_poll(req))
-			return -EAGAIN;
+			return ret;
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->flags & REQ_F_IOPOLL))
-			goto done;
+			return ret;
 		/* no retry on NONBLOCK nor RWF_NOWAIT */
 		if (req->flags & REQ_F_NOWAIT)
-			goto done;
+			return ret;
 		ret = 0;
 	} else if (ret == -EIOCBQUEUED) {
 		return IOU_ISSUE_SKIP_COMPLETE;
@@ -976,7 +976,7 @@ static int __io_read(struct io_kiocb *req, struct io_br_sel *sel,
 		   (req->flags & REQ_F_NOWAIT) || !need_complete_io(req) ||
 		   (issue_flags & IO_URING_F_MULTISHOT)) {
 		/* read all, failed, already did sync or don't want to retry */
-		goto done;
+		return ret;
 	}
 
 	/*
@@ -1019,8 +1019,7 @@ static int __io_read(struct io_kiocb *req, struct io_br_sel *sel,
 		kiocb->ki_flags &= ~IOCB_WAITQ;
 		iov_iter_restore(&io->iter, &io->iter_state);
 	} while (ret > 0);
-done:
-	/* it's faster to check here than delegate to kfree */
+
 	return ret;
 }
 
-- 
2.52.0


