Return-Path: <io-uring+bounces-6173-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3DACA2155B
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 01:02:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 153C21889192
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 00:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D1A42F3E;
	Wed, 29 Jan 2025 00:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="FM/K62No"
X-Original-To: io-uring@vger.kernel.org
Received: from sonic309-28.consmr.mail.ne1.yahoo.com (sonic309-28.consmr.mail.ne1.yahoo.com [66.163.184.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EE61FC8
	for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 00:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.184.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738108929; cv=none; b=IwHhGfrnBTi9aAmMqg0Uy1s74irSufGBT58W3a2sgutaXXALoDTt4s7EmM47m3Kga5Qfr8yd5SWRUMknI9Qd21fBssL8uzGHCrPxY1aNQ9nMzW7irxcZ7sa290gB7ttznrirxeNqA8YT9L0LBuveG/rzxitDrSseUI+ZH9pBrEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738108929; c=relaxed/simple;
	bh=d9s7R1FlGhnoCg/BX1Amdn3NuScio9jVOq4QUYKgb6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h7rYPWdazstnpYZBWZgvOpzqvcOrCPUyjL8JWRfbhgtQmAc9ACRpIy7/vgImkBykZ4ugu1s2JeNn3BqZuIsvgx35pJGZC4unwtDIxpD15Cc2cyET7c9pk+j18ct3Np72FanZH9TsjbVeVJ0y/xtyzk+ReAZ8+hmzS7QbIZVozgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=FM/K62No; arc=none smtp.client-ip=66.163.184.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1738108926; bh=teQC2LZ5zSH/sS+eQI6aKaJiOhVbqoZ6j55vxMZd7iM=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=FM/K62NojoZxeFL5DAFaBaul8Wbez9LKtblf35gY4sTX+9FmdvpdIcISBydRwQ2AG5KPKRNweAh0be9VNHF2hR07hVxuLPPRhCu76csev8/iD/JdKKoRWuLi+QFOrNpiLeplUi+2PgkbJWE7vhnF0HhE7A39604wQ83kqQ6/UljvCuWHBylEI1Lbhd6VrgYUwnjIsV9aVjnoQ+QmJY1kJg635Ctvwu7BTRjR2yPpGmQPJhIEcCDJdFzM7QWv25B46NsXGA2+ltUr7iT1hsajOoLC26m7tz3Xjapu9KZjpYVphgIe2YUtb2/2JfRAbIbtw4cY8p1vNBxD9froWxgSlA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1738108926; bh=XnNthY7Z7ABMoByRKv4/cpA+SvmLpxTxX6pBiX7juQB=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=JOQ2vwd1fZUlZ2kwM1kHyQ2F4MAMrZEKO2BqzjUqOVkU27Sobo9510hz1r9IrGqfGakKgxDB9LVCWMm1vTJPcsCpWrAPx5yGPpF3TjPtHiTrVoLnS8PFUOQuUko1dKcvbAJQRTm7P/49PxacVL+I7EXS71ZqKk4hzQwsIXDp/eWSyFo9naT99UQhItJlLox0pszt7ZXACO79ZEcczBfZhVZPWXVSpxhAUR7zSyeiATT1qDkqiL28/3KjeRALg8Zo4E4ZjK0rZZFBuXyNJmmYQKnEq9+uVvImC3eTXQZ3BZ3oqKVdr/b2fDUNfaHM5oYc6EtQR+dIwzh//E98IBBkwA==
X-YMail-OSG: Za2rmoQVM1m6yjeHTtRWCQGVG7ON.ZE0BMe61C20oPPWp39QKT.ZxfvDELlFB7w
 IAa4kL.jT.ZVHXYMTNhAch9M4tPpVZMlhQqLUIEOtJYhB0jM7wU.ro.rlZEla33X._2rKiHFFe5e
 F22DibBEYz3FIfAQPU5pyazStc1wkDizsKKxUZBT6fQHrSZMzXi.QJzbqXIpDAi1FDG7pMNLwVoz
 m.hvorp5kM9pk26xD3qW6LsVUcD6Zkf46wvngQzoZljGZCb3FT8XSH2sYXE7jWoFRXJDp1tG.R.M
 DMWNCLGSlDTmuwV6pBw6UjNPBlV6HoL5X27Qv7SobTs70VA8CjVRyVgEBLyjgR1K5aDWPfmSqsf2
 W9tDlRI_JLdvjlF3_yZp..PvKdWaDHEqDk.THYVfbfgaExnARGf832hM4E8F5OoeZbvkADHh_ZBf
 RAr5bMkT89rvn_kX0b9.DaE8rllAhvaNboHNdrd.84IyhZEhO4Og_PDtK2sI4wot0FO4awkbPowk
 TCkQ3V7OH45mP.Pcoqttgt24jhDZkSHdIaa6BmRe2Ya6dDln7D9tcz4sCSlfq5bxMkpRfSPOlati
 WwDVJTGHoTMrmOOAP8yRenmMFN7CFAOYOROEash82OjzqKdDC0HUWw_lQ7Vwi0ngckfZVJifb1mf
 8fakaiFr5LxxdOY7S4w6cjuS5k0hHYVW68fmkrQ8m1r1YreGGdhm0IVhl4HHK4tFFhqJ_d9nwbx0
 .UwtAO9qJyZ4nmDsEjjd72Xhqz.L_A8aO2dPj3U.FLLTaL6eZWnLT4RbyVD4Ib_pqR40OwpbT0Jn
 S_Fy4ypTMtoVg1C.KKYelV3FZ2eaz_XBtkLWYk3wabvlP41LoEpZLuu6UzT8MwMogQrSE5Yn1aHS
 _m_Ztvs2O7fdXBC_8NPRSnmtkJgWw2P3ZeiHdOz4CRee3jntYyCQ0EJ20rml1WK4z820Lmr3s9YO
 2LbR1UFuviJ24h5Obvfsi1r2Ej1aM5uJlnWgKe3qVVaet6T9xsYtj5Dk9Y9hNQxxpOLvW5O35.9d
 ny4moUlsSRrjlqKkwvcmw7sOa96F4hEVU6ajVrz_UVCW2DitchUQI5K1uiW8FTV_Z0S.WYCaIi0u
 bY7TguI6KcxS2Rtf.whIXhJu.F5rEK.VZRLO_2iqK07T_iMAzt_vZVV7BYyEoMABYinlIhvN1I0k
 Cnx2WkvTz7HdCFz0OYQmKUR0p4S2x1OkwzX_zDa0QCOTrGD6vJ9Y0C_grUs1st0RMOmzqmHJmCqU
 4gq2VNrKYKcm.pC6mTkixmFfbp5NVrI2b8oReYo4tE1A9MSIjPEAOTsZAGPDqlWZmj1L44S3n69L
 qQUTJPfncWJgtist5F9LG0glCRl8IQOs5RE5OPetXusE45NUXT6LYMwtpF1syAEOPZFoUOqr8XOp
 CZOyem3Jr0xoDvYq3QAE0PTNfMbmezOVf.gQPP6ZzSKY8dDpH8M5bjAV9uf4BlbNasjpMsaWrQ.1
 egbd3y_kVvNB54.BOq1Qq7nQBUYTQh43QhkKF9gIr0EL2CnHYIngzIwGDCyrH15z8x89XmQE8V4P
 RqNCLZh1_eCvHmidK.462GWjlizet0Eka600dghZHkt0bPTmSflQjTYbxuRtCKPVR2ZfmtG0c1SS
 qeGpT.hbcI7J6Mg2bf6fr4socAOdaj8rYqVt67iSN839Kz1dy.x1AqjnObhLZ7HNf4wY1SUwTlSe
 .8iZaihGf7PXEjIjqY6GyXu1OyxJc2exCv0Q1PNRW3wiUVHGEVUGd0JCBNkklrqGAcF9nfaEG4mS
 yNZFZP1TqjkIT8qIw1sYQxEZds4lwe5obr7nzzD3vXvgzko09ywtvSwXjBa3CWEk8AFVTUojYos8
 ijjts157U_ppbS9XBpDiNzx3g1vukNQK21zz0tnCOxvVQilyve7u3lLQ0vueoLVvPvM.65y6oCbR
 XmHy.Ip71gpIIGC8P7ZX6Gn3YG55aZRSuNZS9eEtWc36y.OVaBAQ2iz7JviIOEs7mGMk1sgQyWHb
 NEyDHBwnbo6uzhJ4wX626xWUQ4S9f4Gex_AFneg_8xge47h8Qd24kLXwW3C9csF4kqYOrJEAhagx
 bAeQvL9cqglCs9Iuo4iIc5EePtadyQeEk_z9brdz1Y0hc4KU7pa4lM70fnrmGJDvVJumUZLBBOMG
 KoBkp2UNBSkqJff64Musd9A4jvScuC7rzBBYnX6mRYTNiMgpLNF0DRg9HwdHP2NkLq5a1vntI_hA
 xo8ag9wrxKYMUSjn9sdRGZLy1xiIEBGgQhnaLaliEWDiGpaee3vJdCy0gf0PK1rO2IpJFSNO1rzX
 XO27tzeH._M_fji0C1sNcwRg-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 0092f601-379e-43b1-879c-af8004618239
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Wed, 29 Jan 2025 00:02:06 +0000
Received: by hermes--production-gq1-5dd4b47f46-9j75b (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 8507b724dd85e7e8946c93db75fc6dcb;
          Wed, 29 Jan 2025 00:02:04 +0000 (UTC)
Message-ID: <84e580b3-0af9-457f-822c-f03271d20e21@schaufler-ca.com>
Date: Tue, 28 Jan 2025 16:02:02 -0800
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
 <bb360079-f485-48c5-825d-89cbf4cf0c52@schaufler-ca.com>
 <CAHC9VhTAunsgA-k64-qmQzeyvmAHuQ-=Jp-yWDi9XDP9CHkhHA@mail.gmail.com>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhTAunsgA-k64-qmQzeyvmAHuQ-=Jp-yWDi9XDP9CHkhHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.23187 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 1/28/2025 2:35 PM, Paul Moore wrote:
> On Mon, Jan 27, 2025 at 7:23 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 1/27/2025 1:23 PM, Paul Moore wrote:
>>> On Mon, Jan 27, 2025 at 12:18 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>> On 1/27/2025 7:57 AM, Hamza Mahfooz wrote:
>>>>> It is desirable to allow LSM to configure accessibility to io_uring
>>>>> because it is a coarse yet very simple way to restrict access to it. So,
>>>>> add an LSM for io_uring_allowed() to guard access to io_uring.
>>>> I don't like this at all at all. It looks like you're putting in a hook
>>>> so that io_uring can easily deflect any responsibility for safely
>>>> interacting with LSMs.
>>> That's not how this works Casey, unless you're seeing something different?
>> Yes, it's just me being paranoid. When a mechanism is introduced that makes
>> it easy to disable a system feature in the LSM environment I start hearing
>> voices saying "You can't use security and the cool thing together", and the
>> developers of "the cool thing" wave hands and say "just disable it" and it
>> never gets properly integrated. I have seen this so many times it makes me
>> wonder how anything ever does get made to work in multiple configurations.
> While there is plenty of precedent regarding paranoia over kernel
> changes outside the LSM, and yes, I do agree that there are likely
> some configurations that aren't tested (or make little sense for that
> matter), I don't believe that to be the case here.  The proposed LSM
> hook is simply another access control, and it makes it much easier for
> LSMs without full and clear anonymous inode controls to apply access
> controls to io_uring.

I can't say I agree that it's an access control because although it is
specific to a process it isn't specific to an object. You can still access
the set of objects using other means. It is a mechanism control, preventing
use of io_uring entirely.

>>> This is an additional access control point for io_uring, largely to
>>> simplify what a LSM would need to do to help control a process' access
>>> to io_uring, it does not replace any of the io_uring LSM hooks or
>>> access control points.
>> What I see is "LSM xyzzy has an issue with io_uring? Just create a
>> io_uring_allowed() hook that always disables io_uring." LSM xyzzy never
>> gets attention from the io_uring developers because, as far as they care,
>> the problem is solved.
> To be honest, I wouldn't expect the io_uring developers (or any kernel
> subsystem maintainer outside the LSMs) to worry about a specific LSM.
> The io_uring developers should be focused on ensuring that the LSM
> hooks for io_uring are updated as necessary and called from all of the
> right locations as io_uring continues to evolve.  If there is a
> problem with LSM xyzzy because it provides a buggy LSM callback for
> the io_uring LSM hooks, that is a xyzzy issue not an io_uring issue.

I'm much more concerned about bugs in io_uring than in xyzzy. The io_uring
people have been pretty good about addressing LSM issues, so it's not
a huge deal, but I never like seeing switches to turn off features because
security is active.

If no one else shares my concern you can put my comments down to the
ravings of the lunatic fringe and ignore them.


