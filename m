Return-Path: <io-uring+bounces-13603-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id qNg0BGUwIGp0yQAAu9opvQ
	(envelope-from <io-uring+bounces-13603-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 03 Jun 2026 15:47:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E966383A1
	for <lists+io-uring@lfdr.de>; Wed, 03 Jun 2026 15:47:16 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ehijjyYT;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13603-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13603-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=ibm.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 38226301C3FE
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2026 13:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 775513033CC;
	Wed,  3 Jun 2026 13:33:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED30F2F39B9;
	Wed,  3 Jun 2026 13:33:41 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780493623; cv=none; b=QvKOMcuuRpHdUqmdVhJcs5kJCZlYrpOTW/a57q0R8WfNiTuJ+BBJ7r6moWvkoZ+alnlcdiA+TpTiLf/iIYvjrbWO4KFhXes+/w7LjzBi5nx4FQFBZMwxg+GCF2EKDH/J6cbYfgUZWG6jPtdh9rseN3hLAiABc2fp/SBcfYzBHLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780493623; c=relaxed/simple;
	bh=W7s7wxfcHO35roXSci+Uzh7bnfE9I9tNRRgIg6dlsf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzDKjEEAtpbUHaeRfXP/oQdh0xE/CTBJG9z/UuK+F8Ax0FzitFW2nYTCYqusoVTwYBv+cTxslMWEf9c60GPDcghM+ZxMuKfvayQCRYPyBX6ShSBaBva5zV3l2gDBr5NDBHv6ks/imEqZW0ZbpcFNHexRUcIohVZ+ijaQmivG720=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ehijjyYT; arc=none smtp.client-ip=148.163.156.1
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6537UL8j845711;
	Wed, 3 Jun 2026 13:33:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=PrPvpzfpwtOEes92N
	NPIxU3eWl0EAkKMINiHdG31bwM=; b=ehijjyYT0OtJgPOS8Cgr5KGwC4af6PVSc
	FFj0lD1uvvS280h9HXcvs1VyVuk7jwFuFYkPwXXhzrOAeziQCsM4QBuTGqivLKRe
	Hq+Ba9dxy0eSeyd0qX0RzS+XiSlNLahLfhrwTMDb4IqNeW+4oib3k6w5rMEKxwSN
	ZyKjymjttFjb586QX8z0gYfT6avGeMF2tegzGdw0pS1mH8WQOJ6QbyqCzMU/diAF
	pGkfM4Lw/k+aDhsPeJfNLWTghCpD6IbRwPGlNicb53sAGFOjeWMq9Jj9R+mgTeJs
	nmmsQP4FsVbMklvESdD0JR/YB42cPqm57ioZvvUY/D8mr/5yjQ90Q==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqjqb37m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 13:33:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 653DO5r4011319;
	Wed, 3 Jun 2026 13:33:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ega7qgj0v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jun 2026 13:33:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 653DXDIO31064378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jun 2026 13:33:13 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63D4020043;
	Wed,  3 Jun 2026 13:33:13 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 074E520040;
	Wed,  3 Jun 2026 13:33:13 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.155.240])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Jun 2026 13:33:12 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: devnull+demiobenour.gmail.com@kernel.org
Cc: acme@kernel.org, adrian.hunter@intel.com,
        alexander.shishkin@linux.intel.com, ardb@kernel.org, axboe@kernel.dk,
        corbet@lwn.net, davem@davemloft.net, demiobenour@gmail.com,
        ebiggers@google.com, edumazet@google.com, herbert@gondor.apana.org.au,
        horms@kernel.org, io-uring@vger.kernel.org, irogers@google.com,
        james.clark@linaro.org, jolsa@kernel.org, kuba@kernel.org,
        kuniyu@google.com, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, peterz@infradead.org, skhan@linuxfoundation.org,
        willemb@google.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
