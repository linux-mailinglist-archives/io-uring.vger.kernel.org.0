Return-Path: <io-uring+bounces-5046-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB2E9D8F44
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 00:43:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB471B26040
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 23:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6E0195985;
	Mon, 25 Nov 2024 23:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePrcCDEt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A77C1957FF
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 23:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732578229; cv=none; b=AzXIJuFFbkSCUahXZgT6GmvTogZTRkEpITioY8FzbjyFHC4LibjmgeA+5e8u841n1jgEZ5pZnEwfUNVnDJyDZsBE/H57d/tRGwtw3ScHZoJh2ywVy29nsUrk117+6I4x5kdCiUgcwudBeT09pAfEQkUUAMgSISCCg6vQ6eHb8I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732578229; c=relaxed/simple;
	bh=BlyzMJCLRfi2sdXbE2kEuePtMHcDPvolsoowakzlRJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FJptgPfiI50/RVJGSaVUKBkMGj1yZIBRndlsyzXgCjSmHJ7QAe5CxIVn27u4B5DYNonPnTcShrXHskPyl2CpnPQPuxobAL9Q7+8ibTULa0GOJ3rfCzde2vinuijFUTTz+1bI3USJzfCANADn9K+VnToGHqzYMNzipcou8tMJzlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePrcCDEt; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-382423f4082so3576381f8f.3
        for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 15:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732578226; x=1733183026; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fUfwl85LqUgycDcD3v2TLs5fD6P6U8yZIMyMGVULmto=;
        b=ePrcCDEtOHyuHG1L9JwzRAQ8g/kAVUUiIIn1E1ratToLCflRcjSKX8+sKJNx15Evxk
         ButlQ6tZ2vz3Ngd+oZj/sWiV2IIeNprFbO8nE7pty4mDyfLMpUyz6Ydwa1aYNEbh+QHB
         TsNfolNxnkCw2Ix0CACoCirIbQjJuVpRYrZINz6XIZ0ljDJo5u/UopLuNq/a7+wFTl97
         VSHwx7Momb7E57Kgb2MiuGym+xirRKo9CZXnKBEOulOw86QpoEUV7inMGvz8DK/sV/bo
         1gRgq//fOLAKpt5V7aUu/RrP684JfelkwI9TU9xKahST2BMom1oAR3BMyjUpPeQJU2lx
         XMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732578226; x=1733183026;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fUfwl85LqUgycDcD3v2TLs5fD6P6U8yZIMyMGVULmto=;
        b=vGbTMQupCUk8dhCmySLX5YRKm3n4LyIlkGO6NGrY4rCozwaS1TutkIzXBe9SFRwg+D
         DKuJjSssoGeoCf4An66KYB+iqpPRs+l4MCdJ/Lk5bWAOQTY0CCl0B7WWv+dtjjMzR7Lu
         OWgbnYDB8Y/lDofZQlfxUnanyZMr0aXtLFiGLI4f2ASWF3jkFqIoU/BB3AMMJy2GfJWT
         oES6VGqT/LDpvgyVaEpcXxzxENsVwD5OYOEvZBHxxv+SihCr7PCL/lUEyqP+KDpw7Jag
         U2xsE+hE/6S1L8EfHiWG9J5iwJN8Eoo4iCARW8UBF/Kwe0wL/YkcupBi37CpVkYj2nCT
         LFtw==
X-Gm-Message-State: AOJu0YwBuG1zQf+/zhokNE6vaCfPH8lUPkRHed7j9TxgM5QyIfVDzFKQ
	k2BkDzJzBrPga1TeJbbMuoJ+t2voSdQVIUMu3WJudaMDUI8BQcTbjoC/4A==
X-Gm-Gg: ASbGncvPMRwKpPz8ki/nRfxkLyEBsXPW74hnA7Cnq1l3nsnkQyXx35R3yvBFdePXgYS
	pdfEIMTfHkum7W2ho4l9A5P9qjMce7LJWGCtMj6Hmu+CjSOgQiRgteeNA2yFpWK24mtDa1sILOD
	NSoFQn3voLuFUdZaV6/LjtMLuFUaXsP+KPX4RKLzqEpE/EuUU3zZd6R4LHLhKWvULtSZrCRJ77S
	fEZlAdQWf771CR66l2o2Ckp/cxb3kUJTGh7R4wyQNr3LhJcRlXBnsMOWHc=
X-Google-Smtp-Source: AGHT+IFG6J0Go1/Yuq7tZYcBa1M44wO/eUC3eyR2g0wEwJohucXnJojd21iQpH/iim9i84ijpO01cw==
X-Received: by 2002:a05:6000:2805:b0:382:3afd:126a with SMTP id ffacd0b85a97d-38260b8766bmr8949076f8f.35.1732578226162;
        Mon, 25 Nov 2024 15:43:46 -0800 (PST)
Received: from [192.168.42.143] ([85.255.233.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4349ca82957sm78293615e9.33.2024.11.25.15.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2024 15:43:45 -0800 (PST)
Message-ID: <5a46cd63-8564-4c6a-bf65-83273e6636f4@gmail.com>
Date: Mon, 25 Nov 2024 23:44:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: sanitise nr_pages for SQ/CQ
To: io-uring@vger.kernel.org
Cc: syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com
References: <9788f6363f9a7fc100f8f9fb7a1a6e11e014cd30.1732576266.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9788f6363f9a7fc100f8f9fb7a1a6e11e014cd30.1732576266.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/24 23:22, Pavel Begunkov wrote:
> WARNING: CPU: 0 PID: 5834 at io_uring/memmap.c:144 io_pin_pages+0x149/0x180 io_uring/memmap.c:144
> CPU: 0 UID: 0 PID: 5834 Comm: syz-executor825 Not tainted 6.12.0-next-20241118-syzkaller #0
> Call Trace:
>   <TASK>
>   __io_uaddr_map+0xfb/0x2d0 io_uring/memmap.c:183
>   io_rings_map io_uring/io_uring.c:2611 [inline]
>   io_allocate_scq_urings+0x1c0/0x650 io_uring/io_uring.c:3470
>   io_uring_create+0x5b5/0xc00 io_uring/io_uring.c:3692
>   io_uring_setup io_uring/io_uring.c:3781 [inline]
>   ...
>   </TASK>
> 
> Apparently there is a way to request a large enough CQ/SQ so that the
> number of pages used doesn't fit into int. Even worse, then it's
> truncated further to ushort. Limit them to the type size for now, but
> it needs a better follow up.

Nevermind, syz says it doesn't fix it.

-- 
Pavel Begunkov

