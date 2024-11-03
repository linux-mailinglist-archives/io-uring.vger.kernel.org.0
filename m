Return-Path: <io-uring+bounces-4359-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F1CD9BA44E
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 07:52:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 758201C20C5A
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 06:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B629136326;
	Sun,  3 Nov 2024 06:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="qJ9F7FRa"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD8E2F2E;
	Sun,  3 Nov 2024 06:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730616722; cv=none; b=hrP6d0+kcOdAu7mpRK5H9c3FR/9sbcMPqfhvIyiv1twpqifiN5Krmj9OzEGc1gOxUYeVud7ERIVh+IBphkDyh68sfiVaRFUIWbQRi2M+Ft8R/QJFcEOqM2s4abgnTEUGV3Fvkn9SxxlF2MA04x67/xOz1GdPQPo0GKLyIoIcMnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730616722; c=relaxed/simple;
	bh=8JfwU+ovhRO1ikKwFrXkcRZWAgSR9nZFlr7GSrXnI2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xr9h2UpiLi7fazAo06YEN3Y4C92oS2uW5qK+FZaEjgLbk0O4EyZPiGVQU9gLzfR0eMg1UNASe/BsL7ui+Iv+iVeujo9kssWSD2H7oPgCd4a4Ed477jfURr8IygE356fr5RheoZlfQkIpQ3LvnaXIm19qPLFyGNMvew4lgAvpjXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=qJ9F7FRa; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=63+ZQYbLub28/z6sbLnOEJ1j7zKdeE3rhU3waMkfJgA=; b=qJ9F7FRaXJC17HBqb4zQSLg76D
	tVtcecKHVxlqgtmThWWj74z1HyDOPSrPR8KCmAP4AW97S0fBE7b8T8ohSCCR3A3K1cWM+qRekmnDD
	4pYd9vndOCK3R1qoSThlfVKbdo6S/cBj76vc2nRpP1ccwduPvX/ghBXFngZ/hvag8Nw5Pmuel3cG3
	VaB/dFrdnyDyQeA5m8VTeBfR34fdBaeUeD39H4BhlkSWypJpJY6x0hB52e7SukM/XWNlD6W0C/FpF
	NZd5vJT7u4cg78szO2PbYdxne5bWOnkS86Y8/1k4+C5D2doAh8WnXEX/3EHPiv4abgjfmI8HuCoOA
	pL5REx3A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t7USq-0000000AeOf-28O9;
	Sun, 03 Nov 2024 06:51:56 +0000
Date: Sun, 3 Nov 2024 06:51:56 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	io-uring@vger.kernel.org,
	Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC][PATCHES v2] xattr stuff and interactions with io_uring
Message-ID: <20241103065156.GS1350452@ZenIV>
References: <20241002011011.GB4017910@ZenIV>
 <20241102072834.GQ1350452@ZenIV>
 <2a01f70e-111c-4981-9165-5f5170242a8c@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a01f70e-111c-4981-9165-5f5170242a8c@kernel.dk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sat, Nov 02, 2024 at 08:43:31AM -0600, Jens Axboe wrote:
> On 11/2/24 1:28 AM, Al Viro wrote:
> > 	Changes since v1:
> > * moved on top of (and makes use of) getname_maybe_null() stuff
> > (first two commits here, form #base.getname-fixed)
> > * fixed a leak on io_uring side spotted by Jens
> > * putname(ERR_PTR(-E...)) is a no-op; allows to simplify things on
> > io_uring side.
> > * applied reviewed-by
> > * picked a generic_listxattr() cleanup from Colin Ian King
> > 
> > 	Help with review and testing would be welcome; if nobody objects,
> > to #for-next it goes...
> 
> Tested on arm64, fwiw I get these:
> 
> <stdin>:1603:2: warning: #warning syscall setxattrat not implemented [-Wcpp]
> <stdin>:1606:2: warning: #warning syscall getxattrat not implemented [-Wcpp]
> <stdin>:1609:2: warning: #warning syscall listxattrat not implemented [-Wcpp]
> <stdin>:1612:2: warning: #warning syscall removexattrat not implemented [-Wcpp]

arch/arm64/tools/syscall*.tbl bits are missing (as well as
arch/sparc/kernel/syscall_32.tbl ones, but that's less of an
issue).

AFAICS, the following should be the right incremental.  Objections, anyone?


diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index 9a37930d4e26..69a829912a05 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -474,3 +474,7 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 845e24eb372e..ebbdb3c42e9f 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -403,3 +403,7 @@
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
 462	common	mseal				sys_mseal
+463	common	setxattrat			sys_setxattrat
+464	common	getxattrat			sys_getxattrat
+465	common	listxattrat			sys_listxattrat
+466	common	removexattrat			sys_removexattrat

