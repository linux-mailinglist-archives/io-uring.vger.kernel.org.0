Return-Path: <io-uring+bounces-9098-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D692CB2DBF7
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 14:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65AE11C23280
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 12:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45B92D6E4C;
	Wed, 20 Aug 2025 12:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hjWCACoP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E899A183CC3;
	Wed, 20 Aug 2025 12:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755691414; cv=none; b=MjLPPAYqEoooqHCUQm8UFJE7Oude/d9vFLQjgpjyd3pfJUmmwzhw8Il+pwzCOC2Qs32FgmAWTDhZD/esibOjUIIvbVeTJk5G7Z+e6XQwTwbE8vjeHRs9msbNZDgAcF5umepomA/3PGptLgRlF1VB16+VY2p8Cic0Hc0HEciY0/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755691414; c=relaxed/simple;
	bh=eHKn8iJucqxAbzpJgDpV7nmtzEYpKn6TT9ECvMVGXLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LZ1MpysMPL2iuxeZVl1OHmkXqa3Yzjy94RTxh0Y5IiwxWeR2Cg0Xl8g51p1wDfcKzF8RokwJa6i+i5bucMXvOaT7nf2RBxD+tI+MLcZzofszSPvQJhmHOFWDm/FwJ65M4+qNz7mpuzreJpWNBfI7jh6bbwrFYpvgTXfHAA3klYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hjWCACoP; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a28ff47a0so19179595e9.0;
        Wed, 20 Aug 2025 05:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755691410; x=1756296210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XXaBuqHwa15yy/eu+VvjkdKQuH18mHpFGGi+XGcVeWI=;
        b=hjWCACoPnoVX+m3eaCW7wFjEyv6RNDZVf9YF8wb6ijWbnmxQK/tWL65rKo9YpT3zuO
         e18T+7qeg0xULyq7D9CoFPccg/70quBpeHut1k4bSKX446V3AO8tgwCTNxFPAYvVPp5M
         utRnnKW0gdyOTg9S+Tej8ot44dGZTFRdetIV9cQZhxDan8XN99HnAwQy6OQk81ist2kk
         NRXcrd1yONR8XJ660Kmxg/i3oMxft37KDcykseyuqusuyCo0RQ0aYEV8SSSWs3i0d1xo
         5Cjla3ZautvG+4NznKs04Ik49HioI3YrEtKmY686/VjhUrpVVadA6DQFPNN5vUuN8lYu
         F2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755691410; x=1756296210;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XXaBuqHwa15yy/eu+VvjkdKQuH18mHpFGGi+XGcVeWI=;
        b=SRuPULcVSVBe81L5RngBUbO1/QlPfMcbUJVupFCncAiEzc3X2etKgcRGGm7oyZayKb
         ljnihYdM1/ExFDvLfULNPkPSPE0GAKnizaP6kBqsqW8LT66U11TQ49J1NMOXCW/GU9Ux
         IBFCeVVNH05tIavoq+XsrOXKSBw6Z+tlj8n/i4I1b9kQt3Pui+zx9FMq7vuYUEQOBPa4
         kqJl5nbtQk1UwgYgUISa/xgHpCi3CS0lxO+ZvsFj70v1XchEc7PEt51QxUjMUedXPXfA
         7mgRWTTi0z68NLyEhnB7TOnMLHV6t94fz41wy7A8YOtvu9cABBPSmCX7C0pW90TuKG4r
         R5PA==
X-Forwarded-Encrypted: i=1; AJvYcCVODFH6e37MSLlCq6crMqPe9CIUuJmil+9eTA+/0xfo9HHePIf6LBB2EFaRPPFDfe5UVyhLBZ6kX8b5iEgC@vger.kernel.org, AJvYcCVveJcWc0M4onUIAoIXPJ1c7z4OE5Q8MhzakBiJzOd8wTZ9N3Ql2Q0f3b/qUMUPn1iZOFg5TSyVjg==@vger.kernel.org, AJvYcCXyrU3QlycofZeC3660IUBp01Svgcpy+daih4XcoTqa+0vD6UTX6bO8GuJRZcg8j1si2sdktPvh@vger.kernel.org
X-Gm-Message-State: AOJu0YzQNE6bJ/xGYnqCYtEXcQRUluUvG6xD7m6GF320n+3S97VJ749K
	olPfmlocVAy0kELkZQf7b2M82tP2s9GshEgFaK7piEIv/5YzawG1VEpW
