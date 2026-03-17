Return-Path: <io-uring+bounces-12732-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eK4xKlO7uWnJMQIAu9opvQ
	(envelope-from <io-uring+bounces-12732-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 21:36:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A3A2B251A
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 21:36:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 81D7A30603E8
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 20:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A97234028D;
	Tue, 17 Mar 2026 20:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="owCEnBJz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECBE345753
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 20:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773779790; cv=none; b=h2l7pIn2ZjPD0ZDnmDb51X3j88OIPbwF1bGrf+ikbVlEPmZwJg7lubw3EgyX+W9XGZ1gHBbxSZg2BJvC+N4pUjSsftxfnUJAlnR4w7ESHmASekmqgkY0QmjAMuHm3HpGwqxpo9pVRzVFSHi8gag9kB310V+SQdgXYYp4ErdJF60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773779790; c=relaxed/simple;
	bh=S8jq5QLQJ88lvRhKU+lwkTOk47Ih89L3Heo2ABqeFWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aO/k7hJHnoQKFr+OS1cgHABFqEq+cSiadlFOOuZ9D31HPCllTZqwCZrtea/rWdR8/BB/ETJkjyMBjlLLFipm1sj36AkRNZ9RnUPC6uuAvK+KjByh7cNBVE4bAt93xsDKlF9pSsZQTBi6aJA0x/nVTL/W+F/9RI2CbEo9bqKQnqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=owCEnBJz; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-4138136f02eso4220337fac.2
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 13:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773779787; x=1774384587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SfnxaOspt+hFbKqwzvscmpHLCMxiBsCdhab0HAb89Bo=;
        b=owCEnBJzxu/iZkr7Dzxp8MNYH9KHOcvQyzf7cPtP/GyFiLM0lo4uGycY1aJEXhMpB2
         YplNUI2gtCGatZA5aIqdzSS0FxPND2DJQNx8Qsu3sZKrjaGOknBhgzkibxp3W/+koQbF
         WEyk9ORJsdmSzY7eV18p0NtPUR3dTzIEXmUdvdVqtA6pOWNPQblc6mxJ0U/LemwVslwD
         dArd0YKLRY4a0e0tO/SYYyYrXnTWhsg2eUZEwjihkP7lS7TNmZeeLhCIb3GODD+baQSJ
         /sMaLQx0CvwSyExs/Q+A6Y41KeXKK59a+/XD/asPOMWsFPuLsv0jYNNfNBa4jr5ArLkA
         OwVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773779787; x=1774384587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SfnxaOspt+hFbKqwzvscmpHLCMxiBsCdhab0HAb89Bo=;
        b=CJg9Tr+67nWxVJDoLhk3T5oTP8H57oO5h0idGae4YOas0+YJI8Pn7SkLxV9k9ffqXT
         8jMB2AdtVDUrlaMDQ5IKmfKGmRyo3KvJ4Urv6RTCb4mc8EvGEB2Q9I9Zitrwnc+WJTLi
         jC7POrE26KNwLciRlpyOURV6qtQ8WohizjEegnHxws9iCQ8o5TFk3tf6tZMqVjVTgZmp
         +RocxWHF5V56+0/VLV4EVDbSvVZDU6omKbWHEHs8+7mmlM2W5gE7xeX08EPPc6ZSYDZM
         vljhn3gCurmtmMGEyC2MEMsmECSHQ9NWzJEFqW4GHHGdJU9XOdhHdU6IPWic9h1TXx2N
         cHkw==
X-Gm-Message-State: AOJu0YykyVr1TpftN1tK81BLlGYLLDWfGATaxmXHWgDxEIxvSoiNX29P
	nJ/xmvfy74M7FO4qEne6/AdZun+Zp3UEel4ZgF82sXsrRMq+bqKMtC2cvRzMP1SYoxt2trHkWY7
	jdCPWrLM=
X-Gm-Gg: ATEYQzylV3P6TJBiR6vbMEAeZOicV8vFWEH/rZbbh4AW1ewwkI54aRUgfwWWtWumGvR
	/HtzQ2Uh6oSzoxs+HZdfXIK9Qvr28o1EMYv5ThMiSltB/dKOkbNhI2VIgRPWfjhFkF2FzmTbLjF
	BFFk6UO0M6ZveKePP87gmRCXIeCnC3xBWIliMWWfEJzZIOEL6CzTBh0UVQ1HqerJ60/h82OlutC
	IFk+Ebfe4/AaIH2TuO3nThcRVRfsvdamm2T+HcmK3pkadPuV3glDkeozGk59+b592ZOiV19mjij
	y1kn7ube08E12jV2X8yW6Ynhcs3qHFrChdO3WyoAOvJ7um4iq1edCDPKOeKhMnwF+6fWGmprEYF
	CyslyjqN7vrFAZiAT2/XuHmvdRD7Ek+wblEGkxEif4ktLJnJNBO2X/gNQklYcEGLrhfcBs6dvnA
	feR56N45Oja53kPvQC/FWMZfpMya2N+b5IJmKWHATPlYl+LgzQWxKtqcWo4yVgmfYKDUk=
X-Received: by 2002:a05:6871:384e:b0:404:2fdc:1ac4 with SMTP id 586e51a60fabf-41bd3d35fc3mr626296fac.22.1773779786773;
        Tue, 17 Mar 2026 13:36:26 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd2cc1015sm670885fac.14.2026.03.17.13.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 13:36:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring/poll: cache req->apoll_events
Date: Tue, 17 Mar 2026 14:35:15 -0600
Message-ID: <20260317203622.1007183-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317203622.1007183-1-axboe@kernel.dk>
References: <20260317203622.1007183-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12732-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 23A3A2B251A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Avoid a potential reload of ->apoll_events post vfs_poll() by caching it
in a local variable.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index b671b84657d9..4175e63b9edf 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -276,8 +276,10 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 
 		/* the mask was stashed in __io_poll_execute */
 		if (!req->cqe.res) {
-			struct poll_table_struct pt = { ._key = req->apoll_events };
-			req->cqe.res = vfs_poll(req->file, &pt) & req->apoll_events;
+			__poll_t events = req->apoll_events;
+			struct poll_table_struct pt = { ._key = events };
+
+			req->cqe.res = vfs_poll(req->file, &pt) & events;
 			/*
 			 * We got woken with a mask, but someone else got to
 			 * it first. The above vfs_poll() doesn't add us back
@@ -286,7 +288,7 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 			 */
 			if (unlikely(!req->cqe.res)) {
 				/* Multishot armed need not reissue */
-				if (!(req->apoll_events & EPOLLONESHOT))
+				if (!(events & EPOLLONESHOT))
 					continue;
 				return IOU_POLL_REISSUE;
 			}
-- 
2.53.0


