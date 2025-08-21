Return-Path: <io-uring+bounces-9141-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CA6BB2EB1F
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B63C6A24B82
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68FB9194124;
	Thu, 21 Aug 2025 02:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cvn7+cNV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A572D8798
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742122; cv=none; b=qMQH4LIRlTDnFgHlKWYnaOU28y5m+iqeOWnAF3T0H44gZb3V1yeOcOwI+3Dgwws41pMVLcJdreFuoVyOXSjbMiaPHVudaXOdc5QbcRz3zeS8mqME8G/IwRT3nup84R6rWpesF87fzcm9y2xUrorFzMT5ZR9Q6ulURUvo4C0CPsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742122; c=relaxed/simple;
	bh=TbrpY4QiYWQ5eo8CsETW6cpjVu+y1SlW0ykcDT67TDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCh9JypYVrcnXGSD+KFWUw/dHxCEySysKh79Dj3nB6MW3RNQaWLZ5qoMO4PUufvfvZYhlcpmSd0WxCCRK5pehFNCO9CUvDOCuPfgDY713+RA+2hbqCiCBtZ01GzIdB542VibayqEC2ydnQfoWKWLMC1inPqzJn6AA+Ze/huPsjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cvn7+cNV; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so524452b3a.1
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742119; x=1756346919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+kL2e/60MQq5UDnoUv4SQ7L1Sjh+ZKMAfSbYzjAwco=;
        b=cvn7+cNVdruLDGrhkdOK3maryhHnVn1W3OoTDTHU2KJx8r9mbZnFqcPqbXcy1gWBSb
         dZWC3YQtqsFShZS+UWl43f/Q7V6ERjkqGxVspoX8UFxZ4+/fCXSxusTgVZHTDVL2Nwfk
         RbTdLyXjlekGHowxEeou+9Fn4/oVK/RwWdadodaipCR7wn6YeXC87RT0mtoK2w1oIfyG
         KMNj/sz+jUVd0xlCk48YIFOsoMc8HMMijbfqgM4kQXTE0T5O7MwgxsBCUdzcQ56KOOwR
         Mggzo7rgApiBrjn11rQPBvxI8nygWTqEUeSLAu1N9sWkn8exqOdLJxLhH8JnekwouRw5
         bxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742119; x=1756346919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0+kL2e/60MQq5UDnoUv4SQ7L1Sjh+ZKMAfSbYzjAwco=;
        b=jEhqjrxnmCLWw6hy6JS7p3aUzlBBcaaEsrin5qSPYFKc+bb54kzFCon/1GYQ6gg1Cy
         3LsJnbgJcscJsxuIO1V9+3fZ70MPMuYd5V5qLkRnHopEF6TeOmn1AVn2UxHTr+XyxKvI
         e79JehTa7N+ITgphdn//LRNdU7MscKTYc5MSHbvK8Okb9tnBkanxrfUuarymuwliOhbl
         zW8BVUw13ubn23N6n8UQqVjXPbQADjqLwmd5TmtVzkW9yTulChINeL+xmAfc+h04Qmlc
         9xozAa5eDG73dP9if+7R09a2B/0hT+H9yzGtDTq/4qEE1WtIujIQTJDAhsWq6DYQYUbI
         TDOQ==
X-Gm-Message-State: AOJu0Yx3FZQ5f5drqIh61xw7vFl5E3CeVIqD/iwTpGOgCLqNnTd52XSj
	NQckknEPCc5vNO+lthOOFxKQunEOk5WpXBt0Is4Ogo9S1d7TvlmIdID+SMjhVEGSdOZyZh0qUx0
	BCTeF
X-Gm-Gg: ASbGnctUigKiPw0binira77n8bfdCEkddFqnq6/1mIGGBhyYwQixHeQMdCcE8bCgUTX
	xP2uBoqnOzu2shE1P9K7nLfMoZMAfxr/Ro45/wfAfis3ldEYUES1MytjRgHRYUNct5g3iitUBLY
	HETh/2AMnOXsfqInIeLx+lLoQddhPBKVpS+uIYo4xNXm49I0IAKbBOhzPRlWg7Que5pWxNfDp7g
	YWFfl+y41AjuxfX2P4QvMjyIj51TVvm1x0LPDnGaXDztw1QBtrtlHqWI3OUvjQMO6Pk4NX+vAt+
	W2aTJ9FyaoHN055eIkQpUxIDslFlwOLqoKxRWTDFHgtQ542k87ykkedi8JtEw5Wbq24k3giS+mG
	f5d5LO68=
X-Google-Smtp-Source: AGHT+IETsKw43BTBgvm79GDzzgbI1nqspUe9CFvC/xWoGQ4blL+tl2OD2NC04EWjrzS/xBq5QIHRcA==
X-Received: by 2002:a05:6a20:a11c:b0:220:1843:3b7b with SMTP id adf61e73a8af0-243306582dfmr878897637.4.1755742118693;
        Wed, 20 Aug 2025 19:08:38 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:37 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/12] io_uring/rw: recycle buffers manually for non-mshot reads
Date: Wed, 20 Aug 2025 20:03:35 -0600
Message-ID: <20250821020750.598432-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821020750.598432-2-axboe@kernel.dk>
References: <20250821020750.598432-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mshot side of reads already does this, but the regular read path
does not. This leads to needing recycling checks sprinkled in various
spots in the "go async" path, like arming poll. In preparation for
getting rid of those, ensure that read recycles appropriately.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index ef94cdde5f1f..2b106f644383 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1026,6 +1026,8 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret >= 0)
 		return kiocb_done(req, ret, issue_flags);
 
+	if (req->flags & REQ_F_BUFFERS_COMMIT)
+		io_kbuf_recycle(req, req->buf_list, issue_flags);
 	return ret;
 }
 
-- 
2.50.1


