Return-Path: <io-uring+bounces-9926-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D2CFBC37DB
	for <lists+io-uring@lfdr.de>; Wed, 08 Oct 2025 08:42:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D67964E3D66
	for <lists+io-uring@lfdr.de>; Wed,  8 Oct 2025 06:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392521F03D8;
	Wed,  8 Oct 2025 06:42:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from vultr155 (pcfhrsolutions.pyu.ca [155.138.137.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9ED29B775
	for <io-uring@vger.kernel.org>; Wed,  8 Oct 2025 06:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.138.137.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759905770; cv=none; b=BwgK47ORjlAFAQEqi4rzaWZclgyHY92KIVUBfqLhpsBPgxZxyAcKwrPaIk6H9bW1PBSQ49Mxxa9dItxzSl/K3zQq1ObPyRtdL67Qzifyf1kArPBJW0XBOsQkIlT4cQooaYYAAh+Bs7c3AfbQPN0Kvx3mrbzXTkyZRlBgzARBIVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759905770; c=relaxed/simple;
	bh=+Txi7KOuzcr5r9YxYffs0GIkt6emKYEinHS02XSBblc=;
	h=From:To:Subject:Message-Id:Date; b=T2LWEavSx2AlfFpSbdZ6VME9bGEzO9p5PvO3UeeCH0XKyPhsIiaX16zqIK29AOytA8lFslW1hf+SxG3UV5+BMjJHU6QpSOwbumo2i/aT4kOA8njG5vXs9Noy9qck5AlUOCjUJDNNrvD0DlF6GOxBE0HqhMBHK20aVC5I+EjwmQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca; spf=pass smtp.mailfrom=beta.pyu.ca; arc=none smtp.client-ip=155.138.137.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=beta.pyu.ca
Received: by vultr155 (Postfix, from userid 1001)
	id A37D5140672; Wed,  8 Oct 2025 02:42:46 -0400 (EDT)
From: Jacob Thompson <jacobT@beta.pyu.ca>
To: <io-uring@vger.kernel.org>
Subject: read folder?
X-Mailer: mail (GNU Mailutils 3.5)
Message-Id: <20251008064246.A37D5140672@vultr155>
Date: Wed,  8 Oct 2025 02:42:46 -0400 (EDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Is it possible to read a folder? Someone told me outside of uring he did it by using the getdents64 syscall. 
I don't see anything like that for io_uring? Is it not possible?


