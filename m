Return-Path: <io-uring+bounces-7010-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01748A56DA3
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:26:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 780AC3AB6C2
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438D423BFA6;
	Fri,  7 Mar 2025 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TNca3AB0"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D40823BD1D;
	Fri,  7 Mar 2025 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364780; cv=none; b=BJDrRaK9DPYlxigWj0injYqJ2j3bmxskScQHQQeCz6jlpD/Rh894XuZ/CRut1FYNv/fPtYsVUClyHLFBraesWLNxCMVIg33XOnVOQTir/E9lVORV0sImuFTkPJ9FRoi4cpTq6aURCdxNOzv75AvxtjnANFv0sXKdhYOMo7VyB78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364780; c=relaxed/simple;
	bh=3g5a0boB3lKThLCR+kdYjeXdg+nosxrsz2LuslXKG64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qLGivWiP5UCvriew1UXbo7yCvrFmrCoWP8enmViTZq6uwiRgODd2wUh3tN9AHA6PBNmF1tJw5G/ngj2u0uCalxsAPdJBYCYy2P+N585ny8YxHXCyJf5cvMhyRSn83nRl1HVzE4F3/1gq2TTPoFfl9ozdX1hWPLA2MPUgPxhIHcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TNca3AB0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O3aGaYemkvRbj4RAbdUwZuj51nOEHRlqr7o8EyGvJu0=; b=TNca3AB0MMLUP0N/BUfd0aAoaF
	PQPjWoTEnSlk1rKkj7nJX1+TNR9HWkFLOAeYuHaYalDOhhOZDH05wy2yOtfjAHsoNxwS9tBmHtzas
	iRXzYGh/zLHG4XFkinemCbGmWrtc6n+4U6pjk4xTXOqQCI/p/nd5R83S1nEgp45IB4F4fuvYORuOA
	4WzM8uF0gOKOyeFHvw+zmwj6hJujOeXvJeAnO7cJSzSXCgDD2M3BXIDgMUQEywjBkGEE9w58oLYvv
	E7pFuE/BVAJYPhmOFvrIaqTWZab91J6BccsBHZZMRwypK5JlROS2zZcq7pfBRi4+ucb+Li22+xw8n
	f5aoQThw==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tqaWd-0000000Dbvz-11kL;
	Fri, 07 Mar 2025 16:26:15 +0000
Date: Fri, 7 Mar 2025 16:26:15 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, audit@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] fs: support filename refcount without atomics
Message-ID: <Z8seJ5QV4nxGMf-T@casper.infradead.org>
References: <20250307161155.760949-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307161155.760949-1-mjguzik@gmail.com>

On Fri, Mar 07, 2025 at 05:11:55PM +0100, Mateusz Guzik wrote:
> +++ b/include/linux/fs.h
> @@ -2765,11 +2765,19 @@ struct audit_names;
>  struct filename {
>  	const char		*name;	/* pointer to actual string */
>  	const __user char	*uptr;	/* original userland pointer */
> -	atomic_t		refcnt;
> +	union {
> +		atomic_t	refcnt_atomic;
> +		int		refcnt;
> +	};
> +#ifdef CONFIG_DEBUG_VFS
> +	struct task_struct	*owner;
> +#endif
> +	bool			is_atomic;
>  	struct audit_names	*aname;
>  	const char		iname[];
>  };

7 (or 3) byte hole; try to pad.

Would it make more sense to put the bool between aname and iname where
it will only take one byte instead of 8?  Actually, maybe do it as:

 struct filename {
 	const char		*name;	/* pointer to actual string */
 	const __user char	*uptr;	/* original userland pointer */
-	atomic_t		refcnt;
 	struct audit_names	*aname;
+#ifdef CONFIG_DEBUG_VFS
+	struct task_struct	*owner;
+#endif
+	union {
+		atomic_t	refcnt_atomic;
+		int		refcnt;
+	};
+	bool			is_atomic;
 	const char		iname[];
 };

and (on 64-bit), you're packed even more efficiently than right now.


