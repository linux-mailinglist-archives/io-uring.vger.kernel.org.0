Return-Path: <io-uring+bounces-12095-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kJxvJ76+iWneBQUAu9opvQ
	(envelope-from <io-uring+bounces-12095-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 12:02:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 096CD10E7E0
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 12:02:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 537DF30210FF
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 10:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A35036998C;
	Mon,  9 Feb 2026 10:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E5NWzgFE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDEB369982
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 10:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770634796; cv=none; b=lbRGlfhfGiphPVtJQbinlXTP1zb8Z6HysISFuMxiIo8hAZQqMOnXqrC2Cu3DiAed+hFfbHwtBZjxie1ZcsGfuK++ow7oLNtOlFfxftbz1/IoFCiTWGj5Opkx/M6XsvtjaC8MqvFgiYr8vO6oSZqasf2Gpon4QdsLfrLv+8MaB24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770634796; c=relaxed/simple;
	bh=v0s80yQdoPcSpPQhHvKUreuJ98yEUo/WgcNVMu0aSBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UlzCAnU+At01FmxOS9VO/JZ11ViKfWdljGhu5NQY1H2Je7ncuyeaFCBMpdCPqrv1CZJdvFrD3w3zqjqgHs8N/mDP7fn/9oN6uMpMiaZclgMorhkrDbAbNGskdKvEeh/dYdaEX700mzTa/IMJQ69vUvpYzYQWWpKirPBXUedKyFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E5NWzgFE; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4806e0f6b69so32591395e9.3
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 02:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770634794; x=1771239594; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G688QNZNzseecNO9s2R/4hOww/aUhIqv4CaNYmpeoYQ=;
        b=E5NWzgFEYVlkwKYbEEaVWvPUMr3yCQkBYW9Zw2+N1+KglrJasumluLmQHHrFRyyurY
         eKoke8bWt0hBcbm6leyfW+S76klDSpNxmMfBwgGDD/Q6ZmPl0Q7TC6jEujaQrP8tJUHW
         p7XLBlt4qMSUYlCFB/sMqChFVbyvxwDlxrajc3JTWS0KpbjbJrsIbQt3RU6w+N7G1ZFl
         W5Yx3v7CKbyL8W+mfSINVc/tPIZoVC1q39kOvYcgL5pOYqHiPBxNydoAqRbcBawypt20
         S36x/rWJ2Ji9asbPUOTydsVGm2Ac1t/+yRXjJYkX5VPvYAsmFs7vTszyP0qLjcuLYiQf
         krJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770634794; x=1771239594;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G688QNZNzseecNO9s2R/4hOww/aUhIqv4CaNYmpeoYQ=;
        b=bipRdFRFhU5N7uDQq4mDsr2E9bPDDSeE4Tc3FOCD6wog8lrHV/iMtaLuHcLWMyVIGt
         BHFUgRVhzz1mQeJBwj9mAmCz7m4BUUxV1mdt8UPfvZdl7jM5wUF6TS6xNa5qU9iK0Ban
         KXtl9BORxu9fh/WCiFAdGja4oSP5CurbMG4hpJAt2Kmxsq/pUWtACV/qLKJy7c4+dKHr
         EjCzMZzaLRQTCaxfWJr+XFmcZLmYclh5Fi15pl/HiwSBFYcZvmV3xRllEIzqFQ43075u
         rn65iT74i1NqkM9hXgAUC1yc7qx7zvG9RQiEjASIY/laXBs0yk0SF7Tcg6T+GF7qVgA0
         1rmA==
X-Forwarded-Encrypted: i=1; AJvYcCWGfpRgV+bXf3XYE3BejnIhpXn3zsLd7E+JxY2OwVcsm/Z89d0dnVmM52Ju3lfFyME29gccVlqTJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyYAPM99/ka7tjNW30aaCVZ3fr+S93pufCMTLMQZgAdCXnZbKsi
	OIPF240Bhphh5+uVK4Utr329ndeRysbcLQGjPUysZma5+IeTEOcZDOby
X-Gm-Gg: AZuq6aLWLCAb8+5eBNfLBSl0fblMyqJByE3m0zWmwEdnFxAutQ+chy8FuD5UYTZdl9q
	dvcNfc/8L59ftJ8zKDHeMtxmmaj9ZjuYAVtGETum2ryIzVQ5KH/YLfGmlspT0ckl4wW1mWP77jr
	rdxACCN9lVD4l79MhBZauzCyNm3/hMjLefRyd1t5/tY9hs1lxo1QhSPrRCrsBA6H9seAO8Zj1vH
	A6byN8MSMXARRgz9yNd+BMNjh3QhDQJUYFzfjwuodVO2hsZnY5vD3WIk4QdrDOhicyR6BQ8jZS0
	KTWstKJH/oesS1n+tQfr13pE7wcTJRk3+Lb7iv0iRLvXJmcZ631sKEn15daPGjctYPwFeCwdo+8
	on70pGzVTdy/2IPW/Ahm4WWZ+H90lP2zaDN0RM0lHyLll0ue7acie8zMuKnxiB3HhjwJVwZOco1
	CELZhwGOad3IwEarn48lDWAFrTVVqTfmTMbN/d3YxDeG6Wr7cxaWlNjULs4AxUW2zud55HVb8UZ
	Rn8jsxgJ8AXlBujtkeYl6+jB0ID7SUJuwF74JUNAhbjiGk=
X-Received: by 2002:a05:600c:a08:b0:480:4d37:e742 with SMTP id 5b1f17b1804b1-483201dd276mr144307045e9.10.1770634793982;
        Mon, 09 Feb 2026 02:59:53 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9b67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48333bad79bsm196879525e9.8.2026.02.09.02.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 02:59:53 -0800 (PST)
Message-ID: <4736af5c-4bf8-4e9b-8f82-4b89a75d2cdb@gmail.com>
Date: Mon, 9 Feb 2026 10:59:53 +0000
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
 <df7fe4d7-ca28-408e-bed3-bd1fa23e7588@gmail.com>
 <20260206183756.GB1874040@nvidia.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260206183756.GB1874040@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12095-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 096CD10E7E0
X-Rspamd-Action: no action

On 2/6/26 18:37, Jason Gunthorpe wrote:
> On Fri, Feb 06, 2026 at 05:57:14PM +0000, Pavel Begunkov wrote:
>> On 2/6/26 15:20, Jason Gunthorpe wrote:
>>> On Fri, Feb 06, 2026 at 03:08:25PM +0000, Pavel Begunkov wrote:
>>>> On 2/5/26 23:56, Jason Gunthorpe wrote:
>>>>> On Thu, Feb 05, 2026 at 07:06:03PM +0000, Pavel Begunkov wrote:
>>>>>> On 2/5/26 17:41, Jason Gunthorpe wrote:
>>>>>>> On Tue, Feb 03, 2026 at 02:29:55PM +0000, Pavel Begunkov wrote:
>>>>>>>
>>>>>>>> The proposal consists of two parts. The first is a small in-kernel
>>>>>>>> framework that allows a dma-buf to be registered against a given file
>>>>>>>> and returns an object representing a DMA mapping.
>>>>>>>
>>>>>>> What is this about and why would you need something like this?
>>>>>>>
>>>>>>> The rest makes more sense - pass a DMABUF (or even memfd) to iouring
>>>>>>> and pre-setup the DMA mapping to get dma_addr_t, then directly use
>>>>>>> dma_addr_t through the entire block stack right into the eventual
>>>>>>> driver.
>>>>>>
>>>>>> That's more or less what I tried to do in v1, but 1) people didn't like
>>>>>> the idea of passing raw dma addresses directly, and having it wrapped
>>>>>> into a black box gives more flexibility like potentially supporting
>>>>>> multi-device filesystems.
>>>>>
>>>>> Ok.. but what does that have to do with a user space visible file?
>>>>
>>>> If you're referring to registration taking a file, it's used to forward
>>>> this registration to the right driver, which knows about devices and can
>>>> create dma-buf attachment[s]. The abstraction users get is not just a
>>>> buffer but rather a buffer registered for a "subsystem" represented by
>>>> the passed file. With nvme raw bdev as the only importer in the patch set,
>>>> it's simply converges to "registered for the file", but the notion will
>>>> need to be expanded later, e.g. to accommodate filesystems.
>>>
>>> Sounds completely goofy to me.
>>
>> Hmm... the discussion is not going to be productive, isn't it?
> 
> Well, this FD thing is very confounding and, sorry I don't see much
> logic to this design. I understand the problems you are explaining but
> not this solution.

We won't agree on this one. If an abstraction linking two entities
makes sense and is useful, it should be fine to have that. It's
functionally the same as well, just register the buffer multiple times.
In fact, I could get rid of the fd argument, and keep and dynamically
update a map in io_uring for all files / subsystems the registration
can be used with, but all such generality has additional cost while
not bringing anything new to the table.

>> Or would it be mapping it for each IO?
> 
> mapping for each IO could be possible with a phys_addr_t path.
> 
>> dma-buf already exists as well, and I'm ashamed to admit,
>> but I don't know how a user program can read into / write from
>> memory provided by dma-buf.
> 
> You can mmap them. It can even be used with read() write() system
> calls if the dma buf exporter is using P2P pages.
> 
>> I'm not doing it for any particular driver but rather trying
>> to reuse what's already there, i.e. a good coverage of existing
>> dma-buf exporters, and infrastructure dma-buf provides, e.g.
>> move_notify. And trying to do that efficiently, avoiding GUP
>> (what io_uring can already do for normal memory), keeping long
>> term mappings (modulo move_notify), and so. That includes
>> optimising the cost of system memory rw with iommu.
> 
> I would suggest leading with these reasons to frame why you are trying
> to do this. It seems the main motivation is to create a pre
> registered, and pre-IOMMU-mapped io uring pool of MMIO memory, and
> indeed you cannot do that with the existing mechanisms at all.

My bad, I didn't try to go into "why" well enough. I want to be
able to use dma-buf as a first class citizen in the path, i.e.
keeping a clear notion of a buffer for the user and being able to
interact with any existing exporter, all that while maximising
performance, which definitely includes pre-mapping memory.

> As a step forward I could imagine having a DMABUF handing out P2P
> pages and allowing io uring to "register" it complete with move

Forcing dma-buf to have pages is a big step back, IMHO

> notify. This would get you half the way there and doesn't require
> major changes to the block stack since you can still be pushing
> unmapped struct page backed addresses and everything will work
> fine. It is a good way to sidestep the FOLL_LONGTERM issue.
> 
> Pre-iommu-mapping the pool seems like an orthogonal project as it
> applies to everything coming from pre-registered io uring buffers,
> even normal cpu memory. You could have a next step of pre-mapping the
> P2P pages and CPU pages equally.

It was already tried for normal user memory (not by me), but
the verdict was that it should be dma-buf based.

> Finally you could try a project to remove the P2P page requirement for
> cases that use the pre-iommu-mapping flow.
> 
> It would probably be helpful not to mixup those three things..

I agree that pre-mapping and p2p can in theory can be decoupled here,
but in practice dma-buf already provides right abstractions and
infrastructure to cover both in one go. I really don't think it's a
good idea to re-engineer parts of dma-buf that are responsible for
interaction with the importer device.

-- 
Pavel Begunkov


