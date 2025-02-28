Return-Path: <io-uring+bounces-6852-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A0DA49309
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 09:12:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 716AF161BEB
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 08:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB411DFE02;
	Fri, 28 Feb 2025 08:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dSCouV2R"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B751DE88A
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 08:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740730322; cv=none; b=uuINI6fyW0LyLMS7Lg4SJj2KSPwieGBvnikKPIKNXBC+DZ5J4aJ+IVzXnrgujDH/MoPn4tHuAwOB0z7BnVy9jUiL0snV76yMN+yOY9/wc1yX/AYb8UNrbbW44c+QS3D/B8awrGq402t5pBIjIGvJKS27x+joUoR/WJGbq2YS7+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740730322; c=relaxed/simple;
	bh=3MNVrP11todEliC+C1E6I90DMaajBjvPsfVhvQWxcxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NzGOcGP33n7Qo0Zg4S08hhydKTYF4GHulai9mBTmXfyEt1Y9Pl1IhrT17uFQu5fi/v12PO3OBy8BvvI0Ue6iFWXjY9yviluW1WuJY+ZEzVeK53GlRLwLSzE8umdviNlFADx7587bpjg5g1vljN5l6rvdmBUvYYckYVCjolmgudw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dSCouV2R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740730319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QJMiX5JQBlxofVNED+SUwd5iuEVsRwDlgHWXTEfci4Y=;
	b=dSCouV2RZoXiBnByuoe8x8z3qVnUjwqSObJvo8QlswQE8alDOFgB7rnrTJEWp0VsBzqedo
	tVhYXKAMKPyuS9Oy/9TDpBwiw4MwEOEzwaGTcGgLgYm7jOsR55t2r8xjSP1SsRtt/KywD8
	DECwsVQOxRYUloYXtVfG3PzH/Lsd5QM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-3J5Q5S_xMVWFm-zXaQ9Mww-1; Fri,
 28 Feb 2025 03:11:55 -0500
X-MC-Unique: 3J5Q5S_xMVWFm-zXaQ9Mww-1
X-Mimecast-MFC-AGG-ID: 3J5Q5S_xMVWFm-zXaQ9Mww_1740730314
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 870E7180087B;
	Fri, 28 Feb 2025 08:11:53 +0000 (UTC)
Received: from fedora (unknown [10.72.120.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABD91300019E;
	Fri, 28 Feb 2025 08:11:47 +0000 (UTC)
Date: Fri, 28 Feb 2025 16:11:41 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	csander@purestorage.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv8 2/6] io_uring/rw: move fixed buffer import to issue path
Message-ID: <Z8FvvUMo9NmBxwKt@fedora>
References: <20250227223916.143006-1-kbusch@meta.com>
 <20250227223916.143006-3-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227223916.143006-3-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Feb 27, 2025 at 02:39:12PM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Registered buffers may depend on a linked command, which makes the prep
> path too early to import. Move to the issue path when the node is
> actually needed like all the other users of fixed buffers.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


