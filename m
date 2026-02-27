Return-Path: <io-uring+bounces-12471-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qK2OAh0Domn5yAQAu9opvQ
	(envelope-from <io-uring+bounces-12471-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 21:48:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 719A31BDEFA
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 21:48:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0362530913FD
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 20:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AE1538A714;
	Fri, 27 Feb 2026 20:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fR+CSNf6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25E6372B4E
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 20:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772225304; cv=none; b=tPZH05+ySRwKJCHdYe9b+PoDuakW9ZHOwazq3cscApS7LGtGzsncuRquoChnuPKi9FdX7gfNIVXwtYVUEuR5zmcOZjxJuZ9zby9P3i6qhA2dn5X+poduMCfXWhZZmGL/bOP0hQ042dK8KYd30X9wFVoP1XFKxu/7bEinELVIwF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772225304; c=relaxed/simple;
	bh=IGfb1kLmcBrVmnBiSaNaZ9o6tR51V8EMPWSkJML7PBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RmvWW7ngt8x8koNWx0wtJb+sWFBkbdgkN5aaBVLOMFMvj7UTMMp7n/GeU9DM+bxqEYMDqhiUKLYmyYSLB8O1N+Nt+TVTCcu5INqZQPfdIGmkYu82MT5vP38sBxltzieSQwz5R8LwaYlOYdLkDKgSWkyb50nmmCA8Mf3WJerEtZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fR+CSNf6; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-436e8758b91so1623921f8f.0
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 12:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772225301; x=1772830101; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xcg3jBdVXKkgCFEIQmOkVAOPdVJjauymlm8Tt0QYeSQ=;
        b=fR+CSNf6l+26DT1T24a34fBF0wrn7UdnOaPm4MxXCzxhBuQAnEoXWhMcH1apoYHlZo
         FVEUZX4XFU5s9uy4fSagO9wjAVuN1fZFImC1t2Vygv3AIzub2ClmUgJbCEBzVe4dxM+X
         PD7z1knC0l8ZEp+3k7bxpoV1DIGoJUgaDLhKVGkvZ19bCWElUpbyuFf3yR9YIJoDYR2w
         qiz5vP4YyHeZ0dUW0WvUYEObrfj1Bkt8lzz9rsxbXCCBaW8WYOAuL/ugRzSB82v3HJk9
         N4ycrgO4MAFx10xMXi35eX7T2P7or31tWkdHoDS1OhhiOn7xbmXresYPr1fFy+NS5SWs
         zeVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772225301; x=1772830101;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xcg3jBdVXKkgCFEIQmOkVAOPdVJjauymlm8Tt0QYeSQ=;
        b=xHEY0/tSzRsFutxP9T+G3izxwPRjkg6gc1BlJXx7ztgurCaefN5Un1DT0g8XIylSEw
         OyxnzKXiJREkM0hGSWhybTyWhhcF56wkrtFvnOIIO8cMseTWmJ29FkoaMr31s4YYTY6h
         nX1L8V+AZPDTQyZerIwJcSPg0nGiZKK2h6pL10vEIG5mD1/GMmuqvVkY5laXPFKOuOO9
         Tf1fU70kAvubjTUOB2fafkIqB9QdNwE5tHupAV07eVvNEvuxk78mgje+LafBzC+CQkSD
         5FI/bSplh+00ubYgGlL35Q6nuYeisabRoXuzsoDRwAy5kZxExQyPiUswCeGLuvDA0Ila
         PKEg==
X-Forwarded-Encrypted: i=1; AJvYcCWZeQA7LsgaxP6gTMMd2Dp3DE5RMwAGrlrUKpktji2oecKWoWteQxvMAJZ4h+icGDMHUm0lv8/BIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeSEqRKqKTtdjNQvFGbnaLGAIAwQQzZmphGEF/ZQAk+CrXTx4F
	qRYg7Y1W6PdidhRSNvvi5PhuV7I7DIlAr+jQ50g6tkbqpWn4KwhIqkaJ
X-Gm-Gg: ATEYQzyuLoVzawlMS+nQwOtST8wTxEWs5cTrzgPOvesPjw6kW+6xM8SS9qAtSFXsOYm
	UuonMHWEdpN/h6NIB9Yq7s4ZyKaqqmsEiOuPsE0fwKxdeeFEfFTLV7cDxjQqeNpV1Vy7/SAzpSP
	mFIJIy6Ha4KqagV1KunquLYzjHDbO8co//AsjTTx/yMv+HVrdhLTFzCsK3JCo10csjdpwX1NuQq
	HgeXbLaP0uWTvmOfE62KuY1Zbaag8NetJZ7bL68KdrQ/7iqA7vKtjVbpfCm3QCRlAy41qFoB8/Y
	seAricoTAfCG5MHJHAf4TJ+Va5syMCabhF5Jy6th703YTLdEJUkTnXfCQdaSN2q/wjclwtZT/TJ
	/0ZG46bS89LgiUUgqPFiW1gdJDbbX3kXAAkaMirABp+VVaB+atpFlgHjiEpfwIZ12JhetwbJcb8
	g5CSVkkiQg1BiZ6RXGavhhUtq8t2XySNETLXs50mcr+eekv54bTCmJ+k2HBr5OE79zafX6+vzpN
	TG/iUm6DvhB6EHHYa8cpTWX81elZs56GRSym73LlNL6LqndU5s9k10QSPkDEAoiut1Cg7KuLJ4h
	VA==
X-Received: by 2002:a05:600c:a16:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-483c9bfb2f2mr65037215e9.19.1772225301182;
        Fri, 27 Feb 2026 12:48:21 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfb87030sm67387005e9.10.2026.02.27.12.48.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 12:48:19 -0800 (PST)
Message-ID: <ae3d2ea3-c835-495b-a033-01a5c9fd82fc@gmail.com>
Date: Fri, 27 Feb 2026 20:48:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, csander@purestorage.com,
 krisman@suse.de, bernd@bsbernd.com, hch@infradead.org,
 linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
 <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com>
 <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
 <CAJnrk1YoaHnCmuwQra0XwOxf0aC_PQGby-DT1y_p=YRzotiE-w@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAJnrk1YoaHnCmuwQra0XwOxf0aC_PQGby-DT1y_p=YRzotiE-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12471-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 719A31BDEFA
X-Rspamd-Action: no action

On 2/27/26 01:12, Joanne Koong wrote:
...
>>> Regions shouldn't know anything about your buffers, how it's
>>> subdivided after, etc.
> 
> I still think the memory for the buffers should be tied to the ring
> itself and allocated physically contiguously per buffer. Per-buffer
> contiguity will enable the most efficient DMA path for servers to send
> read/write data to local storage or the network. If the buffers for
> the bufring have to be allocated as one single memory region, the
> io_mem_alloc_compound() call will fail for this large allocation size.
> Even if io_mem_alloc_compound() did succeed, this is a waste as the
> buffer pool as an entity doesn't need to be physically contiguous,
> just the individual buffers themselves. For fuse, the server
> configures what buffer pool size it wants to use, depending on what
> queue depth and max request size it needs. So for most use cases, at
> least for high-performance servers, allocation will have to fall back
> to alloc_pages_bulk_node(), which doesn't allocate contiguously. You
> mentioned in an earlier comment that this "only violates abstractions"
> - which abstractions does this break? The pre-existing behavior
> already defaults to allocating pages non-contiguously if the mem
> region can't be allocated fully contiguously.

Regions has uapi (see struct io_uring_region_desc) so that users
can operate with them in a unified manner. If you want regions to
be allocated in some special way, just extend it.

> Going through registered buffers doesn't help either. Fuse servers can
> be unprivileged and it's not guaranteed that there are enough huge
> pages reserved or that another process hasn't taken them or that the
> server has privileges to pre-reserve pages for the allocation. Also

There is THP these days. And FWIW, we should be vigilant about not
using io_uring to work around capabilities and mm policies. If user
can't do it, io_uring shouldn't either. It's also all accounted
against mlock, if the limit is not high enough, you won't be able
to use this feature at all.

> the 2 MB granularity is inflexible while 1 GB is too much.

-- 
Pavel Begunkov


