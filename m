Return-Path: <io-uring+bounces-713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 884B1862A4A
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 13:21:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70BB51C209E4
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 12:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D3410A2C;
	Sun, 25 Feb 2024 12:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fBus6tpb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A13B10A09;
	Sun, 25 Feb 2024 12:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708863705; cv=none; b=mfLEPbhoKFm0BNk8BSzskDL1MlEOFivE6rh+7ggQgeV2afDzBML9VgwZuGeepsymUOcwZA0HJwZlb9KmhpnKF4F548x+7033vCuysF5GNyboyzJOVgGMjUGEMGrVPUjgelTMRGzd6pLnMxBXbhzTgw7ibetPfZN5lka4Mkiix/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708863705; c=relaxed/simple;
	bh=ELyAkhv5yDMxG88tr/ySEunJISyDJdrT7sB2ZiE2whs=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=CFcZiVoQdtXddN14S6V9lqVfsEMToQRe4xs86r3qFJyaDi4yD2DVcnA8CVStZDMdAIoEPU1iDFteAHiS/1TW9/oWhn2gOrthmOHfQFqIbq/hQB0mk9Q/d865sNJ8p0u4Jz5hEwHEKOUWMJyZKqVXypTW63ubz1Md9ORYNHXUmMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fBus6tpb; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-599f5e71d85so1715145eaf.3;
        Sun, 25 Feb 2024 04:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708863703; x=1709468503; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1VsrEW364NLFbMOpVdWrVpVClR5o3UGDnlsGXHcP8Ms=;
        b=fBus6tpbeT6ZIZEBFtwssqdxwrmZEaa9+fRR+I+D1R5ZDIAH8CP+UVL5URm6ic5+vw
         FVdJgozosVxpccoLeL2QxG49Tboo1GUSp/dxKGL/G9qZ7BXAszhGrEsZYVHGNnZuc4w5
         yoGMGB6fK+oeSEUYDvKr9uKJjY5sl9n+Araizfl4flnfOIZx6oTPEygq8Cyrxkj/u4FC
         gQp9z093dRCRJch5scXagcXJkLZ9tNVKNKg2OaVKfk4OSnWjweRAa5oyQklNkHILgCKb
         2yKYEBbpVHZKMaXAcd1j+YcJCRfGoEEhaw7PreElAE9CZJbBx1MO5MJ9HjL+7Ik8UyG9
         rdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708863703; x=1709468503;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1VsrEW364NLFbMOpVdWrVpVClR5o3UGDnlsGXHcP8Ms=;
        b=swiDKTqbktQ+jQUl6RiDjpA190xcjH/uHl5pCdfkRbxcyIJC5OdeHu+LalTSr/Rge+
         rm+oLAaGH7O/vJAwNN0tNy6hrBr1cbrCOnzxkT8SQnnOhHac9RiCunfj/Q3NLIKPKTIq
         2V8a9VvMQxlI83r12U+/yWspH6tSlK5+OdkpkpL8hDN/DdjSfPEb1vXYEJzpSWJJj311
         61spMicFCQSOtwW337mdTja5Wjw8U9MrM5fdULZZeRGxhUxfAV8FglMQF+9JC+5Phr+S
         +BHS1BPQORNDQ9aNRXYmAi8XSlXwNQPiqIuW1CIzkZ+zVl09hfGc9Ir3aFPQ3PeWMxJU
         U7uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSM7hI11rug8wJgKUi1mBiXB8vpDkzWKTqQiXr2ak2ROqPO77NH1SfEHvEOi0UuIcIsvIqdblxsqSzYZjUtOq78QdF9MjNQDlBAslQYt2AWAOBBin2Twnibhe21jpIiFBUnWl9IwPOgXL8p+FzFB4zwv2AVqF4S3zOCEkYRS0KC72OI3W8hpxEBhOTg6y0Icd7ATDFkJRocg/JaC65jf4YOZ0ymWzm0j/Lj7R7vlv0f62mmPWOlA5vDSowtrrI
X-Gm-Message-State: AOJu0YxzKFbcjfzO9zRBbrbe+aZLGzeIH3s2lwpUC7PARAKsRLcr7YbO
	1zL/8/tl4XOR58USGq2Bpl+jhFT4A9QrAmjOknn56Jyb3a1PYBfZ
X-Google-Smtp-Source: AGHT+IHCCjz5G11xwMXvR57ze0SaNofitVx3jUtjCSoTmI46aCxCdio39YUhl9mRABM4LyLCND/KWQ==
X-Received: by 2002:a05:6358:5413:b0:17b:79ee:f9dc with SMTP id u19-20020a056358541300b0017b79eef9dcmr6073415rwe.3.1708863703133;
        Sun, 25 Feb 2024 04:21:43 -0800 (PST)
Received: from dw-tp ([171.76.80.106])
        by smtp.gmail.com with ESMTPSA id t124-20020a628182000000b006e43b99a6c6sm2395792pfd.118.2024.02.25.04.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Feb 2024 04:21:42 -0800 (PST)
Date: Sun, 25 Feb 2024 17:51:34 +0530
Message-Id: <87il2c20q9.fsf@doe.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, nilay@linux.ibm.com, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v4 05/11] block: Add core atomic write support
In-Reply-To: <87le7821ad.fsf@doe.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Ritesh Harjani (IBM) <ritesh.list@gmail.com> writes:

> John Garry <john.g.garry@oracle.com> writes:
>
>> +
>> +	mask = boundary - 1;
>> +
>> +	/* start/end are boundary-aligned, so cannot be crossing */
>> +	if (!(start & mask) || !(end & mask))
>> +		return false;
>> +
>> +	imask = ~mask;
>> +
>> +	/* Top bits are different, so crossed a boundary */
>> +	if ((start & imask) != (end & imask))
>> +		return true;
>
> The last condition looks wrong. Shouldn't it be end - 1?
>
>> +
>> +	return false;
>> +}
>
> Can we do something like this?
>
> static bool rq_straddles_atomic_write_boundary(struct request *rq,
> 					       unsigned int start_adjust,
> 					       unsigned int end_adjust)
> {
> 	unsigned int boundary = queue_atomic_write_boundary_bytes(rq->q);
> 	unsigned long boundary_mask;
> 	unsigned long start_rq_pos, end_rq_pos;
>
> 	if (!boundary)
> 		return false;
>
> 	start_rq_pos = blk_rq_pos(rq) << SECTOR_SHIFT;
> 	end_rq_pos = start_rq_pos + blk_rq_bytes(rq);

my bad. I meant this...

   end_rq_pos = start_rq_pos + blk_rq_bytes(rq) - 1;
>
> 	start_rq_pos -= start_adjust;
> 	end_rq_pos += end_adjust;
>
> 	boundary_mask = boundary - 1;
>
> 	if ((start_rq_pos | boundary_mask) != (end_rq_pos | boundary_mask))
> 		return true;
>
> 	return false;
> }
>
> I was thinking this check should cover all cases? Thoughts?
>
>

-ritesh

