Return-Path: <io-uring+bounces-5155-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB7F9DEA31
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 17:06:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CAD4B23495
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 16:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24ACC13D619;
	Fri, 29 Nov 2024 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="puF4hiK6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7334168DA
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 16:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732896392; cv=none; b=CYL12DgBvbhlISw5626On3rfbqOgcn1o8ci9aNIexrjbl58uljs/HZmuBIpGF+pnTUqFvvN7Kf37iSN+UwGrczde4t3J7b3uOwRXZkvCWyU0E3eD9FxIG6YQ3cF05H07r8ezXpnGuPqvgTd0Y6zqB2zw4C/WqHDOBBfq4Ig3aQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732896392; c=relaxed/simple;
	bh=0DId6GzifRTbPlA2j/KZVqIhqj4kUKg81Z7w1IklAtM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Fe4Ffv5ALelEgl1cVW2c9CgrHcogQyb5w52moezE6Jwnyhj9i03t6vbJMkZo+y5cOlzNfvIxCUa4+RJDBfztmi7rAEnBxNPV1tFd4lE8fYamFJJ64ZvL9+dCJcsdhM8ukTxNWOM0jLVypfMy5MmqySZCwGHFRVvW3kdz7DLKMlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=puF4hiK6; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-724ffe64923so2127404b3a.2
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 08:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732896390; x=1733501190; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bZGFGeOUe2/u9Po90HZDxtrmgQTsGYV7LdIgEc2j6ZA=;
        b=puF4hiK6c7Fj6kYg47QFXzkzDQ4FwtEubmHxEuVRR16izTk1oLOO3kIuGJxFGGMLT7
         sggGJ84+M18/L46ImNpU+PtqrcgZvFS/wsLyYp/udXjYzrcbtMPSqnzBLUu2KFL3g/jO
         dlTZPmCvIz1G4phSTOG8Nsfb/bCg+d59ufSFjM15hRAQIXpfYgVX/OzhTS91qb/UJatf
         6NUdNVtdWZjcJBNYQvpncYrKAzWX2sfYy456oihvORRa0W6OxlI9EPwl3ysIEkPu2UbS
         5EaXvSubF0ekAtcM7nFTHwlrs/mqjMar8IbbWEDpmAMhVi+hr8zXxsgeHA/RUd6ZVi/P
         l2QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732896390; x=1733501190;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bZGFGeOUe2/u9Po90HZDxtrmgQTsGYV7LdIgEc2j6ZA=;
        b=sdKL1kYlkL6PJ6zfMmsxJjSiK2OLnBNrYAlV1xbapqKk71mjCwaxZCqFF6lp+aeCgP
         ZmgTSKJQHvjA1JQk7AHFgJ+ki+jhEQF6kMBQFiUW+15MHQz8N0S+bi4FNYw5vsOst9lO
         TBiA9rdZTq/TBODHiYjGFoucnVPGkN35P6Cs128u3v0hTEX3jeiQ4fH+c9qjiW4vWFrm
         0Ss8vaq7nl0LXaq1092f0IOVuUnzgm40Fn6XYqMQhA7oF7u3TmZc/rbKrs9PvEgl7651
         7kJKFZtRolk4FhOT2OzoSEZ+Szo2dmv5QkJHFoF3bzWKfo2j8viqlbAkRc1ROei0p2JA
         Onww==
X-Forwarded-Encrypted: i=1; AJvYcCWfDl24avfensT61CkIKyVf4hMKLffd0Yqbr6jFtvEjIglUPl80wFaZ7ey9yIM9FQg9XAdTg0E8tA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXVkpETiPMKxjbKotmGSUQIBM78Ok+4oiKLgtqfGWK5cqbGHie
	4DBTttL2KsuqEHnbY2JMxT7ksrgVhxRoJWyqd9KPxNlO4CGOt5EyzQGhWxrb4ic=
X-Gm-Gg: ASbGncscYxf6dEdW340iq9yhZZR6tjKJIX5ONvLLqRg27Y++fi0VhdHMIsxfMnMDQBV
	bnWIWBWHWeFTeEVAydKPniOrut1vR9n5kpsdjC7VBptRbWgnVTpm70nMg10k0WjG8OvMgs1f4KW
	6Act7ZIxgMNYTpJ6Xppt+s9WlltGhEn0gMZP8HUI3qxx36GaIMOyfEa7/ugtVsMl1HhyFKNLYlA
	w501bkZCIrYf1szc8RtrLT17yWkQr9CO1NnOXnDlW5iZHs=
X-Google-Smtp-Source: AGHT+IHdEN6BRBWbZXMe4BDrmio8UcpQ78FiasvHfz5sDZqYnt4K/WpPn/rXBglRJKXFvA7QmOcVJg==
X-Received: by 2002:a17:90b:17cd:b0:2ea:a3fc:b944 with SMTP id 98e67ed59e1d1-2ee097c1e92mr12868867a91.28.1732896389735;
        Fri, 29 Nov 2024 08:06:29 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ee566a9a34sm1587561a91.51.2024.11.29.08.06.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2024 08:06:29 -0800 (PST)
Message-ID: <aa54264e-ab72-4463-a2ec-c95867ca77a5@kernel.dk>
Date: Fri, 29 Nov 2024 09:06:28 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/18] kernel allocated regions and convert memmap to
 regions
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1732886067.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1732886067.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/29/24 6:34 AM, Pavel Begunkov wrote:
> The first part of the series (Patches 1-11) implement kernel allocated
> regions, which is the classical way SQ/CQ are created. It should be
> straightforward with simple preparations patches and cleanups. The main
> part is Patch 10, which internally implements kernel allocations, and
> Patch 11 that implementing the mmap part and exposes it to reg-wait /
> parameter region users.
> 
> The rest (Patches 12-18) converts SQ, CQ and provided buffers rings
> to regions, which carves a common path for all of them and removes
> duplication.

This is really nice, great unification of it all. And the diffstat
tells that story too.

-- 
Jens Axboe


