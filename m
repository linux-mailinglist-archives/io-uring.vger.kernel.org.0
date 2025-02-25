Return-Path: <io-uring+bounces-6748-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BECA44376
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 15:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C90C7A44DE
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 14:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BC8D21ABB4;
	Tue, 25 Feb 2025 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fHsqd/Kc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B57921ABA9
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 14:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740494834; cv=none; b=gQgTa+9BmUHzWWXQ0sCenhePSgv7cVq33Y7S2YqEHzKZIQBXqPGlWBMgOYeQVLjo1fCRFagjj+RlGf4+ZXrBgPnwEa67d8z2ytjs068qmPiUNHFFI+T7kTXkXW2sYT6zqH+IeTywUYfb3UCSBk175GJ3MPep2RIqyn32MSGDEr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740494834; c=relaxed/simple;
	bh=QwABXWy1fKbn1nAt5j/8CP3rTsH3O7QMG+bUCBwo5G0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SYQToPp2h7nIKsYcGUiPAuHNyuHQn5AoxlEtmbIuKr0NnMDpRn5A5r//VIOFV8ym9NwOZi2/CgPYn5Yd+aHTDutgVjHPRcmDVjC5zdrrBBQ+Po1VBu9IStF58MSGjbE7TqXC6g1zU5F3FvfRhopgi5+OhlYnAHilUgIBQTjgNNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fHsqd/Kc; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-855d6bdfe05so130347639f.2
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 06:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740494831; x=1741099631; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rcG1XxD6FnOBpx42YqnwfJDuehBu+OPJCV0NDRzKGho=;
        b=fHsqd/Kcx9LMy8KVqzeTwKApYnbQZ7kE3JGm/JAssA1+ATwbe//eXG7o4n8PXLWREV
         3Ap9Oi2q00z6/T8eTSwnNQlL+CknlAgnAjE8QPcpJq7ObOEkFlQPJmmBuR7NIlyZna60
         8tndmos4ct4CUUlbzhHQUK0hLOUU1/TMme6qW2iP0dn5gmObiSFpFT3gv+XNISn0MXoo
         wVSnY5EE6O3IuOpCnKJCiPBFjkE3uRKgptqnmzauhqWKSedCyQri9RT8PK+SYzpzwK3b
         qSdsL7kDbSsxzNKeCS5cvrf1THk5Jp/z1sHO7TeDvOKG1jVkC3O563vWpMeOH7GXjZqf
         6t+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740494831; x=1741099631;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rcG1XxD6FnOBpx42YqnwfJDuehBu+OPJCV0NDRzKGho=;
        b=VeCy8PwUpRGV2RmhwElY2UbzMF75Al9EuvxR7sZZxUEguNFqXYUL1cugJs1VqNj9fH
         4BPp3O+pQfZGcaJH67SIns05E75AvIDW9wKE4IxzLyKUcoeJZ7iMYciyxCuXapnWc9ex
         ZFoQ3nKiX+VRjqdNoZqk3FYW9vwwY7QohG45D0ibXEHVyC758nMIJ543u+r71VzlEeSn
         pTdbxda6NgAnu1DSpNNouqWG9HJhjm/Gk0oXLy+AoiKEaVjRsxE8PazIJP5nkrCWXQUM
         ErL7M+Zrz05t9xFzrURgHf03KsZXwr4j651TTAwreehoEqJgATCrOBIvvT0FPd1YQrhn
         pcvw==
X-Forwarded-Encrypted: i=1; AJvYcCWU4I/c010JGiFB7MfZT/xmAmyazAByjzkzbxrP2D0yaHV1CRCvK/I6HimWuED4AM0+PQ1MOTxgjQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3S3vvlPlgLp9ssv3ejaDtONZzp5BnUYjIpm9pR3IMGEovzBnA
	fC1I071dVxGwElybB/v5xwlHUp7CSUYEmE5RFrQihInzUZjQzfzyWKhKDgP0b4O2NDVduidcS1T
	l
X-Gm-Gg: ASbGnct/3Dl1o8Hg3I4vg9exJw7kVqnMTkhD7vDz1QNH85SI2PtJhJaH+t6e7WBn65L
	ii2FAdarNpAwFy8sXYP174Iy3uUg50fSyEfxkmFBBSyxzimjUwHP1FlThoMJcxawy5/UylyjWvA
	zOhoD53aQZiua0nWN0i5GIauLWxlevb4i0oY/9cmVx9S6Zg4SRUY6Pb4jHIYZFXZL/JbN08Uryk
	zg/3aAA0JSYk/n8TelGwnZY14I/K+CJWWL6r51ueTrYwPL/GwzPIX1XxW0z1YT/F/wqt4kmzntC
	gz2loLWyr/iqAOMhBatJEQ==
X-Google-Smtp-Source: AGHT+IFVZ6yoKor7LCidCg3vshthrED33BTt9nHlIDKingFnGezqVjoW2ywwFd+pEsCuboPa/SxJrw==
X-Received: by 2002:a05:6e02:339b:b0:3d2:b0f1:f5bd with SMTP id e9e14a558f8ab-3d2fc0c3657mr39396875ab.3.1740494831293;
        Tue, 25 Feb 2025 06:47:11 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f04744e8e9sm434255173.12.2025.02.25.06.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 06:47:10 -0800 (PST)
Message-ID: <bce558a2-269b-456e-bf28-d0ac529bf929@kernel.dk>
Date: Tue, 25 Feb 2025 07:47:09 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 00/11] ublk zero copy support
To: Pavel Begunkov <asml.silence@gmail.com>, Keith Busch <kbusch@meta.com>,
 ming.lei@redhat.com, linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <6354970e-bbd2-4435-945a-efd9e0f71eb4@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6354970e-bbd2-4435-945a-efd9e0f71eb4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/25/25 7:10 AM, Pavel Begunkov wrote:
> On 2/24/25 21:31, Keith Busch wrote:
>> From: Keith Busch <kbusch@kernel.org>
>>
>> Changes from v4:
> 
> Should we pick the first 3 patches so that you don't have to carry
> them around? Probably even [1-5] if we have the blessing from nvme
> and Keith.

Yep I think 1-5 are good to go, I'll run a bit of testing and queue
it up. Last bits look pretty close too, but indeed easier to manage
a shrinking series for a v6 posting that can hopefully wrap it up.

-- 
Jens Axboe


