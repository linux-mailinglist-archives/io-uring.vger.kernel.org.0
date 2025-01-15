Return-Path: <io-uring+bounces-5890-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A8DA12A35
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 18:53:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E0877A39C2
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 17:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C79441CCEF8;
	Wed, 15 Jan 2025 17:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="O59TkAiV";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fzGlQJbE"
X-Original-To: io-uring@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE24155C96;
	Wed, 15 Jan 2025 17:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736963564; cv=none; b=as7OqnqLMcKoxSEZauhJUGRslfL9HwpuuqhIsXXMRUQlcvLYuVXExZ4MTXqKU7yFLp93AT4sRvwLdHib1N/BJ61LNL5WqU/yg2v8nVgh/T7fHUMy4IvNoxM2CeMzZhIKReOr+AnK3IJr6XeQ5R8HtzbnwWF1h6ePtXmTNEXng0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736963564; c=relaxed/simple;
	bh=SAuv4o0YPcUZA0Dnn4TAU1w9hrOHI62b2s0bpW+yq4M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QplvuKlWnT4nVi8mqnHX4Vm5dJKeDpFj+1O++IbEEzsjJMt8BNXNS4HY6xoRjddYgGAszy1KrP4zniiZQDM0jFj5SFOGeZ2RVxp9sujHScBJzHMsR1UGivVU8c664i/MvMd2DSik4n6Sx4mfw6EETGfnV6UgJ7KNsBavnC5j/sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=O59TkAiV; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fzGlQJbE; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1736963561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HoxPdbGDiDXMZjZ2YzakPSB0m74gINsG6VFgtuazYj8=;
	b=O59TkAiVIoh/kyWqt3sD2QUaiElCxlt4joNfsm5Vy47rl6VB5TFRsEG8yyBoGzvY2r/6mY
	lQrxl2KFOtZwXB8o2yGswqA28AwPR3ILexVj+8YMlHNoNTQyAqrecm5DQu43fEOAoeu1zB
	AUUJUV3mFLL/jKj4Q1eejS9vRnjN/1NreJFiVLN6lXCv97Xxmp1pRrzkdAR4+8k7oYySE3
	EjRlx3bwRLZ1kPZatpooq203bOQXFsUoJ5K9wvWgIoGkzYbbWPFekFpYB6FKtIibo4IGCl
	3qtrgWckX7984+Okk9ULQbx1KIxKVOK20qnnIXjJMWBsTxDlkgtJ8kE9XE9ROg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1736963561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HoxPdbGDiDXMZjZ2YzakPSB0m74gINsG6VFgtuazYj8=;
	b=fzGlQJbELsuQf/TIokTn215dpIYwMgfAYRUXgXNteW1TJ/rfCFCi40yte9UtrzUzNBp68H
	ns68VXLDVpNCEbAA==
To: Joel Granados <joel.granados@kernel.org>, Thomas =?utf-8?Q?Wei=C3=9Fsc?=
 =?utf-8?Q?huh?=
 <linux@weissschuh.net>, Kees Cook <kees@kernel.org>, Luis Chamberlain
 <mcgrof@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
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
 linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, Song Liu
 <song@kernel.org>, "Steven Rostedt (Google)" <rostedt@goodmis.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, "Darrick J. Wong"
 <djwong@kernel.org>, Jani Nikula <jani.nikula@intel.com>, Corey Minyard
 <cminyard@mvista.com>, Joel Granados <joel.granados@kernel.org>
Subject: Re: [PATCH v2] treewide: const qualify ctl_tables where applicable
In-Reply-To: <20250110-jag-ctl_table_const-v2-1-0000e1663144@kernel.org>
References: <20250110-jag-ctl_table_const-v2-1-0000e1663144@kernel.org>
Date: Wed, 15 Jan 2025 18:52:40 +0100
Message-ID: <87jzawarrr.ffs@tglx>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Jan 10 2025 at 15:16, Joel Granados wrote:
> sed:
>     sed --in-place \
>       -e "s/struct ctl_table .table = &uts_kern/const struct ctl_table *table = \&uts_kern/" \
>       kernel/utsname_sysctl.c
>
> Reviewed-by: Song Liu <song@kernel.org>
> Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org> # for kernel/trace/
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com> # SCSI
> Reviewed-by: Darrick J. Wong <djwong@kernel.org> # xfs
> Acked-by: Jani Nikula <jani.nikula@intel.com>
> Acked-by: Corey Minyard <cminyard@mvista.com>
> Signed-off-by: Joel Granados <joel.granados@kernel.org>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

