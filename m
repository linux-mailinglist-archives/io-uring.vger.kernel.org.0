Return-Path: <io-uring+bounces-13612-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ATA6JVOxImrscAEAu9opvQ
	(envelope-from <io-uring+bounces-13612-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 05 Jun 2026 13:21:55 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id ED818647AE5
	for <lists+io-uring@lfdr.de>; Fri, 05 Jun 2026 13:21:54 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=r3yGxRCx;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13612-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13612-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9A182302DE1C
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2026 11:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A61D407CCD;
	Fri,  5 Jun 2026 11:21:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958D43D8137
	for <io-uring@vger.kernel.org>; Fri,  5 Jun 2026 11:21:37 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780658499; cv=none; b=O1bBmqaATKgM4IOKCliqivPaF4rCD74NaS7JRQJ1Y6ezkh98Wl0kgXXSMhciQL5iubD+83efLwQj65k8XZvkGCxLi4V1hb8Ni0D7WUpCH981lAkyv7seQt4YKOOPZ8+8MnSz+x2xgAyNLOBxivrkgQ+ua2X3XuPZPvuZcCadNxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780658499; c=relaxed/simple;
	bh=hgqRpZbOUEZXd4Qi4NwddlSDDWqe/FPbm3DOSkVfurw=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=LOkBaVapJvi5R+MbMOPxGiHUA7WPZzcb6igSWPsEmg8K3FitPUIGeNxrCLREnfKfc6lrYWcXnNwytmYf60PzLbJ9fqEKgE/4VpVLt1SHp2xpm8KLl9Un4EItW9jpz74EiakW2BOWABbwML0t5dqBm+lthL7717PXKBXzhnGjdPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=r3yGxRCx; arc=none smtp.client-ip=209.85.167.177
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-486304fa184so1419090b6e.1
        for <io-uring@vger.kernel.org>; Fri, 05 Jun 2026 04:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780658496; x=1781263296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SNa/02L3ctbj2gkZFvzjHgndeIXLqv08D8Y5YnC2aOQ=;
        b=r3yGxRCxwSkM6Uc0BtD7nf+a3mKL4S3+OOUuaYoswqpL04vrjLIH2YG49mrseBEKZe
         JSBZY7k0eIEkPWF7snhy/Z90EbVnfKzeSozlmsy0TkKDUCyOmFd4M/WyxNf8pU+/z1ul
         gpqIvdaZfc6tnWtxrGZCQdNCN1LCVyRYoI3wcEn3xBdpV79al4Oq7uhDrqyEBKAQYfAD
         /UdDZpAHdDr7MjbaPrh5Mn4JQzjQVxNHU8XaNUi8AO00BdXAdXtVZJXHIwEL/gqEAi3h
         0SzKPEX273P1uoDX5VInZYq8KXFNILe6kfousEBe26stWd90qT+Y8PNeqz6mGBRcn5ug
         FCoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780658496; x=1781263296;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SNa/02L3ctbj2gkZFvzjHgndeIXLqv08D8Y5YnC2aOQ=;
        b=UEX4JqELHb0DnkCsMCbxSJXQJTtGaKP6RUB42WJHUwlhKCAu9A0Wf/aj7PCRkad7w5
         iKZIwOFWa18HdSlc/MoIKjy+hiMFVINWq86TVEc5y9DfpUVOTK21MsRafW+MByoZaX/R
         BPbskrBUMA0mGvMeo6reTePLiw9FDoqIodrTXfNy5ZL59Yj/y7wkSkjhY3A9DgSNqm7g
         0RTVko+ldfTZm+dyDNudIgJUsJEhYiWnjOgek+fuECbKdJxqsF7ESVxrMgKrHyDRkEO/
         QtdZDGrCleUccO2AKjqonwlDY97aL8pVlgut2THehHf7p1QJqMfeaHi24eaRTUWEi/Jg
         3Bag==
X-Gm-Message-State: AOJu0YwH0DL1T2zTcrgI+QMVX1ar1AhUMqFTziXgxzoZvkakwkcz6Rrq
	riDck6en2bWouVNBytFYHNsi1Dd8A1wX8xuespai7OEmfi3+mCIif2pHb/yeZdiJBMs=
X-Gm-Gg: Acq92OFuvGx0p3Nmc5heOemMueHT7liPn6vAoTGFnCXyRIkVjfq6kw1cf0bOVC0TsKt
	Kpl+YjNqPZGszx1UY+gWjNyxNzAvbBQhgA057DD24dsa1VYTpdZZoTIYOW4Va9G8VbnZ5vAeH3b
	Qxtfc22D18TdvMpzEguN/Bc2eAgjgNuPjtxma613IG73u2Gup6zJQUjZ9cF0Vtkqic1nTA9vZKy
	JYPAc9YCAtb2KPtGA2+taUSyFVM6e7FBTja7ZDQzT1v+i7svJBYkxWjhvOj8ZKak7mXt9mCiWem
	KUV+3ionmnZYZRyTPYEg4R+NkAtKd4cw/6rAt5Rd9HkQnemU3bmV+RcVZ7bcJlY14lELxwj9qen
	xNEqnY4IKohSOt7+untOTNKFLr58uk5OSiBSL16NxBQA9wYZ+Z6Q1KOhx76RuoVFNjPOyC+uL6H
	LxZ+OqD3G9rQis5bi+5BqpStZapi42oalEljXFuqq7FXDWygI5ngDtwk2WJ14iI0eWAjyOxTF/b
	ihx4vFwy7PQp6E=
X-Received: by 2002:a05:6808:1b0e:b0:479:e7c7:dc76 with SMTP id 5614622812f47-4868df5a0camr1715349b6e.26.1780658496070;
        Fri, 05 Jun 2026 04:21:36 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4865b760799sm6634155b6e.7.2026.06.05.04.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 04:21:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, 
 =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <cleger@meta.com>
In-Reply-To: <20260604160715.2482972-1-cleger@meta.com>
References: <20260604160715.2482972-1-cleger@meta.com>
Subject: Re: [PATCH] io_uring/net: inherit IORING_CQE_F_BUF_MORE across
 bundle recv retries
Message-Id: <178065849466.805549.13653501857626235057.b4-ty@b4>
Date: Fri, 05 Jun 2026 05:21:34 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.15.2
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:cleger@meta.com,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13612-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: ED818647AE5


On Thu, 04 Jun 2026 09:07:13 -0700, Clément Léger wrote:
> When a bundle recv retries inside io_recv_finish(), the merge logic
> OR the saved cflags from the previous iteration with the cflags
> returned by the new iteration:
>   cflags = req->cqe.flags | (cflags & CQE_F_MASK);
> 
> Bits listed in CQE_F_MASK are inherited from the new iteration, and
> all other bits (notably IORING_CQE_F_BUFFER and the buffer ID) come
> from the saved cflags. Before this change CQE_F_MASK covered only
> IORING_CQE_F_SOCK_NONEMPTY and IORING_CQE_F_MORE.
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: inherit IORING_CQE_F_BUF_MORE across bundle recv retries
      commit: ed46f39c47eb5530a9c161481a2080d3a869cfaf

Best regards,
-- 
Jens Axboe




