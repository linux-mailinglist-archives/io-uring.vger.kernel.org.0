Return-Path: <io-uring+bounces-2277-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA4DD90F16B
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 16:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C89C21C21C5D
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 14:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6121E492;
	Wed, 19 Jun 2024 14:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Q2nB522d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161081D54A
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 14:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718809056; cv=none; b=Hw55p+p6Ry9GCRBu9SnqyF8woMiSdeaIZ58FJodS01mxjlHJkTGblO8+tP0/tCsX4G2HvZI3Nd/poDVEktjV5W+5SoN8RT1YiftnSogqTlwskjBkYY5+GikAQtptR9Z7SXn45nNlvuHoovtVcDfa55a89udNMBJj1z3uodE+pIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718809056; c=relaxed/simple;
	bh=w9PfffJDK0QmN0ptegEljBRwI/+zt6IqjV3Luku0AAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DyPUZcpN1USBuVKHTjylWGxRtRQB8zhHes1cTpKm4DFJrsGiPHXxcpvjdcthz6v0Xa99Vom+GCYjE6y9IBV9xWpHDg7L0pms+HrgeQon6h9UBR4fmtH9AVAn7vPIBkA8u65wHOLx85O1OBIt3MNXpusdLqH4MR+bwRHFW2QEgsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Q2nB522d; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1f4c043d2f6so6289645ad.2
        for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 07:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718809052; x=1719413852; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oeWtfPo8jUgBkRYFxxYWXE2JuWF3xFoK1qTZGlxFiEs=;
        b=Q2nB522d4k3sN5dKl8BrlXqL6SiWmg45PcRzw4I8qWEaNK4WZ56arytQzQUuSxWO9i
         0qYFX3QMzL0jnL0Ens/ssb/lCFPeV4MYPUKtQX60gBgIuTlGLhHMe0tJ7xfA2w+w9NKi
         buZt544ypVcEIRw53+EV9MSH339ZwHbkhvfVDDCtwmj2W7wHjkPFNYcdAGutkPOZxDAs
         7wA5dTeFQ2KiNcniMZBzZerv5cd65R4MGcFG6tXIDyly4rdfPyNqbfbVKZrBdgZJjumv
         58yvlzgtapIof7TAP6FtGKWSzvWtfOS0asDw2xh9xYsooFAJJDslPNelA34+UrEoSp43
         4ITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718809052; x=1719413852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oeWtfPo8jUgBkRYFxxYWXE2JuWF3xFoK1qTZGlxFiEs=;
        b=WZfkk2Um5bNvMP2TWhVWit7ezrtNc8sjBWM07JPMt7HlBFfoJw766gotWwF3w5KxLd
         cZDF88NJfZZja77Zw0zKOicKTMcwiK1Qbr5GJSHProZPMtpbt8KLlqWnuiVxh0WJqVt1
         vIwgTFTECQLJKo0uKPnJT6wGd1oGH5ZAkGWCa1ZylEIjHdCNXNJAxBunbdGd16+Km4Qh
         v6rIFZ5fUCzT0+sipw1U36cCzTymS7pLAseBuPlSkxFmt14iyQufME6O9eOf1Y5Fjgen
         qyZOLVtPT7lq8aCuwn8NBqUdN9ur0DUqod6YQObNIF8w1+AbSCDuXg/4F2X6yLCWoLzm
         pUcA==
X-Gm-Message-State: AOJu0YwrnbDuX5/VfjIh+tBC2gxetBShyfsmI4H6c87ijm5VOjWfncni
	WtWkjtjhzKJqzlXIs9JVk10DvwjMLp728d2uhWZuQDqk71mGbhy2PmVYF08zq6Q=
X-Google-Smtp-Source: AGHT+IE5/Jx5XSb+X8TNBujVMcxHykeM65zRSspOIdAnI78xrTAOjxxqYrb39tozcW0tMcJCLeOFdg==
X-Received: by 2002:a17:90a:ca96:b0:2c2:c967:3e56 with SMTP id 98e67ed59e1d1-2c7b5e659f6mr2678871a91.4.1718809052335;
        Wed, 19 Jun 2024 07:57:32 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75efb12sm15429411a91.18.2024.06.19.07.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 07:57:31 -0700 (PDT)
Message-ID: <093a9aee-1e7d-4145-9780-c1af80214495@kernel.dk>
Date: Wed, 19 Jun 2024 08:57:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: Don't read userspace data in io_probe
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240619020620.5301-1-krisman@suse.de>
 <20240619020620.5301-4-krisman@suse.de>
 <007e7816-64dc-4f3a-b35a-5fed4625c697@kernel.dk>
 <87plsdhthw.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87plsdhthw.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/19/24 8:55 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 6/18/24 8:06 PM, Gabriel Krisman Bertazi wrote:
>>> We don't need to read the userspace buffer, and the kernel side is
>>> expected to write over it anyway.  Perhaps this was meant to allow
>>> expansion of the interface for future parameters?  If we ever need to do
>>> it, perhaps it should be done as a new io_uring opcode.
>>
>> Right, it's checked so that we could use it for input values in the
>> future. By ensuring that userspace must zero it, then we could add input
>> values and flags in the future.
>>
>> Is there a good reason to make this separate change? If not, I'd say
>> drop it and we can always discuss when there's an actual need to do so.
>> At least we have the option of passing in some information with the
>> current code, in a backwards compatible fashion.
> 
> There is no reason other than it is unused.  I'm fine with dropping it.
> 
> I'll wait for feedback on the other patches and, if we need a new
> iteration, I'll skip this one.

I think the rest look fine. The unsupported part was mostly a thing for
backports, did use it myself internally once for the meta kernel. But I
do think we should just kill it, so fine with doing that.

-- 
Jens Axboe


