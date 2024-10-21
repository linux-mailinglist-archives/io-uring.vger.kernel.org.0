Return-Path: <io-uring+bounces-3860-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70DC09A6F0D
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 18:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30989284307
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 16:05:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89CFF1CBEA1;
	Mon, 21 Oct 2024 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KAPBa9Lc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412601E5705
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729526728; cv=none; b=r4cSBVIeWcbVy/trT7UcbHrB7AYxZyPQ4muRs+yx3r8Stgv5w+vHrET0TqzLjNSCiPvpRL3eWeOLo8BjH/W9wrWGbNrJp5tr4gw99PUfGP2xajzqYku+nNCPy1Ru1oIjT9CwzIQzi1RlLz802+xi/t0T7tVHz0S0dQQVCXCOQJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729526728; c=relaxed/simple;
	bh=82EnS5fxs4HAEKp3RYPaUrmzu5xS+BPxemHrEA4kBsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qYz1vTmwQX8btDa998ddpsERph+uBKHrie2n8uiCTlA+K49StNTaMagnU6xPJGP3apLmFoE5vQDOBpMomixCYG2KUyHjAKevaq0erRsj4b9UT9oJoebrDCvp9oOqMd1LtpvCg6+snP2m8l4HkDiCtJ6MdK5dQtB5kD0O81+OU7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KAPBa9Lc; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a3a5cd2a3bso19198445ab.3
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 09:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729526725; x=1730131525; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O20YdsRWSCZeo0YE58LeV4jhBG07ObRjvq/lCHiTEP0=;
        b=KAPBa9LciU2+u9r0tWWrGMJ4p6kmQBLo4a1Hc/N7PoYQZ8iOw+A3TgpzVL3hsnQHSM
         2iB8QT5jwPs21uRDzQEDKYDwCfMchmNiajuW69AOKS+mp8DNyoNl58srmWLKsPMYaqRz
         tJz7qfQBzgx0pvTdqwpnO5qyAswVoerhk+n5rbp23709FiImjndPy/N/NOCwlalGdMi2
         FL8c3oKDAv8GFIxLqqvmqdLTcyYY2veCSKx2GL+EYCivkbWJoRweNxtI9MUF3K4uPvXA
         P4wm3/jWgsvk9RdY8NuKCStQkBQeW+qcxas0YSaMAWbdzo0rD8jYLuWMc14znf1FdiAQ
         2iXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729526725; x=1730131525;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O20YdsRWSCZeo0YE58LeV4jhBG07ObRjvq/lCHiTEP0=;
        b=MhvleNdbuQ2L8uhJhPSsmDFjaRJy9jBbMjobwYwQjadSYp9H9HQHmNwx/OsKe/jvtQ
         qWlTA8pDCS2FD8ocURWCPhtfDVUqpEE6VLHF7jhnrwpRKm1yBxF9xMGG5rUvLoGN+xNe
         EP1HwaUvHPn1BsvXKWDUKbugkhKY6XE//VRYnZfxRfSJPOplm/pKvgBAgXjteeVW2HfD
         1c4N6ku8X3RG4l8pRXa0CkhuMIgSewcm339tsR+B30fyr6WmlO3AFtdMOLGXaTtAU/Gu
         Gqv5R83JtQT/gPFWXL0dt3WUIU3UwaQYq8T3nyouRGo9ve0tNiAL6w0wDwszkZtfv3uv
         xQjg==
X-Forwarded-Encrypted: i=1; AJvYcCXw97x0IWXkydx+UVYOggXBENv06j3iCezGvHxEmN0xY2xLEYi6Fd/ZElrdbV9ueUro7bcfLRVoAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDn9tTeClsAoUDN1r5MvQ0Wx0IKjdLPuN4JLdyIqix79Ip2WcG
	1n1mUaGkbm2Ba9kVvbr9iR/AdZJ/wYvvird7F8MA6YzA/wYKQpxUIXc49JMUzZ0=
X-Google-Smtp-Source: AGHT+IHeta4vSc/mgvTqOlST6hmybeznoapVXDluV7Xo5064TrWo2byZXUX7KY2Rh4ywEgacKobZNw==
X-Received: by 2002:a92:c54f:0:b0:3a3:4391:24e9 with SMTP id e9e14a558f8ab-3a3f409e805mr108651205ab.20.1729526725084;
        Mon, 21 Oct 2024 09:05:25 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b6339csm12264525ab.69.2024.10.21.09.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 09:05:24 -0700 (PDT)
Message-ID: <29147d52-f606-4831-bf4b-90feda7d58ec@kernel.dk>
Date: Mon, 21 Oct 2024 10:05:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/15] io_uring/zcrx: add io_recvzc request
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
 <20241016185252.3746190-13-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241016185252.3746190-13-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Looks good to me:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

