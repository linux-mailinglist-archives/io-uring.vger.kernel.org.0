Return-Path: <io-uring+bounces-284-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95CDF813CAB
	for <lists+io-uring@lfdr.de>; Thu, 14 Dec 2023 22:34:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BD9628235F
	for <lists+io-uring@lfdr.de>; Thu, 14 Dec 2023 21:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB1E68B9A;
	Thu, 14 Dec 2023 21:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Fu+beiHV"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615BB5F1E2;
	Thu, 14 Dec 2023 21:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7z3XIWKiQRXINTdgZuNu80jE2Rb8fh/bbs66WhEruCg=; b=Fu+beiHVoGWcFtzO1l1v442y+G
	ZADPfDlPm1kvo7RrdZoRnKoAF5Y4VI18NANwACar38pRjLoW65lkgyU2ScZFE6b9iiF8vn4mxQ4cY
	H3hpQ6VX3M6idL2rB6fuD9ky0HgJ9x5RuE/hQK2SG/edPXpL3k3xOw+HuoGHYujgdnL+IK1fEgwd4
	QW4gOnqCMlBBtQhsAg9qhgkl479tU/seoO9vOc5zJHDdJuW3L2QFzm1kabCJWHsQYnTmwG0EDst4C
	X3nO/ayP9FrIDXH6LpJ8P7Vgq1ZzkHVq+oIV+8zi19ftKujxKXIzZcODKYtbtgJoeRvk6M1HlPGC/
	utPAIY8w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDtLM-00CSwl-10;
	Thu, 14 Dec 2023 21:34:08 +0000
Date: Thu, 14 Dec 2023 21:34:08 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Breno Leitao <leitao@debian.org>, Jakub Kicinski <kuba@kernel.org>,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH] fix breakage in SOCKET_URING_OP_SIOC* implementation
Message-ID: <20231214213408.GT1674809@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>

	In 8e9fad0e70b7 "io_uring: Add io_uring command support for sockets"
you've got an include of asm-generic/ioctls.h done in io_uring/uring_cmd.c.
That had been done for the sake of this chunk -
+               ret = prot->ioctl(sk, SIOCINQ, &arg);
+               if (ret)
+                       return ret;
+               return arg;
+       case SOCKET_URING_OP_SIOCOUTQ:
+               ret = prot->ioctl(sk, SIOCOUTQ, &arg);

SIOC{IN,OUT}Q are defined to symbols (FIONREAD and TIOCOUTQ) that come from
ioctls.h, all right, but the values vary by the architecture.

FIONREAD is
	0x467F on mips
	0x4004667F on alpha, powerpc and sparc
	0x8004667F on sh and xtensa
	0x541B everywhere else
TIOCOUTQ is
	0x7472 on mips
	0x40047473 on alpha, powerpc and sparc
	0x80047473 on sh and xtensa
	0x5411 everywhere else

->ioctl() expects the same values it would've gotten from userland; all
places where we compare with SIOC{IN,OUT}Q are using asm/ioctls.h, so
they pick the correct values.  io_uring_cmd_sock(), OTOH, ends up
passing the default ones.

Fixes: 8e9fad0e70b7 ("io_uring: Add io_uring command support for sockets")
Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index acbc2924ecd2..7d3ef62e620a 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -7,7 +7,7 @@
 #include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
-#include <uapi/asm-generic/ioctls.h>
+#include <asm/ioctls.h>
 
 #include "io_uring.h"
 #include "rsrc.h"

