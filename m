Return-Path: <io-uring+bounces-12529-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EB1lJ04EpmmzIwAAu9opvQ
	(envelope-from <io-uring+bounces-12529-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 22:42:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 180EB1E3C71
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 22:42:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CE1E7333E893
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 21:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D8ED3CF0B8;
	Mon,  2 Mar 2026 20:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r6SPk81H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88E11A239A
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 20:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772484356; cv=none; b=DsySfQ0y6toetPadMv4XQUDJT3IgtSl2V0fRLlyCaBDJLNMCotMZ4eBqXfLC55nR/cxRI0oNLPDgCxPeCiRIipxxP880qbENC02oknHcS8H0mZegyjngb92XQoLUh6aLcK0xfT25j2t9MLckdg6/J54CoDWM1KYacTLYykntSj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772484356; c=relaxed/simple;
	bh=dh2KeC0FHh2tfpycGhTqg/+ghsqdACtQk+amNEmzqaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zu7SEyFD/60uLlfew5zPbczaiwRlVCDmgVhdUaprGw781C6cXNmSxHyfx+fay6jsHCo/qbKNty0lQ0YjRIXiPhmvCEVao3Wwqv7UY4VcTrZUKC0L+sA0ihfS9U75dHE4qbspFzDdbmmf6yTW+fz8u/6wg0cPP/C53rDO2vpVTfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r6SPk81H; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-45f10d7eb81so2020323b6e.3
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 12:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772484354; x=1773089154; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v68RHoeeN2biRUEE8nKGOAckVRccNLWB9PTIqaEQqtk=;
        b=r6SPk81HLM4VSQTwkzce+x37H727l/RVg8o03pQ5Wvh7Ux/8TvAjAZ175b6IzlcM4H
         GvN1nJscZEXJONa2VX2hrPNbViTGIDM9I/07HQuh5KbvEX1Ro4mQsO9D9pyEBWJnCjYZ
         l004cCGmI5wHizK9haJWMvdwuEFzgiy0KwMTXkppNkY5vgXKsXRmcmrVVe3+edLOUBXV
         DVGXf42sUyVD0b19pFDDtRJZmLBlNfoOPTPC4HDkyOOXjRL664JftndtUOBJVOU20ZS8
         QWlEz7G64HMWtWxP+cf6QSQcTJJA4LDS6sOcMVkfeCBb2/fIgr1jNa8sXcxr+ahnlbej
         AMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772484354; x=1773089154;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v68RHoeeN2biRUEE8nKGOAckVRccNLWB9PTIqaEQqtk=;
        b=a9XlqgRbaO+C3W6wU6Rq6qm4Z0ecM4So4w29ApeiEZFkwfvYswTY7FUHbBPRAZpu3i
         lmF2sHg4pnbFxoLiNCoLfvWXJtM3ZkWZ6FzuLXvcyDSJ7Tb3fEqj++xP2pDX0UhC3jdc
         asWSjxeCrwGsKyEjNsTGE9Iv0GxW5fAFU96rNTOIytOdjqJAMv1irOuiNcl++pXUnzz7
         nR5kd/XmmhAq9OcXjvdutVNtqadapfWUiUGr0LP+usAJbAdae3Tj94sawQNwZY92rlBR
         5ak47Zz1XC5V5oF3it7V/xruwhyMx47/SWIc+BVPvQKnP9ruDlyoPaoYWE0SedrfMLC0
         WkmA==
X-Forwarded-Encrypted: i=1; AJvYcCXKuV9lqNR3F6tD5Ja39PxDYiu3ufC049SF5dRI7n+Dkf5/Oh1Q8xoDo2kDOQUvRGvCKe53zX2GTA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/OD7y8UJabRnLueIzE96tyLmSQGANEcN+tn00jy2i2+nbWwHX
	HGW7VOwkIblxSW3dAdNHneDNVvvu1hiyokx8kcmE+9WhKd8agVm39n9CbTo9pTuCp2ShfsMnTtq
	nFgQfDqU=
X-Gm-Gg: ATEYQzziaVtCq3tjtIO1kdkq7nUmrxLYlDjHainO6f+MHx1lRaf3IshKBqNSJorn8k0
	tHHenYqepBlglEhJNcY5P3Yj4KHQYG6Y0cLpHZsKjxryXwFQsPHdarW01CaGxtBv1Qch1oKTcqS
	+OBL9zjVMNI76EL4l/+88bPzYMYIhyFLzCXbDTidoa0s9IlF4cesEmP7TQFUhxa1W/yK+oxZNHc
	2Zzu1OYvFxKpm1LOiv9XAZ6eTBp14S4mqwK0UwDYbvzGl6jGpwSuBD0Xf2RSCr2V/4nwNIjwDJn
	iUMyyToq7eQr8G3dmxXO20gV8x2dRei1PKpRcjujdz1TKekpjsEnxCDHTarYixmNOPjVzR8NgC/
	pbcyxK638zQ/gNeeP0O6RJus3Fp80FJbg0fPipYZu97HzVIrB5dkgXlK36NTdkEAA8LsoypS8vT
	pzdvjuEkIJwSqd77lPCVGE0gcwkLhUvDk7DSIHOvFonMl/ewrdmnKrXGnN6bMoBkwQlsqR7bwu4
	dqyZKm5Qg==
X-Received: by 2002:a05:6808:1719:b0:463:4f2e:c518 with SMTP id 5614622812f47-464beca7006mr6410351b6e.61.1772484353719;
        Mon, 02 Mar 2026 12:45:53 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59b66fsm8262084b6e.10.2026.03.02.12.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 12:45:52 -0800 (PST)
Message-ID: <531cfe07-2a07-4bd2-be07-9cd78890e04f@kernel.dk>
Date: Mon, 2 Mar 2026 13:45:51 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FAILED: Patch "io_uring/filetable: clamp alloc_hint to the
 configured alloc range" failed to apply to 6.1-stable tree
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, io-uring@vger.kernel.org
References: <20260301014717.1711200-1-sashal@kernel.org>
 <eb41b6f9-08f4-4972-99d4-3340571830bc@kernel.dk>
 <8e84b6c3-e62d-4aef-90b7-a7a0e63d8a17@kernel.dk> <aaX2F5LGPcqaDXum@laps>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aaX2F5LGPcqaDXum@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 180EB1E3C71
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12529-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/2/26 1:41 PM, Sasha Levin wrote:
> On Mon, Mar 02, 2026 at 01:38:37PM -0700, Jens Axboe wrote:
>> On 3/1/26 6:15 AM, Jens Axboe wrote:
>>> On 2/28/26 6:47 PM, Sasha Levin wrote:
>>>> The patch below does not apply to the 6.1-stable tree.
>>>> If someone wants it applied there, or to any other stable or longterm
>>>> tree, then please email the backport, including the original git commit
>>>> id to <stable@vger.kernel.org>.
>>>
>>> And this one also picks cleanly into 6.1-stable. Not sure what is
>>> going on at your end?
>>
>> Are these and the other "FAILED" false positives getting applied or
>> not? I didn't hear anything back on any of them.
> 
> Appologies for all of this. There's an explanation of what happened here:
> https://lore.kernel.org/all/aaWWE5uQqz_eG69i@laps/
> 
> These should be part of the -rc2 I did earlier today.

Gotcha, yeah it's not easy to know when you don't hear back, either
as a reply or as a new "added to stable" email. For those of us that
do take stable seriously, I 100% need to know if something is landing
or not.

-- 
Jens Axboe


