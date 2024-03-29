Return-Path: <io-uring+bounces-1340-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 634C38927C7
	for <lists+io-uring@lfdr.de>; Sat, 30 Mar 2024 00:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70F211C20FAA
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 23:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D791C13AA5D;
	Fri, 29 Mar 2024 23:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PIGW66Qt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344B764B
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 23:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711754657; cv=none; b=XukeMcwaBN2SCXujOE74bdX7dvCJSe3u/Y5CvVkZk26NqFPJHS564eWnjNTl6Ptl826T/XSiE43xWkF3BWPeH2trF/oIpTZssHDo1kFOugz+yKky7EkV0bwHQZqyFAd6pEiMDa8uYtGxxSEeJeyGSsBOcfekd1kPDc1S+GZ37vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711754657; c=relaxed/simple;
	bh=/Jd3g4Yo18wbStJqr2uP9mk0put0VhA6Qmw7eRd8Jm0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=tWsJpxCkpMuZijkC/YEjKFB+yktd65ZOnZF7G/ccKAeDwCjbmZiSHlQBIpbFyGKTBnm7tza07bnxPKTOb+2/D1o5CHn5lza6GbAY5EQ56Mlgep8ZyfUWDwZIp6MSgLRyvw0BFXYIC8BM2RI4cUTvMnB24oJdjdVFAoIlLmaQmGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PIGW66Qt; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2a050cf9adfso494331a91.1
        for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 16:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711754655; x=1712359455; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8EPUsnJ0MgUKWXZ9gIzGhGds7IMGGQ0Byk1I7cRXB0=;
        b=PIGW66Qt+cTjgjX5R8aXReEYddRl+4igB06isfbAz23o/vaIPIMSC+7PcoU/rqk7Jr
         gh/X+przGKengYyiuIOb+76Gvad9Fo4fsMlL34yUQEf/AyM7CxUdCwe0RGMpG1gQbcVB
         lJfkT0gYNiOZLGWREFaZ4QUnr+Eh3QPTFYNa7WaW1ZGShYdhjneIRLcAhrQuHO+1F9oV
         Pwz3Zi7rLvY+J2USjzA504VfCJm3qgmHPFmvdm5LHMJhYHAJWAeEeB4fRKcDqiRQUurH
         r7k2lninuFDOzB9UXNvWfbnbsDaS+Kzi5JycztTOqldopMtM3WS8+yzs2lf1xHIOAYWn
         dS1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711754655; x=1712359455;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P8EPUsnJ0MgUKWXZ9gIzGhGds7IMGGQ0Byk1I7cRXB0=;
        b=jwDg8XiRTWX44jWiXiGiHZn6VDzgvjGxV05khAuH8TP+PhtIxsUFseooEpFmLx7rgQ
         k7DmyzoTlfxVSEgbgtHCEw/1/EWwNEqPN9c04B/AV9sBNS4IOmSHto8NgNXFa6McEOuF
         AeJFSiPvfLwsj8sp3Knbm28JG18iuh/oB9akSBllti+b3UrBKvjlC559o6FWm22gYYRw
         zf606xWJ8NUOd1lYJlhOVfS/EI8YvthcNvYESPOS8maZyGDm+w7BLV5WvvPZwjys2gc0
         QVNANxaUMyQcIvvf9+W2XpJg3Bhatq0/fp/87iyiTFzdNJi/I1oPhQQpFj21KU7BxqVL
         BTqg==
X-Gm-Message-State: AOJu0YzECqjZXddWLWhn9E9/rMw9JZd2fq13qci0sHm5r5DwENyv7LjD
	aG8OfRPvGBEM6n84mO5AJJ3AKBilARtLYuz5998nH0ISOZW4L2SEeS3ZxR0Irq6hvWg0AH30gj6
	2
X-Google-Smtp-Source: AGHT+IG4DLlpOt6yZzGrgUFsYCgxE0/cIDU+KQ2hBZpv3h42dc4HBUHyvm41Ks2jWWB5DuyWmd5NnA==
X-Received: by 2002:a05:6a00:98b:b0:6ea:c6d1:c928 with SMTP id u11-20020a056a00098b00b006eac6d1c928mr4290524pfg.0.1711754654646;
        Fri, 29 Mar 2024 16:24:14 -0700 (PDT)
Received: from [10.46.44.174] ([156.39.10.100])
        by smtp.gmail.com with ESMTPSA id fd37-20020a056a002ea500b006eab6ac1f83sm3537607pfb.0.2024.03.29.16.24.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Mar 2024 16:24:14 -0700 (PDT)
Message-ID: <b64fea1e-b499-4667-9f71-501b779b03c5@kernel.dk>
Date: Fri, 29 Mar 2024 17:24:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/kbuf: remove dead define
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

We no longer use IO_BUFFER_LIST_BUF_PER_PAGE, kill it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 6fdb45603a1c..01e29d0bfc4a 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -17,8 +17,6 @@
 #include "kbuf.h"
 #include "memmap.h"
 
-#define IO_BUFFER_LIST_BUF_PER_PAGE (PAGE_SIZE / sizeof(struct io_uring_buf))
-
 /* BIDs are addressed by a 16-bit field in a CQE */
 #define MAX_BIDS_PER_BGID (1 << 16)
 
-- 
2.43.0

-- 
Jens Axboe


