Return-Path: <io-uring+bounces-2616-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93DFF9422B5
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 00:22:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49D241F232DF
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 22:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C86B157466;
	Tue, 30 Jul 2024 22:22:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1562018DF91
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 22:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722378171; cv=none; b=a6EW7XxIvhFqd61yS/20C+vrUibuCWzkrlwQwV1IVUq6Qh9XP/CY4ZrCBZRFuQdjPrUcH2reSuqQ+XNX+qSdtYreAWOxsfoHGBTcrPLz/H/R8b4/8Jtqf9GUPuZ8u9DXvcULnm2ELss2KbndfAmZRdLBFX71e0wiFtnzYrDu1OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722378171; c=relaxed/simple;
	bh=LItwvTjAr/dTBfvi42l08mJcGrRyHFm3FzrRsYFO+NU=;
	h=From:Message-ID:Date:To:Subject; b=ri4exONu1eszpaqLtmC9q2Zpc2kfbKcChNRYVe0AMoNYP7TrkBELd3yXEV6Ed8NhGKBX5n8Q0fq8zyd/+Ufj/w/fXqVF4T4yyrJ+sPCfxoT365umcLsAP8gigqdT9neoj8ysnG2YTBZqd1GHPwS1Bit+6LimzqTj2LxJBvBGEUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=38618 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sYvF2-0000pj-1K;
	Tue, 30 Jul 2024 18:22:48 -0400
From: Olivier Langlois <olivier@trillion01.com>
Message-ID: <cover.1722374370.git.olivier@trillion01.com>
Date: Tue, 30 Jul 2024 17:19:30 -0400
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH 0/2] io_uring: minor sqpoll code refactoring
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

the first patch is minor micro-optimization that attempts to avoid a memory
access if by testing a variable to is very likely already in a register

the second patch is also minor but this is much more serious. Without it,
it is possible to have a ring that is configured to enable NAPI busy polling
to NOT perform busy polling in specific conditions.

Olivier Langlois (2):
  io_uring: micro optimization of __io_sq_thread() condition
  io_uring: do the sqpoll napi busy poll outside the submission block

 io_uring/napi.h   | 9 +++++++++
 io_uring/sqpoll.c | 9 +++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

-- 
2.45.2


