Return-Path: <io-uring+bounces-9930-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03505BC5760
	for <lists+io-uring@lfdr.de>; Wed, 08 Oct 2025 16:40:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1618A189F304
	for <lists+io-uring@lfdr.de>; Wed,  8 Oct 2025 14:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60A2E2EB870;
	Wed,  8 Oct 2025 14:40:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from vultr155 (pcfhrsolutions.pyu.ca [155.138.137.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F123279DCD
	for <io-uring@vger.kernel.org>; Wed,  8 Oct 2025 14:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.138.137.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759934411; cv=none; b=ATO96dctehjifsq/HlwdFBTPG3ffGxpFXeYTKVK2DomxsqpzRJM3m7QvskfFTzYiuP7MvXTR9g+H8rNjwutpZc8F4n8F1yGHphsY6EDhcgSli5Lp0HkJ83CCQlMMTnty0GPLW4nIZ+rb2wjJe5ddcDn50xXl5paaBv/WQ3iEdqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759934411; c=relaxed/simple;
	bh=KaHHW8HBa910eI4rPYcmpBldRe7ii/cKF8zuLH8tEZY=;
	h=From:To:Subject:Message-Id:Date; b=UTIm8pjMlHz3g2B5GbOblkZsyfIAx2ss34qCMJ6yZZ8pus6rbNezW+BZyeMDiqtARMnp8h3U9MQpmddVr5HocT8EtArO4SH8GFaF6zNCO/01AaMRb3xwll7xmDNt9ZKTfjFcXEpSV2JW8u0jyrMu1HTLVDKjqR/kkHwKaPKUYGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca; spf=pass smtp.mailfrom=beta.pyu.ca; arc=none smtp.client-ip=155.138.137.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=beta.pyu.ca
Received: by vultr155 (Postfix, from userid 1001)
	id BBFDA140672; Wed,  8 Oct 2025 10:40:06 -0400 (EDT)
From: Jacob Thompson <jacobT@beta.pyu.ca>
To: <io-uring@vger.kernel.org>
Subject: read directories with io_uring?
X-Mailer: mail (GNU Mailutils 3.5)
Message-Id: <20251008144006.BBFDA140672@vultr155>
Date: Wed,  8 Oct 2025 10:40:06 -0400 (EDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Is it possible to open a directory with io_uring? It didn't look like it from the lib.
Someone told me they used the getdents64 syscall to do it without glibc,
but I don't see anything like that available in io_uring

