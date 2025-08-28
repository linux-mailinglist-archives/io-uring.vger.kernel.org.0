Return-Path: <io-uring+bounces-9368-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B504FB3923B
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 05:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 662767C2D4A
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 03:33:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD5D917A2E1;
	Thu, 28 Aug 2025 03:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="QYKK6lNc"
X-Original-To: io-uring@vger.kernel.org
Received: from out203-205-221-239.mail.qq.com (out203-205-221-239.mail.qq.com [203.205.221.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BF313D503;
	Thu, 28 Aug 2025 03:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756352023; cv=none; b=FCgAhOMowK7tKve/wTINqi9Mh0VHRDI0qwQHHKYd2ek+oGgHupdMZ09l7makJxx4ZZPRS/nsVwow2giQecCUSJ+teLrUzI469+H3Zql72tLExoYGg4ms3X5AOvxmVhehBv4gTBpjtVv5508FUa+2tZN4+U2wSapZ81L905Hf6qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756352023; c=relaxed/simple;
	bh=BMAGjRMk4Z3TjouD68EjoYToYs9haeFZiFaVppJm+XA=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=mREpUQCO8Nz/qb7wOCCD38iYs4PDnmJz2cbXm9bR+XveiOznf0QwsgJFHz0Yp2npLXzjIWMLr7r8ewlrxkeYHBCoR5ZzXxUBpJFB1W5Y7AqSZB4GzuR/VgiUwhcYXtl2btliifhjqh1Rb+EQU9AmPQQZ8DVSGuitu1Ioq9JRAEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=QYKK6lNc; arc=none smtp.client-ip=203.205.221.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1756352017; bh=u1zhF4oSCXVG+6LusvOKKNkPof3RJVhGMntnsj+s+1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYKK6lNcfUyMS2DXomL8yP06dzLwoMuRlzqhJHe9mI6vP2jxnBlX1/mcJkWqJ7eWq
	 Pt7a0D3PeDyfjlmxgvIpZlFBR4Re19a5896eB0ILIt6DjIrFxJUumSfo5EqKUaC/+H
	 airj3n993krKMbycXifpRciD/GSRC7rInO9HilmE=
Received: from nebula-bj.localdomain ([223.104.40.195])
	by newxmesmtplogicsvrsza56-0.qq.com (NewEsmtp) with SMTP
	id 6E0888BA; Thu, 28 Aug 2025 11:27:32 +0800
X-QQ-mid: xmsmtpt1756351652ta9x299eo
Message-ID: <tencent_2DDD243AE6E04DB6288696AC252D1B46EF06@qq.com>
X-QQ-XMAILINFO: NGZp1yYNf7Y+9GzPxqsNlS6AYhGbwwFB5CviZmlZJVmcbrpS9/OK+Dw/zgqzHX
	 6+5nr9SgFDCxH0x+PRGPCBF4pkycXVY9nYdwiUue6ACSsAYjv1g/uN/ZLUeyfajQEg7zoZ8BlVXb
	 HBZ0UMpM5/94LQTBgdrAy6jurk2p0cjr7iSwwpJDhhIU4Egc9StM9mCxpKZUOHELk79zsM5zJzSd
	 lX3aPYRIfbMRSAwbXf0vNPqfMXtvyux72R4QShSoSV5WsrJKUy0UJon3ofzq0xw/E2bvjBSKLhxw
	 bq9Z1aEhbcIiWf/rpyT6ENccAoCcJE0GhkpzYrvL4mAnz1ei6ots4Og0C0JK2KORfu+3lCdGnbI+
	 FGPc3F66xS7flDuTrZwxa9zGMXx1lUWOH2MPeX33+0virMr/cNpu42HfH1frcu9yUD9atRkFghlX
	 rL5kyPwFc0sb176V5SYw63D7H+onYvuNdI8CtCKvGRf1QpdMoy5+4AekM1a/yFrZvS6j71znv+ke
	 jebWJHiMz2Q6Pk58pCEzfsHNYhHL56TI3SqYtheZZzG2xeMd7rrOuyv9t6nhUPblrj8xRDlRFHuX
	 ZMo0lNwr+9XOpfyY235BDjMz0z5Ksw6kesXk6jyaIeirY0Z22knSdK8XFAitHdRY/l6MH3nc0ClL
	 oU3BLyv6BJ2g+ZsjTMZ2wQg4+tcHtkXaEWSH0cQcX5RZxYsrGj8w3KsIjusWlH7o5xBg8p1xKPzq
	 e52KCW2QqlazO8RJaY6B0lMoNHeYEpzX1eMV2YH5IwRFpAatar6/ZY5VreNa/x9PfFH36RaA2pAg
	 8r6e5wdQjZ4vRu35TurUWt9Hy0UlkcjqbugirVI4FnuZrHj5be8XS51AwEXcDnEBinKXV2zqsU1i
	 yUUb7sDnDcDL9Hb5m1Osai6Pfq7YP5uRFeouSc1uyaD9iNix5asUABFBAVGiH8r1yM1JV9o6X1f0
	 /RXGmsWtABMkMgxATYoMxZy3Mk+j8ZoDiEKrhGYysWih5fuhOElMwbtsXuXA5F5+aK3teg67Fn2x
	 2wVjiKinU6uMjrkndvIQa8czMTCPBfZRe/fivscMRKg9SHjI/I490KCFFPWA54re4ELUmy8YpfsG
	 4AgF+DCf/2TOsClQYKRcGPIQzmPg==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
From: Qingyue Zhang <chunzhennn@qq.com>
To: axboe@kernel.dk
Cc: aftern00n@qq.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring/kbuf: fix infinite loop in io_kbuf_inc_commit()
Date: Thu, 28 Aug 2025 11:27:32 +0800
X-OQ-MSGID: <20250828032732.101494-1-chunzhennn@qq.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <8f4a4090-78ed-4cf1-bd73-7ae73fff8b90@kernel.dk>
References: <8f4a4090-78ed-4cf1-bd73-7ae73fff8b90@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for taking care of this report!

Regarding tags, it would be nice to add a 
'Reported-by: Suoxing Zhang <aftern00n@qq.com>'
tag too, as this report and reproducer are
developed by both of us.

And absolutely, please feel free to use our 
reproducer for a test case! I'm glad it can 
be useful. Your version with idiomatic 
liburing looks great.

This is my first contribution to the Linux 
Kernel, and I really appreciate your patience 
and quick responses throughout this process!


