Return-Path: <io-uring+bounces-333-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E75981A463
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 17:20:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BDDB28C49E
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 16:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289704B5B2;
	Wed, 20 Dec 2023 16:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SqRvzSuo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE9B48786
	for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 16:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-35fa65d857eso4569835ab.1
        for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 08:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703088811; x=1703693611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9vx/HFdJ2lGP0x5f/VDYThbANjquCkQv92UEoArWaHc=;
        b=SqRvzSuoeI+NjaMkrNDx9kVx7ivVtk6ruRl0KpNvGkzfFnfozZY62w+5k/kL504Mm0
         YWI1dmyAVy1jWto9ysfJz/jjRi3G3uHCjhChTr8hToRf9ECkwNK1zWIHVrER4a9Q0mpA
         nSO0aECH8zTLT6bl79TBVhsPF6oRON6VrCgc3nqA+FrzZ4kG39INoJ1Zov4kpy1mgm2L
         MqdyQSIcz9tsBcDCu7qKdNApgRw+7b+v1yDM+d1kYHOF1v1qiXpUeu96BOovLAkGzb8z
         fC3ZzxT5X1o7uRVagtpTq3GkVjoSKPm2eAGQ50e+iQm6vLCUGjVT7PEsC8lG7fsdLGfE
         Wq5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703088811; x=1703693611;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9vx/HFdJ2lGP0x5f/VDYThbANjquCkQv92UEoArWaHc=;
        b=re4lnfPdQ8D5kH/4UTLCNddCM06dar1maTlMDdH855HMcLipUIWgroEEkiAZQwb6Dr
         Sy21tRA02grhS286g+lc23MbNDBahIYSAksMU7q30VVlp4+w4xPZlfibD0tcv/iW1FKq
         hWTbjObsuqQrJ7dW89KO8kvtozVUGqT/F5/kgHyy7zfkuLS9hPmZiBFgRr7gyvFQ9fL9
         iVbXIfruYtocI3wCcUL43SaRt5HMQtAfLii0hakEOgiLwG49ht6oP7mgVtg56FnNlSDO
         1woH/Yj7QpLna3DpnN12+RCssUnzFNgy1/QLEHKr3T1rQWKQtHZUc9GA8oiPKFnFBFFH
         5OLw==
X-Gm-Message-State: AOJu0YzlCPazRs7+p2DulLcEOA0KhL/KYeD4epxymdC/gwLu60DqNErP
	sifie7q5BZnO8gcoDWcMByJVXw==
X-Google-Smtp-Source: AGHT+IEpgAg/HWnCmZqJjL8/DT/KxToKs2GVV1VyNx7BUzg35egsFGOwcKYViFaCHVJdtJ9H8atgHw==
X-Received: by 2002:a6b:7a03:0:b0:7ba:7ff6:1be6 with SMTP id h3-20020a6b7a03000000b007ba7ff61be6mr154498iom.2.1703088811642;
        Wed, 20 Dec 2023 08:13:31 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w26-20020a5ed61a000000b007ba783a27c3sm284931iom.11.2023.12.20.08.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 08:13:31 -0800 (PST)
Message-ID: <a40e1d72-98c9-43ec-ac0a-d8cc8d0d9af7@kernel.dk>
Date: Wed, 20 Dec 2023 09:13:30 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 08/20] io_uring: add mmap support for shared ifq
 ringbuffers
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-9-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231219210357.4029713-9-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/23 2:03 PM, David Wei wrote:
> From: David Wei <davidhwei@meta.com>
> 
> This patch adds mmap support for ifq rbuf rings. There are two rings and
> a struct io_rbuf_ring that contains the head and tail ptrs into each
> ring.
> 
> Just like the io_uring SQ/CQ rings, userspace issues a single mmap call
> using the io_uring fd w/ magic offset IORING_OFF_RBUF_RING. An opaque
> ptr is returned to userspace, which is then expected to use the offsets
> returned in the registration struct to get access to the head/tail and
> rings.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe



