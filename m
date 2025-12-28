Return-Path: <io-uring+bounces-11314-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F1880CE51AE
	for <lists+io-uring@lfdr.de>; Sun, 28 Dec 2025 16:02:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8569D300A34A
	for <lists+io-uring@lfdr.de>; Sun, 28 Dec 2025 15:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24771D9346;
	Sun, 28 Dec 2025 15:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IYOoeCS+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HOEFL+Ai"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1240A1F4615
	for <io-uring@vger.kernel.org>; Sun, 28 Dec 2025 15:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766934145; cv=none; b=YYKGSbXNGfLYK08NoYSoI6vSIMjjx1vkxusazjzUIkFhLO+57LRGt9r19InYy7WpFrSF4UY95c5iGlFXWIfWftvEBRgaOzyPvvDpyF5RY4TSTq3kNmtNiAobQQD61Ai06Wu63kXGH81I8zIDAQyXtIOlTn8utlflafyvF+y9YKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766934145; c=relaxed/simple;
	bh=RDI3VrEbchG391k8f7u4dPDQLKRuPGaB0glR5NyXv4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i7p2UfBA6rPefBwiaUjxud/pRF2cBzlpB69BPWtnle8nSLYppRx/t4x/gZIA07DJ96kd5SzUEhiNcxhcq1RZVPjd7uxch8w+V2s2x7RO0Fnq4rD1myfXu8A9vTUPWyNB0C6xvcnDs10UphncDv8ifg9UzrK4pT6tZuUlefy6jl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IYOoeCS+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HOEFL+Ai; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766934142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uirCeyBb3g6S/NRXILsUBYspxdlSYbkXOQaSFgZb15M=;
	b=IYOoeCS+5eaPwXMT/+Okj9F7HPGJK+WQiaZNV7LUkIig7oPmIGVg+pTitbpkGjb0w+dfqV
	3eDeFXVgbUeKRX4A7dgSsdyAKf51RAl2Ag4druN5hodbtu2QkQMllL+7mBMWJgHv5yXxud
	Iu5EvUWXlvRsG7wsQcVZrRjweWrj9Ww=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459--Yx5U_n7OB6mdu32139C7g-1; Sun, 28 Dec 2025 10:02:16 -0500
X-MC-Unique: -Yx5U_n7OB6mdu32139C7g-1
X-Mimecast-MFC-AGG-ID: -Yx5U_n7OB6mdu32139C7g_1766934135
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fd96b440so4367770f8f.1
        for <io-uring@vger.kernel.org>; Sun, 28 Dec 2025 07:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766934135; x=1767538935; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uirCeyBb3g6S/NRXILsUBYspxdlSYbkXOQaSFgZb15M=;
        b=HOEFL+AiTr4Gwc6PKh1A0yGNeYv7Cd1tLD9d6QX1KMp3o2HWmEwnkFsdHahKJVP/ES
         Dx6wsL1XXHZPGtUSFPEWKOpVgC5KIzglPsIWN83pHhxxZvenTr+ZtJa/7kuEp3eenQI1
         bnoATY8Mt8BFKdEP5VWOF4fg/XfKcKr7Mor3/YLhDnhgHLxYBCqkITTyZ+NAfeW4uB+4
         /c2N+80xCecyq+SXG3w8OQg5pc0LnKeEacflI3YOYpXwhx71rMC3g8nzRNgBSTJ5W2mM
         WYamU8gleFlB+12OYApkUFVhUUTlg488mIaex4zEbIdV/Cia3sHY3DtZ4m8Dmp7qBM54
         3AWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766934135; x=1767538935;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uirCeyBb3g6S/NRXILsUBYspxdlSYbkXOQaSFgZb15M=;
        b=oHiB2rbtsvDYxf10sPmENUiTNpehMsItQXerCWRfCzKnciqEN1rXIz4EXaEFrTTv9d
         SPR265aIsy4LaSrEebjuc22uYvmaMN62AMqXuhhtSdC9wb887EUo3rmFFI/cRO151baK
         CojBtT2ywLUZnM05Av19z6WuDLLX68nKTWwsBLrdFlFDPfoXVXqKIkMyAFi4RUszrycp
         tId8fXOHltCkvXmWbUoVnNEB4FtJ/SkEmqkYiXOnTHwu2wtY/KTzXOKzKdTWuRApwBHU
         cDycEgPvQJbo0SxTgac6DmuFv72ND7+uOl8JNbcjFvXKGhbbOrSYqz7SW04BUFRoWYma
         JqTQ==
X-Gm-Message-State: AOJu0YxEDQ2M4LBXMA+wmg6EvYFH/DFUtYfIP84NCno+AwmW48PWed3L
	SJxYLBL/UM5hFI2DaOa4JHY5vvJAjRGgFTEg1n2F7oZ26KwwlxCb78tYjAyl3MF/2Y1Y50BzCGf
	GcfotIsP54IDhgcj3yF0OmQsxX6l6w0HdEFpWbkzzLFllQcaGTK94yYRtO70u
X-Gm-Gg: AY/fxX60ffwF4x6rorkp6htFvPVo33FrRBLbdCdS97xL2Zl60mx8E/f+Aj+DVSemJn9
	5ggCCUrjs6WuFR3ZPxCX8b7ewg5yC276GRgq6SfrnVsGif/hTI8qUACjEuZ5E0O2auCS22xU/kA
	1KEUpKeUqHFXpmcomt6k4ARx1vdtTd0hr340+Pk8bhEDcS4JxOdmN/i+VCKT3EI5269do0zi7Ye
	AyS8qa0TjMtb/aLD4JIHkYtHrkpfGeyI19iJd/YGjLJ7NsIb3yhS8ifRJbEDL/eXeO3DunXkvOM
	5mFDXbzUcDYu3BXLupfqz6BT7zScp9Yo1zkQEOn/Kc/R3QDGF1bDjGzbK8wkXGUGqy+6H43wq9v
	+KDp9tBehBOCfiw==
