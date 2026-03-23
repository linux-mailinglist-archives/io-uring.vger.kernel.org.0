Return-Path: <io-uring+bounces-12811-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SEI5Hg/AwWlSWAQAu9opvQ
	(envelope-from <io-uring+bounces-12811-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 23:34:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 386612FE4C3
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 23:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 18B2B3038FD0
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2026 22:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6390381AE9;
	Mon, 23 Mar 2026 22:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YQrp8FCH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED269381B06
	for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 22:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774305258; cv=none; b=HtLGgSp/mZch+NHA0g/ZLpRGzuwfflpd56MdQsyDy5+kPNSZScEQoXGNSZ/udGDJSEqtRO/4HLuNUoHZVqbmtTe2T23eJs7MI6frLwlrG7WbdNdpGox6psc4z99MFFdwmtq5l5PH8WbLEM29lhJ+08o9WRh1E3vggd8nAS1agSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774305258; c=relaxed/simple;
	bh=BXFmjvsjMQTvfaMWOZQXkrVfbrVYPtM0fGsvLEU7BhU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gIueICb4QzBMZp9zU5cTzeAUGxn0DAzvxSokI3UvBy/hMJ0j4MZJHCCnvt2Zqd9S+dD6JOHKqnNIB4wwp3RK+eT2YX0wuOsNGas9in22WKRKcqw1CpAuEhnr1yb37en0ftKrZWKT4DDC3FZLmUZeS5eeYvyBag03u0iJH7HugO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YQrp8FCH; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-45f053b7b90so392112b6e.0
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 15:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774305255; x=1774910055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCxQIcYStCZz33HtObf8vi/uZK0sty0tF5QsKOfJztI=;
        b=YQrp8FCHh2iyAvabbwNEEWozisfQkJBW7O0xtNNC5RLkfsUGpZaLZnVHzEhj75PVEY
         2omE2FLb21KYojiwubFUou94u06JWZFAy904EwYZERt66LQ2cpPIfCUDKNNvHbqeoSEV
         nVqEemxHiH2OWRUAdet32V2E7Q27BvN7bEJZ2gl/e3LVZo/TYNm6A/2JBV5p0p5Xucml
         Ec1VHYm8lzJY/5H1ZNJVA4a015UevFeIZvnci5ujDtMIijDW7pdVi1rT0kB9JKvNp8+i
         e9nQnSsyJ9WlEH+BfUAyqRlEfjos0K8Mj6zB9aAGdpnh6Hu7J2jfzcS25hmIul0WV4yC
         3R9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774305255; x=1774910055;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YCxQIcYStCZz33HtObf8vi/uZK0sty0tF5QsKOfJztI=;
        b=DQiwCdKoPca2sWcYLgeW4gMVOE+SOWVusUTrMOXByDB1kPE1XiIGMLFWAN8j6Yn9J3
         n2eV02/17dw9Fj88TU5ft66zvWupVxuqs/4bRwQQyiJi4BmjYGrCMx+RSnjnRECtbY5S
         Q05fmUNVeHPxXJSgJ2s+Ijz8ueZKgPcC2CsJBUQtL1Tpsqu2RXRPW4ILo22zvz062mT4
         MlMwlqxPiai6YBdROo4iMP+KkhKhZ8uwJNgPNtT/fHqQKzFo9KrprNawmadnkuEJS7sU
         6D1DIIDS2/OQ+LudX8G06Wi+9lGJ+iWjOvIjcaKOQ2vZtKkpa3AzXK/L5/fD7dpWeXtm
         E9Dw==
X-Gm-Message-State: AOJu0YyG02x/Fl2WiAICdMzwSvnKGVa+qRuLUfleu1oBoGzA0KcEHDYV
	57naTfC4oEDyVytROTsx69ZVpMKTeCU/xyi15sGaXTtFhygWS1uqgtg/d5j/9BZji8iYxLXYC75
	K8z1uyis=
X-Gm-Gg: ATEYQzyvnu+RrJW/kzK/3xwPue+nO3dp6UjHEgYqW1RolG6cMnhGDS/JCi/8gPPU9Sn
	ClqV/WESXPDGied+62u+hnDuFwyobq7kZ9XBvjwyZzItfdk/OXVNG7loy23uBY46HqPGNJtaFF9
	03ei1yuHVOImif76Gvw5r0c//bWI6Grd6m2t3rFYg5/uSbRm5dCvilRRSJ+nxSg9mi7em3NqoDK
	4StKaHOoFTxLQJx/KomZO8VXS+bkJz058s6gHDgUyI7oru4WEZFBiqh34NJTReqXVd9c9LMNKz4
	F05mcNYLxLfFjJ3MmF8/O1DFzjaI/6tP9PFP7u4FNvy4c98VSxwhutXX7OrFDnEuXlAkGDkgtRU
	WRa5haZotjU4H7U4d10huyMLkfi7JPn/T5jBCa1Hqu48FEsXnFJ1RKiiNuiN9xd900E5OyrZP3T
	d+gWUv5lcC+rXSqH0YWvJwWmSmBh3gDvDTuUHy/6ykHGuUALAJp1uL3zimg92VwvI660bwhg8Sq
	HFz
X-Received: by 2002:a05:6808:11d0:b0:466:efb5:9434 with SMTP id 5614622812f47-467e5ed6d76mr7944787b6e.31.1774305255312;
        Mon, 23 Mar 2026 15:34:15 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14dd0a6bsm11014124fac.13.2026.03.23.15.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 15:34:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <cover.1774261953.git.asml.silence@gmail.com>
References: <cover.1774261953.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring-7.1 00/16] zcrx update for-7.1
Message-Id: <177430525401.475832.17980460579260076952.b4-ty@b4>
Date: Mon, 23 Mar 2026 16:34:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.0
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12811-lists,io-uring=lfdr.de];
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
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 386612FE4C3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Mon, 23 Mar 2026 12:43:49 +0000, Pavel Begunkov wrote:
> The series mostly consists of cleanups and preparation patches. Patch 1
> tries to close the if queue earlier at the start of io_ring_exit_work()
> as there are reports io_uring quisce taking too long leading to fails
> on attempts to reuse a queue. Patch 5 introduces a device-less mode,
> where there is only copy fallback and no dma/devices/page_pool/etc.
> Patches 11-12 start moving the memory provider API in the direction
> of passing netmem arrays instead of working with pp directly, which
> was suggested before.
> 
> [...]

