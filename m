Return-Path: <io-uring+bounces-9880-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB73BA10E7
	for <lists+io-uring@lfdr.de>; Thu, 25 Sep 2025 20:44:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C2DA4A0755
	for <lists+io-uring@lfdr.de>; Thu, 25 Sep 2025 18:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F4242E1747;
	Thu, 25 Sep 2025 18:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Iih3PNiV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE77A944
	for <io-uring@vger.kernel.org>; Thu, 25 Sep 2025 18:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758825865; cv=none; b=KFsPT3Z3spz7guoMKAQYyi7iJDZnsLuXPnaHKurHay3Oykilzt6bTen5W16xU/aJH4SRVvAeOur93EULIR4/0XjFzs+ZyWbOgeMlRCJujOEvXxaR/3QAjn5olw2EQFPjZxRkWradXdV1s81+7TicjFnZvwVsZY5NiRM9ztf/h3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758825865; c=relaxed/simple;
	bh=PWVCH0Yi5G47teHXIG11h0sQa0xsXz9Sv5C8sgFI6lw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qC8tBHWzLAOJByzlhPUh3Qjn3DkfbW/XRcTppwpBce607XmcW7gej5joWdD5ljPMgKCte9NR6Pw7TMTS+bLWMLvN9WQN425yN1BdIwcYTkR1iCNdL7uIGhwzOzDUxqHpHthMwlBGk3U7MvmaZCMKuUpAm9q/tMFmrCNo2u1Hn9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Iih3PNiV; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e37d10ed2so9653435e9.2
        for <io-uring@vger.kernel.org>; Thu, 25 Sep 2025 11:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758825860; x=1759430660; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jLd+Bga+49ggYsXSAeaxVZKI2YVufiChuU0V+tRV6T8=;
        b=Iih3PNiVdAqZQQ/mZwcvnSsm7NCnX5QVA42IxoP2oDLhGrIVbtdGgJU3yfFYOuN2Wy
         e6utfzgwNhICXUEbfoTrV67OnZTWOugbPt1rw0BrM8AUkT6I9+FRONfZirLA7tSxbUGW
         dcFl1b9GU2JVlrBM1v4bMvkNUYlGqQv8VxcjqLz9iyxF669BU0RSeqdor10utrDbhk2m
         vHf544/lgA3xdsx1ZFjRvRWFlkOikqkTDxllvYFj7TiNTWvyKbIfpgKt6BW1JQUisN/d
         IHNydlna2fPaUJXEF1EYkNGva7MaJyGt+qz7C+0g/VNWfk9o29UOouFJXY5w3yiDvAks
         W+LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758825860; x=1759430660;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jLd+Bga+49ggYsXSAeaxVZKI2YVufiChuU0V+tRV6T8=;
        b=lMrKHt++FVXLQnYr1oSZgMuGTLD1VV3p+xYUF22qTYOD2INtioqey2VGUeoVIwzx0V
         wM/IgUwvf/n+f4IBicmp0HC0/YXhnmOYbCpjaYztBHjhBJICBQ6lBqbhxhl6h3TDI5Kp
         hrkuRsZVgXLCe7gSdNs4S/T4OxQV04ds0q353QWUheiJEfBFLOebjdvrxWRsthl9IvpB
         /NZ69MseQ7FJ1qXeMWK7NN5Ljow/IeuZTcsFym1Wr+Zb9rs66X0CitQFxuXSECbo0TxF
         gOaYBSA+18P1AXYHxlKJ56K8mw1jodBxT0r+wDjfsHTeqNIOPF2vp46SW9/tIcb0LjXy
         gAOw==
X-Forwarded-Encrypted: i=1; AJvYcCWswvG052Dq9d7uXdflpZH9aLWQYCSumd4jTm/r29RaSJnJYEjkHeDQZwvLjbaSfiio9Z/4bnzvug==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJV6UPRPubTUfkitimT6hy5GvDuhO41Hgef5pkgfB2bI69p1iY
	j07LiLyCMTlqkOP2n3aoOz2fZ3+EV9lSJGGMwp1n4A+VXjpRbV+IPmRApuEfOznGj/A=
X-Gm-Gg: ASbGncvUKytCajXyTWUwe8vVJKaHP1oRY6/ebYtGtGf+/XqFaZyhf/BIRQzPJfWdpgb
	LYQlnpIeWVs0ykUOBOguZpPwEZLzjjU1lCR+l44ocYuZAGiG21iNwueRnCyL66149ig+iGo8U3I
	H4vFUx7D6tjWRxAwazFPq/M+GedXgbHc4rpEBEWaVy/c6wn3xec80eQ1W3p4liyCvLc6FegSekj
	Fc3kU4Fov3PBIwB5FEIXsHSyO1UnQcWezBCXQsILWsqMrlxx3yAtYf6ZMvioOba/K1ox1pW0hn+
	295yh4bn+iKfEX+nagYq23e5DxVH4Lup2ojQwKngUVQ3dFaxBwnZG/ZTC7+HraPqmP2Ipd4Du+w
	14Y3rzf9FLvfDbzDnO/OWzN4=
X-Google-Smtp-Source: AGHT+IFf4jBAXcn1gfHu1Hkx+eCm9FWnO4ujc1GRf4/n0Cpt++nXjuvgUguzsy0kD3vS6+tCMHJ4MQ==
X-Received: by 2002:a05:600c:1f8c:b0:46d:6939:a83 with SMTP id 5b1f17b1804b1-46e32a3cec3mr40456645e9.28.1758825859554;
        Thu, 25 Sep 2025 11:44:19 -0700 (PDT)
Received: from [10.10.156.189] ([213.174.118.18])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb9d26ef7sm4124353f8f.26.2025.09.25.11.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 11:44:18 -0700 (PDT)
Message-ID: <b11faaad-3142-4db9-b3e8-55b8785264b9@kernel.dk>
Date: Thu, 25 Sep 2025 12:44:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 ming.lei@redhat.com, Keith Busch <kbusch@kernel.org>
References: <20250924151210.619099-1-kbusch@meta.com>
 <20250924151210.619099-3-kbusch@meta.com>
 <f5493b8a-634c-4fba-8fa4-a83c98f501d3@kernel.dk>
 <CADUfDZpL2r2nhVDGZF07pDwNw-agxogo3hz2VDvJNvZK+h_Uug@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZpL2r2nhVDGZF07pDwNw-agxogo3hz2VDvJNvZK+h_Uug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/25/25 12:21 PM, Caleb Sander Mateos wrote:
>>> +int io_uring_cmd128_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>> +{
>>> +     if (!(req->ctx->flags & IORING_SETUP_SQE_MIXED))
>>> +             return -EINVAL;
>>> +     return io_uring_cmd_prep(req, sqe);
>>> +}
>>
>> Why isn't this just allowed for SQE128 as well? There should be no
>> reason to disallow explicitly 128b sqe commands in SQE128 mode, they
>> should work for any mode that supports 128b SQEs which is either
>> SQE_MIXED or SQE128?
> 
> Not to mention, the check in io_init_req() should already have
> rejected a 128-byte operation on a non-IORING_SETUP_SQE_MIXED
> io_ring_ctx.

Yes good point, it should all be caught there, no need for any per-op
checking (or the separate prep handler).

-- 
Jens Axboe

