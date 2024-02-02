Return-Path: <io-uring+bounces-516-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5AF0847524
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 17:42:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C8F0290BB2
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 16:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169937CF04;
	Fri,  2 Feb 2024 16:42:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F193A14901E
	for <io-uring@vger.kernel.org>; Fri,  2 Feb 2024 16:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706892122; cv=none; b=SX0M1On4wIR+87+5pDkCixpTw69mNmjaKIGWpCbDnHEz9noUI/JPuZazid2Fj6S1Dsh6JEb7Y3w979ZFUxVD6+NdMrFX9tu+8ssXzEsf0jbQTZqUvZm4LqtPN9LrWFzw2CfDda5ZHsCwOryWLYoZ8JeeYDnvgbJd+UzBCN+BxcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706892122; c=relaxed/simple;
	bh=xFE8D95posObEqDGYUgMuXIb2kKk4D3lwmL0aKW740M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C0IBW1R/MGfF6e0I185/Z9T504djpan/rszgXzaUOQ+MA37HaEIZHldm12ghfispzkJlmSCbVZw9SW+ahp96VyHg6AgG9z23lXDcDOl79ixkkBCUDD/HDwQNDhuJnZIkVjd0HO1fPTlpFaa+GDaO19Juu/PVk0gxbfbvti5Grcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=olivierlanglois.net; spf=pass smtp.mailfrom=olivierlanglois.net; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=olivierlanglois.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=olivierlanglois.net
Received: from [45.44.224.220] (port=42274 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@olivierlanglois.net>)
	id 1rVwbr-0004FC-24;
	Fri, 02 Feb 2024 11:41:47 -0500
Message-ID: <d78b0ed1ca8e1ff3a394bac4ae976232486a2931.camel@olivierlanglois.net>
Subject: Re: [PATCH v9 1/4] liburing: add api to set napi busy poll settings
From: Olivier Langlois <olivier@olivierlanglois.net>
To: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org, 
	kernel-team@fb.com
Cc: axboe@kernel.dk, ammarfaizi2@gnuweeb.org
Date: Fri, 02 Feb 2024 11:41:46 -0500
In-Reply-To: <20230425182054.2826621-2-shr@devkernel.io>
References: <20230425182054.2826621-1-shr@devkernel.io>
	 <20230425182054.2826621-2-shr@devkernel.io>
Autocrypt: addr=olivier@olivierlanglois.net; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - olivierlanglois.net
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@olivierlanglois.net
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@olivierlanglois.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On Tue, 2023-04-25 at 11:20 -0700, Stefan Roesch wrote:
> +
> +int io_uring_register_napi(struct io_uring *ring, struct
> io_uring_napi *napi)
> +{
> +	return __sys_io_uring_register(ring->ring_fd,
> +				IORING_REGISTER_NAPI, napi, 0);
> +}
> +
> +int io_uring_unregister_napi(struct io_uring *ring, struct
> io_uring_napi *napi)
> +{
> +	return __sys_io_uring_register(ring->ring_fd,
> +				IORING_UNREGISTER_NAPI, napi, 0);
> +}

my apologies if this is not the latest version of the patch but I think
that it is...

nr_args should be 1 to match what __io_uring_register() in the current
corresponding kernel patch expects:

https://git.kernel.dk/cgit/linux/commit/?h=3Dio_uring-napi&id=3D787d81d3132=
aaf4eb4a4a5f24ff949e350e537d0


