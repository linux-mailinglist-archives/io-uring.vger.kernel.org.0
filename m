Return-Path: <io-uring+bounces-10813-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 34FF8C8B10F
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 17:52:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D436B358003
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 16:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B75ED339B2A;
	Wed, 26 Nov 2025 16:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gZXa79Wm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C0C309DCD
	for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 16:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764175916; cv=none; b=P3G0wHl9cU5MpTJ/LQTA2uUrcUCPKsZdddhDBiBY0X1P4oniEcTGDMQxEhSPz1ijrMrd2I9PIBzh5jOpV3MUaci/V8ZX9SMvdi8m4xm3ZWeuwqWm4L1uEaakYXsW4lEKukdg117n728dQEyKuf97wSk3fXUPQs3tdpLVf+4OMRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764175916; c=relaxed/simple;
	bh=JWiv9GUAi3pxwnCES8vgmto4Vt9mGRrMhXaU0XHLp+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UgJqxY8dhCsRSfZwEEI+7pW9LWGZ7cSnlxrwXiQjm5Wxsy5IatVJ8dIuSWAyw4GsNaxi/Ckk9vTxkhGp1M6m5U8LAbrFzbfgqQXyVQcI2KBrkCsPks0wYZT+ESmSGvxW85QEwFa/QVEEcy8gNQa/W/MWWqSqmto97w2GLjXftKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gZXa79Wm; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-9490b441c3bso292606639f.0
        for <io-uring@vger.kernel.org>; Wed, 26 Nov 2025 08:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764175913; x=1764780713; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6o6rvThCpAXrqoEfGloDnW/XDixoz0N5zTrIyfzn8cQ=;
        b=gZXa79WmQWkZOisKdeQhPVyMiJEzJhSIDcD465qh9Y5Hrt79JyMc0Z0uAXvKZP+eNQ
         m4zznGjeLjT7nOwkvi/InnIl+KD2uGZF8/OZ+64ShasL6BdQOrlXUxvt7JLzheKEJRaS
         jpsdjD3AvJW6Jaa/COtWIX58da2ZaxhLE49V/8t08SD7sq//CzZmI2z5IrvvAuXpYm3T
         pogDcvSun2QmutEAnIttju7Mrw1hFAi+5wVxExiPcIX29k+P/kYyNOpzg+eV4wvqZhaB
         utyeqZuugBsNey8NfQ6jPDI6PSJ7TZknxD3RdIaOPFufsnaXoNwU8Vi3ISkeMhlVeMQG
         RDJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764175913; x=1764780713;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6o6rvThCpAXrqoEfGloDnW/XDixoz0N5zTrIyfzn8cQ=;
        b=bIdcG+xAjPbpNjOIblYv6NwzmWTN43A0byb40M6HlLeRBH8xhADp1scoZQ38xI+E8z
         2KZJr8sDTB3DujvlY08yr4cpPL0rg5sCKMhOezgb7PmBj8iBRKIx/UY0Wa6NYfPPmPID
         VxQwPscom2eKoex5E50hygHKwWJBnF3GKqLsp0MrQNH+b0xYfmKnFQQIBGTQQzDpNbSh
         p+0aUiGql3WvPxI3yawUUXtFeU/utJRVg46B+jutLzFHMEm5HahkN/8FK6H/XjnomMWs
         0ZffZ7CkpCvWReTZQUIyJX53dEKGWvfOCDoOeySi8jCykn3HfjmjUgw0Zm4dnNq45p01
         GmuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgJ32N/FxHUlAq0i7V0ciawg/nBvLiIUC8NeS1EvufKwxMGBTGGd9McjQusv/Q/TvjAUzb1pJMhA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9qrc+fqDCgRpgXSvOE8zns6BsfqFEaHqLfXHCOXvKxYLCiJRT
	k5N4SjARdml9cmur/IUT6raL3V3/3wXvZKDQ0E+75lpxwA8yc2o2k4Ma/XYxEOOIEhc=
X-Gm-Gg: ASbGncs6ZGBPCSxUI8wLaJEIrCjEUxf53YDZaUHWHtftmBqlhqh48vMLZK5/5m+DKs/
	XzsCjB8KeMJRNm0psy/A8FBjdnu6YJvr2yU6sQDF2CF3AsccAL+Ns2RKLjoOtVPa9rIBVzTR9zC
	2Mk/5Xj1viqUt5ej1v8ET/wOVgu25uy9kyHMrm55dc0MFKwCbNMObYjrBn/hs1REwXRpBKX4tZV
	/M0M8Etk55G/MpwBgqsdWT488hIRLXP1Gktpl+L+mZjwA6byXQpPhMWcGl82hceP037f3t0BylE
	RSgvbgoFcFSvD4N5nLhr9DLzIdMwA20xtlMld7wzq5KfVrZcNYwT+axlI7rtQsdwnNS2e8roKGb
	yzHGD5Pd3UtvvisFRiweuhvfAQnfoy2l3Kx9gYyZqV/tHasHBP2w30mi/6av9e6JKZdXQ2nUXKZ
	+plxSZhA==
X-Google-Smtp-Source: AGHT+IHj8vbygkLIHNIW+NNuQ8p1emK06owuHOj/3Qh+CKsf7lwUDqZEF5Zmk8DbFPim0ayVzFJniA==
X-Received: by 2002:a05:6638:1354:b0:5ad:1e7e:45a4 with SMTP id 8926c6da1cb9f-5b967a01ce0mr16606472173.3.1764175913156;
        Wed, 26 Nov 2025 08:51:53 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954a0ee3dsm8636352173.11.2025.11.26.08.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 08:51:52 -0800 (PST)
Message-ID: <4e08b49c-a0e3-4e17-bfdd-a58182b900d9@kernel.dk>
Date: Wed, 26 Nov 2025 09:51:51 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] io_uring: Introduce getsockname io_uring cmd
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: netdev@vger.kernel.org, io-uring@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 Simon Horman <horms@kernel.org>
References: <20251125211806.2673912-1-krisman@suse.de>
 <20251125211806.2673912-4-krisman@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20251125211806.2673912-4-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/25 2:18 PM, Gabriel Krisman Bertazi wrote:
> +static int io_uring_cmd_getsockname(struct socket *sock,
> +				    struct io_uring_cmd *cmd,
> +				    unsigned int issue_flags)
> +{
> +	const struct io_uring_sqe *sqe = cmd->sqe;
> +	struct sockaddr __user *uaddr;
> +	unsigned int peer;
> +	int __user *ulen;
> +
> +	if (sqe->ioprio || sqe->__pad1 || sqe->len || sqe->rw_flags)
> +		return -EINVAL;
> +
> +	uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	ulen = u64_to_user_ptr(sqe->addr3);

Missing READ_ONCE() for this one. But I can just amend that, pretty
trivial.

Outside of that, this looks good to me. Bigger question is how to stage
this, in terms of the two networking patches. Jakub?

-- 
Jens Axboe

