Return-Path: <io-uring+bounces-12395-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wNy3GYasnWmgQwQAu9opvQ
	(envelope-from <io-uring+bounces-12395-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 14:49:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2803187FF2
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 14:49:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EB791314BB50
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 13:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE8439E6CB;
	Tue, 24 Feb 2026 13:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EzhlVvoJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEBF395DBF
	for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 13:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771940925; cv=none; b=aS0hYFcakGYnPbP1NwQNNPXfn374t+xd661EROztid4ReAWhGhMu5noDybJUoRllfMc+h/kFxx4yrW/FZJOldhsVz27xzgbquHmE+4l81YNaWPViNEWbVrOZVGmaXgyH63S+pfadp6/WS+zsBDJtqC0zGxWzrT5oj/6vEkuMyaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771940925; c=relaxed/simple;
	bh=EFzZrlZ2A8XJECXkGSOPGAYLDNQ9+SHBQIYlc/V/zf8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gGX2QjVBjKmDcrbFeP9KSTUOXyzO2GhvYfOPTC+NFar3/9g3iWwG2zurcA/Oe/Ym4RBSakT+JMB1bQ8PDOz3/uVjaVjxy+MIAmTt0KEcuU9+mwX2eoIPSOowg2fm1YvtIcbKIRwVnwOIFhKbUVYJTz3NjHCqHl7o1bmH1+jeOy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EzhlVvoJ; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4362507f396so5264883f8f.0
        for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 05:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771940922; x=1772545722; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7doier/S6v57RTdBt1iVFnJdNLGw+lPl8KUgoSr5lVI=;
        b=EzhlVvoJr68dAV5eekTaSL5I86uAnH6oyagDe5AP2ZpWWis8KUIfu96ACoUQBUndoY
         2t6LuK6r0q2I80l0BY5oB9y3kuMH/c0B5L2yQbvVZEF7QWlp8sh6sQzLudZMg7k6CIiv
         bPPDABKEF4psEliEtsMnQb5vs9KH4B329JhIQrd05opQyH1Wpdp2wLRDDfeas+2H2W+H
         ZZxi7K6ayigCHchi2bZtZDc3LFiLgnQV9pfvWApPq3MKE4dRVBn2z0qS6+IRDq05Yw5a
         aj3gBTQ5CEZDHU8aK07nf4kfSiih7RHd77/yVDBuAUKJH90z6aD6grqmrf5KDuauRpF/
         FefQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771940922; x=1772545722;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7doier/S6v57RTdBt1iVFnJdNLGw+lPl8KUgoSr5lVI=;
        b=EFMh6HEGWGp3i2+kla2SfZyPQPx6dHf13wNAN3brX124nDptPaTWYbqTMTBEeBhZXm
         FZsFPAzHrjntyCgrRG6Bqa+6mEnn/4E2xE2MnLloED/qDtNeaMIlU59rqJrrQq4gtpMD
         ygXxSYsL5JxeOPBvRSVNJ+mkWLOcyDWOIW5pXMY7RCiWaM7kVds/PB8nq4a20GaBcaiE
         5NJ0sRCkCR7YQWdIdKADLRyuV6fSZJw76yrAZThNP7z7Jx9yYmQ0QTDTVpH312LjC8u1
         GuKi56rIj9Cr3u6GuMHKnwp1bBj2w2BjynTouB1tDaG/ALpVeG0eOeDwenNWS3oRbhN4
         5KJg==
X-Forwarded-Encrypted: i=1; AJvYcCX+if3d0r1AkQDJtJHxS1JJ+6cvfc//Nd0SJJrvU/mocJtZhMfLBiRxpNjOuQUFjcPRm5XeNQAY8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxslbFcmLncmdAbe0g94IkUAgLdCkn3hWCEeB/VOQHn8hIThh0o
	bCHkhM8he37eBQ9YZ9gGY7pK0HnCV6oJ/Vi/dIk1mcJuamKnAWzgs1Tm
X-Gm-Gg: ATEYQzzjG7WZZY7IHESzW+AAKn0sypd7fZFLZ5OigKxtxpnies3ZCooWDzlwRMOZ0ds
	WZYCJoTAT4GLjXd/Mm7EnRqvCOJ0JGQH6M7NRuV6otjNUUd+KNpoHdtWFbqUfVqm4QsP6zkmNUU
	q9xMAXBGx2pSRtsKE9bcc0O1Bof7Mnuo309L3MQohK7F+De5fvciSTI88JqQ+gzRVnlymQ/f89Z
	F8qCutQRh5kYBsC38ooR6bDcjnnPFP0At3qPyf5bZ9XluFB+pawcwkKTaUExWjc2MxxZG31tMH+
	Vev2K1ernvymyReSAQKQYzzWCuXEiO3K2Mze9IkKTGOK+DF/nFns7y3gyoKdJBR1K855ODY4x4e
	mD8X8FRa6BVgaNXYDPD//+9Z2sQkl/iNVD3Byxrctf6KESQXBFGwfs7WDgR/w/7FQYvm+rcfN6g
	JKpfefR7PLlIflkniBWbm72AdUBo3nb8TD2tMWUYBt8TguOGsDE4g4vs/GOzJq6YlgOhg6ST3ut
	lyqs7ZUr4LKEQlNPk3r8Zb4j1oMPn/8gz1P6GRhFQ3tDkG1puF+E2WUUYpPvdhL6Q1J8vYsVZn9
	CQ==
X-Received: by 2002:a5d:5d84:0:b0:437:69c0:9612 with SMTP id ffacd0b85a97d-4396f15af1dmr21713147f8f.13.1771940921895;
        Tue, 24 Feb 2026 05:48:41 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d3fc12sm24786376f8f.24.2026.02.24.05.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 05:48:41 -0800 (PST)
Message-ID: <b091a8ae-4767-4ca4-a1b2-09cb525c4ff9@gmail.com>
Date: Tue, 24 Feb 2026 13:48:39 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: "T.J. Mercier" <tjmercier@google.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "Gohad, Tushar" <tushar.gohad@intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
 <CABdmKX2+OiqobQKf5G0ABiTeW5oqXS0p1dH7wRe2H7Gwdroi0g@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CABdmKX2+OiqobQKf5G0ABiTeW5oqXS0p1dH7wRe2H7Gwdroi0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12395-lists,io-uring=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A2803187FF2
X-Rspamd-Action: no action

On 2/24/26 00:13, T.J. Mercier wrote:
> On Tue, Feb 3, 2026 at 6:29 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> Good day everyone,
>>
>> dma-buf is a powerful abstraction for managing buffers and DMA mappings,
>> and there is growing interest in extending it to the read/write path to
>> enable device-to-device transfers without bouncing data through system
>> memory. I was encouraged to submit it to LSF/MM/BPF as that might be
>> useful to mull over details and what capabilities and features people
>> may need.
>>
>> The proposal consists of two parts. The first is a small in-kernel
>> framework that allows a dma-buf to be registered against a given file
>> and returns an object representing a DMA mapping. The actual mapping
>> creation is delegated to the target subsystem (e.g. NVMe). This
>> abstraction centralises request accounting, mapping management, dynamic
>> recreation, etc. The resulting mapping object is passed through the I/O
>> stack via a new iov_iter type.
>>
>> As for the user API, a dma-buf is installed as an io_uring registered
>> buffer for a specific file. Once registered, the buffer can be used by
>> read / write io_uring requests as normal. io_uring will enforce that the
>> buffer is only used with "compatible files", which is for now restricted
>> to the target registration file, but will be expanded in the future.
>> Notably, io_uring is a consumer of the framework rather than a
>> dependency, and the infrastructure can be reused.
>>
>> It took a couple of iterations on the list to get it to the current
>> design, v2 of the series can be looked up at [1], which implements the
>> infrastructure and initial wiring for NVMe. It slightly diverges from
>> the description above, as some of the framework bits are block specific,
>> and I'll be working on refining that and simplifying some of the
>> interfaces for v3. A good chunk of block handling is based on prior work
>> from Keith that was pre DMA mapping buffers [2].
>>
>> Tushar was helping and mention he got good numbers for P2P transfers
>> compared to bouncing it via RAM. Anuj, Kanchan and Nitesh also
>> previously reported encouraging results for system memory backed
>> dma-buf for optimising IOMMU overhead, quoting Anuj:
>>
>> - STRICT: before = 570 KIOPS, after = 5.01 MIOPS
>> - LAZY: before = 1.93 MIOPS, after = 5.01 MIOPS
>> - PASSTHROUGH: before = 5.01 MIOPS, after = 5.01 MIOPS
>>
>> [1] https://lore.kernel.org/io-uring/cover.1763725387.git.asml.silence@gmail.com/
>> [2] https://lore.kernel.org/io-uring/20220805162444.3985535-1-kbusch@fb.com/
>> --
>> Pavel Begunkov
>>
> 
> Hi, I'm interested in this topic. I'm guessing this will be in the FS track?

Forgot to mention, I submitted it to the storage track, thanks

-- 
Pavel Begunkov


