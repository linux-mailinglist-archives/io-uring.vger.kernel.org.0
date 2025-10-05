Return-Path: <io-uring+bounces-9892-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5663ABB9CF2
	for <lists+io-uring@lfdr.de>; Sun, 05 Oct 2025 22:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D3873A519F
	for <lists+io-uring@lfdr.de>; Sun,  5 Oct 2025 20:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30DB842AA3;
	Sun,  5 Oct 2025 20:30:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from vultr155 (pcfhrsolutions.pyu.ca [155.138.137.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07615189F20
	for <io-uring@vger.kernel.org>; Sun,  5 Oct 2025 20:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.138.137.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759696226; cv=none; b=Qci8pSu+2ap0pcgTFs4R/fI0cs2L5TjTn8he3PFRWpao9OmRXlSlSXEgRRTPhpH4VxWpUIEaiDq97mh9GnCrN6EzR8YHeWxT29CrpJrQlEYsQn9E19Q1sJqmD1n4xHJj436bHYGuKRIH7MA21MkKXLOTkSKBd0HrVd6GFgmdpK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759696226; c=relaxed/simple;
	bh=8FUvvX+fETBiP82Cgc32041GmUokwGqowjELdYqcEh4=;
	h=From:To:Subject:Message-Id:Date; b=mCr/mhnOiTg8nYXecNg5+65RcbApcvunLxEsiJkGBumyyVhJNoAEOwB1FA0uJpS36zdpin3iHhvFVTVFjJ3QXjBU0iCRn5wneiHpS82z8UmzNzSJdNr66FBnBwd67WDI5PE50S00DGfjfGpNX0riXDq0HBB4Xwf3uopGUT/kV/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca; spf=pass smtp.mailfrom=beta.pyu.ca; arc=none smtp.client-ip=155.138.137.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beta.pyu.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=beta.pyu.ca
Received: by vultr155 (Postfix, from userid 1001)
	id 78998140681; Sun,  5 Oct 2025 16:21:15 -0400 (EDT)
From: Jacob Thompson <jacobT@beta.pyu.ca>
To: <io-uring@vger.kernel.org>
Subject: CQE repeats the first item?
X-Mailer: mail (GNU Mailutils 3.5)
Message-Id: <20251005202115.78998140681@vultr155>
Date: Sun,  5 Oct 2025 16:21:15 -0400 (EDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

I'm doing something wrong and I wanted to know if anyone knows what I did wrong from the description
I'm using syscalls to call io_uring_setup and io_uring_enter. I managed to submit 1 item without an issue but any more gets me the first item over and over again.
In my test I did a memset -1 on cqes and sqes, I memset 0 the first ten sqes with different user_data (0x1234 + i), and I used the opcode IORING_OP_NOP.
I called "io_uring_enter(fd, 10, 0, IORING_ENTER_SQ_WAKEUP, 0)" and looked at the cq. Item 11 has the user_data as '18446744073709551615' which is correct, but the first 10 all has user_data be 0x1234 which is weird AF since only one item has that user_data and I submited 10
I considered maybe the debugger was giving me incorrect values so I tried printing the user data in a loop, I have no idea why the first one repeats 10 times. I only called enter once

Id is 4660
Id is 4660
Id is 4660
Id is 4660
Id is 4660
Id is 4660
Id is 4660
Id is 4660
Id is 4660
Id is 4660
Id is 18446744073709551615


