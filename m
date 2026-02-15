Return-Path: <io-uring+bounces-12208-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id TCBAKCEckWlRfQEAu9opvQ
	(envelope-from <io-uring+bounces-12208-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 02:06:41 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D426913DD94
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 02:06:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2D2D93015C9F
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 01:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB301A8F84;
	Sun, 15 Feb 2026 01:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vb+Jzbmg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F13199FD3
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 01:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771117598; cv=none; b=ssfdmb9NviMi7jxw9B85iFuDRwa5WE05szsdcXGNiZIQ3d4cP7+CfaMX7HD92W9/8Zm3tKYwTUXM11qhnr1wfDRvE4zGbWp7z37eUH+tefClqlX4GLo1IwEAu4MO+J1tB5UDY160gkro5rOYeSmZ1mfCj2+86GBEczeICmym19Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771117598; c=relaxed/simple;
	bh=lu0RBEWKjIEJnmsOLIdWPF/JVFWKvY5L4v0aQ1RN8AM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Gr9yJcELUs6jT5z/uxCWmjz2+WlPURNzVYrws/h0vfMViZy11pl4mb1+YzxE+fGFCbCuzlRP2PU5OCWn1ylr3PI3nLCmJkRK1BvcMch3RdcBbjeTTMtR06j5aYX3JvDEkuW8owpw3I7/+Be1HAZJn1u0MlpBo74lKVROU2Nj7u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vb+Jzbmg; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-4042fe53946so705255fac.3
        for <io-uring@vger.kernel.org>; Sat, 14 Feb 2026 17:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771117595; x=1771722395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJ/Afk3bypA9GyZrFiet2Pfeppld0QGw+7P47/14WNc=;
        b=vb+JzbmgcUi/IDTlfJ4Oz8ReIaf6eNFQvff+4wyIFvQ9343++klSEx8tZMthizG1Em
         pTljjYmDxU0yJRQwfq5+lwTyqz677VuZ7bn0QnuhV7n20DKng55qGsAXl+hwhMPWAadK
         g7nidMk8dC4B0DP8UO5VmtRM4aa9mxZJt/58UtFRypfLaxkv4M5coFqSB3o3mDkJeQ27
         zN57RbOWaguQSU11vkVvJI08j2gTcRfgajb5ACumMPvOnpLCPkVCIH9Km9F/DpYPKjPo
         k8fmNXP9SeGTYtRU27jyXD1/WHe/fDO1JXNjlyEYis2CXnYQxY1hVrMbpgiXyFSvY0yW
         sdvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771117595; x=1771722395;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VJ/Afk3bypA9GyZrFiet2Pfeppld0QGw+7P47/14WNc=;
        b=uVaOGXPB4SJSJ1zUUFQbOvQCe4eOjcMJ6NjUr/l+c7gNDEV5s+CccsZ5umLA4Wp2mU
         WQdjdx/GnP/Lmksh420OCLEg681+WByI7eABnD/DbcIXCWz1LbbXE+C235Xg3vV38oBT
         uNG+hMpc9T6nEJQEquXdMwClq7yREmPOvPJRti4OIunjP1hJb846/6dcwV0SuWxPZOx/
         d6SG5wjaS4H51J/Ztmvqy6nfQXltOeR0YVoB3MaWVx/qk6TjRO69uGVTT7AqkckbfIKs
         NP3Nz4wJf7isHOdeBU+j3O8vOdHlS7cZ0CoJ4jvIATl2aq/pftO+n38ZzJ8WpfiuKYGw
         lDiA==
X-Gm-Message-State: AOJu0YyCqyYflOAUf4LdDrCHC5f9EJAJ2BlJ2V9clZkavgG4XJra96JE
	nWFzBt1MKasxJ7tkwFyT+UxQcxuHX9BiiHgbZGKDCnqqH9VM23YByIxVNZeGVjrTOdI=
X-Gm-Gg: AZuq6aK5x+WTGIrDvoX/eUG8lqgcwI/cwKLtkusxIHT1/vu3N1QvIi/n6IxUHIE6I8O
	1pun5OJllIJ4k9D8EKrpi/yCHlkZ15UXFdXroQF7Eezs1L5/BIIS1McbXGYYtALDUlcJVTeWRGd
	NMkOmhBCdMuefxPHSf4COnT0j0K104DCQutIXj8p2S1XgPLIzC3zMMGS/10IqrI1zqFHNTvoUqt
	q6s+3Z9eYOV38QIaH92qxOkOi02f/pFyN5eI262iNfSVwTg+wbPa2owU+gkMRKfsHXhJXH3Ojcr
	adXW0GmXKMJeqw7FI53GBLMSuYJiWH2U03d21VE51pAs44AtEGR9LEwBqqV2dban4JoC43daWzq
	aWNZZ2TlixSg+j/bDDvsOg7ghVTYdSR57cLO6NY/aVuUAtJb00sPXI4D8/1gpFd4TUCJtEoInAV
	PDPQ9Jh9YtsSkvAO60h4PposcRmTmPSoZO35DB5p57MbSidepvoB+G/azFZDhP+4zHymJrxPgSI
	/Qr
X-Received: by 2002:a05:6870:84c7:b0:404:4157:3dc9 with SMTP id 586e51a60fabf-40f0d9581e5mr2219778fac.42.1771117595194;
        Sat, 14 Feb 2026 17:06:35 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf1e858bsm10583097fac.19.2026.02.14.17.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 17:06:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <de01fd4111d3f89ddbddb70bdd427c741f0cda46.1771091730.git.asml.silence@gmail.com>
References: <de01fd4111d3f89ddbddb70bdd427c741f0cda46.1771091730.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix sgtable leak on mapping
 failures
Message-Id: <177111759401.436334.18359471040201613553.b4-ty@kernel.dk>
Date: Sat, 14 Feb 2026 18:06:34 -0700
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
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12208-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: D426913DD94
X-Rspamd-Action: no action


On Sat, 14 Feb 2026 22:19:32 +0000, Pavel Begunkov wrote:
> In an unlikely case when io_populate_area_dma() fails, which could only
> happen on a PAGE_POOL_32BIT_ARCH_WITH_64BIT_DMA machine,
> io_zcrx_map_area() will have an initialised and not freed table. It was
> supposed to be cleaned up in the error path, but !is_mapped prevents
> that.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring/zcrx: fix sgtable leak on mapping failures
      commit: a983aae397767e9da931128ff2b5bf9066513ce3

Best regards,
-- 
Jens Axboe




