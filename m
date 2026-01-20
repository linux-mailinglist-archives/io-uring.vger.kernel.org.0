Return-Path: <io-uring+bounces-11835-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wDjdMzRScGlvXQAAu9opvQ
	(envelope-from <io-uring+bounces-11835-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 05:12:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C24050DFA
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 05:12:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3DEA9661B62
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 12:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35CEB426D23;
	Tue, 20 Jan 2026 12:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MfO4/tth"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com [209.85.210.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3F93A4AD4
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 12:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768910656; cv=none; b=jhgsKeq1Zjj+Vk0n8MFU8dyr2UtKD9E2rlDWLqvIf2QYdmOYqsTID+GqDGVFY7y1rFR3HPxHGMmcsEVKM+wAmsmBiBUvuGL6G89bUoVOrGS7f9Vto5NuRCAGZXITYBcgU9I9uZm/MwOtZXMLSWATA/VtYEorB/aubzwwjWkMZA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768910656; c=relaxed/simple;
	bh=N5V/193EphN1/dy/Da4Wf3eE2aKK1lzEAiTEDPjaRgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VthfdZk0NzjCXxiRWwLSDs0nXGzHxU05zu2I65fJg8CswauH9R5pSbSo4OET2S7IQU2dszJq4BWDH8QNWFk62Z0CeWRf9RkK8sQ3gINPzoqzu/ZyKwaJbydVgLszXLM7ZHSw0kZ3rrUYmBsnUiDPASXsm++1j8flN+KzhrO9eTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MfO4/tth; arc=none smtp.client-ip=209.85.210.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f68.google.com with SMTP id 46e09a7af769-7cfda2de4efso4611936a34.3
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 04:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768910652; x=1769515452; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vul17wrC6MbwDzM3wl7ZegOxGyDJJHAhPHQeTyTGhs4=;
        b=MfO4/tth8y9dh7pxTOPmHF/BayucmzwncBPiJwMCjJcx0FDhdLlXvwCuNd8wQB+1sp
         zKc87L2zUsHryD9cr0ULpW5rfpiUBMUHc1X1LM4kqPzprpga9FNs74rIV3n4W29utpx/
         rUk27c0kaSSOSxeqdya2jUbqqYicTowy9DJ1fi4ciPxh3LfjtstWc+i5IfizEWv7QWWR
         W+clwyABC8gXVF3/AmMbsVBpxA8ubvEqVeJtcMHohtJmctZxW3gNctSoWnTC36e8JDMi
         nPrBp1yzY+VAAfqvsqFTeU0XAOwEvre8GeiuYb/bhKJyN5evbtJuJR6y9gXQ/frDMUi9
         C16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768910652; x=1769515452;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vul17wrC6MbwDzM3wl7ZegOxGyDJJHAhPHQeTyTGhs4=;
        b=p9ktCHv3YcMnGlLM0/Y/6X8ns+d2oH766LshFIw+m9ujpZMqyz+nQkeXcsUiRo2yrv
         uW92CQCE0faCQ+A0v3teAc6Jz5l/Yu1yR2mbm9zeRmIyW5l5GIMPfYBTiD85eY+QyWCB
         MYlVdbDILX2GgQbBQv5jbqvUXvdlV35i+zV5CVGa6fV+I3vdg+35EURD5PLo9R22aexF
         mcUI4HLVpWCmUbL5eBhToY2Pa5maYxcfQA9zx0resh+i153G7eHXcE2y/ZIj2ZV4n9JJ
         /srfN80aE1lVgrJjQ9qAuQIDcI2Qc5XIVr9WkBdZ7Y71KC6wAZfm6f/0u/p7gim5rrR6
         OhYA==
X-Forwarded-Encrypted: i=1; AJvYcCWfupsjCxMk0sxZuVbAMMwf66E24cRzCdWRN1vqGqPHStV/WE+F9Pxr38jgwbpWBseRqEZYvNXpgA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNEMdBuhAS3m+08A2MXIKpWZXJaG3RuuuG0k++imgEpJja37n+
	+VST8DITMBIuEVxv4lsEPybX9n1qnQU1VeuL1PNzmcgmUNIdd1bDhkGRvd0EvSMQYMw=
X-Gm-Gg: AY/fxX6F0VUhGL1cYPBxzfujtiK6rE3Js7bDCPIkKx1jBoKIVVCrkAfA1IXGSnicXPn
	nDSXyoV9Y6LNDhbZUuEFhHqhe4S3EvyMzMphxFsM15iPklY3T4GJPQ9srHmGlrs5BTFwsAeVZn3
	KCUqIUWKjZ1J00l/jfmTsIE363V1cpaPKMGHcczOPDLuEQBiboOaW0An0WxXsdR7fXpA6gH37Nq
	3sHRxOFDwug8A50S4OTJ9OBzZKqYf4fTFDAgZ2cQs8+xME954RRs0LlR7qZqOc35Mr8+L+9+5Qh
	DYseewHBAAdriA+1UqRuh65054n/b1K7GdMErHpesoFXloHXXKq72FxzID2kiHyYWuzp8ohANah
	RdXRBbMRlKpxSah1e9Dxf4Cu+LUv3aRC4JngG9QKlneozq2iXfFiuJm382cWJwZzalaImCTCd9G
	tzklp5dtsV/7ZhrU6D7ws9vF+FH5nKRw3D6yvAS8A9gHz7TfFnRSybek5OlrVLUil3nJ6W6g23u
	qe+v+C1
X-Received: by 2002:a05:6830:67d5:b0:7cf:cc2c:1d9f with SMTP id 46e09a7af769-7cfdee6326dmr6316522a34.32.1768910652662;
        Tue, 20 Jan 2026 04:04:12 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2b5a74sm8318908a34.29.2026.01.20.04.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 04:04:11 -0800 (PST)
Message-ID: <c019c249-ae7c-4034-9d1a-e4b9e200453a@kernel.dk>
Date: Tue, 20 Jan 2026 05:04:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
To: Yuhao Jiang <danisjiang@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260119071039.2113739-1-danisjiang@gmail.com>
 <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
 <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
 <2919f3c5-2510-4e97-ab7f-c9eef1c76a69@kernel.dk>
 <CAHYQsXQK4nKu+fcni71__=V241RN=QxUHrvNQMQtPMzeL_z=BA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHYQsXQK4nKu+fcni71__=V241RN=QxUHrvNQMQtPMzeL_z=BA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11835-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCPT_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,kernel.dk:email,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 7C24050DFA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 1/20/26 12:05 AM, Yuhao Jiang wrote:
> Hi Jens,
> 
> On Mon, Jan 19, 2026 at 5:40 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 1/19/26 4:34 PM, Yuhao Jiang wrote:
>>> On Mon, Jan 19, 2026 at 11:03 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 1/19/26 12:10 AM, Yuhao Jiang wrote:
>>>>> The trade-off is that memory accounting may be overestimated when
>>>>> multiple buffers share compound pages, but this is safe and prevents
>>>>> the security issue.
>>>>
>>>> I'd be worried that this would break existing setups. We obviously need
>>>> to get the unmap accounting correct, but in terms of practicality, any
>>>> user of registered buffers will have had to bump distro limits manually
>>>> anyway, and in that case it's usually just set very high. Otherwise
>>>> there's very little you can do with it.
>>>>
>>>> How about something else entirely - just track the accounted pages on
>>>> the side. If we ref those, then we can ensure that if a huge page is
>>>> accounted, it's only unaccounted when all existing "users" of it have
>>>> gone away. That means if you drop parts of it, it'll remain accounted.
>>>>
>>>> Something totally untested like the below... Yes it's not a trivial
>>>> amount of code, but it is actually fairly trivial code.
>>>
>>> Thanks, this approach makes sense. I'll send a v3 based on this.
>>
>> Great, thanks! I think the key is tracking this on the side, and then
>> a ref to tell when it's safe to unaccount it. The rest is just
>> implementation details.
>>
>> --
>> Jens Axboe
>>
> 
> I've been implementing the xarray-based ref tracking approach for v3.
> While working on it, I discovered an issue with buffer cloning.
> 
> If ctx1 has two buffers sharing a huge page, ctx1->hpage_acct[page] = 2.
> Clone to ctx2, now both have a refcount of 2. On cleanup both hit zero
> and unaccount, so we double-unaccount and user->locked_vm goes negative.
> 
> The per-context xarray can't coordinate across clones - each context
> tracks its own refcount independently. I think we either need a global
> xarray (shared across all contexts), or just go back to v2. What do
> you think?

Ah right, yes that is obviously true. Honestly having a shared xarray
for this is probably even better, rather than one per ctx. Should not
change the code very much over the existing test patch. And it won't
consume memory on a per-ring basis. Downside is of course the need
to synchronize updates, but should not be a big deal as accounting
isn't a fast path. IMHO, just go that route.

-- 
Jens Axboe


