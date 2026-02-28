Return-Path: <io-uring+bounces-12484-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 7nYMBzTxomky8QQAu9opvQ
	(envelope-from <io-uring+bounces-12484-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 14:44:20 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A1E21C34BE
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 14:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF6943049973
	for <lists+io-uring@lfdr.de>; Sat, 28 Feb 2026 13:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B88280336;
	Sat, 28 Feb 2026 13:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GwwnzOIB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C631E98E3
	for <io-uring@vger.kernel.org>; Sat, 28 Feb 2026 13:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772286257; cv=none; b=jtuRX+9kNGq9L9PY9HpVeODs/0h8V0Q/B64kb2IqjBy+PQuI3441mIY7afHbT2dmDlINRH1L//18RvKWKjqvG7Y+lumBoY5gex/WLsADVHDoMR3X4lNDBC1tlYgaCAqzsQxENQJKdJr7LgmQJ1z19kHqecQuEX9V1gy/qpD3Edo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772286257; c=relaxed/simple;
	bh=fP9C3+xfEgnVSFCNbvnYqWVsW/6XUMZCO8WGiPtfBhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KjJquakemovBMZP9twY3ouTyZf/Ael3Q0MINiR0DGue1ibuGGcQnCtzT17FkhQycFfypizJ2JvVf1sxNhXt+YOxWrCSnwaNf3+ZXg+mOKF2z/gMtPLkvJAU/J+utLk3MbCH28q+M5v4aMdvQgFHFnWsOqG377znCeXKS3aMKDeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GwwnzOIB; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-679501fac3cso1968090eaf.1
        for <io-uring@vger.kernel.org>; Sat, 28 Feb 2026 05:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772286253; x=1772891053; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BVnpQKUt3Nzv07m/ftUSGx1pk5aquKdR1wzC0DScDNY=;
        b=GwwnzOIBFX7c/wmGPxKGOD+Chh/ydJ9JuuZnEXtEGdhORFUF1IU2Z9KFCGw8VTm4QQ
         QjVL40LFJcsbAIG8x2/hAIAE5AkVicALuHjFVG8iR+bcZJCWh2eJ7JnxplxzErpL/kpW
         DNHQejP+To9hMSHQ+TL6DN0VqX26CCMHXZOEdcJqZayMmTlLdnYlArnMLOEEcrBr3xnc
         SJdqlzz4jxFcc09ByJQLl5bBLMDRkQp36JPZjBo2Bl+xPlyO20cxuQYE/n63sxQ0396R
         gv7sLT9YRD+QBOST9iX2hxOY/xQo85o6XDQU0FY43Dibh7KilsvqVsmE2MMECnrnjZFR
         jDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772286253; x=1772891053;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BVnpQKUt3Nzv07m/ftUSGx1pk5aquKdR1wzC0DScDNY=;
        b=bhKnHIIEODqGMsJ6kvc5wXuDVmXN17dDs3oh+9Qb+UAA14llJtnhN2dHGQflX4NRZY
         o0O36DuHyj/pLMOLCc3kihVHLawRu1VCFD2e8PtRfg7gFRLo1X3pW8Bk9r4GiZv5QtQJ
         VTo64ZuYOacD8SnmvKMhzleeA52rXkc2+6t+Zox8gs+EQxbLnccpjfDxdfTDYT8kcBUc
         4tEZRP2kq5m+adogTwc1UGxgBDoxVkRTgtJIefrjq6ONw/HW5fRCQaEw6hlP049Vj/jk
         6YGKfBGx2hBD5JbxLuHX2BebRpGOkpzLe3Jhb6N7N7AJJh5/P5gb6kVcewkHdXS7EuDs
         EBpA==
X-Forwarded-Encrypted: i=1; AJvYcCU3yaK7dOf3jheIfLnURhGtiHjj7j6wzrXJQTe99Kb/d9kHhjlZyOcmor8r4EiTvc4OZlGrvEeppA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxGJLBiZ5yRdVKT6ew3vq6syQ27ru84d6ZBFf6uZLkkCpsD53cl
	XfQ5EMq17FA9JGprd1dAmw7oTtfzLzsQWpwUGtD5fXGezVFy8Nx674uG/laHIvQ/cR7crY8h2bB
	UhV6vX3I=
X-Gm-Gg: ATEYQzwEaTy/a/c6MChBrmfF9SzPEMwmKVqrVK/sGNY4uDzvXhB2QBliK4+mtnPdQpU
	+FT/a2qh5m0zCW23/l9sneK/KwR2e24lqAbGSKzEEDnQiipZfP9u+pTx/qRAn6XlUpT6+7EAkBD
	XyAD3YnFC4718oi4C6NWd/PpaGhiM/Umlnrw5JI4ZPuADm48hehLE00Pd8YkJ+ihiHvaKMTQWxg
	NXyeWr6K4SEt5Uj2TRyxNwObXPrufGKM2ThuaRDuwnBhTX6wLIpbdP6363flFIjvax5Dyek13Jm
	CQJJxkWqSHMs0l7itHVelMTcAfvxOaAiYjYNGjzJaOJsFcsRjSSCMMqYt9A8e9JZXHMJfhbqBZn
	WLepCKXdJJ2S0nFL4cfFPSOBxymGxU/wT19Rte4upKHuHffhE1ZimsQFda03/qmECDQp88XewUm
	ek2BLmEEsxIu4L73FS3CB3syukHR0gY1sHaRtUtcJQdSj4ICuUAvivJ1HS9PYOKhRXSFXA0IWcM
	HWCXtt3XQ==
X-Received: by 2002:a05:6820:16a1:b0:679:e750:6c06 with SMTP id 006d021491bc7-679faf0f946mr3927700eaf.39.1772286253411;
        Sat, 28 Feb 2026 05:44:13 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2d84dacsm5423012eaf.9.2026.02.28.05.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 05:44:12 -0800 (PST)
Message-ID: <b4c878d6-dcca-421c-a722-84a1fc77a1ee@kernel.dk>
Date: Sat, 28 Feb 2026 06:44:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Pavel Begunkov <asml.silence@gmail.com>,
 Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
 <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
 <a6cbceb5-2065-42ff-bcca-bdb1c2443b96@gmail.com>
 <1cd9a071-dc93-48d1-81c9-24b65e65e8bf@kernel.dk>
 <dcb21382-36a6-4d5b-8e79-66290e522f2c@gmail.com>
 <2daa9b01-d989-4922-b892-e7f3f06297ac@kernel.dk>
 <cc9ba4b8-88f1-48c9-8aae-fe30a6b5c282@gmail.com>
 <e834eb01-6cde-4249-a797-ed1fd9f8c713@kernel.dk>
 <2ab205f2-fd87-4fcc-9c0a-0bdebbadeb58@gmail.com>
 <3a8e5738-b417-440a-9851-b8ecc2a82b82@kernel.dk>
 <11058b2c-55b2-4a4f-8d80-7533211b16bf@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <11058b2c-55b2-4a4f-8d80-7533211b16bf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12484-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,samba.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 5A1E21C34BE
X-Rspamd-Action: no action

In the spirit of not pointlessly arguing this to death, how about a v3
that includes the ktime_t conversion?

-- 
Jens Axboe

