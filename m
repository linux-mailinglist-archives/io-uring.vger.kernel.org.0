Return-Path: <io-uring+bounces-6143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB82A1DB23
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 18:19:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CBD37A59BC
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 17:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750AD189F57;
	Mon, 27 Jan 2025 17:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="RThh2l8h"
X-Original-To: io-uring@vger.kernel.org
Received: from sonic309-27.consmr.mail.ne1.yahoo.com (sonic309-27.consmr.mail.ne1.yahoo.com [66.163.184.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E12B189BB1
	for <io-uring@vger.kernel.org>; Mon, 27 Jan 2025 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.184.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737998327; cv=none; b=IWvTkJiNUNSn7BLaGuCQyuTWrnPqCJZcZi9Sg7V+9srV5upSO8fcC43tbKZ51nmEiDfMCEDadvtql8gCcarcrePwgQnM+9SlpZNHqOM5ehtklXU1dOqpZxCXc90d8vbAeMG4qZdn4ubhpHC85UTWWHNdKTJkc0U/IuKWSuF0C0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737998327; c=relaxed/simple;
	bh=t/dos2zj8APz5pI+joT/EuwBbbvSOcgYgZAgIEhiLHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a6NRdXlytpnMHHg7vHzTMD4QIP4DXRp/Z7sF9gSsv31xm0tH4jtNoi9riVecccqfbQM5pBtMoel2O9ksuIk+GsuDh5YpgUhlnEsysw2BVcPJjldgyUe18B4WT7T4tGQf1TJCfthfN089J7Lxa23s7aCUfLFvbfGgOCtHS4slJ/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=RThh2l8h; arc=none smtp.client-ip=66.163.184.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1737998318; bh=x26gB3JNRu+hEDafrk16nnBoQG5bhDVgTkZ9KxR0jDw=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=RThh2l8h3hAarzDmH0dRAzTjP8wnCZdphPxsHhrN/F2nBR9TUGM5WQe8+OKyILEmVsmTvlMjztm3B/mm3S6XQUnCeiw9xfJZZLEsOyTWnm/6ub5IfKY7/6ADE/eKA4Kf+vlB1CbLlQ1RBX9VURUM4dM9Ezwx0X+7qC3fOsX9xWiViKMCh9+Ob5LyYdjzr4NtEHhW/berhEBu1w7TBbko6ow+/WhOM88JHGXe/kVeoYESRrOu3/j2rYZ+WJ18tWx2LJ3oAS5IKe//6sF+CXMyh8hZkoHz9SBJVhjEd6cKA5x0CeDaAmLecskYAWl5tcdc1tYzY10Ri/edVBKAVyEgJA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1737998318; bh=qf3zwfy18vAo4gAsG8dJa6yEqWhaop+KVdos/z4c1uZ=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=GJ0ZEMugSxuAFFd0RiIF4wzAngteVemeMvt9qyztCwExSAveuO+KjGPRmlsZwMzs0NNVQ5UVXscFAIbVxsGZk5rhFLJgIEDCfGClkh8mfretnJrYvShXIDlU/9USehFu11uZT+urL3basknvnYYi+MzVich8JCocgfFfV0zHm8KrfIIrsZVdE+p5IgMvej5KOMrG23M1VjtDsqsQznmnvvo4mUgeu5CrZp+75QbH+LIfa0edgnCnUmBdpzQ3ZUY/GkWjW/FL/5Gw6r9uDga6uhAF4PmlW/bfIuWpTzfDhEJ+Jhm7/q4LZ/YgxBLxnvDRimzK7D9t4ofe2AdSDTkVKg==
X-YMail-OSG: vSZpAlEVM1l7U6ez4PgOK0aKdNqcuOVY0tr1uXzTkq2MXA1SkJDpmbgrNwZT1fI
 IZn4EdjSGFf3QGTgbqHgzOAKfYkdsj5SVzFLfNPggVnIdzg6tYLm.iEN3NpGguICuF0ECwsitMQl
 C6TDvyjMrwmN28jiVFyy3h5PHF6PpEO7rvSV1k47bVZjFlmKYafWiX3.Mq6KsyXgcNwuLLctlYaO
 bBGRfa5KDek_5GFFE8wDAWFl.WwE8KGWh_jxCZP23ULTvgELGSjz6s6NVBL0Pt7gDXnwuA2Lff9R
 2GAZR4xjTkMDDe9A7hGSDy7uHIQ40ZlbPpEC5DjmyuFgTkyMiYBoFBWFaBtMs7waYo2Kc_TIQ5Qk
 Sa3jg_FEBoysoD_iIP39DKjv6vTdTsPoJtZYdjwZxGvMTPxEziOQsNmC13Z5g3hw8_haolsJ0Sxj
 IrU5OsWksqmRxJbo6mbGQo.IkecSF13pWwdHas0dgmIW2GHXJ9TFXMJ2.694Wz.DdudJ0vFyYq5m
 c4psSB1uciS1yvIUsM_Bdc5pEH2K6ljptd3xlcNWB8R7k0gjBy1Boa7x29_sINlsSA2LY93cvpdK
 8IqirS0C27F7rxirs.wKSN3DdEHu58UTq4u7KjWrFJpF7qJ8cPDLTQkt0P_YItMAwcvAHCPfkoxb
 d5hgXCFnNbId0YzEJzIwBQDxeu_.Xh8AWe5x91TB90mungOrLIOO7zlw9I6yKdTaySaK61JHxou2
 vmfkgf7fnrSS7BAGwlGEGv_zriE9sJIB28jb6NxE7KnDE_keq7R0kirm0HSHy9q1fd9bsg_YIugx
 ok9dJqowE9I.I1oZvWRzyt40oLJDD2ml1fFglksNq5yILEemaHCjGramOWjUzKYa1aBhtPe_bHwk
 6X9PcCirWwZMh1M2BqRybxJMYXNhygbeUUPtl1r_foi6OrfvyjiGVN5361XyaGB9t.jPnAPXK7io
 MRkTRvFp746SBmNBqVAP7rRgG0wTMb7ebOlCgTqAlYkmNUzoozqmY35XU6Vepf6Yx3CKbMX9TRFf
 5.C9dMiNY9sov_5dXkVpwWHx8Fp.1VlXievupEfHgxkkII3aEqFN8U5rdQlhTjihWva9rQBdoWCn
 JoYaQJkQKY_B5LlX_vK5P91M.pxiJDGHl7JYSUgnZ07glQ6EvU1_Af3KN18Svy4lkchTamzkhXmR
 9uo1dHAaJbrir7PZgLFyKLwqH_3_nDMdPbQYYJGfNXJcIZJuAl.o2GD8P13Scr9KS2lRI2M_EZBT
 XyMc1Ce1gAePClM1yOM9PFPiyneoiMegXycDxJIjtc4Rg06D5E6ft8ddJnKExvSjMpc28mQ4Wbo4
 Pr3pyyRlY_HKEy7ggcXphRIu0irHy4DlyPKlfJwSpCacO3YbAJZFKNnPTlSKRG9goXdTclWy7DvW
 dOvU_923HKcYIUvMCbHtcyRcUFolfn2OPVkxQ87j2cyzmFSsieKPsGAI8xRtZ0XpRkudZMNFDjBH
 MQBTxGT5rYw35k40X4abSjLs0_JWWguwt6bMIH96aGjkhIpnl2XGUxdww6nkKKs2tOFIWEP0vxqg
 nX1FARP0.jECT_v65XJ9qbIv32RCltzHqpAH_xq3XHh9xDvQdmoM00MsQdKVL5nEnJXLYN.bdI4b
 OoB0rnWJUlESkvaCX1y5.NBoTQZiVVRwdtPMqwsAuTs_n65_2xJ6WMkiow619vaDOyZdOuZ3rbD2
 j7GHkSAOK0W.431qlbrhkEpRwXjBrpIvSomDTsnuyl6kFnCo8pLoOWqRVnawAdLEEvy7OBG_aPnH
 im..mirYfYVCD47I52SKt7OfYnQR3nxSy0CiZv3vrIqyome9kG7NS8db4PPF8JtxPPSiLMFXJrIx
 QHpE9D09jJ9slCI32600Py5YkxjZ3sV6Eowd8hY4bX2yChggPb7LN5Y8N_f6ZC_tts6RDPORWFJn
 iP29dvJ2kMtF4M8AP.Ljn1wAuqvoqjCGb9I_Q8ud_xqJnLzvWMCO9_XSizhsZZn.xFRqqZIUiheo
 M2RrAwarDP5GEiK.i50cnAY2IY3yIzdRU8CuPaEUIF.ZTSG9tuNZcJuZmjJgzTz06Qo0dWpMG9RB
 DCLBh9mHyzVRPAiedA31fEtDrqdbsCZQjIY8_alnURbejtNnSatFRUTEHEvX2QAfGSoNW7NANLuJ
 d0QjpwGthUv9WP_UMqgLGfl3dhQJvXNbIVkF0acJl6PQ8dayC2kBNMI92V60yGYCc0GBhTI5mVdE
 3QZr0vxbvVj62Qewq6utd.rBG.Dy1PhvZH7_yWEXD9LWBY1GEzEfZvouBoJUPkvDwQE1bhdvMU9A
 rv4xJcEVW4WfpYWJOBVIwyExpMhNK
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 4a44d33c-5d77-451c-992d-d8c86c4377fb
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Mon, 27 Jan 2025 17:18:38 +0000
Received: by hermes--production-gq1-5dd4b47f46-5qmz7 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 81936a5dd092f50612d99092c82af2e8;
          Mon, 27 Jan 2025 17:18:34 +0000 (UTC)
Message-ID: <bd6c2bee-b9bb-4eba-9216-135df204a10e@schaufler-ca.com>
Date: Mon, 27 Jan 2025 09:18:31 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] lsm,io_uring: add LSM hooks for io_uring_setup()
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
 linux-kernel@vger.kernel.org
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, =?UTF-8?Q?Bram_Bonn=C3=A9?=
 <brambonne@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?=
 <tweek@google.com>, =?UTF-8?Q?Christian_G=C3=B6ttsche?=
 <cgzones@googlemail.com>, Masahiro Yamada <masahiroy@kernel.org>,
 linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
 selinux@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
References: <20250127155723.67711-1-hamzamahfooz@linux.microsoft.com>
 <20250127155723.67711-2-hamzamahfooz@linux.microsoft.com>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20250127155723.67711-2-hamzamahfooz@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.23187 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 1/27/2025 7:57 AM, Hamza Mahfooz wrote:
> It is desirable to allow LSM to configure accessibility to io_uring
> because it is a coarse yet very simple way to restrict access to it. So,
> add an LSM for io_uring_allowed() to guard access to io_uring.

I don't like this at all at all. It looks like you're putting in a hook
so that io_uring can easily deflect any responsibility for safely
interacting with LSMs.

>
> Cc: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> ---
>  include/linux/lsm_hook_defs.h       |  1 +
>  include/linux/security.h            |  5 +++++
>  io_uring/io_uring.c                 |  2 +-
>  security/security.c                 | 12 ++++++++++++
>  security/selinux/hooks.c            | 14 ++++++++++++++
>  security/selinux/include/classmap.h |  2 +-
>  6 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index e2f1ce37c41e..9eb313bd0c93 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -455,6 +455,7 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
>  LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
>  LSM_HOOK(int, 0, uring_sqpoll, void)
>  LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
> +LSM_HOOK(int, 0, uring_allowed, void)
>  #endif /* CONFIG_IO_URING */
>  
>  LSM_HOOK(void, LSM_RET_VOID, initramfs_populated, void)
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 980b6c207cad..3e68f8468a22 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -2362,6 +2362,7 @@ static inline int security_perf_event_write(struct perf_event *event)
>  extern int security_uring_override_creds(const struct cred *new);
>  extern int security_uring_sqpoll(void);
>  extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
> +extern int security_uring_allowed(void);
>  #else
>  static inline int security_uring_override_creds(const struct cred *new)
>  {
> @@ -2375,6 +2376,10 @@ static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
>  {
>  	return 0;
>  }
> +extern int security_uring_allowed(void)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_SECURITY */
>  #endif /* CONFIG_IO_URING */
>  
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index c2d8bd4c2cfc..9df7b3b556ef 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3808,7 +3808,7 @@ static inline int io_uring_allowed(void)
>  		return -EPERM;
>  
>  allowed_lsm:
> -	return 0;
> +	return security_uring_allowed();
>  }
>  
>  SYSCALL_DEFINE2(io_uring_setup, u32, entries,
> diff --git a/security/security.c b/security/security.c
> index 143561ebc3e8..c9fae447327e 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -5999,6 +5999,18 @@ int security_uring_cmd(struct io_uring_cmd *ioucmd)
>  {
>  	return call_int_hook(uring_cmd, ioucmd);
>  }
> +
> +/**
> + * security_uring_allowed() - Check if io_uring_setup() is allowed
> + *
> + * Check whether the current task is allowed to call io_uring_setup().
> + *
> + * Return: Returns 0 if permission is granted.
> + */
> +int security_uring_allowed(void)
> +{
> +	return call_int_hook(uring_allowed);
> +}
>  #endif /* CONFIG_IO_URING */
>  
>  /**
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 7b867dfec88b..fb37e87df226 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -7137,6 +7137,19 @@ static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
>  	return avc_has_perm(current_sid(), isec->sid,
>  			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
>  }
> +
> +/**
> + * selinux_uring_allowed - check if io_uring_setup() can be called
> + *
> + * Check to see if the current task is allowed to call io_uring_setup().
> + */
> +static int selinux_uring_allowed(void)
> +{
> +	u32 sid = current_sid();
> +
> +	return avc_has_perm(sid, sid, SECCLASS_IO_URING, IO_URING__ALLOWED,
> +			    NULL);
> +}
>  #endif /* CONFIG_IO_URING */
>  
>  static const struct lsm_id selinux_lsmid = {
> @@ -7390,6 +7403,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
>  	LSM_HOOK_INIT(uring_override_creds, selinux_uring_override_creds),
>  	LSM_HOOK_INIT(uring_sqpoll, selinux_uring_sqpoll),
>  	LSM_HOOK_INIT(uring_cmd, selinux_uring_cmd),
> +	LSM_HOOK_INIT(uring_allowed, selinux_uring_allowed),
>  #endif
>  
>  	/*
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 03e82477dce9..8a8f3908aac8 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -177,7 +177,7 @@ const struct security_class_mapping secclass_map[] = {
>  	{ "perf_event",
>  	  { "open", "cpu", "kernel", "tracepoint", "read", "write", NULL } },
>  	{ "anon_inode", { COMMON_FILE_PERMS, NULL } },
> -	{ "io_uring", { "override_creds", "sqpoll", "cmd", NULL } },
> +	{ "io_uring", { "override_creds", "sqpoll", "cmd", "allowed", NULL } },
>  	{ "user_namespace", { "create", NULL } },
>  	/* last one */ { NULL, {} }
>  };

