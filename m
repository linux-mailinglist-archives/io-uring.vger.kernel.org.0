Return-Path: <io-uring+bounces-14006-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id a4hpNLNqVmq95AAAu9opvQ
	(envelope-from <io-uring+bounces-14006-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 18:58:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B7617572AC
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 18:58:27 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KDs3Htvd;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14006-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-14006-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B59E930BE565
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 16:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02BA4DD6D1;
	Tue, 14 Jul 2026 16:57:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5304DD6DA
	for <io-uring@vger.kernel.org>; Tue, 14 Jul 2026 16:57:20 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784048241; cv=none; b=frZL5PQk2GW+jODXY6bwhJ+kLgf+4hd9fitygMu4KHVkjO8bw9z1CSAEGdSfCYkY7YH8QC05BzXj1yFRhv5PGUoyYf43GI2KDXAmfS1Q2wtqhMti4H9RbXZAsGqNsx0uuyE8KksM+5+iUnL8BkJZIw3sDd75FCGUmaVvJ7d9rRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784048241; c=relaxed/simple;
	bh=O1ebWhT9r1BV4x+pRqO2Ajo95W672XzqB7q4eFL/Rkw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pkBBPbK01zaBVbnxqUD0h7tgaA137abIcFq/M3TC5d7inwzqSbW0K1hUbLJCfPVvb3JbLY/CHxEMrVYZUJK8grxgd9mxcrkG+BT2WOKRu2riKLHRmwmV2ddoGiFiB/7AIjbkheP86AY0Ef6206sbMAyM7H6IMcw3Rk3FybeqN6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KDs3Htvd; arc=none smtp.client-ip=209.85.215.172
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca957432c7fso3123396a12.1
        for <io-uring@vger.kernel.org>; Tue, 14 Jul 2026 09:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784048240; x=1784653040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8gqLo5lz3vVUAC4/4Ogo9UQMER/Hwqu/vYGNyPCJOgQ=;
        b=KDs3HtvdqhMAZgYtJmYFPf61Om9fMl9nCc2SrFk1mJlRngJ4aemgdHQdfgjFgDaiaC
         IJOuU69lPMy/Em1EZEbTndscMhLwV+OLw3nzNf85a5RrooI7DfrGK4vbSALNWxsHRjoh
         hJSDWs9AqOiQJGz0jc5AWMXyOokI9T3F+ZO/04V1Rj6m6wnmBqH8AfvbBjYGTRkP+bRx
         btJ8rct/XoZiyGMihYV1006fSDTcwcom5g/I3FUuqthtvGiMDNVipp30Ug2EIL7r2tPX
         d8fJ1JYkksrWU7Jr+/MkFW2Ci9FQY+R2X43wESIm4bGh07HkrWiXkbPFFGdzKV1wsvFU
         a0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784048240; x=1784653040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8gqLo5lz3vVUAC4/4Ogo9UQMER/Hwqu/vYGNyPCJOgQ=;
        b=fUXIAHtTSCKEZwehvFMRZMco/7BeKKIx96LChz3IetGpD4AJo/xzHD5oY+kbFJ08Fj
         q5LmvRPVHDtchV+nuTFGEIeZhbSUDEEMcc5tTBf4G6SNGVoCqfN7xno78Hd+DyAY6pgi
         mKGDIWL8q3Fv6QntMSH82HBVbE+574uGDGp5zLiU+2XFuPUOTnWXVQjy1o5eJ6l6PT5i
         wx/Q9Z1ZTsI/+5Sr938wavRnvQJDOf23e9kZD8MDHNxLIeQ8U5bQeK+1VkuWGHnltgkD
         yKM9YWqaAy2/DION84eE3SOE+zqaWMeZRqAotVoIFhfofW2dBagh5o4CwgbhlK51D9Zl
         k+hQ==
X-Gm-Message-State: AOJu0YxAdLI0ht//ZdaxSlGx6NAOXCLGX7jp0+6XapBiNQwW03gELJK7
	hy15rQZqoIODVwlq7pk5sdMr9NxfT0JyPFjqTGTCEdiewC+3IVZBNPQRwbrKwFUBgXQ=
X-Gm-Gg: AfdE7ckqnUlrOxfArC3A/a6k0AjCTsdUs6sWmpi5v2Qk6q964GNNb7474u4xng0UJYq
	QgvYFy0xron2p9LAs7dYUjqggsHj+bGwFfuf96AwXfIirMHdccaTjWfpaxatE+n+qS+6MjI0FaO
	5gZI4ghQg9dMyRuqpoEYtkV8Wm3SxUHMK6BB6i1IEYbVe6S6tNpmgCQl0GYzbFHQ1rozaS0XCSV
	zQlJGE6J6JxULsA2Dfh6JYDzP2bXZTlgIOff2mykvdb++76XAO8DIVCoxgR/hM9hxtty+ANbKoj
	WsQkLsVgsGdmFrfA6RUSGWNvDDeXwvVDHMQH2GXtaB8pxsqrZpzzymUZXInj61QTysW95cbOxkN
	rkK2ES7yWt+Mnpqv+e41BSCPuvH591VyVirRjH98sbM76aXuL9AeGYDp0inJkw9qvNsQK33LSPS
	YxpSTPTvbkihl6nBlX4UX61IctAz7Yg3sIwLqAi9RsGHU6cAkBu25qGix7H+LV7t7DhNmjyRSWj
	l/i0G7OA64hZYuT5eHy/UKKpCDZED5b94VUG2vW4Z7AtBPo/s6UBKYWS8Y2PshQeFsFoesppn15
	v1e+tjF3mC4=
X-Received: by 2002:a05:6a20:a107:b0:3c0:9c19:658c with SMTP id adf61e73a8af0-3c3576b3036mr3971997637.70.1784048239672;
        Tue, 14 Jul 2026 09:57:19 -0700 (PDT)
Received: from prateek-Aspire-A515-57G.. ([182.77.77.253])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-311a6115e61sm67241222eec.22.2026.07.14.09.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 09:57:18 -0700 (PDT)
From: Prateek <kprateek283@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	krisman@suse.de,
	Prateek <kprateek283@gmail.com>
Subject: [PATCH v2 1/2] src/queue: don't swallow -ETIME when SQEs were submitted
Date: Tue, 14 Jul 2026 22:27:01 +0530
Message-ID: <20260714165702.237136-1-kprateek283@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,suse.de,gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-14006-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:krisman@suse.de,m:kprateek283@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.de:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 1B7617572AC

If _io_uring_get_cqe() submits SQEs and then times out waiting for
completions, it returns the submit count instead of -ETIME:

  1. The first enter submits the SQEs; because submit > 0 the kernel
     returns the submit count, not -ETIME, and it is stored in err.
  2. On the next iteration the has_ts shortcut wants to report -ETIME,
     but the 'if (!err)' guard sees the non-zero submit count and keeps
     it, so -ETIME is dropped.

That contradicts io_uring_submit_and_wait_timeout(3) and
io_uring_wait_cqes(3), which document -ETIME on timeout.

At these two sites (lines 113 and 118) err is only ever 0 or a positive
submit count. A negative error from __io_uring_peek_cqe() or a prior
enter breaks out of the loop before reaching here. So the change is
functionally equivalent to dropping the err condition entirely; we change
'!err' to 'err >= 0' so -ETIME is successfully synthesized whenever no
CQE was seen.

The guards were added in 2f61e849 ("src/queue: don't wait twice if
looping in _io_uring_get_cqe()") to carry the submit count across
iterations for the partial-completion case (got some CQEs, no error);
that case still returns the count because both sites remain guarded by
!cqe.

Signed-off-by: Prateek <kprateek283@gmail.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Prateek <kprateek283@gmail.com>
---
 src/queue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/queue.c b/src/queue.c
index fcd3c702..e2e5a061 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -110,12 +110,12 @@ static int _io_uring_get_cqe(struct io_uring *ring,
 			 * timeout, so treat any timeout the same as -ETIME here.
 			 */
 			if (data->get_flags & IORING_ENTER_EXT_ARG_REG) {
-				if (!cqe && !err)
+				if (!cqe && err >= 0)
 					err = -ETIME;
 			} else {
 				struct io_uring_getevents_arg *arg = data->arg;
 
-				if (!cqe && arg->ts && !err)
+				if (!cqe && arg->ts && err >= 0)
 					err = -ETIME;
 			}
 			break;
-- 
2.43.0


