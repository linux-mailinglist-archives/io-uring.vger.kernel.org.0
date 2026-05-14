Return-Path: <io-uring+bounces-13327-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EJqWCh3NBWpGbgIAu9opvQ
	(envelope-from <io-uring+bounces-13327-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:24:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8265424A2
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 15:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 51058300612F
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 13:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87E313959D;
	Thu, 14 May 2026 13:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="UA00B4KY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7494326F293
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778765081; cv=none; b=PrlFPMDToqi2rGnZ3WWB+jLO8W0UM+llL11oMfahyHvwUbridW2cO1y9TYdeTMHbxIfbpjBl+A16kEPC25RkazKy7cszc0cm7WyjYj5jSaizyK4Nd8xjjULgz2Y7aOtgwkm4geRbm4RaFhSKH8z3Sm969TJxqVpr6AVcilkcpp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778765081; c=relaxed/simple;
	bh=KmAJtsOfoUzTCiFmf5Jf0IeYg7Ymr/tW5VMAgamqLB0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=onoTccRcxAWGH/K68XvWUprWwXfxoTi9mDxTWQTaRdjYLD4f3bb1j2IA2FkpCXo/xkmdXspuRCv7ROhM0Uu5FLGTzdXboZyW/qrJIePThzBrrbvonuTCo7wjredeLdezLKcs1DGpAv2TFigm3PZm0Mwytr6ofH3/oy7973ZDqD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=UA00B4KY; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-415c8a4d2e6so3752626fac.0
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 06:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778765079; x=1779369879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SbSYYnlDSqscUvT30NSlVKX8MH/5EYSLovToRHvloVo=;
        b=UA00B4KYTK4M1jerJG7vciQDIv7ePNfvxJVdGK+yq6zVuSlvCS7/6K9vVtzoZFMBSj
         ddMlWGxSG16hdiqEnShMYcrUtvRJcjZWeAjC0Y3gjY+VomcgqugMdAC2EDzHjP2O0hbB
         dSxJL7U45/WlAsTZgYoKaf+gU9rwXxF1BOp86D3+tyWW5XKVbHoE6TqSdHxU4vd3pKU+
         Q57ARnAZrgINmv6PRMUAcV7mOJgO+P2pkQOnDGLYAg72ZRhWl5Nbg1HaQ0VncpTHIiOx
         zjIknFgUrv7iVL+wb1hcxNzx6XCWircHPauGU6bvQdAqQ+96QT03mW//2N+cauofIcE7
         WCLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778765079; x=1779369879;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SbSYYnlDSqscUvT30NSlVKX8MH/5EYSLovToRHvloVo=;
        b=Vf4b3CZ/kYqmgJxEDc2x2ylbgMIOOBHtoNTXqtBw5K2BnlgWTlSU0gqVY1rnjphuoS
         3CHB1CvCmViGVNvNvO05rcGXS5l/l4sJFtVFyW1DQagx6528iMlREQqnnUVS5EOq834G
         nVUGQj0Q0KMnip/Pohbbsc2rK4j3xA7Y+BOhiBOeuJx/HTYOmzP7EX1NEY6fucbxA+O4
         TI6kTQ8rhCZyjkeMHYJMouL3pO8JvfBOAEYUgUTKAGQ9PHMypVRlCGMka6yEvrg9PMgR
         FLpsvNDICFBCH4TDRs0TA5VwuNo/yWhFk1RzP/4ctcwJ02K2IaeKscAD7kyjYgQ06L3o
         gWjA==
X-Gm-Message-State: AOJu0YwiIXaNl217LhZDAWICFH5z61QMuxNTD0Pq7Eg297wgalnAAuw3
	rRWnQs8fgYomyyHlT77OEWqjHe9s0MTvcre+YoZWpY56qYkWZ2dGouOF4MpZEgiZZKIBOONWqQu
	fCwcB
X-Gm-Gg: Acq92OH7sanUj82Pe9PYOUA5PUW2bTHsvk0W+WYU5znFkN6fk/rDTmRLF3ZjZZ6uuKW
	tBZWfOAPbvBD95/inBZm4pu16V8MzD7VjtxAJ31nAMNya22FFDh8JvO3EQUvxHvMpsypszd4Itk
	T9kT2WekBIT69POEuodiJdEppVg9zK+3lRnjzwMPXiXUal72hQW9U68X3Q5DnzBR5HkQPrRiYyf
	ok5rnNR1QV118rYo2IrkX8zRWkORqjrx4s5tv+keXTLfVfo+AnNgR+RwoHkyXKJHN0e2ukj8wrt
	U8SSEGY0E1Q1ruFnsGWXOeq6ielgCo4GcJpvfdH4d/7S28ZSaC3tcsoH9tk9b+6EZVsaBJOyzWH
	9JQg2U6OVZ0EniC1QYn7ZSDFRQjQIbmQoEp9nKDLCS+FZbIMn4+DNkB9Muz6n3gYYKECP+GUYqb
	ImcZsz4ioZypr8tGyqZGBIeNdxbIgHhNdLCoKlv8dFmcjnuMy3IZ29Y8ygGvAgO+9ALB3Yhkoi+
	Z8=
X-Received: by 2002:a05:6870:4153:b0:41c:5589:ec48 with SMTP id 586e51a60fabf-439ce10ca64mr4738074fac.16.1778765079369;
        Thu, 14 May 2026 06:24:39 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439fc542218sm1812296fac.16.2026.05.14.06.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 06:24:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Shouvik Kar <auxcorelabs@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Kees Cook <kees@kernel.org>, 
 Christian Brauner <brauner@kernel.org>
In-Reply-To: <20260514110751.1927-1-auxcorelabs@gmail.com>
References: <20260514110751.1927-1-auxcorelabs@gmail.com>
Subject: Re: [PATCH liburing v2] tests: add cBPF filter tests for
 IORING_OP_CONNECT
Message-Id: <177876507818.607079.6335728086640819526.b4-ty@b4>
Date: Thu, 14 May 2026 07:24:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: DA8265424A2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13327-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action


On Thu, 14 May 2026 16:37:51 +0530, Shouvik Kar wrote:
> Add subtests for IORING_OP_CONNECT to test/cbpf_filter.c, exercising
> the io_connect_bpf_populate() helper added in the companion kernel
> patch ("io_uring/net: allow filtering on IORING_OP_CONNECT").
> 
> Coverage spans both blacklist and whitelist filters for each
> connect-specific data field (family, v4 address, v6 address, port),
> plus v4 and v6 subnet matching, and a test for the addr_len guard
> in io_connect_bpf_populate that prevents stale io_async_msghdr
> cache from leaking through to the filter on short connects.
> 
> [...]

Applied, thanks!

[1/1] tests: add cBPF filter tests for IORING_OP_CONNECT
      commit: f4b781ed18cda473f76f9535f500f73903a5d5aa

Best regards,
-- 
Jens Axboe




