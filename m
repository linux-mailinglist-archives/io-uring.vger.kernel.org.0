Return-Path: <io-uring+bounces-12128-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wBoBGvGBimlaLQAAu9opvQ
	(envelope-from <io-uring+bounces-12128-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:55:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BEC8115CC9
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:55:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C6DD93006237
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 00:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C5DE1D5160;
	Tue, 10 Feb 2026 00:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="y/FIuYfA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB25722FE0A
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 00:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770684908; cv=none; b=lvOsR2RsYJM/nUj8hF9yQSkfaj4RJ0gBn1VDFWkCsEuKVTfoE4Uuqpeqqez4JngquezctGn2LpJI3Jr9IgnG1bAo8FUcZl6dT03i03zqnddzNHGalByPdSS0k3y28bo8gH6Q3LIrNBRtMgwa5zBRQzMGKZsxgW6GUv8Df+l2O8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770684908; c=relaxed/simple;
	bh=bNGbnoYHphmDMq+tsIXTMuGwdyjziIIf/kP8aUBslZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d0PSixpf/GP8r3n8qqRIUb52nx7ECjgJm7yiNwHaMl0ZA84W3W8dexNVutLHSe4EuDgrTrkZIDVLCfHx7q6wuNU63LOY5bjvy5RrgE+lu5DNBjLsOXlerMXoEwf5dDkzW9afr7/MLDwDo44A80yuEFOAdl3d5gBh0aPKpt3ZO70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=y/FIuYfA; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d19d3c7208so201716a34.0
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 16:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770684905; x=1771289705; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lUU6lmqjVZyhTtFbjOJny4LX3nceJtE6En3QGrOjt6g=;
        b=y/FIuYfAAmjoSNRT7jRirMxnfMSAUq+lTEH9Ez6qY73pSI4VaN7p/aEadYRpRj2ZUu
         SbykmOMojtZAkpnV8WWazzYI+KKFFsC8M9tERF9MiqzLfWzcmZoHSAX9iEEJ7DXNSWfn
         JBylfcHVJ+E5N07gv59yXcPpOaHn2A5Gl63TsEhG9bAKZwEsMghAGjSuYymXUnB1Xr+O
         0W5dWuFDHy8V9bCvQquqHZxXDpp47BzmNH9Rhx0aLoI55s8vvcTKF9qSCWPwy8Jtuvvz
         tjKAzfyuaJCLj7AFgNaqZdkJDfSnpQVMtaA1030tPGYssDduGH1nCRPRXoIAC2HlZ0mo
         pL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770684905; x=1771289705;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lUU6lmqjVZyhTtFbjOJny4LX3nceJtE6En3QGrOjt6g=;
        b=aaff8/YlcgTJLqu/DqrRuudbpQMc8pwatPCi0tF7Tw8c2jtVupAgpXtoY4RLbBhAan
         HQqzVZc96H3NO6BjVQtvYfZyCldVLP1ZDDdJSz7dpjscC/TlmcBcafk+o0uLWKuHQ4Rm
         LsAGC+O1hyHn9H2smYGtxyyFWVRDGh6F56AnAtgkVCtgCH/tQ0Z29uw2XkyR4CQryz66
         UP2C4uDG8OHzBsLpo9ImtGLoiQirywTG5OdXp2nNZGVaWPF1uOThjHrO2CNxTSnTzYbQ
         AFR7LRT+W0RHl30CupHDd8JJdbmAUjJRFyKYaIrsg4OmMwVtmlXIGFw7zlsQCzdl+t2O
         uNhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGZgYk4Fs8Qn4HVljg8O353tIJtAyP2RpzzWRvSvMSAeH2eMPOX9zvAM8sj/B+SH9hgHJb94OX0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnNcqmwg2dFYcsXvO6SPcsa0063LStHAdl8JBj57NYVJmwxRCd
	ZBpPzPlVPVUjG6BtJFqLNDQga+Obvq/TurBMoaQxl1SFyfnv+ciGvnmSZuKYb1PxLNk=
X-Gm-Gg: AZuq6aJKv71pBS++fxNwOsIvEW0736PJ0AhR7vsJP2BPqr52VwqSrTjLJr86P3d8KP9
	T/QJt85sykeTcxWIZH2DAo60CzQkgfZtwXJKMEl4QBQrDSh4txZGtalfw+1V+PlQVUkIYKsG/qN
	04LxQ99OABSnYRq5ugiMgoh4VAkj0fu1ZdUWz4xJHwAE0TqVXj/3+pXPFNHpgBg8Uk1wTme90Ci
	rzyeOVbrwP+rGlGrlMAXd6DtxFAaCh4a/cBlSdaq3SVA0GCM1EUR7c/iOXYmKhj3N2uBjtTUUqR
	7wzXmYkteTHv0kvu7B4umHPUEGOK9RoPcHd5RkAF91CBQekRx8D4N6AdNQE5OunGAGDDq3GAUoW
	QLZoIpf4izoHLsOryR9VIx2R3/6B21fNJNOoJXz3TS+z7tHDfHC9xHjF8p0IZ+2pQ8aFyfYL1Lo
	DRQFn6Lta16G0rnaYb5OWtoGWme317dvfRDutDfgVw2cUmCfNxcM8ciX+T3bWMRQdAu8BtAy4E6
	D5A4y4APw==
X-Received: by 2002:a05:6830:44aa:b0:7cb:125d:2a47 with SMTP id 46e09a7af769-7d4643e5a0bmr7090026a34.1.1770684905573;
        Mon, 09 Feb 2026 16:55:05 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d46479b9cesm8261665a34.24.2026.02.09.16.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 16:55:04 -0800 (PST)
Message-ID: <27cebab8-fb11-4199-a668-25aa259ef3b1@kernel.dk>
Date: Mon, 9 Feb 2026 17:55:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/11] io_uring: add kernel-managed buffer rings
To: Joanne Koong <joannelkoong@gmail.com>, io-uring@vger.kernel.org
Cc: csander@purestorage.com, krisman@suse.de, bernd@bsbernd.com,
 hch@infradead.org, asml.silence@gmail.com, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260210002852.1394504-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12128-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 7BEC8115CC9
X-Rspamd-Action: no action

On 2/9/26 5:28 PM, Joanne Koong wrote:
> Currently, io_uring buffer rings require the application to allocate and
> manage the backing buffers. This series introduces kernel-managed buffer
> rings, where the kernel allocates and manages the buffers on behalf of
> the application.
> 
> This is split out from the fuse over io_uring series in [1], which needs the
> kernel to own and manage buffers shared between the fuse server and the
> kernel.
> 
> This series is on top of the for-next branch in Jens' io-uring tree. The
> corresponding liburing changes are in [2] and will be submitted after the
> changes in this patchset are accepted.

Generally looks pretty good - for context, do you have a branch with
these patches and the users on top too? Makes it a bit easier for cross
referencing, as some of these really do need an exposed user to make a
good judgement on the helpers.

I know there's the older series, but I'm assuming the latter patches
changed somewhat too, and it'd be nicer to look at a current set rather
than go back to the older ones.

-- 
Jens Axboe

