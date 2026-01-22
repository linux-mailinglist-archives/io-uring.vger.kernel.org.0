Return-Path: <io-uring+bounces-11893-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPCqMNSrcmkkogAAu9opvQ
	(envelope-from <io-uring+bounces-11893-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 23:59:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2459D6E598
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 23:59:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6D49300BD8E
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 22:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5215E38FF11;
	Thu, 22 Jan 2026 22:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ku/ZaNU8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48413D8094
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 22:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769122767; cv=none; b=qPo3d23OMfJoBFib3Bl/tdV8BZFF19PtBQIZJQTHRdOQXqk6LNBYMcj+kyPWCVX0g6LFgnFcvkwydfG67bSLmWzmLZNNakpqg3FsLQQQeSXqU4eGuzoHvybKxeluUUtIDFE1i2ZK/EzEgm2IqgKji0GsORoC3eh2Q9EODfthqPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769122767; c=relaxed/simple;
	bh=Wi64H88y19xhSauRYglp7elxd1D99YnLBaKlPC6UXX0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bbDZeBBFX8P80O3XhyOXv0UJjA7AfCbEfEqzBzuLG2FptIixcYh4kbOq2eAqs+d83i1rdRxyg1Oyd1y7iuIPZrqvZKxKqPAZp1QuPJe8N55T9p81LQZMfV2xruqZAe0h8jUBI6P3ZczvqeX5b5Iv/BAOPLaoLe1b0qJwsJvcvlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ku/ZaNU8; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-45c7f3a9676so1186686b6e.1
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 14:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769122760; x=1769727560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ORu2aq64SUgYQh0aU04+Akrjmz7zeyzEZX8BfiY+G/s=;
        b=ku/ZaNU8038Tmf5uBaKxusMXSFAkajHSNYsXkteWKgKv2sIz4X0zaCuGQKSJwcq++N
         /dsIfLWKp/3x5N6U3ZIqDYlwLlftwXKBERXCh5d8i5PJsn4U4YxcDHyHvGxxCmbTCtXF
         4Ta1NsE+AYE8G9dZv6OTQsp8MIEWjTnLBqdevhdWFaBa2evxhN4WYrd3jcJir4zEbeRi
         eLX29+osIOozEa6pIXzSspwEU1uMA1jmf3xy4Kz4Pzsf2c97xBN8WOtMYwmkE477FlxH
         tVwn9NJI44TEmLBn+oYHOV66UypsrJplQn2VNfjMKKjyV0BrxFiz7Y6E08GxI+igy14U
         KmLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769122760; x=1769727560;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ORu2aq64SUgYQh0aU04+Akrjmz7zeyzEZX8BfiY+G/s=;
        b=nfRjm9igp6gl9ULg+jZlY1WUqTdA00z0sMLqlUIdENfk5FPKUddpXYDQIY4/JC6Piv
         cI4vGR2uhN7GTKFu+oyre3gSlFnFmquKnAyYRrDkcjf8+hmmcxvRHzsnXosPeg3icRhw
         al8Uc1eoa0sY08+ADAizVa8MEVIQ1MCfWnpHdCursQCUfVrwh5mVtZx32pZkxFPYrwgJ
         Uk3acn5lUv4Oc3VuBpqE9zYzrM8FNwXqYFXzfUdvSwj1JpS8U+kO38ixCt044JONbufu
         CDwJlPbl7WduG8uZ8fOhbjPVhw9OHYgvuIEfhfsfy3Ue9d50m4F6KjHtsxTQlIo60Q3e
         3oMw==
X-Gm-Message-State: AOJu0Yz04eeC3eYKYU9S63C4Vd37Qj+5V68hPBQN2Suyb4NC5RO1M2k6
	8kGEoKtJV6dYGTA5rx9zmcC8DC3tc8DO0QDIlppLBec2ov/bbfnpOB21ul4sRH22p0w=
X-Gm-Gg: AZuq6aKdGyDaEXNoy5y0oSv/4sQkdszTTOoy/rA3GACHckVHHND2HAn3/T0X9XGa21m
	R7Ozy8O6waXbG6gWo3poGjwbZ2i+Hmf5q9l6ExmdPtMsv7pNZbux0FUZi2zk5srismX6bpLvw1B
	uaaXqYZU2XTKNYD1j1/DE0f5LBLw7RqbHWYIX4/p283NWsWpg3rt5/oPDAO0LxeLve9wtJmhe8e
	gJgm1kLjFZ6jJ+/VaAG/DiOaaqu2KzRtswqpRGYwcvWORqLE9Ceu/XmPDmPYi55MGqGkITbWAsN
	4AS0QStoDRVR66a48hv9gzwWHwnYuys87EWvC3ubHeVW4vWk2J6RZmpYhT74o1oVuWwhQTXsd59
	+ao1JVJsMWj2POMGWZ3AtVahc0aa0GEnUbwKCen+4F09GSbIP91j0nBYfhpR1ksyggn6/PIC1KF
	BX60zzGRguX8NpJ0iqQrrtS0BtB2jRRiNCLFRhdCP22gqo35CiaA0Dyk2PUv0F0l6a
X-Received: by 2002:a05:6808:2507:b0:43f:68b:acb3 with SMTP id 5614622812f47-45eb22f8f8emr439797b6e.17.1769122759710;
        Thu, 22 Jan 2026 14:59:19 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45eb4235b50sm290180b6e.14.2026.01.22.14.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 14:59:18 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260122214506.88529-1-csander@purestorage.com>
References: <20260122214506.88529-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/rsrc: take unsigned index in
 io_rsrc_node_lookup()
Message-Id: <176912275829.523910.8844345576274421651.b4-ty@kernel.dk>
Date: Thu, 22 Jan 2026 15:59:18 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11893-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: 2459D6E598
X-Rspamd-Action: no action


On Thu, 22 Jan 2026 14:45:04 -0700, Caleb Sander Mateos wrote:
> io_rsrc_node_lookup() takes a signed int index as input and compares it
> to an unsigned length. Since the signed int is implicitly cast to an
> unsigned int for the comparison and the length is bounded by
> IORING_MAX_FIXED_FILES/IORING_MAX_REG_BUFFERS, negative indices are
> already rejected on architectures where int is at least 32 bits. Make
> this a bit clearer and avoid compiler warnings for comparisons of
> signed and unsigned values by taking an unsigned int index instead.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: take unsigned index in io_rsrc_node_lookup()
      commit: 82dadc8a494758093e775336390cb31033c6f9a3

Best regards,
-- 
Jens Axboe




