Return-Path: <io-uring+bounces-13712-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id zhA7Fj+ALGrWRgQAu9opvQ
	(envelope-from <io-uring+bounces-13712-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 23:55:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DAE7F67C99D
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 23:55:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=MkAv5EGu;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13712-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13712-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4768C3010BC5
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 21:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54672376A14;
	Fri, 12 Jun 2026 21:55:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DF3385D8A
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 21:55:07 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781301309; cv=none; b=GswtvE4jsljbAFnBxRYy2SiJqmr+OKjEE+eXbUW/gGCk+AzjKef86cRseQT3zODsJV9BBuzOF3Pip3zZ6Ze+VKUqGsJSly189I6BcQfARMuRuMtCMKo43WRIB6K+mOvQ8h9aUGgP6Ch6hG57ILmD92VeCaSbtG79hOCQUROjHNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781301309; c=relaxed/simple;
	bh=YKKH6IByhzXOm3RA7lrP1uaBro3+5fqYBOx8ZscWUU4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WcF3Yvb3oIyz8r/5zQo/LU0aw3LViw5P/CMS/bb+OIKyiX9F18buqxvnHDX5ms756r43PuOAlsyRDvIH1ptzE/e50NSmbbBGn30yoHW6T9lSJF9I11Tr8gqLnyMQjl2cpmx0e1QdGBfsa2iaa4rCaDAQkVmYtw4KWDxykfTzQxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=MkAv5EGu; arc=none smtp.client-ip=209.85.210.54
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e6b5c374e5so1628700a34.0
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 14:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781301306; x=1781906106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yz/mJmsMPEFrnsTzcFyaU7YgwBZRj4KigdZHxGKDKNA=;
        b=MkAv5EGuY9TBwlSL2qMsqv3lGXscQvMoGpY1xmWnGhgydotsJqXAFaeGI7QC+iUlPp
         y7Cr7jNcjXB07d63i7eo6RglmPY5kqANHmz/a8CWXpGudOZeVEJOeItar29r2XPYmMeJ
         8WXY2+h0qOAuCGXQyBK+UsDSziNLt9xMVsjojQ3Ic2G6cQZNWB7o8bvCq0I+W9iDPjzD
         uFpNJeRKSC9GHaG/w1yndQUymHb2xSrnUIK9K4VHBpKje7zCDvjlHMC5pPI4oiDawI3c
         9bs4IAi5+GiHhXpzxB0pbwGqrZfmKLg0oQHMQz0ejiApqYYjq26iy/bxgL6/Pb7jsp7o
         82kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781301306; x=1781906106;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yz/mJmsMPEFrnsTzcFyaU7YgwBZRj4KigdZHxGKDKNA=;
        b=L33rPYpb9ECUgbvCiDh6m+hF4NRNTtOyEXtGqXq1zeQ+cfNtIYSKwji1EGR+0xQnnL
         pHc9z0QbZjEBOKoP2qzZC6PDOLUQ++OwlEicSpI1xkBPZkz96Ig5ga3sp8llh/08uHMP
         0MZZtUiXvce7WNf4SSHYKJOI3vJDpnV41tZ4PMyvJ9B2Pw81jmPU8utqUNAvCbmTHyk3
         +dlCge50jCqXxsdIJlCZ/tlubTN0fb5Cyj1fqsBiGcU7eyz3Cvbk8PqFM9MjdY9cD+0R
         huZR3khp8/qwNjgXiGf82ZEweFN6OFpLAxzN4J7Hv5zYYWa6I2XAzlfDwI1vc+KwfCLq
         +IFw==
X-Forwarded-Encrypted: i=1; AFNElJ8Yer2/Unu9gOA3jrEPNCVegP1cKaNmW1ibpbuTcrZVzSnHLOKENzqVPxHbdkwPixPuQeBmuyZXJg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp3OfQ6XTayE62V50MHf89opOfaWwb38eWlvCLhvs5/A5z7F3E
	r7zmsa9kzCsSCsr+h/T9vGKE/2yi0uV1W4xHktvGsPEkDsxMfer+OAxoimq6/lf5yxc=
X-Gm-Gg: Acq92OHpp4tl23eBtiRiGD3UYlZS9FZg1d4EahAXFG7xH0OSYQuO6ZdXdnOmVreB5kD
	V/tg5vBANhJfkr+vdiH/21WfSswZlK/kYiMNHUz6+ODUw6pb6uszYYRiI5fdJCjWbXPtSV1ChDJ
	ASP3EZDQRxMZp+arqfAnXpYv9NI3ZHRoHfb0PYsIN6NH0JEZOVCR/GUI6tc7lEcxMGS4q6xd7CY
	scsXZ2jUOkBPwDlbZuaJIHL9DPtKxjdx+6g5tbCpP4mADVv3N7K8t5SrmcxuCBrJKphKMbaW+XG
	2Z9PHThLs0twGDjygKRGvihJr2aSsRjurXNwDjbdEgssXUZU5YvIFwVvNoaadSjS4SFysd1axEu
	QYWlrPzdSPBoCfUIfX8wIwLMq6j23r3N/fVBDKHA1j0yJHXRCp96nGTjJy0f4oU7wWRs4oJipww
	BwjjlOtflWHSPrzAcqk0CHxAn13meyNoVH5x6MZxcJatXuZNC/OW0vNqctZmgPyoxor+oU0hoI+
	XJ3
X-Received: by 2002:a05:6808:11c3:b0:479:eb0e:670a with SMTP id 5614622812f47-4872dfb8841mr2534707b6e.29.1781301306235;
        Fri, 12 Jun 2026 14:55:06 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-487311aee6fsm1702372b6e.0.2026.06.12.14.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 14:55:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, csander@purestorage.com, io-uring@vger.kernel.org
In-Reply-To: <20260612184840.4058966-1-joannelkoong@gmail.com>
References: <20260612184840.4058966-1-joannelkoong@gmail.com>
Subject: Re: [PATCH v7 0/4] io_uring: extend bvec registration
Message-Id: <178130130495.1842502.8108846477682868015.b4-ty@b4>
Date: Fri, 12 Jun 2026 15:55:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:joannelkoong@gmail.com,m:miklos@szeredi.hu,m:csander@purestorage.com,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13712-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DAE7F67C99D


On Fri, 12 Jun 2026 11:48:36 -0700, Joanne Koong wrote:
> No changes from v6 except rebasing to the top of Jens's for-next tree.
> 
> This series refactors and extends the io_uring registered buffers
> infrastructure to allow external subsystems to register pre-existing bvec
> arrays directly.
> 
> The motivation for the patches in this series is to make fuse zero-copy
> possible. The fuse zero-copy work is in [1].
> 
> [...]

Applied, thanks!

[1/4] io_uring/rsrc: rename io_buffer_register_bvec()/io_buffer_unregister_bvec()
      commit: 24963b8a6b09876b4361c96ab2b12541372c1917
[2/4] io_uring/rsrc: split io_buffer_register_request() logic
      commit: 8219b09eb4c21f6ff1e32fafe4290caaacfa44fc
[3/4] io_uring/rsrc: add io_buffer_register_bvec()
      commit: 0ebfe2954f408ec1e42502f3fe4352c2bf197957
[4/4] io_uring/rsrc: rename and export IO_IMU_DEST / IO_IMU_SOURCE
      commit: e2a9be1b1774d0f27423d291f855c17d8b0c91db

Best regards,
-- 
Jens Axboe




