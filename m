Return-Path: <io-uring+bounces-653-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6323285B3AF
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 08:13:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87D6D1C2040C
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 07:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59D75A0EC;
	Tue, 20 Feb 2024 07:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gGD2tCA1"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DA02D79D;
	Tue, 20 Feb 2024 07:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708413207; cv=none; b=apUiZyO8VEQBA7p9QahNZlBu4LesZbjo2sCgUBG0iyRNdsQl1KkZJ6ddklzRFYVZFkMUN5fMwKBSw2AQmJeMkb6+ooyAbGdkfZnBewXv7puxL4IHtQIePBTdcxmYKy9JUFWQpyV2U/hbLAvLmgNdQhTl9lwYY3VOLx4oQvwKhUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708413207; c=relaxed/simple;
	bh=A0boLwLblavqe/cHPOM/gNgcEK/SXPYRkW4EUOY/Lng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksU4aw7YJ/CbNwXa7JuYKS78MC9SfQ9bs/AEj00qUw1EWqdydKBLYW/VN3XaPFDJWkEbPUYxJL/e7Oeh1o0/IU2XGPos3gj94uz0jY5+UOXIXx5P5H+q2UaXegxs+lDfUmCmA4wtB4SYwBGpzNE2ebBru45UxvUxEoC52+CkJ20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gGD2tCA1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41K62vJq024757;
	Tue, 20 Feb 2024 07:13:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=j4VxHQFYcFBNB7oDKLQRRi47zN0dSg9mJIy1fi2ZhwA=;
 b=gGD2tCA1xPLN9mKLq1YcGN2gFn2heO0+LNK7LLoX0Ymtm+6NjONDCxREBfZq6GrkA+AV
 Bq7XyigjgTxEXkhJOhtLTZt26A5VZ7U3ekIXrBqcPI+oQiKAubUqQqsW55F5TpSsftGZ
 GAtHbfLD0F/wNa425Tuxwu6bXaIkCQjqlXl8nkmWkAiA97cCw4scYDwiBD5NnD9Ipc/X
 lmnkE6KaZIFxDi3KVFZ9MsDXUOTIjPjFQoK+EZAOaZPBnpsPs32lVVmPIHVSSW+hIEtz
 +81HE898IPK/nkbZ7gEf3WgKTx6JP8pQ5oWkcnFxlyXWRahx+7jGRXVIvkssw2Zd6XSj kg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wcpf7sjg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 07:13:04 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41K6FUKx032580;
	Tue, 20 Feb 2024 07:13:03 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wcpf7sjfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 07:13:03 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41K6ifYt014343;
	Tue, 20 Feb 2024 07:13:02 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wb9u2e1uu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 Feb 2024 07:13:01 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41K7CuCt35258846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 07:12:58 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 493572004D;
	Tue, 20 Feb 2024 07:12:56 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6864720040;
	Tue, 20 Feb 2024 07:12:52 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.109.253.82])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 20 Feb 2024 07:12:52 +0000 (GMT)
Date: Tue, 20 Feb 2024 12:42:50 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v4 09/11] scsi: scsi_debug: Atomic write support
Message-ID: <ZdRQ8mPGRVidvjQI@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-10-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240219130109.341523-10-john.g.garry@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nFEswPML7UDUeZc6IcJW6G9J9Ms5rekK
X-Proofpoint-GUID: rG-L3TMM-_MNtREwhvieoiF2hLiR4_1f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 spamscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402200050

On Mon, Feb 19, 2024 at 01:01:07PM +0000, John Garry wrote:
> Add initial support for atomic writes.
> 
> As is standard method, feed device properties via modules param, those
> being:
> - atomic_max_size_blks
> - atomic_alignment_blks
> - atomic_granularity_blks
> - atomic_max_size_with_boundary_blks
> - atomic_max_boundary_blks
> 
> These just match sbc4r22 section 6.6.4 - Block limits VPD page.
> 
> We just support ATOMIC WRITE (16).
> 
> The major change in the driver is how we lock the device for RW accesses.
> 
> Currently the driver uses a per-device lock for accessing device metadata
> and "media" data (calls to do_device_access()) atomically for the duration
> of the whole read/write command.
> 
> This should not suit verifying atomic writes. Reason being that currently
> all reads/writes are atomic, so using atomic writes does not prove
> anything.
> 
> Change device access model to basis that regular writes only atomic on a
> per-sector basis, while reads and atomic writes are fully atomic.
> 
> As mentioned, since accessing metadata and device media is atomic,
> continue to have regular writes involving metadata - like discard or PI -
> as atomic. We can improve this later.
> 
> Currently we only support model where overlapping going reads or writes
> wait for current access to complete before commencing an atomic write.
> This is described in 4.29.3.2 section of the SBC. However, we simplify,
> things and wait for all accesses to complete (when issuing an atomic
> write).
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---

<snip>

> +#define DEF_ATOMIC_WR 0

<snip>

> +static unsigned int sdebug_atomic_wr = DEF_ATOMIC_WR;

<snip>

> +MODULE_PARM_DESC(atomic_write, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=1)");
Hi John,

The default value here seems to be 0 and not 1. Got me a bit confused
while testing :) 

Regards,
ojaswin

>  MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
>  MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
>  MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
> @@ -6260,6 +6575,11 @@ MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)"
>  MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
>  MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
>  MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=256)");
> +MODULE_PARM_DESC(atomic_wr_max_length, "max # of blocks can be atomically written in one cmd (def=8192)");
> +MODULE_PARM_DESC(atomic_wr_align, "minimum alignment of atomic write in blocks (def=2)");
> +MODULE_PARM_DESC(atomic_wr_gran, "minimum granularity of atomic write in blocks (def=2)");
> +MODULE_PARM_DESC(atomic_wr_max_length_bndry, "max # of blocks can be atomically written in one cmd with boundary set (def=8192)");
> +MODULE_PARM_DESC(atomic_wr_max_bndry, "max # boundaries per atomic write (def=128)");
>  MODULE_PARM_DESC(uuid_ctl,
>  		 "1->use uuid for lu name, 0->don't, 2->all use same (def=0)");
>  MODULE_PARM_DESC(virtual_gb, "virtual gigabyte (GiB) size (def=0 -> use dev_size_mb)");
> @@ -7406,6 +7726,7 @@ static int __init scsi_debug_init(void)
>  			return -EINVAL;
>  		}
>  	}
> +
>  	xa_init_flags(per_store_ap, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
>  	if (want_store) {
>  		idx = sdebug_add_store();
> @@ -7613,7 +7934,9 @@ static int sdebug_add_store(void)
>  			map_region(sip, 0, 2);
>  	}
>  
> -	rwlock_init(&sip->macc_lck);
> +	rwlock_init(&sip->macc_data_lck);
> +	rwlock_init(&sip->macc_meta_lck);
> +	rwlock_init(&sip->macc_sector_lck);
>  	return (int)n_idx;
>  err:
>  	sdebug_erase_store((int)n_idx, sip);
> -- 
> 2.31.1
> 

