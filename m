Return-Path: <io-uring+bounces-6146-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D2AA202AE
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 01:43:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A092A165A5A
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 00:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C6A2942A;
	Tue, 28 Jan 2025 00:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="MSzyyCfl"
X-Original-To: io-uring@vger.kernel.org
Received: from sonic315-27.consmr.mail.ne1.yahoo.com (sonic315-27.consmr.mail.ne1.yahoo.com [66.163.190.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420D81DA4E
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 00:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.190.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738025032; cv=none; b=o78wweW3zh6gzWEFvdjadV38IidSFn7s1xwcOCuALgFJBydrNXFm+lM5qJESYEdGsYkj5NKN3nAkhIafhGfBFUE4/6XmPCD+oV/7q8t7RDmX6xGInJgdPcDiTrnRbOzFBmUinhtfC0SmuSHuG6bsVCPrLs08EN/UDmzGo+RTBsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738025032; c=relaxed/simple;
	bh=QsyiCRjP3DaGVqfnaUCOGK5d8ntrKppe3LIoAchhpXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VnGCezk+3uf6LWfrjHV7NuZTg+wEHOnFRs0EO8JmIxrPjWJ2fpqCwBZEWHqEcfLlMl8kngw/4+PlV3itHAS7KKMWmWA4bAz9XG9M6Evqh/p5585C692WcEtRzOa7Tw32Z7Rzca4sNFPXE9VG7Dzl3MlxxO5oqWKonepBvQ8D9Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=MSzyyCfl; arc=none smtp.client-ip=66.163.190.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1738025030; bh=QsyiCRjP3DaGVqfnaUCOGK5d8ntrKppe3LIoAchhpXk=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=MSzyyCflrINfViPS7maF4uycraNdQ6q+n7N8KOoY5vYEjzz+/x7I3M8AlmtFk28E3CYJljoOEkQ4/gW+JwYca22OEKiZk3XFVTVeN9WDrzIOnvXGZXFsvEBwtqY9oSFpigbaLd1z4yPI50D4rahaMJDcq7K/Wp96+8Ah25CAdIgO6ywPhuEj7PBZz6jV7I4rK7mF8a/UWZEqTI62HiQJkfICjeMjSIYTM88MqpK5sVKi7wzEe7SDdfR+BdTtcA3jaSGK2CUdY0M2bey1auMDi59/X0pznT3NM5x6tmGxoVrOhE/JbwZYnZqy6Fz3WQZvfGRjZIuVrlr/KM+vnN/lJg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1738025030; bh=0IthKUd8ANWreWSPcvwisla4fQBfobF+q3MD62wVP9M=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=p9K4rbsQU8ymFeba8T4Hns8JJqG1/oNTPQpKRvY/xEZ40B7W2YEZsObujPuQ6JD3JQUE8OY2HSN10pXUSJbB3/x0Yje/6i9O/7fqLBG/kC3rlYb91Uvx7DT/MaMcBQCIuTnYS1ISeSeO5wQ50OhHSvb+X0a+4GAjjgNEmzcp1KTtXSS1fva+BuLRIWJgUfv1eMXQZAKI0iMbKxPRUxQdxtRFKg741BDXH48s8IE1aOhhqX6Z9fJjp38v7YlWxDo5R/N3HQwEKZI1F7aAdOg6TM45d/+wPi2koaSdinSofZdQFbxjaqv6xRTLSIiYlDRz7W94fSn0gg8CEoltl5TM+g==
X-YMail-OSG: vysmwxUVM1mVI5DfHGU8J.2SU.Pejmqo4qRXSBJTpgmymtaokG9v8ySK_POcvNp
 g23Cl8HfA_XbyuUbUL8jWoh4HD9MVtSO9AhtzD9CT9ogW.y0.FMnq9Gr99vYBS84ce1J26o.66rJ
 7gOTmiEFsneZMBnZibc.oKJsco5edKGMeZDZB.znZd9HnN1cH7Ksx7rFUUkYDM29_SJ_9J1_HxAb
 uC5l.2jc2oUJZ.FGHp01Fy26REk4NMCkBWcv73BHfqRACNemz52TpTCeyQ48HhKZcVK.pg9MtctX
 8Ez6BW7u0UOvSGeP5KN1FRECRAxS204F8KTufNmx_kUI_79NY6weLkhiREPSOKMArILRwTgDYRRK
 YEQ8nZ4JrZCutvz6gbeBHPOz7wSZlbCSauA3lw2sT74voV1QMjHdqjPXu9ezX2RCzK9ckupSzMGE
 QrRjDkcxjJx5xuNgDn8ZZoZC3GLsl3uVBlrlO8dWwc3i2GPqVQrKamruKEJAhKtV.NMWU1VPiwUN
 Tw7JpjGaibiEpTfK8OD6oBE.8I49RyUlNg92ETyzWEosP7v3Os2CVG_5a5_EjBQ3Bk0Lw3LhpKsn
 qMujPyFrkM3VXWI.kynj.UpAQrcKMjd.XOXFP4zHnuYgA7pfgQDfJbaLX2iGd_YIu4di4VE9fcCE
 if9CyAy8x9DyVyOhU6Zp3iV7AvDoV7ujO9q5.IH8SrHIufPwBfbF793IEUQEgn6Re.RsmR4Ua0IO
 EjhWL9sxZjqTKqcOligFTgODcVz7G1W9Mcye.JPlhOpk4TASqmpvt_avoP7ay0CEg8eJUIevyzNG
 ueHiwtznugQaDuzCkm5xnSv1elk.jv.vX.pOthFARWKoZ7DfISXL7LIHkuUE0PCKhe.kKysNp2xB
 .Uf3jVbw9Kq0NdkzNdSuyFH9u71coKO2_Zg7e8qPT08Iqk8b3gEMSaFZbJclkT0K1h_UnNe34V5k
 zMkoDTEU2hvnM3j6iLhjZ4qqah.dO0JWjKJKuOpLG._oBj8tEh6nBCJuONhgxRalLUbEaBOmWKFh
 4oqscuwRS71.g987KQbzGX5ri8YVPIhuaqFIT2NjQgTNaA.9LAXqINtUL1xWn.dUnbCjY_9cG4tL
 NiHzxu2hgkI5fQyImwQ3CTl8tLbyVLLhK_e7iSEJliHFi8n91RvDPZ4zHJDKO6BhM.KtEWVMaATj
 IuLEHwaxIWcdThdkMgZ430yPpVJeZtkl8B1eoqkFZJECX6HQx4UnXxNSeuNnxi9I2D9u0u8JXhPh
 6hGaelEgRQGbRd7k9f3.g.rmMJP7aR8JHuPGll8ZJhUzvJNmf2UmtvSuM4ihUllKoPTEZ_Xrsqgb
 5O5J3gqocbL0ezU_hFJQtC8rXZMtMR_qr3H0SSu5GhVb3uf9cPX03tUDYAb2oMVq58Yllue7VCLY
 SUfetFj75X1GcB2MmUsTR0TSX_JAFp6If3Pzmu9bTTBJN3m7Jgnw5Ckb.ASWiIL_h_yev5DaYyZS
 rUqNXyUmXeSnoN4NICeuKH1XPZbPrB62LF.FVVhqZuXtGkVyPgEL05FM472s9i5_vUJnSU.sRNtH
 RlUtO._.oW6WLqPlC.gKHVylBonitqbsbVm92lGiGKhrRf73Re0JttXG3TBhJTniYTWDeJQ11TOf
 ee4tYgoKi9GuU_yDD_dt7JJnRpmBwAHeTMzFteO03NEs5.GJWSso2XvGycTXJb6B7XgGFZVzjCEG
 OXgZA.z288T2CgCXKkIIEAKl03yaQ_xQbF3BsONK3x49d.H2mKKY2dr3Qb4DX3xWsSM1481SbYei
 E8mtr.sTl2TCP_t2Fu52vYefkJDIwMKfIHc9B7nJhfpi9Z3bB7ZcUGSjs8yQiu9zYpaOAiza8xZb
 nt5BtB4tA4o88KjQlbK3TWSVg7egRnt_BaqDXj4IGd.1rNxJ7A3bFkfDZJobhh9SvNB2hTJdL7jv
 yz07DVS7nI8UrGU0vBNoljavMEgwfQVsnK7HqaAE.FrE391VkdXIkI_d9cGuI.UqLPPBpsokyqKh
 CB3dRN0wNUG34__2ciVeq3miQUctlNoYuvVDEU3u2W5JWT7vNY7F6QaMya8b592l97GDNcpLnh7h
 zUnHltl.tpXkw7FVCh25vSGLF.Ih4fgTnHKsmqIQzrIlGdcitwqWdVy9e1yHUQubSqMoAZ0wVdD1
 Tlb1H_JlsZBTMUH2g2_fEtiKLOaY_0e.2xmAu.BATgYNIdNRBJjRGNGQgIGaaQzMEWu.VMiUwqNH
 u6.0t2HWW0UfoJF4632IyC2G11RmTpnyskbocQLv7Glbxf1ef9nGkPJ7ePk_mLInsorZeElZXlo6
 _trpA7MabWzGLPVDaV4osKgk-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 0b816345-770e-41a2-9668-a1dfd0d40cd3
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Tue, 28 Jan 2025 00:43:50 +0000
Received: by hermes--production-gq1-5dd4b47f46-wrqn7 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 1fd4ac7a758ce4301069c09e19ebfa33;
          Tue, 28 Jan 2025 00:23:34 +0000 (UTC)
Message-ID: <bb360079-f485-48c5-825d-89cbf4cf0c52@schaufler-ca.com>
Date: Mon, 27 Jan 2025 16:23:31 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] lsm,io_uring: add LSM hooks for io_uring_setup()
To: Paul Moore <paul@paul-moore.com>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
 linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
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
 <bd6c2bee-b9bb-4eba-9216-135df204a10e@schaufler-ca.com>
 <CAHC9VhRaXgLKo6NbEVBiZOA1NowbwdoYNkFEpZ65VJ6h0TSdFw@mail.gmail.com>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhRaXgLKo6NbEVBiZOA1NowbwdoYNkFEpZ65VJ6h0TSdFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.23187 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 1/27/2025 1:23 PM, Paul Moore wrote:
> On Mon, Jan 27, 2025 at 12:18 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 1/27/2025 7:57 AM, Hamza Mahfooz wrote:
>>> It is desirable to allow LSM to configure accessibility to io_uring
>>> because it is a coarse yet very simple way to restrict access to it. So,
>>> add an LSM for io_uring_allowed() to guard access to io_uring.
>> I don't like this at all at all. It looks like you're putting in a hook
>> so that io_uring can easily deflect any responsibility for safely
>> interacting with LSMs.
> That's not how this works Casey, unless you're seeing something different?

Yes, it's just me being paranoid. When a mechanism is introduced that makes
it easy to disable a system feature in the LSM environment I start hearing
voices saying "You can't use security and the cool thing together", and the
developers of "the cool thing" wave hands and say "just disable it" and it
never gets properly integrated. I have seen this so many times it makes me
wonder how anything ever does get made to work in multiple configurations.

>
> This is an additional access control point for io_uring, largely to
> simplify what a LSM would need to do to help control a process' access
> to io_uring, it does not replace any of the io_uring LSM hooks or
> access control points.

What I see is "LSM xyzzy has an issue with io_uring? Just create a
io_uring_allowed() hook that always disables io_uring." LSM xyzzy never
gets attention from the io_uring developers because, as far as they care,
the problem is solved.



