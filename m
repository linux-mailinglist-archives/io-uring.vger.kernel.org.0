Return-Path: <io-uring+bounces-6041-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD011A19185
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 13:41:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F0511659F7
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 12:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA60212D8D;
	Wed, 22 Jan 2025 12:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoyrM/KR"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BE2212D62;
	Wed, 22 Jan 2025 12:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737549709; cv=none; b=CcUdhbSAictj+RAcMhoxRKDLbrqp1Wx+6oq9TE84CfkL2vElgSMA5hJK6pw41lWqSsP17Zq3ai49TooqJbbANd3YfQquTGMurPNZIq9ohXbPN1/GemYy4qwX04VXbv2GOdEXaSsS3SCHQmSPDio3xrwZ3+3Lz0p3VKcHJB3ihp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737549709; c=relaxed/simple;
	bh=/nRt7/FOVju0HHPP7y/y/GmcikIqd0uun9LCjQjrq7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hEKvKRUCNpQEjWg9J3CZIkOHFaOFNphESlsysqIkrRoV+spWQ15rab1Ri90RFd2UMcvkamCt/LbCr7LRqdjk8PiWyMPl6lEvEtXxfUwV4Ss2+uKtp47xjJG5VYfNhLY2aJkjPeq1qBrGmX8Ns4+9ECsGzNICft0wj6n+DsTjguM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoyrM/KR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C04C4CEEC;
	Wed, 22 Jan 2025 12:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737549708;
	bh=/nRt7/FOVju0HHPP7y/y/GmcikIqd0uun9LCjQjrq7E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VoyrM/KR3y6SyzXqcrUXIeXUzSXAukF1jTugO3Tp/XeZbDQsZz0btjWFVZexImUyA
	 GNv9Ye0JlCb6LXyPS9Jx9MVxR+Wdtkk0Ms+qZSrA1Lr8Xe+0i9vU/ISeGtF/6vb7Vs
	 1Uj3RovlFmNzqVfmuzQ82cCacT+Fx0ki2YqsVx1IY92F3iqqKCafCCMLWLqphwdRxg
	 srLeLPCzyALTJw1qCRW7tcb44xO01Rx4zDtdApARN9p2pthq2z1LppbizS751cMHo9
	 cZn++ylUYdHjeWMHwboi8qRzV/CerfY2kd1XCsOqWLze560AIlYM8svAXpyzid0N54
	 v69z43CGgr7bQ==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-30738a717ffso40026971fa.0;
        Wed, 22 Jan 2025 04:41:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUKqVG4UQOQTScLlnCjBrFmMKDZi12BERoup2VyZXTeujoY6Rg6J9s/glWmZ6JY1dfvi0Vi7hXCtDobASohYA==@vger.kernel.org, AJvYcCURoO/ywDw5Pl8qBwi9p4pyVnljK/iYiPao3+ko2R8pPSFF1JIyN4LpC6te/C4MLv1+hgdaPnoWpTBxWr/o8TfP@vger.kernel.org, AJvYcCUTzmcDIA3LpW9fUZlK213aRAmcpVoGuMm296zP0GKAOe0NceNLxF2DYZ0tP/oGKWDugZEOnlaSFYXoZBnGSsY7mtMI@vger.kernel.org, AJvYcCUXzMJs1EOc1S0Qfg7EvOLAIApE4a/Y01VQBzxNp0og+HHLddfXMrw2KCphcFcF1WG3f2vJw83Lsqs=@vger.kernel.org, AJvYcCUhrq7e6oE/j62WaesbAWQmSfgJKLUXs1F88xv0gqtCO9kadmounQWzCQvQ7ZrRBigrI0/1oK/ZEciT@vger.kernel.org, AJvYcCUtRZqq47x2MjR02ePwLTpxZQLDkXyg/PHk+FZ8rZ+e4jxy+KayMaFFoVHxYhLTujFI7XMj4M4o6me3@vger.kernel.org, AJvYcCUuD2rnEggiuXhFoo6SplY8eJbBjh0pqNoMZdLE1hekIhiG0Ij9Y4afZbyV+YeqyoSMzs72XcvxxiGVxGcy@vger.kernel.org, AJvYcCV1VcHnEi+XdJFXMd1QxDJsFt2GCvBBAc75PN/wtRaE20o0A7isaXNNZZqLSJ1i0nRd2Z9jgbCpwJIw96CjRCZWD2W1ng6h@vger.kernel.org, AJvYcCV4Fsa6oEwxkMarKgqsZ6LoPr+ywTkrol7pMfdV3JSxKpa2FddWU9Y1puunmgLG9C0W61Q=@vger.kernel.org, AJvYcCVUPAGR
 czk8MJssFfG6JzcgUi9NPmpZKxRpM69x9n6JongrYB4eyJJLAyiWx8HpPaGREmh5oRi5tGrUIA==@vger.kernel.org, AJvYcCVgt+IpKx1UwT3+h1GuwjNZI/xRLxaDq/ZuYde41XNGnMAWJmK0+A8I2arP2jYw6ySDDq7/BPVXpwY=@vger.kernel.org, AJvYcCW/rKaRjtwO20eckWhl1Hd8U9gU+6ax1NJVt/117zOm71lz4h9GUtkLqJE0gjU+nP1ZBTtevM6yJEcghA==@vger.kernel.org, AJvYcCWiYi76bcwqzm4drHmtyFI8rXphj1bZjD3LNNwVHESxKi9QXLC8GbYQG+3AUwRqDEuZJWV/E2Ve6zDVmg==@vger.kernel.org, AJvYcCWuucLsMUN+VWJyuwold4yhiALa8XQEilEKuazbig7+clgdbUySTm+e1nyMoJ0Uor99skfEKMwL0ed2+PKp@vger.kernel.org, AJvYcCXbjfRokKyYYMMdauSChuYQz7JLeQBw9YepWJbjHajMabmLKIQTbJVpXJ/Yf5PHCjVyIqyOLE+mNo2ZcA==@vger.kernel.org, AJvYcCXbm8imEMFZodtt9XomgfNMoxBGcBQM2ej0FUGytzDD1kI/zLMJ4CUa2SCLjpculQTPHvRDMvyQarRIodvS@vger.kernel.org, AJvYcCXf7G7N0M2NQhVlh4bbdQurA9xZiwLMbx660NU9zjJ0xVw4M61lJ2lynsjwjzr6RjczKQdOxGNqhQXl3A/3@vger.kernel.org
