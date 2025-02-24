Return-Path: <io-uring+bounces-6724-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0436A430E4
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 00:30:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A6FC178817
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 23:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3AE1C860F;
	Mon, 24 Feb 2025 23:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0+OI89Zb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A7C22338
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 23:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740439852; cv=none; b=pS4TQHNxxLUVBakkHDTyl1o3qmbf93FcBSSFTSUf67rj7nAsBmDf/3CdOMvU2pJL1d8EOKQXhPgGjkKXghkQXdR1Goo0VI1EepoP+2DKrjQkLVuRwzwweeFvj1sBVtbJCYIpGXe5vZ29mOqvc/MpObi8y9BjdYBf2o1ZGNQ5bjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740439852; c=relaxed/simple;
	bh=R/SFmzKMQaClZ6ac3+FS1o2WSMthwJHwexFRGbXqiWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FQG/oUdQxdcB6prpkjAlZv93f+a0AffSMNxmZknivSQwlwoqd/1AFwKIDpGU2/qio+Dq9wy0+GGAQnT6JQ0VS6LWjDrdHt4CIo5bpR6N4mk/bYPoWi2TN6lKdONKpGRuJ9YFwTz0lThkpqXSPO3GIw1QwUmlIu+R5mpjclXRuQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0+OI89Zb; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d2af701446so40907785ab.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 15:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740439850; x=1741044650; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BlabqSiF+gaIVSAaNLOzEjzZt+feYIrttInKlJG4jQc=;
        b=0+OI89ZbbGAb3C9EcwlVF3MMRZ1pR9/duTF3eWvS5TpJk+XumotaxIvfQ1mIRxT6L4
         RC7G6SdBgr+b2ukfMgCNyDsE5/K7CLL0naysH4TfaAL8Xm8pF+K39MlDwkQiRqjlZYpG
         NLSKsFOgv4YDX32uNCOdRH0hk4dk4Zpkx73sV+HSAB5fEaeV7V+tTGlV6rGdYksiALAI
         3PizLOB31ncnjDRIeY+buR3OXxGVLRoJAwCgKwzzFA+ZIolggsKAcSO9j3X5eHy33uch
         9tuz+mWHcPwib93Mu0bScUVx06o5B72FM1MQmOKgfUTeSlZudDzJU8+lHAXIxVCc7/Rb
         guDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740439850; x=1741044650;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BlabqSiF+gaIVSAaNLOzEjzZt+feYIrttInKlJG4jQc=;
        b=wpCy9hUpoAggymUxZneZeLWCQHM6lrLuh/SThu6fYSJ+xqDr33igLz93At96w01g/4
         DvaKMyklc1eelYaatCanPRqoNkQdwnhvGGUyrkL7m2X/VkpJdagkJqnXFW7NduiWP9VB
         p71FoBVgLqpDUjX1OY1R6BlGeZ+9RI/FZQTqXQeRVWR4dIYfzInyQF2SaiDdM1b5C+6l
         uHz2Ox8Do37OiZFgUs6gcjqOZCNipA7sJU7BOq9sOgd4nMiXgHrjxRLingq/Rn9eTOvz
         9BH3tRFFH9gITIHGKPWlkV/ZnAkg1uzLvEnCTa+C8KyDVFL3zVtdqypI2i2hUENqmOfk
         TdMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgDBlLwyqR6bcbWDW45S+fdQHxRvXkJeCbfmPR2qVQo706S+fj7aMopUZlNXmY1XOa8s7POkG2UQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7MFDV6/i+RANOHzsUrBFNKn1J0QqQ8qoaM8cQVOTTw2jeL1Wx
	r/u7XkEIzzhozUNrOra+JmyQqJ9+V27TldTsXqrLdaiBqDUmuyk2Z/tQNc1UbbQ=
X-Gm-Gg: ASbGncuDx0iIZMJ5qmTcN4ODS5du5ktsXRqpgo1s77irmylSwANXlpYQicUIKvIA4Oe
	CeqwjbHXNIOa4Ym3/LXtOUEIcCQzAysj0iPLe9urrZh3U8Ndovfq/0USxyR5mjvGb2PlGwCBfgu
	C5mDCX1WDxD2nAY53F12moPaL+RxTCLiNB2gYbl9730iZuJpRF1/OBIw3xXTzO/eYIYjV3JGfLw
	WlrNN6B1Cm2zEFhdO5LHq6QzqgsJmnPBzf4q1MMVdqYkinA3jUkpmUmKQYJxv5sYCiMgq9Wyzx8
	E2b4t9j3ih5wTWu2XD71djA=
X-Google-Smtp-Source: AGHT+IHjAdmF70MFm5stdQrkzlR7rmei8bejitg9as7edXpa/8I6sFYvUuMceshIDQ3INEI+4auImg==
X-Received: by 2002:a05:6e02:194b:b0:3d0:10a6:99aa with SMTP id e9e14a558f8ab-3d2cae4e70dmr136608695ab.4.1740439849909;
        Mon, 24 Feb 2025 15:30:49 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f047530b3bsm125641173.132.2025.02.24.15.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 15:30:49 -0800 (PST)
Message-ID: <54284f45-b597-415a-a954-5ab282747704@kernel.dk>
Date: Mon, 24 Feb 2025 16:30:48 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 02/11] io_uring/nop: reuse req->buf_index
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
 asml.silence@gmail.com, linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-3-kbusch@meta.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250224213116.3509093-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/24/25 2:31 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> There is already a field in io_kiocb that can store a registered buffer
> index, use that instead of stashing the value into struct io_nop.

Only reason it was done this way is that ->buf_index is initially the
buffer group ID, and then the buffer ID when a buffer is selected. But I
_think_ we always restore that and hence we don't need to do this
anymore, should be checked. Maybe you already did?

-- 
Jens Axboe

