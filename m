Return-Path: <io-uring+bounces-1298-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38732890446
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 17:00:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A2E21C2CE60
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 16:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDDA513281D;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A973XSxY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921E513248F;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711641546; cv=none; b=kKEekGJut45/DonDX5ikRZXT9zrs8+5ALRAhyqSxxUbFBl61cytJhx8TPbqvv/estgXvLeIv8+KYFbQrypkQ2yqciNDKi2LpMxn2zL6fuuhH2GFr0EdF/3WqS/0PDaA3Mzke9UVRVGAlsOnkZZ8G/6d6ziLpdbyUq71qwImj79c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711641546; c=relaxed/simple;
	bh=HnkZYSjKPCIyg8WyvmAEoZfloM2q2PjF9q/5pIFpJNI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Flu759/0QDyZYTPT+e/x2Ow7OzIu/GFi5xJt0yRhzz8JFIz0MeHbT18HRX9Nw8m6B4TS7u2CHu+SnSS/MfRvOmthSsElzA2WJLcJP6Qn0DKBhmkUfxc/Eba/MCwDjbqSUn/7w39+Yd/tqg9He3z+lapnfwDISqF+z3fgRcMKXv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A973XSxY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1804BC433B1;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711641546;
	bh=HnkZYSjKPCIyg8WyvmAEoZfloM2q2PjF9q/5pIFpJNI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=A973XSxYI/ju15z6W6S+Zrm/5kMUYhxyRNOSEa8BISg+xhHNJ21AhLrRci5V3ezt5
	 G4PNLZaWFIxsggTvEAUzr7l8LgXJZrWARcEwxW+RWbPlxy6NPkYhtZn5WzSQdYEd32
	 2k6vtXt0rxSgNCak/8O3BpjQjaz7zyokbzRdMdeby3m/iZtBDRnqpBVJAYnH0T2YEk
	 S5drgQu716KnCTqX92wTBXKAmLVGguA1A3N3NDZVnH5MvpxA/aAyn9e/KWFEno6BbG
	 0QiuiOTFxrdrskTyW4XxYOTzWCFNfZLvIT7jtscR+Uq232aXtXJlEDxAwXPiJjqEVP
	 uR+bpimr8TZog==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06266CD11DD;
	Thu, 28 Mar 2024 15:59:06 +0000 (UTC)
From: Joel Granados via B4 Relay <devnull+j.granados.samsung.com@kernel.org>
Date: Thu, 28 Mar 2024 16:57:52 +0100
Subject: [PATCH 5/7] ipc: Remove the now superfluous sentinel element from
 ctl_table array
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240328-jag-sysctl_remset_misc-v1-5-47c1463b3af2@samsung.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1263;
 i=j.granados@samsung.com; h=from:subject:message-id;
 bh=JOrcDebyPdeQyVF1o8hVyIGZcNOEUHOhqgwA2b/7KxA=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGYFk8WY7+nF4T/aynBPi+a0SWAqJw+C58bGs
 dIDFmbETTURK4kBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJmBZPFAAoJELqXzVK3
 lkFPtKYMAIWyicivuHYgLcu7kcoKi4dh5VzhBVmU1d1+zzEnR2f4BqPMWMLwExZKwt0v0rPf/iU
 VZqwFLCJUE4M6vX+VueRURT03H99gHyLgGMHwe5rlh/JUKiqlLQVzwaWCGrg4BG8jkIQgCXfv84
 gAArkvSzOc8a35wOKAMKVRINK7w4fuDO5JFG7WGw90+v5WSY50dXGOmigPWIbA7P+EsriFvVDlf
 N7UHpuSG0nytDxusQM71WHX2MxSQ+RTJgscogj75JzJehbmXTDZMtP/iGBTDfeaBRx0b7ETHJfh
 0a0bG+JnXuG4kxqxIV9k8fY5uQ94V09mvexhYMDSoOwKKWEHkwf7t26SYW4VgFtIFSEUyemvxmZ
 tf3YlaL8wMsdBYj/4fwIlc1m9N3DOPv57ze5SEt8ileyVjKISuOlfRioVbFCF+fqVHKqi9zScRs
 kqPhFL/gsIIeNp2Qv4tfJFyeHcFT20yhcmYz5E1RFipwOOD9XwQG8aCNvTZOZ00zy2zfSAJ8yU5
 s0=
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

Remove the sentinels from ipc_sysctls and mq_sysctls

Signed-off-by: Joel Granados <j.granados@samsung.com>
---
 ipc/ipc_sysctl.c | 1 -
 ipc/mq_sysctl.c  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 45cb1dabce29..0867535af96f 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -178,7 +178,6 @@ static struct ctl_table ipc_sysctls[] = {
 		.extra2		= SYSCTL_INT_MAX,
 	},
 #endif
-	{}
 };
 
 static struct ctl_table_set *set_lookup(struct ctl_table_root *root)
diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index 21fba3a6edaf..22ec532c7fa1 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -64,7 +64,6 @@ static struct ctl_table mq_sysctls[] = {
 		.extra1		= &msg_maxsize_limit_min,
 		.extra2		= &msg_maxsize_limit_max,
 	},
-	{}
 };
 
 static struct ctl_table_set *set_lookup(struct ctl_table_root *root)

-- 
2.43.0



