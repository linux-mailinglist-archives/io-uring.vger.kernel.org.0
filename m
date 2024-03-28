Return-Path: <io-uring+bounces-1297-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0932C890444
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 17:00:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68D7CB24218
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 16:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF1E1327FF;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+v1+/no"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7731A132472;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711641546; cv=none; b=fXUJ1HoSXoLQoO+mO0yzFcKOxmAY3bvDQ4NRBsl02lgi+avQmWTEnt9+N+F1Q6KUnoKZeSyZc2qDE5OlU/9JfrArnp5xdgRp6NDRSy0QLLybLE6K0cGNEWQ7Xfc18M9pUgsU0ejK8Ru5lIJw4yfqEJl5J6b4UI/1wVvUUW8UyxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711641546; c=relaxed/simple;
	bh=mM06SAnSuRZUv5Kr1gQkrOle0ZVHR6HF0Jnu4nRNtL0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l9+bvpOCWzjPhcspKXeKHCSN94RUamnnwPNtZzHgkIzX6+UuEfktVF1ZSYDjqPEuSqFQ8MmhbzN7p+8tNbPAmkzXvtaxLEnezE+V3JpF5NbEizPktW+5US1NUwM7t2RfZEw6n74nxcle2qVxYry545ZAjfXoC5dc9xbEaxnWttI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+v1+/no; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52F70C3277D;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711641546;
	bh=mM06SAnSuRZUv5Kr1gQkrOle0ZVHR6HF0Jnu4nRNtL0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=O+v1+/noxeHa2Z29M0Dfz3L7XwTqiI0xSKknYFHgodqhhqIXTlgaF5GJjkqnuAv3L
	 QJxvcu3YYA1qZjmQriQPtlGiApETtmUtwQHVF/mp/WtFQk9UehvOgAJeV6PpbAWgWt
	 02/i+g/f0rWpKPeEEZakfWjZpLF/khrQ+h7tWPfJteywlTTTgyReBJobJ5ExHS2O2q
	 P+uatIB9TfpZ9YCFscfcUjEAexbVtmkvVbscVRBTU0U0R6SWjGJWmJjXG4HSM2sdT5
	 VtY1FnB+Bq7tZ4HXbaYYH7rGNOO4FPxvElyBHUboqVi1ty0+qGhl83aKm0zP/ug6uc
	 /8eNJHjxwny0g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E82CCD11DD;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
From: Joel Granados via B4 Relay <devnull+j.granados.samsung.com@kernel.org>
Date: Thu, 28 Mar 2024 16:57:54 +0100
Subject: [PATCH 7/7] drivers: perf: Remove the now superfluous sentinel
 elements from ctl_table array
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240328-jag-sysctl_remset_misc-v1-7-47c1463b3af2@samsung.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=941;
 i=j.granados@samsung.com; h=from:subject:message-id;
 bh=x6LKxIed1g3mBTsVnM3LyyId0GhLgp5Sc+vsy/qx9t0=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGYFk8b3d2Da02YyON9nng/oh0az7TH1At0Oj
 Klqtpadz8QDfYkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJmBZPGAAoJELqXzVK3
 lkFPn8AL/RQuAkZvqODJOaCfSxnffeO8fIdKo3HY6jpLrbB1T2bwX+NMLubJdUp3yENm7YB8nRa
 WW22oyyDlvKBzvMdpZd+FKjXo7UBi7qchJGagofe3xiSIEGW50zF5NJDsM7ktMH5gzkhzIXDn2y
 zr/ABmufu4M7Zp2Wr9jVGv4y27IaAVDyFc4zrPnoSa0mN49bPR3NDQWuqqdYJEL6TmQnN2pKz1K
 wTPVnaqmhRdvr5Rjm7bltaHte6Bc8+h5J14i2UXK1jWSg1QYCATTJjpTGopxecIhWetPhrcfO1l
 3sSGhEU/sq2scZklB97vertazO6s46/yNljcLygRX2jL+HciVVcAOzhjZZMUQWAqUDPhCH5PQyL
 oF5sSgTDRjbTSNQpMGp+Zz4Le+f0MYjgkudGjGozgrNAA/i//Ct6jR22lj9qFmZGqe9IxsUEDiI
 mlqlj7Zr6yMfYyLS/gGgRPGvV1D6kyV9cMFEdPnBexcqwE/4lVrh9+wu+JqVoOoY6+a/ZCRcCN7
 k8=
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

Remove sentinel from sbi_pmu_sysctl_table

Signed-off-by: Joel Granados <j.granados@samsung.com>
---
 drivers/perf/riscv_pmu_sbi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 8cbe6e5f9c39..5aef5a8737b2 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -1043,7 +1043,6 @@ static struct ctl_table sbi_pmu_sysctl_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_TWO,
 	},
-	{ }
 };
 
 static int pmu_sbi_device_probe(struct platform_device *pdev)

-- 
2.43.0



