Return-Path: <io-uring+bounces-2417-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B28F92442D
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 19:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF30A1F2427E
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 17:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C641BE23A;
	Tue,  2 Jul 2024 17:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="CTTpYiNh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YA82QPSJ"
X-Original-To: io-uring@vger.kernel.org
Received: from fout3-smtp.messagingengine.com (fout3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C444178381;
	Tue,  2 Jul 2024 17:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940038; cv=none; b=Sy7wnvDoHPYHKawLcLRWjPOuLKZBSXCAIEdZyYHJR+nhpBmpKyTlyv1jsmEHnOKkQKnTe+2xWLCEc31JcjiX+YH2MY9ORXGVZvjkxwI2xfQ7DRy/4FExDeoAi6Kl5zQEsr202xkmCHluzcQzOuIJg0RHo+V927S3nNyzGQwb07Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940038; c=relaxed/simple;
	bh=FQwg6a8nMdp1BsXF1goaiUjznOr3KBtRKTTh98UR/lM=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=rhZ42ufg2qQLvmWv7/0rHGG0UzXYg9XrQ1JdbWk1jwgzp1VSFWeNKOX/cq+mt0rEp1u8MKNqAoVt6k3S/wfJUkk2+QHV4Q/LsJbm6KlrGUYBJtRCtM5eu5o3Va1IRH/DUoY0T5LUrgtdDrh1xT4NjlAnHTlL1chFVP0+Mz6EpDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=CTTpYiNh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=YA82QPSJ; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.nyi.internal (Postfix) with ESMTP id B737E1380262;
	Tue,  2 Jul 2024 13:07:15 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Tue, 02 Jul 2024 13:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1719940035;
	 x=1720026435; bh=02lqCeohhDRoeVg0KpfzdqcfaHWT7DV6FXoK/ZsOGDU=; b=
	CTTpYiNh2+vqYbxoHmNRAOgDMs157QY/20a+zn0hbHZ/0BO5Oc4CkLJssMVI6rMw
	sXryWlTUzM3ijsSC0piB5nzqbZDy4ZfLM6ssHloiLPLD2lmBsd2+rHiFA8vfwjXF
	Frn9so4Vwbgl1tQonJEiEsX/Qv/ngCkpwO5MGm9e5stix3WgkME9ZZSnKyGZx0b7
	cU2Zv2OlrYte8mcc3BuoCwZPiTO8I2luRwHD6i0RjTsu8FzG4lZxOMDtDJrtlgRY
	WAr31O0JCryI6S32ZiKPvV2pTNF+R84Sf+bbOVmI/qLrtTl8hcLC41zP+d3dv4ch
	TxPGjf/DpVNTr3gvdINuHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1719940035; x=
	1720026435; bh=02lqCeohhDRoeVg0KpfzdqcfaHWT7DV6FXoK/ZsOGDU=; b=Y
	A82QPSJkwu1JEznu+WPK3XsFoDLipQJZwigGRTPV0cuTHEDFKSBheA2T4PxHz1Ql
	YcUZg7Br33Ehj/sXL6vMen7Sy1T9ei5v8jN9GFs1TM/+or4gEbPyuIwSoeVYYADM
	J7Nk5KwBjm0QCJmyTrrDDcvMkXo3y5aPts2m1X2ylLH3rLtn3wlbwJ3nu6Ncy4J9
	vsrQqxUsK9+DGw4Zp2y5c0ip7qdpMRy/4TQQv5V8tL+j0hnbJ6O0i7dKpPDoQ97v
	GGN7IywolM3Sd7Q9/vLv7cPOmootTvFEGwaAqo5GGFfyYy6H3U0z6H4qnT7nkFvH
	pRe7UGUg7UU2OY/cYPczw==
X-ME-Sender: <xms:wjOEZr2uB0qim3zm7640K329vCwA47OaIp2UJyBSNNnAqFqRuwT0rQ>
    <xme:wjOEZqFQdbAPAzmOOfak2VeBMbb7v_5Tbu1uFCc17293DgbQHQIMTOyaUbb8GvuL9
    dATNpJOhOP9I6fs_TY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudehgddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeegfeejhedvledvffeijeeijeeivddvhfeliedvleevheejleetgedukedt
    gfejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:wjOEZr5SMHIz7DCEE-mfkPvOaQqCI3ivt-DpU3uILf0MKkyWuxlvsA>
    <xmx:wjOEZg1b9ViA-A6rdu85ok19R8zbDdh8PBv1ZJzBeaCtij7NW-dbCw>
    <xmx:wjOEZuE2hcK4KlR8yu0KqUxL-DLKRbfsNhxd78kCiKY9c4AkwNQdlg>
    <xmx:wjOEZh8gWbgct-iLqfDifofA3NDZZZC1BeWyO2duTglo-m0EEl2EoQ>
    <xmx:wzOEZp94g-39Q7Dr71ulB24ZRP8O483QGADs4er7MnppTCiMYDzRE31a>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id B8572B60092; Tue,  2 Jul 2024 13:07:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-566-g3812ddbbc-fm-20240627.001-g3812ddbb
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
In-Reply-To: 
 <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
References: <20240625110029.606032-1-mjguzik@gmail.com>
 <20240625110029.606032-3-mjguzik@gmail.com>
 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
 <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
 <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com>
 <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
Date: Tue, 02 Jul 2024 19:06:53 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Huacai Chen" <chenhuacai@kernel.org>
Cc: "Xi Ruoyao" <xry111@xry111.site>, "Mateusz Guzik" <mjguzik@gmail.com>,
 "Christian Brauner" <brauner@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, "Jens Axboe" <axboe@kernel.dk>,
 "Linus Torvalds" <torvalds@linux-foundation.org>, loongarch@lists.linux.dev
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 2, 2024, at 17:36, Huacai Chen wrote:
> On Mon, Jul 1, 2024 at 7:59=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> w=
rote:
>> On Sun, Jun 30, 2024, at 04:39, Xi Ruoyao wrote:
>> > On Sun, 2024-06-30 at 09:40 +0800, Huacai Chen wrote:
>> >> >
>> >> > Yes, both Linus and Christian hates introducing a new AT_ flag f=
or
>> >> > this.
>> >> >
>> >> > This patch just makes statx(fd, NULL, AT_EMPTY_PATH, ...) behave
>> >> > like
>> >> > statx(fd, "", AT_EMPTY_PATH, ...) instead.  NULL avoids the
>> >> > performance
>> >> > issue and it's also audit-able by seccomp BPF.
>> >> To be honest, I still want to restore __ARCH_WANT_NEW_STAT. Because
>> >> even if statx() becomes audit-able, it is still blacklisted now.
>> >
>> > Then patch the sandbox to allow it.
>> >
>> > The sandbox **must** be patched anyway or it'll be broken on all 32=
-bit
>> > systems after 2037.  [Unless they'll unsupport all 32-bit systems b=
efore
>> > 2037.]
>>
>> More importantly, the sandbox won't be able to support any 32-bit
>> targets that support running after 2037, regardless of how long
>> the sandbox supports them: if you turn off COMPAT_32BIT_TIME today
>> in order to be sure those don't get called by accident, the
>> fallback is immediately broken.
> Would you mind if I restore newstat for LoongArch64 even if this patch=
 exist?

I still prefer not add newstat back: it's easier to
get applications to correctly implement the statx() code
path if there are more architectures that only have that.

       Arnd

