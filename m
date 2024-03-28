Return-Path: <io-uring+bounces-1294-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5647889042C
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 16:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAA5C1F2316A
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 15:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41BD8131BC8;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmrzuH3B"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0E613175E;
	Thu, 28 Mar 2024 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711641546; cv=none; b=PB99BVHUofCQTMZB6CH7H2WEurUi5xeX2ExHbcjuOuzWLXNPV2sU6UuSRo90qljyeF8EbOm8kI69la6asoraKYUuw9bPBAPkeAUb2UqXxG3IT1kWr8f1FTTzEMl6rJa1Ftq7M2KjIYgx+aCKThDEZxyq90itUcn5UPmA5lJMC1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711641546; c=relaxed/simple;
	bh=8Q9bngJpVYFNnjYWEtmsJFuk+cZjVn0lFU8F/+2wGYs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ubwbU4Mx3MVWwQBFaFz2KnKm/Q6wb2YxGiwqdghZWJH9c/LxrOGdRyKBABwXqxQyEWMph2KhBqNcQRw87lKrub2CAPJw/Di8w4/J+4ItOM7T2aTwjsZ+ugxkOguh5mMpGfoijPiHuDSotv4NNJpuS40RRTs5s5Dzu7m2yeUwhUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmrzuH3B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86BCCC43330;
	Thu, 28 Mar 2024 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711641545;
	bh=8Q9bngJpVYFNnjYWEtmsJFuk+cZjVn0lFU8F/+2wGYs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YmrzuH3BliTwE/0aMbEF+2VcX2UHLIx+m0/yWXRyIVMZrUgJcl1YJw2PyjUdmHwH/
	 ya+t94hVgDN6IgMudg2SFgzwY/QkWU/c5PyvAs3DJONRijbiNBdkjWrkrS9vITZJqV
	 4s04RYKI92TvN21zTvtB2gcOBkXQhkvtli7vl6GfIUBYpv79m9cOqJfIAc3avYKsR1
	 et5Ln3Fn7tFgf9EBh6rMXYqfbPYlOC4GV90FtOQv8ksO3NFUmX7aoGpXg35HgC+Vha
	 ym1eDEIT+a1xQaLkltBSuLe9+BSHO9hWQEAyYw2P80euDWTYPSyoWKKhYEzU2zRol+
	 iXCI1G6AfuRrg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7384ACD11DD;
	Thu, 28 Mar 2024 15:59:05 +0000 (UTC)
From: Joel Granados via B4 Relay <devnull+j.granados.samsung.com@kernel.org>
Date: Thu, 28 Mar 2024 16:57:49 +0100
Subject: [PATCH 2/7] security: Remove the now superfluous sentinel element
 from ctl_table array
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240328-jag-sysctl_remset_misc-v1-2-47c1463b3af2@samsung.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2166;
 i=j.granados@samsung.com; h=from:subject:message-id;
 bh=MMRfTm4NsPGzunc+jLCBGXNs5d6MSZ7h8iaXBibxUBo=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGYFk8R1UXVA6OVx01bpEwxUOhfTMICbrVR2h
 1f4SggspLYarIkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJmBZPEAAoJELqXzVK3
 lkFPOkcL/iL3V8wwR26L9QEsybs3FPUiCWjpFGJI5kszPVk0Stt5Whqa6ZRa3moK5yHXtROXmvH
 isu58CfDXlwnMMhjVDwBIJZd3E2mAxRS9baf5sTt0gDgfa0r546kRS/vV46bg4zIffFfucqpDvg
 0fbbU/XhggxQ1E6Q2Vx19634oyUaqMW6dcA8Eb+mcpWiNtSXYJE7P54ZWgiJ+2+Q/k9nz7bCClt
 sEf6hL/2xqZg+knPxHu9eD/l1KgNVEmSCLGALUzExhRUHlM0pbydHbqK2OYALSMv/PdEgBKs6Gc
 bcSJHtuhVAopg7QCAi5uPSAsV5kKgSCCSBm2lPmOMiK16fx+3Cjhbr6h8H6SHMOYdFj4mbWCd45
 LuweyC40jgWA9KA9AWJ5GbTqKDsNDBskuxjTGdV56ullhWNEauQL28puh5SoCK+byTFGBI4C3Zk
 idQbenpimWdJS+vXICzHjVOiMZZZeDcJN+nBisWSI5knBOJJhnflKNDQ1lTTBr8PkMV24lIia23
 HQ=
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

Remove the sentinel from all files under security/ that register a
sysctl table.

Signed-off-by: Joel Granados <j.granados@samsung.com>
---
 security/apparmor/lsm.c    | 1 -
 security/keys/sysctl.c     | 1 -
 security/loadpin/loadpin.c | 1 -
 security/yama/yama_lsm.c   | 1 -
 4 files changed, 4 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index cef8c466af80..6239777090c4 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -2064,7 +2064,6 @@ static struct ctl_table apparmor_sysctl_table[] = {
 		.mode           = 0600,
 		.proc_handler   = apparmor_dointvec,
 	},
-	{ }
 };
 
 static int __init apparmor_init_sysctl(void)
diff --git a/security/keys/sysctl.c b/security/keys/sysctl.c
index b348e1679d5d..91f000eef3ad 100644
--- a/security/keys/sysctl.c
+++ b/security/keys/sysctl.c
@@ -66,7 +66,6 @@ static struct ctl_table key_sysctls[] = {
 		.extra2 = (void *) SYSCTL_INT_MAX,
 	},
 #endif
-	{ }
 };
 
 static int __init init_security_keys_sysctls(void)
diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
index 8e93cda130f1..93fd4d47b334 100644
--- a/security/loadpin/loadpin.c
+++ b/security/loadpin/loadpin.c
@@ -63,7 +63,6 @@ static struct ctl_table loadpin_sysctl_table[] = {
 		.extra1         = SYSCTL_ONE,
 		.extra2         = SYSCTL_ONE,
 	},
-	{ }
 };
 
 static void set_sysctl(bool is_writable)
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 49dc52b454ef..b6684a074a59 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -463,7 +463,6 @@ static struct ctl_table yama_sysctl_table[] = {
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = &max_scope,
 	},
-	{ }
 };
 static void __init yama_init_sysctl(void)
 {

-- 
2.43.0



