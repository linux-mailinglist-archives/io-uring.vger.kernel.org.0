Return-Path: <io-uring+bounces-13160-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kCGqK2TW8GkSZQEAu9opvQ
	(envelope-from <io-uring+bounces-13160-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 17:46:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E529E48829C
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 17:46:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1A4C4305615B
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 15:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A476C3BED06;
	Tue, 28 Apr 2026 15:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="CeHBvkP/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E810A2E5B2D
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 15:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391163; cv=none; b=kKmWf+7x1BbNAC/Fr/UHehmRzxtR5z5QuTtLmRhGwCYTlmjRG5sRndN9a7r78cXj8honxNA0tsytWTCp7p6sXHSdlx+cVOVbu5+769171pvO46Jt8zyimLYeCgT9sOGc0ag+UE2D7YC2AKKcj0RwJWQMCTlyVraR18tLbb4erK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391163; c=relaxed/simple;
	bh=PGPhm1VJfg+elZ+P9QXQcyecJzoY6IHad9/5+feOmfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CO/wl21eg5VTGUJtA9meckp7LV2KjG3i3KBZRH53HyhIP3lvMtS20ptH1DZvJk0MBPNw+ZE8m7kZZcGmtsclDQQ4yaewBrLtL6Dt/ZnNecBkrNjizUR0DEKQZr8EL7f/Lx2+yeaUgwK7S+zvXiKURzspMT60h8juZMr32t6XGhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=CeHBvkP/; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-415c8a4d2e6so4585619fac.0
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 08:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777391160; x=1777995960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m81PZcWO7oosqV8q2OImk1j0BB0y8AMfpxU8IsZ+YYc=;
        b=CeHBvkP/0vzdujVMgcJKgOnU6LW18ZWaLnhr9QiJiyBII6xhxHd6bBasLj6KvJ0+LB
         MRi4IWx/9uU1QNGtcQJ9pw+2V0BziYCdoZy7SnaUQSQCMbjOBx2Z58bamuDi7o6nQUhm
         PwnxwF1e+XXyj/dwVv+eJ+rkYMH8p7i+UuSTXkScMhr6bCF3Dpj7ZfPLoDRlbetPqyhF
         5JORrWfoedagve4RVZjcHAC0QdFvR22VsFrDKc0fNV1CRjFXqaWV2ESa+E5ikVFBS0rN
         MAnhXUNbDfzBW8RhkbH6fgxGaUNx/RSjcR0XvrRPyjL+Lur7IUZpjqIj87iEOybYhlRM
         SPBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391160; x=1777995960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m81PZcWO7oosqV8q2OImk1j0BB0y8AMfpxU8IsZ+YYc=;
        b=BMM4jSM+r225+6U5C1LSVwAaNZ9jIb097ezvq3W9id6AySqVJ8vhJuvGPOIl9N+wUv
         XtKoYCIm5nlJtcFmU6HuOXlFwI57wVa7z6Pay/4+BbElDGeXIZ6rGxPBX+/48cjOC2fc
         H7neHjMT1kJNMZdPIxsKnomQeH86A2XkWoXNoyI9juXX6QuENCJ+8Za2g0QnkeZ8XPD5
         v/CB+FX8JmLmT4Kul/AzoqcEXykTJOVXKFTIZiInz60NX2q+0kpU+aEftNCOz3N05bco
         Rv4Twgj4GbHRj0q7yzcrCvaXPH/PIKLpZ1gY4Rl6LY0GGk2irDS2jb1uVa1020G8Ffzu
         5RNQ==
X-Gm-Message-State: AOJu0YyLVG2bOWKPoUH1dEeBaW+U4Q2qbcRIvOcjVLSyHP/K+cWQd26z
	TSMeWD3LP2PIoqthMBuupWdSOCUOebF0qxHm4qpLrIKOGuPfzf8ORFuWP4agQzVzNct/5p0bQ1a
	Lv+zypSU=
X-Gm-Gg: AeBDietKmwBQRTry9DExh1n22xElgt1ZzMLQmnTaV2a/gttFnbltpoXgNCixVgAgsKF
	8TIWWweMz/sbFrs2T4b8O+QE1sKybUvlDIQ8ySQ8VzijLZPuI1iGBb01O3ePIDLV/8shDSnaM6i
	FeMJYcmeBJ/r44HTyhjCb64TJcMk+nvnVP4yjyD/3jJVl3SSj/unWTabDykYms/6FfJb/QrP8n7
	QrKOgw+JpkxPCsHTXmubmNbhBOad+0AZ97Rk6Ti4DwBZDn1RRYHbuvqwM6E5jH3hoSPdOz4BnhY
	gkU/fWT1csk3kNS8oF7n4lJJISrrm49PGOM111Lbjrz3AfQVUWops30pwypGjjp2yxG6XBuRXj2
	k5U/yZxMI03uHtgmUZwWl1qHSMsaMu5OVXMZ8/OxEXrgcfCh71vWNs6+o7QHgjhQLy0d+evuxc1
	pwLSgXI0DC/rCyt3B+DYHDDTItGsC84YHZzYnZYF484gJWAfaQxgYyM+2tv2Qk1ha6Nta4RLnsr
	MWRLFzwJsRsmR+M
X-Received: by 2002:a05:6870:1782:b0:42c:2c15:375f with SMTP id 586e51a60fabf-433f38a4519mr1916535fac.2.1777391160459;
        Tue, 28 Apr 2026 08:46:00 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-433effdc79bsm2109567fac.18.2026.04.28.08.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:45:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/kbuf: kill dead struct io_buffer_list 'nr_entries' member
Date: Tue, 28 Apr 2026 09:44:49 -0600
Message-ID: <20260428154557.2150818-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428154557.2150818-1-axboe@kernel.dk>
References: <20260428154557.2150818-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E529E48829C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13160-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,kernel.dk:email]

This is only ever assigned, never used. The only used part is the
calculated mask, which is used for indexing. Kill 'nr_entries'.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 1 -
 io_uring/kbuf.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8da2ff798170..43e4f8615fe8 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -680,7 +680,6 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	}
 #endif
 
-	bl->nr_entries = reg.ring_entries;
 	bl->mask = reg.ring_entries - 1;
 	bl->flags |= IOBL_BUF_RING;
 	bl->buf_ring = br;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index bf15e26520d3..abf7052b556e 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -27,7 +27,6 @@ struct io_buffer_list {
 	__u16 bgid;
 
 	/* below is for ring provided buffers */
-	__u16 nr_entries;
 	__u16 head;
 	__u16 mask;
 
-- 
2.53.0


