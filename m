Return-Path: <io-uring+bounces-13642-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id A1rsH6bVJmqqlQIAu9opvQ
	(envelope-from <io-uring+bounces-13642-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 16:45:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A1B7A65777D
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 16:45:57 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=mOq+eR0L;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13642-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13642-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7EFBE3071C40
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 14:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900ED3CF02B;
	Mon,  8 Jun 2026 14:34:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113C23D0938
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 14:34:33 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929275; cv=none; b=oTroCZ4miMYdkey70EeEiIyHSgDyebkJfUyrhY5/+JSrwSIvbRHiqgXetko/mp8RN5R5xNzdstXAOQHfEKAhyOFsPIkDkSLb426M5en1eolWp0NUUKgAqQktXya/nHaxVZ8eq253RD3XJMBSoe6dywxQPcd8mmbKj2S/GI99SMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929275; c=relaxed/simple;
	bh=Aw8vhTQGa/fZBwrIj0Blqu7wHbMGd32v9CoHbEWrQWM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dfXJw6cCaZ0qlhlhueIqLflq0UEijEmguXm+UJmNa4/jdPUsrfg+0zkiwFe9RU0WbGxXUI4GAjjO6WD/AxDmP3853F9UtqG6Y69uu00AwJENRI6NsfqYTJ2qHGXPoXhKvNTs3ModoPGeZYBF5MF3Vb0Pqm+aNIi0r6Gkwd20JWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=mOq+eR0L; arc=none smtp.client-ip=209.85.161.46
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-69e4d51b15dso2892270eaf.2
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2026 07:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780929273; x=1781534073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DDKhmu7bOC16MK97/CtkrCxkDCLC9HisH8pn7ZCdscE=;
        b=mOq+eR0LMuaTNos7QKq9PGfDwSzEWEtzlLwIfJQraad1p/v7/r1EekccvOL9SJS6os
         yrHKE3lHpuYVjM+DYgcPR5XmrSxiHlD/YZ/CH4wuHimZfP2mPbLVVBIIaANKx8Uyp8ks
         XZB1jQZEtPFwrNneYlLhuZ9wWPysfQCBxFZ8H5wI2IdtiHvN40kel86/1PiUWirE8Azf
         IMZ8zHSHiq0hMuETj50vOGtPWjtY/BI/fT6owAQ+iaVM8z1fNKLYFnyDFWq1jRTIfAXk
         QLaYY5GGiHCcy0d3msBs+XKsrwVOQYxJWMq6MthZWRT5p3dUDWOWLliPBgQtKgcfQqrB
         Qhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780929273; x=1781534073;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DDKhmu7bOC16MK97/CtkrCxkDCLC9HisH8pn7ZCdscE=;
        b=nBM/ITtmz+i3r+DQQsvJY/mjANd99kQJulKmMedIGr8d5djezXTQbAxS05VJ05kblO
         OiNcJB7SJyd23UWFlS2MAsbtZGrDQPwvz8zKWk95g0Xj2wylVUvgyyLTGloeG3rpxQ57
         8/QtNTM2s/yI/EdwYGklwxQLSHTPZMDcmII2O6oSsl0Dl2OsnYrn6R2Wszcq2tMiJhv6
         G4D9/rTYEF/I/J8Jr7WbCrWX60Oef5QXgl1kjTJDxSe0Fh2sillLHGtcZQ8pVU8Jcyb6
         tIQ3PLZgoJxXCTfCax8RwGV4gFWJXTEOBtepp7S4G3Cax9PWR7q2YFyLU/CnusAsAVG7
         2CsQ==
X-Gm-Message-State: AOJu0YzIec6cNRGZZB2jV4bEIhA6EdEgLoGNFRjilYLo8M7sdefPy2rO
	5kD7b4QSpKEabJ90a2l0KpKBqwCTP82npPnslz921gKO+jyIZ7LK/V5tNlc//M+dcHk=
X-Gm-Gg: Acq92OHOH63wwUN6M5YCbbvWlic+4KRCf6ljpLJf5NME9/IgJgySt5l238lJ4dyg/8g
	wJw3sUL54yYaJIJSmEqHFaBUL6We6edCEYAkvZgEfRuBbkiXdZGueFun9yomB6AGoYT+otvpVDA
	xxGFFfRtK/lEUuJIKLpvmj4JdZKWxPTR11eUCaLoDhLO2qee6HGryHYmI4oLTUouU+nqGPWodqf
	nwBsx1r4YKwGzHdMq17FDzRQH2PG5vNYGncr35a1vm7V9yqiC++Ug/FfM01Vo3R6jnbFV6SJz+0
	6oS5/d8Yu/37qrQPJkS543jQwlCjOH1/aDBKlF+sRsXF+8HzI7r+bkvkfJGbZX9PWnlvId2Z5Da
	9cFk8duDQxLPFctbDzd0Xfz3uUv58qXAaIATII9JPjg6xUhS2E/sTFlK8rtNt6KehWi+nbKXpEu
	1Dgy+SVWj3Sqo9UZUuk8TumZralfT9oPrM8NCeSDR7Cd2XFV0pbMQ49s6y67WWA0OtUrtLn9kt7
	hzMyvJWZVFzm30=
X-Received: by 2002:a05:6820:221b:b0:69e:639:1093 with SMTP id 006d021491bc7-69e68b4e92fmr1261469eaf.22.1780929273169;
        Mon, 08 Jun 2026 07:34:33 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e464050fasm9622409eaf.9.2026.06.08.07.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 07:34:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
In-Reply-To: <20260608142511.659240-1-ming.lei@redhat.com>
References: <20260608142511.659240-1-ming.lei@redhat.com>
Subject: Re: (subset) [PATCH v2 0/2] io_uring/net: support registered
 buffer for plain send and recv
Message-Id: <178092927145.1038952.7018221349957103039.b4-ty@b4>
Date: Mon, 08 Jun 2026 08:34:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:tom.leiming@gmail.com,m:tomleiming@gmail.com,s:lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13642-lists,io-uring=lfdr.de];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A1B7A65777D


On Mon, 08 Jun 2026 09:25:09 -0500, Ming Lei wrote:
> This series wires IORING_RECVSEND_FIXED_BUF into the plain IORING_OP_SEND
> and IORING_OP_RECV paths; so far the flag has only been honoured on the
> SEND_ZC path.
> 
> Motivation: targets such as ublk's NBD backend want to push/pull I/O data
> directly to/from an io_uring registered buffer over a plain send/recv on a
> TCP socket, avoiding the per-I/O import and page pinning while keeping
> single-CQE completion. The SEND_ZC path is left untouched.
> 
> [...]

Applied, thanks!

[1/2] io_uring/net: support registered buffer for plain send and recv
      commit: 57ed21fad4022d595c6654d3b4d2b2083a79ee25

Best regards,
-- 
Jens Axboe




