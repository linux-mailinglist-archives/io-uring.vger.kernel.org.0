Return-Path: <io-uring+bounces-10978-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4759CCA86FA
	for <lists+io-uring@lfdr.de>; Fri, 05 Dec 2025 17:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 768B830110D5
	for <lists+io-uring@lfdr.de>; Fri,  5 Dec 2025 16:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD582F361B;
	Fri,  5 Dec 2025 16:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fabrTwxi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4DF2FF649
	for <io-uring@vger.kernel.org>; Fri,  5 Dec 2025 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764953522; cv=none; b=ecd31bUBEKakAR9uTlQqKQtpq3cvlQ3q0iSLPry6GsIjvOeB43X2luS/yaeEa8rfg568H4omLEGeEML45GGtsDmLWVGTI0aEHhuNdE4Eu+COyETqtUpacJIGJ+YVRJ3/lyY7a+uQuktWAVqI2zcO0zKavjV42kfEn8gs9YmbFTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764953522; c=relaxed/simple;
	bh=QzuLGRipWOC/i4TGGkw48UmyzLOZNHkWBStq5VtcqZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aoug1MgKLnWpS87xHpVzrY3TA7OHbOBed+mv9LT2PFSgdSqLJvhQti0CLyLT7WBl3SIa2u2InZPNhy440NGJ/KqgjpJ7EPzz/2JiJ0Ymj7KC5LUCR2vneK//bhyduwm/PLrGWbzUZq+iEm4szIs7ThUbK1Eza1KvDWptFY7qrcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fabrTwxi; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6597046fcbdso719422eaf.0
        for <io-uring@vger.kernel.org>; Fri, 05 Dec 2025 08:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764953512; x=1765558312; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+wYx2qN+3jSudKBPqDqpxWsPORO9UYKA/Ux0+uby7OU=;
        b=fabrTwxiNFBrgLKFmIMXzZxNfXbSSJ/bRCpzOSxmfIKHh0l9KNFiBvmuMKbdbJnXyX
         vON0kek2mfoRULMdtz4oOYsbAQTIqMqiqB7aPlugg/d03BJ3Ra6jnVFfVWGCSRBCyycE
         rWzIbebRCV1+xNmBxw5FG7YRWOVQm0AbBepfntjSokboOBW81dRxj61sZxepUTae1qs7
         j3KuUfQCAoM+Fxqs7idu4lHkyfSIzuwerS0FbWviuzqe86kvZ2xvOdFKOflfv2oQjxmT
         qapbgelm4EeqioYadzr/f9IQYuHW6lU+LcY58325epXw6zluPOCWAtkZ8YafgloL3ZWY
         /ZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764953512; x=1765558312;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+wYx2qN+3jSudKBPqDqpxWsPORO9UYKA/Ux0+uby7OU=;
        b=EcO2C6VY1rpiMgGr4vj+CNRxy4jyPGMv6DtAIyAsaRLeK6j57sjKqeto7/pED7LX+L
         ZsEUwALKzx1FB2XkA9g+L5Jkfd57ed+2AI1F4OC9dkZ6diukj48uLEyGHKpYxxVpuZlj
         BMXQ7Z5XrV/lm49bhNEP+Kdq3Zh2XQz7PQaXFvmxlQVim6yNsoGpXczPowKCgMzs5MGw
         BHN95+0IdRN1Xw/oQcr+MkxA0Zpf1rmlj3NtNwE8w+WgO1CKM8n2lol+L7QFLoBNnTR+
         BnY7oO6P0SLiv7RH1DiS//YGidmbg1T9dq+sXYyxRFG15VNhVL1QDBpJci7L3Skp84g3
         BIvg==
X-Forwarded-Encrypted: i=1; AJvYcCUYTjbXdQCG3Hg0KYYVBdqrQWFvhjWOV/vUsqkgdzColm2zce/cZ6NvNmI+x+Z1dmX2j3xSJ1XoHg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKzG9p5dNSsKtCY7WeVNP8hXoEO888BTTDiKz7VNEuGvQ3X7Kt
	EsIJmRu6Uysz7t3g3ZYkR2nSJ8PacOjTEoNUV2LOVkZDPO7IH4bPlOLZLEV2PlJMsFk=
X-Gm-Gg: ASbGncvKn1KaPhLwl0D/4nhlEh6UP+ldLXnDiOzml1XBXQGzIAER4wNzwSw9PobYwVM
	gqL/MiLWGfwjySLFEuq14cGUJEkXU3jAnqxRCJvmVxvXILO87Lw05LbSWeT6OoH/GgNseI8XZLq
	xWeUkk/kB9gk/9FoWo+TDp164Zbo7leqljenlk62hqW6uv2oIwbX2jTtLcqh8uT59dcwcw8YA/T
	JqFoby8+JBlpnysuiv72B9jZBFemC3wjjd/scclt7hxIDDl3vChelhVc3iaFoyyp80xBaz92if2
	zje7AFVCqTEKZRPVfgr2GhJJURyFOeiv6JVSrQLr6O0wamlKWy9FT+zrnn7VZyoHBmtHIFCNVcN
	0/85WF9SWiFHei2XYNkYgwGARetcj8FxcaSt68UC8a9v8xqRw8ZWhWfph8Gvle0Cc49k5KR59zE
	xprS0Szz8=
X-Google-Smtp-Source: AGHT+IGbe0zH6GzrVJtUc+0NUfNTLzMHm6Rpv3olf0Q/S84WeKv0iY3CXMF5EesdnGYVgQsMArXQyw==
X-Received: by 2002:a05:6808:1a16:b0:450:cb51:a55c with SMTP id 5614622812f47-4536e62f641mr5858807b6e.65.1764953512626;
        Fri, 05 Dec 2025 08:51:52 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-453800cc729sm2426316b6e.10.2025.12.05.08.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 08:51:51 -0800 (PST)
Message-ID: <27273a89-d4bb-4b64-9fa3-5edc3ff493dd@kernel.dk>
Date: Fri, 5 Dec 2025 09:51:51 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring/kbuf: use WRITE_ONCE() for userspace-shared
 buffer ring fields
To: Joanne Koong <joannelkoong@gmail.com>
Cc: csander@purestorage.com, io-uring@vger.kernel.org
References: <20251204235450.1219662-1-joannelkoong@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251204235450.1219662-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/4/25 4:54 PM, Joanne Koong wrote:
> buf->addr and buf->len reside in memory shared with userspace. They
> should be written with WRITE_ONCE() to guarantee atomic stores and
> prevent tearing or other unsafe compiler optimizations.

It's not a real concern, but I think we should still do it purely
for documentation purposes. But because of that, I think we should drop:

> Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")

to save me the trouble of ensuring older stable kernels get this applied.

-- 
Jens Axboe


