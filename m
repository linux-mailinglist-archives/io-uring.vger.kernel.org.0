Return-Path: <io-uring+bounces-5891-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C83A12C39
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 21:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAB9E3A1237
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 20:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B991D63F5;
	Wed, 15 Jan 2025 20:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMh7oPcJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A0741C6C;
	Wed, 15 Jan 2025 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736971764; cv=none; b=Ugk8Sn60d88ZwIRtxXFxN9GqYNeH8uIn37gL0zRAEcahsH5nFqDTvV7NgiAsBPuZLjxjrwLlJ4BuaimIWoIbPkqHsicf7IhPkpC4AATy9vnX4BwxIhP/DoefvR8pvm5pnFfQe6wbxJjNG4fZxlCdYTDZs5E4p190X3DM9Kmtt3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736971764; c=relaxed/simple;
	bh=HKd2BYN0EJzvcqr3Xx3Vueop4tDJh+K1d/v1F43ixq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+7M0zhdOZYP7EiMMdSTCIIHeLWGUSjl0nVr22SUUpTfU7CqYtGUMJn7Yr/9Wuv5NZkBF8nHl8jkPPqzGNUyYrVM5kkuGWWlAbeSn4pjcmiufAU1kobl2B1hyOCXYZnbnhNyJXI4432ukG5t+FKqs3w9ojeXauizxUQjwprfUz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMh7oPcJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A6BC4CED1;
	Wed, 15 Jan 2025 20:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736971763;
	bh=HKd2BYN0EJzvcqr3Xx3Vueop4tDJh+K1d/v1F43ixq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mMh7oPcJEGeeR1CbLFNvT6sYm/PkFQwDWfBsQ90yztglpZ3/YZEBVnarQ1AC7szWo
	 7TIaoC/5Ds9yuqwsCSv511HrZQrz9DYKTCs5teywBQChtbtwCLdUU15B57wDXyESFf
	 A/x13wKP5lj3nSG+MtRjOv+yVwR6g+BlMg1RaQLmyhmo5lqJ4XKmsH9giN7zUcgT0G
	 JjdlmRxxbsFDdoqRPMfd7BNNsEMs0mR8Cyqj/oCkFnsbRsTmQflWeOU3bRrVWJH9mq
	 wFz46x9sk38sYnuYTKWOXCW+bAgDPbIH7khSU1whNzE/e3Hn5P+2qU6Lun6bUVc/Ly
	 lJaxe0RpKwpyA==
Date: Wed, 15 Jan 2025 20:09:21 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Joel Granados <joel.granados@kernel.org>
Cc: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-hyperv@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev,
	codalist@coda.cs.cmu.edu, linux-mm@kvack.org,
	linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	io-uring@vger.kernel.org, bpf@vger.kernel.org,
	kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	Song Liu <song@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Corey Minyard <cminyard@mvista.com>, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v2] treewide: const qualify ctl_tables where applicable
Message-ID: <Z4gV8QNnafm-iCC4@liuwe-devbox-debian-v2>
References: <20250110-jag-ctl_table_const-v2-1-0000e1663144@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110-jag-ctl_table_const-v2-1-0000e1663144@kernel.org>

On Fri, Jan 10, 2025 at 03:16:08PM +0100, Joel Granados wrote:
[...]
> diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
> index 7a35c82976e0..9453f0c26f2a 100644
> --- a/drivers/hv/hv_common.c
> +++ b/drivers/hv/hv_common.c
> @@ -141,7 +141,7 @@ static int sysctl_record_panic_msg = 1;
>   * sysctl option to allow the user to control whether kmsg data should be
>   * reported to Hyper-V on panic.
>   */
> -static struct ctl_table hv_ctl_table[] = {
> +static const struct ctl_table hv_ctl_table[] = {
>  	{
>  		.procname	= "hyperv_record_panic_msg",
>  		.data		= &sysctl_record_panic_msg,

Acked-by: Wei Liu <wei.liu@kernel.org>

