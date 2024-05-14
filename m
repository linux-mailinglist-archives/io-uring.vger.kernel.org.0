Return-Path: <io-uring+bounces-1894-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DD268C4A6F
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 02:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 490D828464B
	for <lists+io-uring@lfdr.de>; Tue, 14 May 2024 00:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3C80365;
	Tue, 14 May 2024 00:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Oaqu00a2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A0E7FB
	for <io-uring@vger.kernel.org>; Tue, 14 May 2024 00:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715646283; cv=none; b=TOFlVmFin5PugigbAgvlIn03L6NhhnZTDUr84bOc5nRaiclOb78HHO4oSzgOM5NcqHqEDcPA1Qz30pzkV1efQW3gANWfbsbTgbAFBT4KmQIGttFXS6xXWtap/LDuTqrVbp+15OvcYmQZmQUniDCpTyotiKnQK173n4gtoUTqpz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715646283; c=relaxed/simple;
	bh=t0auGNVQBeIHxq0bLd1+ULfQscoiXyCuF7VCFEwNfOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kU5PxgaOWk/DiawC4C5pNRN9HQURavSUhd6SPBKCPsNu/P6mlXSBbQrvEfRg6FS5A90EsQ5t/X6gkrk8HC0Px2pI1sr9i1taRAwfteCbCqnWQWYJ/0ncskAzDA+LIZ2JNqjpA0H3Q77zsiUHRDLy2VSIqKhh6Ipe2y4h0M0kV5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Oaqu00a2; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3c9a65308d0so105850b6e.2
        for <io-uring@vger.kernel.org>; Mon, 13 May 2024 17:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715646280; x=1716251080; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vv9tAk9ywvBLGmojvsSeKdtPXUn5PYoMEpo4ShJp7hM=;
        b=Oaqu00a2lAklIIbKes+bstqQQWz6bldW/LwtB2EC9PZ03xi7uWGSj2MeE55egoZVbN
         f7NwBNNqFaT5tjd84jneU/+G9te3djtFMW5LXN+KQAS7u7Ni7ooHNUMdFhm56+2/MUgB
         pxe2Ws/GENzaescGSYVMofJIpWd0VpNXR0ROFcflwhlgNE+mARL38w1HOqYGxF6y5HFZ
         Fz4M/E63uiSJOVbk0+ptERbuQX/VhbEA019JQOSxyu3i7CZrLg6Cx+BKmBuRUbei51va
         jF4K075wbTKUO4ojX0IgQJWHHaPAm8ktZUq+3VHRhVqXkJyu9fhNMB7LXwhgyxMMi6HH
         MCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715646280; x=1716251080;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vv9tAk9ywvBLGmojvsSeKdtPXUn5PYoMEpo4ShJp7hM=;
        b=Iev8S8uLjKQBM/c0+gpDqtFpa8FlwgCRLuxVde9hHTC+UZw82QGgNdKlMdCGHZvZln
         FtvMIpsNicmz5aatJWnRwnHVLGapBLwEGZ9xEHfb4gafzKJix2LpnK0v/jcetLUa0lax
         /BIZyqd76xBjeulmVfKa7hAIqAs+GW4k/AOVeluwjzWv+0UyKerMTkdE5b7u0wegt1uj
         6BFvz+mHzJ/eb2twbTT9TtcZvRk4ss+/vfoUYwogkTaP3lV5XzuWLkqrStCiKgx51pZS
         8Wm8v+IkGo6ONkqSka8Zv4etpGud651ukq8pRHyrmSAJf1JDm2+tcmuyNquOScYsg+IU
         9eFw==
X-Gm-Message-State: AOJu0YysDmg7Uvrutjb3CMdR6k/HibW5rO+chF61yn8VJ0AMTj0GQ7To
	ncHAcObmWmjawJqvw9Zxy+0vQxgRBiN3fZFJZNoQIIu7l75W7w1BWDRaTuNODaM=
X-Google-Smtp-Source: AGHT+IE5noQE8R5HMrOb/xoqVoPsOKt6780883wcR/yNCRrEI5wnHZY8XPt1NoYg9tNtvafk6w0u0w==
X-Received: by 2002:a05:6870:9724:b0:23e:6d44:f97f with SMTP id 586e51a60fabf-24172a3d677mr13744472fac.1.1715646280135;
        Mon, 13 May 2024 17:24:40 -0700 (PDT)
Received: from [172.21.17.150] ([50.204.89.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2af2b53sm7936468b3a.151.2024.05.13.17.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 May 2024 17:24:39 -0700 (PDT)
Message-ID: <b4bb08a5-8213-4b31-870a-f4f24f7a2c4f@kernel.dk>
Date: Mon, 13 May 2024 18:24:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET RFC 0/4] Propagate back queue status on accept
To: Jakub Kicinski <kuba@kernel.org>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20240509180627.204155-1-axboe@kernel.dk>
 <20240513171347.711741c7@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240513171347.711741c7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/13/24 6:13 PM, Jakub Kicinski wrote:
> On Thu,  9 May 2024 12:00:25 -0600 Jens Axboe wrote:
>> With io_uring, one thing we can do is tell userspace whether or not
>> there's more data left in a socket after a receive is done. This is
>> useful for applications to now, and it also helps make multishot receive
>> requests more efficient by eliminating that last failed retry when the
>> socket has no more data left. This is propagated by setting the
>> IORING_CQE_F_SOCK_NONEMPTY flag, and is driven by setting
>> msghdr->msg_get_inq and having the protocol fill out msghdr->msg_inq in
>> that case.
>>
>> For accept, there's a similar issue in that we'd like to know if there
>> are more connections to accept after the current one has been accepted.
>> Both because we can tell userspace about it, but also to drive multishot
>> accept retries more efficiently, similar to recv/recvmsg.
>>
>> This series starts by changing the proto/proto_ops accept prototypes
>> to eliminate flags/errp/kern and replace it with a structure that
>> encompasses all of them.
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> Feel free to submit for 6.10, or LMK if you want me to send the first
> 3 to Linus.

Thanks! I'll send them in later this merge window (post the net-next
changes).

-- 
Jens Axboe


