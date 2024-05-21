Return-Path: <io-uring+bounces-1943-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 150918CB38A
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 20:34:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E88EB207D4
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 18:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D0A148302;
	Tue, 21 May 2024 18:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="c5ZkYgKb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC02B9A7
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 18:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716316475; cv=none; b=DwJA59QwkcbLS4Gk/ZGvZ3b4l/Iiq81NFTSjN2feC2ZtaqYHnGGrei00IVl42LbHWbT65j7a5WW6iLQxKw5vpImnnwwm32d9Hm9ZrV0A0PJ0EjfeyXwABz5m1IMdDVOk7IyEwpxgt6MWEuIw91eTylrbcu2tbYiHnn56IllG3Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716316475; c=relaxed/simple;
	bh=7uUZBLeHMVbaBU3Obz5LZB0v8dXN6WL3RvsPXD8Gvps=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=BI1GTjjEG0cqUaO+FdYYLhET7XHEyBhy8qxHZhxhCaSFyiFETcBijTUzYs1+S+hnqu4HZibZa8cllSrILGMZ5qGPG0jwCsPBxOqFiJogp+8Y7IeygZkn3WdID5tu6V1yCL9GceDxArQkK/Em0czpoXIPrrWLlSlbpV1CqRH6SLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=c5ZkYgKb; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7e22af6fed5so20092439f.2
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 11:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716316472; x=1716921272; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQIQExZlCgeghbc2jesJlYX5dNwmE9hHk6kFjojgv8A=;
        b=c5ZkYgKbVWvtKKCZSb1jB+atxDZizH/Cp1E+/5y4EXpx/WO0nH1LnhWWvsAgOpP9IO
         r2RnKoX+HAqehMsemRM7ISmJI+BkjskVgSFkRySiY9XGjugpBSrMGTRGFGNdABsDbqUf
         QJ+39Pwca5nBru8UoC+nnaive40HVMouDQHyEq1nOnAGgUrmG4PMLEq4NSmr0n2Id7Tc
         hzdf827BwbHhs3XdOI27nmqoeGqnkeL841n14E6gqWXFiCVoKOyqZeXawf7D0+T7raCe
         nqmVu+eCToRJxXD7mvS1BCJl1JjJtzOUiopf/rQRghZqenoKFhLhnDT9ZefhldW5fFjg
         Oyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716316472; x=1716921272;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FQIQExZlCgeghbc2jesJlYX5dNwmE9hHk6kFjojgv8A=;
        b=Z8PXS4Yek5x/nqDb/y6GWSAqLU7SYIPaVw1KrFy74WrkVgW4Sc7mkUsRmgrFrs8+o3
         p6WLFU3LDhOs67l/7b5Pn2c1AyrWQuagtklfOD51Z0UmEtauzJrTU9xooaQtVUod8LHC
         pIw3KZ0+Bbfv4YqsKpyR94B06XGzU7BjS2Iu5TQkKICsxeieskeQ5Xbd8LVsZ1pWaBl0
         pDHKoGzH1bmTe6pbULdsW/9GfcNsMok0vFY1b9+ZPWsNbemw1wVXRrbf6HuqpjubWk96
         VT7/CEZ0ynHNWc0WOx1yA0Pc8Apy7jMnzEngMPbIpHb+mWeU4IxDTi8QnsW6slZqQFZV
         6PkQ==
X-Gm-Message-State: AOJu0YzuQT4FdmJDxxrtNf607/CQ8pWwnHwWmcmBVN5zOBGiWl0A9gbU
	lrAiuTIpn8ak50wvXTMgQcUrlhxarjb57R6oZg8ckTHBH4mu1n7BBGJpITnUJtPFwUB63IW8vtj
	+
X-Google-Smtp-Source: AGHT+IHShWDz2IEYFo9EwUv/jYOGFPtj/RMPmn2E87ZoQxu2N6+BHB/noinEJe8xkK6XrE4vCIEhdg==
X-Received: by 2002:a6b:5007:0:b0:7de:b4dc:9b8f with SMTP id ca18e2360f4ac-7e1b5238e16mr3482999939f.2.1716316471737;
        Tue, 21 May 2024 11:34:31 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e1cc43e540sm583287539f.30.2024.05.21.11.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 11:34:30 -0700 (PDT)
Message-ID: <40c7404a-f4ce-4a7d-86f3-313a9e9ee113@kernel.dk>
Date: Tue, 21 May 2024 12:34:29 -0600
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
Subject: [PATCH] io_uring/sqpoll: ensure that normal task_work is also run
 timely
Cc: Andrew Udvare <audvare@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

With the move to private task_work, SQPOLL neglected to also run the
normal task_work, if any is pending. This will eventually get run, but
we should run it with the private task_work to ensure that things like
a final fput() is processed in a timely fashion.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/313824bc-799d-414f-96b7-e6de57c7e21d@gmail.com/
Reported-by: Andrew Udvare <audvare@gmail.com>
Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 554c7212aa46..68a3e3290411 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -241,6 +241,8 @@ static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
 			return count;
 		max_entries -= count;
 	}
+	if (task_work_pending(current))
+		task_work_run();
 
 	*retry_list = tctx_task_work_run(tctx, max_entries, &count);
 	return count;

-- 
Jens Axboe