X-Gm-Message-State: AOJu0YygbY2mkegbAEPzTnpWkQfZ34u45Z9jzLKtcYI8HoXQWad1kKlU
	ZnNH8dnDCR8kew/TVhwdFxohdV1pSkU9K0dxh7lkNitB+SHJE69YrW51RLmcyAbcMtQMpCwjkIg
	ZNItjjIDVm3D3jzjgZ14bvWmyn5M=
X-Google-Smtp-Source: AGHT+IFcRSReB7hah7mapcirnp1PWu31SswN3BbR4HjBYPEG79Tzl030J0TjqkE7fYQS4xaDIi2/KgOUqh2J3fswv1A=
X-Received: by 2002:a05:651c:2228:b0:302:4130:e19c with SMTP id
 38308e7fff4ca-3072caa15c1mr71017091fa.19.1737549706586; Wed, 22 Jan 2025
 04:41:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250110-jag-ctl_table_const-v2-1-0000e1663144@kernel.org>
 <Z4+jwDBrZNRgu85S@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com> <nslqrapp4v3rknjgtfk4cg64ha7rewrrg24aslo2e5jmxfwce5@t4chrpuk632k>
In-Reply-To: <nslqrapp4v3rknjgtfk4cg64ha7rewrrg24aslo2e5jmxfwce5@t4chrpuk632k>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 22 Jan 2025 13:41:35 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEZPe8zk7s67SADK9wVH3cfBup-sAZSC6_pJyng9QT7aw@mail.gmail.com>
X-Gm-Features: AbW1kvaDj3u8bGVj1m4rnYAkpiRSTpmPAB3bThAH-GyuG2Tmgw9okzkp1e58uCc
Message-ID: <CAMj1kXEZPe8zk7s67SADK9wVH3cfBup-sAZSC6_pJyng9QT7aw@mail.gmail.com>
Subject: Re: Re: [PATCH v2] treewide: const qualify ctl_tables where applicable
To: Joel Granados <joel.granados@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
	Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org, 
	openipmi-developer@lists.sourceforge.net, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
	linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-serial@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev, 
	codalist@coda.cs.cmu.edu, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, fsverity@lists.linux.dev, 
	linux-xfs@vger.kernel.org, io-uring@vger.kernel.org, bpf@vger.kernel.org, 
	kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, 
	Song Liu <song@kernel.org>, "Steven Rostedt (Google)" <rostedt@goodmis.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Jani Nikula <jani.nikula@intel.com>, Corey Minyard <cminyard@mvista.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jan 2025 at 13:25, Joel Granados <joel.granados@kernel.org> wrote:
>
> On Tue, Jan 21, 2025 at 02:40:16PM +0100, Alexander Gordeev wrote:
> > On Fri, Jan 10, 2025 at 03:16:08PM +0100, Joel Granados wrote:
> >
> > Hi Joel,
> >
> > > Add the const qualifier to all the ctl_tables in the tree except for
> > > watchdog_hardlockup_sysctl, memory_allocation_profiling_sysctls,
> > > loadpin_sysctl_table and the ones calling register_net_sysctl (./net,
> > > drivers/inifiniband dirs). These are special cases as they use a
> > > registration function with a non-const qualified ctl_table argument or
> > > modify the arrays before passing them on to the registration function.
> > >
> > > Constifying ctl_table structs will prevent the modification of
> > > proc_handler function pointers as the arrays would reside in .rodata.
> > > This is made possible after commit 78eb4ea25cd5 ("sysctl: treewide:
> > > constify the ctl_table argument of proc_handlers") constified all the
> > > proc_handlers.
> >
> > I could identify at least these occurences in s390 code as well:
> Hey Alexander
>
> Thx for bringing these to my attention. I had completely missed them as
> the spatch only deals with ctl_tables outside functions.
>
> Short answer:
> These should not be included in the current patch because they are a
> different pattern from how sysctl tables are usually used. So I will not
> include them.
>
> With that said, I think it might be interesting to look closer at them
> as they seem to be complicating the proc_handler (I have to look at them
> closer).
>
> I see that they are defining a ctl_table struct within the functions and
> just using the data (from the incoming ctl_table) to forward things down
> to proc_do{u,}intvec_* functions. This is very odd and I have only seen
> it done in order to change the incoming ctl_table (which is not what is
> being done here).
>
> I will take a closer look after the merge window and circle back with
> more info. Might take me a while as I'm not very familiar with s390
> code; any additional information on why those are being used inside the
> functions would be helpfull.
>

Using const data on the stack is not as useful, because the stack is
always mapped writable.

Global data structures marked 'const' will be moved into an ELF
section that is typically mapped read-only in its entirely, and so the
data cannot be modified by writing to it directly. No such protection
is possible for the stack, and so the constness there is only enforced
at compile time.

