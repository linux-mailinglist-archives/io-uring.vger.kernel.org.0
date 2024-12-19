Return-Path: <io-uring+bounces-5577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B78AE9F8703
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 22:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E301C7A35C9
	for <lists+io-uring@lfdr.de>; Thu, 19 Dec 2024 21:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC291B4237;
	Thu, 19 Dec 2024 21:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="oUE+8T1i"
X-Original-To: io-uring@vger.kernel.org
Received: from sonic311-30.consmr.mail.ne1.yahoo.com (sonic311-30.consmr.mail.ne1.yahoo.com [66.163.188.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B185E17E00E
	for <io-uring@vger.kernel.org>; Thu, 19 Dec 2024 21:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.188.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734644068; cv=none; b=t0sZr+xHylkjwzDZ8I5Pg7OK6UtF30CF5ulXOKNTTfNhaALGSaGfK7BWLf4rNu/b8gb1LzavYtAhkcHrpiR64iivy5bXA3yMgOaWGbUZQcRskPhWw6hQDRr7t6omnxukIo6h1dthqTQk4WA+1c6KehoFlD3LIJGtZ3ZeZHFoK5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734644068; c=relaxed/simple;
	bh=5L0FOMfCI64qljGCpKY+SvTkJwHBKzTjAxxi2guSr2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H4SxgJqwo+CizdTFvasJNBemW4umPwTQ2Re2iPvBp505eK+ZItBu41WClTrHjGC5OG8ehcCBI8M3KjNb43YhpgTEgZq63+Wz8gQSWB7/E3fs83LCy4+52OYhH5mvOpi816FwDFVZil0hdbaRDkqzCO7K7HKWhhgwNen7FbBmj48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=oUE+8T1i; arc=none smtp.client-ip=66.163.188.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1734644059; bh=MneSeXSVsHy7ZQcugGf+8Um6UZ4OQskaBiBAMmAmHXQ=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=oUE+8T1iMgr23DhjaXPKxJALFRHFiQT7b4VKtUmkZRiddpFK4IfthyI0fvCqba7al6fcDI9//1Ob8bubJdqGCrRsKhyCLrPUGCWLnj9CYwnVJuSFHJspVjCCUGR7shFZAue9hrSfekCtGtC8qmFlyxP9GoHU32CQ22Za5fseZcvMc1+kz9D5iBU/HtDVvrKBu+2poSM6mHe2cbXN36lnYxwibDXINstctUqiLMGxK5Sw5s4SCB3iBgaRi0Ap7soXU2Ps7ebQR/tBMUTfEKPPTWG1cAnrF8CMoNX/TQFc3nMpWFneiCiqmC06sMTvTXiCbjAu6v3Eyc86/OgUWKWxnQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1734644059; bh=N/1sW9+3xXaaF2wSXhtblnJo6auU/w2Ui4fUfB7OjJk=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=K+IuOgxKneVh2sedrExqTE0zBZN9jIECeLyaxE9sx/BmhlawhdTTcScGvUAAL2bofy1TN5JpXfcaBinTQygsUZXxa+YYrs7at8HLOBROi9qPykSE5l/5edWs1j+4N1R4y2L/9nppAMyk8nWxra3PIlPMymXait0/O0VHUL2vVWETSZyIpL4foDVUwF0Q9UGSPOAotRA+fG3RwQGM0UI96DK/3/eQBhFa3S4qWSXPcHeFV6urfLRyoQRlKhzilvXDcfVABFPbK5eKfOMe+c+HkCAODUlb0PLDqJiDOErROLF+/JLHGZ2RNn1UZeNROQkGmZaTzdlnrESiuxJV7HPd/g==
X-YMail-OSG: QEuGr8wVM1nGSsqnUyMlEJ4tRl8JTYzWBSeaYqTsN5iCRoKOn3T68VB0DEMGKiw
 i47x_Jj_7CXYNB15EozdbQM7oCY22tkVXbMDMEphWLOmxjozFTFEVLNzIcUE98KzYiOzfYvrWyFc
 n6uXnTjT7c8sMVeO8pYvjO3eotpSN0hca2Sg1sEFrdnhp_yqJUpy85uyP62iPlnrzyHD6PdxwgSH
 s_6KvwIOS5c1mK53EqDAf.GVvVT3LaEfmySc6vTvXgw1OQBQG3aIbQaqmZBP6lm8ovUQh74jhrkN
 QYzuOEYS0iAfHu8VQh_a_wz7G1O3saiY7h5CZkbUU9PEO55T12a1TLXrowQIj_RM3onZxFU01HQn
 IaAbbomUDcebmWsN9_8Jh4YqUCjIkBuWxXuHG2kteBMNLcV_BsWJM7xqyEePfrxKANnrmuTf3PTf
 AHl_BG13GK2iL1XBUDmeLbYgJw0D_5Qw6TXonc4BOVDlVX9QyuWOdt8.hEjX0RQx6RJbnT6rO2Yq
 RZSjk1SwiGsnNGQ4Gk5Luby1creyLtXyGA.KDhquf4EfmvsZbqQCqtRH6bcNcaoWz4RLYsWtybFI
 1DSAGY0Iiu1ROae3gB6fm31HtqUZuGz1GQnKNHbiR2VaeERBHTxeci5HlPOJL8ROsY_awZaZL.3.
 rDugjod55.iQqumZwokm6P0v4T.zX5coGyykeL.5xi3amt03qtmMqs8t9_qoEd1IA8UIVO4Uv77m
 N9y8VhlOdHVmr9WQekR6O9QFFqxnRaAsfxFIGH8Mi7KmV0KU_3b0UrWmXhuvGRS.7bJKPtriYtip
 I42pJ2Zf8TET5alhNmByiamkCb7NE6vqb1QI5dQMILoTNYiuH7q3b2CnD6qjMDv9ZW0fwT6Q.fTs
 r1gPvsmhhae61cnSnsOl.n7UibB3wZGnD6zHhtAyxtP.82HVJzOcLMkwHjb5zLW0Au8Zr05.RydX
 FdNqihBiLP6hji78DJcqqwkQDFXg1TIAhEkRQwkHgRVzPLj0IZpKFTsEQ24mCALKu5guxq.QfPnP
 uhzO.MdU6EgdknDqkOrreKdrnmZUzdcVoUBcjoBDr91HQ3L_RSvDV2HEe2PlsHPm65a5qmIboBGx
 g6Kj0Twjs.mMN1_Cg2lTLUajuyXbm6nFAapJ_xNbh6GRlWZQ0S2C0CkRRQ1cQFppDdch5LXWDySC
 ._dMDzZJBRArihlTyil9R7dx8_nWAwrJj_AriR6D3ETQO5OYvlGHcZg3vwrL0sucdQjKoSKqc65U
 c04cR294EZvW6goAnr1FTus4vwmESjBOmUidxwGKzmUd2sKbHd9dWlXh2z8MqjE5XksB200CgP8P
 FAR1Wpl.kRcIaSoQ_HEbXxoUPfTQDklh3iiYMN7ptKzw5Aaqj.2faOYVbzYrmbQnDSy0Vmqr7ppn
 Nd81gbwI28VI7rJjorBQLnXF5O6Xee_c2bhzqmS33TvVq4ld.XD9w0KKjq0KjhSNOdhl7PcBnSM3
 jGFo5wfEbyGbR6SLv031JtVpq_v8bBg4PkwFu.RTtUcnJAT0jRrgM.gGjTyw1DEJ7RU44mSobnvy
 DJ0yp5aVelcNBU45vjSt8suIuoKbZkuT7A7n6Ha7jI49ozOewGZ6FkIyIbxEa3eJXQoKAfpAfyle
 I1sJ5vYCiFl41YoAdo5eeHQ.TSyoCKbQB3uCNSb8o8w2itl8sOpWT3dqTP.j5jAwOZq783izktHO
 MAitGm7EO7cH5HFhgSb44PDvel70Z8BhCdblh0qDncK0vv2DgZnhvy7Ypr1hGDCD13TjsD2Qip_I
 ZR7tbxPZ0V7f8CzROegkcGKTw5I_l3rmUPGSGcRnkBxru9wn7_I_Nd5TOWKRXAmmCYfxu6lverNs
 goxKW9JvcSuwNUtc1h7WW4q6DMHjyYJe1v2r.1yYK4QKH3cBPrgX9yGnOou8JF3TubfUp8Jae42D
 mr3aa7NkWvn9xPBIUh7esFGJ_uzlUCbf.miYO4agRHAFpNdt984mIYOcZ_R.ha5hn7yZvwAyZx7H
 U5zWE8dfBvzaUuOQPlCpRK0M2oW.tusL_K8.mNQQLT5G14ILMAMrPC_o25GEC1V7b0alu1LMvZW3
 T.0NKblzHgfwoQoIyFlApLagkkzfv8gHH1eQpLcd._mUK9svwRYS2hRzKFDCJpty3M18H3v_Jp4w
 TiRqKYC2Egss8qIENMn41OCRvuTiS62qrWVeguhJM1SjvIYLUB.NbFuCQoViERYuiqXZ6iKPIkCk
 oQ1Idk2BQx0h1Qc569qmscuAtwFzHof4ep2UfkEB.MDkixtbmQK2.0OZb6Bk7Ln2vPjpOWU71Zzj
 PMiZlBHq4WgwfDgGYnZpic_cq20Jg
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 655147cb-a620-4696-bb7f-8b3d5fb3af27
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Thu, 19 Dec 2024 21:34:19 +0000
Received: by hermes--production-gq1-5dd4b47f46-5xsmt (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 652990730afd43712a6662483d7566c9;
          Thu, 19 Dec 2024 21:34:17 +0000 (UTC)
Message-ID: <4ad606c2-c7d1-4463-a2f1-4fd0c63c6e9b@schaufler-ca.com>
Date: Thu, 19 Dec 2024 13:34:14 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks for io_uring_setup()
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
 linux-security-module@vger.kernel.org, io-uring@vger.kernel.org
Cc: Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Pavel Begunkov <asml.silence@gmail.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?=
 <tweek@google.com>, Masahiro Yamada <masahiroy@kernel.org>,
 =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>,
 linux-kernel@vger.kernel.org, selinux@vger.kernel.org,
 Casey Schaufler <casey@schaufler-ca.com>
References: <20241219204143.74736-1-hamzamahfooz@linux.microsoft.com>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20241219204143.74736-1-hamzamahfooz@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.23040 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 12/19/2024 12:41 PM, Hamza Mahfooz wrote:
> It is desirable to allow LSM to configure accessibility to io_uring.

Why is it desirable to allow LSM to configure accessibility to io_uring?

>  So,
> add an LSM for io_uring_allowed() to guard access to io_uring.
>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> ---
>  include/linux/lsm_hook_defs.h       |  1 +
>  include/linux/security.h            |  5 +++++
>  io_uring/io_uring.c                 | 21 ++++++++++++++-------
>  security/security.c                 | 12 ++++++++++++
>  security/selinux/hooks.c            | 14 ++++++++++++++
>  security/selinux/include/classmap.h |  2 +-
>  6 files changed, 47 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index eb2937599cb0..ee45229418dd 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -456,6 +456,7 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
>  LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
>  LSM_HOOK(int, 0, uring_sqpoll, void)
>  LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
> +LSM_HOOK(int, 0, uring_allowed, void)
>  #endif /* CONFIG_IO_URING */
>  
>  LSM_HOOK(void, LSM_RET_VOID, initramfs_populated, void)
> diff --git a/include/linux/security.h b/include/linux/security.h
> index cbdba435b798..0a5e897289e8 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -2351,6 +2351,7 @@ static inline int security_perf_event_write(struct perf_event *event)
>  extern int security_uring_override_creds(const struct cred *new);
>  extern int security_uring_sqpoll(void);
>  extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
> +extern int security_uring_allowed(void);
>  #else
>  static inline int security_uring_override_creds(const struct cred *new)
>  {
> @@ -2364,6 +2365,10 @@ static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
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
> index 06ff41484e29..0922bb0724c0 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3806,29 +3806,36 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>  	return io_uring_create(entries, &p, params);
>  }
>  
> -static inline bool io_uring_allowed(void)
> +static inline int io_uring_allowed(void)
>  {
>  	int disabled = READ_ONCE(sysctl_io_uring_disabled);
>  	kgid_t io_uring_group;
>  
>  	if (disabled == 2)
> -		return false;
> +		return -EPERM;
>  
>  	if (disabled == 0 || capable(CAP_SYS_ADMIN))
> -		return true;
> +		goto allowed_lsm;
>  
>  	io_uring_group = make_kgid(&init_user_ns, sysctl_io_uring_group);
>  	if (!gid_valid(io_uring_group))
> -		return false;
> +		return -EPERM;
> +
> +	if (!in_group_p(io_uring_group))
> +		return -EPERM;
>  
> -	return in_group_p(io_uring_group);
> +allowed_lsm:
> +	return security_uring_allowed();
>  }
>  
>  SYSCALL_DEFINE2(io_uring_setup, u32, entries,
>  		struct io_uring_params __user *, params)
>  {
> -	if (!io_uring_allowed())
> -		return -EPERM;
> +	int ret;
> +
> +	ret = io_uring_allowed();
> +	if (ret)
> +		return ret;
>  
>  	return io_uring_setup(entries, params);
>  }
> diff --git a/security/security.c b/security/security.c
> index 09664e09fec9..e4d532e4ead4 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -5996,6 +5996,18 @@ int security_uring_cmd(struct io_uring_cmd *ioucmd)
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
> index 366c87a40bd1..b4e298c51c16 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -7117,6 +7117,19 @@ static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
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
> @@ -7370,6 +7383,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
>  	LSM_HOOK_INIT(uring_override_creds, selinux_uring_override_creds),
>  	LSM_HOOK_INIT(uring_sqpoll, selinux_uring_sqpoll),
>  	LSM_HOOK_INIT(uring_cmd, selinux_uring_cmd),
> +	LSM_HOOK_INIT(uring_allowed, selinux_uring_allowed),
>  #endif
>  
>  	/*
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index 2bc20135324a..5ae222f7e543 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -177,7 +177,7 @@ const struct security_class_mapping secclass_map[] = {
>  	{ "perf_event",
>  	  { "open", "cpu", "kernel", "tracepoint", "read", "write", NULL } },
>  	{ "anon_inode", { COMMON_FILE_PERMS, NULL } },
> -	{ "io_uring", { "override_creds", "sqpoll", "cmd", NULL } },
> +	{ "io_uring", { "override_creds", "sqpoll", "cmd", "allowed", NULL } },
>  	{ "user_namespace", { "create", NULL } },
>  	{ NULL }
>  };

