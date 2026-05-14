Return-Path: <io-uring+bounces-13340-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMJRJIPiBWqNdAIAu9opvQ
	(envelope-from <io-uring+bounces-13340-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:56:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 916FE543912
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DEE34304E7F1
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 14:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE9240B6C6;
	Thu, 14 May 2026 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="dWpxW8Ol"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7897239E9A
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 14:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778769893; cv=none; b=ql7HGrxvLxIbWRL+uJ59Yp8LkROqH+/D2LSpdguHEVetWCiyGM537V3Nutg6lOuqQefuTYCn5Wbn4YOQCC3b/Lx8E1sIdGuzUVN9dEdBULL6ItLzfIBd0q8so+mRkDxr/swcQh7J+9wpeQS/YxddFijPzKT+zJPe5zmqFnjjiJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778769893; c=relaxed/simple;
	bh=hmCpIUiqtFhwwLPKL2BnJjS1oAreYkMIpTMK7i6x5BU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CpvLSWZTHLW/vuQ2gFhm1uxNvQFf3VQD41HRDOn4uxXdBsXbXK9bWKPSQMMcLlgNxLs5E1ucYGoOhc3Fq6PFh+sNCgWi0C7LtWKPU3SZdOR+muPiysdPPCUgDLzjiYOMYVBdkoCNUX3dr3IlHkGLLIwSyKLguYVUqrEsu5rD6Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=dWpxW8Ol; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7de46b8e432so7637701a34.1
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 07:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778769890; x=1779374690; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NS4v54YF5gKyAiMos1n5WlZ0/b6IiTDbCD3GBCwb72A=;
        b=dWpxW8OlCK8XrxZDiIp0z6yHVeZVPMd1Wp3otbDw9/U5Lg9Mcbv7VBVCTXOraEsv+X
         7xVvrknogQX4vogpXpYZF/hnZtlgsEZ8kVWuvAzvcKRvdGNia4ldcy2MA67PxJq9DOFM
         eHgWVPqeHLORE0I4JXrWWwv2U8YC51+DfxlbCpyUA9aKoytRCCI3s00R9jj8jVplAZZf
         19kB7hcAiCb1UFOGNzQXNhhMiKtIPRuA6g31JamGFHqp2a6YPkdMeGtUCwi2sA+5sigr
         NArTpUFPYsE+8HoRZtAB7eP7lmwo+UJhlmWG6534TVAfGKJcFTUTMQpBxvqyHE6oKXlr
         Dz6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778769890; x=1779374690;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NS4v54YF5gKyAiMos1n5WlZ0/b6IiTDbCD3GBCwb72A=;
        b=n8JB5Stug6Kib6zsTEGQ+qauWeb0RDSRMOAixW9OziGQAZ+i7oqv8QrHkG45Qc8Ejw
         0Oij1SmziXagd1gLGyJI7p9u2GmMxZDWHCtO7+9t17Fvk/E+TXD7dMquCBobyf7d8luK
         5yOiHNcDaIwjZ2UTjpA4/HjGueYjGLPcKbGMutuJiecFbuPc9lTnSQdrbVncH6K96Ar3
         gbM57a0/+pyhMFMP9MS1kNwcYf2CnUpK8dX1VQl5asmTXVWWgI1iQATDoJB1g0GL/JDU
         3D/uPQNQk5nUY6gDSWlAMHU2Jmg3HBGDuy/SG21YHPTwIuaLdPmAfg3q6bPbSM0Pq6wQ
         TTLw==
X-Forwarded-Encrypted: i=1; AFNElJ9qa5ERlj18sA6PTXvdGCQjROqWVa6gbwqALcykygktKWWrVC8fD9E7F+agec44wq+SFz5vziI5EQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyIlfpjBmv5za1pPfT3V4pDqnirOFhriKunvpymKhFncl51V8Ab
	NOxX1GKKc5rvliHvbW9AJ9Eo9Mvs6wsCztUUDFN+QG++0UPVQLCkIzGjhkBLrJJVJaY=
X-Gm-Gg: Acq92OHGNRgJ086VkooNKTQsjENdMBPQPqsf9kx3SnHx3ITjXRDa6elwcFUEvb6eCNd
	qOjYG0/hdYC85t2lttLGuC1Zn/UikFpJadjwT1pfRK6DneWnCd9z7JMKvF913dOD/ToGo8lT3qG
	w48shz03c2RBJ9Vh85P/BG5b+E0Yr5SOd/uJBygmBnn8yze8wiGI/XwqzOzVWKvKSUVG687XWLI
	D2qsOuTU9CBjVQsxAropY8Xsy6GQFpvOgrUxfvvZ/cXWe+17gK+5cM1b+VjcV96qT2eTxfW6Wxz
	IZFFqvrhumnGdwGaUAvRTG8iqyY7CXKFtSQmfMOGlqMoGI6tguwoEH/0QO36QtzHr/q4mvdzxev
	Vqg2lmu0W4pYho3oRvGF5RzSoJSTSiy4aJPkIdUS4qRvbfHZzujGAzNyi2yrJiq4mXtxGhWSV6O
	9mnn3PPRjWtl181B8A8DQU9Rby64UmHqSoPBrShtfYs5FAYLCreOPOb/FPMf3OZMGYelcRWU+xO
	RS69Ou3
X-Received: by 2002:a05:6830:82e2:b0:7dc:e08d:d9ec with SMTP id 46e09a7af769-7e3dc877e29mr4738480a34.15.1778769889803;
        Thu, 14 May 2026 07:44:49 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e3f3e8ad4dsm1922330a34.18.2026.05.14.07.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 07:44:49 -0700 (PDT)
Message-ID: <0673a432-6d70-47b0-bb54-42f6a207d2b2@kernel.dk>
Date: Thu, 14 May 2026 08:44:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: parenthesize io_ring_head_to_buf() expansion
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Yi Xie <xieyi@kylinos.cn>, io-uring@vger.kernel.org
References: <20260514083443.203387-1-xieyi@kylinos.cn>
 <CADUfDZoYZ5hGejvoZrCzhef2LrB04cbDsdoe+jyGnhL6Pnn4FQ@mail.gmail.com>
 <49a10373-f2d8-4813-b9d6-25cd2a0f2fe6@kernel.dk>
 <CADUfDZqGmQd0t0614yU6FKYWs74iFWnuEhp0BaxTfgDWwLDLLA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZqGmQd0t0614yU6FKYWs74iFWnuEhp0BaxTfgDWwLDLLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 916FE543912
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13340-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action

On 5/14/26 8:43 AM, Caleb Sander Mateos wrote:
> On Thu, May 14, 2026 at 7:25 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 5/14/26 8:22 AM, Caleb Sander Mateos wrote:
>>> On Thu, May 14, 2026 at 1:35?AM Yi Xie <xieyi@kylinos.cn> wrote:
>>>>
>>>> Wrap the io_ring_head_to_buf() macro value in an extra pair of parentheses
>>>> so it is safe when composed into larger expressions, and to satisfy
>>>> scripts/checkpatch.pl.
>>>>
>>>> Signed-off-by: Yi Xie <xieyi@kylinos.cn>
>>>> ---
>>>>  io_uring/kbuf.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>>>> index 63061aa1cab9..dd54e43e9ddf 100644
>>>> --- a/io_uring/kbuf.c
>>>> +++ b/io_uring/kbuf.c
>>>> @@ -21,7 +21,7 @@
>>>>  #define MAX_BIDS_PER_BGID (1 << 16)
>>>>
>>>>  /* Mapped buffer ring, return io_uring_buf from head */
>>>> -#define io_ring_head_to_buf(br, head, mask)    &(br)->bufs[(head) & (mask)]
>>>> +#define io_ring_head_to_buf(br, head, mask)    (&(br)->bufs[(head) & (mask)])
>>>
>>> Is there a reason this can't just be an inline function?
>>
>> No reason at all. But also don't see a strong reason why it can't just
>> be a define. And generally I don't like cleanups like this, but this one
>> at least made sense to me.
> 
> A macro can certainly work, but as this patch shows, it's tricky to
> remember all the parentheses. An inline function also results in
> better compiler error messages since the arguments are strongly typed.
> And not applicable in this case, but if an argument is used multiple
> times, a function ensures it's only evaluated once. I would generally
> only reach for a macro when something can't be expressed as an inline
> function.

I do know the benefits of a function over a macro :-)

I just don't think it'll buy us anything in this case.

-- 
Jens Axboe


