Return-Path: <io-uring+bounces-13498-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id TtylIKc+E2oJ9gYAu9opvQ
	(envelope-from <io-uring+bounces-13498-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 20:08:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE4145C35AE
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 20:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D1E83007374
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2026 18:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359302F25F5;
	Sun, 24 May 2026 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="O8ej2CsF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E946674BE1
	for <io-uring@vger.kernel.org>; Sun, 24 May 2026 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779646115; cv=none; b=KQgVApct1SttqcmlkWgyT8Z7n/BlPB0UMbwRraMRzkdZXJlEW93DrxFkn1U9cc76zQhKzTgZiaDz0ZnnK7zvKjhmNjJ9sdh7Ei0aiYA7GPjEHK7ANtEtaiELI528hXi37fr2Q3Ffzgs1sn/wybpsWXaF4MQSWISrJSdZHFezCeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779646115; c=relaxed/simple;
	bh=sixVOBai2G511M/aKT+7XV1bRxqMVuqtdqmSyeHssxM=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=eV/MMQ2jhdrfraZ1QLz4OZB/6riuK4WqJQxk79KBEsv1B7Isrgs3ShgrtAtr7qFln7di+31h4gbTDp0hFse7nbC/jKPwx7gkbfQzr7ELYMSSIls+SgUxUhthrmrkrBA9esa8BPR6QLb3fqkylNP7DnsI2lfiYIUMnoe50cE/aXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=O8ej2CsF; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e61d3fb1c6so538914a34.3
        for <io-uring@vger.kernel.org>; Sun, 24 May 2026 11:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779646111; x=1780250911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mdnr30vn3OUjkQmyBYEWBbbA8SEc1JM99uXDV5y5BgM=;
        b=O8ej2CsFWpNUUzYwdmzUb5YbM0o+sWWLDHcEbWkQxxxbr5K5XRwfVEuIA8vGV7n2p1
         2IpWWcpfVw4HmrBVMd8wiIg4bwhEParMrHTAVW/SeNAtpszDaZo5+bDeF6rBgCAw1xVV
         Z2+CMEHKrkADBacsIAnoZIyqajnT5GoFNJ/1FzKXxhbh1q4F8p4z5IsGazDLzh2WwetU
         5ITV1dJ7XOOAwcGBeLVlyN+uW+OdHxamwBNDNHAgsVR+AeSRqmUKRKYpaDMPDCHotsuZ
         ej/NpSMSWjQzflfcZmFnqEWmCX3j6GmiW5pTQPsh+7jPX6nujqb3iSeSIfXJlD24eR0J
         GQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779646111; x=1780250911;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Mdnr30vn3OUjkQmyBYEWBbbA8SEc1JM99uXDV5y5BgM=;
        b=kOrXaZTzLBdlLLLH4mvTjzecwN/fILtVzVyfN3gzqVqXe4adT/RzDE98e0HxARh3ZR
         A2GcyC1vcDwJwtM7CD1awgmMKZ8R7uI+kliIMP8j0k6+bp6crLXT9L2ChVg8Ap0oPoM2
         mO7cLrmbfkyGBL3bbYFef4K4v+btN1ZcvK+fjN/l6Bc1M7Bd37A42rf1PtygEkF5H6IF
         cKkx35spoM9TQ3t1EKrLwzLMMOyM4mWxTPbXRQ/zQueHD2R9ZuxvHKAcg2m3W9BkuiUr
         bnDs48Ur9iH2N3jcsIE+JGpDAGYjrSr5PMcPAe3/sJXB/Ftej84aMJxVVeQKD8hbhWXL
         fRnA==
X-Gm-Message-State: AOJu0YyqqpESxoVA5ZFOCca7ek4m4Am6sZuq6bpbeA0SJH059j2bmQSS
	6eHxykAdp9OW3s6kDxQE/Yqx55sskpGv4IHYIfbs/rggR5OfyzBkW94qWpkTDeyz2A1dGDmzIZ6
	fvcuF
X-Gm-Gg: Acq92OGSwWIi3xnbC0DaerNpEC+4qBAlupCq0AXVUkw/8GbCujIuqP3cKKmqcPUcFbh
	wxJQo+7Mh7hIAKXbjfOqzvk5f1W/9u/czjNGL+Am5KhxFDllda1hB7410AY4Tqu77hUvTbTjZsJ
	rYEab8NU5Hqf5Fke+z7aUM0q6XVO/EfHV3xmgd6LtQSQYYhkbE/mVwnSZNhz0MwBrR/c7zMy4TA
	3xsPIKvh7lH+iD6ij7spTb+tzccMaLPGLjPw8mOS/5iOHILpLyO8+p/zRnJl4OS/58atsM8QLRI
	FmwOy0aGKDOysttcIvVmEz4MkAa2sGNA3hCmjVTLoAXZ8pMk48mF2AQJU4gmQ8+ZyapEMPe/LHv
	7OoPVCxGGXTqqYQ9JX6nCXbOQX3zjIk1Jod0dDeO818GZRZvIzKzWnUdEl2oOX0rbd4ZbjOA8yx
	vhVo9nlFOIvS/IyDemN2Ea+pVadFebPjP+0lO4Nz/2v+6SlXAQpikv8xik2DL+2Ll8CKMXsEqPd
	NXg
X-Received: by 2002:a05:6830:2b08:b0:7dc:d0e3:5bdd with SMTP id 46e09a7af769-7e5ff02a2cbmr8499079a34.19.1779646111569;
        Sun, 24 May 2026 11:08:31 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6065e7cddsm6044344a34.18.2026.05.24.11.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 11:08:30 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Lim HyeonJun <shja0831@gmail.com>
In-Reply-To: <20260524110853.115634-1-shja0831@gmail.com>
References: <20260524110853.115634-1-shja0831@gmail.com>
Subject: Re: [PATCH] io_uring/tctx: set ->io_uring before publishing the
 tctx node
Message-Id: <177964610881.307699.9664695678589599397.b4-ty@b4>
Date: Sun, 24 May 2026 12:08:28 -0600
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
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13498-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: BE4145C35AE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Sun, 24 May 2026 20:08:53 +0900, Lim HyeonJun wrote:
> io_register_iowq_max_workers() walks ctx->tctx_list under ctx->tctx_lock
> and dereferences each node's task->io_uring without a NULL check:
> 
> 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
> 		tctx = node->task->io_uring;
> 		if (WARN_ON_ONCE(!tctx->io_wq))
> 			continue;
> 		...
> 	}
> 
> [...]

Applied, thanks!

[1/1] io_uring/tctx: set ->io_uring before publishing the tctx node
      commit: a88c02915d9c6160cfc7ab1b26ed64b2993e2b94

Best regards,
-- 
Jens Axboe




