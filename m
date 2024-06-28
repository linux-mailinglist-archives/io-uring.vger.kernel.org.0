Return-Path: <io-uring+bounces-2383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA2C91C482
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 19:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08C0F1C227AF
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 17:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8D31C9ECF;
	Fri, 28 Jun 2024 17:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vTqxiFPN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2801DDCE
	for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594556; cv=none; b=L1BhldZR32dUeOVEok5fmBU7w1W7hRwzekzIvtdCABaeVR/x6qgnrXaY+31pYL9iNkLloRosLNeT7uQFTpS4oEmXFRZX6yTD2DNN1v0cfoRVvglJuXxO1r5Co480rzSQT3KYEBSeV34440Kpo62l8KSB7pDwvR9pUnQhZNF3WHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594556; c=relaxed/simple;
	bh=jIaONTjps6miPll4PQVUCzr4NACzEvdJoQIdXLv5i6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C69AIsHgWjaPtsNOOJWpkqgrkcRkLaFS9hHKTl3ppOPEoZSYDf1zVtnfA0bNEbkX7t0kyUNX7ge2QpiZqY3FDaDxbNMnZlYZp6LIEYrr6JYly/kAKG0pRJp0E+RpD0O+oczyfZX6jfH5/u+QnhA+QA1oABId0+i0Pwj/mcZo8JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vTqxiFPN; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-25075f3f472so75787fac.2
        for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 10:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719594552; x=1720199352; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=31LE6HFOYQljdlfLoaQEH2FoBjrI6f8xv1wuu5virW8=;
        b=vTqxiFPNFllcDBwWI9uV25W9K0YH1XMGz3vhKNsDERabkfGJfyE+gjMzHfwoldt4ei
         W2PSIB/6qBef3umd7K6YdhSo0EeQ03Z2rJnOkNiqg785Q1Y2dRxe21sE/nS/+9fMwl0r
         wPIHqprj8MFFE0LpMKz3ngZ0MdIwfYi3+gqfyBkhAVOBvoRLUwHqAwu26Qd2xeyyXPGN
         99wyReMlH+LZWtOxzj2aj6J8amxavWQTKBqQ5yxXzu1X+EUuiBFFBCJEMz5ez+gtO6/n
         P7TPOU0pzFeFMZ6KrinAsVvO/hfhLSZTEACUL3p+nMdn/E6mAl9u/Z23WLfN/BxZtUek
         160A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594552; x=1720199352;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=31LE6HFOYQljdlfLoaQEH2FoBjrI6f8xv1wuu5virW8=;
        b=ZSriY6rFa4byPwRFAOaQv8AWAmyM68Fe2ca7w5B3mMDCJ6BS6Cw/iHRfGLKUr7kDbx
         nVmuOtIp/pMWS36tjZ8UOytaqGiKxo+Dyssd7Mf3VO9tgENQaFLRd8J7wnUjtp1roBfG
         LeMcCpIIpVsHF2CjCZQ9KheahjgG2MKoTdfhgvA/4D5rk7GJXj1enz5rm5MedxqxWn/J
         x8ogJyVD1PsXbe0uSQcFb98dnOWDk3vzn+Y+MTuK2LqvTUVMu9XFg59nc4xvUnc5ks4/
         2EbGUi5mYTy9cQHC99/wz7F3fUNU26josZ+g2z0pF3SZKX4lMUa/gQZO2IAisSDGjYsA
         z4pA==
X-Forwarded-Encrypted: i=1; AJvYcCXL8+9gaeHbhdgFmb0ntq6IAlkRI/cnrXPma3AfSBh3lqv1YEruwJyz12G/NgkMWs9OYX/QdXjs4wETMsVydw+YvE81F9a1VYo=
X-Gm-Message-State: AOJu0YwYyitLPxyO00vqecLcCuUApePjO9jksLH2xz9DIlFoVohI83Y8
	ZGAs/j99tKtLaqE9flW7fSuk6/x03IUFdB+m34IJH6pYO3Exs5EuZBwboL0/S2g=
X-Google-Smtp-Source: AGHT+IFtOkPV5QySi2C3Lm+zza2+wpnpbYXp3hFp9W4E1cRPw1hjSl2kL8GPJ2VHtFLXGjPLbRhVGA==
X-Received: by 2002:a05:6870:5587:b0:258:476d:a781 with SMTP id 586e51a60fabf-25cf02d87f7mr19127744fac.3.1719594552342;
        Fri, 28 Jun 2024 10:09:12 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-25d8e339bd6sm507709fac.46.2024.06.28.10.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jun 2024 10:09:11 -0700 (PDT)
Message-ID: <c175bc3c-2d5c-4785-963b-01ae969f8e6a@kernel.dk>
Date: Fri, 28 Jun 2024 11:09:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 0/5] zerocopy tx cleanups
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
 Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1719190216.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1719190216.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 6:59 AM, Pavel Begunkov wrote:
> Assorted zerocopy send path cleanups, the main part of which is
> moving some net stack specific accounting out of io_uring back
> to net/ in Patch 4.

Looks good to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe



