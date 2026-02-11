Return-Path: <io-uring+bounces-12160-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mG92GNiejGmPrgAAu9opvQ
	(envelope-from <io-uring+bounces-12160-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:23:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CE10C12595F
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:23:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B425F3010491
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2274C2D0C68;
	Wed, 11 Feb 2026 15:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Xpk1bmCJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49971534EC
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 15:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770823380; cv=none; b=pILvDtJrV/0jgH4FWk6p/2oqfS5zBwMOnHV4GWD3lSkPsQzVkWbHOhJMd/l/pUYxQ22gSykLHdDMKn8tv7yy4hWVPePThQOChVzPnfdakxnSrcnHZENRc4u+RGBiheNqE3uzOeTH389hFjFTag4h3aMN8I50x0w66LcJ1poNqcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770823380; c=relaxed/simple;
	bh=oe7zlQrj9Fj4FRzQlB6N0RD3Qljj/+uCn1sYn22xCYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TemHq6/h57t5rsDGjtnkYNdvaKy+xqwqe1eatsaBPlotjmaCnQlb/c1LRUcr+qjM6kfbUdjzDacm3W17iog5r+vAAJmENBWn10lYCahpzLALhhYxukAE0sQOdjfF7SehPAemzuDPI6RhZO7GLZ7a6scOm/w0fbQuMZbKGyyAQtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Xpk1bmCJ; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d44b2df00aso2726148a34.3
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 07:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770823377; x=1771428177; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vIdKaU8HmSz8XrXB9v2WoeP7wxPfpURDZ/uABicXGNM=;
        b=Xpk1bmCJ0E71ghJDxcwnkcDYrFnv5mTWknOF+Q/BrsEnoq6WRCIydE3DrLcRnS8A4h
         1dBjH+nVIihIewIKOoHa6Nym+KZSZy3g9SPVxqQl8swZ2kxfM0hLTXVeHN99OqBQbHbc
         njF5jMI5kgpsNf/Lo6oKcjI24SrqiksyJPwNdb4hz+BfUlAvyPEqEtNl6LG5S2qA9e09
         RahyBlxk9k6wo4XQnG7aJKwrra5P+jM/YJ4BcLzY8z3af6eByu966UgutV6Aoh9ime5M
         5WIgZuBDRxopsBbW60zFbl42bAKPi5p2/Ftj3Fb7M/RusYsI3OxZdeGvdHp71gRS+82a
         6Hug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770823377; x=1771428177;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vIdKaU8HmSz8XrXB9v2WoeP7wxPfpURDZ/uABicXGNM=;
        b=QM7x9C1qYGOSvZLSveyoG+g4cZhm+JVLS9ZBhvrXUYMybmPZdjxNKYFayIXrXbdf5o
         rg6tNdXsFTLY/+AZpoD9jBtlQkZhFtA9VJwF1gNeWzpx8Dmd2xxomz11aG3XxFJCH1or
         Xw6eaFXruWzOng3q3sMrMnJ1aYK/Yh98dNKc/SYtx6XVtWdi9czim67XZGEztq153ciA
         bcYNh6HpdyOg3pAQAaJFWrAB105wlfqOZEXxmjtoo3FFDf9+H9BrPQqzvBHdxj1ORwHP
         9kvdTIotkzQrRwlvDWFtujZy3NiPizOovOoYe4Fe2j/7aXKDNjLKVRd9BU9eng7RC4KQ
         xYcg==
X-Forwarded-Encrypted: i=1; AJvYcCUOObwavwiVGrULumeXG9u7SSLz4m30/jSsvbOQZgHWjQxGO8eTo3jUEXhUl85YZryrI6fYIa5OGA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGCDISuU79eioZ+NQkB4O3nwE9+V7/u/SgSjAVbzNw79avSqkj
	valZ322JAdBS50icrOQHUJqL0bsV8JY1h581sf743QFe+oSw7rDoMUvIVtKiB2cuSHI=
X-Gm-Gg: AZuq6aIVQejz7k2C6dY3Qoj3SCtfDDE57xaq/6kOP/aZ6SqMBGSZHYjN1+dmChVkxUV
	TjArnXz3cB6FLF/ei6ZFGdKHjrUd/rwdOJnitYT2SYc9cDOlY9gWiWaEJLYLKkDPHfhQK1GkLKA
	tliM9uLZCOim40bCXt5vGpe8EM82rKfn49eXGkIYyupRDfOU22uC/XAZdlWMLGWRPTN+6Jwq4AU
	DE6rS06jx4/uFvPASVQ/qfENYm3Ctx3TdmUQWobPavWX0NTO1e9cgDAlovhmLqdOkA2E7tjQHZX
	essJSFMN+fXwpjGFZNQ7fe/8l3ZGwtey1eOZq/SSZ5CZKJ06QW4fNHVCGaqmm2ap8dk0P5mFelA
	uwtzxjdUzok1G+1LB82JQIyxjO3fx0pKAnOyiUaIwdkTSjSpU52W1W8Qzwz8fpraMRe7eqRofnP
	+Tb4DdYL14Li598+I3LAcz86NccGGrKvgBXEKI2zWGOlvshXmPLjNTGIX0thLFCPNUkCgX1TjFW
	qCfrEWYpQF8gRq5I8G6
X-Received: by 2002:a05:6830:82ed:b0:7cf:da7d:6757 with SMTP id 46e09a7af769-7d4a570aaf1mr2133615a34.11.1770823377350;
        Wed, 11 Feb 2026 07:22:57 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4a75309bcsm1448893a34.1.2026.02.11.07.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Feb 2026 07:22:55 -0800 (PST)
Message-ID: <cc018c92-1215-4424-8995-4fd5f318c420@kernel.dk>
Date: Wed, 11 Feb 2026 08:22:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] selftests/io_uring: add a bpf io_uring selftest
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1770818588.git.asml.silence@gmail.com>
 <52d39c60d06ee9d02ddb04521382045a6b1d543d.1770818588.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <52d39c60d06ee9d02ddb04521382045a6b1d543d.1770818588.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12160-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: CE10C12595F
X-Rspamd-Action: no action

On 2/11/26 7:32 AM, Pavel Begunkov wrote:
> +	if (inflight < max_inflight) {
> +		unsigned to_submit = max_inflight - inflight;
> +
> +		to_submit = t_min(to_submit, reqs_to_run);
> +
> +		for (int i = 0; i < to_submit; i++) {
> +			struct io_uring_sqe *sqe = sqes + i;
> +
> +			sqe = &sqes[sq_hdr->tail & (SQ_ENTRIES - 1)];

Nit: assign sqe and immediately reassign.

-- 
Jens Axboe

