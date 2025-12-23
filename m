Return-Path: <io-uring+bounces-11293-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E1C1CD82E3
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 06:36:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E36430184E7
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 05:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98C62F3C3E;
	Tue, 23 Dec 2025 05:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KAaAzbrs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91852F39C1
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 05:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468186; cv=none; b=fkGfVfjW2UaT4pskG20VqrEe4ljRUns1kZwK8FwyMsEVK2r0KJr8St/GiLSku2GAafThWEoG3FRhAz5uYPf47x6we9JnDjFc3W/ZyhSMksIZbX2TJ0TT8lsRlAWBNfHKTkXsSpae0fHFvGajEGZPgEDwq7ypFEMSe6FFqz4ccBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468186; c=relaxed/simple;
	bh=VlgqwkzGyrE3K5mQqCM6bG2Y747dQIeSyi7etFJLJbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5J0O8oEZAhugHGpN9b+lr/1TLcO3InXvIT1u5kK7uqXdUMaLylABdDx6jxWjeP8QXkP7GScmus3/LzK1NZwX23ddOX50QRFByCxg09ma7r1HAjMornyDPqCG84xejI15t72iJU3OIGCeZ8Bt49K05j8iSnKAIi5kOLWGY87k7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KAaAzbrs; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a12ed4d205so40570065ad.0
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 21:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468184; x=1767072984; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VlgqwkzGyrE3K5mQqCM6bG2Y747dQIeSyi7etFJLJbQ=;
        b=KAaAzbrsGMa/yJ+ZeX66ACX313azU6u48dvdzrBwSic4HN62sJmYDXTq+VchukDU1L
         8sG8trF29f9VOcpuO7lWFH+BtnrkVzkWLbshB/5Fh07Cpq7NqkxHa1xuesIgnE8tH8Qo
         c3+byqUdmpSNC/AP16Hdfch35yejCD2kiF38JOHoQK6gtdj4WyMVRlnjcQ++8plqDvIq
         NINaKHODJxbdRib8oUYW69eNX7+AvJttzXqe0FP4ujNyHKM+xMXIBDuh4kEtf5cTmD4y
         0aVURA8jPi1DS5UAj6B/qSuo7DCtY/esApe51d34XyvYMy48PHQzwV0SOMUwYx1DdqtY
         fU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468184; x=1767072984;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VlgqwkzGyrE3K5mQqCM6bG2Y747dQIeSyi7etFJLJbQ=;
        b=QbapptYaarjLq0h/Fbhqy+UszdG4jghSccHGGxrT1Xt8mPlBd06BcP4ViQrdWdjvzI
         uwBP1i2Q8IaVwD8eg7rFqzPrCwthds3SEAZUiaq9qE5nbBhLbmxVEd4SpH//4DzpGZim
         l89Y5X5HZxlrj2k3MG3ahhJgxeX07NlzkZ+sOhktL80kibUtkz17yhbO2D0KAObpAWGM
         k2J973IOanqGM3MSrHMF/MpLickn1FQHsSqwdabhE/ZXmFtU6zESrdXBA0lHmcRyDnGn
         4PhFn/WSJZIrmlpoVk2PKCJrUVMoBMYyd31gtUV1ZmL4IvFfpVIgrcTU7Hq76WEP0/5H
         /fEw==
X-Forwarded-Encrypted: i=1; AJvYcCVtrasjacNiyCxGLriQ/sMiItjWwEUiO56lHF6jM2m3KXkAHt6vhDtyIQfbtvfmdnYyuRTm3oaFng==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFrm70Qq3fEf48lkmbAaaeGoEzDBwshoWGVnTdpPvE0zxowCF8
	PSSnOofF53c0cbdMBWJD6yLc2joMLk2Ba+5UVfjd2NehDX+4idgzPdlZ
X-Gm-Gg: AY/fxX6aU+tSZYQK7DeH0+jpEpElLax6tmcbcSfl7k4F9pv8VAhfbXECWfDiU2b5NH1
	3Zx5tdaybXzN8itLQ3UDmF/2FCW8cOJ/LEiH23acJ10OD8hzDVtQbidRNXY71KT19C2rKNVByTq
	ckFcy6vcli4EISH9VLmHnYpE5ONNiNBQhPgIu5cfceFi3ZoDtSiLvNHWXuiieIuUZgD+OYhAtzS
	6XAdI6RmYeqwIrfB0XWBkitzeASum4qSehfErXxdaIqj62O+ASPScbndNOfMA0FC0p+pLamsUZm
	COM00J6plJQuuFo3mc3jQhhx/iuZ8BXQOwFXB+UzWj7ZTI3MnfhUfz4mrmKR7h6iBd1TX6Nfb0j
	BMmjCxyE6Uun1uqacopCb1efAE83NUid4821pHSi11ZoDFaupypR7tslYtHaUWjsVy8A5nmrHt2
	jWx0k/6elM7o32KGFno2Knif8TJvbdsAMO1DxtDwk2Y7f/DmWL+6FXuK4iHPtdH3+r
X-Google-Smtp-Source: AGHT+IFX/6+bwcWXg/4km6FqYdkuwnUGcop1hJcfw4hTgcVNu0v2yNrPtPf/mgK+hd5hIFUJyC/N+g==
X-Received: by 2002:a05:7022:3705:b0:119:e56b:91e9 with SMTP id a92af1059eb24-121722dff1cmr11158229c88.26.1766468183950;
        Mon, 22 Dec 2025 21:36:23 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217243bbe3sm54039368c88.0.2025.12.22.21.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:36:23 -0800 (PST)
Message-ID: <4e5f6df4-b446-4ec0-a0d9-231756ee934c@gmail.com>
Date: Mon, 22 Dec 2025 21:36:22 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] fs: factor out a sync_lazytime helper
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
 <20251223003756.409543-7-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Centralize how we synchronize a lazytime update into the actual on-disk
> timestamp into a single helper.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jan Kara<jack@suse.cz>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck



