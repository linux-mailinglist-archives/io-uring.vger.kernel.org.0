Return-Path: <io-uring+bounces-13158-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ELY3IH218GlwXgEAu9opvQ
	(envelope-from <io-uring+bounces-13158-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 15:26:21 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B2598485CEA
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 15:26:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 74E5D3015C97
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 13:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B0C43D4E0;
	Tue, 28 Apr 2026 13:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="PRCN4Asy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35DB43CEF9
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 13:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382004; cv=none; b=LUJ8oJwXzbkBIK+bunVev+wInqU9Y2aprfRhsSFf+zc9GCb+lclu3+3AmPHBhvAryUYLDzbdrooc7OvHSSlASQhJTRAcptq0bU4KCH/1dZ/7aotZ6eMBjomBWpqBH813DC/BJs76enytqMIugF+E+YwPu23MVq6nkOgTevP9SK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382004; c=relaxed/simple;
	bh=i8j1qMVhIXUx5kMKDn52NX7A8T+N9YdbIRflE/XS4ak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EWhlzo6gDtNDrQ+O+WIRk5aChburN/iCnOi3hm9Fv8rTllBVsWQdRvJW6B3HqChUYoXMPA4N0czWa7pzAIlPyd+FP119Oj17OzZMaL906M4lQz64/xXdk5ctsByUI6t+/faIS7ofpTn2gachEtxpWgqAXhRC3uCYDZxSqFhQvKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=PRCN4Asy; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-40ee9b945d5so9353669fac.0
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 06:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777382000; x=1777986800; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DXCJaGrSLaKv4YGTnclIICROVVbO2+Gp+8vAxfV2kjA=;
        b=PRCN4AsyrPVd4gJ0igOMdRozu54POT/lVX0UTurBDibGq1cMxVxn0z7qF37kF03t0R
         WNnKxL7VWxcK6uTzT0iYX7Qec1MoEEkD+/j3/UgRMddkZ2Dbo3rtI+gw2lXR7B4zpEt2
         I+/MhNKS+X4GW4WGhw7MEiYdUtQb8lYDfadpr+JLYIntZ7j8DTXtAZqhRpiFykwvOkZq
         mFiNjcN91DUXWQ1KV9CEN//A9MJ854r2bY69Qi/mQndIBaEPXX+co8nJQETAObsBpFCp
         HTbAXmQbrhhixwpQbxMmMcgsoOSksBVdDOqYtREaYDctZAaiajUFC+2F81ktAdr4VQC1
         Yq8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777382000; x=1777986800;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DXCJaGrSLaKv4YGTnclIICROVVbO2+Gp+8vAxfV2kjA=;
        b=AF3e+xrjuGEHOGD2nkvFcpkXTbiyoP0bd1vyW74YfriGf8mVsnxZEryNetjWEd3iD6
         5Dup7e616eVA5UHPRJYizcOjCTU29X9wScVXyqDc2UZnkR0Q223lRLVxsTHoY9Fcf6Ul
         2mtuN/XLknibj3OWeRivIx6yCjwVsRub1aFmwt/ClPcx2GCqtzhU28MxPswdt3Ys9wjg
         EOvtUElzc1RUnjfq1j4Q3h7nJhja1yfKCSMFUVpOABqm9FOXp1UDRVwAf93shc7hoGkM
         dr5XJ63JjrV4vWeN1R36nXLfLdpVp70EM7x0cEK0AMkx/47PfcfGaoSLNBoS9ydKY2lc
         DjFw==
X-Forwarded-Encrypted: i=1; AFNElJ8dxx8Y39ipKScifg6RYGelm9OTMXlBKCTVf79K/7u3ha0Darc9k3CWxrS+dbFciBzSFoZMGGHiYg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6dU/ML0XJGX7z0TM9C2m9d2+8sPM5ypAv7BzhZ8zYLJOktFl0
	g0pZ2WGMjQQvnhCRjImu/HbDj3HzvRnQ5h0QPR+lhMhMXgyG8tGDwJaaSwd2Kq3+PKk=
X-Gm-Gg: AeBDietC0yzb7fZEd0qHYukAwhigEYBufC5MtujzlUMYkryr9I/uZIrUcj9aXSnx7Rq
	7ifGi2DlLEWYfEq27mjntm3IqOIDnTXH0Rxb/1pHpBpW54q/YaLqs/3RZVpmG7bV8XhL+U6ilDJ
	F1rACaJomvpbcDk8amnskpmqc+K+WeY1f7g5sxJeybpAWHM2epShsQNumQx5OG3j8nVte+h09XB
	gp3gBrTqq9glbmCccL6/VxCAvA7rkJ02aHeuVCj/FWXvXO4SzRJVDxE41PGJxIrAw4T9MDQ9Bf/
	/zzaDsOiSh8fhPG+gVAKZUaYdSzuzsFJ4KY9tR85BunxkFTUgLybeQ+fjpk6FOG6GqhcAVXKtyI
	owWcxfB9eWYkEOpbAg4yDJqwj+X8f9UPqfKFf++Fd88lXLdCA7CxkL/Kd9iQKXBzteKRXQtS4iv
	abGZELk5kFVRbO5LwpV9lpqBOlXq758Ip1v8/5wJaiItSr9GWBgPpgKQ23kIRzTHCSTGqs6cYAr
	/h/ratAhvNPV+lP9LVwR21qw7Du6w==
X-Received: by 2002:a05:6871:3325:b0:42c:6ea:3227 with SMTP id 586e51a60fabf-433f3a15ce3mr1521884fac.19.1777381999703;
        Tue, 28 Apr 2026 06:13:19 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-433ef7d122esm1903865fac.0.2026.04.28.06.13.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 06:13:19 -0700 (PDT)
Message-ID: <af21e72d-d4db-4fc1-84d1-e374884ff919@kernel.dk>
Date: Tue, 28 Apr 2026 07:13:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net: add net_iov_init() and use it to initialize
 ->page_type
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, asml.silence@gmail.com,
 almasrymina@google.com, sdf@fomichev.me, hawk@kernel.org,
 akpm@linux-foundation.org, rppt@kernel.org, vbabka@kernel.org,
 io-uring@vger.kernel.org
References: <20260428025320.853452-1-kuba@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260428025320.853452-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B2598485CEA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13158-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,gmail.com,fomichev.me,linux-foundation.org];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email,kernel-dk.20251104.gappssmtp.com:dkim]

On 4/27/26 8:53 PM, Jakub Kicinski wrote:
> Commit db359fccf212 ("mm: introduce a new page type for page pool in
> page type") added a page_type field to struct net_iov at the same
> offset as struct page::page_type, so that page_pool_set_pp_info() can
> call __SetPageNetpp() uniformly on both pages and net_iovs.

Thanks for catching that, that's an oversight in the offending commit.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

