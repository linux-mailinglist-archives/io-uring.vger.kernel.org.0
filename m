Return-Path: <io-uring+bounces-3853-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9F89A6E18
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B60F1F241FE
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 15:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9349213342F;
	Mon, 21 Oct 2024 15:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DP5o9aBW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CA413B7BC
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 15:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729524483; cv=none; b=YAODWRMPl1PjxpLERZIoZvhfB3qykwd5oHZ8mmwezRpkP5JVLGONm2gjqYWerDdDV528F9Xg9WlG8NQqXzqxd5esQoB1kDkKJvZ3SpIyMow5jZWtkDqAEMjmgqFmJ86cyu0HiLpqMqe36veboh2mvbAefJEB3zPZfGx7gyZTklA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729524483; c=relaxed/simple;
	bh=nv2ti2VLDg35idg6XZbkZTZ7JN7/mw/x6VHeFJLQSwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iPSROEmqL8F+ZXQeAn7SQOB8wekw2XNltF83w3RFYLoNgtegJ9FLdtGDf1gQrjduvRmmkYLDofbxXyGo6bAZ9zKGtEiQUnF49MwU5nFVRfjYlt8o+qq++Y9hrp5E10F5rGp+s/82HxMzkyzgTtN3BBMZFEpdk0a0n9uUhiY5pKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DP5o9aBW; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83abcfb9fd4so120006839f.3
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 08:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729524480; x=1730129280; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XjWBqmqjt2x2Uv9XbFQatXnQGGyRKjtoeD2ucKh9A0s=;
        b=DP5o9aBWUiNS6wy3ojk6UdhcypMYfdtCXHL8pqyavtZF243vh44YeZn2B0Lj6QCu09
         NS5brzHqBWuQc1Bms3JAq/5jD+oK32UN44KO+3YZD9aYH6579mgHoVwSuhPG9lRO55Qa
         8sApUFkGd1zPZtUXrpbQCdKy33ejwt4RQTO0BvwkdgAml1Sey5BuZm5igugOo0/WhOdw
         FiayEUKTKOdcM9AThG9Xssv4FwQpZUH13gb6wW5nUiHagbp/eMn2YEvvxfInHPVAXN9E
         Xd76zkU45+Gsx8H9hzQsBa74f9VEbSVGSNkylS2S5nkXloTKPU71ULAMKZPHvRzrNnzi
         v89w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729524480; x=1730129280;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XjWBqmqjt2x2Uv9XbFQatXnQGGyRKjtoeD2ucKh9A0s=;
        b=dydynsGOa+Dnv65khwlfPrUcwCHx2eMqgUFhhVStotXaGvRwlTGptw/K9FWD6rjhyS
         YxLLlb3aKW7b162jQiP2xrNHKg89u8up3uALsW5iApP4vJRZEgMcMCckbO8/BLzImzhw
         qYvFmuH56aPxKU5USbgfl835XpGVRnzlmwSVzlcVk7zKYxubq0TN7Gsy20frMtT6m1uh
         jKGunnDDrcwwOzHYI5ntokRklEhVYA612NlCyGixP7weAoUkaWHqUn4oQxtyESxZQD4Z
         ISzoUvs90dB3pTsXErp8Df8mwBVgxXxFdNzK8AE22+WkffbYwYFhv7mmC2WKmrErrtSo
         RgqA==
X-Forwarded-Encrypted: i=1; AJvYcCWuexH+wSSguXrKMU9NQHX4ehKmcG22ebgijJ8A9ITFbi4SIbOOOSqU8Wcp9D/eTzOoaekBXlHV+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYpeA+vCxil4EBQAujSVT9PGDtlxCMbp7gK8TjUBCRKYskmCKK
	pu6XdDwW9LaNBVe6rPJPPUWvpdhiENkHAfKIv0ZTCz3fUW1y0Q5JV5ctF4eb0qI=
X-Google-Smtp-Source: AGHT+IHIl3pXKp/ZTWv1FpdI6p8zUnVKGDFvh6+mFBdKBn3nyEcQ6Xcc2f8ypADoA/1gPUu6YAyPsg==
X-Received: by 2002:a05:6602:1549:b0:83a:b33a:5e0a with SMTP id ca18e2360f4ac-83aba5c5755mr953616139f.4.1729524480134;
        Mon, 21 Oct 2024 08:28:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a586cf2sm1025441173.75.2024.10.21.08.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 08:27:59 -0700 (PDT)
Message-ID: <55423797-8362-41fa-99f8-58017aa43e52@kernel.dk>
Date: Mon, 21 Oct 2024 09:27:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/15] io_uring zero copy rx
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241016185252.3746190-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

Ran some quick testing with the updated series, on top of 6.12-rc4 and
netdev-next. Still works fine for me, didn't see any hickups and
performance is still where it was with the previous series (eg perfectly
stellar).

-- 
Jens Axboe

