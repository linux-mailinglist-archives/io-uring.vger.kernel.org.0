Return-Path: <io-uring+bounces-10290-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 803B6C1DEE3
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 01:39:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C16601892D18
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 00:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842481E7C34;
	Thu, 30 Oct 2025 00:39:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from bolinlang.com (unknown [155.138.147.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E35517C77
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 00:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=155.138.147.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761784786; cv=none; b=VuJpw1l5aeGeYYUhltYbIi787zLpQfkwEy7gR8A+Vr215t976bdQnIZDBaWIpuxFvyRSJK1wRXqAiAIampEDZPhZ6SY/zy8rBKxemp1Qg0a+qqawCvE/Po1q576zmwQHvCnKjrNOqMNUYcfrljNuUfySrRNpNTp8bn5JN1/d5dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761784786; c=relaxed/simple;
	bh=+0TG/WYyC44yH3Lrvjsw0Q4tqoXF6FEJEpAKRlyG/go=;
	h=From:To:Subject:Date:Message-Id; b=WMdwMWuHAJq9sg29tO+q+AbezhUClob0QO9vG0NTeV3E89a75U0cPlvp+Rox8KoBtQ1+at+cTCPq5jd6IySg+XZuGzTgbEUP/7U+tV9yaKRBhUV7G/lF/NkIFgbDJ94XLhUIO1sp4p7a0vLNwGCVLtZE4wSyC5Kh1wPbj3EdrdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bolinlang.com; spf=pass smtp.mailfrom=bolinlang.com; arc=none smtp.client-ip=155.138.147.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bolinlang.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bolinlang.com
Received: by bolinlang.com (Postfix, from userid 1001)
	id 88F8D17C155; Thu, 30 Oct 2025 00:32:36 +0000 (UTC)
From: Levo D <levoplusplusio@bolinlang.com>
To: <io-uring@vger.kernel.org>
Subject: Does io_uring_enter have anti-deadlock magic?
User-Agent: mail (GNU Mailutils 3.19)
Date: Thu, 30 Oct 2025 00:32:36 +0000
Message-Id: <20251030003236.88F8D17C155@bolinlang.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

I'm using io-uring through system calls (I am *not* using liburing)

I tried to deadlock my code intentionally, but it's not allowing me, which makes me think I'm blocking incorrectly. I submitted a few commands (open, stat, reads on files, a read on a pipe), and on purpose I didn't write to the pipe. 

I called 'io_uring_enter(fd, 0, 1, IORING_ENTER_SQ_WAIT, 0);' in a loop, and my logging says my submission head and tail are at 13, and my consume head and tail are at 12. Then I call enter, why is it returning without processing anything? I understand there's nothing to do because I didn't write to the pipe, but shouldn't this block? 

I called io_uring_setup with 'IORING_SETUP_SQPOLL | IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_NO_SQARRAY'
I'm not sure what else people may want to know, but how do I block until there's work to be consumed? Removing the IORING_SETUP_SINGLE_ISSUER doesn't help.

