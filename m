Return-Path: <io-uring+bounces-2304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F150911352
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 22:36:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0E9228479E
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 20:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B7C54FA2;
	Thu, 20 Jun 2024 20:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwXh+FaK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C1D3C6AC;
	Thu, 20 Jun 2024 20:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718915798; cv=none; b=SYBcY5TiivWe+vFFJDlTjdyBKxLVwHed1XduTeKW4EmBDkH52UrNKIEOR5NxlmUjOW/OKfOj16ZGbn3T9R8WwPbY0mOM20gQXRfros4f74xLKw3f2yr5IsCX0eRdN6AKRClVXhFu29Ne2wDzNh24I89hKMzGHc9j3V8idN0neW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718915798; c=relaxed/simple;
	bh=vEA8X/MKc0gI6uWmJH+jA33Ug9fWGn6Gnff22ONubZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dj2BA8bZMxtLU488g8JTbgrtlrNc79M6jvibov9xfjYy+TAvLfdUr3quX3YVq3yyBWife7qT7vlN7VuNUBykMj8LnDZO1FwQdaCwagBorH+DcxREGTsC3N6jeVxlhagAyxnBeupgheLsU2jcHEPR/IGDC3MZyXPK3/03Mr4gx+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GwXh+FaK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AB2C2BD10;
	Thu, 20 Jun 2024 20:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718915797;
	bh=vEA8X/MKc0gI6uWmJH+jA33Ug9fWGn6Gnff22ONubZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GwXh+FaKDmL85CDPsH8udBqfeZC1mmF+n15sIcBNDwsFbFBRZMyb+xpna0zMD2PLM
	 pqf/pNSj8Xn9DuVLbM7jilwFcIE7roNMHVfaWpDYYRGRC4SG8fpLBeRYVrM+hyP0Bi
	 y36HAxmaieWyUEy7hWc5dTmInhBIN8woKOjinukAIvnzW+3QeIiNEpPs7813h50kTT
	 wyzF9XYqpjMdjwns7vRDcPVOhVos9O5OcqNcwQdEk9vs5KXzSxgZieOpkG1j2x6M+v
	 qRfkGvv4gsSMGTF47/LK1UoUzDl3zNk0K2bgfrIAMyVSEfKdZjCEH6/TKbjw7ONHqD
	 JsWaPADEUONyA==
Date: Thu, 20 Jun 2024 14:36:33 -0600
From: Keith Busch <kbusch@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
	djwong@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de, Alan Adamson <alan.adamson@oracle.com>
Subject: Re: [Patch v9 10/10] nvme: Atomic write support
Message-ID: <ZnSS0Y0AFqQg-7lm@kbusch-mbp.dhcp.thefacebook.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-11-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620125359.2684798-11-john.g.garry@oracle.com>

On Thu, Jun 20, 2024 at 12:53:59PM +0000, John Garry wrote:
> From: Alan Adamson <alan.adamson@oracle.com>
> 
> Add support to set block layer request_queue atomic write limits. The
> limits will be derived from either the namespace or controller atomic
> parameters.
> 
> NVMe atomic-related parameters are grouped into "normal" and "power-fail"
> (or PF) class of parameter. For atomic write support, only PF parameters
> are of interest. The "normal" parameters are concerned with racing reads
> and writes (which also applies to PF). See NVM Command Set Specification
> Revision 1.0d section 2.1.4 for reference.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

