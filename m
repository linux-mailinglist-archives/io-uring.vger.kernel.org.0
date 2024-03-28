Return-Path: <io-uring+bounces-1296-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED7D89043A
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 16:59:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 771A6B24072
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 15:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF565132802;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QpwTzhmR"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68761131E3C;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711641546; cv=none; b=SthHwCCPdf2dLuO6Y+nsea2QqmqdckKnNKr4yX0Ou82sqdOY7DB9Yd+GBuABN8hDQsnQ/z1deyB2rm8duLBPHdd/ysKJtALW0WZxAZ/ymGhsQs1GnCxhdgu6BucswyNia2pRI76DgPq6bv1jstbL3hxGC6abg0jiSPBEIPs7pGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711641546; c=relaxed/simple;
	bh=AfrCwZ80UJ3Lm4rQSxOz8hzzAx1c2/4P6ahzY46bag0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=u+ntGqRAm4MMSV9XFY/qEy+Vz7GwG38q2fy+r/g1JQleOZq5+v0ElVfVF8f8yWrMpIMvmEZFqGmzqEvKGaUplLY77pQ2jk6DIqbnXWSBhnyu19w4wsWt1eCeoWdTKguPOeBhIjYLbf0NurO0sDV8nAkUfd8yl41pPqf3plBiYfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QpwTzhmR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFF01C433A6;
	Thu, 28 Mar 2024 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711641546;
	bh=AfrCwZ80UJ3Lm4rQSxOz8hzzAx1c2/4P6ahzY46bag0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QpwTzhmR7WGhuLwCx6UXbumllSSE9tYRsKkAr6OihSqnK/6Y+IWXbKQAHDInyuaWx
	 rTDfBmUgfZ98fOScbKZBeaOSEdLQo2wuZrLXIG8wi5b2tQIbL7/LhsLU36tC9m8QLm
	 SKFCwTJclUweEoeigZ8MYMjNltuD31nSRuDh9qMDHtnDayRxWSriEwama62/Ig779S
	 MQkoDfrzF5+8mxp4hKMzkI4AObyj9cvED1J0AMGty75Nvmg2Ic82YbCEIOO6h4wY/+
	 9M1eZBcXQCxM4vr8IdTZKoYYhGv3bb6tZISiHLdtG078zWhQIubeXRMxKYeoMix+OP
	 3/ySCP8cmwVWw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD355CD1288;
	Thu, 28 Mar 2024 15:59:05 +0000 (UTC)
From: Joel Granados via B4 Relay <devnull+j.granados.samsung.com@kernel.org>
Date: Thu, 28 Mar 2024 16:57:51 +0100
Subject: [PATCH 4/7] initrd: Remove the now superfluous sentinel element
 from ctl_table array
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240328-jag-sysctl_remset_misc-v1-4-47c1463b3af2@samsung.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=936;
 i=j.granados@samsung.com; h=from:subject:message-id;
 bh=dgUaKeQvY6Yod09xLYXFtRCigrPjq/BXAkqZRZrGl5Y=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGYFk8XUCfilPNsCftny+5XBz8vuxkpLL6JS7
 SCj0hqJr2zVAokBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJmBZPFAAoJELqXzVK3
 lkFPpf4L+wRgtVGVBHjTE3dn5OJC+qANHV6TvS+aBE93+XlWcxZos/8ML4JUmXrCqyDX+EjaEmt
 Bl1MIWQAVqLXLuV7NDHWaNzl/KaCn7lS4MToV9Ele72KR+KWBLrnjQ/I+5IQf/JDUlRkkrcBNbS
 552foz839UfCmsc3qOa6OcB6/xYB/gBK5DxflSgUd+Ziu6Ae7iaojNn+RGbv1ZDklEFh/f8/jpD
 UqCAWxXD2JyYCZsEEpmsCmkOQB8efRr99QTCROusfn8mUMush1Bxod1cPFXq4Fekw4ycYERCYdk
 T7vpnaafd/mbKKROVnW0INiF64qLruVon1sVyPP7Jz/t2QGRfmb6SFLwTjQweUjiOxn0HPXQchy
 EIundt+krY0mkCcBVyKC6gb5Uo5ccOPPvzY1kjXyAJhmVlp7vjnoX3aUdTxwrpov1YY2pPjzf8J
 YpUSnaTsAtN6NIWpJsNhma0X8Fa3853Wn+ZChtFx+TOxMj9f6Srzl8C2TOGe/baq643G4sE5nC6
 EY=
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

Remove sentinel from kern_do_mounts_initrd_table.

Signed-off-by: Joel Granados <j.granados@samsung.com>
---
 init/do_mounts_initrd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 425f4bcf4b77..22c7f41ff642 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -29,7 +29,6 @@ static struct ctl_table kern_do_mounts_initrd_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
 	},
-	{ }
 };
 
 static __init int kernel_do_mounts_initrd_sysctls_init(void)

-- 
2.43.0



