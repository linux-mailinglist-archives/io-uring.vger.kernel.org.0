Return-Path: <io-uring+bounces-12888-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2CdsIPeFyWndygUAu9opvQ
	(envelope-from <io-uring+bounces-12888-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 22:05:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 22658353ECA
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 22:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5FA973021E79
	for <lists+io-uring@lfdr.de>; Sun, 29 Mar 2026 20:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D14F386C23;
	Sun, 29 Mar 2026 20:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="q9UiSaBG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B5F2E040E
	for <io-uring@vger.kernel.org>; Sun, 29 Mar 2026 20:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774814663; cv=none; b=Mxft2hmRfEnTFSSsnUl/oIIOaxYs+wY7NUGz9SzewDt7hhegx+U+2hJCEDhve4/DwecQH3FnjfPmZvfyCpsVUEPl4IraOa5R68apjzs/c748ahi/Oa1GIW5jeb9Yw5ADvwwSIU92brI7qv5b+3d3CiJ9hbC5Wr61CU8gTAeqLYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774814663; c=relaxed/simple;
	bh=T0akMagK3D7z1MLS5n2zGdohODkuFj96nAYcyQXQIpQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Eg6uHz7Cogzo1gyCa7CPQ6wYKW+tU2+WaCaiD4ybaDcHsacrF4rezTSGyeoVwevDN4uwt+cTAbCdy7ioaYcplngkvnmfmToOHcIcrhPoMZQZrAgNC4NwJdqSO+6xyYCZ1DfSRo6bwEXURERPtwlSYzXZ4+63wDomqs8jy46letY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=q9UiSaBG; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-464bc03efd8so2049979b6e.2
        for <io-uring@vger.kernel.org>; Sun, 29 Mar 2026 13:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774814661; x=1775419461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vyKrK1JH7T40YiaTs6PnOEBlN3y2YpN+Ui0ZTaUDQYg=;
        b=q9UiSaBGyn7gLnXJ6TDFlT/1xgR/QsR2uZYS489nFqJNG/y2eJwTdRzOR47a4c0DYg
         s5nhM2RU0vOrD9AfaqCLs1BhlEqc+H/nQG1/i6m+EW65sKxiDAF0Dqc9ZnjDhWPK559U
         zAo4HJm2nCigxVBmvWOtoBYoxcPxOi+ARz0At20iZsFOpA81YOITX9jBjGAZIu0c4/zw
         BXrtrsohgvxm1Z7gGFwN1xuJIenMxt1xvsCKD5ULIOLFomgrh/hMp0ZcU2srJI3dD6Vp
         GWIbKNBp8n3QLDaOgRg1bZL1BVbRJnwS5lpOEMG2S+dCe9l+UCJB+uJYbigyMMWoZWRY
         tShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774814661; x=1775419461;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vyKrK1JH7T40YiaTs6PnOEBlN3y2YpN+Ui0ZTaUDQYg=;
        b=jziuO8DD8xjkv3l9sVR72gISiHQxG22MdeuYS2mEJLA6hKa5QAnPoNRNgACTQ9G/KE
         zgk0UOCpZ8/MIBd8/TRobEjnT50TFqmAZ1EutjXQdldtQeBxDHiE1ZXP5F++BgPPW6kX
         vVR+qcNqDgFQf/mUVkXkFGpqYu6sf/MtmYPmrYkIlAeWrplO5vbeXFdqZMfcSeaTAOPa
         n1VRtJfL/3ipYD7HcS++HFPTCEGsLYKLo3MaT5OqV7k4XUf9rn6nxbEdvFxO/u0GPgYa
         wBp+vkpouTYnC6Z0UGqd28QdMLRFbeb8+QduZKGnKICDAd2VZHu0lQ7y/h55fTxmLeCo
         lvGw==
X-Forwarded-Encrypted: i=1; AJvYcCXXscrIcNmCLOVyk6R/SENz4OY1rzfrLvmQCmzjxB/FdUJZI5BbTMqkY4GRK+6MRCvlumZoTcMSvA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxllL88flv3lD/97FXbclSQj3wm3JuqlWjMKyFqTIYjSaAgLX3u
	DpWpUuWNDyqhAjky9gC1PmoZwgyO+CWVaERRzmBqfDDymtN5cPwTaQ+0YTHmI02V+dEo7G0fFtf
	ISXMR
X-Gm-Gg: ATEYQzxmIHLo1U5Yc7Z0mff3bapWWy5MhOgiK6lgkigna6xn9FLge71qizxDzPu7mL2
	VkR15YTDkpun8feDYsCh82rCRIxliLGi6CgvWu78Vi/m0l1RmqRL6nM5/xivQD3f1RJYBsDNBkI
	irFYF6qrm1LzPL4HyAanPSFoVPs4AlYSstahqRIVBMLk5VZ3Y+ShNLidVhUCy7BeBUChELmt8O6
	JKStzjaPoLhTH+uPFPw7oyERo2fqbxkinx1cq5DwrKjOehDN7bVQt7xAOZLL+m4qnzFqnu4Qekj
	/3rGDHu0UzNwsT8mAkRTEzfKLjqKYl2g2GvqpyaVII3jka51dEBVHu7Lg/lFY5T914gpDvLvR48
	M0Et+PH9U5KdhkQcIr0UWkBrrhqn4Vrl67Igs8OWZi0h3UKT82HfqmZ+laSkTx+bvEedf6HeVWb
	bW06mkeYxh+jbr042MkA173pwkC4XqoEooyrm9Yp05j5v/OgP8LchWAE8W86syy2zPWUuLF4Z0r
	oUb
X-Received: by 2002:a05:6808:11cf:b0:467:baa:ed5c with SMTP id 5614622812f47-46a8a3c8086mr4942052b6e.12.1774814661039;
        Sun, 29 Mar 2026 13:04:21 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46aa03a9179sm3076174b6e.14.2026.03.29.13.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 13:04:20 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Qi Tang <tpluszz77@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>, 
 Caleb Sander Mateos <csander@purestorage.com>, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260329164936.240871-1-tpluszz77@gmail.com>
References: <20260329164936.240871-1-tpluszz77@gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: reject zero-length fixed buffer import
Message-Id: <177481465974.564893.7090796228655852219.b4-ty@b4>
Date: Sun, 29 Mar 2026 14:04:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.1
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12888-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 22658353ECA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Mon, 30 Mar 2026 00:49:36 +0800, Qi Tang wrote:
> validate_fixed_range() admits buf_addr at the exact end of the
> registered region when len is zero, because the check uses strict
> greater-than (buf_end > imu->ubuf + imu->len).  io_import_fixed()
> then computes offset == imu->len, which causes the bvec skip logic
> to advance past the last bio_vec entry and read bv_offset from
> out-of-bounds slab memory.
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: reject zero-length fixed buffer import
      commit: 111a12b422a8cfa93deabaef26fec48237163214

Best regards,
-- 
Jens Axboe




