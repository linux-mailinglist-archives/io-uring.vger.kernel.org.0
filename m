Return-Path: <io-uring+bounces-12060-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CFPlACrqhGkj6gMAu9opvQ
	(envelope-from <io-uring+bounces-12060-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 20:06:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFC1F6B36
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 20:06:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 836973006900
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 19:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F23230DEDE;
	Thu,  5 Feb 2026 19:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jOWbPOkD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F9830DEBD
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 19:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770318370; cv=none; b=rIk6wIRuksaUjU10MjpyM5xeTiYKlyGmigkJXK1pmrFWxMczrD+ohGcEFJueVLDIhBkTQaMk80duq/zpIlIEfyQ+I1hBr6K7fUsXn86WGAFzaSDgyfoX/bEewU5OGkUKI0Ym195CYJ5zAZedO5gM20CDV6e+MthCy/p3hOIoVjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770318370; c=relaxed/simple;
	bh=6xkmyF5XZKw+4x6EVGIygZudWYp36C+Bq+hpfGTgz8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EpFSwyJwwwArCbZH2GjrpoIPZp+xRfjXhia9BOxe/2XuAQkn08XjnZ7MYT2wY6KWuxw9CktXfiRiQtoUFS8wMQQWQvfX6dBpReJ3oI0Zj4uzBxFiGunmKFsmJmDu9EpIR4Arw9gThF+AkD+b27N8dzewV67MCbyhVbHyur0eOwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jOWbPOkD; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4807068eacbso12219055e9.2
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 11:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770318368; x=1770923168; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=idtwUK6BtIsEhpc3TaDCHUqHeRjM5Kpq3rLxxa+LHTI=;
        b=jOWbPOkDLf7n2x0zC4BPgs8f2DMziJiWJGoyo68VukLSYaANqW0KOZUk4bcJZqcWQc
         zyA1AagpKSPjetJjuhM9FnkT2u4epsAxd//I74ngUgrUWErA/I5o/TW+ADnN3bxl24Re
         a8NhJEFowiwFgz0Z6MpfL4fpeDEsetPYwVxLC5J4scNuNkpVAFFZP0skp6j2HWjXboty
         dra+ApdUMevRFxXUYBqarfT/8CM1rPpztmg37GLlRLsuK+0Z8FoHdnD3D6HgKycStHOh
         LJINur0yGhL9f3JN8v7dPMXZjjHVB4ohWtbZNnFnJ7pCtULfYZtRiBOl0gYvuX4u9sVV
         G+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770318368; x=1770923168;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=idtwUK6BtIsEhpc3TaDCHUqHeRjM5Kpq3rLxxa+LHTI=;
        b=F1cLYsSNhwJpKcK4T57T1UA/hGQFdCISAMKwooakSFOEp8vksicPFEVlHExLX16rkI
         PYRyzF1ecrmyRdWDsZhy07VR6XZcAwvtwHx0vvO7EDu+xR3A8r9sWsIRLFP3SSaj5g2p
         38D36KwULWj08xIyKKk1QiH6TKSMuVzIRfv06JjDM4+V3fgPp/PMMxLvJKPbVWu2Oza6
         gXZ25fsFJSUc3vxmzjwyaXsTXbaX2FYuC9meWAE2v+H30UuQ79WFY1hElxrJKAa0A/Tt
         cond5D0m3a+zhXGUP6DdIFWQ1kQvUjBuWUb4eiSMVofEsr1SrrG1ZYh52BvSVJCcGh76
         G20g==
X-Forwarded-Encrypted: i=1; AJvYcCWiXQt36egYTZDTEmoTzvOOMtub0a7df/LE0VegMMnO6X0bi9HDq6P7Sn2yTk1Ew/MZGQIUyDWyJw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1Vhxu+N32ZnY0tlUWZP1f6VvMJ1UXwtqJ0HHd+yvTfd6QDrX2
	JdViRCO9SgxRzT6xhbKXr61mWqrJVME64EueJtP4gltpuidjXsbqLMbWKE7n+A==
X-Gm-Gg: AZuq6aJIwWNAnWU1RgI4oz0/LfGg1GwcCLUXGu0X2YutCv6r0CHxvOukWBcSgtd6/w9
	W/juPXJME9zh4/aSg2EVF/81RURMvOhwqR7F+W7ruKlBFvu9kqvQ/8CzmS6ELiV+ba+vDYycq9U
	2Pwa1NNAdUbjDYP++UJGE2fCRkc/axPojdQlqG+GR3CxwGZnJB2LCniKMXYVHS+n4q/HSnnDvm1
	+w/WVF7A1xo3CdTC42zSSRkAczS2r+vHuqeFBNfLXVQxSrpxn+PPWZX5o6vhsOZhqxktnqcHZL5
	4CfxUKOCSoyshd0KADToN+fsm29oWuCRwYQPsEQ5pOZHMbm4e3N4Itohdl79j6XjvbzMeQVFxRO
	KxHj65IfMg132ARtPGQVzYw87rOuXK6uJ/fIpezekZcNJSiZy3IQjPga/78kHAGAuLzIyYid5NQ
	QwSWet2L6SoMzI8xEJNIC+vh3X/iRlREVfhBOlu7csczU/qtvb4CypnrUNdeewglUGXszQoWupX
	jFujrlNflZWseiOfK/7mN5rPhWmAn7L6aMtadj0AuHIHYhDQ+9VdHvMOMZqjM5pmA==
X-Received: by 2002:a05:600c:5253:b0:480:1e9e:f9b with SMTP id 5b1f17b1804b1-483201eead3mr7164205e9.16.1770318367919;
        Thu, 05 Feb 2026 11:06:07 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483203d5ef7sm2743825e9.1.2026.02.05.11.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 11:06:07 -0800 (PST)
Message-ID: <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
Date: Thu, 5 Feb 2026 19:06:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "Gohad, Tushar" <tushar.gohad@intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <20260205174135.GA444713@nvidia.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260205174135.GA444713@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12060-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1CFC1F6B36
X-Rspamd-Action: no action

On 2/5/26 17:41, Jason Gunthorpe wrote:
> On Tue, Feb 03, 2026 at 02:29:55PM +0000, Pavel Begunkov wrote:
> 
>> The proposal consists of two parts. The first is a small in-kernel
>> framework that allows a dma-buf to be registered against a given file
>> and returns an object representing a DMA mapping.
> 
> What is this about and why would you need something like this?
> 
> The rest makes more sense - pass a DMABUF (or even memfd) to iouring
> and pre-setup the DMA mapping to get dma_addr_t, then directly use
> dma_addr_t through the entire block stack right into the eventual
> driver.

That's more or less what I tried to do in v1, but 1) people didn't like
the idea of passing raw dma addresses directly, and having it wrapped
into a black box gives more flexibility like potentially supporting
multi-device filesystems. And 2) dma-buf folks want dynamic attachments,
and it makes it quite a bit more complicated when you might be asked to
shoot down DMA mappings at any moment, so I'm isolating all that
into something that can be reused.

>> Tushar was helping and mention he got good numbers for P2P transfers
>> compared to bouncing it via RAM.
> 
> We can already avoid the bouncing, it seems the main improvements here
> are avoiding the DMA map per-io and allowing the use of P2P without
> also creating struct page. Meanginful wins for sure.

Yes, and it should probably be nicer for frameworks that already
expose dma-bufs.

-- 
Pavel Begunkov


