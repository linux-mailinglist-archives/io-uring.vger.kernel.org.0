Return-Path: <io-uring+bounces-11291-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E436ECD82AA
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 06:35:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BC90E300C2A1
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 05:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 935F12F25F1;
	Tue, 23 Dec 2025 05:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LxX3T1Ps"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C266B2E228D
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 05:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468154; cv=none; b=NiyTnwiMT4WSEpzbW29N0NwnH7VCNT5bBgqCNnyPj534lQaa1wJ8e4Hp+rL9tUNCVJdPnRI1nxSmNEeUTPbvDgc80XBIIvY2cSKAavtYISEOvQG26By2VV+h2M0IOj44SYyLScxn2BwZSt4JIEX9Jw2z6r83GKPZfRyhFM4ULOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468154; c=relaxed/simple;
	bh=g9Bt2s+UFC+DeXi/131tDLXltXct0EalOx5ApUtrNkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UgSR4CnKJv0/PF/kvzRnYvx5holfAHmCXbZjKPn96GmJPPyp4d1C+R2BOocqoix11GF5YVnp6CGTIVWeyKyosJxsoaMfKBizR5KO4QdzrcbMgerfLsZmgSYWduCOFRVg9naZO7YY6vC6v29DefkwaANRii6KSba9jJ0EJRcsaBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LxX3T1Ps; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-11b6bc976d6so8222830c88.0
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 21:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468152; x=1767072952; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1VDWjicrLkuqVcwGv9d1sh+ocm1fa0mGizT1YHR+Z6c=;
        b=LxX3T1PsbL7A9toWeCRP1ZiEISt/so3/Ge3jUHQW4vV4bDI+CFNh2mgvpyMRmaKHoT
         /MVJPZzIUDwB/OoYv1aOhJKvrOm2AivnEB8xW6vyl+8+1t7pR6MlWzwtRfU/GfflqC6K
         3JQu8w0MC9/CxAeX4efBrU98BIUAeM6jx8wPEXyWQR3NDflVWRIrWEIxqQR4++JYkCHY
         bFEz1B+WB9h9jFH2Xqa8kzgS5ZTgD86P5uMkVxwxMjciEze4VsRaDj13pFlXKT13kVUf
         kH4LjKRVTROQaXbg91AnL4dtGRfgA1kC1ZeJH3Do0F3CuIrtVgeWGDs/NQy0SWkny28V
         x0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468152; x=1767072952;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1VDWjicrLkuqVcwGv9d1sh+ocm1fa0mGizT1YHR+Z6c=;
        b=wWkDGaPGypfFrrRTnfN6aZ5PPAs/jEeTD5cVhih2pZUBo21xbDlHuFMBbbFfRNs60R
         nWiqhjT7QnBdiIwwAHpOedgtWY0eWCP4RQeusFsTXVF0H28gX5plXy9VwDvOpvIrfFVn
         rlB61fgrcKrp7Mrh1ZzTEKzcOKA5xai/yqee3BPjlU4ufbqcEajLbX/5iYj28Zl9UC5j
         fN9Yo5+LzxNAbk0Ubg1EIoYqHx1bucmbEU57Hqm04F+j4/b2O6EEAmqfYtxBxueLy/ZU
         oPAEW2L1J5Gqo4N4Sl8Z2OS6Q+YStCQXRvdSKQVZmUZRpl4p8nfHzCT71d3SFmU0tkSK
         FuOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZ7yGf6cwhYnd9JXDhb5weubTfTqVq6akNxsOG2nX3JSqGuPvhMUyuaRuth4kolZVyNupUX50wWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7kf2CPOi8ZWhI7gRe/8M6wUnFvSqSWd7EAKETVdt7J6NUJZ4h
	qD4X3gIq3myvpJSDK4mQMYzW0b/kix9tIap5QH2Z1voE+/0bQ0TM3TNa
X-Gm-Gg: AY/fxX7j60wktsIFLBYz0HW5er8dN587L9YTq6FYilaU3CmCoyCH0CGhaoRA6uUE9GU
	/aClN01UTmvtSy72/82TD+c50hsJLhlViTuUn9BZEJ2J7HeYP3jRP67feu16uSFQWRG9o5UrTAw
	5TeoOGAL37T3dvHS3cm8wVU+4nQgEieNSxL2OD6YWRugAxL1GHKVeKRDTpmK5tMJQ6Iun6FvOFh
	8CM0qe+wSkgtAI181HyREqM8UqCBGy6v/7k4TMN9kuVReJ+mK+Q/Q6ChwTgzASgA5BelHm49u8C
	YrkimfEMqystCXigcWA7UNBfV90j+YJnyCZMo6HUVWF1bFB9JkqX8j1+1Cj0kJwtjxbAfxX1f5Y
	ZtQrwLdwxwR0ImWVXMw2fDjGPraonjAybioky8+Zg0OaXnK5reF4khZRQAGeYpasxucARQpEjTP
	FTY7gozWSIQsrJccGI17l/vjfqCrf0cgPQSmq3OtmXCbdo3U3Hj/gQKzYWuCyqz+Bf
X-Google-Smtp-Source: AGHT+IFgD3SNwd/4TCZfokt7AW5oqjEJYNTcZgO21z1zxvgYYO/3rgL7QNl7uSOUpz7Nh4qCGFV22A==
X-Received: by 2002:a05:7022:eacd:b0:11a:4ffb:984f with SMTP id a92af1059eb24-12171a85250mr15323051c88.11.1766468151780;
        Mon, 22 Dec 2025 21:35:51 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121725548b5sm54725089c88.17.2025.12.22.21.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:35:51 -0800 (PST)
Message-ID: <6f297260-3c99-4330-92ab-deeb1fc5d8f7@gmail.com>
Date: Mon, 22 Dec 2025 21:35:50 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] fs: delay the actual timestamp updates in
 inode_update_timestamps
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>,
 Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
 io-uring@vger.kernel.org, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20251223003756.409543-1-hch@lst.de>
 <20251223003756.409543-5-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Perform the actual updates of the inode timestamp at the very end of
> inode_update_timestamps after finishing all checks.  This prepares for
> adding non-blocking timestamp updates where we might bail out instead of
> performing this updates if the update would block.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck



