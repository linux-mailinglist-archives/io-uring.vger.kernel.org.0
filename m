Return-Path: <io-uring+bounces-12809-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aNYsOi10wWkQTQQAu9opvQ
	(envelope-from <io-uring+bounces-12809-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 18:11:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 843AD2F98B1
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 18:11:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8B68F30458E0
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 16:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265033B8D5C;
	Mon, 23 Mar 2026 16:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NyoLjvtt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA0D3C1980
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 16:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774284262; cv=none; b=Ee9djfuF1piQu7yD4zClzi30BaqfpBJ78rQXISAeunIIaRQ+cXh/TysakUwEHCRzDbTiPYZzuSDepmOQdqd06cBuQZil8pI0dka7j7oytscGliI7CO+aHF4dQ7zWfLm/y+v8tpDKjaDXnuRT9rvKs3X10lWl1gfxmPLr0r0Dbng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774284262; c=relaxed/simple;
	bh=LBK1GfTkPqN/J3ekXfWul5rM7Y0N9TEPGG3iPFdaMvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DFozsLUscL2DBCr11UjKl5d/BJ3+xSZveU2SRlM2Zpu2+1ZNZBUSyXaONHOoBeBwVHSuLSXRciLoj4dUNeCn7R8KK8oZsHZEkyoAu3okD4iv2RrCGWML+TddMgcxkQRy9DNhl5EsG8eDvBniJWkk3+I+9zwruscuAMlQ/oG4b+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NyoLjvtt; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d4be94eeacso306022a34.2
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 09:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774284259; x=1774889059; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F+mUNq7tmfNnDvMUw7l2UsagRnrJrQ3LN33pu/ZkAt8=;
        b=NyoLjvttGaqUi2qQdd/BWFA5gUXTdp5SiHrUL95B6IdPIzMlHXKSFtQJACLpfCbjjT
         ezrNB7amSMh1fxXOWG1zOMGz6QC3UdI6Y2H8nMJ0vxmrdaicm3AEyDP3E5BuGHdviHg0
         +wZ2cuN5h4ev6s6kJu75whMjQxzzzV94U/f07UAzm3ZKUJcop82jb6NImgwQaEH6OCEh
         4wAxiOK4x4Pe5QRvQNrF2kjFqCFvQNzVPrEOD6wE/kRRv24iCOcv0Jg4KWZS2z5Ajspz
         s/SO8nut7rCN0RF3VqvZkqF/09uUJLyLoBkhYcaGOm9zppIKwLPGYJQbMbODnC92OLhL
         59jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774284259; x=1774889059;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F+mUNq7tmfNnDvMUw7l2UsagRnrJrQ3LN33pu/ZkAt8=;
        b=AiuB+Rvilq2p9R8/AhVhsS9jFprfwX3HImDB5EVVQuIzbyJNrWQqGvvswflE4Wwv0l
         JKf5TSh6Qizg9YEGHTDACNdZP23OSaqzWSg6Wfrz7cgnGIxSEkvrGBAQ5yLZncnJ7FWg
         Vsv8INtwSbpS8JeGmBqUwb9wNpexR4ZitGjQb/wuJW2Ff6mmmK5Iz2IrlEegIZ0aaphR
         toFtG5o0Uq+bwe9lRQ83IRtIN2VixeeLw8s9S1/h+z42R0X5l9zYUzdGgk7fSjXqlgQE
         xJzxB5O5b+Qye+ousr6QQD7Ay7vXBwrii2T3pKIlQUguXMdFD7bv437QJynf8zg1e+1R
         0rHw==
X-Forwarded-Encrypted: i=1; AJvYcCUDICrMQEXbljTy0QlOE5ZaaJ3jNUPuoW0kDPiqCZDVrouLoBtFTL9Xmxk6DufAyXoGKAqjUtIwgw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzV0l6usBJizEzlgUhMfa96k7G3kmVT0NWT9r6dkcMEFvhJnxIn
	AP096T37T8Gy1QJHf/ys1Dtb3EsHqIzN511BoEGCCQUr9Mfya8zFf1oNX4noLW6s55z+njYE0je
	RMYvxUgw=
X-Gm-Gg: ATEYQzwg/E4xdU2ivpi5+qUZto/VkRRrNSquNsciwar/8ksSFmH4wHWUX7kJLrq4J6+
	aFktj+E/o5FSIEpdqNNZoAYQhSkEEj/APgtt9T7vNmdWSN1305wzbePeIEd2FJkJvd9vFnc6gXH
	acdF/0L1VG4bATW6QDqdfOl12hOatYhAJUMZhAYuvqKY0zvv7X9z90n3kuf7ZTfYBFes1AoUEyG
	t9cB4/Ep50n93tddQW/nyhKi2AZtCqoXHH7pF2pjnEuVj2WXXCmOGLDQWriYHhs7NEEKveR/w2r
	WVuVp6jLqa2BZZX8e2DO2bg+6qngcNlGPF2kJ9lsORF9+OBlJMF2ItGqHcXykTJWtWQ/6vreNXI
	/977oKorDo310G9wD3zqslfLbJiENloaI4qbWp4X4NmwHtFiiPgOPff7JpvLj8S/HwZKvutEg8g
	i1qWJck57sww/yQqJrLsn1aUWxEuSXKG/YZjOF+IBiGdt0lVuQmjGeN59Hkp2EKJqyVgx+6wgEn
	FH43T0Y
X-Received: by 2002:a05:6830:81cd:b0:7d7:f15b:bdcf with SMTP id 46e09a7af769-7d7f15bbee3mr8134708a34.28.1774284259411;
        Mon, 23 Mar 2026 09:44:19 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7eabe8dfdsm10044182a34.5.2026.03.23.09.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 09:44:18 -0700 (PDT)
Message-ID: <71c67415-497a-489a-9b98-9c85ae89a8f2@kernel.dk>
Date: Mon, 23 Mar 2026 10:44:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.1 01/16] io_uring/zcrx: return back two step
 unregistration
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org, Youngmin Choi <youngminchoi94@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
 <0ce21f0565ab4358668922a28a8a36922dfebf76.1774261953.git.asml.silence@gmail.com>
 <1b3ad321-866a-4cb8-9810-5eae7805647d@kernel.dk>
 <d1981803-0b3a-468a-9fe6-a751470cec26@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d1981803-0b3a-468a-9fe6-a751470cec26@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-12809-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 843AD2F98B1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/23/26 10:14 AM, Pavel Begunkov wrote:
> On 3/23/26 15:01, Jens Axboe wrote:
>> On 3/23/26 6:43 AM, Pavel Begunkov wrote:
>>> @@ -898,12 +933,15 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
>>>               unsigned long id = 0;
>>>                 ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
>>> -            if (ifq)
>>> +            if (ifq) {
>>> +                if (WARN_ON_ONCE(!is_zcrx_entry_marked(ctx, id)))
>>> +                    break;
>>
>> This break is inside the scoped_guard(), does this need an ifq = NULL
>> here? I do like scoped locking, but this seems a bit tricky...
> 
> That should work, want me to resend or would you amend it? It's a good
> thing I was pointed at it, but I'm not too concerned about this case as
> it's a warn once.

I can add it and add a note. Outside of that, I think the series looks
fine, no further comments.

-- 
Jens Axboe


