Return-Path: <io-uring+bounces-2327-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8016915BD1
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 03:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B8E6B2145A
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 01:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D842101E6;
	Tue, 25 Jun 2024 01:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tvilNJw4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AE12F56
	for <io-uring@vger.kernel.org>; Tue, 25 Jun 2024 01:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719279939; cv=none; b=XyKJ4gJSJSS3hxkpaeT2oOTBUucInzHcbdhDwV4BxgXheZMuqB8eTKmbTU0ji+DZKB13/zdzLWHgbyANlICjBz2wdMTUqDkUGMzw+wgnQDFX0DpFK8qISRX4GpIewEcWknr4GpHrXYzCEA0fmUQg0WO6rqszJ9hjBB3Q0DKq2pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719279939; c=relaxed/simple;
	bh=lzPXp8khuTTK0zKj+/373KimC4vyrY26Gr3U3oMXczU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=FeaSuQ9236O84La/DNBTVjsBSb/N49NqckR9dZzU562bY8y3Ye/kj3/gIP1VpgK2D9kzsw5XlSdHGWAkrpgSgALliSTkbwxsv4B1DA2p3VPWbBxQjjd0RxRr/0ZqL8kQnOUzRK/JFIB8D3udFejnbN4RrjSetw8vhupV5Kth5TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tvilNJw4; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2c86869685aso354115a91.1
        for <io-uring@vger.kernel.org>; Mon, 24 Jun 2024 18:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719279934; x=1719884734; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zwTWm8iBeNeOC34Fk0goSFLF6UrIEyDyBkoINkj074A=;
        b=tvilNJw4sj8YEVTOzY8Hay3TkmWqKco4irQtCkjH3rVMwhnsNIzFU0CsHOhjOzIrA2
         dcdmqn31kqIAnOX0nTHJEhcGXG0i7t12u6KPLF0XdfZxqfZH+O5kg/15C4c52oeTB7FR
         hC4SMSP1STCvevJ89kRRDDWS7LCLb2AXY+LsHlriZvy+7IQrEYeBVwr8cV6dQzMiICfY
         qplEsXQ36nMCeDhoverkLpiwLZswHlWctdJhKQ1d0P96UMTo9WBZYiVUUhW2eXupRmKd
         f2xEgO5hdgneXYuEi+PI2rpd5rWC2E2pf2z8S5G+4TpJlSZ/n/iVt9g0Nf2HApV+xt+B
         lTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719279934; x=1719884734;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zwTWm8iBeNeOC34Fk0goSFLF6UrIEyDyBkoINkj074A=;
        b=QNrG8rKiWD8fG22SLpGth2DzP9M6M57Pg4b7QkBndBBZEAo52rphdDzh0geJeoedC/
         ua07nBcabjSJG1xVDdFbnxpqxI2BoueeF87rLdsoKSeu9FBTAlyMOICDZ4WKDl/X3PuV
         Fj5j683FcG1WcZM52rp3E9mas5Hj1qHEmehAnFQZmWAAVsGI0calTQCsTbNAWQiOI9EK
         n+syVGD6NPGQLpcoRTLdUOewA42gN9WdhtGRpdNbCf38RzAUW7mZv72HGPqGSJc4HNSU
         cPGiuo3a06tWmQwu1Q1EDR34zLDcFhw77q19Q9aL6Hfp/nbcS84OGkAa22KQmQ5ngEBG
         DgzA==
X-Gm-Message-State: AOJu0YwCGW8i9MsXZLNiiARxpPKqJRVhQLqu+bMCH7CsF0LB3FBLb9pr
	DgjcudI21vQRcSRH4E3MbzQ41fB/EvWf6y2xqrMY3BuDlH5CQG9Ozaap22ADXKoRt6dfqcDV5BQ
	f
X-Google-Smtp-Source: AGHT+IFAcX+/1Y9hI7uiRdJjSV1Jw+sPxoLxaRufPyEBJ4aK3YsEHykrbR/fZOtQKibsqQh0XJrRcg==
X-Received: by 2002:a17:903:1c7:b0:1f7:2576:7fbe with SMTP id d9443c01a7336-1fa09e8a5e7mr86485025ad.5.1719279934245;
        Mon, 24 Jun 2024 18:45:34 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa2921e21dsm35752355ad.94.2024.06.24.18.45.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 18:45:33 -0700 (PDT)
Message-ID: <caac8dc8-3794-461d-a7ec-de940b7110b9@kernel.dk>
Date: Mon, 24 Jun 2024 19:45:32 -0600
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
Subject: [PATCH] io_uring: signal SQPOLL task_work with TWA_SIGNAL_NO_IPI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Before SQPOLL was transitioned to managing its own task_work, the core
used TWA_SIGNAL_NO_IPI to ensure that task_work was processed. If not,
we can't be sure that all task_work is processed at SQPOLL thread exit
time.

Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7ed1e009aaec..4e2836c9b7bf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1209,8 +1209,8 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct io_sq_data *sqd = ctx->sq_data;
 
-		if (wq_has_sleeper(&sqd->wait))
-			wake_up(&sqd->wait);
+		if (sqd->thread)
+			__set_notify_signal(sqd->thread);
 		return;
 	}
 
-- 
Jens Axboe


