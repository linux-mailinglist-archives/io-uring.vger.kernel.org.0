Return-Path: <io-uring+bounces-5850-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EFCFA0C4C6
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 23:33:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71DEE16142F
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 22:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B00D7240223;
	Mon, 13 Jan 2025 22:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jpACI8F5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E971D5142
	for <io-uring@vger.kernel.org>; Mon, 13 Jan 2025 22:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736807529; cv=none; b=RJDVIXPB1dwaGVW3LpiWPCXNVmS72YKdpKufE7fgljq4hFspeachOrOtz9K8512I3IG+X1cBBNRnQVUqb81I4H2hLAe4IXnnBPjdmyhlTO2E39M9tBV0tPRP32upLY8PS4Uu1AWxaNW7G3q8x4BWgseZqedAOdvN/CgG3+DcoVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736807529; c=relaxed/simple;
	bh=hbjFWc/M1u0JtUeGDfraCyEfZ1LuYrMt6ic+SN3g7Vs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vDGlcDvOOAJ4RVPVpgfMOd5Mq02Wj90uHivEdINr0TYGoTek5FbTmJWrjJZ1CO8weflakDNUSFpQJM5/Wx5n9qZ06XgCyQ3B6bdTQl62z+Uw0iKklbt76qulfMsWBZIrBZHEFLfEXQJjsqxJN1COOQOx3LvbQdYXVtTrY7N258U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jpACI8F5; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-844e7409f8aso168619839f.1
        for <io-uring@vger.kernel.org>; Mon, 13 Jan 2025 14:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736807527; x=1737412327; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=jpACI8F5zdSCaEhZJdlHGLRyv+e+ExUikhghVozjlLiCFCETguLJg18HkqUsjIPEXu
         7ZYZ2vzX50iawyyI6SaMxtF/bHYqUmUvXXdWAhubV0KnryfMHw347d5qN1OvMtgQwqhs
         9qIUY9qLWutz/kh7gQUM3snSG3Q5hk9lF/fskUu9xAlusNLi3RHmIoPLZPXzUvo4I5pl
         s92Pzer2XCn+BzTRd4jOvfg8aEbUDYVzyyLH8ixDafMHluhBOd8Z8je13QbfmbaPmUfT
         /hlc4D0XQqNFtbIyuorW+/iD/0cVdEbGXSMPnu2aYHe7QAvr6o4mv8Jbhl9GCooPnUA0
         4VOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736807527; x=1737412327;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/+f5haOvY7V5aJLRvqMe+OKgyMJap2D1kg9AHRnXBFo=;
        b=tGh6tvq5CBuUIZkpIhfJF9bhnFF/iod21xnqI/M3pKu0wYl0h9JpUvWfFyYRcS6X9Z
         ATxm+YVqfu5aHBZ6EpJb1kVLzJh3ROqSxra2AWyTxAQJLmaTnflwS57iZnAYZOhFQ8k7
         Xomcqt2qckeHEMgpERgskBAdFFZbzTw0glsKGz2oCYOSUqZBwpAb/NlhjkP5pVcbzbqY
         sS2NsqSGgVSxQBwQ/KsTLmx6APBkpXLa4cW2NopvqCM5xT1FY1Xo845Ga/AZaD6s/SU4
         V0LP1ZmZGItEMP5rYMwIGwGACw8Lz2egebIfXJGh2LWgUlDAA0sRlXZfGZNajeOSUa2+
         eAug==
X-Forwarded-Encrypted: i=1; AJvYcCXMbGYOg5VmzAKy0lQn72rTUOT4BavP3nnw+Po453YVvVjrC5r0s2EpbiqYnT0MJIuUNXoB2u3zJg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx42Aggmr0k35jssjFnH2vLfzR1mQSZY+cY4+VblG8uQgSJjedt
	0NEorKN/CxITb4UiJ0OfFk07yrDFSTxJ3Iri8is5ltO0S+b0B6MgtfYXgvpGEAs=
X-Gm-Gg: ASbGncv7qoU5fTgLp+hnIrlFLEB5Pph4O/Ljs7okVHq9xlvw7qjafCPs6praWd5m5eJ
	paMRag2kXBhtmsRd/PfeLh69tZfG3UWhiZAcAWTVxkiUAxX4Ur+VGIKnu4BRadnM1w2wdDm520C
	YMQqE4GBAuuJVims6H5M4z9uv7zkVXQeyg6tBckbJIb9L3MnMXN8MknUYj1TW4IzWffsZtcrTm9
	RTS130DulBhv24aszvar6OGq4zys93TI7gDvhlIjIHOiqqZAiJZCw==
X-Google-Smtp-Source: AGHT+IGza1UWlyinqLQDDvkXKHMxhIrf8nEuCr5exGMIqyR2VhyxBJgIxQ8XJ/KUXaebYKPkcdPv4A==
X-Received: by 2002:a92:c565:0:b0:3ce:7ae7:a8c2 with SMTP id e9e14a558f8ab-3ce7ae7a9f6mr4276195ab.11.1736807527235;
        Mon, 13 Jan 2025 14:32:07 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b611829sm3038094173.33.2025.01.13.14.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 14:32:06 -0800 (PST)
Message-ID: <3fff2dc8-f371-47b0-80ab-b87385339b9a@kernel.dk>
Date: Mon, 13 Jan 2025 15:32:05 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v10 15/22] io_uring/zcrx: implement zerocopy
 receive pp memory provider
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-16-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250108220644.3528845-16-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

