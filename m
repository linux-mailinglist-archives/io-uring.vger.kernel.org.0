Return-Path: <io-uring+bounces-13183-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOuqFWgm8mm/oQEAu9opvQ
	(envelope-from <io-uring+bounces-13183-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:40:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A7384971BC
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5129A302E07B
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 15:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C6CE376BEC;
	Wed, 29 Apr 2026 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qMkRCmAG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0576A37CD25
	for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 15:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476611; cv=none; b=tei8YxG6M3WidKtNj3HATWKPCHaxXvpGGmqDDtcNuwAEkV+PrvyjouYip+Ckj+lygyLpYb7sNG4nwABSBtpIJORgOH7cF+2lA31rTJ+fjw89bFpZ2cdZZBz7WRCBAFtPCVUylzObqDKNHrXIacZll8rBE93Xurl49COupd3wdOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476611; c=relaxed/simple;
	bh=rzuxUcixg/aGo1wsLI7mfQXDoDsrq+gCA/2UqCKDcbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YUXinA0Jbdsd1q4r/80L47YX5aNhHox7ilm6/B8JNJ8Iyrlze5LvDMyhaO92pxenhhxXSXEobhh3NZQbwNRbpBf3H2nhWWMAXW+jPTni6WFvBmasD+MyLfDOk459KzFuG82RLdeUqxslewfe6dGlaECVOtCMArwuk66FiRxk9Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qMkRCmAG; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43d73422431so11815519f8f.2
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 08:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777476608; x=1778081408; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FOLuNiA/kfZwdLV9E2p8TNPc5d6B3zFK/DDHPjJ4Ciw=;
        b=qMkRCmAGPF/CQdcPyMvL7/b3NrrRRQjb9rPJFbEO+e47eRTPnAFflJ7b7/PXCP3za1
         3ecR+Hipy0pr2biy0kmthF9f41ammpPrxLG4BQqO5tHigxmxrKm3zPWOFdhUVbOwpl+G
         dDvxE4hDeh7HYZdShxmepG+bcgdeMrvNTKjgP4hW4567eU776FPkTErKOZTp2J/+JrFG
         jVTk2AjOa4qDaPOr34pI7R7g2xRo/jz7rj0pmtPYD8ZGilkaOFPgMqghJJlgE09MsMLy
         gmb8sXsShLrMJEFyD2OUoNV8ga1ftTKs0EPkyc4QBg7KjbnrHqqABWouhVnp7eKEkqjx
         QwoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777476608; x=1778081408;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FOLuNiA/kfZwdLV9E2p8TNPc5d6B3zFK/DDHPjJ4Ciw=;
        b=lK5g7rwRB/q3dxJeoceGw3FefPn4UdwM4srXvkFgCmBKyayNxHUcCswK1J9VW1kP0Q
         8sI8Gd9GVdv/CRbyLgy3xDA1nNlEVK9bETqDGJTZcYswcPbc66z4Oti67eggOUz9+/3U
         pW03SIwRbETvFCsgErkHKRz1FOwtueVAl08INySefZW/Nydc4fWmWnX6v49djb2GHcZl
         CljeGTQFvgvGHDuFcNzWwLZALvZyNKwWLY9ByFet7p3NG9gfJ3UmF2rSErITnNx+Shq4
         XD/GWT4p989YfYrLvUCjWtd6IridvayVMcJlLWkz6CxkiJG6G+fILNSmGioY8YaNVAtr
         bgkg==
X-Forwarded-Encrypted: i=1; AFNElJ/b4pYUWR2hmGKLmU5L7/FAnV7HES9Y1mpRH7gVAsdAlgKeh/rDec+GtIoUwRhI+5uUQiw2IpvRCw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzS4YzT0JDwF9LZ/9yeMXQtGQfASb45lJxMrQ6Hucay97GKrSvp
	AvV9NtASdgcAjcy7OM4g95sS11WymwFhmyeWhUpnOEu89zc1OZLJ5j96
X-Gm-Gg: AeBDieuozTSqrw/Np9njJvickvV+8dtGvNqNy68jFmW8tX3EhwQyX3vRAc1hRY7AUIP
	nY6V6z1IpzBqMVa7B5PbJYyWP6lEApNH15yZbLMacHVwj9TtujH1HWzrYXQ24zS1QyEGaBnawkn
	hOM1xTURcWCDtDIXdeSMvZY9DBt/Ir7REK3ZoOW/N5VJyvUJ0XxaVztCSH3/2hgZI5axjkbfgVY
	cITW1YeHMGa5sXEK3kK/Jc4U4rqhSC9sUwPuOmv412CbFmjvmvMRIKAbMms3EqywBZ2cvnJmHT2
	Glz8g9du82W8YKHey0rLOv6VcXx+KNUSWAVMFMRXc7M1yAROxPAKfvsTfhmxDAe3PETAj7II6zC
	JFr091LZF6dWy8r5pOBEzDx3ZMiL8nUW7N8k8ZnrSFIsbwvtjm5XVvhrqdHkbIVH1h6pT2Z9LZP
	nw/CWGoQwPQ62yvR0yacaYsvDwDLCWAfH3LADH5bue+H2ohhSGGqCmMZRRF6uWiyIGWTgm+TwIF
	ChKAnkB3iU4x0bG+8q5YbqG9YREyDlvxonwzB7Alg==
X-Received: by 2002:a05:6000:4313:b0:43d:d037:d59c with SMTP id ffacd0b85a97d-4478eb81cf7mr7566713f8f.16.1777476607642;
        Wed, 29 Apr 2026 08:30:07 -0700 (PDT)
Received: from [10.228.209.141] ([82.132.184.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b3d481fdsm6740381f8f.8.2026.04.29.08.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2026 08:30:07 -0700 (PDT)
Message-ID: <46bf2c04-72ab-48a2-a8e1-9f4423eb17a6@gmail.com>
Date: Wed, 29 Apr 2026 16:29:51 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] nvme-pci: implement dma_token backed requests
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Cc: Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi
 <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <5cecb1157ab784f9f303a91449fdf11b03aa6002.1777475843.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5cecb1157ab784f9f303a91449fdf11b03aa6002.1777475843.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8A7384971BC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[24];
	TAGGED_FROM(0.00)[bounces-13183-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]

On 4/29/26 16:25, Pavel Begunkov wrote:
> Enable BIO_DMABUF_MAP backed requests. It creates a prp list for the
> dmabuf when it's mapped, which is then used to initialise requests.

I left nvme request / map setup as it was in Keith's work for the most
part (apart from rebases, adapting it, etc.). It appears I have some
use for prp lists, and I know Kanchan, Nitesh and Anuj already have some
patches adding sgl support and some other optimisations. Hopefully, I
addressed most all feedback from v2.

-- 
Pavel Begunkov


