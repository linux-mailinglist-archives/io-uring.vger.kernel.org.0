Return-Path: <io-uring+bounces-8209-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA11ACDA44
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 10:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 889BA1895929
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 08:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A0D231837;
	Wed,  4 Jun 2025 08:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gUipQ124"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1AE231833;
	Wed,  4 Jun 2025 08:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749027126; cv=none; b=XHdY4FasXqruGUyIIXMQGA9lw7388WgAlYBoYiUzs4knMA4fUuu8/xcqbKMyiMqsB9ZxKDqNQkGayZ/HZEsPHPXFr0twlSkp7vSUwd5X1yMuGSerMNAF/bauSq0y2soNxAsFuYviK+a7vE/GTaQWoOlblTF1OUAwkTnU6xU6gWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749027126; c=relaxed/simple;
	bh=fnNgkzGftpljMjTaeKiPjWijfObuZgFRqWuUjmrN3c8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VoayLjOoGSmMh6cC6i/sE7268SwVg+AtgN8Hmyah4PeffmuRxxKkkNsHDi4c4L1wm6wrHm5bmGqbOk8rMU/gSAPNVZm298doQCWbJTFebQdH64xI/0mEKxcJhJgzw39c5XcKR7QtumH9K824jPeZi77qX2aaxxW5tny8UwhKkMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gUipQ124; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-addda47ebeaso547130466b.1;
        Wed, 04 Jun 2025 01:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749027122; x=1749631922; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s18OXxB2J+rqEEd4cuUATT7H103nVr2cT6AOoJNQm0Y=;
        b=gUipQ124nrGJ2nlL4oOlA8uR+cDDnQkoZgDyKRVDZ64mxgu4QN32zE/YBDYB8/ZK+Y
         JziOYCoR1sh5Egua38c1GRL/OpiWdxsIwA/k/9K6I8nDw/dN5xfAx1C+bnhqff+AMacv
         51Uk3/UPw6pZqR9lrYsmr10EpmrLqPSwbMUrl82L6sAe6AInbE1xMinRKOSPsdVzgfCc
         ZB1S9eASCv/fPnbKAsSo8Ly6cjSXERR1RlmDw1aQjjQfgc0rCkfRCHOKlcCUot/IfHbn
         cDtFqfgtDcrGVqDPTO1rwIKDTnsZSzsXFfkXsQBlKHw/wP6ahy7Poqx++q3F7oLq0Fmg
         EDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749027122; x=1749631922;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s18OXxB2J+rqEEd4cuUATT7H103nVr2cT6AOoJNQm0Y=;
        b=W+jYkeXDTU5oOf3wC2Ipv5yyO7wtteX56G56N3QmL9HIQpAfKVNBVpa+5lx2h8p/OO
         bUbFfROOjNF7iznPvbBzf/djlw8MdGE6uzs/7AOj91lBwCneF/Ef6te3hcFzjDDyRYqZ
         Cpu4pB91/mtd5xcvwHDe0Dlwnjo28JW1N4/DAHHpwJG+h9319MmOGbDf5q+r4ki5xHeh
         bwXpE+IwsJkkwDcOFziCCevoB1V1VOK1Y2ujAjhaHWH2ep9RD23BjxwIMJUZtBMkdqao
         05EWltHEA3gxCf7BB+oKPJbOSdc2MyWuH8AG7aXE8KDAhnPVCqHcrj4OUqJVkfr2TyHq
         ovkA==
X-Gm-Message-State: AOJu0YzU+g5sFMJqVz5L20XD6EEiiCmAyFRRgI/ceJZ0g+5a9cU/NgmE
	uvJZCKjE5+rbTeLDgVxQtaoE5LC3hcfdwoPt7mHIKYRfj7A6NBfbIXAIMwBSKg==
X-Gm-Gg: ASbGncuVdwbpk6H1X2C5Fvcme3vaVRdc406CNR4s4ya7nGCoGGkR7Jv9/bsA66hnA67
	TS8t+L7jBbAmj2KAvHRbXii2yKOb7eJZxabjm0Ff4YFx0pCqJblFzhDWq2kXY+poGXqKeVp2Bwq
	Ju1TI7g8qoLLxguemakve6Dp9pAfHI8DO0YoNUNU9/JL8nG3mB7IcmyMsesMZgpTKZBEU2Q7yc7
	OhdXm47trhdjNfFWrdlW+ZJiOw4/LEX83WKVTtlbJJqmx+fT/wKI6eHlroA0VnR/0czPvlnTDNx
	dtNOUFN8cZnHEdRPe92odNRKUWpEAhVxhhfF7pLCVmS4kmelSyAfa4NKZDp9/fLL
X-Google-Smtp-Source: AGHT+IEVpTSwc08kIcsCNa6mzTF7jShw7RMNAQkvLJVZ3IKHEpcF5/wx/oLMo92vKOmGHnIs9GdYyg==
X-Received: by 2002:a17:907:60ca:b0:adb:469d:2221 with SMTP id a640c23a62f3a-addf8fb3392mr159006766b.45.1749027122363;
        Wed, 04 Jun 2025 01:52:02 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:b3d1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adddf8f009bsm260341066b.4.2025.06.04.01.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 01:52:01 -0700 (PDT)
Message-ID: <0d287955-c55a-4f1e-86c9-5c301f3f233b@gmail.com>
Date: Wed, 4 Jun 2025 09:53:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] io_uring cmd for tx timestamps
To: io-uring@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <stfomichev@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1749026421.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/4/25 09:42, Pavel Begunkov wrote:
> Vadim Fedorenko suggested to add an alternative API for receiving
> tx timestamps through io_uring. The series introduces io_uring socket
> cmd for fetching tx timestamps, which is a polled multishot request,
> i.e. internally polling the socket for POLLERR and posts timestamps
> when they're arrives. For the API description see Patch 5.
> 
> It reuses existing timestamp infra and takes them from the socket's
> error queue. For networking people the important parts are Patch 1,
> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
> 
> It should be reasonable to take it through the io_uring tree once
> we have consensus, but let me know if there are any concerns.

CC'ing Stanislav as he took a look at v1

-- 
Pavel Begunkov


