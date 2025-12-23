Return-Path: <io-uring+bounces-11295-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 71EEFCD8316
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 06:38:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 18870301F036
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 05:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA14E2F5A08;
	Tue, 23 Dec 2025 05:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/39yZPJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327222F49E3
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 05:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468313; cv=none; b=UlKGvcxvGmMG2Cu5roOZg9QuEmYU10HUrS/f2ApTqn8bNAVoRSbQF0ft0daTuBknarBYcOeguw4Ofd7MixAXRo1xPSrnzWTUwiFwxA2+C+86m0RL1Zn9IywwJUl/Ymaw1MBzVgr1OuHHoV/W5bDJGw4K8RKkJV+TIh7jz51ZZ2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468313; c=relaxed/simple;
	bh=zTV5Fl6uJEq6bikfRl+2GZKAfKdgBpPPlmOrmzDQ1Sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KpwCRtqu2dKmc6HVqG6bP5Kec4xqk7He0ajvg84Ayi1ZBYDyOl5Jgy5cSyRHYh+DryP9+PP6mkvrnV0e5ZiDxTDTV9G19l9SiGNFoXoT1fKZRyVX3snP8C2SUChejFaB6WaijuT2/mHdioja2ebA1J/JmqW1+lrto6fhLeMbA/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/39yZPJ; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34c1d84781bso5287416a91.2
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 21:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468311; x=1767073111; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2eUzqzQcRAv7TL9i3u7rXqYthkznBqBfs67/HNYTk8I=;
        b=k/39yZPJRd/lUcRJkV7mXQEWc1+ntOQZ3mgr8kFI765nq8VXzciXpYKgKPQG/tmkAM
         owjPUkIe3CFME/oQ1dh1e+schfxGr1GebTc60fpUHpvMD21xSXHx1R6rHRmQnGi7e77b
         K8gWq0Odf6lE5z7xabI1OfkODM0SiBVhCyDtkdpfiQCqP28IV5iuZ3X2EFOvRV2Gg7UZ
         OwnNQdnzXvu1PxMtIuBAX2FJOYDAFMzk3ZDVkCoSbErCXRMukkSvcsMp9nWx55EwuwEJ
         7Pdlo1cgbWzgOgds7F9Lpvihye3j+92iv8K2QF0XqTlcbb/5O/MwGRalD5ldn/b0XsSo
         WZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468311; x=1767073111;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2eUzqzQcRAv7TL9i3u7rXqYthkznBqBfs67/HNYTk8I=;
        b=dzvapwgBuL2YkjGkJsoD+KMKM5uQ6JBaFtXIsOqWsBBdN00leR8/7HhvCR5GH49l9Z
         r90+pj+FgJwTcdfJpiKMIptNcVWnhblHORqALLEao/VgvyF0uAyhKHSYoyCcAb8N/EP3
         7rgi643fAm91lfC3kqWRYmcAPafuLN0ILM3wipX8WTZZFsk0Ni3xlZkBplBsYOXvjHAy
         3W75VACSKdXx/z67bQEkQ7gbru3fo38hRfm8nhuw/NTe/U0/nMaNdnHyTVFHivZbtCa2
         hyfMrWzGF2mdrsMBYlcfIOIm5d7qeIz9wLT+8BoqUWA2ktqpeK1qFpmngXU8nX1dPpME
         BM8g==
X-Forwarded-Encrypted: i=1; AJvYcCW77rtNdC5VRdg60I7U7lb+yCXFksPUh76BnmGc2NtIXCMNxj6/knx7M1t5VCxclEzJGaDucTvkEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YycZqmslTKS6mocIgB201G1RFSbo8FXeRbJI2UOMd/2X/lmd5/4
	z+TXuoXjFhhLh5KXxW9xkNfXhZrnBC5UowAv+um4ORjf57PbH58/1Zxd
X-Gm-Gg: AY/fxX7HrrYCUjLCP5CfPCfEru/BztMfG/tDvkLb0Vc2Qq36mLIyRVJvkKtwmqf9l8S
	5A1S++8siMOP+sDkVWd5YaCaJeVtzFF0ZWZAA2WOiJUAYhudXjP3HnXN1J6ADEf9zualt9TDCgc
	XZxKsnXzEZZep+rsP9JqvwEm3N76WdPhaKg2zLXFmXAHTUv64xmBsdCRcHciVjoGEfFQwqx1LIi
	6bQlNyff7NBNVvtGxAnDTmU722hGlQLbDCcfFsVm1HPtr4WNtzrgg4u7jK+LQTlthatyq+w+umv
	y3RQloJXrPaWfy1BDWnqqUvb4XWM/Hwfms2pVdxyPgS6bHtPVA9xbA/glbB+h4S4lGV5u87G+Ou
	BhfcTUBkx3IGl4GocygZBZFVZTpjpxfpvGKgigqgbYy7D3C2xHRtQWEHB6ro9f79QGIpquN67EU
	+F2HamPnRqS6gTUgL7nSbW/NOsNeuE0QIbPGwwgceRhgDFUtYWegN2r2sRRcQd2WVLY2GqcfZnK
	oI=
X-Google-Smtp-Source: AGHT+IFwAZOrVWcdz0GU+cDO+t7ewKrgjzgkHtOiGD0/poJQvRMMxSdMeBecD46MhF4AsSDjM1RyIA==
X-Received: by 2002:a05:7022:799:b0:119:e56b:957e with SMTP id a92af1059eb24-121722ac244mr18354800c88.3.1766468311123;
        Mon, 22 Dec 2025 21:38:31 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254d369sm56187439c88.16.2025.12.22.21.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:38:30 -0800 (PST)
Message-ID: <37febb65-038e-47a7-9a5b-3b4c2773994f@gmail.com>
Date: Mon, 22 Dec 2025 21:38:29 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] fs: add support for non-blocking timestamp updates
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
 <20251223003756.409543-9-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Currently file_update_time_flags unconditionally returns -EAGAIN if any
> timestamp needs to be updated and IOCB_NOWAIT is passed.  This makes
> non-blocking direct writes impossible on file systems with granular
> enough timestamps.
>
> Add a S_NOWAIT to ask for timestamps to not block, and return -EAGAIN in
> all methods for now.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck



