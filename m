Return-Path: <io-uring+bounces-1230-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B86B88CA73
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 18:12:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 245411C3C913
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 17:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6CF1C69E;
	Tue, 26 Mar 2024 17:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LmNciYel"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1F617BA0;
	Tue, 26 Mar 2024 17:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711473121; cv=none; b=YNLFIn08pMYtrt5xNK6nVw24BpXHJjs4mb5NX6zBxsxmuWafU3THlU4uQqP6EbTVYMhbVPynIqsck7k4NCD7ETxUSir2UIqshH2tMpAmQ9/Gx9yarl0hhAxVr6EXhouAM2VZ9xeLwOzFsZ51GSQrTytYgXorGKfciwVT8Q3m0M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711473121; c=relaxed/simple;
	bh=31wGWIPo+c/oEpudO5XMXBMQ2M8snO+1qTCP8lP1PGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SCPuSMet0V/1vkZVHOikSpowLpbgp14Spx9I575uSD7e+Ytt4DRu2pLHqhV4icdHVA8QodGWbaRzUjtiTCosO1tW3MmtJ4G+SaJVAI7xuc83OPxfrwnJgiWYPDCXg1lsmEqAoAPOvQlaizmAVCKb8mQGEi6UYLOzDnLrOkN7clE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LmNciYel; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=2DVDjn14jcmXI06omFunOWKNfCuEsxTlBPssx+oZvkM=; b=LmNciYel9AIIAuzc17ceAVCp4g
	SbWXMbuqF6BpYr+UBRhH6+7v138c15rv0K1vu4kkMs/Yv2xP1GTKqnU9ETniAAOycQJ8800JZOd4E
	g6YdRztEFr1RkREzfq9RTioqjtEH/RpE0qVk7dNPc9S2sDl3NH43rPuPsEk9Bpi+lHsv900qmgpp3
	Dx1FtKrUU9PByLpEOW4IprjBfozF7Ot5IDSA0GXlfV9QDGSVo89HjFptoGs6cmLnaM1ByvE2LoMOe
	z9xp6yo4C3CN+GitFK6P7RyI0kS05Q0L7D8yb9YRmKu/s1OrZnEARY49fPZ2moMzKJhZDisXprzPw
	ZUIgocCw==;
Received: from [50.53.2.121] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpAL2-00000005fKX-32AV;
	Tue, 26 Mar 2024 17:11:52 +0000
Message-ID: <0a9fb564-7129-4153-97d6-76e9b3a1b6c1@infradead.org>
Date: Tue, 26 Mar 2024 10:11:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/10] block: Add core atomic write support
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
 martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
 brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
 ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, nilay@linux.ibm.com, ritesh.list@gmail.com,
 willy@infradead.org, Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <20240326133813.3224593-6-john.g.garry@oracle.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20240326133813.3224593-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/26/24 06:38, John Garry wrote:
> diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
> index 1fe9a553c37b..4c775f4bdefe 100644
> --- a/Documentation/ABI/stable/sysfs-block
> +++ b/Documentation/ABI/stable/sysfs-block
> @@ -21,6 +21,58 @@ Description:
>  		device is offset from the internal allocation unit's
>  		natural alignment.
>  
> +What:		/sys/block/<disk>/atomic_write_max_bytes
> +Date:		February 2024
> +Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
> +Description:
> +		[RO] This parameter specifies the maximum atomic write
> +		size reported by the device. This parameter is relevant
> +		for merging of writes, where a merged atomic write
> +		operation must not exceed this number of bytes.
> +		This parameter may be greater to the value in

		                              than

> +		atomic_write_unit_max_bytes as
> +		atomic_write_unit_max_bytes will be rounded down to a
> +		power-of-two and atomic_write_unit_max_bytes may also be
> +		limited by some other queue limits, such as max_segments.
> +		This parameter - along with atomic_write_unit_min_bytes
> +		and atomic_write_unit_max_bytes - will not be larger than
> +		max_hw_sectors_kb, but may be larger than max_sectors_kb.
> +
> +
> +What:		/sys/block/<disk>/atomic_write_unit_min_bytes
> +Date:		February 2024
> +Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
> +Description:
> +		[RO] This parameter specifies the smallest block which can
> +		be written atomically with an atomic write operation. All
> +		atomic write operations must begin at a
> +		atomic_write_unit_min boundary and must be multiples of
> +		atomic_write_unit_min. This value must be a power-of-two.
> +
> +
> +What:		/sys/block/<disk>/atomic_write_unit_max_bytes
> +Date:		February 2024
> +Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
> +Description:
> +		[RO] This parameter defines the largest block which can be
> +		written atomically with an atomic write operation. This
> +		value must be a multiple of atomic_write_unit_min and must
> +		be a power-of-two. This value will not be larger than
> +		atomic_write_max_bytes.
> +
> +
> +What:		/sys/block/<disk>/atomic_write_boundary_bytes
> +Date:		February 2024
> +Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
> +Description:
> +		[RO] A device may need to internally split I/Os which
> +		straddle a given logical block address boundary. In that
> +		case a single atomic write operation will be processed as
> +		one of more sub-operations which each complete atomically.

		    or

> +		This parameter specifies the size in bytes of the atomic
> +		boundary if one is reported by the device. This value must
> +		be a power-of-two.

-- 
#Randy

