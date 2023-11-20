Return-Path: <io-uring+bounces-107-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E36B07F2026
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 23:22:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C2E7280C60
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 22:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3055538FB8;
	Mon, 20 Nov 2023 22:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="G89ZlMj5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2354CC7
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:22:17 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-28399608b7aso808396a91.0
        for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700518936; x=1701123736; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tIt8kp2cxeRa1t1PQOk657BADJKCe8uQ/Gkhda4b4go=;
        b=G89ZlMj5A8ZOz9nDz+ChIBSPW7Lpqxj/EDFXCRrkVYBb1l2YwQCGEOgrmvk2K78OSt
         3vC/KevgIythx191P9X+OHZDhzuKPzrMyKCgwVmTrjsuogXew4TN6hntkByL9qaWhkOA
         4obKSVmeSqgWs3LyW9yPFq26w7i1hP2fYs/yO5lLVj+AY05h91nCq9+2ZJ7jd83inewM
         3AXmDqwMfF3E6TBv/9Ql4AuanT+TQ9sssFA4YV38NFNIxPQ+T5cpcDy4C4NDv53hokPL
         AEaLzbo6KjXn40p+Jqk5hWoXp2PWjsW0VDIYzMaGdGvtYbJ8hONIXF8e3ZjZy8aTmJA+
         tUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700518936; x=1701123736;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tIt8kp2cxeRa1t1PQOk657BADJKCe8uQ/Gkhda4b4go=;
        b=f+eioORQYCvND/6xliBzdg52bepJOIgev12H6cYIDtqe5aDYNZCdjH0O41IIiVE6iv
         MY/cmqpdyZnVJUyDK1iJ4a0u+rznIQRRs1cEaeSgfCOiW8nIPfUbn5Qc/tBieES7urTy
         pRSyVXVQVMrMyT++Us24k111Oc2LuU5fOct9q0z0Rc77PUufXr8zYGEA0b+29vzSznuJ
         wr6EaAGcZkMjUXSY7/YQrM7SJysAqM+0dEgyzb3VD3a1UyDB/VUHi6wDVTkzwf6hIGDM
         SmkUVeLWBCNBr+/MtgXAPtvhymzVxcpVXV4fFzVQbxAKQdu2RFk1EOtheiW3jU02cCXj
         MTjw==
X-Gm-Message-State: AOJu0Yxlhi7yiAva4/O1AoxCAr8HogW8ZkgzGp6BZ2gM2GMFnylJMOnH
	m/37ubc/BHAikLsxiCIDw+54rw==
X-Google-Smtp-Source: AGHT+IHlgTFuRc3rHjZXuo9begWCuf07Mi0ZqD1OjI+940LwTdYqzVke2lvEOZ7zAfLFVZ7zK22+GQ==
X-Received: by 2002:a17:90b:198f:b0:283:2fc3:b8ad with SMTP id mv15-20020a17090b198f00b002832fc3b8admr8957314pjb.2.1700518936548;
        Mon, 20 Nov 2023 14:22:16 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a1a5e00b0026f4bb8b2casm7205994pjl.6.2023.11.20.14.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 14:22:15 -0800 (PST)
Message-ID: <47d93722-0845-43a9-ac15-923245e530b4@kernel.dk>
Date: Mon, 20 Nov 2023 15:22:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix off-by one bvec index
Content-Language: en-US
To: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 asml.silence@gmail.com
Cc: Keith Busch <kbusch@kernel.org>
References: <20231120221831.2646460-1-kbusch@meta.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231120221831.2646460-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/23 3:18 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> If the offset equals the bv_len of the first registered bvec, then the
> request does not include any of that first bvec. Skip it so that drivers
> don't have to deal with a zero length bvec, which was observed to break
> NVMe's PRP list creation.

Thanks Keith, that was fast (I sent in the report...). I applied this with
a fixes and stable tag.

-- 
Jens Axboe



