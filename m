Return-Path: <io-uring+bounces-2052-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E9708D6F2E
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 11:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67EAE1C210EB
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 09:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DCD514EC43;
	Sat,  1 Jun 2024 09:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=s.muenzel.net header.i=@s.muenzel.net header.b="pTgImWLm"
X-Original-To: io-uring@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C2925569
	for <io-uring@vger.kernel.org>; Sat,  1 Jun 2024 09:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717235015; cv=none; b=F1D84pdmiOL7wVyQt4mj8MeDGw/TyRj6CToWSb7shYXNA7XI+lnepq6PFsq0KM8csF+YYCpLmqbh/pkz9ncdHbmIKyGAi9ZltZ2Q3UkJ1lcam7gj9lIFa4QAEavdTX8Mdd0j2i1p40kwH6E+OaI6OOnXr+V84pe7WlDI4m+uUJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717235015; c=relaxed/simple;
	bh=CcU9We3FxegU7MVEU0LzkRwpdNRKtomJ8lIadMRIwx8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=arUOmuO0wIxZu2G5G1XubC9IPnSOVyS/GSuMKQmcA6HWAnb6Lw7qxJwruwURw1ulokp4c5KNC37lcF3cLPoBCAF1/5nnL2SzvPY0GsmS6zAgkIUX8iS7vBUdpw4BIWkujFZLj/EZ9mZZ1Mm+vBNDRrfiA5yqMzv+tIbfjDe9y44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=s.muenzel.net; spf=pass smtp.mailfrom=s.muenzel.net; dkim=pass (1024-bit key) header.d=s.muenzel.net header.i=@s.muenzel.net header.b=pTgImWLm; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=s.muenzel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=s.muenzel.net
X-Envelope-To: io-uring@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s.muenzel.net;
	s=default; t=1717235010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=L/zxPThXgp0VFG5RnhLmHG4J+FwwU6CH9UEE7fOkC8w=;
	b=pTgImWLm9gBVAMJc0LfDfg8xTVbhABG+sfywsPFzXfXSDwku1W2H2hWQjJTMgv0kSoULly
	cH//DpfHvPJtfpkyFlaLexCPPI1a1ObSYtMZXqEOBBSFm342p/MR5IhvdVIuAqO/Juomjv
	lOPTbiJKMMPalqYVy9+0CfqM3P0yiYs=
Message-ID: <bc92a2fa-4400-4c3a-8766-c2e346113ea7@s.muenzel.net>
Date: Sat, 1 Jun 2024 11:43:41 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: en-US
To: io-uring@vger.kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Stefan <source@s.muenzel.net>
Subject: madvise/fadvise 32-bit length
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

io_uring uses the __u32 len field in order to pass the length to madvise 
and fadvise, but these calls use an off_t, which is 64bit on 64bit 
platforms.

When using liburing, the length is silently truncated to 32bits (so 8GB 
length would become zero, which has a different meaning of "until the 
end of the file" for fadvise).

If my understanding is correct, we could fix this by introducing new 
operations MADVISE64 and FADVISE64, which use the addr3 field instead of 
the length field for length.


