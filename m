Return-Path: <io-uring+bounces-13885-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id /Pl8IvsdS2pUMAEAu9opvQ
	(envelope-from <io-uring+bounces-13885-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 05:16:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9627170C483
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 05:16:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RdZRQ4ME;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13885-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13885-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1B4C33009160
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 03:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358453AA19B;
	Mon,  6 Jul 2026 03:16:03 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51272E0938
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 03:16:01 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783307763; cv=none; b=MOlNtpCA5nbKEPkMuRANYI+j+EvEWMhlICrbdSCqlHLQtCdBeUAJJGw4UJ1FhgxFDBRIADzXMdCuMNVB9J6QudshtTZAFm9I0p2oqR3+j15Zxg6DsXwPEpQmHCm9yvdeSfSyd+s9yTBbvRyCV+Ni0mB87zEC0RWdUS5yeUkd4bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783307763; c=relaxed/simple;
	bh=2JrOu8ZYb7tHM+J8eIgn/teiRpLN+8jSh9WWl9nAN4w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cryyu5CLJ3HOlc3q80sUwdRmeR9R5hUbehOZWKWs4ncoB6fuL0xUUXF5x6nuN647KZRRhkC+J/UzUKyEbnnATYQG0tfx3DfqK8aF57tUPH/mdj09G8PSWzBT0tfFgudPGl/M1lAac+0kk2avMikb4LQPtYUxXM1PpooHBnKvC8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RdZRQ4ME; arc=none smtp.client-ip=209.85.219.50
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8ef7b7651ecso25641516d6.1
        for <io-uring@vger.kernel.org>; Sun, 05 Jul 2026 20:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783307761; x=1783912561; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b2Lmo0Z9LtR3itZCUsud8f61jOwZl96l9I13KLRvA0M=;
        b=RdZRQ4MEbBQQVi6xoKDl1WBCkN8K/W8tThDDFj+V0V2WV67hjZKw3zbXYIHI5WVg99
         RqGKBvz5xabhbMWyi8MKIpA/WeoahfPuTFOqEESK/E2RCmKYF6v0LD7DmNcPctutklaZ
         jhDIBOp2TUPKrWBKQJPuTcbzMsvEofK+2dOLa7/Tqvw5gcalBUrdH93D1uC7gImrkJ/F
         B49CHjS+uToKC6YVJsF3+VR2Icse0EjlYmrpefyvlXgdHXVyud07z978AlNONABr4Pwu
         riZqFtIwvkWz4T/eQ+K7pn7R81uJCTEzDBQPtF0y6ihpgWT2vkCKIdIlTLWTDsbO2W3K
         JBqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783307761; x=1783912561;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b2Lmo0Z9LtR3itZCUsud8f61jOwZl96l9I13KLRvA0M=;
        b=oLQD09iFADrRLAYugp4zTPmQJxlp9d2qE1ynAA2VJDPuJrGPWXEoje8nreR/ERDXcE
         z1XMupG4o+e6VgQMltzaV/KKVtzsalDHqp5zpD4USD7VrsIojU+leF9g+EqN8vocrrvk
         6IdclMx3Ml0e01b+0jfTJIB50ZzL/Vf63TA62mx9D+rTEJwsW7tPlL9qbN8OSjkhf8Mv
         +w5kNNd/6R+KGlKESaWKneFa5yP5AF1XSLWSVJKpbAj4BYrdZrFSttiSJzX1oYdz6lWU
         zMUSajPPhnAbs73nRQT8y205KJixbWfaL6A7GRF7Do3q2IWoSVcveWEWRP8SXH5Rzcdl
         hvjw==
X-Gm-Message-State: AOJu0YxEYzh1fqQZD0aeIAcvVkOe2aoQp6dM2YR6ysv35f1pPaHK9bOu
	06lh+YFjKKI7215GRoD+/+aOf3hXFRqiu/WO8jKPOAPzJKJRfov529AFVzX44g==
X-Gm-Gg: AfdE7clWm4aAcvC0ZisJ2Xc6VREa6aSKIeizXsgoDxXXpdwndGDb74pJ7Fc7NTVew83
	FJhtROOzjWD07uzG5mIbnTlNFWCcf51VghC6msvleoMduUaOe76YkrVcsKkVX1AbxFidi1VQVU+
	VusjXIGu3+qDa8+CiXNjrpXqkXZQ6uZYd0CCWkHXXK25YsRowkDbXwuCsgwPoAqKc3HZH7dEzPF
	G589ravTyclIN2IZsEAFUL4GiIReLDPMJr4yNJx7iE/C4Ec5GjaQ1i2ZaKGvzqvDJ4TqXQ8Yrwj
	94/TtPEtb7Ub/Yruo9AXErIZr5ajOX31he/UdgFDOv57TiqAzZcTCc9dWa+NYmkA1SeWfohVdGM
	XZ5V+X2b4B3bLlj+4ubUmTketyW9A8M/kXtrFsQUakLT8+pISAHfoIktTEKq88N7gJvjUfZzN/L
	CrPrVpQzzmAqkx4361PTeKJVAxDrthRBC6LQncVtbEPjWbHVM/Lq5ztqX4jbzh4cs/WH0oeUkpe
	0mhgvDjrn2Ugbb21ohb
X-Received: by 2002:a05:6214:5902:b0:8f1:fba2:d4aa with SMTP id 6a1803df08f44-8f5bce7ca6cmr177079776d6.16.1783307760406;
        Sun, 05 Jul 2026 20:16:00 -0700 (PDT)
Received: from fedora-laptop ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f46f013f05sm123047226d6.16.2026.07.05.20.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 20:15:59 -0700 (PDT)
Date: Sun, 5 Jul 2026 22:15:54 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org
Subject: [ANNOUNCE] ioutgt: a generic userspace storage target on io_uring
Message-ID: <aksd6ruHwN6bVVKe@fedora-laptop>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13885-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:linux-block@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fedora-laptop:mid,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9627170C483

Hi all,

I've been building `ioutgt`, a generic userspace storage target on
io_uring (Rust, Linux >= 6.11); so far it implements NVMe-oF -- NVMe/TCP
and NVMe/RDMA to an unmodified in-kernel nvme host, mirroring nvme target in
userspace. 

It's early, but it passes `xfstests(./check -g quick)` against kernel
nvme-tcp & nvme-rdma with `ioutgt`.

Single job fio test shows that its perf is very promising compared with
kernel nvme target on mlx5, follows result in the repo:

	https://github.com/io-target/ioutgt

Feedback is welcome!


Thanks,
Ming

