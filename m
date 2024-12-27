Return-Path: <io-uring+bounces-5614-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 873459FD61B
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2024 17:53:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 310E43A281D
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2024 16:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB3A1F76B3;
	Fri, 27 Dec 2024 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GOZkGW2D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC4E1F754F
	for <io-uring@vger.kernel.org>; Fri, 27 Dec 2024 16:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735318428; cv=none; b=aR4CndsXY0Z4enuRkroAfBf9fZw8TXOBhCFQ4ZkzX7zduYpQGH1A67XkRkwBOelb43T8Dj/4hyDzWPNU7fVv3nX9dSIeBgwlP/o9To7WY503jK6nIqA+cvSoI2uNeHUkuRt1zWbSjqaQdcHlKoYiMv/3Q2cIccYAUs8xYTyyuHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735318428; c=relaxed/simple;
	bh=fZ9ETASbj8uPA4mJi9fTGt2zLzXoKQTAzJkK8OuLTwg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=bBWRagrXsWhB3kx4O777sGj1zemGT8xBYqjMAld1qLQFUIcLK8WjjgwDOo31S1uFMuAC4goazCVL6hZV0BHLn3lg6YsOawzTKG7XKwWhoupTAPzA6U66eN71dafdTCPNBuayN8B/oFflmSJ3cTu6xsnh2/M9N3CduEN4/38YgKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GOZkGW2D; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-216728b1836so79266415ad.0
        for <io-uring@vger.kernel.org>; Fri, 27 Dec 2024 08:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735318425; x=1735923225; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRhkGg4LTG38snHUsICHHsDYqTmxC7y8aJA3ttdttuM=;
        b=GOZkGW2DSw2dm4mTuu+GOeKqDH4V5Hk2tslgXIR9C6M/rV7U2bs2hRKBpNTgc5PRm6
         h4nB5xccuqrByP6lmSypqrMy5WA+ckYP1Yr9Vv9veRKPwFy3L7O+Bna+MdzU8EGAw86e
         LKneaeAz7/p8M6wOaU8nrANO8M1FOZ4I0YBOBQuzuHDRTQeDOb71kbvMAtLN5cw5lp8W
         vEXT0DHRIYD6WnJmmhK0ZZkyOooPCkdj7yLijo+YWOsVitylQrdCLIC+YSS+Z3HBOOqK
         GDTOvO0RYpw7PzkZLZTryKWQE6qq0zmQ+O4Ru+854vCQp1xKbwNAdRT72fZIwNwc54ap
         DoQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735318425; x=1735923225;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PRhkGg4LTG38snHUsICHHsDYqTmxC7y8aJA3ttdttuM=;
        b=fGAbjxXaE7jia8y8b+SyijOHs7rMtiPjyQ9sfEb2lCybTAi2lx6BS0Mbym1I2aDkh0
         Xhf2JITDC0kjGERnlv+A0kQvjEP4OEBDzQRY7STOiQ43PwmCtnLsJug8d2bw1UAYSosT
         ZW3I8B2lQ9h89UbMbIhfH1ozK3K50tNxEWL8MUBB57BFF6bliP63h/9BejHcBkhPZ87F
         k70YzG08HVUpvOtODIGwNxiQHTgwPe5sZW3SF8M/3YvELN/8Z3uimL6Vn5EbKjp111ow
         vpWfTNEgRMfQ6raaMl2C3dbRKzocUB9e30HwrZaRJ7aDBHnPoVsCNYdN75klHhHMexLz
         rgvQ==
X-Gm-Message-State: AOJu0YxZ2WskSo2atlPuNNvTWaoRhl18Vtw6i+9UGyqZ4X1dtf3xJ39s
	KcadFQO8Y+bwX1ySM7zBzXseFfjL8QzzNAJIRzm6ELzflhu+BGMxUM1bvqIZmb/L7iCT+q7Mm5U
	y
X-Gm-Gg: ASbGnctzSztOpU5/istp4ZNvwoX+yolltJol3h7F1y6gp99nMHxvo3LnnJlM8DbG5O7
	LhbSxx6YDQAIcUaZkZkDR60ZDQ/tIxj0nrxqjQl/FqvEykwe54AfMoMBLMfJ4rxj8Z9lRCf8ixw
	H1uVA6KKxWYr6vQH0jabc1WWD75mBMTNfDe1aGmJU+XN5ZIa5/J5c/vg4a/3H1ClDbDsZeYpqnn
	aVewIu+ycwXvWBQumj98p7+IgE7DQdHmNlZpQ9jrw7c1c+h9JTzJQ==
X-Google-Smtp-Source: AGHT+IEbzdTHlzgjmD+cY0T3j+US/OMlRggzToTaL1KCeaKEGOSuLqATE9LgL1g+pY5SzlpVKhdyQw==
X-Received: by 2002:a17:903:2346:b0:216:3eaf:3781 with SMTP id d9443c01a7336-219e6f2eb9amr411166055ad.43.1735318425086;
        Fri, 27 Dec 2024 08:53:45 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dca02b27sm136498805ad.276.2024.12.27.08.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Dec 2024 08:53:44 -0800 (PST)
Message-ID: <1e3d150c-8d0c-42b9-b479-0aa55f0ab86f@kernel.dk>
Date: Fri, 27 Dec 2024 09:53:43 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: always clear ->bytes_done on io_async_rw setup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit mistakenly moved the clearing of the in-progress byte
count into the section that's dependent on having a cached iovec or not,
but it should be cleared for any IO. If not, then extra bytes may be
added at IO completion time, causing potentially weird behavior like
over-reporting the amount of IO done.

Fixes: f628c7e5a7c0 ("io_uring/rw: Allocate async data through helper")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202412271132.a09c3500-lkp@intel.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 75f70935ccf4..ca1b19d3d142 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -228,8 +228,8 @@ static int io_rw_alloc_async(struct io_kiocb *req)
 		kasan_mempool_unpoison_object(rw->free_iovec,
 					      rw->free_iov_nr * sizeof(struct iovec));
 		req->flags |= REQ_F_NEED_CLEANUP;
-		rw->bytes_done = 0;
 	}
+	rw->bytes_done = 0;
 	return 0;
 }
 
-- 
Jens Axboe