X-Received: by 2002:a05:6000:2303:b0:42b:5592:ebe6 with SMTP id ffacd0b85a97d-4324e459b12mr28415761f8f.0.1766934135339;
        Sun, 28 Dec 2025 07:02:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFMdPMfcWK3Ww4uTDkORmoROiGmQGrC5u+pZCYH+ScC3b8Rb6DpeHfZgh0Tmx3FKkXk1Pvqw==
X-Received: by 2002:a05:6000:2303:b0:42b:5592:ebe6 with SMTP id ffacd0b85a97d-4324e459b12mr28415731f8f.0.1766934134811;
        Sun, 28 Dec 2025 07:02:14 -0800 (PST)
Received: from [192.168.88.32] ([169.155.232.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43277b82a58sm23572604f8f.6.2025.12.28.07.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Dec 2025 07:02:13 -0800 (PST)
Message-ID: <3308e844-6c04-44a1-84c9-9b9f1aaef917@redhat.com>
Date: Sun, 28 Dec 2025 16:02:11 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] af_unix: don't post cmsg for SO_INQ unless explicitly
 asked for
To: Jens Axboe <axboe@kernel.dk>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 netdev <netdev@vger.kernel.org>
Cc: io-uring <io-uring@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Julian Orth <ju.orth@gmail.com>
References: <07adc0c2-2c3b-4d08-8af1-1c466a40b6a8@kernel.dk>
 <willemdebruijn.kernel.18e89ba05fbac@gmail.com>
 <fe9dbb70-c345-41b2-96d6-2788e2510886@kernel.dk>
 <willemdebruijn.kernel.1996d0172c2e@gmail.com>
 <0f83a7fb-0d1d-40d1-8281-2f6d53270895@kernel.dk>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <0f83a7fb-0d1d-40d1-8281-2f6d53270895@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/23/25 6:27 PM, Jens Axboe wrote:
> On 12/19/25 1:08 PM, Willem de Bruijn wrote:
>> [PATCH net v2] assuming this is intended to go through the net tree.
>>
>> Jens Axboe wrote:
>>> On 12/19/25 12:02 PM, Willem de Bruijn wrote:
>>>> Jens Axboe wrote:
>>>>> A previous commit added SO_INQ support for AF_UNIX (SOCK_STREAM), but it
>>>>> posts a SCM_INQ cmsg even if just msg->msg_get_inq is set. This is
>>>>> incorrect, as ->msg_get_inq is just the caller asking for the remainder
>>>>> to be passed back in msg->msg_inq, it has nothing to do with cmsg. The
>>>>> original commit states that this is done to make sockets
>>>>> io_uring-friendly", but it's actually incorrect as io_uring doesn't use
>>>>> cmsg headers internally at all, and it's actively wrong as this means
>>>>> that cmsg's are always posted if someone does recvmsg via io_uring.
>>>>>
>>>>> Fix that up by only posting a cmsg if u->recvmsg_inq is set.
>>>>>
>>>>> Additionally, mirror how TCP handles inquiry handling in that it should
>>>>> only be done for a successful return. This makes the logic for the two
>>>>> identical.
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Fixes: df30285b3670 ("af_unix: Introduce SO_INQ.")
>>>>> Reported-by: Julian Orth <ju.orth@gmail.com>
>>>>> Link: https://github.com/axboe/liburing/issues/1509
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>
>>>>> ---
>>>>>
>>>>> V2:
>>>>> - Unify logic with tcp
>>>>> - Squash the two patches into one
>>>>>
>>>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>>>> index 55cdebfa0da0..a7ca74653d94 100644
>>>>> --- a/net/unix/af_unix.c
>>>>> +++ b/net/unix/af_unix.c
>>>>> @@ -2904,6 +2904,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>>>>>  	unsigned int last_len;
>>>>>  	struct unix_sock *u;
>>>>>  	int copied = 0;
>>>>> +	bool do_cmsg;
>>>>>  	int err = 0;
>>>>>  	long timeo;
>>>>>  	int target;
>>>>> @@ -2929,6 +2930,9 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>>>>>  
>>>>>  	u = unix_sk(sk);
>>>>>  
>>>>> +	do_cmsg = READ_ONCE(u->recvmsg_inq);
>>>>> +	if (do_cmsg)
>>>>> +		msg->msg_get_inq = 1;
>>>>
>>>> I would avoid overwriting user written fields if it's easy to do so.
>>>>
>>>> In this case it probably is harmless. But we've learned the hard way
>>>> that applications can even get confused by recvmsg setting msg_flags.
>>>> I've seen multiple reports of applications failing to scrub that field
>>>> inbetween calls.
>>>>
>>>> Also just more similar to tcp:
>>>>
>>>>        do_cmsg = READ_ONCE(u->recvmsg_inq);
>>>>        if ((do_cmsg || msg->msg_get_inq) && (copied ?: err) >= 0) {
>>>
>>> I think you need to look closer, because this is actually what the tcp
>>> path does:
>>>
>>> if (tp->recvmsg_inq) {
>>> 	[...]
>>> 	msg->msg_get_inq = 1;
>>> }
>>
>> I indeed missed that TCP does the same. Ack. Indeed consistency was what I asked for.
>>
>> Reviewed-by: Willem de Bruijn <willemb@google.com>
> 
> Can someone get this applied, please?

For a few more days it's just me. That means a significantly longer than
usual latency, but I'm almost there.

/P


