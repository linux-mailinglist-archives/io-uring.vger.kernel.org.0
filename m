Return-Path: <io-uring+bounces-1295-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BB07890434
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 16:59:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 256132921C1
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 15:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79BEB132484;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rC+cSWQa"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFC9131BC2;
	Thu, 28 Mar 2024 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711641546; cv=none; b=dWHuj3LubXjYYehmn7/YB0cO7pk6vEkRhaIaZN232F5OS4tFax489If781uDTeJS/N+9ujG+Mk+go7jgmwttGoHVJwaNMRs4GyQTAX0ytkGXeD5uzFqwjSoFQPj84o63yIS+iAuKj46uuS9X2Yu53TdYdwO+3I6TYceH2y1mMBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711641546; c=relaxed/simple;
	bh=w/CAagCs93tnwOISaREraUes9B75EU7uQd/GrX75vJ4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c3avkX4iUby6IwrjPt69q5/3a7nzFUaOUnPGQcdSJoh6qnQVn9rrE0AY4pIE342fYLPbzCqSpJQ4yJrB+kUmwz7bdHHXUOhZyu5y4gfLPe946MYzvAmbisK6hg2QvY9R5fFDnlrICugAa9DJWpDTZOQzn7OqyQq8FmgtCE7CYaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rC+cSWQa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id C150EC4166A;
	Thu, 28 Mar 2024 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711641545;
	bh=w/CAagCs93tnwOISaREraUes9B75EU7uQd/GrX75vJ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rC+cSWQaCVaIgFz+KeWgwqswKUa8HnduLtkqZzAPwFFb14jZuXZ9z7qBTzh7na9JS
	 4V+5V8bkh4Zo1vtFt6wL2mdo9OwzBhkto75XnOEIzmeixScBZYPvR6DETzowMtiLV0
	 Bom/CXB456RgDjKFiZ5VJHiLA3ZRIW2p7Tw3RPdOEaQB9vf3Bw1qOQd/OEW6BUbuBM
	 HfMUSPdl/bztabiGFkLHcIvbKgvMacaCktlmCXi9YGgQhWi0a+5P7DPZ30NpYsAv8n
	 sAg/FCFFpdhDZFJbUxFUp8sDopsYyyhRs1qa163ynn0i+CjZ+ujFMfHYzFlhQ8Qn9w
	 2Gy6wKhIFR5Yg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE43CD1283;
	Thu, 28 Mar 2024 15:59:05 +0000 (UTC)
From: Joel Granados via B4 Relay <devnull+j.granados.samsung.com@kernel.org>
Date: Thu, 28 Mar 2024 16:57:50 +0100
Subject: [PATCH 3/7] crypto: Remove the now superfluous sentinel element
 from ctl_table array
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240328-jag-sysctl_remset_misc-v1-3-47c1463b3af2@samsung.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=843;
 i=j.granados@samsung.com; h=from:subject:message-id;
 bh=PsRDF4iHKhFg1x0ZSp/XUca2d9GI60WeSwOtfnTJcKU=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGYFk8Sn6Fir1TrXxzcrJeA20C4FmUqvYJhos
 nJVoW2ScjI/aIkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJmBZPEAAoJELqXzVK3
 lkFPCAQL/0dpS5DBrYR+5mZqJK2pQcAA0QQqBm8y2Tq391CKvm30tew2wtkScDHoRiyul8QyzWC
 D5/YpkG8dWaCHAkj+HOhXbtB8Rfi/cf4BchHZ0+cRj41OMxCePLa+yG5/nfgar5oc2nXN2gcrYK
 ntIUgfJExh6PEDQXr6Xk4RK675RUtgLxch2ojMfz4S3qe9J4DmkUPtR+VQs52+lmteyOBMwdh8/
 DgmBLGsimvyq20RbSHwzZRPUwk7y6YTCDhKz6oLyB97eOjbuarD4FwBd1nLHwpS1su80Ul8kYu4
 OmnEs9ucp2Ne9WIybw3frLNgnmJRfjHa3nQalXpp7yFOENLnS9QK2RvrYCmjKIep2FZIA7t5Jvr
 0Iod9HPfrNohN1XK0AjqT+ihZTjhFd8fSHnf2YnS/oSYtZf1kJuljhIFoLNl3PKVsRUHhhUHlHC
 dW+jquu6DydspJi9zZEyoeHoSbs1S2+5jvkBGfrXYVn8pQWjKMpvfOWKuIw6sqQuxre2VZIjR26
 SY=
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

Remove sentinel from crypto_sysctl_table

Signed-off-by: Joel Granados <j.granados@samsung.com>
---
 crypto/fips.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/fips.c b/crypto/fips.c
index 92fd506abb21..8a784018ebfc 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -63,7 +63,6 @@ static struct ctl_table crypto_sysctl_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dostring
 	},
-	{}
 };
 
 static struct ctl_table_header *crypto_sysctls;

-- 
2.43.0



