Return-Path: <io-uring+bounces-12725-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wOX7Aw9UuWkNBAIAu9opvQ
	(envelope-from <io-uring+bounces-12725-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 14:15:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F3F2AAAA3
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 14:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CA8C30DAA2D
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 13:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD2593A5E71;
	Tue, 17 Mar 2026 13:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w+wu6OMT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581D9344D88
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773752928; cv=none; b=UD2owcjdEmflMYrJwn15G3esef2aivLM9cEMWMJbcqzsioOIU8l2Uc+hA/+b79gTpGJzSZoYeMeWQE2oVQ9pyAh2YVUfrvjg72x1PZwN4VBGQ0ZA69gG/jbJ69kZjUA8afKpJgcJU0j+/0n2MRkzJrQ2H77WzxHqKX+aEZ+QPR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773752928; c=relaxed/simple;
	bh=GGMDXOi2WQZvPGcngdr9eRZmaDDpLGcw2XW5sn/PyiQ=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bt0K9If5VH7hUQoUwbHsu123zygkqgXbNv5V7P6b3bbiPGF41XTGbAY1QExg4w+ht3MEsrId72wXR8EBhO+vsHtnIvSpR2joVw/2okKzUvsnUOBEy7fj9xnGvWSc8YJUZRMAc7wLNrGLUaZOzU/nYt97u1Zkz6JtV4mF6hstpOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=w+wu6OMT; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d751ef36ccso3211327a34.0
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 06:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773752926; x=1774357726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i/PLUrif59CDJ/17V+3cuLNJjsum4Y7DOWOSRT3IgQs=;
        b=w+wu6OMT4NOdNa2Yf4s6WL0AVFtI57kgzKQHrMljXxX8cV35bVpxxsfNma94mo1EtD
         W+LeIqZXQqfaadfMXksCLstK/V1+yP0toJm71dQ+9P1xP9dPviUzniCgvQPC2TdV+zRb
         /wjm/0JvsHaV0ivlo3K7sO0yKwiaG+yW25AeDZMyWmRXUkK6ZbT4NcE5DyrLK6ElhNFI
         asUPsp/MchxpRIo7JlwdoWJ4mgoqH+rQfVsNMOE2DUC2ZcYFcePsUfPdDvROFQNSiHw6
         fgzKYZTC6ii06iVYM+dI4dlWwxdip2Uhxgu110FghGRE8QMMnlrJ0yZawFgIWAVxxWyZ
         p/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773752926; x=1774357726;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i/PLUrif59CDJ/17V+3cuLNJjsum4Y7DOWOSRT3IgQs=;
        b=ZXk/+9l3LgeJxQgGbjlMJM2ZmG8esV1pF3OWBtxPLMh7d6JvFuzWwSnjAbSKiLuM0D
         p7D9BAtiCxSzHDdCJOzjb4HHzF/K7oY0q9+a3AlQ869+UN5m5DvDDoCQ8l5YSRBHKFVm
         f1HTmTGigpoC0Tqa++NTOwhy2ky+pASvrqvKs69LEjP8FFSzKYdXJ9ygiLgKTk2U69S2
         TWio+dk0IqjaVF7PoptfWg+kVak230CCoeM9QqgPeteNtC0Y7dfpeVykbq9yp2CINzQS
         GfRPPBzNg+gJoZVFcn+zliUrY/Fja4Oy7+JHt+NAL/13mOz86cNr9XXmXTY9PQ3B/VKI
         XXRQ==
X-Gm-Message-State: AOJu0YzYha67A+5TTLLGXUqpzXgZlACrJts5mCXaUggKZtQtFVWEyA+f
	3ZEydXmMchBjn7gU+plBae8PK6sUyaP212L3RNnOPyG70svAFhWYCDhYvpTi5Gh+0+SCOd0UJl9
	oAdGot0U=
X-Gm-Gg: ATEYQzzHagmkgXRZ/JXFmujEFbIgVrwOXymg0sv/AsDA7mt2GCMK1m8EzhkzcfMrMTU
	aHBYWUzE2mabbs8EZ9RMEys9H2q2Kl6fHSkmTEhaSn7z26G6HP8PoPclf53iRSMHlC+gn1JcYHy
	lJAjyx0qZQCjuxP+UT1ur0Mqhi6fw6o1Lhyt0I9ZiGIZuSxMFa6mVjO4swGG5xZoNSrn7Kz+wwa
	1HSIFltkcz4wE8sTx1/o/pnW0auCyzooBE8pZnqReW6y5F9oR29ENo4lwOmTypvD7oep2ThG4+b
	TlBL91T+fyHbfZKujB38pSzzOfRDltOYHAjQK26I9PH80YH8aYD2S970AStYycBrwmIjt4YKpKh
	5EKMPyDEQEhFZFtd55E5bBvsv64hjlvuxia437kHMOQ4kvPUGcn+XvQbXXJkOgPVE75T9uI3Ojn
	aV2VJ6s0xUx6se5BkAVHtqTXoODQMRF3MvAdNwHvep6bPSc9MmVzhNR4LZzTRXGxXs8KXBrzSB0
	i1A
X-Received: by 2002:a9d:7b55:0:b0:7d7:b841:c715 with SMTP id 46e09a7af769-7d7b841c99dmr1937762a34.19.1773752925949;
        Tue, 17 Mar 2026 06:08:45 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ae391f5sm14116821a34.14.2026.03.17.06.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 06:08:45 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f2e0ecd078f1b3c27428ea0921122d6cc0a2c6af.1773742334.git.asml.silence@gmail.com>
References: <f2e0ecd078f1b3c27428ea0921122d6cc0a2c6af.1773742334.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] Update headers with ZCRX_CTRL opcode
Message-Id: <177375292505.880912.7990368325537054213.b4-ty@kernel.dk>
Date: Tue, 17 Mar 2026 07:08:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12725-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 67F3F2AAAA3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Tue, 17 Mar 2026 10:12:52 +0000, Pavel Begunkov wrote:
> We also need IORING_REGISTER_ZCRX_CTRL, which slipped away from the
> previous patch. Add it as well.
> 
> 

Applied, thanks!

[1/1] Update headers with ZCRX_CTRL opcode
      commit: 560fac7b7625c120876b1840f6d8e79048c04b72

Best regards,
-- 
Jens Axboe




