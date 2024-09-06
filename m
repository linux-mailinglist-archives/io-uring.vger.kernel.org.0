Return-Path: <io-uring+bounces-3056-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE0C96F064
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 11:55:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 089BF1C23B64
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 09:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7711C9DFD;
	Fri,  6 Sep 2024 09:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b="IFf5a5o/"
X-Original-To: io-uring@vger.kernel.org
Received: from mta-65-225.siemens.flowmailer.net (mta-65-225.siemens.flowmailer.net [185.136.65.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FC21C9DF9
	for <io-uring@vger.kernel.org>; Fri,  6 Sep 2024 09:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.136.65.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725616427; cv=none; b=q02kSUci76bZwjkOA31PGPdDIM8C0I05ohzmLznKpNnBjdEhQPb9nYEZscM44zTf8MJs9jBzLUEXu1F258H92TCBaaCW0ORfspwx0ifRpOfsKtN+G4cEOUv5Nvw9hBgFeqCU7X0/GTwkR2DM5rwP4XJvtHA7bBZ3UGEGUpKrdEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725616427; c=relaxed/simple;
	bh=IFiJzNa23HL4yv8NJuBXDog0rL9XAEykvFMCfcNcisU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=VwrYDmN6emygTsZvPkLCuFe6ROWpQ1eMiUZYgJ1ybNjIMTtuv0Huyj12C02wYu8Mf+JSyB2/EamBXOkdEFB+0NY8OJO56++3aVoiLeh1eWikRZenYaRotRb0/lOxG5ilj2wgtPhlCQuIZzz9JvaQpjxmjwaaMFQcfockJJSjTZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=felix.moessbauer@siemens.com header.b=IFf5a5o/; arc=none smtp.client-ip=185.136.65.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rts-flowmailer.siemens.com
Received: by mta-65-225.siemens.flowmailer.net with ESMTPSA id 2024090609533366f6b5c52f39ae7b2a
        for <io-uring@vger.kernel.org>;
        Fri, 06 Sep 2024 11:53:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; s=fm1;
 d=siemens.com; i=felix.moessbauer@siemens.com;
 h=Date:From:Subject:To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Cc;
 bh=6VoFJll+UytvMdR9ZwPf6T244iPbXuYc1jQw/YWFhao=;
 b=IFf5a5o//QwGazxn9uhFa7rMjQVkIGpi1g5YNZaci36YSaBTA2Mvw9YD43a2yHJIvqbYzC
 /M9yM07dsd7Q5zf3KyREHPSSCdNOU6ztSV0Zq9B1Io6q3TFwwrAlaP0jtFQIdIBH97GLMoFP
 EMYEagm1ed4Zpsplr6f4XArhcJV8PJbx+KhB5mmXsl13I0tzp5zOP/trXgeYAhHeBQECDy6K
 BK/V8xq5CyflLO4IGSVHpS1KIF5ygh7LEFStJmj4zoLt5FRa12VEBWJS8Yl3RgZT7XfQBcpQ
 GaB7x9qGj+8KDQmCghFMXWAQooGN2Hnzz0pmUEoS0CfDv4KCcNnNObxQ==;
From: Felix Moessbauer <felix.moessbauer@siemens.com>
To: stable@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	cgroups@vger.kernel.org,
	axboe@kernel.dk,
	asml.silence@gmail.com,
	dqminh@cloudflare.com,
	longman@redhat.com,
	adriaan.schmidt@siemens.com,
	florian.bezdeka@siemens.com,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH][6.1][0/2] io_uring: Do not set PF_NO_SETAFFINITY on poller threads
Date: Fri,  6 Sep 2024 11:53:19 +0200
Message-Id: <20240906095321.388613-1-felix.moessbauer@siemens.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Flowmailer-Platform: Siemens
Feedback-ID: 519:519-1321639:519-21489:flowmailer

Setting the PF_NO_SETAFFINITY flag creates problems in combination with
cpuset operations (see commit messages for details). To mitigate this, fixes have
been written to remove the flag from the poller threads, which landed in v6.3. We
need them in v6.1 as well.

Best regards,
Felix Moessbauer
Siemens AG

Jens Axboe (1):
  io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq workers

Michal Koutný (1):
  io_uring/sqpoll: Do not set PF_NO_SETAFFINITY on sqpoll threads

 io_uring/io-wq.c  | 16 +++++++++++-----
 io_uring/sqpoll.c |  1 -
 2 files changed, 11 insertions(+), 6 deletions(-)

-- 
2.39.2


