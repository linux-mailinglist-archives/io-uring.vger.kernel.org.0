Return-Path: <io-uring+bounces-1951-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B12368CB461
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 21:43:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E0A21F22CAA
	for <lists+io-uring@lfdr.de>; Tue, 21 May 2024 19:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46A1814885C;
	Tue, 21 May 2024 19:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Q/x459tT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BC614884F
	for <io-uring@vger.kernel.org>; Tue, 21 May 2024 19:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716320634; cv=none; b=KU/mCJ7mBHO+iHipnVTh5iJc7FxW5xbo1S24b4Vfx1HWcIChj7ieZ6M0D4Dly+m6CHUZ/xGmrFxNLNl+hJyl1SruXRuZGd2zsG87whd+SMirOeAcxfkjgTN9YcSuuAs+cr6WBGo33TXA1wYYEdcKAp5+2MtFRlOEfEpneQZ1jRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716320634; c=relaxed/simple;
	bh=gaIkoP5Tt9ptNy9eqUxDwFHSVRdtXZdNQxS3gSxXieM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=g/8jkVOwbG15NZZ75HTC/Dfc8RLdXo+ufUTtRf0leBrGhctRXfFOQcPJHuIp8HY9Wrch47B9oRjqZL6/m5CaK8aKCXZAQ7dCknHsT8yf8O7aMN+fNs+3QQ7EyZpc+3NjnHZ+NbtSEtGyK2eC5F75Apq4KjVZCYUl/lUQ5sCjIp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Q/x459tT; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7e1b8606bfdso19766539f.3
        for <io-uring@vger.kernel.org>; Tue, 21 May 2024 12:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716320631; x=1716925431; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4xIoHSMmGrzeSfhPivp04fPK+A8FmMUIxCHFcE1zPo=;
        b=Q/x459tTR9ak5EYWL/Ygb8HtLydtfqDpakjjofFDUwlF24E3mxFim/Nnw4x9AEj/vO
         Nw0e7YouxTiSj9kxnTdLpVz9LuTMJxvPohmoXfgI9ReSCIJ1I95Dn70CZ1CiQW8bsad1
         /7LdSpIPqGK1OCnLphDgXdqqyBn/URkVCoVovoxwhWgmDm4DwKMePqCdecoZ/M/o9zr5
         yEPrJag55yEmCVL6Rfezs07paFsHgHAiX55syf6xBBP2ghaH18+oB8oeeHfbCnHxunNc
         cTL4mATn49cvERCj4GYxEZWnSB/KVSJw2TQbs8VyyLJauzMx4Jk5S/lrhsMzDolCajWj
         /Tyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716320631; x=1716925431;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=T4xIoHSMmGrzeSfhPivp04fPK+A8FmMUIxCHFcE1zPo=;
        b=W1PQkCljf2qgJy1vEyfE6GT8FahYvbyD7b8TGqRMKaqyAI6lt9kofryakDyC3RKSSQ
         FZsB+Gx9RQEUu40SOMfUjZQegR+zKaojOx6wtx37pRW85eJG4oNto15sFFfJQSwyKuyN
         p61QuElnpiAFyaT2QpK3M3NctjaTKRzT+DhJ4+cK1Py69C+ZCqQiaCMgtkIycVWtaUWF
         evEF260Bry0bjSBbdVfuDaic9WhdvMo2p8c726hK/Bu1CkRs3pGoxkNEHWPQlMmyxzRw
         zZLB6bwYwQjFAJ6/O0m04m/74Qx1TvUSmx++KafWS0Mn2iVq7rbg/2gPYjLdH/wOoIVf
         637Q==
X-Gm-Message-State: AOJu0YyFIIKlIrtLfYpArCPZCQ5Jzozh7A3dzTYrVMDbjr9u4nAs/Wp7
	ixCpJUwEr1gVybpU68+EwAaRu/9iGdFdgduROcwRveqm10je+a40D0fqv3ilzfyy0QQWWxpTXCD
	P
X-Google-Smtp-Source: AGHT+IHIvD2vBkh0fv6wTvoSX5+gjdHhX2Vpo1oJeclj6etBfpIA8v5xmG1uQE1/CW5TRH1jaVRaqw==
X-Received: by 2002:a05:6e02:148d:b0:36d:cdc1:d76c with SMTP id e9e14a558f8ab-371f617e0c6mr462975ab.0.1716320630872;
        Tue, 21 May 2024 12:43:50 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-36cb9d3f219sm66602285ab.12.2024.05.21.12.43.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 May 2024 12:43:49 -0700 (PDT)
Message-ID: <45f46362-7dc2-4ab5-ab49-0f3cac1d58fb@kernel.dk>
Date: Tue, 21 May 2024 13:43:48 -0600
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
Subject: [PATCH v2] io_uring/sqpoll: ensure that normal task_work is also run
 timely
Cc: Christian Heusel <christian@heusel.eu>, Andrew Udvare <audvare@gmail.com>
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
Tested-by: Christian Heusel <christian@heusel.eu>
Tested-by: Andrew Udvare <audvare@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

V2: move the task_work_run() section so we're always guaranteed it
    runs after any task_work. Ran the previous test cases again, both
    the yarn based one and the liburing test case, and they still work
    as they should. Previously, if we had a retry condition due to being
    flooded with task_work, then we'd not run the kernel side task_work.

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 554c7212aa46..b3722e5275e7 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -238,11 +238,13 @@ static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
 	if (*retry_list) {
 		*retry_list = io_handle_tw_list(*retry_list, &count, max_entries);
 		if (count >= max_entries)
-			return count;
+			goto out;
 		max_entries -= count;
 	}
-
 	*retry_list = tctx_task_work_run(tctx, max_entries, &count);
+out:
+	if (task_work_pending(current))
+		task_work_run();
 	return count;
 }
 
-- 
Jens Axboe


