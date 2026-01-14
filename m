Return-Path: <io-uring+bounces-11704-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D223D1F859
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 15:42:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 01DC6301A4AE
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 14:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62DD02FDC5D;
	Wed, 14 Jan 2026 14:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CxRxPkdo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DD8E555
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 14:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768401740; cv=none; b=fzVkidmHY7AfUC3kLf9cggVy2KMqsPcVuVDDPllul95c9melWoVozRX6+9Hx41mtde4dfqk5gBO9571bjviiByzPD9mjp5l/2b9uGeYlHu53hAx08m5tWuIi3YCKpBthdnkpfy5K1Yky1fCsMRjn7YQhA3OSVyzQ6Dd8QBYpDhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768401740; c=relaxed/simple;
	bh=BVASAEECGqlGnShU7hLOg3/ClUMKE0TbQyv+NyxazAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TpKkDToG7fHQP1bs5N8MCMPPyQE0PdNHFIefKe0mtIEAZtkG+nzb5WiW9JXeOYfh5lkY2VlbuUO23x2+IgDy0YDVJGBOqP0yxH/m6NutSxmJukHJwTDKqW2j4QaGLejP6v6mnX9ZEu/TEN3ZGORbJpvi+lYd6tSXw5d7FqkRzgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CxRxPkdo; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88a367a1dbbso145413606d6.0
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 06:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768401738; x=1769006538; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XllR2PHeIuAyaDsa1eEsmGujrUzEwrlwh2htikyR2EY=;
        b=CxRxPkdo0eDd+w6ZOXBMTf93OelkRGCSsUjWDwBKAkbiEC+kEA1cV9fehwNYZY7W5K
         XaEgFTg4hMNGFlpB2fE4YFLCawBn2J2cX4k1988CyOSQP0eBz3s4/IPUiKtw9Ul3n6Y7
         MzEB7/1j9C7KxcQLZRkuR0wIU0xiUchYD0B1x6ajvUWNFVZXLKqiZNbyA4qAid0hId0L
         CdgwGM37OYA3om/LJFU4dO2IhvoaURTAkWfrz/PDDKtb4KlUVkQDPqK+JSwXeqHIPElo
         e0wlI848o2WAVqPF9ohFk/00v1puTmSUUvkvJZNRN4jZdpF2lpMXDZbbD6kK2tMjVBN/
         Bjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768401738; x=1769006538;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XllR2PHeIuAyaDsa1eEsmGujrUzEwrlwh2htikyR2EY=;
        b=EJRZeKjqikMZMDOk7+fYweig/aabQeal+uBbhgHunzQ7pbaE/V2t//xp62IdCxqCpQ
         aLBNm56p3zHnBP0UubdmgsoXT8M2AKsyLyLqM+H6nI8Y8iAZHSiuxPJCkGjUWKuFkHq5
         H/B1optFwEvihcTmZ85DaUvOqGeUlWcp/DZIsmcyfpBYA9sjHYHIEb+xLNjLUERqSiqK
         AEgSAtCoPPFt/I4TCDt98kduliRGxHKRueYPKhcTEtYXEmckZVyR/GZmJfUso9UzeXfU
         zmF21WX7DrRY11NgcbgkVtQJbzqFHakc4sURPQ8Av0AXIRk2VuF23xaUgnx1K8o2WF5t
         xQng==
X-Gm-Message-State: AOJu0YzwKNfGjboJr8eV7h1vxzK8leoa5uo24TR1Mis8ZtqHd/9nRjYK
	s/Lh6fb0xKVYptnfvtxdkqBB51JDhmqsCaEUeQfCj8wHxLjSn7yc7dAE
X-Gm-Gg: AY/fxX7DSOlvkfF/1z4laUyVZYikxxuMvo8dNN8zHqIRgozzwPjXoJCGDn/+Fm4OGuz
	0ecrvnCpYvNw49C6cw7bdS0uTRUPtIwktG8PHLyTUS21WiVPg+VRxYUOwjZONzDFgeJUN73Fb0L
	5NCMVt3G3ZWOAMTZbnE2KbxXh6sVT1xQLpSQUiD6uJSTMrUX7+ZTero/7/yXFw6jBLF7l2UOUS1
	lUOip3MJyXkM5DN0uwhyjg5lhMa1YXbkSnveRRp4obNUEXuHTvGpmoGdi7me91XKBDwCemq0Anl
	BDu9YYoMfuv2BS9Fc04/gaYbfctRJE+xv5zdT8KO0Z7LXppqQ72RfPaPsuAEkvsvnBDvkVFwWE/
	dpA6h+9e9AHfWpcEcaABlfDFxo2zE8xxRmf0LQh4kIZzfSRWyxCP0Fg8TTdIhZeDgysH1AFYpQp
	TYir6VEo7CyvshvJ+cz4mdg/qP53V0bXvtpNEbTQj4EZ9kjlYP4g52EZkw40GS9nN6NGYuYLrhL
	Q7nmMOy4Xa9aHi8naYm/jREqxP2Uz5H2NUxpQhrUX0r45w=
X-Received: by 2002:a05:6214:29ce:b0:888:8913:89af with SMTP id 6a1803df08f44-89274383f69mr31306996d6.15.1768401737697;
        Wed, 14 Jan 2026 06:42:17 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:b3cc])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8927a07c731sm7999216d6.34.2026.01.14.06.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 06:42:17 -0800 (PST)
Message-ID: <9f032fbc-f461-4243-9561-2ce7407041f1@gmail.com>
Date: Wed, 14 Jan 2026 14:42:10 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
To: Jens Axboe <axboe@kernel.dk>, Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
 <87ldi12o91.fsf@mailhost.krisman.be>
 <d3a4a02e-0bcc-41fd-994e-1b109f99eeaa@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d3a4a02e-0bcc-41fd-994e-1b109f99eeaa@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 22:37, Jens Axboe wrote:
> On 1/13/26 2:31 PM, Gabriel Krisman Bertazi wrote:
>> Pavel Begunkov <asml.silence@gmail.com> writes:
>>
>>> Describe the region API. As it was created for a bunch of ideas in mind,
>>> it doesn't go into details about wait argument passing, which I assume
>>> will be a separate page the region description can refer to.
>>>
>>
>> Hey, Pavel.
> 
> I did a bunch of spelling and phrasing fixups when applying, can you
> take a look at the repo and send a patch for the others? Thanks!

"Upon successful completion, the memory region may then be used, for
example, to pass waiting parameters to the io_uring_enter(2) system
call in a more efficient manner as it avoids copying wait related data
for each wait event."

Doesn't matter much, but this change is somewhat misleading. Both copy
args same number of times (i.e. unsafe_get_user() instead of
copy_from_user()), which is why I was a bit vague with that
"in an efficient manner".

-- 
Pavel Begunkov


