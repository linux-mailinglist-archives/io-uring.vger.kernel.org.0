Return-Path: <io-uring+bounces-13200-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id adgoMIMv9WlaJQIAu9opvQ
	(envelope-from <io-uring+bounces-13200-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 00:56:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB914B01D6
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 00:56:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0AEF8300F1B7
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2026 22:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C72837C924;
	Fri,  1 May 2026 22:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="NBBKfG0O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870F837C0F3
	for <io-uring@vger.kernel.org>; Fri,  1 May 2026 22:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777676158; cv=none; b=TqaITRMC8k8kxDGN0+RK0UH9YcnR3KQP11cdf1gcEP3sDO+zud550ngKsbKuys4tUNkvTCvgDB9gpV0ZFDYCS0A4PIM929AUvb1BmKGH7NY5vg75JBtu/phQhOubw79eYnDQKyzRUPl+KYlCNGjN8s+tDbRSJpF3nP3nF3uaKZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777676158; c=relaxed/simple;
	bh=Y5VZ8P13n27vfxj4mzevVdNouWSoeA4ah4EGtop6iVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N27ROLJTQFfnRilo2n2t7NJze9QmoLsb1GqDUpLYSb50X/W7XwVJ2RVXbP01cdALtlwl8TZY6xB/gmtUGBTEdVUTIi4V2TDlNIBWvGVhpLNVf1UkvwpLyaW2YgKzdM7xJfzrznFnGuabKEs1tqrjZuXkQO26F5r8Kl+KLeGFrz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=NBBKfG0O; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-479ef2b78f3so1759452b6e.2
        for <io-uring@vger.kernel.org>; Fri, 01 May 2026 15:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777676155; x=1778280955; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oXPqeAPzzXvPq2f4I9I5gjHJ+abRxZrFUtm0T7puCUE=;
        b=NBBKfG0ONJ6fAVx5csFbMiybL89UZ1XxyplZpDCFnLKtczIG2f4c0NiwtzE0lKInmo
         cvz09flN8cFKe/CthBN/LHII6JxopHgzZ3tPdUhffF90+VGX8/RiZa6ewb3JGE87fVz/
         Beuaz+tLHxRFNNTHikrPngiVMYfQzmcYLVWG9MGE2zuA7BncmWw35tiF28f22MHQjqTJ
         HZHBP9VxwUtnM4fNvS8LbOeDK40KUhOtbgjaNTCS/fmEaxHaqYD0x46qMPJONVgaOJc9
         T4mdQfvAMzoF5xX4v4JUet8O4Ucb5pEzs8JS7wvgIwRUIzFgHI40ZeDmXRkKAVM7cWpX
         1QwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777676155; x=1778280955;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oXPqeAPzzXvPq2f4I9I5gjHJ+abRxZrFUtm0T7puCUE=;
        b=P3RFR8Fki5ZWUqvYyyanAv0ENNnlUwcIAB6tlMU/kpLnJ9A7eTzaKvLFrwcgYYNJVm
         Azm3aaTZ3e3+vMeEaD2oOxZHbQ71xKhxdHRGWLXmUYr72sFZ78bpEmKZb5yIqFXkK5Ja
         48WT/aztCgRx32WChjcc8r6gUbM1HF13BmgE61rvPpt5pVTK0xLY8uZ/Z3GAUPz9/gCE
         uo6xAJgrv1AOSwqxg5XvbUDyv2RoNOdcqFrJJud4rVL/iQ1xL1Dnitmls9UnqjwWDGi2
         8o/gcwouR2ZgnS08V+7HQOvzaxfv0avgH5Yv5k5dUnss5aSCknThqrYw2C8rdZQu1Gmq
         /p3A==
X-Forwarded-Encrypted: i=1; AFNElJ+3p7hNDFfbynVi0fRW28Xy65dQdWcXMX5TispTlXgMYY7F+yN+7kc7G/qz+vmJjdLUZ5QGcJu5ow==@vger.kernel.org
X-Gm-Message-State: AOJu0YymgAEsrat4n9LlXkEsBqv7nn/ylsnUaVdi2Zto5fHKueXX4CHj
	UGde4wyPhrmjoayObXO7p72WQpime5hehf8bTlYsFzTS+wbvY8ro18cIVRhszpRZosE=
X-Gm-Gg: AeBDietjc5iEuV4sLBDyRVhBQELPDG/I6XtAgzLCKmsr30ZmKh9AToz+BTWG1ixYN1y
	xS+uooaSWXiCB4uNJT/wP8JKt88njbFWe1YsDxf07lYeTrYnVkqhvfulb+iGiR515kdWCuhlhx3
	YfIwrwF2obmxIzBh4wW6m0UpR2+OZCKJe9RhJIdL/0P7wl+n3T4gxGn5tphzo5G7WIzQIZjwLwQ
	AGQSM+0hYIDoogy9yyfiXfaVDt6B/qYgIsDq84SPH1AuSHC0LO2ypntjsJLhY9DMLun1YsFL9QY
	SS3lPoWyHqFhnnJDINcgzHbqTguHfJdJ1MdmxjkcZk5ozWGNEclQf5qogD2SRt1fxx/7rKmQV5g
	gFAz3rspn6nviOpapbWBfd540cPfqKTvh1UdHfnfhr3bYqsqYWTpq9ssin5R9z+tU72zobiBpee
	t9u18KqiQyzKg3nY7tzX9xgMaFsmnIHNXSz4RCxVjV2HlMP5i4nS5AD0YUnvd2K1rSbhhOrTlBX
	boUubnzLnFujznIYRc0
X-Received: by 2002:a05:6808:2217:b0:479:fa21:adfe with SMTP id 5614622812f47-47c88fcc194mr879368b6e.6.1777676155577;
        Fri, 01 May 2026 15:55:55 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7deca7a5e75sm2900431a34.2.2026.05.01.15.55.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 15:55:55 -0700 (PDT)
Message-ID: <3fcf1bf1-23fb-4e01-ac3d-6ec6fb86da08@kernel.dk>
Date: Fri, 1 May 2026 16:55:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12.y] io_uring/poll: fix multishot recv missing EOF on
 wakeup race
To: Kai Aizen <kai.aizen.dev@gmail.com>, stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, io-uring@vger.kernel.org
References: <20260501225250.90152-1-kai.aizen.dev@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260501225250.90152-1-kai.aizen.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2DB914B01D6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13200-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]

First of all, I'm fine backporting these. But:

> CVE: CVE-2026-23473

How on earth is this a CVE?! That's bogus. Yes it violates application
expectations, it'll wait on a CQE it won't get, potentially. But this is
the only side effect. That is NOT a CVE. Greg, please retract that.

-- 
Jens Axboe

