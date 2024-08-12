Return-Path: <io-uring+bounces-2719-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA23894F675
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 20:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A609C285512
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68A118E030;
	Mon, 12 Aug 2024 18:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EHafbL9U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E485318E051
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 18:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723486413; cv=none; b=j088IBnHnNpw5UkGC50IXRBs2xuMMr9c442x6xLEaEesvQdkVjKzHjVRMfqSI1Irjnb5GUdN3jbvANwo4ERTNVW+0tpI3p4nrgnnKi6SB90dFEbLrwbkFsQRS8uJS4MhHrp2N8gyVbI7awlTbeHwRSzRnN+XuabYW27b1/QB9Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723486413; c=relaxed/simple;
	bh=lGYnjD12ntB99VZgX5KBZnTecsLt680C8I6vALCs9UU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DZuXVnu4NCog8fTfUsg/q/09VgQuNJ9vBxXImTkgQi4mdYLmjaT/GxSB5f2tZJcvSL+tKICrxUDh2Vf2pmcWWF5cBfGMrzK9M5dARS7RpovA1wUBOIssm+m0DsXFBvK3bHAavyp2ow35X69Pi98904n+7BxX3QlBUHMmUzh2ois=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EHafbL9U; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2cd16900ec5so881972a91.3
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 11:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723486411; x=1724091211; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UquTWnSmGqYvXYChbfh65tuFwrqqrsNEij4kjHjKkyM=;
        b=EHafbL9U9yJcJUk0bmWOkGxoZY6xy4gyGqQxExV0ebfrh2tUNKcJL2ybGPmrdzJPVZ
         vHlDT0xUjNp4N9/UfktNvFvhG8l3yFwjf5DJLlJ8WAVy2tlBljKGV6Yd9WkzBXDN1unz
         pxkjsKBysZNjFghtu7MVQ0sp1beavNOoXn2UA1IrJtddtXjFVCZ7sp0OEy6om42UmhRN
         8DYUsNC5FL6D2G81XJE+0LtZI9qOEMZU9dd90sXMj0P4y9uf4TckUZAY78bIjiKCNhC2
         ojEM6gP2vm/fF97GKxCeYa/lne6ItqWnlK111R8pZOVC4PnDKA5Br+iqTd//NS9eqyKG
         lMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723486411; x=1724091211;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UquTWnSmGqYvXYChbfh65tuFwrqqrsNEij4kjHjKkyM=;
        b=wTdMG4jO/F3VCeS3oBIHMKaCpK/4SeuDzjpnkmYNmb/QODpEQGbWZvxtBEm6vVOutm
         CZNqdDsPRVheLDMx79NtnoEPRB5iJVuRpc8kKIFHjkToJ1eg8bb7UqvbVDHczzDzR5vj
         n0MhpJUOewIxRofefoaO+CRdwyevBTooFuUULK0WKfJQSqzEoWmdmGPxxK1fhVQQVxkx
         P3uvAsL2qbTOIiT9PX71nlBWB4a7TlcFn7IPRYYUmQMz/k4xFkNSQYTblstNzGJqCbUG
         Kt6n/pTzPNN0o/YwdG1Z3af+mQUM3LAXx8r9fMLhSaaLC/j2RRpCQUzwKF+s9fZo2M8d
         0olw==
X-Forwarded-Encrypted: i=1; AJvYcCUICHAd2kqc6j/3pKIYZ9lG3GM6i1TofEE177ULAmg/l0XLYHEJU2JHhkw+ELvPD2cqyXXuLuIRezvSsdCEfzcMbuTaiefeuRc=
X-Gm-Message-State: AOJu0Yx0NGDpMGxX8x0fSILA4z7yya/wdTdlf8VUpgU5n/7ocy2bRw7M
	f+9EVcOoClaFYXCOZ9eeaNhY9QYPePaCLfiPrtaPPPo2Af3FNThKzwZpaPHNHPVV2iXxxreaFQZ
	B
X-Google-Smtp-Source: AGHT+IGKI44/SMgXvAPF97mdABu+cpeQUJnDXejBrg1INn+IobVuO7JKhvMgA6pYRKZqmOjGXBG0LQ==
X-Received: by 2002:a17:90a:b30c:b0:2cd:b59d:70c1 with SMTP id 98e67ed59e1d1-2d39251b043mr688993a91.2.1723486411144;
        Mon, 12 Aug 2024 11:13:31 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1fcfe4adcsm5465444a91.37.2024.08.12.11.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 11:13:30 -0700 (PDT)
Message-ID: <98f30ada-e6a9-4a44-ac93-49665041c1ff@kernel.dk>
Date: Mon, 12 Aug 2024 12:13:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] clodkid and abs mode CQ wait timeouts
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Lewis Baker <lewissbaker@gmail.com>
References: <cover.1723039801.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1723039801.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/7/24 8:18 AM, Pavel Begunkov wrote:
> Patch 3 allows the user to pass IORING_ENTER_ABS_TIMER while waiting
> for completions, which makes the kernel to interpret the passed timespec
> not as a relative time to wait but rather an absolute timeout.
> 
> Patch 4 adds a way to set a clock id to use for CQ waiting.
> 
> Tests: https://github.com/isilence/liburing.git abs-timeout

Looks good to me - was going to ask about tests, but I see you have those
already! Thanks.

-- 
Jens Axboe



