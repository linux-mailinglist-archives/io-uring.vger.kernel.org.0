Return-Path: <io-uring+bounces-10001-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BA93BD983E
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 15:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35360188F80A
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 13:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C8D1DED5C;
	Tue, 14 Oct 2025 13:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X5WuHwNM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2938DF49
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 13:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760446916; cv=none; b=ANkMiakTAyvmbPXesHhSRZjKs/47E7gYne8tw6LwHaNdjOkaaAuMxjXghkyUBqELKUY4aPUMNQIR9bZ8L0vOi9L0X4JytPjf63FZvgrSVYdQSuSIHAkNSDkoCU8le3kCoSGeY92IcFDI2nXJPF5Wa0UiCYGpHXldt8bFoF1a2VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760446916; c=relaxed/simple;
	bh=2PZ7Dxiux29sn2cxLLbfjy5baL0JUF5GxdCqMf2A7vA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hwLhtBBrF0eEGmsFllA1cU1m5xnJX0KZJHXYDXvOT7jkWlwMTpAE91KqOuozD/VbuEWj6OVYawyjzAEjUlRmEsm16pdO1+mCwAYU+TZOZZRQCJH66hbDCRVDnja7fHdd43uR5/2N5izbSfHXnEk1YGBmmibaUfd0xa/Qiz+C0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X5WuHwNM; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ee1221ceaaso4331036f8f.3
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 06:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760446913; x=1761051713; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Orem4t6QfSI5JFiug2h5DjVy4ER1OmliqxRluIkKeWg=;
        b=X5WuHwNM3pxJoKh2q75+gfboP50bMXVfYAczv0kox+2KJ8OpzfKOq8AVucrnCXVnLv
         Az92vUSAhz0QjQGDyuFb3UdnmhKP74BEwSQOasnxOMlu7gY8hsoPo9avdafBoshXokDh
         woRq7tMdufnWEmYVhmXbNbudYkrFC+khWf6GC8vzhbgWCcNs3iEjQ6beMEAnbMyC3myU
         s08+94Dr+GwbPdoF1ImXT1KXGZ+1fBuqgCsHLzU0DL2TWUJV8tNahrf2xP3t0D+HOzxz
         HpFH6QCOLS42ek8ah0KeZEJNCYbIuSfxaSpW6g1cwwaVyf01IA3QvJphpwMz9dd30y1R
         NmdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760446913; x=1761051713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Orem4t6QfSI5JFiug2h5DjVy4ER1OmliqxRluIkKeWg=;
        b=QnAg8gzk8dQWYw6p/N3dtwgNvzEUjH5P/8+aFT6cjypZI1BXJUjQprg0Tyc/cKmS6t
         ineUs4uYqbCC6fGn7ElLHiINRuu6VanvEOZrfWR4KmjaEslYDH9Y2SyY62uJSSQvrg3+
         O+JL30pkKv9hQFzvKfyWk4Jk4/aNlmrdbIXZfGY+SGg47M0L9MBNP7aQaOkVnM8r/RBL
         9D2dkFWyEuYGizUF+IDdfcfwyXao7dK42q2MjN7tOqxiwCpsf0lQLS4FvXwyPtXwWNuk
         3Rjz7ShtxeKHyTw4CdKPgg2WfzPLBBo/j4K6Kt262vTJSxWqkc9tb6bnGA/jP7h6wnch
         gxQg==
X-Forwarded-Encrypted: i=1; AJvYcCUx21X/gPlC1JFWe/ig2zuu8QKA86iaW5DOJ6HVUytVipz09eE2JBJuhvEiMWXSZqIv92Abd+95Yg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDyUMs9D2aR3neenQNHK1Mszd127MWVxRKgqiQWOWHY12+Umg9
	MXUc/o3MI6H5nqeFWdnU9DQ9yRh7g6oxPCVZ84/FUdx/x+sfpxHzwkJi
X-Gm-Gg: ASbGncv1jbWqySgCBPXg7Opt3cANiVtmcX7pkAz3Fv8Giz8HTJlvSDIRSTjOqVoxipd
	eX0jQ7RE0Mp81O+pCf1lMPhMZd521crMMcLfIwLehLjV/wKsteED6EV6pa/wFoBacEYwfzY9pWi
	RYun5MadBu1ry6OU0HLJl1zSmLW3mYy9qm0ROPIiQzvE2cCPoY3I3imUqD+z1GrGvvN2g99K3ru
	cJl7v23NB+5C+L0gf+v4Sp2Zj0I6F/oorG6bKJK/Gt65lVEzeAOReL8fA8EXxiRtfoxhUy0K2Ee
	1mllbglA3PD1JAlT1EH49cXOGmzHpXQWWozalXPJYyMQJH3QohnvwkJWLDoF372IXHKjGruwk5K
	8qrXSGbkQxDdi31HNmKz3eMsyo4dutXtHywEZLMd/vppZgfEiiKpLALPL2oShTIukp32aeLPlvQ
	==
X-Google-Smtp-Source: AGHT+IGZAuguHs2vAFoS95VzADN/By/zVpX3eGPY3Q5ZY95Qs8yWuNrHeiJWEnxBhgf85YsKK7wXPg==
X-Received: by 2002:a05:6000:2c0c:b0:3f1:5bdd:190a with SMTP id ffacd0b85a97d-42666ac3a16mr15370706f8f.3.1760446913058;
        Tue, 14 Oct 2025 06:01:53 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7ec0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cf790sm22831336f8f.28.2025.10.14.06.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 06:01:52 -0700 (PDT)
Message-ID: <2ebc6019-d8b6-4d6f-981e-a61819b67e19@gmail.com>
Date: Tue, 14 Oct 2025 14:03:07 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v5 00/24][pull request] Add support for providers
 with large rx buffer
To: netdev@vger.kernel.org, io-uring@vger.kernel.org
Cc: Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Simon Horman <horms@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Mina Almasry <almasrymina@google.com>, Willem de Bruijn
 <willemb@google.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, David Wei <dw@davidwei.uk>,
 linux-kernel@vger.kernel.org
References: <cover.1760440268.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1760440268.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Oops, should be 0/6 in the subject.

On 10/14/25 14:01, Pavel Begunkov wrote:
> Many modern network cards support configurable rx buffer lengths larger
> than typically used PAGE_SIZE. When paired with hw-gro larger rx buffer
> sizes can drastically reduce the number of buffers traversing the stack
> and save a lot of processing time. Another benefit for memory providers
> like zcrx is that the userspace will be getting larger contiguous chunks
> as well.
> 
> This series adds net infrastructure for memory providers configuring
> the size and implements it for bnxt. It'll be used by io_uring/zcrx,
> which is intentionally separated to simplify merging. You can find
> a branch that includes zcrx changes at [1] and an example liburing
> program at [3].

-- 
Pavel Begunkov


