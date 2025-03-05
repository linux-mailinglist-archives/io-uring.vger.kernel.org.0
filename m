Return-Path: <io-uring+bounces-6972-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A743A50D09
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 22:06:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6218F3A8967
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 21:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED8D1FBEBB;
	Wed,  5 Mar 2025 21:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ulV/YESH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6321D8DEE
	for <io-uring@vger.kernel.org>; Wed,  5 Mar 2025 21:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741208804; cv=none; b=jfSlweba5uwP1E+Z4LVduv4oChB66lW92+GUZWLObYt2+8jTsHNNba9kWAHCgEwQ+TTOE5pATl95Hpua+Z/Uq10/uONeQmYl1aOIoxS/g2UmEy2HglOoQUo6XfH6r5Rrce68RdpjCx0bpEF5sI9abwR4SLQ//z5qsbHrS+cP398=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741208804; c=relaxed/simple;
	bh=hFbTkhCtlhAULZiQSCtZEJ7KQM3TibGlNUTrorY6Uz8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=qrNQvAsuYB/MGlhfxUF02pS7gMPcnRVUJMbtrLiZRgXtIaQFw7rgW+wfmz7Uaafv2BheIY0rH/FAIOll4PYAeStWknI6sLz273n7wwZg/5YSCh5J9GSH0/WnS8rrrzw85aHaLLI5x2es6GrVO5Yzzpie47iOCSpNFpL/cdrKg1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ulV/YESH; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3cfc8772469so27141125ab.3
        for <io-uring@vger.kernel.org>; Wed, 05 Mar 2025 13:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741208797; x=1741813597; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dhc97OG8RDxw815Za9Acu0oKDweP1tXc0QdJUXYvxo0=;
        b=ulV/YESHBrsbRn7uMSWYQ6GwuC4128GEyTR8qCni95sNk5BSR6O2rG2kOLRiI/l8j3
         cNfHvMF0O+/r48Qeo33Q4lK/yj0X7UdDuJ2jI8ooWYyfFsUX8tbJYlp7RuiZZNs+59rl
         8HTUN7tsW1a4MSgH7feQ4Ju1RfuUT4UEZbVFmrheSyUt2p2egLuuCOnGgjrdElIx3K04
         G68FgxtRPb4RyKeozANTk6H9ouGxfA7gSiYGL0eeCYNU29c0wLEGh1AZe7HPm3cYgoWD
         jFyxLWbzqWQ8jeMw0/6Bmt0LH7Miuv7A0ox2k/cU91++vM4mbDJeJm4jAxSzvQuxRMgO
         2F4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741208797; x=1741813597;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dhc97OG8RDxw815Za9Acu0oKDweP1tXc0QdJUXYvxo0=;
        b=MAqa4XhMza4XJwxv7a2Fdul0By0LMWojj25VSyljPzdQjGzlMTBwuTFkaM/cGWQdOl
         2odD66woK6TK4KLrVHeeK8UCjWxdIh6QwDLAjYimImRU+XeiRQNIQKXb3eNRoYqrmZWl
         GjrUtQahwKpXwzmFP4pg4zr3w01/jqb+R5M4J6XtB2b168i9EJzczYOOrd9WbzV9dMnx
         dG354rfXquy3vAMkM8k82Fq5GFyryxglBhgZ/sGqnJcplqlBfDZfiClQhfiFk4mynnzX
         0oViRiDGh5TxQIfwauezw1zAC/zci/o7cSJ0V1TQfeJBg3O0LzA1PEcAzEVsNes8p41O
         bD8Q==
X-Gm-Message-State: AOJu0YyB2CSzWr3Zqt87u6xatRtjpLbWu4HJ3w9AeNU9leFo6gOegMvC
	d7bL16S1nwM0Y7GRBd8s2TSZzhJiyZUm7SSKQT6OIN75EBK/HdgaRgDm2SsAuLOkh4CmRmh1NWq
	m
X-Gm-Gg: ASbGncsEixodqMf3PgliQz2Cwtj5HEHwGzKf7q8BJT2mincQZDdFNucHnIlWlTa30Gi
	soLtFyVBq2nlOKDmYuaC735qMW75rfCxk5aOFtFCvaxAbmXNMonixNPcdyKo94jEPH0pXgD+Dk5
	UiJN2S0OS22LWKMqxAZNCLt08chfKxOKZyGxSkwiCol1okDJY8nPDIUIxytsaIVGF3EtTV7NGl0
	/lIOLRJpt0fSVIkdOjgZWMkER8t+bFY7sPIyZ3eXotWqEMDiJgG5Bo/abOtgYh/db3okXu90Esw
	ZKbG6W3meIfeGWz3c3WpeuA2pxqfNVlkfnQxzefK
X-Google-Smtp-Source: AGHT+IGFgKhX5DPv6mV9h6czuzZjSJWSl9K3NmB/u6mQ4+RCi9EnwWP0meX7Wdq1Fupf358k6qczAA==
X-Received: by 2002:a05:6e02:1ca5:b0:3d3:f27a:9104 with SMTP id e9e14a558f8ab-3d42b87d366mr60160825ab.3.1741208797269;
        Wed, 05 Mar 2025 13:06:37 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f200f942e1sm292550173.54.2025.03.05.13.06.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 13:06:36 -0800 (PST)
Message-ID: <92b0a330-4782-45e9-8de7-3b90a94208c2@kernel.dk>
Date: Wed, 5 Mar 2025 14:06:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: ensure reissue path is correctly handled for
 IOPOLL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The IOPOLL path posts CQEs when the io_kiocb is marked as completed,
so it cannot rely on the usual retry that non-IOPOLL requests do for
read/write requests.

If -EAGAIN is received and the request should be retried, go through
the normal completion path and let the normal flush logic catch it and
reissue it, like what is done for !IOPOLL reads or writes.

Fixes: d803d123948f ("io_uring/rw: handle -EAGAIN retry at IO completion time")
Reported-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/io-uring/2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 9edc6baebd01..e5528cebcd06 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -560,11 +560,10 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 	if (kiocb->ki_flags & IOCB_WRITE)
 		io_req_end_write(req);
 	if (unlikely(res != req->cqe.res)) {
-		if (res == -EAGAIN && io_rw_should_reissue(req)) {
+		if (res == -EAGAIN && io_rw_should_reissue(req))
 			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
-			return;
-		}
-		req->cqe.res = res;
+		else
+			req->cqe.res = res;
 	}
 
 	/* order with io_iopoll_complete() checking ->iopoll_completed */

-- 
Jens Axboe