Date: Wed,  3 Jun 2026 15:33:12 +0200
Message-ID: <20260603133312.12848-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: iSjO_QN_WYH1Co56C1ey6R3URohRWB3y
X-Proofpoint-GUID: s_kRT_T1wq9TI34aElrat1UiQutSsMDs
X-Authority-Analysis: v=2.4 cv=bcVbluPB c=1 sm=1 tr=0 ts=6a202d1c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8 a=Qr0bbqx5VTdTA2CgjBkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDEyNSBTYWx0ZWRfX2hLLU66OhwOH
 xvtV2ecyk7GFvmfFoTnlUVD+KxsIQgROhU/m0nid/cngCgqbFihcochevVYCqnnSJ8cy6qW4kq3
 yFrNygcdoMGDngGQRotXcQiwuqJkTr+WT53EOCGMi3w9FJBGzBXAgleAu13LeOHe5/IX6nRWAT0
 tKQDQ8xO0M+0WXOCahK5aQ4d6QIwzGCRZRCr1oxbO7iQb+2SApRa/1QKmFZzSswz/T42AF1QH4R
 pmkaVPNOZNFwSCH2vgnFScUaH0Tpcq85tLz40jLCDoi3+We0gUGDjHW6iZ/Y9TLZUZILPXIAm1v
 OJvtx2GtaX7Nv8Wkfghlss8J2PcqlCOwDuXFpoMus5LGPM9ovjdox/GIdhAp+jxPxx0y6jDtwkS
 F55ZtIJNOu9EXHlOEe6/mATBDBgtSN0owu4PrkgGZ6i66f0wB0EGqfjncwTCTknkVEndicgKFJb
 9pvpVurIUXD3vOK29Ig==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 adultscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606030125
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,intel.com,linux.intel.com,kernel.dk,lwn.net,davemloft.net,gmail.com,google.com,gondor.apana.org.au,vger.kernel.org,linaro.org,arm.com,redhat.com,infradead.org,linuxfoundation.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13603-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[freude@linux.ibm.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:devnull+demiobenour.gmail.com@kernel.org,m:acme@kernel.org,m:adrian.hunter@intel.com,m:alexander.shishkin@linux.intel.com,m:ardb@kernel.org,m:axboe@kernel.dk,m:corbet@lwn.net,m:davem@davemloft.net,m:demiobenour@gmail.com,m:ebiggers@google.com,m:edumazet@google.com,m:herbert@gondor.apana.org.au,m:horms@kernel.org,m:io-uring@vger.kernel.org,m:irogers@google.com,m:james.clark@linaro.org,m:jolsa@kernel.org,m:kuba@kernel.org,m:kuniyu@google.com,m:linux-crypto@vger.kernel.org,m:linux-doc@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-perf-users@vger.kernel.org,m:mark.rutland@arm.com,m:mingo@redhat.com,m:namhyung@kernel.org,m:netdev@vger.kernel.org,m:pabeni@redhat.com,m:peterz@infradead.org,m:skhan@linuxfoundation.org,m:willemb@google.com,m:linux-s390@vger.kernel.org,m:devnull@kernel.org,s:lists@lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[freude@linux.ibm.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	TO_DN_NONE(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[32];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.ibm.com:from_mime,linux.ibm.com:mid,vger.kernel.org:from_smtp];
	TAGGED_RCPT(0.00)[io-uring,demiobenour.gmail.com];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 55E966383A1

> AF_ALG is deprecated and exposed to unprivileged userspace.  Only
> use the least buggy algorithm implementations: the pure software ones.
>

I thought AF_ALG is marked as deprecated but still usable. This patch
now actively disables groups of crypto implementations. Also it just
assumes that all algorithms which are asynchronously implemented or
do not have a fallback are to be disabled via AF_ALG.

There are may reasons for not having a synchronous implementation. For
example if you need to fetch (asynch) some information from a HSM before
doing the job of the algorithm. Also all secure key operations can't
by definition run directly on the CPU but need to be fed into some
hardware. Same is true with just acceleration - and acceleration via
special hardware (crypto hw, or AI hardware for example) is very common
on platforms priced by CPU cycles.

I also can't find any arguments for the statement 'Hardware accelerator
drivers are frequently buggy.' Does this mean that the linux kernel
from now on will not accept any hardware accelerator drivers any more?
Statements about code quality should be addressed to the driver
maintainer but not lead to tagging of groups of drivers.

I can understand that the AF_ALG shall be deprecated and fade away.
But this patch out of the sudden disables the long standing AF_ALG
interface at least for testing purpose and causes some failures in
the s390 crypto test area without any chance to react at all.

> This removes one of the main advantages of AF_ALG, which is the
> ability to use it with off-CPU accelerators.  However, using off-CPU
> accelerators has huge overheads, both in performance and attack surface.
> I have yet to see real-world, performance-critical workloads where using
> an accelerator via AF_ALG is actually a win over doing cryptography in
> userspace.
>
> If using an off-CPU accelerator really does turn out to be a win, a new
> API should be developed that is actually a good fit for it.
>
> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
> ---
>  Documentation/crypto/userspace-if.rst |  7 ++++++-
>  crypto/af_alg.c                       |  2 +-
>  crypto/algif_aead.c                   |  4 ++--
>  crypto/algif_hash.c                   |  4 ++--
>  crypto/algif_rng.c                    |  4 ++--
>  crypto/algif_skcipher.c               |  4 ++--
>  include/crypto/if_alg.h               | 14 +++++++++++++-
>  7 files changed, 28 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
> index ea1b1b3f4049fd4673528dc2a6234f6376a3489f..b31117d4415dda6ad6ca36275e615bec7df9552e 100644
> --- a/Documentation/crypto/userspace-if.rst
> +++ b/Documentation/crypto/userspace-if.rst
> @@ -9,7 +9,8 @@ symmetric cipher, AEAD, and RNG algorithms that are implemented in kernel-mode
>  code.
>
>  AF_ALG is insecure and is deprecated. Originally added to the kernel in 2010,
> -most kernel developers now consider it to be a mistake.
> +most kernel developers now consider it to be a mistake. Support for hardware
> +accelerators, which was the original purpose of AF_ALG, has been removed.
>
>  AF_ALG continues to be supported only for backwards compatibility. On systems
>  where no programs using AF_ALG remain, the support for it should be disabled by
> @@ -59,6 +60,10 @@ Some of the examples include:
>  - CVE-2013-7421
>  - CVE-2011-4081
>
> +Hardware accelerator drivers are frequently buggy. To reduce attack surface,
> +AF_ALG now only provides access to algorithms implemented in software. This
> +means that AF_ALG no longer fulfills its original purpose.
> +
>  It is recommended that, whenever possible, userspace programs be migrated to
>  userspace crypto code (which again, is what is normally used anyway) and
>  ``CONFIG_CRYPTO_USER_API_*`` be disabled.  On systems that use SELinux, SELinux
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 8ccf7a737cd6ca9a5d5bf47050c9afea0dfd61bf..cce000e8590e469927b5a5a0ceccfdf0ef54633d 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -181,7 +181,7 @@ static int alg_bind(struct socket *sock, struct sockaddr_unsized *uaddr, int add
>	if (IS_ERR(type))
>		return PTR_ERR(type);
>
> -	private = type->bind(sa->salg_name, sa->salg_feat, sa->salg_mask);
> +	private = type->bind(sa->salg_name);
>	if (IS_ERR(private)) {
>		module_put(type->owner);
>		return PTR_ERR(private);
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 60f06597cb0b13036bc975641a0b02ea8a41ad03..787aac8aeb24eed128f08345ba730478113919b3 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -342,9 +342,9 @@ static struct proto_ops algif_aead_ops_nokey = {
>	.poll		=	af_alg_poll,
>  };
>
> -static void *aead_bind(const char *name, u32 type, u32 mask)
> +static void *aead_bind(const char *name)
>  {
> -	return crypto_alloc_aead(name, type, mask);
> +	return crypto_alloc_aead(name, 0, AF_ALG_CRYPTOAPI_MASK);
>  }
>
>  static void aead_release(void *private)
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index 4d3dfc60a16a6d8b677d903d209df18d67202c98..5452ad6c15069c3cb0ff78fe58868fe7ce4b0fc3 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -380,9 +380,9 @@ static struct proto_ops algif_hash_ops_nokey = {
>	.accept		=	hash_accept_nokey,
>  };
>
> -static void *hash_bind(const char *name, u32 type, u32 mask)
> +static void *hash_bind(const char *name)
>  {
> -	return crypto_alloc_ahash(name, type, mask);
> +	return crypto_alloc_ahash(name, 0, AF_ALG_CRYPTOAPI_MASK);
>  }
>
>  static void hash_release(void *private)
> diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
> index a9fb492e929a70c94476f296f5f5e7c42f0313b7..4dfe7899f8fa4ce82d5f2236297230fb44bc35d6 100644
> --- a/crypto/algif_rng.c
> +++ b/crypto/algif_rng.c
> @@ -197,7 +197,7 @@ static struct proto_ops __maybe_unused algif_rng_test_ops = {
>	.sendmsg	=	rng_test_sendmsg,
>  };
>
> -static void *rng_bind(const char *name, u32 type, u32 mask)
> +static void *rng_bind(const char *name)
>  {
>	struct rng_parent_ctx *pctx;
>	struct crypto_rng *rng;
> @@ -206,7 +206,7 @@ static void *rng_bind(const char *name, u32 type, u32 mask)
>	if (!pctx)
>		return ERR_PTR(-ENOMEM);
>
> -	rng = crypto_alloc_rng(name, type, mask);
> +	rng = crypto_alloc_rng(name, 0, AF_ALG_CRYPTOAPI_MASK);
>	if (IS_ERR(rng)) {
>		kfree(pctx);
>		return ERR_CAST(rng);
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index 9dbccabd87b13920c27aff5a450a235cc6a27d59..df20bdfe1f1f4e453782dee3b743dd1939ab4c6c 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -307,9 +307,9 @@ static struct proto_ops algif_skcipher_ops_nokey = {
>	.poll		=	af_alg_poll,
>  };
>
> -static void *skcipher_bind(const char *name, u32 type, u32 mask)
> +static void *skcipher_bind(const char *name)
>  {
> -	return crypto_alloc_skcipher(name, type, mask);
> +	return crypto_alloc_skcipher(name, 0, AF_ALG_CRYPTOAPI_MASK);
>  }
>
>  static void skcipher_release(void *private)
> diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> index 62867daca47d76c9ea1a7ed233188788c5f6c3c0..7643ba954125aba0c06aaf19de087985325885ad 100644
> --- a/include/crypto/if_alg.h
> +++ b/include/crypto/if_alg.h
> @@ -41,7 +41,7 @@ struct af_alg_control {
>  };
>
>  struct af_alg_type {
> -	void *(*bind)(const char *name, u32 type, u32 mask);
> +	void *(*bind)(const char *name);
>	void (*release)(void *private);
>	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
>	int (*setentropy)(void *private, sockptr_t entropy, unsigned int len);
> @@ -243,4 +243,16 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
>		    struct af_alg_async_req *areq, size_t maxsize,
>		    size_t *outlen);
>
> +/*
> + * Mask used to disable unsupported algorithm implementations.
> + *
> + * This is the same as FSCRYPT_CRYPTOAPI_MASK in fs/crypto/fscrypt_private.h.
> + * In additions to the motivations there, this API is exposed to userspace
> + * that might not be fully trusted.
> + */
> +#define AF_ALG_CRYPTOAPI_MASK                             \
> +	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | \
> +	 CRYPTO_ALG_KERN_DRIVER_ONLY)
> +
> +
>  #endif	/* _CRYPTO_IF_ALG_H */
>
> --
> 2.54.0
>

Harald Freudenberger

