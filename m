Return-Path: <io-uring+bounces-12734-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SMlnHVe7uWnJMQIAu9opvQ
	(envelope-from <io-uring+bounces-12734-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 21:36:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 374782B252F
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 21:36:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AD91A30751A5
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 20:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D0737BE84;
	Tue, 17 Mar 2026 20:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WWbDOz47"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0600345753
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 20:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773779792; cv=none; b=NBlPXcvukm3h9GnYFR8f9tkunHt55C4y60Obi/D7DKxnFYqw6UxACsl5mAUjuWFsYfPqzSPBOHHCOzERjf24uygBdG/kSyQh2PKjdRTYzdh0kZFSFbguy8DiVg8oYY2G6cppggW1J3MKhouOz2D6XfIOc0VlyyrNPzjnxPrApxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773779792; c=relaxed/simple;
	bh=CRzCcXy73kiQFwk0lLQ8oN244HN38TeQ8oR9yqUp3g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUlEnUBvXVN/8AbEk+/H7UpBx8ZXSbV54Z39MmhtziKSWITT8Kz1FXB6YneZ+JJqEa3CB9+dC/MkVoGC6wOQd75LjRV9ujt7cOU6eGj6MZ+jCZmhEfOS7y33yjIJ5hsAbgInTu016sitX2QceRBQh//UfHyxtVURx8TcM37m4Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WWbDOz47; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-415b23dd6e5so2104315fac.3
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 13:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773779789; x=1774384589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1nOOzZsz8a/TPuoO5fhwA+cM3BCE6K7YOgKeGJ54UnY=;
        b=WWbDOz47gnhKa8Gbi6aP+C+BD1y6cJcCce6L+pl9Pxzk/umuErnec5XgEpd58oj+L0
         QGId/cRXGGUtSne13uFrjdfAMSfilJfJXjCDwxE0Q03mrhnrw4LuhTBm0q8XlMaIfT/+
         sPKaBENnE9Xx2u33nGGWfB+ycQ1vul5Y3vdsbeIPuDFC9rdjw3h11xLE2rlgYjvoVoQW
         yrKnOshaMGHfvyyhMDetdteAnZMjQu+JLHySw8Kewl816LeqbC0HJ7X/2r2LGEAuNinS
         U3BBtus4O1QNvqxrKQprgygsgKegK7nlwIrxgVg7fR0Ps2c1fejlfyx9rgyYqCSbT8st
         0Vhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773779789; x=1774384589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1nOOzZsz8a/TPuoO5fhwA+cM3BCE6K7YOgKeGJ54UnY=;
        b=Gm8Q9cgH7xGQZ1FrjRtHZzlZVNGeI7tslUnKdVRB4S3V0aEvqhjOT1jz+i9dvVuTac
         Mbr9LChqL2qhgsXPDbzWCvJopRimu8y1q/JkqTcg2ZRe/OthVPW/Re9lEzjdp/J5VNdB
         xoKhjYwXGMAxEDpxsLQzvXGauXeAGmP9RmwQ3m2y/mhCblZaUrUuP8wyloxBIsKUxI6q
         0pOmqdjdMQJwmCxa40CqmqbWF1YWRBGy63I6mENPAknc+P0rCJgdmdoqn1CbV7ghfAtR
         c0ENj+tQXYlSSTetzhW+fRZ4C6nTDrSBrflwbMAOld7riodb5aZhikZXnzeyxk8F3T3b
         nOmQ==
X-Gm-Message-State: AOJu0YwWEHLzvFVTYfkUqLQh9rXYC/OtAFSg9LF/0JazEz3Ffiu90vQz
	9HFtHb/p1R/IXMN0pDI6swUW0sje71V33GTSu5RcQU8sGFy41kNafnKOkeE1ZGBwKnYRibS3baA
	wgBgbzio=
X-Gm-Gg: ATEYQzwKAio/hqRIA+7y/36RaYrob4CXV6Uh6MssaAgvtTvCqZx2nBAydIxvfcmX+wF
	6UNaIfS9eE4nOnPQj2/UpSUQuXUlBDcdic+8qptPokEdr8jmijjhaUj4hOqCMuUmw/O0hMtfEku
	7Xwf75SGk532zpPHS2YnW5p++OkO2mSOsdDbwWyq1Ymi9hry+YCJhos3oVjU8jNLyq2kbIVIBjm
	axkt8a54UdmrdNpbQKdCKMggUI3JJHxfTgwp8NX0ECsprpIxbXNopkEjMzjvX0ul7cOba5OJ/hn
	YqnD9E05X10Awh4vyibem/l1KuOz60W5CzHzfhr6fFPhBuifR2O3FYzZ9uqes54wumJdVlPtoeO
	7/spPnWNSU9iaz1Pxj8Dvz1BmXJHC10bA42MiSXLvZWXyQAm6zQukY2CoGrYSDsnZ6r18KhB8if
	oVkVv7YTFAeSE4PS9mzqfu+5cfHXWYkMgVtnxrfXCHOgdGkJ3DrXnodlV54Tf3Bypgfgo=
X-Received: by 2002:a05:6870:ac1e:b0:414:e37a:9b80 with SMTP id 586e51a60fabf-41bd4233713mr554462fac.45.1773779789148;
        Tue, 17 Mar 2026 13:36:29 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd2cc1015sm670885fac.14.2026.03.17.13.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 13:36:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring/rw: use cached file rather than req->file
Date: Tue, 17 Mar 2026 14:35:17 -0600
Message-ID: <20260317203622.1007183-5-axboe@kernel.dk>
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
	TAGGED_FROM(0.00)[bounces-12734-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 374782B252F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

In io_rw_init_file(), req->file is cached in file, yet the former is
still being used when checking for O_DIRECT. As this is post setting
the kiocb flags, the compiler has to reload req->file. Just use the
locally cached file instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 3bdb9914e673..046f76a71b9c 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -900,7 +900,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 		 * We have a union of meta fields with wpq used for buffered-io
 		 * in io_async_rw, so fail it here.
 		 */
-		if (!(req->file->f_flags & O_DIRECT))
+		if (!(file->f_flags & O_DIRECT))
 			return -EOPNOTSUPP;
 		kiocb->ki_flags |= IOCB_HAS_METADATA;
 		kiocb->private = &io->meta;
-- 
2.53.0


