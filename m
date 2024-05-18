Return-Path: <io-uring+bounces-1928-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E3D48C8EE3
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 02:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20A6D1F21F47
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 00:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398A336C;
	Sat, 18 May 2024 00:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infinitecactus.com header.i=@infinitecactus.com header.b="DJocaQOj"
X-Original-To: io-uring@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2380B8BFC
	for <io-uring@vger.kernel.org>; Sat, 18 May 2024 00:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715991946; cv=none; b=Dyecfc4pAqXXt6TwW18hGQiaeGdczIRnNjTleBxjUx/UCxnnVNuM5lYMEBdq8rzfVaASN88NdSyvf5LRVcWMcKifQARBddnq2Shzfy+/XEfaBzX7pPFtdl2K4vl7giIdCUBFlOhR0Wxp+vBj4p+1ixk1BBIg07ZpRfbdmxK7OHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715991946; c=relaxed/simple;
	bh=HCZSm84Ox4gbEWl8sY1zhQzl/ORn9cmldwkgrMJTlKs=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=I5DUXMUNIwIXGoRFeaNYIYTzeBFQYW2QFHa2ltxoJ48KWX+zFjBsaWG75lOQ69oEt10UCRFOXOjHCaYMLJtAf8VPLa+gElPesFBJXKt18g0YRMc8aOoi6zXOGzYWr4msITY7Ky3bDvFBLg5eh73rTmDGK0LUPJeFPqXEEgq7bGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infinitecactus.com; spf=pass smtp.mailfrom=infinitecactus.com; dkim=pass (1024-bit key) header.d=infinitecactus.com header.i=@infinitecactus.com header.b=DJocaQOj; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infinitecactus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infinitecactus.com
X-Envelope-To: axboe@kernel.dk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinitecactus.com;
	s=key1; t=1715991941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HCZSm84Ox4gbEWl8sY1zhQzl/ORn9cmldwkgrMJTlKs=;
	b=DJocaQOjJy58Ci9KAFG3cOYHGN1jhLVwwPZikN/vLiwpGfeICCRjUPVEVwEwVSJvhQJdiH
	CoVNa4qjLarB4zgsPEnadruyKQusdyQ1JFz26jbO5c7e2ZUFmDaEQvvPYoz+JKvJ75rK5G
	uHqLOUxm+N2yCrEal9RXh97RsJzxLg8=
X-Envelope-To: krisman@suse.de
X-Envelope-To: mathieu.kernel@proton.me
X-Envelope-To: io-uring@vger.kernel.org
Message-ID: <2b21e1e5d78c0c34de555e840ce780d3b49f82d1.camel@infinitecactus.com>
Subject: Re: [Announcement] io_uring Discord chat
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jason Bowen <jbowen@infinitecactus.com>
To: Jens Axboe <axboe@kernel.dk>, Gabriel Krisman Bertazi <krisman@suse.de>,
  Mathieu Masson <mathieu.kernel@proton.me>
Cc: io-uring@vger.kernel.org
Date: Fri, 17 May 2024 19:25:35 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT

> I'm really open to whatever, however I do think it's a good sign if
> an existing similar community is already using zulip. But as is
> customary, whoever does the work and sets it up, gets to choose :-)

Not to be that guy (and I'm just a lurker/observer [for now, at least],
so feel free to ignore me), but a lot of the other kernel communities
are using IRC (generally libera.chat or oftc.net).

I may be wrong, but I'd suspect some in the community are leery of
closed platforms like Discord.

--
jbowen

P.S. relevant xkcd: https://xkcd.com/1782/


