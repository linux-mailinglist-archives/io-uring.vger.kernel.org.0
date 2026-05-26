Return-Path: <io-uring+bounces-13506-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OGChKoXNFWoTcAcAu9opvQ
	(envelope-from <io-uring+bounces-13506-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 18:42:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EEDA5D9E62
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 18:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5B5573003366
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 16:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 475423CF696;
	Tue, 26 May 2026 16:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="I9oo1pEj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936C13C5DCD
	for <io-uring@vger.kernel.org>; Tue, 26 May 2026 16:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779813750; cv=none; b=cZPXKDzQW9+XJlDY4crW4jrhWUQxPc4ytg78XJ6n2FVLWm6scPhQqb+bm3UcARtGCu8Dg6+zWkNlBZDs5exX2R+5H2NJC1rY25ItZchh+R8nLBl/PxCHrb23muQGQWxOo619eR9mo3mnNS9JwEYGc9f4u4kmO2MnPKVWzEXdPno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779813750; c=relaxed/simple;
	bh=5+ghzdOAeYiPC10bfdvW7qLblT51mD+e1870yn8q5IM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=m7gW6vA0PRqYuiBdBs99nUrZMm24mCzsx4F0iGQB7UcGSEsU/NHwKN8pe08KX3PX7HcZSsX7ggF+5U6dEheR5wEVEsP41OxnrKDzg7oyhXJ4HasMG6j+SV0sppe842fQQrzL0MVVIdc/S2kyRYlFaJslXZBcDKU52f/fMl1tsx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=I9oo1pEj; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7de4a9cb8eeso9826735a34.0
        for <io-uring@vger.kernel.org>; Tue, 26 May 2026 09:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779813747; x=1780418547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ZYtlrVR2dEham7O0YH+Al9z1p1eXpPP2GpFWfv22t8=;
        b=I9oo1pEjfmyW84aL9PvG+v6a605DHSb1Sbo0NsFtW6JrKKswGpwRudySa+/Po7yUWt
         megT8bQa/BvOM9/WgE98WvHKSnBAnoAoxGfF6pytX93UZJKb6afDbg55P4sHq3pJTTA1
         KhEOGvw42u7ckZsBbpVePVTrLtV3yGR1wBefS92iLdUAFCAHEKxkJ0gxFoqnwRiDZwX2
         gQye4ogV7j1Sf51cQOUxuTcDMQSCXFw2ag+u5PScLLdyBI5hPvy1+Rol54JiBpV0EGKS
         FBsuz2TIpxXuYU+BpRmhbh4EBLMABOPUbwSU0nUvUVpzTO6iqzghMhh8+yFmwMlxGpLG
         djJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779813747; x=1780418547;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1ZYtlrVR2dEham7O0YH+Al9z1p1eXpPP2GpFWfv22t8=;
        b=Oh5zP/IAmx/F3Q5PLhuSnqfzLJ6D12oykksFMhXzcpd+j6zWli13DjwfAGJN8jCSJb
         CzQlUgci2QgZ/nUcO+UpYm4TO3zl0Pc6T+vCRpeLemymKlcji2bylzvMtYu9NoIGm40E
         IZzCCd1MKuRWYO4AV+n+Kt4bDyFsZJXVEuudOzK464ntigoL1xla4+zRmhZC5E43Fizu
         OkcSjDrVlz6BOXX3zBGV3vUD3XxZ7f6AEnOago7HytYJlpTImpTSIZiCbhLyW73LkZzD
         ERpNzYd0tHWkCgm2cD+8Ik5wYE/1Gq0rUz3XEPm+E72Cb8P6nKn/MVGOS8iUJjKC9j/J
         R/pA==
X-Gm-Message-State: AOJu0YxEohWCzEldz5y+OtAGCshxsWatmfoLE8bySxwi//fJcaYQse/F
	xgUYwPlPKt4wtsDAKVPnPj9ifz49brQ/ph/YM/b33lKvSu3mLGWkoB8kvC0tpSdRxlw7UAqitv+
	OzIo8
X-Gm-Gg: Acq92OFp25YO9i0hE2eqfydQuH/GNOsbKjIP+hphPnNt33nidJNOs8eseLA70KMpj+V
	QxqGihaIAw1A51mlqD0LsRy6XTe1qhGaOGuY7mTWkGG6pcVmipEwi8g2Eg7TVZkgy6k93HvOWCk
	qjov6XJAjMCRqeYs09JSN2KzNq/XxVTeiYq7AdcmcCB9Ol/GWtu5v2h/7OpmcYXMugTr5iCbRFY
	lMw4tCaCSyZ6VKwKUQo2L/vRkA5dMOehHzM1EdiDhD0qkEEF4KGiZ1JjTmpbvMd3AyGvkZWQY6X
	E5fMZEAK7dklsY2FJD4BR0UwlQFL6FJkjN/5QMozz2k5UzQ+REowgAkB4AKMKzm3i3kggJGRDQe
	1J+FPvq0xHUVsBea1qm1wvzCi3HC6RpFkm8G3lWKqxLCadg3fi84S/vioa8w0c62HtlPOU/YxNh
	mMy711Jhz0OYatS0nm/9TtEsQ8c2nyCuX4ZiDnd939mXDaL7O1SnHOEYM79zmYVBLVY1EfN+QWR
	Ok=
X-Received: by 2002:a05:6830:4705:b0:7d9:b2b8:e06f with SMTP id 46e09a7af769-7e5feec29damr12084262a34.21.1779813747421;
        Tue, 26 May 2026 09:42:27 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e606482473sm9585235a34.8.2026.05.26.09.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 09:42:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <cover.1779189667.git.asml.silence@gmail.com>
References: <cover.1779189667.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/8] first zcrx updates for 7.2
Message-Id: <177981374538.466119.13708830919237773602.b4-ty@b4>
Date: Tue, 26 May 2026 10:42:25 -0600
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-13506-lists,io-uring=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 4EEDA5D9E62
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Tue, 19 May 2026 12:44:26 +0100, Pavel Begunkov wrote:
> First batch of zcrx updates for 7.2. The main part is patches 5-8,
> which add notifications from zcrx to userspace via asynchronous
> CQE posting about events like allocation failures and copying, and
> statistics. It's accompanied by relevant query updates. Patches 1-4
> are general cleanups.
> 
> Bertie Tryner (1):
>   io_uring/zcrx: reorder fd allocation in zcrx_export()
> 
> [...]

Applied, thanks!

[1/8] io_uring/zcrx: make scrubbing more reliable
      commit: 74fc9a9b50d43ed473ea2449682000da43e17175
[2/8] io_uring/zcrx: poison pointers on unregistration
      commit: e57b44039bc54bbdf3d1511021458356858a4a12
[3/8] io_uring/zcrx: remove extra ifq close
      commit: 98f07b0f74b65284ebe0d021505b461d4be6bf07
[4/8] io_uring/zcrx: reorder fd allocation in zcrx_export()
      commit: 84f7d0931c42cb0690615a431738cf6913d265f2
[5/8] io_uring/zcrx: add ctx pointer to zcrx
      commit: 8503f2de11f7fe78a7fdb87746255c8d02897279
[6/8] io_uring/zcrx: notify user when out of buffers
      commit: 0719e10d826aa0ba4840917d0261986eaead9a51
[7/8] io_uring/zcrx: notify user on frag copy fallback
      commit: 255180f7034f48aa5b0c8df70228307394bddbb9
[8/8] io_uring/zcrx: add shared-memory notification statistics
      commit: 6935f631465f5f60205978a59228a26db4723d51

Best regards,
-- 
Jens Axboe




