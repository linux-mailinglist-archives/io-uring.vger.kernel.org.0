Return-Path: <io-uring+bounces-12081-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8N6dJJwrhmm1KAQAu9opvQ
	(envelope-from <io-uring+bounces-12081-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 18:57:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 330451018D3
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 18:57:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ECDC630166E3
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 17:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79FCA4219EA;
	Fri,  6 Feb 2026 17:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LtmGWo8Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058FB34B190
	for <io-uring@vger.kernel.org>; Fri,  6 Feb 2026 17:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770400635; cv=none; b=bkXeFb9ORgiUiETtaRQ58dPlFbdUTG9pT2UmmvM0hAWBWXt1S5hytcPH8WOxy5NrHcljF5qdLCWnaobUY4Y5s5SZd7eOeWHVi60XA9Z124R+7mpOPdGVzIpbZJwbh/62uld8dkToAZQpNsyCvid2DYB19suR1RkRgqavdbNUycE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770400635; c=relaxed/simple;
	bh=vLBMaSRLHO7oboPE1A1XsKKv0Js2Rl1SaZmguYqzxrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oSPaFc+LighuWR+kUMDW2f6LbIv5mO/Ce150jNErk8MEsyeb0HjOnegKcktM11Ub6X67DrhOdZpBacP16w1jIuJcJcD1D9fF3X74tmP4eTwAwgDTEARHByY8ALQvUdkjxewm+r4KR46KZ/8UKAxEGZMipmEfLxpSrCRCS6WW0fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LtmGWo8Y; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so29376555e9.1
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 09:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770400633; x=1771005433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0xzBXC39VA35TGgzF7BlqtIk0rzDCuWiS//uKoFgvig=;
        b=LtmGWo8YW/66vIAX8Ujyxvf/7oC8OBWrfE8SWCxFfUtmUtQfzsU5RBKMc2YIJPlHM9
         jJNdTpD7aNdrSM2uLCeoweqOeKuiuf6uMCiSV3YUeGzx71ZZFHvW6CQ0DAikLcPDMYfy
         s5RoX2lV1CjXp8UAukgenOq4y6HQfqhaay9wzTi3sKg9d2ytaO72GB9IduwPEycs6uFa
         VpTHNd8n621HT+yvPZTiqRjhjh6QGI8QgoqoVFZ6+s5IB4mNDSs13FFbhxzUMvrg/gHD
         LUH1gOazB2XwvkmN7lSJYbVzCwAiHM97FjaWPDpSa+oj5qBJXZZnhgB+9rwrsiC9qf/V
         ikXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770400633; x=1771005433;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0xzBXC39VA35TGgzF7BlqtIk0rzDCuWiS//uKoFgvig=;
        b=g1EbtCPfRsk+hP/COw0O+gZUaqjxJ8dsa2THGdOcjN8PMaSCrMLlrRiXvvRwDOMBSo
         GLRrg8gPbQO6yuyevKNbUra1wIPGHtxDrLel5n+zDkIkbrmbyycPK4cWp+WAtcI0Gxjr
         jAA2z1e/EHQBtworeuk6h1TfXav3c5NUM5L6Heu7MZcR/Jn8943PoJK0DKEEohEMWVP6
         ViVxyh59g/GdU16jXpv4TaDni4DFc6E3QfvE2r0+xocZ+ZdUmqJ07X75r6yuPOnFii8h
         oAL6Ut1gtcLZvS+gJXv3szyyLc2oDW5obPJpShPmNeNAz0kgTBJSIDYig5rxbqM0OkYl
         jLLw==
X-Forwarded-Encrypted: i=1; AJvYcCWfiTvi/qCzSPslUESjIJAN23T97OSuzI4Vzj5Z9vcedzIAHWY17xN4iIvz7clIAkBQQRMmfF4TIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YycOkRLOdpRtdLCBzJ9sLGSTJqIxGhrtWtEamHBHdRj1I8KrzFV
	6LP63+PEo+iaKfIKdgALHUvyFtcfS4M6F4I76hcGWfLox40c7yuGx166
X-Gm-Gg: AZuq6aIBuN5bgpo4SgvZLAaJMJQi1XhDLQJqSIB1ao+nuWeCsz2dF07W7DDQBafaZL9
	KgQLKEGeGdABTxKaX7IE8Rk44f5jx5tMv826m1B3ca2kyKj9za3HQ8X+JGP+gdjnn7U1g6spvwV
	kczL62Np2afvhM1pZ2M1U+EuMQv6Wvc5jtmO4tNFCyRIrngETKfaMLAteZFi2Rtybl3SzwJ+loC
	XREFTC7cFXEnYRwpGNdVGEXhTlggl8tbq63dLvuM/S97q7R+ACAByiGTiPCnjACy7YzOp1ZGrVB
	7QkO3RShQG0QgEnh+xpqClyeu0DiOpzxUIl1JjAvC2Kq4P4b31/7c5Pazrzh9YRgwuiLlhunH9F
	PnczYRt8Glomt/yzOJS5p+Tc3Vj2bdjbrEvvKgwsQMvhPhbUtXqo3AvV3xNauyeL0KeK28/rVNc
	56o2WbH8W10TNJgcQJeWEEZJ3qgIofPqVw4bqHBLzGPehIqSFaYG9MCqFA+QwITB0N6hzHGcaZB
	/bnoCcZYf2/VHuwSK3RJcfABOpnJ20CACHnNp4U3r8pJ48/wJy9FmfGAPLFF2d3X5ZNYyelHjTb
X-Received: by 2002:a05:600c:1f16:b0:482:eec4:758 with SMTP id 5b1f17b1804b1-4832021fe37mr54462585e9.26.1770400633147;
        Fri, 06 Feb 2026 09:57:13 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48323c12d74sm38492195e9.2.2026.02.06.09.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Feb 2026 09:57:12 -0800 (PST)
Message-ID: <df7fe4d7-ca28-408e-bed3-bd1fa23e7588@gmail.com>
Date: Fri, 6 Feb 2026 17:57:14 +0000
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
 <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
 <20260205235647.GA4177530@nvidia.com>
 <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
 <20260206152041.GA1874040@nvidia.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260206152041.GA1874040@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12081-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: 330451018D3
X-Rspamd-Action: no action

On 2/6/26 15:20, Jason Gunthorpe wrote:
> On Fri, Feb 06, 2026 at 03:08:25PM +0000, Pavel Begunkov wrote:
>> On 2/5/26 23:56, Jason Gunthorpe wrote:
>>> On Thu, Feb 05, 2026 at 07:06:03PM +0000, Pavel Begunkov wrote:
>>>> On 2/5/26 17:41, Jason Gunthorpe wrote:
>>>>> On Tue, Feb 03, 2026 at 02:29:55PM +0000, Pavel Begunkov wrote:
>>>>>
>>>>>> The proposal consists of two parts. The first is a small in-kernel
>>>>>> framework that allows a dma-buf to be registered against a given file
>>>>>> and returns an object representing a DMA mapping.
>>>>>
>>>>> What is this about and why would you need something like this?
>>>>>
>>>>> The rest makes more sense - pass a DMABUF (or even memfd) to iouring
>>>>> and pre-setup the DMA mapping to get dma_addr_t, then directly use
>>>>> dma_addr_t through the entire block stack right into the eventual
>>>>> driver.
>>>>
>>>> That's more or less what I tried to do in v1, but 1) people didn't like
>>>> the idea of passing raw dma addresses directly, and having it wrapped
>>>> into a black box gives more flexibility like potentially supporting
>>>> multi-device filesystems.
>>>
>>> Ok.. but what does that have to do with a user space visible file?
>>
>> If you're referring to registration taking a file, it's used to forward
>> this registration to the right driver, which knows about devices and can
>> create dma-buf attachment[s]. The abstraction users get is not just a
>> buffer but rather a buffer registered for a "subsystem" represented by
>> the passed file. With nvme raw bdev as the only importer in the patch set,
>> it's simply converges to "registered for the file", but the notion will
>> need to be expanded later, e.g. to accommodate filesystems.
> 
> Sounds completely goofy to me.

Hmm... the discussion is not going to be productive, isn't it?

> A wrapper around DMABUF that lets you
> attach to DMABUFs? Huh?

I have no idea what you mean and what "attach to DMABUFs" is.
dma-buf is passed to the driver, which attaches it (as in
calls dma_buf_dynamic_attach()).

> I feel like io uring should be dealing with this internally somehow not
> creating more and more uapi..

uapi changes are already minimal and outside of the IO path.

> The longer term goal has been to get page * out of the io stack and
> start using phys_addr_t, if we could pass the DMABUF's MMIO as a

Except that I already tried passing device mapped addresses directly,
and it was rejected because it won't be able to handle more complicated
cases like multi-device filesystems and probably for other reasons.
Or would it be mapping it for each IO?

> phys_addr_t around the IO stack then we only need to close the gap of
> getting the p2p provider into the final DMA mapping.
> 
> Alot of this has improved in the past few cycles where the main issue
> now is the carrying the provider and phys_addr_t through the io to the
> nvme driver. vs when you started this and even that fundamental
> infrastructure was missing.
> 
>>>>>> Tushar was helping and mention he got good numbers for P2P transfers
>>>>>> compared to bouncing it via RAM.
>>>>>
>>>>> We can already avoid the bouncing, it seems the main improvements here
>>>>> are avoiding the DMA map per-io and allowing the use of P2P without
>>>>> also creating struct page. Meanginful wins for sure.
>>>>
>>>> Yes, and it should probably be nicer for frameworks that already
>>>> expose dma-bufs.
>>>
>>> I'm not sure what this means?
>>
>> I'm saying that when a user app can easily get or already has a
>> dma-buf fd, it should be easier to just use it instead of finding
>> its way to FOLL_PCI_P2PDMA.
> 
> But that all exists already and this proposal does nothing to improve
> it..

dma-buf already exists as well, and I'm ashamed to admit,
but I don't know how a user program can read into / write from
memory provided by dma-buf.

>> I'm actually curious, is there a way to somehow create a
>> MEMORY_DEVICE_PCI_P2PDMA mapping out of a random dma-buf?
> 
> No. The driver owning the P2P MMIO has to do this during its probe and
> then it has to provide a VMA with normal pages so GUP works. This is
> usally not hard on the exporting driver side.
> 
> It costs some memory but then everything works naturally in the IO
> stack.
> 
> Your project is interesting and would be a nice improvement, but I
> also don't entirely understand why you are bothering when the P2PDMA
> solution is already fully there ready to go... Is something preventing
> you from creating the P2PDMA pages for your exporting driver?

I'm not doing it for any particular driver but rather trying
to reuse what's already there, i.e. a good coverage of existing
dma-buf exporters, and infrastructure dma-buf provides, e.g.
move_notify. And trying to do that efficiently, avoiding GUP
(what io_uring can already do for normal memory), keeping long
term mappings (modulo move_notify), and so. That includes
optimising the cost of system memory rw with iommu.

-- 
Pavel Begunkov


