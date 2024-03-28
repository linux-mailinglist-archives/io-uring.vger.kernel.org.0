Return-Path: <io-uring+bounces-1299-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A03DE89044A
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 17:00:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BE4F2944AD
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 16:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 192681353EC;
	Thu, 28 Mar 2024 15:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fKgqsRfH"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5761327E6;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711641546; cv=none; b=do36iJrDsIsimtaqYC98ot3HFzfzv5p/knBn3YRzLLPW8hlEijTk1cjuQJjTzURqcFgM9Kg+EpMx/wKou+VYvz96wBIOeyb5qKFrjULzqS4UJm4WodxtUAE2PGuk7OFM9GKRnu4Z5tMdV43xw4b4a4D1Zbdv+c1v/uwefIFF5lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711641546; c=relaxed/simple;
	bh=43XallgnzSLZhguS4VWitQ2Fcw54C6K2Ncxf6+7BSRI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RtHLcgbgrBp/5JWs2pdZL8AuGuI2YZbyRHs0+F2GZ2dxB1MwuXfYc7vtP+cnMSwwi130hK9zNKdcjqIh9cE9MbvCmKsvoePsQtK0qgoeOUlDhx9fse4fiDOt4VVz0CORh5/TRzUq5nWs4gEsj2Ps9tgQonEhxtNp9W5sgm+5Cbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fKgqsRfH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F74AC43142;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711641546;
	bh=43XallgnzSLZhguS4VWitQ2Fcw54C6K2Ncxf6+7BSRI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fKgqsRfHUCx6aBs250bwLQxrFH3Lt/DFlxIi8K/W26txiNrqxJep69UlidZtSxnVn
	 k7iSc3CfIlmPR0UbHZqUpdqicpM92Ww6KLLDJoV/Qry79ox2BJ1pTf+muRfMeS23BZ
	 p4i2qIH1mZzObREbjVuGDqhXLNAMEJnhF5aQtvrBlxljhYj0EgbZmcQ0Dp4zfo04Me
	 C+tPRd7A842f/XiH5yoJ14adYy7E/MbzAGR7hwyIzfLBoLIe+y1x820s9EyNVwrNBO
	 yN40GaJTPuM2NJdmotsIDLpSQg7ygtHrme3rJNFUudKpg+rfSWF+pZEf5nxlBBQ4AD
	 uBTUPLvTuJ9ig==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23321CD1283;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
From: Joel Granados via B4 Relay <devnull+j.granados.samsung.com@kernel.org>
Date: Thu, 28 Mar 2024 16:57:53 +0100
Subject: [PATCH 6/7] io_uring: Remove the now superfluous sentinel elements
 from ctl_table array
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240328-jag-sysctl_remset_misc-v1-6-47c1463b3af2@samsung.com>
References: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
In-Reply-To: <20240328-jag-sysctl_remset_misc-v1-0-47c1463b3af2@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <naoya.horiguchi@nec.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, Kees Cook <keescook@chromium.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, 
 Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, 
 Joel Granados <j.granados@samsung.com>
X-Mailer: b4 0.13-dev-2d940
X-Developer-Signature: v=1; a=openpgp-sha256; l=866;
 i=j.granados@samsung.com; h=from:subject:message-id;
 bh=fE/NZmB4pRzGY5dsPYrxUBO9ZoOr+5OhzOId8tu7QTs=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGYFk8bmxZGot17fJWYqTrmMAyaWIBy9sBUWG
 aHGw/deIYoGrIkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJmBZPGAAoJELqXzVK3
 lkFPPqgL/j0Ld5LzYavMO9DP8fYz7mNmdGMwclTzF1+obs3fJGdIR8B/yld44GUGxZL131jYcMG
 rHpj3oVP4UfarmvGW9AI2OimEgbMMWPFc1ZmFkY/CrgzinI5TjytwY+i2r2AavTNWRMT7zcLAQf
 Vdq3FZfdbZ+JpLovP5iiwvyb2Cd96kkzD/e4Oa1nyGkxFYPOAxO80j4LDy7GfxL6+9UIIGGFZv4
 DaZKSWK1X2UrZOmVK1qgRXej8kHjlVxhl53AUNyQ+rFa5VbLRO405J68WgjMP32GJMISyVW57h5
 ocoprGgLHRyg4LpPfHIL4yohqv2RIyMpZPgpoTW5dpYZqFRcURac/bVmRZRQx5wpJjjEowDk45c
 H7nH57Hsk+EcGqekPtpXVg4vLZuvXOmv5CConYIlM2ttcTJItblMO8RCNiIqgE21QlZc99oAynV
 a/OGIOEYnrYir1BnHvhD/LINHxzOFzcChPE2iJr9kbQNFsz7wr+soDr8zShfiwcyJ1Ika8nd5s7
 ik=
X-Developer-Key: i=j.granados@samsung.com; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for j.granados@samsung.com/default with
 auth_id=70
X-Original-From: Joel Granados <j.granados@samsung.com>
Reply-To: j.granados@samsung.com

From: Joel Granados <j.granados@samsung.com>

This commit comes at the tail end of a greater effort to remove the
empty elements at the end of the ctl_table arrays (sentinels) which will
reduce the overall build time size of the kernel and run time memory
bloat by ~64 bytes per sentinel (further information Link :
https://lore.kernel.org/all/ZO5Yx5JFogGi%2FcBo@bombadil.infradead.org/)

Remove sentinel element from kernel_io_uring_disabled_table

Signed-off-by: Joel Granados <j.granados@samsung.com>
---
 io_uring/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5d4b448fdc50..fe3c93e21e2c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -169,7 +169,6 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{},
 };
 #endif
 

-- 
2.43.0



