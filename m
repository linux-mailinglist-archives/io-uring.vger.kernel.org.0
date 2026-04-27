Return-Path: <io-uring+bounces-13148-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +IBWEnib72kbDQEAu9opvQ
	(envelope-from <io-uring+bounces-13148-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 19:23:04 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D06014775C4
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 19:23:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0E1EE30371D9
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2026 17:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA723E95A7;
	Mon, 27 Apr 2026 17:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="k53tF2ek"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F6E3E9583
	for <io-uring@vger.kernel.org>; Mon, 27 Apr 2026 17:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310344; cv=none; b=DbYb74QYIeoDMTAih+o61lTkP0C08ESHyHmlXT76w0od3Dm8VYaTwJEMxCIeujecb4gi+xz2ZAWVPvbn9lTze6eGqeh4RI6D08CqcbviV4Pqunx6xr1i4i3Cv3OLb/NBgjuNZw1sNNOzSXtlOsDeAt1eGGuXp1PamFullHzxQ9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310344; c=relaxed/simple;
	bh=7mRmTxhM8o7fkPuIJQIEDZpRPVbM7kzS6bf4WRUAe60=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qbTFP2Utkm7ZcUH+AlqwT9WJOXlX4PkvWUsoFG21+uzq6dW5bAvCUsfdQFDWIdrLyxIdCGXBNnOYMmidSkjSAvYLTL5Do0T+RTq1DXRFOtbu43zMXiU7ikoZLVUvdqRMntdKv8uv7ijIDeMlzX6EiIzN9bRzjx6a+jnoF+m8qZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=k53tF2ek; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-43034c0fd27so645028fac.1
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2026 10:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777310339; x=1777915139; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PRkfESzpeh+im0S7tgGzCdtmk7Rwulth9e9Q6iCRAWA=;
        b=k53tF2ekHzVr1AxRvcPHCLn7d1dbbdaTSARGcbj+rkdkBBRMJrgWt6dmVEEM5FRFyw
         DZU7qkif0WeAf/eZXnl41BumIfBqowQAXDC28wCFZbibV78frFdIO5D1HAEcJyRlR2pV
         UPF35Vhd9RDHw1P2mHtji2BhbAVmHs/9Rhdz65/o2o0o24gRnGwKw2d/qvwIssGdEPXI
         qk3jkoE7hneD13z6ZxuOMW+ha4d3iFoz8uKD+dzA11IPX9eQJSyoq3Rt2SBGgt2z/0K1
         jwBN22EjF45zlkI/WaBVv8c/pnJU3s52SNqft5wNI/RhliP7eiW90agdKoSkQyVYGND0
         JLwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777310339; x=1777915139;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PRkfESzpeh+im0S7tgGzCdtmk7Rwulth9e9Q6iCRAWA=;
        b=Rhs8thI8l9VF5i5EIjDZxXlIRpKwZiXaiXbBmAuwaVGMMz+twZmvLn5xHQGC6ST1+V
         FlAtASot9bSV3hIiSzsKWEAn5ruMCQgm2qNeI2kBq3iIVdZ0lMRcWn/IFI3OnseXwtob
         1BcC4Wkt6+VUngFlLodV/0BsSSKEv3QQfqX8UeZYa1U1RmFW1WAhxJxEAOkHpL0HRgvC
         Qj01+//4pYUp9m0jRMgjQ8g2WOWsMmHYPuR9HS5aA06rQAt1nTZjpKSCbOn5DqM6JDOA
         fpjqXZzSd1YKi6/1IUBTFeUAUxsmvzs95aUhIvB9oddf1c3iXYwGupuvttAm/arnVOE8
         ng2w==
X-Forwarded-Encrypted: i=1; AFNElJ9xShY2pVEd3II5tF3K6haKkwo3YKa50ZLcBYkVMbMUJ9fw9MfzIa9IBJXqcuzRb/ibmc/7K+ng9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBL/WBC0geBn2trplwRJU1cYmwmmQp8DU55SucUpZiSqdtcJNS
	qsxhDmoQYo7zFFzjkIQ/WLfyCtEqmehxKxLulzN5BxBThk+65Eur3EoGZap0qS9cc2s=
X-Gm-Gg: AeBDiesBBzm15GtCpJmIrZj46UiXbEE0tQghD0sPtPrR3QCMmh4gH3MAa243HnYLbv6
	S2wW2tEQUY3KM9R4k5jzxAG3FlbvEQEojhV4zkK+LBFeVF0YwI6RHDUJ/PuM49Ijl7Dz1GXFgvd
	WhzPzEXqllHL2Z393BZSNgTEJUV9A/IHCLTyP3kCZbt2/FX8CuxSYvNAWngWaO/0ZPGHDf5Wv6/
	KY+J8kSq6sXDMzBWU7Yh9UaQtTiya8msHJU7js4DROqLuUfeE32zVB9bW5vjc7VAKA70M1mQ7se
	4LrUnYs0Gt3crbcNdqNGjFrKvMc/BIVJHPCBpxnDGy6x8DDELDXJ+mz1gYu3MWPYAMiYV5w2gqE
	B07m6oZmM4w9sjoOO+q36+UmyZeRyjvR/uWknFr8Zs2tg+vcOuJXhtRjiibaJhPOMwMoRhnBaZC
	k6Q7zSyAxksuFZeVQVQRC8fDGU13aXZgKNspv9NP6z9PjCJt73qSizSQYPBpAu1o5uPXOfyEhUI
	+6vDtWD8+4Dz+eiGMJ7fe/6LXcXMA==
X-Received: by 2002:a05:6820:210f:b0:694:84e9:4a35 with SMTP id 006d021491bc7-69484e94b74mr19605136eaf.46.1777310339557;
        Mon, 27 Apr 2026 10:18:59 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b934a2dd1sm31143919fac.9.2026.04.27.10.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 10:18:59 -0700 (PDT)
Message-ID: <81c9150f-1f19-417f-bdb8-ada97f0b8ea2@kernel.dk>
Date: Mon, 27 Apr 2026 11:18:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/wait: make check for pending io consider cached
 task references
To: Fiona Ebner <f.ebner@proxmox.com>, io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, t.lamprecht@proxmox.com
References: <20260427165910.683941-1-f.ebner@proxmox.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260427165910.683941-1-f.ebner@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D06014775C4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13148-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,proxmox.com:email,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]

On 4/27/26 10:58 AM, Fiona Ebner wrote:
> The io_uring task's inflight count also includes the reservations for
> task references from io_task_refs_refill(), not just in-flight
> requests. Thus, pending requests are present if the inflight count is
> larger than the number of cached references.
> 
> Co-developed-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
> Signed-off-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
> Signed-off-by: Fiona Ebner <f.ebner@proxmox.com>

Looks go to me! Just needs:

Cc: stable@vger.kernel.org
Fixes: 7b72d661f1f2 ("io_uring: gate iowait schedule on having pending requests")

tags added, I will do that. Thanks for debugging this and sending a fix.

-- 
Jens Axboe

