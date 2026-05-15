Return-Path: <io-uring+bounces-13365-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLD7D81CB2oCvAIAu9opvQ
	(envelope-from <io-uring+bounces-13365-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:59:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA0E5528AB
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 17:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 49A73305D7DC
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 15:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79BF13FF1D5;
	Fri, 15 May 2026 15:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="KDhloYDv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0C3175A87
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 15:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860050; cv=none; b=dkr2W6QCJZT5lFTfgxA8V7+S+8waOovVsHKJkkAyY4Qa6/yt1vvYPOdGVuiZ6BlMwXZ/VXmgy9PbjmojU2v1XDi89k68MEwfrCxP6kbV+P7GKp4E90p/07VlZRHXWyyoqK6oUgbsUntN3aqO/ogXjBGacZE71KF5lIweIAYx+GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860050; c=relaxed/simple;
	bh=CVdUnOiNPpPmGc3LezT8e+nwF1TZwRu4S/w0u6LkBm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hBvfWderIVn7mU2Qw7/TIm+euKP89NQryNlU2PCyQaai8NMx67YaPlEf+2PdAEJloan114qxp/2F+J2S3a3+PnqDg8l7TvV1xplHEuRl2iTJHdIuGgTMwH5IifE7Zbqbxojb7geVJxrFR6wI/lS4L60VF6FlWLaJfSWo+/BBnJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=KDhloYDv; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-4824b15c19eso5924656b6e.2
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 08:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778860048; x=1779464848; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F1yk8fFWUiOttWO09N8CWC0NIU+i5kI1E9W6FnulKH0=;
        b=KDhloYDvIKp9ePnUjpQKVS3La596lCDCRYljsmZXs//VgO6sz44+4vftOGLBQv/G8e
         QOPr6cTe5o1nTll1S3S04288kjlZEVzndevnsbeRxnHHZupCWVxgzjJkyfjzWNLlc3SX
         44BbIDGYj4Jhl/DsD6m1w4P5gG12BfXVdBxBnzG5UsRL7PisHiLO2oXcL1PS/Q8Wo9eS
         5deSltZUsswrStxKZ3gID3/8fpxGnEKRqwSJLIxOuwjJjSDlGh+dhZ3nH47PeMZKKaNU
         Cs2LpQuKhh10t+6Sp6wnspppplYpIVxl/2JbQzpbgfzCplZf3tNThjvfmle6/dS9YKKL
         ipuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778860048; x=1779464848;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F1yk8fFWUiOttWO09N8CWC0NIU+i5kI1E9W6FnulKH0=;
        b=l5EvD+5/qLON4DilJljCGtpDWAtEDwLu1g1yxiaXSvAloYHg0i+kNaNTKeAtstYmVQ
         Z4pZrFb054SQEdIIuyZmCBHRKSyS4KSO83EjQOZr6cKauOPxVRHBSpURpO00n46v/N4w
         d5KX1t4VhAYJ9hvA9nJTbih9+9dkqpsy6Y3Va3y4VzV6IKxsSnU4R/QOYgk/zM4+TKT3
         oQkP0jedxn6F+MFUt0t2uvSUFR+5uIkPlN1jkldaIKsw9MCUZfsBFk+ge7J5QA4Uejhu
         rf2xneW3FAMzXNEECGLBoX56VVP4VMpbFNAD+qGl39QVqKehu4A8KUk81nsMQ4udLtxG
         TKcg==
X-Gm-Message-State: AOJu0YyI+tK5gsslZ9+IKZE/PLx2s7qg4TfZyhJ//dFK7WZkO/dDl5zp
	ZT72EMAQedcBEZO4DKvElp1rcCxrCNuSH0wn+wOZ+ZLQS0MyGFMb9PnBUWRKO6jNWWQ=
X-Gm-Gg: Acq92OHfs0S+Q8yXOY1y9HZ54QUi6XEr4xw5CN07AAsMQjs29PTVWe5cYeQpfc/xKe3
	G0ud/+zvLl3k9zSADCZyVFp30sJIShitt7oOlnXUlZwt0ma5juuIqoDpzRUb41+Q78GmyE28UMY
	93VtvQFEiZkKMlI8Uatw2P8NJJZBcGFaB+JCJxQZWShiD02HZUYrcMYpJfbSAyoOXaEBKzfNQ7G
	fAOEpDPnC4o0hamIeY0tA+RKmrz8ieDqUkIUEFGdc/qYU3TZnS9l5kE3j/6iaRRfeJ9vH2s6Dhw
	hs06aK01iTCxmYVKi9aHsu1ZwhE1gOcgZhDT6LAgmO6PJChCEQflSKtp79vyCXnKVylepfcPK7I
	6L395fX3NqIieACcVC5kdsN10Q94PGW4WG3nE0Xs3h0+w8cAyzNpxiOjE8iuAZPp6N7Kb9m7qea
	iyjB9SWo3Ed79qR4r1YGlt8lAioQktCvYNHLe1dWrFNIBXHT44FXxevNvMwz3hq6vk0JucXVIqy
	j6Ghb2pxOU1Q5s05hU=
X-Received: by 2002:a05:6808:6ec5:b0:47c:3733:2558 with SMTP id 5614622812f47-482e5717b2dmr2717102b6e.8.1778860047709;
        Fri, 15 May 2026 08:47:27 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55bc4749esm1673726a34.23.2026.05.15.08.47.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 08:47:27 -0700 (PDT)
Message-ID: <cac7db8a-a547-42d0-8589-c8a282cb6860@kernel.dk>
Date: Fri, 15 May 2026 09:47:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: propagate array_index_nospec opcode into
 req->opcode
To: Keith Busch <kbusch@kernel.org>,
 Michael Bommarito <michael.bommarito@gmail.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Li Zetao <lizetao1@huawei.com>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260515145812.1241925-1-michael.bommarito@gmail.com>
 <agc_m0rN3MN7ttAY@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <agc_m0rN3MN7ttAY@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DDA0E5528AB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13365-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,huawei.com];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On 5/15/26 9:45 AM, Keith Busch wrote:
> On Fri, May 15, 2026 at 10:58:11AM -0400, Michael Bommarito wrote:
>> The compiled change is one instruction (a single mov of the clamped
>> byte to req->opcode); the cmp/sbb/and clamp triplet is unchanged.
>> No functional change: array_index_nospec() is a no-op for opcodes in
>> [0, IORING_OP_LAST), and out-of-range opcodes are still rejected at
>> the bounds check above this assignment.  
> 
> Since the bounds check above already catches an invalid opcode, why does
> it need to be re-initialized to the clamped value? Surely it's already
> the same value if we've taken this path, no?

It's to avoid speculation values being used. If the ->opcode store is
the last one, then it doesn't exist.

It's pretty narrow and mostly theoretical, but does make sense.

-- 
Jens Axboe


