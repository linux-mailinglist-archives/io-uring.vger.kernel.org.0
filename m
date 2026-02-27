Return-Path: <io-uring+bounces-12456-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPxQELrGoWkVwQQAu9opvQ
	(envelope-from <io-uring+bounces-12456-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:30:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A79501BAD0A
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:30:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7EA883077CF1
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 16:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3AB9271A9A;
	Fri, 27 Feb 2026 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=p2p.industries header.i=@p2p.industries header.b="Xagl5VsF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68641A9F97
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 16:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772209679; cv=none; b=mcv2OXMd5VCpDRO+fAH3Wjt6qNLc2uyj4sEWMFna2C5T6cOn7F1zTy0yriXrfONmNSZjBB6sLKE7GrZtUctS3InJHxEE/coFIGLWE41ynULlnEIIQRxFy7yANnEqBuUDY3OkXIzksKj2XqPQ9chBj9j/ll0oOvrEwPROqFi7tIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772209679; c=relaxed/simple;
	bh=tkupGVLWosd9h5O9WTeJtLj7xFFWbEgR/Q3ECU1nYnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TbyncWiSED8R870gogqf6j8BcNYHqjaBQqEm4BMBoQiGj9dHVUDmv6RkcnSaZS2eHpTDXAfOgyPvKFjJtMal6xipKOerxHb3zAsAKD50NVaOuG/NNYdG/9sfPhIOqzx05XpNyLsc5b+0Tmr/cFT2ieW9pcOct4dKNcHNd/DP2tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=p2p.industries; spf=pass smtp.mailfrom=p2p.industries; dkim=pass (2048-bit key) header.d=p2p.industries header.i=@p2p.industries header.b=Xagl5VsF; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=p2p.industries
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=p2p.industries
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48371119eacso25647695e9.2
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 08:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=p2p.industries; s=google; t=1772209675; x=1772814475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLOUNewpxFrSWUmNtLjrQOnmr3Uj3bvJ8Kyt6EDWtos=;
        b=Xagl5VsFQxbItkRnLRmXofUJp6a15z4/GMeQRcc5K2aSD7ZuvtoblLpbEE98e4OV3D
         YbPqf7gdGuo0N2uOcTtq/1zKcxumxG8w7BkctwTcDgGDgmYvaGtu1noNipPWVEAjfojt
         rORacTAWI3DrF7sGQ/zoAUmIj4WFl4re+6YTi7XXoCNqY9T2mCtD2y2zcASiJEkPRCuq
         hz4ZDJcAtOe5zU4Fs3VXb9HXcK3gYx49//8KhjkGeXNE6m5Cg92dYxYadPsjgpcR0iyS
         OqvA8KJxYMBZ1xl/39uAlABE1nXyIC5IIfKALtN2NJjMts3Pyu0Op2taMY+7SZPzhbzT
         v5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772209675; x=1772814475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aLOUNewpxFrSWUmNtLjrQOnmr3Uj3bvJ8Kyt6EDWtos=;
        b=iIbvEadbW7d50DiX0//ka++FyUrwDQ0hRODNOuwPWgk1jF2JbrcSo/plQjfLBmNq5y
         xi5lc/ejvUoG8b4D4AJKXeDoSiO3qI0k+JaKYJAww5ymmb4JuqvzOCDM4qRFbHUNW5km
         /7+AvZsgfoOC8R1MC/iQ1Q5LJ+me45YTfn4btctaPTBgVF9z4eLKWt6D6IBUvNBBsQSE
         u4x2xzO4+fojEfr3MI5hAeeeHTcw5swFvCMY0vzp2X3/+514HOlGZTyu5ZwEJatTIoUi
         CxByg3s0dsCu85KKhleV1vGDdtSXAKd62qSZIz1KiWRqoR+AUqDdmI4n430Jt/iRSdLB
         ZJHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTY6Oi4U7wNqAgpSLe7pNQgzXDSS/e3VeZmLs7o/g7HEIcj+SU0ein5L6EUS3HgHXqSLZgwszSNg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxmdyR+cginfCjFJw4QFBtJD56cVUpy5aFQnrmx6yyt+qfezUBE
	OYA5JtUtlUKNG3iVVu4FzEyYPkQuZYpX9UY6KUBdSoPUw0WmAXGSLADp3YE8qCwCBYAl7/sIbdZ
	TJrePkqadJqlM
X-Gm-Gg: ATEYQzxP0Az610s/ga0zDxDv92dsp9/hKiTgyAL47ERWD9tD0oNobw8pft20rX2di41
	t/Nu6yVszjjHa7ca4aE1U8rkeJ0G7WITAHURC/oN7kAzE4fiZl8YC/LG9/pjVI1cNRPxmfSQiQv
	fmTp82zbruk6mkKlVJ6Gq5yWtbKJux7SYipveE6tKa2u9xnOiPxaluGOql7pZAilTbfHaYCyqnJ
	N5KMPXFojkGiT02kPwT8EOXl7efwfm50Dwm958e1IhiduzJxnD7HjZR1eVdV3zf5Lme7CvyW5sF
	HNQI4on2Hh0Ef/KkYQTDjX9DceEjiQid7JRyiCSMiOmTIthw6sd9Uaa9FR/41UgMY9qRPWZemNZ
	YdafoPxPuRMGg1DeV1PqPVmzBHjk7et/dfpNiIKt2ril/8oIhp6Gohd/8M2yseZ/VLW+kkvP8Aa
	iEFaFStaV7wFnDnw==
X-Received: by 2002:a05:600c:350d:b0:483:a8e9:201b with SMTP id 5b1f17b1804b1-483c9b81265mr61099385e9.0.1772209674956;
        Fri, 27 Feb 2026 08:27:54 -0800 (PST)
Received: from nixos ([2a02:168:646f:0:b9df:9962:a75a:7bad])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfcd0b14sm62116515e9.27.2026.02.27.08.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 08:27:54 -0800 (PST)
From: Hannes Furmans <hannes@p2p.industries>
X-Google-Original-From: Hannes Furmans <hannes@stillwind.ai>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stefan Metzmacher <metze@samba.org>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hannes Furmans <hannes@stillwind.ai>
Subject: [PATCH v2] io_uring/net: don't check MSG_CTRUNC for IORING_OP_RECV
Date: Fri, 27 Feb 2026 17:27:30 +0100
Message-ID: <20260227162730.79355-1-hannes@stillwind.ai>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260226220310.758404-1-hannes@stillwind.ai>
References: <20260226220310.758404-1-hannes@stillwind.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[p2p.industries,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[p2p.industries:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12456-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[p2p.industries:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hannes@p2p.industries,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[p2p.industries:dkim,stillwind.ai:mid,stillwind.ai:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A79501BAD0A
X-Rspamd-Action: no action

IORING_OP_RECV sets up the msghdr with msg_control=NULL and
msg_controllen=0, as it has no cmsg support. Any socket layer that
calls put_cmsg() will find no buffer space and set MSG_CTRUNC in
msg_flags. This is expected — the caller didn't ask for control data.

However, io_recv checks:

    if ((flags & MSG_WAITALL) && (msg_flags & (MSG_TRUNC | MSG_CTRUNC)))
        req_set_fail(req);

This sets REQ_F_FAIL on a fully successful recv (ret >= min_ret) when
MSG_CTRUNC is set, which causes io_disarm_next() to cancel all linked
operations with -ECANCELED. The recv CQE shows the full requested byte
count, yet linked operations are cancelled.

This is triggered by kTLS, which calls put_cmsg(SOL_TLS,
TLS_GET_RECORD_TYPE) for every record in tls_record_content_type()
(tls_sw.c), but it affects any protocol that delivers cmsg data on
the kernel side.

The MSG_CTRUNC check was introduced by commit 0031275d119e ("io_uring:
call req_set_fail_links() on short send[msg]()/recv[msg]() with
MSG_WAITALL") whose commit message states "For IORING_OP_RECVMSG we
also check for the MSG_TRUNC and MSG_CTRUNC flags", but the code
applied the check to IORING_OP_RECV as well. MSG_CTRUNC is meaningful
for IORING_OP_RECVMSG where the user provides a cmsg buffer —
truncation there means lost metadata. It is meaningless for
IORING_OP_RECV which never provides a cmsg buffer.

Remove MSG_CTRUNC from the io_recv check. The io_recvmsg check is
left unchanged as MSG_CTRUNC is meaningful there.

Fixes: 0031275d119e ("io_uring: call req_set_fail_links() on short send[msg]()/recv[msg]() with MSG_WAITALL")
Cc: stable@vger.kernel.org
Signed-off-by: Hannes Furmans <hannes@stillwind.ai>
---
v2: v1 incorrectly guarded req_set_fail() for all done_io > 0 cases.
    Stefan Metzmacher correctly pointed out that short MSG_WAITALL
    reads should still sever the link chain.

    Root-caused via ftrace + msg_flags inspection on a real kTLS
    connection (TLS 1.3, AES-128-GCM, S3 download):

    ftrace shows io_uring_fail_link firing immediately after
    io_uring_complete with result=67108864 (full 64MB), from io-wq:

      iou-wrk-52242 io_uring_complete: req ..., result 67108864
      iou-wrk-52242 io_uring_fail_link: opcode RECV, link ...

    A debug recvmsg on the same kTLS socket shows:

      recvmsg: ret=67108864 msg_flags=0x88 (MSG_EOR | MSG_CTRUNC)

    MSG_CTRUNC is always set because kTLS calls put_cmsg() but
    IORING_OP_RECV provides no cmsg buffer.

 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8576c6cb2236..8baaf74e8f8d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1221,7 +1221,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
-	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
+	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & MSG_TRUNC)) {
 out_free:
 		req_set_fail(req);
 	}
-- 
2.53.0


