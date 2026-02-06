Return-Path: <io-uring+bounces-12079-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MHYTIyUEhmmyJAQAu9opvQ
	(envelope-from <io-uring+bounces-12079-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 16:09:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 05447FF7BC
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 16:09:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4E30230104BA
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 15:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D20327F75C;
	Fri,  6 Feb 2026 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WR+xHuiq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2CB26FA60
	for <io-uring@vger.kernel.org>; Fri,  6 Feb 2026 15:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770390533; cv=pass; b=Wef87SNjd7PjUWL5BU+CfLu3uwb2i7531yaPaP/YhVuphMig/rL33b002Aexq1fqLynfnaaRByZwcsb+5mWw+AD7pDMd6oNg5xOedUnuR/7ILefkgkmS2TshBESSNE632WbFWufdRWj7YulDmsx9G6MOSnLEHi55i193moUNafc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770390533; c=relaxed/simple;
	bh=FmcW3+jk1TotXNp0abhfHHj1CNo1HgJv38wXpbipRZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mq9Xgr5Q1x/usJsXdBhqJ1gxlf1qnqCQgZ/7b2r4P2H2VLvH/ma+G8r/YS3KuIE9OGePLh0iat8XTVpShmYwvn/9MORy6/UE1MUcsQ+uAmzChD0lrFuUllidIuURFQKDdtwLG3JORTefwNJUV1LIi6RzT3Z2CXUJSqtI0tJlQH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WR+xHuiq; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-658078d6655so1269240a12.3
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 07:08:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770390531; cv=none;
        d=google.com; s=arc-20240605;
        b=MoZXcPlv9U563fB1jOBnkLjLiAGo0poOSb35oENNlPpUC4LZsa3+sK4/fAsfXuu5SI
         Pj8v5CxlHSqJLmguv59kaQG1o2tiBrRhCMegwmrALyTHOoVPoOses4x/DdzYfIkUEY/h
         SFUDGYZcS9kE+ViSkim/Fb/zqVVGBJ07V60mRMoLeF9014qzLbRKJgatRRyNKqFIXM5M
         wofN38NSGjIYaS+Coa79U3zwTKB6pgWmUhcFk7swaOiwiorJ3lM6VDT6WVFeYIDDyZhq
         IIkbvwxbTbS3cc5Gdfk3p9zUTAYWPQQyjDwyOsSbGH+bdlQXQkeyNWouTB+TbJfCVFMq
         G6wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IV2wXVQGGux8HdfCehvXRHDBtsaFVEwot7iSA9nA38k=;
        fh=nHwZ2P16PU4Z1FRN3c4+Fd4amW/3ZShktVT9QFGS3qo=;
        b=cbilThLcomyGIkAH2D8zAfDA7/xov4bmRkjSErVGQqV+ggjuWLQZJjIQijItEu48wD
         2Nk3sNVzQcrXJA0lxD8Q26aHpbyvqrd0h63sHwl1PWwU1TxmJCEU+IhNseSln4HBa7GG
         Jsm/W33pVgQ5HUtWiEl71JoC0aE+fbWnLXpDaFzsGRYnBGi1pW+pcsCFsy9KxEyIaIp7
         2kPNpS7QeisgaBFUDfKsQl+2b8l3DGtIVbwnMflzpIICwntvuDyl3Sl+pinlnpCZftWi
         Whqc4aevjkW3nGyqZpFpLnIfAj0T5pBgMuZBtM187Mld0Yt1Z7kN28M7m2tudRTQCJNl
         XQYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770390531; x=1770995331; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IV2wXVQGGux8HdfCehvXRHDBtsaFVEwot7iSA9nA38k=;
        b=WR+xHuiqvLCmeR7rhyGhO4/EwrBaQa3a6rSz1gf5I28lqTnIaym+sW0J5xNtMzszE3
         SUmp2/WeTD7mcyCB82AoY80uSjupBet0cijyEjKlIO572PNOY/h5PcRSKPib4ab9Z+4N
         /DPXqqAIH9bqx5T8gDWAubblFgKs9+y6pOgNa1a8Ah9HRPPusDwQhE/dgFeQdZcUgy46
         qEmAsWuqWsVREbHBkuG5kzqa6yY3M7PWrk3z4Moh2RJjY44U3Jo4g6IYun742m5n6Pi/
         iRddR11zq+/xH79/rzcLbGQ/Qk2Oa+LmzNUaSKdbwVOVE2YGWoYUzO7LXhaznte2lsU2
         bP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770390531; x=1770995331;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IV2wXVQGGux8HdfCehvXRHDBtsaFVEwot7iSA9nA38k=;
        b=GP46Jf0z4v63tFOj0yuBlZcBCrZtqLxhUcZVTxQC3lTpEwXIxkMCJVn2VIncLgv32y
         TgWAGZMebF4uONcOyc1n4d895nVQ/Z8y8EZ1+Qy2MINNajXzhFzhSVizlYlEy6eA8iVt
         xM/15dZlzLHt6MIw08OvJWFWZQB5DdUAPpV5zaMBTFJX0a0j03JUmLIkAKrTGk85Xbs+
         RP/TLK0YPpWkNXN0JyCxwjDP5q8ZjWYEnIZE9b6XobatLSpvV9Ora59h4bcrQKdZmi1N
         VI/a/l5BATNdAJPFx1xeTj0QDEz7FqASuHWK5I8hHSwd+G9pZJaPMUpEAP+DIp71+YvG
         DjIw==
X-Forwarded-Encrypted: i=1; AJvYcCWmZMTCN6rFvoBfjSbRtFHL/6OsMoYikDVPql7q8iuLz9TlNKqjyTv16cZbMs4rm/KqZ69RawCJXA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg40vUqzeZtNaxS2GCuS17IlsMGqZa5Hg2/YNcJoOLE2ORTZEA
	QkiZrpawLBU2hPbOYPAQqnoBXwRFaj42D/JWAVHslUW2k8Lca9Qt5T9Q7V2YLpuCwTWZ5pyao60
	RqVKOlecpYkuXM3pNy39keo/8T68jzg==
X-Gm-Gg: AZuq6aIwTMtwbUpVbZEH95qmDaK2YBWtxKE47u2mQ9v6AC3Q/Lk+yeGTwU7AelHSi2s
	9+UYO3PoqtYw9RAD5OIydkSdQ6zOllS12U1ro9jJ+9QHmNevS9Z0nkBwuYE0RJdhnIE0c/pKWn6
	P6Rg1nofY8Z0F9tSMv0qCivhwFv8LGdTHYYikbXMVZmsm24vLw7nKE7eR2YmvAxORLdZLencQWy
	grrUgTdExlCIFIBmgoHlBT2JPK5Gp0a0qQV1bxIRqIaJjJcuW1s6+EjrPOxlfFKB+n14mP978cL
	uL1+uWsV1ZIy3Zl3CvfGoGHQUTPylp0tcIB8VGHDw1mZAd9jDuUrCOQ8Pg==
X-Received: by 2002:a05:6402:278c:b0:64c:69e6:ad3e with SMTP id
 4fb4d7f45d1cf-65984192b46mr1665335a12.33.1770390531549; Fri, 06 Feb 2026
 07:08:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1763725387.git.asml.silence@gmail.com> <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
In-Reply-To: <51cddd97b31d80ec8842a88b9f3c9881419e8a7b.1763725387.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 6 Feb 2026 20:38:13 +0530
X-Gm-Features: AZwV_QhSbcTXF1vOFniIsckdgf0WRvSvELPcT6UCzLuL9aGCZaYlbLnCwaCB9sE
Message-ID: <CACzX3AupFeAy0-pPsZ51ixd7qW++LYYjiKBZ3aK5Y2JDrB_JWw@mail.gmail.com>
Subject: Re: [RFC v2 05/11] block: add infra to handle dmabuf tokens
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12079-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.979];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anuj1072538@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 05447FF7BC
X-Rspamd-Action: no action

> +
> +       dma_fence_init(&fence->base, &blk_mq_dma_fence_ops, &fence->lock,
> +                       token->fence_ctx, atomic_inc_return(&token->fence_seq));
> +       spin_lock_init(&fence->lock);

nit lock should be initialized before handing its address to
dma_fence_init()

