Return-Path: <io-uring+bounces-2747-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 750BB950B39
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 19:10:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 319B5284AC9
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 17:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF2A3D38E;
	Tue, 13 Aug 2024 17:10:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC5826AC6
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 17:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723569048; cv=none; b=UdHkVVZBmfSAPjDpn/ss20sOvK5lN1iu1OrV+rPF0xx8e/QXZF44lQgKLDdm8Fv9s/xu9DlVcfT+pHnNvpdw8zfHMICJcPyFtikO6SYeB3yHpN0LEMS0foIajLRN8i7c6BDU71I6gP4MF0dFyoJxlAgxlrEOLKyG+AaWHueIP24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723569048; c=relaxed/simple;
	bh=kacQi/2P/GT/nyfgbgSzqiqGFNam1DbcAoYqK13InAc=;
	h=From:Message-ID:To:Date:Subject; b=aMwotq4zfYmC7ZGQpKpaoDVI+aB8dVkwwAE7D/tUTdcMXPaSLHdVU+Ma3x0KerzB9ZIV3lpSHmtEJRKYBmjsg/OCgl37l/Jd1ft3kBIxPWTClZJBMrsYpc4dHqd5YyDKdILwwbBJ5PiWTnAEki42md8g69+DKMKmi02p/I2RciU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=43534 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sdv2h-0003HM-11;
	Tue, 13 Aug 2024 13:10:43 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <cover.1723567469.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Date: Tue, 13 Aug 2024 12:44:29 -0400
Subject: [PATCH 0/2] abstract napi tracking strategy
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

the actual napi tracking strategy is inducing a non-negligeable overhead.
Everytime a multishot poll is triggered or any poll armed, if the napi is
enabled on the ring a lookup is performed to either add a new napi id into
the napi_list or its timeout value is updated.

For many scenarios, this is overkill as the napi id list will be pretty
much static most of the time. To address this common scenario, a new
abstraction has been created following the common Linux kernel idiom of
creating an abstract interface with a struct filled with function pointers.

Creating an alternate napi tracking strategy is therefore made in 2 phases.

1. Introduce the io_napi_tracking_ops interface
2. Implement a static napi tracking by defining a new io_napi_tracking_ops

Olivier Langlois (2):
  io_uring/napi: Introduce io_napi_tracking_ops
  io_uring/napi: add static napi tracking strategy

 include/linux/io_uring_types.h |  12 +-
 include/uapi/linux/io_uring.h  |  30 ++++-
 io_uring/fdinfo.c              |   4 +
 io_uring/napi.c                | 226 +++++++++++++++++++++++++++++----
 io_uring/napi.h                |  11 +-
 5 files changed, 243 insertions(+), 40 deletions(-)

-- 
2.46.0


