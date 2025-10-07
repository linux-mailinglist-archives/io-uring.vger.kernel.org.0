Return-Path: <io-uring+bounces-9906-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64243BC04F0
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 08:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E0FC3AD8C7
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 06:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2BCA208D0;
	Tue,  7 Oct 2025 06:15:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from vultr155 (pcfhrsolutions.pyu.ca [155.138.137.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39CB366
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 06:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.138.137.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759817757; cv=none; b=K2EbbW944S1AGQHQDLJyUSyfpO6YGctUwfGRrnIppxJnuaFzTnubVhplAgtScMeqXRR0v8peL2CJfYdb/WV/brgBHnFe+3v6DEqdl9ru4l9kxE6s6Sqotq2b+c8IKlVor8x6ClLNtE/+Dr1g9uOrdyVQ+rHW2EaOHkVyDUlRPzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759817757; c=relaxed/simple;
	bh=Agf9r1kWjHbpwBTsHCPo5Yi6ik0Ln2WV7lnqYdhpWqw=;
	h=From:To:Subject:Message-Id:Date; b=GVoJyL3A4zeFLUfk6zyFLPf1qC89L1hrengV1wbt9Gkajedh4BwIah4IJS9Em3FyoUZRNsbXkvJtUEYoWF5C/Nm3W76dAqugPjTS9NeriQS8iLZVsMYQ+Fnq727Q3ms14D6+b1LLU/dCncwDqVMqd+PNwKydUw6nQe+lMX06AHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca; spf=pass smtp.mailfrom=beta.pyu.ca; arc=none smtp.client-ip=155.138.137.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=beta.pyu.ca
Received: by vultr155 (Postfix, from userid 1001)
	id 74792140672; Tue,  7 Oct 2025 02:15:54 -0400 (EDT)
From: Jacob Thompson <jacobT@beta.pyu.ca>
To: <io-uring@vger.kernel.org>
Subject: statx can't used fixed file?
X-Mailer: mail (GNU Mailutils 3.5)
Message-Id: <20251007061554.74792140672@vultr155>
Date: Tue,  7 Oct 2025 02:15:54 -0400 (EDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

I'm having a hard time telling which opcodes can use a fixed file. I assume all would?
I don't see 'read' explicitly saying it supports it, but it ran fine.
I'm able to open a file (normal call) and use IORING_OP_STATX with AT_EMPTY_PATH to get the file size.
When I try to use openat and use a fixed file it no longer works. Is this unsupported?
I don't see "sqe->flags |= IOSQE_FIXED_FILE;" in the statx test, I'm assuming if I don't see a test for it, it's likely not supported?

