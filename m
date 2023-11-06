Return-Path: <io-uring+bounces-41-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 61AAA7E2E42
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 21:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0348FB20A10
	for <lists+io-uring@lfdr.de>; Mon,  6 Nov 2023 20:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CABD41799E;
	Mon,  6 Nov 2023 20:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EZkmiSuH"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D2FFBEC
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 20:35:52 +0000 (UTC)
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB63D71
	for <io-uring@vger.kernel.org>; Mon,  6 Nov 2023 12:35:49 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-7ac830e8b74so45322339f.1
        for <io-uring@vger.kernel.org>; Mon, 06 Nov 2023 12:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699302949; x=1699907749; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JDfPwDbqnisrRkeKB+yAZ0Agxv0I868hv8CXK90dJFw=;
        b=EZkmiSuHnVJyB7BC+ernqoRDwAWABMghOew8hQl1HOhsewJtpdtKrWkt5vmkS4ueKb
         yDUfC0H3dlT2Mmgq6ZAUD2nzCYlAjUsgBnVc03A39OXLPQZVZ4wKHN6NAldLpO0MYuHh
         oHC2PRMLtDu4dhRefHt+3i+Aeua0S/VIOl+UWLkChF4VPVwWhIuY1fDDpRfNlWlfCWfO
         hndJfexCd9f36gNEyBtpWwWJhKHlRbdUZx/+Cjf6zt8rBYLj6PVBHRJD9o/Ypy7hn9gT
         QNuyYj4hkvCd2dWa00KVfUBnGVA/AQhOwGdT1ZbQsE3LKcYBLGDFcudQystfh75x7RL6
         IuOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699302949; x=1699907749;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JDfPwDbqnisrRkeKB+yAZ0Agxv0I868hv8CXK90dJFw=;
        b=I3MEsx+s9VcJbbI8IgdBvPMnsZ/MqO1OzQlAxU6+dRMFQFBgV2hojx2cxjjN9ue5WZ
         JcrG8HQKu/bFxun3nVvr1TW+HOCprb/2uJKF9S/h5CIFocWfGniEbGiX547/3xy8LN0q
         iYGcr6XffXeOSf65Ykm8by5d1cEqSSYJ28y4SECnQFpTxVr3d3l63mf8ZaOtZOcJZIPC
         Syo64SdooOHiotYGanNYClq3yq2pgAJw3pE8YyihH887zOSqFr9AWHeJQBUPrhVqFH3l
         W6ZtYJOD4I9FKSIwe7eugn2HO0x475Gy0GmWOYU3g6qsynRmj5LUHeDEXcvA6ptBFp/g
         esWA==
X-Gm-Message-State: AOJu0YwR4fkegkSGZfnlP+k1+G13HZzPs+jGApyxaNru5V7aJ44a7UuT
	SrM0rwuBJR2pUWz4aZmxulKz3mTTWDq/dhaGY522lQ==
X-Google-Smtp-Source: AGHT+IEHhZDWQjq2NXdyd3MMiokKAISpu1K5RQP5isXeUNtYGiDOtLkY8WmCVDXk34nAHfsySpj9ug==
X-Received: by 2002:a05:6e02:1c89:b0:359:6a3f:6aa4 with SMTP id w9-20020a056e021c8900b003596a3f6aa4mr11205478ill.0.1699302949215;
        Mon, 06 Nov 2023 12:35:49 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e43-20020a02862e000000b0046400bb3462sm1475273jai.53.2023.11.06.12.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 12:35:48 -0800 (PST)
Message-ID: <680eb5d5-b0dd-4ece-8a32-56d987398c3c@kernel.dk>
Date: Mon, 6 Nov 2023 13:35:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] io_uring: mshot read fix for buffer size changes
Content-Language: en-US
To: Dylan Yudaken <dyudaken@gmail.com>, io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
References: <20231105223008.125563-1-dyudaken@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231105223008.125563-1-dyudaken@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/23 3:30 PM, Dylan Yudaken wrote:
> Hi,
> 
> This series fixes a bug (will send a liburing patch separately showing
> it) where the used buffer size is clamped to the minimum of all the
> previous buffers selected.

Oh, if you have time and once we get v2 in, maybe send a patch for
liburing as well to remove 'nbytes' from io_uring_prep_read_multishot()
as well?

-- 
Jens Axboe



