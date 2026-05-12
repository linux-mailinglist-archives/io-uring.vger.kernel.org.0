Return-Path: <io-uring+bounces-13296-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CIBVNvGHA2r46wEAu9opvQ
	(envelope-from <io-uring+bounces-13296-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 22:05:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D40DC528EF9
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 22:05:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E279D3006097
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 20:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1934F3A7583;
	Tue, 12 May 2026 20:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="a13TEH6o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD49360EED
	for <io-uring@vger.kernel.org>; Tue, 12 May 2026 20:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778616300; cv=none; b=Bk1GGC4tsHp66yfZdz0Gcme/dFjmYOzRtTskrvkxH3vO8yJh/EU3b7Fk3OuZ+dPUOKU8sVKP6voPUM8Ej1WhL8t/lgfo4P9XLDTd3nAm1XWHPn0zodouAaGVkpqMuHdFiQ21aJvCRlAl/klDfLThO2+I7OKHGRC6Gp37qLDawyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778616300; c=relaxed/simple;
	bh=U149B7jOZDbYNaIBagtJTBhvtJfw5mB1hC2QAke5b+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KZxT37MHrgOS51NtEJYPYPWzdogAnzK2lc01gKFyShPVk/HyS+xLB5k7ZcBDSekAXtGuMJIcazP9o3XvQMrGbXT3vbifZOSEIH/vdJPvtQ5lpx+HjYibZ7lsyMGoUUsEC/Eb3QIdULnYyJDdPmgwXXtNKWd2GuKMKIyEwzbBYFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=a13TEH6o; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6948ff6b006so3575346eaf.2
        for <io-uring@vger.kernel.org>; Tue, 12 May 2026 13:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778616297; x=1779221097; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ytaRvGyzRvrwPfExsZqDRmrBerTbe0eDzEQ+zX7gEI0=;
        b=a13TEH6o0QX8YWFboTTIBE7Au4HbM8Pf/JRakFnaXLJRXlcgF0YOZEK2I7wrajtl0k
         mREGo9aI1zCrKTI335CwbOz1xkBzQ6jxQEZFJPbrxEAGea7yd+mcl1YBgqeBGsV79UbJ
         /rpUpM1mS5V0eNS7yJJ0Xgtsnp5xEyvDka7gk4WhHs9T/sOkvH/GRJSHLKs1PhJehuXJ
         eMMA5KEzE0+d0q20xcibLAtJ+k6vl28UeF/H1xuwHZchzzcC5wP/KdJvYPSpzL/7c7XW
         3STgY/2QmYeLSzn4yj5q9OEBR3YcArGrUCyLSTbFX3zru2v4GGgmH3zm4wjGbM6bAmlW
         5ydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778616297; x=1779221097;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ytaRvGyzRvrwPfExsZqDRmrBerTbe0eDzEQ+zX7gEI0=;
        b=hHCT4aK0lQNbaFSThGt91Kb30CCwcUAP4cZlhKKeUuuwkgfXefsyUO6Ev9VSzofYMP
         727PZ0LjxweFHW0+IDkXrmE+/6FLqK6JioY3FStCnZEWhp/XirdWgejxaBxl9oeUrTQ3
         VLBvGlWblIEPC4Jc+0y2Nfd3jHrdjZFuoAmLlfVts1kwlzIIkLHgMN0OpXvaiBsIylp5
         VLEjnVKPnqbl/Kz6v82UsQGAwH0pso8JrJB7kf7/hAoDtCnfNQ8j5d2CXYjKm5vYgAjK
         jZk+M+YOwcKl2waKrTkfk7gQvb9WeTLLlL/8lQ9gersfV/O5H2Q2iHtR6umy1r7Qhr3P
         R2Lw==
X-Gm-Message-State: AOJu0Yy4RYKvYU5m8oxg6HELL+PFl1k5e3e1cFQNpKzFqr+IGsNFLIoB
	caSXkS1fRxa8iKC+71nE/wl+O808QigqgaV8DEj8XoTT3gldIj+J1uXi4RizdIgtCws=
X-Gm-Gg: Acq92OEQOVCZM/LP+jbbILqcw4wlV2uadCyjVKGsseeNwM0dpdzb5KYwAXakB8gkhGu
	+RvmmpWIVAt7U/e3a/wiYGrhw0WnETHbKJyjWPK5Qt3mDNRNh+hZSiOOwcaGlO2eFcq4Hige8h+
	cX4hca7oelf9McFpWF9GbL4VIPerashYGK7y0ZhUfqoG2O/p8A0hp/YDjN3oqXB5nHbmvPhnwJc
	0UPdeR3jqIiRJzoyMb/m5scWxAqH4rZ5TTgaA+TFIxH39rfLkkaGcZc9ieo8hFOQeCen2wM/CJn
	aoNRh05mq88gdIdWmBWV2BzeKV7cDOOdLMXbgmps5bRV8O8m/F/T2sK3BBYkkI2bvDKtEKO9Tpy
	T2dgyBeS0+c3+0CZiwXXcyBxTuA7re0Sfrx7Sp0qlOjMKB1Bv0cArHC9b+P8pr2sE9mf1ML/nQ1
	zTxVlq08DoGh7U4uHg13z6nDi1vw5PKEtwxq8bhn3+sGucT7FFJhJHPSowU4s0PxYFY9LUWmjgw
	HMTGEhPEA==
X-Received: by 2002:a05:6820:1527:b0:696:72c4:5db1 with SMTP id 006d021491bc7-69b78d002e3mr201665eaf.14.1778616297483;
        Tue, 12 May 2026 13:04:57 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4355736f517sm13670314fac.12.2026.05.12.13.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 13:04:57 -0700 (PDT)
Message-ID: <ab0c9639-e636-4603-9e86-2db2d139c472@kernel.dk>
Date: Tue, 12 May 2026 14:04:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/5] io_uring related epoll cleanups
To: Christian Brauner <brauner@kernel.org>
Cc: io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260503085101.112698-1-axboe@kernel.dk>
 <177861542127.846060.15247420422293788438.b4-review@b4>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <177861542127.846060.15247420422293788438.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D40DC528EF9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13296-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 5/12/26 1:50 PM, Christian Brauner wrote:
> On Sun, 03 May 2026 02:49:11 -0600, Jens Axboe <axboe@kernel.dk> wrote:
>> Hi,
>>
>> One of the nastier things about epoll is how it allows nesting contexts
>> inside each other, leading to the necessity of loop detection and the
>> issues that have come with that.
>>
>> I don't believe there's any reason to support nesting on the io_uring
>> side, in fact IORING_OP_EPOLL_CTL is a historical mistake, imho. But
>> let's at least try and contain the damage and disallow nested contexts
>> from our side.
> 
> I can stuff the epoll preliminaries onto
> 
> vfs-7.2.eventpoll
> 
> which is where the refactor I did lives and you can just pull it.

Sounds good to me - I'll send out a v2 with the rename of the
struct, then we can proceed from there.

-- 
Jens Axboe


