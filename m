Return-Path: <io-uring+bounces-12328-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yIvtGJMEl2nhtgIAu9opvQ
	(envelope-from <io-uring+bounces-12328-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 13:39:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A502915EA0F
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 13:39:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6FEA63023373
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 12:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5761E9919;
	Thu, 19 Feb 2026 12:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CXqv1hVb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAB318027
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 12:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771504783; cv=pass; b=rZze1kEGubjN96vCL9K+cOJ7sgw7yMeyHEq1Er0TysyNEZqPE8mPPeRpuovsV0GhzaII7SAJbMLfwcc4oaYrQFdB3+j0ovVRc5zVEYIc0IlpxVXv47MBBqE6aSBod8QgBs2IG5G+C+8X17sEkGx/MK3lJrH0TWojJw+84l0QERE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771504783; c=relaxed/simple;
	bh=OgomjWPtpmD+eOsIH8fUkv4dBzkwG7FWaCss6M+RTSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tBjaWwqtC0+yuH5FYBSHnZ7NSeUTKMdXQNUmQD8e0zv8Krg6/9CiglzU2quH/6VHVtwognRUeqwWO5VvNvsFFzFrT352hBTou79980/EkCQDtl5R40F+C0/xwMY6G09MMLb8NrZL0233ZBK8zmSX9DuvAGSMeRa7vDXG06hdtFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CXqv1hVb; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b8f86167d39so131576566b.0
        for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 04:39:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771504781; cv=none;
        d=google.com; s=arc-20240605;
        b=F3Q28fqzGGb9ujQftKqHWgjMk8OQCa24DWW9l4tiZ9ar71+IV2tiCkH0TUSr6M6q0x
         VCtWgJPUnNuDO8zdxaXu+2pcTG7xc/sKi7H55AtBCqbMkiMhv2lS4ic0LH80QbLXRzbs
         FLXi4scDgJS4xlBJiP60xh1ObUQawcERrdKT9zVqXGdQ02y2G5M412SFfnUBTL2G6EYs
         Z+rkGlOKupfLEehGtvKhPgwouFP6Zs45tDQOt3cnww21hvUhAbEecQjZndpsXCeCdlV/
         6UCFR47bOCbdPJt47kes3Y/EEOSNcV2sDISMSp5LFTmhqlVxblLwRmw5sgfSNtMqEZeM
         gqIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=K9x0gs1Uru3r95Lbv4iqUVCP85SqlxE0xVGVRZWEuqY=;
        fh=CnKvhCBPENAThla8hgltBJhIPasCu2J0VRomt5qMxzE=;
        b=j/FQANN9alOMcZrg0QHkPbGMAV5qaV+/bAEs3hoGZDh2BwuXTNrs4knTJ0kXlSH7sJ
         9vakSe79t4OqsWixSCvXFiFVkH2uFnfwynxRi+PQdvtnUbneTuLkKtB8yNM4R8v79s8y
         AfOzuS8yp5zRC2Zorj3rlJeyxxLbEAAYlx8EzcftMXHDUDfBIvybq+UczlCwbzDeOfgJ
         VxXQIDN3OflwOlacQ2tLYGcfbL7zxQ7OOr3XwnEM13MnQKq2KITyNpJX7lSBNarSN1v9
         2zk4qEjnyKI93xEOotCykqWBFf15CqhFmM2wMikVDfrAAPkyIuVgaK3KsECMB0K+5z8V
         Te8g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771504781; x=1772109581; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K9x0gs1Uru3r95Lbv4iqUVCP85SqlxE0xVGVRZWEuqY=;
        b=CXqv1hVbQgN8g3mcBG7Zod01RpsvAFuxergfRAJNycTtBkOklI7r7tGwaO6cD77VAR
         xrJ1299aSoa/xigvaGtNEQmSdUo5Jt2TeARxYlEa/7+BjMsZGjCwBZYiI1QbGfMNek8e
         kW9CUMe/IIpZoLtBbkHZ2+ugN1hzAHT6JYxuFNB/KDUn8XNFy8qiUAA8ZcWSTeX7M2hb
         M2vGq7ziUYqP3nhL2FvLmZzZyRtrq6O8RbBBwbIqghlctv2NzjGJFR8IaVKc0xXWHUm3
         CDLeCyOVEs/oBD8NcowUg52Hkb8shBuwilZQ9twFWP10UJO5zqBFHgcmfxpxfoW9fRjd
         9YEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771504781; x=1772109581;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K9x0gs1Uru3r95Lbv4iqUVCP85SqlxE0xVGVRZWEuqY=;
        b=rHaIFcpPm8Ptp33ILCREMudSCyKTdlA6vapaNsWkbDF9OS3N+uKUza48ZUuWVnZxTY
         qh11RlpB67lkqpsimpdb+VYanuYXOEsvMY7kQ77uTfHOjJEeCKnABO1DPQOASn+LKAAh
         savLZ6lHkdAQQTSSCyCd2xrLijiz9VRCAnXcho52OEOQCoSUFcTCj1gqlPCj1nSSAzWH
         ic8Jp8O/+fG/GKhxR+E6aHC6pmW0fWD4iXafH09Vd6dYHEG8pUtZYXinr92QOxYo7jou
         4AvrGyPniYz4UyDKoj0fhgAObHCDPy5+5Ieeukzv2sIf65GYKhRfeepmA8TiNDNG8tA+
         Tj/w==
X-Forwarded-Encrypted: i=1; AJvYcCX9nzQN73wOq2zXLRC2sNCQ3CMnO0GfXY9VeT5YiJ3Uty+Zock9nUCN3mVp1JL2rnIa/zeBx+hfeA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzS+bU0X/gaqOvWSumDI6KVymMIEzk5TitTrc+UXfSApLRBPIVN
	XL4p3yvQRmhAMcCQ9LirM63tOm0yQWGY2ekKUMI+TcA4paMSzUQiBhuL3Lo2UhdpzU2+fNQUSmY
	/gzJif5mYp2PBccaBjOBTPd2on/xkpw==
X-Gm-Gg: AZuq6aLpxHDSdJPyPexnvVgQiYWFtHPfuZ9bDKRcy4PYK+PktQMShe/1tmUarlB2hAp
	18AFptLw8eDnBc3nokMpLvSfDukzphY2pnrqvO9KeLwqW3Kki2PJRW41k+Zo4g0gs9yo51nCpIi
	yjwVCBONX0R8tr9Tm+bKN/cD1vDK8t1fhjkRgF8s17GAdYtoOQK1fELv4ABAk2pdJIy+pd0BZmN
	tus3s5zyCAoNMOcrHIsYXjglMjk7SKTXTL8Tq2A+Aq8qD7CTalZ1biqPkhIisFKLYkw6BKxc/r4
	fjMyvy3Hjtq6V4Sqt1MixB8alVo+4nBu8Fo3D33DMNAFqZ4Rt595ckUtWdnVWITHp7Y=
X-Received: by 2002:a17:907:7216:b0:b87:206a:a241 with SMTP id
 a640c23a62f3a-b903daa63b4mr311771466b.11.1771504780476; Thu, 19 Feb 2026
 04:39:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219014335.9061-1-csander@purestorage.com> <20260219014335.9061-2-csander@purestorage.com>
In-Reply-To: <20260219014335.9061-2-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 19 Feb 2026 18:09:03 +0530
X-Gm-Features: AaiRm51PRTbuDOBVDD9MKNI3CZHgijGXXIV-tUiGHC864mQz-p1bLHnzuo0b_AU
Message-ID: <CACzX3AvpBv_vM5DNFmxBcMoCogC4HK1e0c58PA0kiBQ1wMacow@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] io_uring: add REQ_F_IOPOLL
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12328-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anuj1072538@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A502915EA0F
X-Rspamd-Action: no action

>         REQ_F_HAS_METADATA_BIT,
>         REQ_F_IMPORT_BUFFER_BIT,
>         REQ_F_SQE_COPIED_BIT,
> +       REW_F_IOPOLL_BIT,
>
nit: should this be REQ_F_IOPOLL_BIT for naming consistency with the
other REQ_F_*_BIT entries? Otherwise this looks good.

