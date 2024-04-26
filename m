Return-Path: <io-uring+bounces-1653-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3D8F8B3E62
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 19:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BE27285ACE
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 17:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA21214D71D;
	Fri, 26 Apr 2024 17:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="pE1T08Fu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aqFcdXIb"
X-Original-To: io-uring@vger.kernel.org
Received: from flow3-smtp.messagingengine.com (flow3-smtp.messagingengine.com [103.168.172.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE42D145B0F;
	Fri, 26 Apr 2024 17:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714153127; cv=none; b=X7a+K6UN4mK0LsKHo0IzL9llPspgTIUJZ8Fe1AjXmUnlu1sn0/Tk/3jqR/oncj07+KBsLX1FIdN56fHw/cLhcvUr4bl9ydfXxUWcBwhht1ZCBJnIV6kbTD08P9a9jiVF1xVV1jy8u3jIAtoya66iSxNSXTFXoNUg6KVzioJ/lvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714153127; c=relaxed/simple;
	bh=wl2WeNXK9401gewnNEkP62crFh93PXjbpWk6KFoepOg=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=Y8SGQ32kfI8Kwf0xVrYeacufgyssYCHjxU+kKAQBk4O4/QvJlD8VtfHb2AJUZ2py1HDAxRBaykGIPwuP7dSTM2LxdxIy4pBG3OsLoyhD+DzAklo7ThJQvmGICvw0XbXkF0s4x4+4raW4th9GGKZO9ZPvoNvzYyqoMJTHSMh+FRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=pE1T08Fu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=aqFcdXIb; arc=none smtp.client-ip=103.168.172.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailflow.nyi.internal (Postfix) with ESMTP id BDA42200567;
	Fri, 26 Apr 2024 13:38:43 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Fri, 26 Apr 2024 13:38:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1714153123;
	 x=1714160323; bh=LvCKd10h8SxIpHH2VnKSem369EuCERsZx0vTF5ejpQk=; b=
	pE1T08FuMVdjjQLWiDkQO7xl56PeI7A1H3IWG3+rFD9emD//4B5RuAiqikq3csH2
	HcrEwfg47R7YMmaz8Ciyl2cvIz4VVX096uNe1CYFtwsais2/erVg/FW25ZTMJvXr
	zpR/9AJQ+kMYwmkwNH/UDIyDG/M/RiXZfW1Gpp3WoGzKEMmORD8LrQExf4Uw72vT
	cf90JKVFYzecW30Y+7oynhwhYveQbKpD0A+7InyVTw6kiDVyu6WAufjR97YB+AAf
	0ZE2OG1WQzxkmWcmeCmxI8V9AL9FQ/NFoFlVnxKbEzgyPDaqo7Ijv+GlzReYpZG8
	UpsdbHxgZ38tWGTiNz9nEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1714153123; x=
	1714160323; bh=LvCKd10h8SxIpHH2VnKSem369EuCERsZx0vTF5ejpQk=; b=a
	qFcdXIb7SbWdXzU54WGeWh/iceHLfbpvJPUdGWHPNnK5IEK/9AtOR5J2UG7I0kdd
	gA+bX/lBwFYGTyhrH0iOL1YwgOqj4CO02fhLgSpzb0errJKY1KqMkKtdiEMGW0IU
	avALV8VE2nPoBWWc5kPZjknu85rpxsTco30NFcpJL3ouXip8e9tY6t5C0m3yG4DV
	i9SMC7BAXFVXlTkQ12jergSGdPKhcHmwu/rclcCs4OnoitPkDQ5s/pDGcdD2HxtV
	6evA3UfMGPMVusCn1+pAQOhpgJIj12adXuHnNCAk7/cjvkYwvImsSZiLSUZbVdMm
	WuinBDiPHs317sdol2J0w==
X-ME-Sender: <xms:ouYrZlQDaCE-0s0WHFCeHepar9j_x9KR9n-h0TbsH_sTOOeSUGEhag>
    <xme:ouYrZuz-rN1jLTr59v2lbblMmuUk9xavewvaecIEfqOvR0end1N-WP7C8qOmizXin
    NZnEkLDPhLks8tH0J0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudelledgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedf
    tehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrf
    grthhtvghrnhepgeefjeehvdelvdffieejieejiedvvdfhleeivdelveehjeelteegudek
    tdfgjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:ouYrZq3qoHAOs6UtEYzZ6Kv2th-k72ltAmHA5-EvubaY_DFzTZHiZA>
    <xmx:ouYrZtDFuilIk3W0hJ0M4DWNRr0ldDoQ2Q3XrafF-t-T9hsqUZG79w>
    <xmx:ouYrZujdQoqwaHSJ1S_IBnSUNzyXxkERFFQZf5-Uajue3KXw-499-Q>
    <xmx:ouYrZhqInTTtQzq1IvTwSb8HCKj4UX1i6i_KpDS_TtRK6OBmlMiQ4w>
    <xmx:o-YrZpX13ubRldSgrPH3yzrzP3OzJ7dh3_1MWs-FrW6tvLtURlDPgFda>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 324F9B60099; Fri, 26 Apr 2024 13:38:42 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-386-g4cb8e397f9-fm-20240415.001-g4cb8e397
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <63ae53af-023d-444c-9571-8aef9e87ebc0@app.fastmail.com>
In-Reply-To: <20240426162042.191916-1-cgoettsche@seltendoof.de>
References: <20240426162042.191916-1-cgoettsche@seltendoof.de>
Date: Fri, 26 Apr 2024 19:38:18 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: cgzones@googlemail.com
Cc: x86@kernel.org, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, audit@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-api@vger.kernel.org,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
 "Richard Henderson" <richard.henderson@linaro.org>,
 "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
 "Matt Turner" <mattst88@gmail.com>,
 "Russell King" <linux@armlinux.org.uk>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "Michal Simek" <monstr@monstr.eu>,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Helge Deller" <deller@gmx.de>, "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
 "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Sven Schnelle" <svens@linux.ibm.com>,
 "Yoshinori Sato" <ysato@users.sourceforge.jp>,
 "Rich Felker" <dalias@libc.org>,
 "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>,
 "David S . Miller" <davem@davemloft.net>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Andy Lutomirski" <luto@kernel.org>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Chris Zankel" <chris@zankel.net>,
 "Max Filippov" <jcmvbkbc@gmail.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Paul Moore" <paul@paul-moore.com>, "Eric Paris" <eparis@redhat.com>,
 "Jens Axboe" <axboe@kernel.dk>,
 "Pavel Begunkov" <asml.silence@gmail.com>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Sohil Mehta" <sohil.mehta@intel.com>,
 "Palmer Dabbelt" <palmer@sifive.com>,
 "Miklos Szeredi" <mszeredi@redhat.com>, "Nhat Pham" <nphamcs@gmail.com>,
 "Casey Schaufler" <casey@schaufler-ca.com>,
 "Florian Fainelli" <florian.fainelli@broadcom.com>,
 "Kees Cook" <keescook@chromium.org>,
 "Rick Edgecombe" <rick.p.edgecombe@intel.com>,
 "Mark Rutland" <mark.rutland@arm.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 2/2] fs/xattr: add *at family syscalls
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 26, 2024, at 18:20, Christian G=C3=B6ttsche wrote:
> From: Christian G=C3=B6ttsche <cgzones@googlemail.com>
>
> Add the four syscalls setxattrat(), getxattrat(), listxattrat() and
> removexattrat().  Those can be used to operate on extended attributes,
> especially security related ones, either relative to a pinned directory
> or on a file descriptor without read access, avoiding a
> /proc/<pid>/fd/<fd> detour, requiring a mounted procfs.
>
> One use case will be setfiles(8) setting SELinux file contexts
> ("security.selinux") without race conditions and without a file
> descriptor opened with read access requiring SELinux read permission.
>
> Use the do_{name}at() pattern from fs/open.c.
>
> Pass the value of the extended attribute, its length, and for
> setxattrat(2) the command (XATTR_CREATE or XATTR_REPLACE) via an added
> struct xattr_args to not exceed six syscall arguments and not
> merging the AT_* and XATTR_* flags.
>
> Signed-off-by: Christian G=C3=B6ttsche <cgzones@googlemail.com>
> CC: x86@kernel.org
> CC: linux-alpha@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> CC: linux-arm-kernel@lists.infradead.org
> CC: linux-ia64@vger.kernel.org
> CC: linux-m68k@lists.linux-m68k.org
> CC: linux-mips@vger.kernel.org
> CC: linux-parisc@vger.kernel.org
> CC: linuxppc-dev@lists.ozlabs.org
> CC: linux-s390@vger.kernel.org
> CC: linux-sh@vger.kernel.org
> CC: sparclinux@vger.kernel.org
> CC: linux-fsdevel@vger.kernel.org
> CC: audit@vger.kernel.org
> CC: linux-arch@vger.kernel.org
> CC: linux-api@vger.kernel.org
> CC: linux-security-module@vger.kernel.org
> CC: selinux@vger.kernel.org

I checked that the syscalls are all well-formed regarding
argument types, number of arguments and (absence of)
compat handling, and that they are wired up correctly
across architectures

I did not look at the actual implementation in detail.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

