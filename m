Return-Path: <io-uring+bounces-2398-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACEFD91DE8F
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 14:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 615841F23AD4
	for <lists+io-uring@lfdr.de>; Mon,  1 Jul 2024 12:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1286514B08A;
	Mon,  1 Jul 2024 11:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="VC66qgtq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="pXCT8ZF7"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh6-smtp.messagingengine.com (fhigh6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7992114AD3A;
	Mon,  1 Jul 2024 11:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719835176; cv=none; b=I6stQIWbPa8tvQlmaEryUCafs5hIBUDydTLvNzblwt1DASGZAsRFL0swsxiguZxOWoA7zY+5raPkVrDyBO2x+bbvb0T84hh7AbvaAfmfBihK7qQbRSwQ9G/ZZRQ9T4dwkUiyDtsjxDjDXUNZq/KO5cgu8KlmrCgxaXEaeRq00/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719835176; c=relaxed/simple;
	bh=0ku05XJrAjTZTejqmaVQxaIEziireIHvW6LnDpuxlec=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=AY0PW+fHn+wsUAFyJ2XJ7zvHj2BexQSsYSwpsdok/y/MpYZ4EcoZPMQU6JfRYH7SCe2sjGVWgV4KJbQye8RURTItLWwk9vZG1pra98jpZp6c+hnHHd9EXGt7qlWKBGMsRKdjC01tY7jX7cnL4FRYqdfr8ZEr9uzL2l3S16yuPwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=VC66qgtq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=pXCT8ZF7; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id A13A211401FA;
	Mon,  1 Jul 2024 07:59:34 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Mon, 01 Jul 2024 07:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1719835174;
	 x=1719921574; bh=3pqX5jXkyZwQM2k8YThla4nhvHoVmaxSyoEecqI36uo=; b=
	VC66qgtqdG7LsO8I8ky+Ow6RnM72z/T/P9hFSisalIKxoC+s7mMlhwIk949lBwzo
	gjer10Q060g4z6PVOux0cYv65fJW1XbvYkSBTsn6Ahji63YzCsoG89liw6Cmm7S1
	C8TPzthfzFhJg0YyE9YXZWzREZ8IQai/MpJfMSQ8n70RF8yVpoVBUSaoUCcODAmT
	nIQw12/Q4SSjN2lIuI5LEpFePPw9KXlQT0/KljFT1YwofwhhcwzpPz8owaF0gnXG
	wPZGHa78hI12ZMQiOi5LRJJD9IkblQgG9UWURYw+YScpq0RSAh4PysH1UufZeVgX
	JjcA6HcURbJLp1bqeuAN+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1719835174; x=
	1719921574; bh=3pqX5jXkyZwQM2k8YThla4nhvHoVmaxSyoEecqI36uo=; b=p
	XCT8ZF7nFeaNlv5oLGXxNzvIrIysC8liKEXqVh/izOHe6r/jyFCbxmP/1Qqdt/MY
	JCuZQMQLHiPrGVbpTBw0ng73OUZ6m0YJ7mJuKGaqzLqzhvqn2+1ZN6q3hibFpD4w
	YuucA1kQUfSSk71wSa/+NMRCzd/CF/067pdJ1EoUtBK/aI6YitZAmoGP5WpMHrdU
	f40jbYLzTe38iSR2brVQT+amt+hPsKpg9tipVR0l9lwGF9Ytcs5YL5mwVJdQwZec
	EpKTDyje2i+zxvr18Sb6EIXpCsjyynxMXCRuC5vsqc5jIJsOHhNdt2ibstNWE8IA
	hkhacZeD4fcrt86wQSYQA==
X-ME-Sender: <xms:JZqCZsxcJE6FkhmOhZHd60Sz4T-1KYZNMPNXoZBrw8VIYTh3jKhKBw>
    <xme:JZqCZgTn4KyprCTX4Vk75aLRQ2iHLnnAjHnQtAP1KfoN3AxpreIWJKjWkMRD1CBH7
    uqEQTPiAdOGEbNXdG0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudefgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepgeefjeehvdelvdffieejieejiedvvdfhleeivdelveehjeelteegudektdfg
    jeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:JZqCZuVMYBIkXDD6oqFUlgu0zfkT6NuqzYHPRTGV-E1jCOquhBiKTg>
    <xmx:JZqCZqjnFRZ0Lq5R_gmXB84igaHpPBscWooKrLDpOkjRwc1b7kS3cw>
    <xmx:JZqCZuBWmJCkkLCr9xwq5G2VUaTAAkNNYwQpIUuGY2zDqWpc5iDU9Q>
    <xmx:JZqCZrLZUEbVnk0OoDZPYzwfP9wuAah9JriHZoGlC0GoqY80MFvePg>
    <xmx:JpqCZvK8eB-kPZWbt1OPrao0nZt_7tAwaeT78MbUZezNbhdLaLolBCi_>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 9D034B6008D; Mon,  1 Jul 2024 07:59:33 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-566-g3812ddbbc-fm-20240627.001-g3812ddbb
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com>
In-Reply-To: <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
References: <20240625110029.606032-1-mjguzik@gmail.com>
 <20240625110029.606032-3-mjguzik@gmail.com>
 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
 <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
Date: Mon, 01 Jul 2024 13:59:12 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Xi Ruoyao" <xry111@xry111.site>, "Huacai Chen" <chenhuacai@kernel.org>
Cc: "Mateusz Guzik" <mjguzik@gmail.com>,
 "Christian Brauner" <brauner@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, "Jens Axboe" <axboe@kernel.dk>,
 "Linus Torvalds" <torvalds@linux-foundation.org>, loongarch@lists.linux.dev
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 30, 2024, at 04:39, Xi Ruoyao wrote:
> On Sun, 2024-06-30 at 09:40 +0800, Huacai Chen wrote:
>> >=20
>> > Yes, both Linus and Christian hates introducing a new AT_ flag for
>> > this.
>> >=20
>> > This patch just makes statx(fd, NULL, AT_EMPTY_PATH, ...) behave
>> > like
>> > statx(fd, "", AT_EMPTY_PATH, ...) instead.=C2=A0 NULL avoids the
>> > performance
>> > issue and it's also audit-able by seccomp BPF.
>> To be honest, I still want to restore __ARCH_WANT_NEW_STAT. Because
>> even if statx() becomes audit-able, it is still blacklisted now.
>
> Then patch the sandbox to allow it.
>
> The sandbox **must** be patched anyway or it'll be broken on all 32-bit
> systems after 2037.  [Unless they'll unsupport all 32-bit systems befo=
re
> 2037.]

More importantly, the sandbox won't be able to support any 32-bit
targets that support running after 2037, regardless of how long
the sandbox supports them: if you turn off COMPAT_32BIT_TIME today
in order to be sure those don't get called by accident, the
fallback is immediately broken.

      Arnd

