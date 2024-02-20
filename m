Return-Path: <io-uring+bounces-656-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C0B85B4DC
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 09:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4C61283D89
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 08:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 274AB5C918;
	Tue, 20 Feb 2024 08:20:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FD25C5FD;
	Tue, 20 Feb 2024 08:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708417241; cv=none; b=DEcoQYcqNnS9Uz7oQZDpVqnRDaivIFVKYVD8rWGHlwvze5hO50e/iPh4H6H3YLG2b7sqd0t8m0++S7PwWTrfMxx4Ucbus958Wo2aAxa7XjSo6DhHFWGk9m2Be03m5otwKjhi+ok2HeEmRg+HGzQCBiXaV/nfS5dWp5Hs7bKeXLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708417241; c=relaxed/simple;
	bh=KPPW2NF6W8zp/5U4yZS74ji11PvDCvONjPvyuJAAYjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CfIi0CBPWBFhMtJGVPZgfrQANLt8s5oJ4Ba8f6PahvKxkXyUdyGxzKbYBLXrPsy1FhfRMJukzUspJbOMB0C2rdycd5zN0OkcF3S13i7djtErodxz5Rk6fenxMnl+YXOtykUFVvJyTvP1mKTETWc/WnWmJV9d7eLIUNY9IBieOWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EDAF067373; Tue, 20 Feb 2024 09:20:33 +0100 (CET)
Date: Tue, 20 Feb 2024 09:20:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com,
	Prasad Singamsetty <prasad.singamsetty@oracle.com>
Subject: Re: [PATCH v4 04/11] fs: Add initial atomic write support info to
 statx
Message-ID: <20240220082033.GA13785@lst.de>
References: <20240219130109.341523-1-john.g.garry@oracle.com> <20240219130109.341523-5-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219130109.341523-5-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +EXPORT_SYMBOL(generic_fill_statx_atomic_writes);

EXPORT_SYMBOL_GPL for any new feature, please.

