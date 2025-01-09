Return-Path: <io-uring+bounces-5781-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3C7A079A1
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 15:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9F5C7A0FA6
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 14:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0470216E04;
	Thu,  9 Jan 2025 14:49:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BF33FBB3;
	Thu,  9 Jan 2025 14:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736434148; cv=none; b=k0rU2qCSk1sacKNAwDkbIDfoixc1IxmQFLV4hJQFRZpq6H6kYi1F6M6QMzxbawenf0GFZ6suD6xVY/FBinaEny72eCL8jexOj5iUtRcoFAf8W7KhT3rwgfrfw5aRb80+b0cecTUTCuSw1g7/MkTSFdzBBcGcBQARYaVYROLKlU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736434148; c=relaxed/simple;
	bh=46OfJedDFsal/84XtGkdidDlykadwg95odP8kEBZssY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uoHQkJ1uNH96+Nx59w/vQTLSR+n3d0MLE3Oyv95Kpd4XF2eMKkCcOnSA4lsYfklJJ6c447yx2AiQRrLEZQXzmtsPigGOnzVaRLn9ZYF9fX66IU0RhsQnWZckf5v3jqM0lOLADlh6yezWjp/vNMyGxKcZzn6jIb8FAFJFEAyTh/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F4DC4CED2;
	Thu,  9 Jan 2025 14:49:04 +0000 (UTC)
Date: Thu, 9 Jan 2025 09:50:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joel Granados <joel.granados@kernel.org>
Cc: Thomas =?UTF-8?B?V2Vpw59zY2h1aA==?= <linux@weissschuh.net>, Kees Cook
 <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
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
 linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
Subject: Re: [PATCH] treewide: const qualify ctl_tables where applicable
Message-ID: <20250109095037.0ac3fe09@gandalf.local.home>
In-Reply-To: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
References: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 09 Jan 2025 14:16:39 +0100
Joel Granados <joel.granados@kernel.org> wrote:

> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 2e113f8b13a2..489cbab3d64c 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -8786,7 +8786,7 @@ ftrace_enable_sysctl(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> -static struct ctl_table ftrace_sysctls[] = {
> +static const struct ctl_table ftrace_sysctls[] = {
>  	{
>  		.procname       = "ftrace_enabled",
>  		.data           = &ftrace_enabled,
> diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> index 17bcad8f79de..97325fbd6283 100644
> --- a/kernel/trace/trace_events_user.c
> +++ b/kernel/trace/trace_events_user.c
> @@ -2899,7 +2899,7 @@ static int set_max_user_events_sysctl(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> -static struct ctl_table user_event_sysctls[] = {
> +static const struct ctl_table user_event_sysctls[] = {
>  	{
>  		.procname	= "user_events_max",
>  		.data		= &max_user_events,

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org> # for kernel/trace/

-- Steve