X-Gm-Gg: ASbGncthDAJNndgFuDc+WRCqd8QLp5PN4Sclj68dEYfoct+w/eaHUABtX+tcZeaIoR8
	jaYfrwuY9xn52xGNlSp+H2QzmoRyAmMQMOBn5ahgryifJQ2uy3LksmIlSdAsci06sv1adeO7k8j
	dBB/BWrVIOn/dzXRB9319aL9Uxp9Awnyzgdy8+lkRLZ3lbMgRMvGYRCahCZxFfYYh/PqZlDr0LW
	e/r6r0nBs4USRM6hVD4fALvNUHVG8fn8Faz7IIFPzxUkzk7hN2eLc5aF/92C4TQOaBx+2/BzkVs
	XStr7zn4/wizvUWFyVBQMRB2Ls34tT0YzEYFeUY42BRhm9LpjAlyQxhlDtbiL9pMB/MtPabTjyX
	TtFRoJFXD61rUzPqW78mLFFTa6Aoa3Rk2qDhWhJHe+5fBtKKD2WfgNtI=
X-Google-Smtp-Source: AGHT+IFTqtLUCF0kRl8LCEKNbCKLBDF/eqiXvH/D0EJIMMk9eWA4xaRr/DXUkSzDP9Cz88lsFbLCqg==
X-Received: by 2002:a05:600c:1906:b0:459:da89:b06 with SMTP id 5b1f17b1804b1-45b479e2772mr28957305e9.16.1755691409965;
        Wed, 20 Aug 2025 05:03:29 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5f7e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c07487978bsm7339533f8f.7.2025.08.20.05.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 05:03:29 -0700 (PDT)
Message-ID: <d55e4a81-e4da-47c5-95ab-03132c1c5553@gmail.com>
Date: Wed, 20 Aug 2025 13:04:40 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 05/23] net: clarify the meaning of
 netdev_config members
To: Mina Almasry <almasrymina@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>,
 Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org,
 davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <cover.1755499375.git.asml.silence@gmail.com>
 <8669b80579316a12d5b1eb652edb475db2f535e7.1755499376.git.asml.silence@gmail.com>
 <CAHS8izMO=6oHN4w9XiL0yw7x86LF8iw-LhMA4qZe2rXOu0Cmbg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izMO=6oHN4w9XiL0yw7x86LF8iw-LhMA4qZe2rXOu0Cmbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/19/25 02:46, Mina Almasry wrote:
> On Mon, Aug 18, 2025 at 6:56 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> From: Jakub Kicinski <kuba@kernel.org>
>>
>> hds_thresh and hds_config are both inside struct netdev_config
>> but have quite different semantics. hds_config is the user config
>> with ternary semantics (on/off/unset). hds_thresh is a straight
>> up value, populated by the driver at init and only modified by
>> user space. We don't expect the drivers to have to pick a special
>> hds_thresh value based on other configuration.
>>
>> The two approaches have different advantages and downsides.
>> hds_thresh ("direct value") gives core easy access to current
>> device settings, but there's no way to express whether the value
>> comes from the user. It also requires the initialization by
>> the driver.
>>
>> hds_config ("user config values") tells us what user wanted, but
>> doesn't give us the current value in the core.
>>
>> Try to explain this a bit in the comments, so at we make a conscious
>> choice for new values which semantics we expect.
>>
>> Move the init inside ethtool_ringparam_get_cfg() to reflect the semantics.
>> Commit 216a61d33c07 ("net: ethtool: fix ethtool_ringparam_get_cfg()
>> returns a hds_thresh value always as 0.") added the setting for the
>> benefit of netdevsim which doesn't touch the value at all on get.
>> Again, this is just to clarify the intention, shouldn't cause any
>> functional change.
>>
> 
> TBH I can't say that moving the init to before
> dev->ethtool_ops->get_ringparam(dev, param, kparam, extack) made me
> understand semantics better. 

I agree, it didn't do it for me either ...

> If you do a respin, maybe a comment above
> the kparam->hds_thresh to say what you mean would help the next reader
> understand.

... and since the move doesn't have a strong semantical meaning, I
can't think of a good comment to put on top of the assignment.
hds_thresh is already described in struct netdev_config and it
seems like a better place for such stuff. Thoughts?

-- 
Pavel Begunkov


