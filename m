Return-Path: <io-uring+bounces-4085-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC579B3911
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 19:27:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0C451C21339
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 18:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 053641DF966;
	Mon, 28 Oct 2024 18:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DhKPFJpw"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E200186616;
	Mon, 28 Oct 2024 18:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730140059; cv=none; b=Nb8OYesr+K/bp3e0LGo3EGNswNJ4HuKKGTSrLYm40smPjcZDsV0N0W53XLOJpYfUdjL8Pbk3nYVLGAy95MmqjOMbuI7KFsw+WReH4veKvRbzyO6trxD6yB3ce00tkH1YRWlDYHBY3bvMoP5UFfSB2xanJmzGxSuD99b8TvP/IlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730140059; c=relaxed/simple;
	bh=rhlpUCqerCgg89TeahubZhhVDdSg0WPb2EHjHy0q2Xw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KkJY6sKdSi2wwoC3FCStrYyJ/g9YsJvhFmL5XLnnamngNi22nSjUsnIYcw9VCCe/+aZhUhpmSJ5KRWyvB2bgA4K/z1oHX32QrQ0gH+Npj26sBiDJFr2by9ffDEoFAVnzY/GVFIB8wOD/iSvgovo+7Xd+X1pPQxeloYfvqtLSjHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DhKPFJpw; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xchh93fq2zlgVnY;
	Mon, 28 Oct 2024 18:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730140054; x=1732732055; bh=rhlpUCqerCgg89TeahubZhhV
	DdSg0WPb2EHjHy0q2Xw=; b=DhKPFJpwpvxhzpKYxUjS3ZL89K5UeOtkI/jcnaB6
	cNh3v4ZfnI0ivSzxXOQKTXYMYhzusvFhy79ymlg+2ZDoMhzboqNNAGPDSHDTkDNJ
	L5FWLiu7IuAieAeFA40n3agyo5Rymjr6y/bc96C5MCwsU6FiUUvGXsjfQ9LOCD7N
	51FN8UKAgeq8VD3JFETDbgUyNZN6qo7kk51MRsFdngjRj+wAu6FtzN8trc5d+q7V
	aVVDXTCsll4vYfbcUJaTxzUcyrIr7VgARFcNVQBQ53GveJMWdUBskwwSXAhE9Fj8
	p3WQOPXTNDTnP3PzVtEppXyRAN0KPyczS4udNgXocq5bNQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sMy7fRG_jkxB; Mon, 28 Oct 2024 18:27:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xchh56TsqzlgTWR;
	Mon, 28 Oct 2024 18:27:33 +0000 (UTC)
Message-ID: <626bd35e-7216-4379-967d-5f6ebb4a5272@acm.org>
Date: Mon, 28 Oct 2024 11:27:33 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv9 3/7] block: allow ability to limit partition write hints
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de, joshi.k@samsung.com,
 javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241025213645.3464331-1-kbusch@meta.com>
 <20241025213645.3464331-4-kbusch@meta.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241025213645.3464331-4-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/25/24 2:36 PM, Keith Busch wrote:
> When multiple partitions are used, you may want to enforce different
> subsets of the available write hints for each partition. Provide a
> bitmap attribute of the available write hints, and allow an admin to
> write a different mask to set the partition's allowed write hints.

After /proc/irq/*/smp_affinity was introduced (a bitmask),
/proc/irq/*/smp_affinity_list (set of ranges) was introduced as a more
user-friendly alternative. Is the same expected to happen with the
write_hint_mask? If so, shouldn't we skip the bitmask user space
interface and directly introduce the more user friendly interface (set
of ranges)?

Thanks,

Bart.

