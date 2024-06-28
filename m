Return-Path: <io-uring+bounces-2376-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E71991B6AB
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 08:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED22FB20ADC
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 06:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35F44654D;
	Fri, 28 Jun 2024 06:04:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797A037143;
	Fri, 28 Jun 2024 06:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719554689; cv=none; b=rtGpoCOQ6yul1qq3OUuds4T8yvzRqAJ5BBkTY4dq6DnohQfcjk04FK1AzLso3BnWqLTtLLq0JQLgW1sQh+M7/eH+J5Kwg5Rf4jgj929DadBGrYcMBWxd7b9KXZvmsMlcdUhh36AdW6L6Bj5GYt+iTl/Myi/kML46dkhChfnMGUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719554689; c=relaxed/simple;
	bh=6ODeKOE4/e/Vo+oOIjM9vkmo5av3kJbjbJUl8hpcuIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGAV9pDHEBl6k1nHcMR5n/rw8J7DYtuGqL3HIP3A0HBIMW5O+ZIlTnUoMWB/WAKJYEBqCKmXl3UvNy5aouuzfIlfFtaKBDkYTrRyV5/IM/HpnoTdXhcw3R0t+xpqlUZdq4oVfhAL0enI6q/M856fg3j8YmaIje+hBENeOiYRjRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 67D2D68D05; Fri, 28 Jun 2024 08:04:45 +0200 (CEST)
Date: Fri, 28 Jun 2024 08:04:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: Anuj Gupta <anuj20.g@samsung.com>, asml.silence@gmail.com,
	mpatocka@redhat.com, axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 02/10] block: set bip_vcnt correctly
Message-ID: <20240628060444.GA26351@lst.de>
References: <20240626100700.3629-1-anuj20.g@samsung.com> <CGME20240626101513epcas5p10b3f8470148abb10ce3edfb90814cd94@epcas5p1.samsung.com> <20240626100700.3629-3-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626100700.3629-3-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Jens, can you pick this one up for 6.11?  We can't really trigger
it as-is, but it would be good to get it out of the way and avoid
someone else triggering the issue (e.g. Mikulas with his dm-integrity
work).


