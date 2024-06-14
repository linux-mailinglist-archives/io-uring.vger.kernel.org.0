Return-Path: <io-uring+bounces-2221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A09D5909434
	for <lists+io-uring@lfdr.de>; Sat, 15 Jun 2024 00:44:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 306ED284E29
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 22:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307931850B4;
	Fri, 14 Jun 2024 22:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="m2KxTbBk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9080A954;
	Fri, 14 Jun 2024 22:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718405069; cv=none; b=f/hSTW650LX77R/EcRRbwC8/O3rYUZ0DTHmJyqYa3/QI7T7+F0rxpG68n8++wvaqaLGT0LrN0nU67awe1t3TI5F9RnVUkLKjvfIyuN72MqAU8Clz8ETN4q8a4fUwKuca0mezltMuH0JPNcy8kwYbwKnGMepJlNQQ67SRSq7m1Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718405069; c=relaxed/simple;
	bh=ScKgb0/EglewfZZ6EuUSCpZ1pVqQWZcSlRmf1VB4Ads=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Phk8fDB9Qf9mpjJ6BRRIqivEWHs60tckapx3RQaNzO9T2hpH7gESB6KFfvmP0Fa+kVTnhIndtuET9AggYRe5DvaJDDlD8r/r46vQVKESRaSU96kCWD+baVqiwyoWAPG9cEGKA2B1cE6leGUDlrMQHRMUuCE9oa4ESbE5TrQdUJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=m2KxTbBk; arc=none smtp.client-ip=99.78.197.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1718405068; x=1749941068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/CldtEnOuUlmUT/wqkFMD45KD0toY5J1p8sVs+g9B0g=;
  b=m2KxTbBk3HS9H+uZSthySeIU3PVgQCw+A92gCB6cPZBWzC3B6O05a0jX
   IXZ2xGFBPXvz5HB8zmIoqZLg6xTWDTTLbwngXxWJm/F4qrnq2hk9toza/
   QN2wkBZUw1vBXow3b7f29iT5XjwPvFA7szbEk4Qo1Sqq78GsNJ+cAC1sE
   4=;
X-IronPort-AV: E=Sophos;i="6.08,239,1712620800"; 
   d="scan'208";a="302349335"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 22:44:25 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.38.20:50786]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.27.198:2525] with esmtp (Farcaster)
 id bba77ebc-0812-4607-8f0a-40f7c337a507; Fri, 14 Jun 2024 22:44:24 +0000 (UTC)
X-Farcaster-Flow-ID: bba77ebc-0812-4607-8f0a-40f7c337a507
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 14 Jun 2024 22:44:23 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.100.24) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 14 Jun 2024 22:44:21 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <krisman@suse.de>
CC: <axboe@kernel.dk>, <io-uring@vger.kernel.org>, <netdev@vger.kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH v2 2/4] net: Split a __sys_listen helper for io_uring
Date: Fri, 14 Jun 2024 15:44:11 -0700
Message-ID: <20240614224411.21244-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240614163047.31581-2-krisman@suse.de>
References: <20240614163047.31581-2-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

From: Gabriel Krisman Bertazi <krisman@suse.de>
Date: Fri, 14 Jun 2024 12:30:45 -0400
> io_uring holds a reference to the file and maintains a sockaddr_storage
> address.  Similarly to what was done to __sys_connect_file, split an
> internal helper for __sys_listen in preparation to support an
> io_uring listen command.
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