Applied, thanks!

[01/16] io_uring/zcrx: return back two step unregistration
        commit: fda90d43f4fac7c0ee56a71c5a9a563bd57dcd96
[02/16] io_uring/zcrx: fully clean area on error in io_import_umem()
        commit: 234fe7bc53d8b2b37bf26a1392020e5b7b58c7d1
[03/16] io_uring/zcrx: always dma map in advance
        commit: 8c0cab0b7bf768594e8efc73f7b8f3d5abeb74f1
[04/16] io_uring/zcrx: extract netdev+area init into a helper
        commit: 80a4144de4e1cc8faeea700fb5a6e6ccc8aa02be
[05/16] io_uring/zcrx: implement device-less mode for zcrx
        commit: c11728021d5cdf8d99a5b127ec21d957d93e2d6c
[06/16] io_uring/zcrx: use better name for RQ region
        commit: 3bb8e0665fd7497e325ef799f945eb9e70186476
[07/16] io_uring/zcrx: add a struct for refill queue
        commit: 161399f0a7414e6b1f09cc76bc1067816bb04ad4
[08/16] io_uring/zcrx: use guards for locking
        commit: a5da6e340ccf62d2672ea90a400a4a66bd13205a
[09/16] io_uring/zcrx: move count check into zcrx_get_free_niov
        commit: ac02a64c479af1ab85b5c31b82345c1c9b6016d1
[10/16] io_uring/zcrx: warn on alloc with non-empty pp cache
        commit: 072237bd1a919545a1c174cd6171a5ee8e709096
[11/16] io_uring/zcrx: netmem array as refiling format
        commit: f3e6e4b057a8e1d4913d92f564c80c3bdd5dab55
[12/16] io_uring/zcrx: consolidate dma syncing
        commit: 2bd8e5066fde4ca5f9f382676ffa830c0e2803fd
[13/16] io_uring/zcrx: warn on a repeated area append
        commit: d2df9b6808abcc46cec4122457693001436e06e7
[14/16] io_uring/zcrx: cache fallback availability in zcrx ctx
        commit: edec451ccfce61291588163f2f8f7e9ed46bb119
[15/16] io_uring/zcrx: check ctrl op payload struct sizes
        commit: 49105528107676a49e5d5a50fa865781986a7c61
[16/16] io_uring/zcrx: rename zcrx [un]register functions
        commit: 623a6d44981f78d7f3391a59d62ae8b55f694850

Best regards,
-- 
Jens Axboe




