Return-Path: <io-uring+bounces-12932-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6C6iCk9uzmkCnwYAu9opvQ
	(envelope-from <io-uring+bounces-12932-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 15:25:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 79BF6389AA6
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 15:25:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7303530D7BBC
	for <lists+io-uring@lfdr.de>; Thu,  2 Apr 2026 13:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFC0F3E5EC4;
	Thu,  2 Apr 2026 13:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sslKwR57"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EE43E51E4
	for <io-uring@vger.kernel.org>; Thu,  2 Apr 2026 13:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775135375; cv=none; b=AAZXqLfrxP+urm+TPBbTSNkvnsBxRjX5Q4nUeY726zByz85B0dvDMMmA3+5MiITVusuxlO3Lfx7lmfEGywL8TS5mEZzdKTZFgw4cyqRbVzGuZkUhsEs32h8qlVRRGU45hQKF9x6tjNBVzIeBjs87vl9Bi3AyTABqVprwpxyL4v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775135375; c=relaxed/simple;
	bh=Px0ghXbUvx0LvXeD8IgHqD/Pf6/I/WC/gZEgwiDvIjY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=a30R7tT+HcZsCyvhdHMefca7SyNIFo9RheJkoSOmMnOc2gfOIO/+cAQF4hEhx+lzilHmutg0nwUc5Vjc+jSUMvKR3hW4C5K7bowp3TKyslwI+soYWJd5laXXM1PwGV4EY8c5EkxoV9wgaKAYtWThKjSJXpYePSzVgY9F+Bx2Wwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sslKwR57; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-466f1c3c627so550325b6e.1
        for <io-uring@vger.kernel.org>; Thu, 02 Apr 2026 06:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1775135370; x=1775740170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agqm21nZ6w1XXa2R4mkj2PrYHX444TilBifHSbyAJfY=;
        b=sslKwR57FwxeJRdzeyXR/Xm7HG8iCCt6Q7wW7Ub7TpgmxP9ZuO2jklmDaPJ+xhb3N1
         hmbuc2r5wWMEh7N+bEd+w8DDfCGnbJcz4RWnihSA0b2sbHZ3876RZycClRQcpvTI+Hld
         Ykx12NNg0azJJly2llT+FCY3i8iDwY6VPgh7GpQRu4dV6n6kSAwyi/I5p5JzUT+aH1wJ
         BEZbBpvWqJS6L7DjdRO3gvfBsvt1WWqpnSzl4zvrQq8tHzHTasBDVZrccjkxoZIxg/ky
         DyF1mCQsLe6MA5+C3JPFY1kozmR1Ypq2H1sfVFmUHlLivrL6B47NMq4+IxAMy8z/y0X6
         HF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775135370; x=1775740170;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=agqm21nZ6w1XXa2R4mkj2PrYHX444TilBifHSbyAJfY=;
        b=muC5QN/PWDb0RfRwLCQdjCIelFixwGKY8EMzr/s45QRZGpx1qtm/wZFGXNugkznLXa
         QVAjhszBAzOouylhNYboSV+fcJItDtNJq8zs4cUQ4INou4dC9oIAF8zzeauUFZ9pE9C6
         MOD1bbMs0osIK9ZD4N/aa9sXPMtpA7P9A5cNT0NTrSSm9NTttnoU5a2vgKmm+fwgKlgl
         1G+DyUW1mpIcmxCM6IVGjcNUGhryuJbgrw21n41QCGNUJKpeDHAic4Lb3LUCHnYkBV3f
         43HJSOU3D6WsL1+6vdtQcZU99gak/9SFfJaYSPSSoUHL6trZSwItfZg7br8laYjpbknq
         dNFw==
X-Gm-Message-State: AOJu0YzsfhUPoxCl5sRS0CHZjgpwDzMM8IQ8S2qlxep/my3uQTcUIizH
	SpVOZKtPsk6EhMPp9PZGMgGOw2ig1J/GKtUOS1T1n+8yX4w5j8XX5m3OsxrkjxVmC+mssS575z1
	Kxp4rEaY=
X-Gm-Gg: ATEYQzxUccAaMQ1xYSTGLwhCLXW+nJ25cF75/AwRJkuDAZxiigFgwWYAFYbMii0KiEq
	xP3YjdSfHPe3Cha2KRHCatpAnRSaxeNtyb/odIWe+wH0kya25GHG1MG7UvdU+q4ZolTjG6DHG64
	/+YkE0Z1qhz6t8tVP18Sq1OyKiNs/Hmu4ywvDIn799LgvErvycADaJw+eZWq17ZPLyR+qEsTqmA
	Rh/PJc57LOSCcPWLCQiaqWFrET3F9siQvOPkNB4shW1B9SzT6Icjz+VGD5XnJ6PGz6dQhrLeJpn
	g7T3WyNWnQQj5gpc6Tq7SmWc1m1ErVwvYKuIpbOS3nOaaBMDJopZwnjT1NJTWOwVEkdtNqczGi0
	9TUiAaWpDYIrStH0LKJ5cB6Q1ZUB9ZM+Wxjpzpm9qzzZoCaNeajbB5KpnSdykFpcF8+btGEqH6d
	xBXDAVt3aA4/qRWugkNcEGuCrOmMjtdeBOz0srimdmGcFkQ70M3PsGBkvQTlKqHDZatIiWenx16
	dgC
X-Received: by 2002:a05:6808:6703:b0:45e:f0ef:382c with SMTP id 5614622812f47-46ae017bdbdmr3698329b6e.44.1775135369989;
        Thu, 02 Apr 2026 06:09:29 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46d9387a763sm1593841b6e.18.2026.04.02.06.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 06:09:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20260402014952.260414-1-yangxiuwei@kylinos.cn>
References: <20260402014952.260414-1-yangxiuwei@kylinos.cn>
Subject: Re: [PATCH v2] io_uring/timeout: use 'ctx' consistently
Message-Id: <177513536890.175771.11901387084315808569.b4-ty@b4>
Date: Thu, 02 Apr 2026 07:09:28 -0600
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
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12932-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 79BF6389AA6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Thu, 02 Apr 2026 09:49:52 +0800, Yang Xiuwei wrote:
> There's already a local ctx variable, yet cq_timeouts accounting uses
> req->ctx. Use ctx consistently.

Applied, thanks!

[1/1] io_uring/timeout: use 'ctx' consistently
      commit: f847bf6d29304087f94ef4b4a8646f69d96945f9

Best regards,
-- 
Jens Axboe




