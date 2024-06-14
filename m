Return-Path: <io-uring+bounces-2220-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71AA5909431
	for <lists+io-uring@lfdr.de>; Sat, 15 Jun 2024 00:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 204AF1F21FFD
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 22:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792AA1862A9;
	Fri, 14 Jun 2024 22:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="q4xnJrCe"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656311836DE;
	Fri, 14 Jun 2024 22:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718404979; cv=none; b=YJgbKK4xEKgPQBV5pW26pQqXZy8uUcHIex0ZgEWIOD3D18fH+ZcB9weQYg3qFZkppos9FDcKDFnWUsQljgAFuoRvVTkUFr3fL7yyZx1F7/7u7Rb3b8qTs87SOYmeX9zav0kQggrsd1JXcWtJhwspJwyf9tE5b0+ealdgzXtRoDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718404979; c=relaxed/simple;
	bh=hMRbll31aUu9PetlDKYWpu73QHXP46vgKGyvrUS0AVA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kt0saXzMO7Xq8VrUV5DFhOWPqpsono3ah3a9xhq5KBK1Wp169hEXJu6zzV3E8/B6vyA5XsTbKgU11ybhOkZ32rR015j+q007cUVl6vZ6yIal1YRcc/KnRJt3x9XbBwZ6/CJpJRmKBZ/vsKnFnWsDbQgZP9P2pWk14AqnsVYLdhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=q4xnJrCe; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1718404977; x=1749940977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aU70ZqFfbp5qX0woM31+nOu9CGI6QA1qDkdik01wSK0=;
  b=q4xnJrCe/uw5rPqKTTNcy1RZtji3lzjShsJaRGkx5Pa+XKucA85dknjZ
   /ozpRazYmteVob8Vuh9DsNKK1rn8X97TDxYhdbyle03sIxWaGyiZKJPUq
   uY4Q7HkYIRklgK2LWH3/KXqRC8MwJs9yz6QWTqYPlnilR/+GsFeuMOl+t
   E=;
X-IronPort-AV: E=Sophos;i="6.08,239,1712620800"; 
   d="scan'208";a="5105064"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2024 22:42:54 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.38.20:22227]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.30.16:2525] with esmtp (Farcaster)
 id d9fe9a7e-4ce8-4d20-a288-48275c00278a; Fri, 14 Jun 2024 22:42:52 +0000 (UTC)
X-Farcaster-Flow-ID: d9fe9a7e-4ce8-4d20-a288-48275c00278a
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 14 Jun 2024 22:42:52 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.100.24) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Fri, 14 Jun 2024 22:42:50 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <krisman@suse.de>
CC: <axboe@kernel.dk>, <io-uring@vger.kernel.org>, <netdev@vger.kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH v2 1/4] net: Split a __sys_bind helper for io_uring
Date: Fri, 14 Jun 2024 15:42:40 -0700
Message-ID: <20240614224240.21155-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240614163047.31581-1-krisman@suse.de>
References: <20240614163047.31581-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D035UWB004.ant.amazon.com (10.13.138.104) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

From: Gabriel Krisman Bertazi <krisman@suse.de>
Date: Fri, 14 Jun 2024 12:30:44 -0400
> io_uring holds a reference to the file and maintains a
> sockaddr_storage address.  Similarly to what was done to
> __sys_connect_file, split an internal helper for __sys_bind in
> preparation to supporting an io_uring bind command.
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

