Return-Path: <io-uring+bounces-13756-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ISP2K9CzMWpNpQUAu9opvQ
	(envelope-from <io-uring+bounces-13756-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 22:36:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 537A4695410
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 22:36:32 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=nE539p1K;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13756-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13756-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4126D31C5FEA
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 20:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED24137F75D;
	Tue, 16 Jun 2026 20:36:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C883932DF
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 20:36:07 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781642169; cv=none; b=IFlsUQLpmx7QNP9nb5i0ppGbhdz2IiEMpEIuzjReD71fj3JwXAdmVJydw3x61t2ZSIfga7vna5tamc4bsDk1JMOwMfrXPp8y6dFQxXyJE/dXRRnoxlb/niJTYUooBATp0N3lj+XvRnlWOi2k0Qe/KaYdHpYhJ1I+R96SRtHobZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781642169; c=relaxed/simple;
	bh=mxMKe0jgsxOJM/p9h7RtsXKKJZ4vpt/rgkLudw2LN4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MhAuue1ybAdUb2l+K7IFMcTafKa67vljl1H+LlsMTVJtKk6SMJunrEr8q7iJwrwpjfaPvDtoSrg+e3/ntEd0kWH8p5/hWvSl7NNOpW3ZKMhNBllxCpoDq+sxYFmlZk0Fi/Zel1HjYsRb8CP5k9pL2RvCltNme1ec+nFRVRtEvAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=nE539p1K; arc=none smtp.client-ip=209.85.210.46
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e6d37b7098so5132378a34.0
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 13:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781642166; x=1782246966; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a2o1XTR7VeYkIhqu4UtENSoBuqpZfEyKyn3oza9yC94=;
        b=nE539p1KlGa15vI841yfbah1dtZVYsMGZS7l7VyiOhXxdDuGdyeaLXrJ+lsI9GgIzC
         hlN8xT7CDmPbxdA/hSHjsO1/rKq6mcNqDyrfSN9ZmYIcHrjBw7GbBVTJNWXb24JN3JkM
         fZbeLNHsNTvmWZRBOy8G4RtvskHoFDlO8onGcHWflTJbtbjj2ZlNt2hoMK60xMvTTGUf
         vG0549szZZKtEC8GVJS55dj8HqICEznt81kyxO9ao8QjVV7tpQedAU9/c7ysvjbgSB2x
         uPO6GJUsZiko8ofHKNlqI1JpUbGk7NL6TiT+JXoLst/0/bjdlF+WsmCWiVR4ZpDyMC5V
         s75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781642166; x=1782246966;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a2o1XTR7VeYkIhqu4UtENSoBuqpZfEyKyn3oza9yC94=;
        b=UGvCmJ0rySy1Bz/wwfAhnnG33DLAH/dEJaH/YpvYrGYIOzhnZ4novP928zWWJWlW98
         F4+MmACwghJFWg4XmNSwK5lUHjYUIjqJuF2qBXMny8PlExvWPORg9wXlLfw6VsZ/yANJ
         hEYxCcrxdZM2skfScXlXuYK+g2bMGA7Hh+VmdcwPqV+Ayq01poFj20oJrotG9ZP3LDsF
         tRtHI0YREHxu3me+u8DJkKixFFqulw0C+kdwFYJkzUrUOJA16jgfpZWBjuFK6tnmhsQ0
         mvx2nZ6hpWtYOWu/Uu5LhEKKyfhdIbo5KATq2zhbbrBwrW0quZpkDxlQHXPERnpa5uPv
         gnIg==
X-Forwarded-Encrypted: i=1; AFNElJ/oAJWeIjip8PRVtxFFe7Ia99qHcIjN7eXXTipxv4Rnga31NwGjwpiXdFXWUbz0wSbLLuowo2m9uw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUKx5eRr1rc3q3KAYbPrBAi1hJvAx1Xvrt9aVhI6MVO57xzwVr
	TjzM5/eGDbpPiw4BgkV6lH+2e4ydkTaT91Rxk6ugevGI0ioSzgf7GezPkyJPsuhfaDA=
X-Gm-Gg: Acq92OHFh5a2NkccQXXIbsqT7wW6q3DB2gqBXD7w56fkhdFmKkv8Ff+o3BsmGCZoUIA
	Gop5XEg/COXViL32vqi0rfZg5/IFGezU68dUpp3HRw04RhoI2de1ZMD4CYJ+ueokkp6UMc9X2rx
	Gmd1dt46G46ItAvj/NxqQ1XzD7dLCthfiyGKSxHhzcnSuLm/n99OG7rP73nY1bQYK2dATqDSNII
	N1cDs4omVhqZPkTA+XucETdgIIm7ouf8ZittBEmhAO5wwtmChckfSCbuL/kp9udZ362WYFayiZT
	5NVqA6JhRSuet0pRpQfzYy0V5uz8zSWbHuz+cwO4SI1kcxxD09ri2MJDQH0XZaGtpj4V0ryRn40
	vbJBpXwtibr3qXX6RpSgmm72qB3l3ftapSa0xD2HAvrzkk2itawUlwrw2zUb2teafYRy1eMztUf
	1zwhBY7OgPIhXOcf7KPrC19c6EuHGeoRpgcFl8WvOtyRM54lFKhDvfHJzX/KKd3Vxn7hOuseHOH
	Elsg+Fyyg==
X-Received: by 2002:a05:6830:3747:b0:7e6:fd45:9cbc with SMTP id 46e09a7af769-7e90b3b982dmr1104256a34.14.1781642166451;
        Tue, 16 Jun 2026 13:36:06 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e79f6de65bsm7523821a34.19.2026.06.16.13.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 13:36:05 -0700 (PDT)
Message-ID: <fcfa9bc9-4f7d-478c-90a2-ec4efd4c7d43@kernel.dk>
Date: Tue, 16 Jun 2026 14:36:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Landlock: LANDLOCK_ACCESS_FS_IOCTL_DEV bypass via io_uring
 IORING_OP_URING_CMD
To: Bryam Vargas <hexlabsecurity@proton.me>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8?=
 =?UTF-8?Q?n?= <mic@digikod.net>
Cc: =?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>,
 Paul Moore <paul@paul-moore.com>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260616201633.275067-1-hexlabsecurity@proton.me>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260616201633.275067-1-hexlabsecurity@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13756-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS(0.00)[m:hexlabsecurity@proton.me,m:mic@digikod.net,m:gnoack@google.com,m:paul@paul-moore.com,m:kbusch@kernel.org,m:hch@lst.de,m:sagi@grimberg.me,m:linux-security-module@vger.kernel.org,m:io-uring@vger.kernel.org,m:linux-block@vger.kernel.org,m:linux-nvme@lists.infradead.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:mid,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 537A4695410

On 6/16/26 2:16 PM, Bryam Vargas wrote:
> Hello Micka?l, and Landlock / io_uring folks,
> 
> A task confined by a Landlock ruleset that grants READ_FILE/WRITE_FILE
> on a block or NVMe character device but withholds
> LANDLOCK_ACCESS_FS_IOCTL_DEV can still reach the device-command
> surface through io_uring IORING_OP_URING_CMD with the IOCTL_DEV check
> bypassed: the request enters the device-command handler (block
> discard, or the NVMe char-device passthrough) where the equivalent
> ioctl(2) is denied. The destructive completion and the NVMe-admin
> surface follow from the code -- see Impact.

I've said this before, but apparently it hasn't been received - this
isn't an io_uring issue. If landlock is missing a hook, then that's on
landlock and they should add it. Other security handlers already have
that. Hence no need to broadcast this to a bunch of lists, it's strictly
a landlock issue.

-- 
Jens Axboe

