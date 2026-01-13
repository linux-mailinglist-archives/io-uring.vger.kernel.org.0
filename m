Return-Path: <io-uring+bounces-11614-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3751AD1AD32
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 19:23:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EAD39302FA2A
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 18:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826CE34B68F;
	Tue, 13 Jan 2026 18:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TIEOcPUt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53B130F555
	for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 18:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768328581; cv=none; b=bQxILNSJ1xzENq4yESVfYWV0xl3n/+SIQZ95yFtq4GZFmqD/Zs7VLPwb48GCby0XvmLcflQobCp3EYvFwpY+kym1FzdXyk0oOVpvXYrxR8q2PBOYJzoBL8Q4E90gOiSGus8WUMwnhadC46diYNYPYK0SFQxteYyX1CnsDD9NjBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768328581; c=relaxed/simple;
	bh=MMPzk/e4AMmxAUGgW9q20nW92rRsSGMn/06sJrIDQUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LZz+Ci5mTJQq6NBJfSH/t2r5ZfiG+ZIDpGvZ2qNTA6bVpJb8XqqGgxwxtb5hCiGHcX6N4y7UequQyw7yu32xXsH8ergu387kZ9momRQ+fgMfOJ6sS4cqw+HPyFiTL64Qbwt5v0eJj6gPM/Yd0xzPqhAGz6F5aaAxIrrDWg5tj1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TIEOcPUt; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-65cf050a5cdso43823eaf.1
        for <io-uring@vger.kernel.org>; Tue, 13 Jan 2026 10:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768328577; x=1768933377; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pWBcSBEXpSdOY9e7pR1i4GM6CexzOAB7AiNAG/Wtm4c=;
        b=TIEOcPUtHMgPxGgAGVKPz6u4FgW3s5d1NAuYMVL9WszdE2agvopSb522GeVvBiayRk
         Va7r3V39l4KIun5Q+NfK+kjbmwJBma0MUBbQY1p7uERy+xrMTKBk3dqz71/XvtYfQwXt
         D7QX2I44cTbfpd5Y6hwcsHuiuIOt9KqtB21ong8av2lTa3LCn+v/nuR+p3C6d13xcgnt
         mDT5/yU1de46iJS6GKOa5fbSxE4DoxP3PV5N38YJuGU7xZonEHcwsKh72SjLGADw1/R5
         ts+fak2TCNp9oIf2oDacCrKjkU5rS8LZHkivnajdEaHHKIwElZU7E0qjJelFBdmgqD83
         oxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768328577; x=1768933377;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pWBcSBEXpSdOY9e7pR1i4GM6CexzOAB7AiNAG/Wtm4c=;
        b=gOGlE3WCh7663NsB5ZWKp97ZDp6bSgQAJWrtj85I139UuMIrll3mokRCj4tFfSPzEg
         mM28Ja2KqXNpvoLhqd8T8lEaauJBp9CH+rQsK1Dztt5Ds9tTvIGn2aKGGiCUBMrWMdvP
         ewmQhJ5gyiIpT4yAt9VpyOkbbmmqC0PyKmqBh3tAYFjUXLsknb+rphzmjG7CrRjUnZ3a
         T07sIpWodi04CFPIl2dAIYaGW0IeH1br75d1+zTz7ql6YneSE8KODmqFrso+jBkMgOJt
         Zvdqak/djbNaNYd8sIfaGFxNE6EXtl9kPp5d8nizMIyk1dARLLsOM2DlWe55Y293R2U4
         KuMQ==
X-Gm-Message-State: AOJu0YzRw21dOMeSPKol5lnNHX68/UNm3HDff5aFI0huxx03Id5UXTCO
	3qUsl3DK5NinCyNOIvfi5998PScr039SpdrCEdgdOsKbn7Uv8QKzEseqiudlB0dv22Uzq3EQ3eR
	rdX/7
X-Gm-Gg: AY/fxX4YtjXeYP4uYQZi63LpX4kySA6jgQd7lBQ/a4vjhlPAFe/NybjR1a19K//OnQr
	zUk9MVh4XKLO273cKyP5m68lNL+tA4DncHTtcrpb5m4pkRp3dCdpANxHYZwN5yz1vxB2DxHYNhs
	bxl/gad4W1zk4p95qcBzdVUoocsGmEvySCW5nj4ZmVCpLeq8Ft8cARfYPMxalxon4hpvJfnsWyb
	4GBYeoM/h/r2rlGtLQtPjXkSaFGL3tHtcpwPG+wKzSC4IspL/AsRLggICSx9Zmspz8P/DO9lgNl
	w1zMioaqrfkV79pj5JAcCSvUuyW/XEfwI42v17sbhHAk0TjrhpGiiQJ2ztWJDCXsN0O6liT6P0x
	7aUKFC+sr3x1KPSPgbpFRIGWFp3kGdXoAxhJWCWIKEzpfjdPihiwKnv92BK6HnaSuPK6db1rLtG
	Mq7GYjr+c=
X-Google-Smtp-Source: AGHT+IE7BmYD7XR4+dHwZFEK7Yh3iTgdv/dOYU8IM3WbC6+kYMZMf7pSbZmrmNKDIt4yzBEIjJKK0w==
X-Received: by 2002:a4a:e584:0:b0:65c:faa7:7077 with SMTP id 006d021491bc7-660f29d8ef0mr1346040eaf.23.1768328577636;
        Tue, 13 Jan 2026 10:22:57 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65f48bbb3f1sm9253570eaf.4.2026.01.13.10.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 10:22:57 -0800 (PST)
Message-ID: <9858cc7d-4e21-467f-9a93-9a5a6162e8bb@kernel.dk>
Date: Tue, 13 Jan 2026 11:22:56 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/5] io_uring restrictions cleanups and improvements
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20260112151905.200261-1-axboe@kernel.dk>
 <87v7h52zkl.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87v7h52zkl.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/13/26 10:27 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Hi,
>>
>> In doing the task based restriction sets, I found myself doing a few
>> cleanups and improvements along the way. These really had nothing to
>> do with the added feature, hence I'm splitting them out into a
>> separate patchset.
>>
>> This series is really 4 patches doing cleanup and preparation for
>> making it easier to add the task based restrictions, and patch 5 is
>> an improvement for how restrictions are checked. I ran some overhead
>> numbers and it's honestly surprisingly low for microbenchmarks. For
>> example, running a pure NOP workload at 13-15M op/sec, checking
>> restrictions is only about 1.5% of the CPU time. Never the less, I
>> suspect the most common restrictions applied is to limit the register
>> operations that can be done. Hence it makes sense to track whether
>> we have IORING_OP* or IORING_REGISTER* restrictions separately, so
>> it can be avoided to check ones op based restrictions if only register
>> based ones have been set.
> 
> Looks good to me.
> 
> Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Thanks for taking a look!

-- 
Jens Axboe


