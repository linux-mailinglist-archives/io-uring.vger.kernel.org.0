Return-Path: <io-uring+bounces-13085-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SIz9HtmE52m+9gEAu9opvQ
	(envelope-from <io-uring+bounces-13085-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:08:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D840743BC52
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 16:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D770301E3DC
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 13:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F7863D6CC1;
	Tue, 21 Apr 2026 13:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="d5hH2Ee4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5AF3A4F58
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 13:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779895; cv=none; b=ZSqv80ylSgXBKFrnE2WS5n1IbLYy2+13nLEMLfCRvYvI+hJQsmk5AjobB0T3rlCvhFE55UmZuaZC6m50zukQjuHnopUMiyKtd6oWVBDfcY/zEBis9wquoXGhEOGLpSg13o59xbLyMdMSX3pmyHbN0PQwX0/v8D4/RKixL3J7tJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779895; c=relaxed/simple;
	bh=h79PSbg/IUermI8GVLDR2GFVPUmxoadUkF2GldaCZoQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nrAXUSqsKbfvCD0SHrziWS6Zi64JxZEiHY8H2Ja8SEn0/ucPGzp0cMq8gHrXb6f7G1VNZBPIOZ3shFg14EYNsEh2/rhsF9i76iT6w/2vkzJW4eOjVdTPc3D/yypl7XF1lDz/BBJwodhZxQSrzw6WWIFuWBr6urVw0dIheOVhwzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=d5hH2Ee4; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-66f747175d8so2069860eaf.0
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 06:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776779893; x=1777384693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JNGZDDJHB9Ki23I1vuWlnb/tBBT2Wz3AVfTrWTmwcA=;
        b=d5hH2Ee4dTVdm9yENqC7RbDAuPbI0fnnB5oAsViaZvAUjO0qcfW9FjN8ogIywISPie
         m5kBdEhwEB0cqQo5mKJG+0Ddz2+pUTPQe2qmmEMbuOpIQzTOpPdKNFw74jEofK9IXJlt
         NqCfoYqSLysXrHQAob5CrRqX3NlM3W9vTAWUrNSWeMKMk1xPhXyWivk++W6S05UYluRG
         eTWv6++oa5Wi5STjg7w8fwhqbk6+QqXlcOl5DBEmN0tt7MK0SynREhWyf5jSr85YgXUl
         F7rb1tVTSpO0GW74mjPbJ67C2mTYagzox+hRMU7v2oBuhhYZRcW/Y6L/NN/BgWKkcOHo
         XW1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779893; x=1777384693;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7JNGZDDJHB9Ki23I1vuWlnb/tBBT2Wz3AVfTrWTmwcA=;
        b=cW+C8DfkzSzGUaiZs2yFsGfh2PQ0+gpGtBJysYw4nj02QOW3Y+I+1ZgZyW5B/dImdw
         ZfOfCCDLsBJnseMac5dXO+HMoyesqK7P6+gz5BfDsj3WjhYcexcmL1di/8vnm96Kl2Z4
         Z2IHj9b8qcC0t9lMeUS9sBIGcNcf3Ct8dsTk3AptQAPjmda1K90U7Uok+dKtCtm5KwFK
         CQEj0W5lFYhTBYbltrBUzO5ZIok+LO9m1pqmhORDsserkKAZbPbGXMFxGgOI+UzYDKLe
         n4AXo/k2eVT98xKonrAzReEo6Q1Vh9wd0LeT+7wgejWxcb8ICN94aeSydj6rPDRfol5A
         i6xg==
X-Gm-Message-State: AOJu0YyziCD5O8BI+gf74c8TRqMiBf1RcpBZMZb/e2qb5918cjnXZOCz
	J61LZsRjbwqn3dSdysiZa5p2+vDL2LHbIWltlvGPQ2fa9I/hWsk9PwaAleDuPHEDbhQ=
X-Gm-Gg: AeBDiet2pwZRqguXpkUVrxkd1Ln7VQ82RwLdOqXUNl+d5XboGfRxJiKOw8v7wo8jqkI
	apfCbxyynuU+ZmpueMfpJdWH35zP6/qC6nHMFhWHfh4d44QPCM32J5f7gayuRCNRkzLCcFP2FAL
	5w3s8yAw5x4FtmftNK3wrogsfRn7+GZmjt1KkgwuoPWlVCC2z5lvuR9iHh5MD9bzi9q3Qpcdm4c
	3uq69/vptcSmD5kNuT/EMhVKzbjiMX+PiaPA1BzyUFPcjxZphMDJ4PMJS1ZvgdNcfjYWfoZKzWB
	o10TLnzeFbZllieyY/cYLXPvL7XW8BFZ8Q8YapKXEciONIieVjYgfV10ift4FkRGuvbrAWlOcJo
	yq7zvAX1yH+Y1czVak+65DSAGkdUwrsdDdSoBAjG2K6j/GWBNEwhzItzRqyJU1TV4ZbraJQb3Nh
	sfAvcMMMudV27ucSps1tloF2Vg+TLoQm2M6pckm6pPwW84bmDUJIo+Wb4ki7Hz1wIaqwCH0Vq4p
	Adn3WpxOswD6/8=
X-Received: by 2002:a05:6820:2901:b0:694:9d3d:e040 with SMTP id 006d021491bc7-6949d3de22cmr704907eaf.31.1776779892805;
        Tue, 21 Apr 2026 06:58:12 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-694984114f5sm1229359eaf.7.2026.04.21.06.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:58:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <e560ae00960d27a810522a7efc0e201c82dff351.1776760917.git.asml.silence@gmail.com>
References: <e560ae00960d27a810522a7efc0e201c82dff351.1776760917.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix user_struct uaf
Message-Id: <177677989210.583761.13165622082638162638.b4-ty@b4>
Date: Tue, 21 Apr 2026 07:58:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-13085-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: D840743BC52
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Tue, 21 Apr 2026 09:47:04 +0100, Pavel Begunkov wrote:
> io_free_rbuf_ring() usees a struct user_struct, which
> io_zcrx_ifq_free() puts it down before destroying the ring.

Applied, thanks!

[1/1] io_uring/zcrx: fix user_struct uaf
      commit: 17a2407de81bf3ef450fddb89230ac10141be110

Best regards,
-- 
Jens Axboe




