Return-Path: <io-uring+bounces-697-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 587338626B3
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 19:20:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6592A1C20E52
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 18:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50195487B0;
	Sat, 24 Feb 2024 18:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YcH25fuP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D311311701;
	Sat, 24 Feb 2024 18:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708798826; cv=none; b=TO1lHHKf7mbDeNpytJ7fmj/abK6lMDUE6zPiMd32W8yxj/u96LSyV1Ji5JJDFEAubYrgBTpXcttLqc9V9qxMc1N8q9wuzKU9B1DGMK4UcS5s/KW6Vb2H8kqeC9Ro2Q3QkbPS0rgGbomriAYhEEXABvCWfmdYoycae5gWVfXFeFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708798826; c=relaxed/simple;
	bh=wcDBodcg+t6zV2TdVa+A97rNAPiwo4viJqElc/m+rF0=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=fsFztj8QVbYYXlvUwkFrDXmp+g0COAwoOhFyEkGJedqeAIsw7LK1USVZjxdDESmFK72xJnxOt+fvpjc+knYiDOrWpwCiYHg44UIflhXLJbWGjVlGgwxDz9r2bC31Uc5o2kQA4wrMHtUZifuchdsXA27Rcp8YwcLEeK2oOfkWk7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YcH25fuP; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dbd32cff0bso11389245ad.0;
        Sat, 24 Feb 2024 10:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708798824; x=1709403624; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u8CYf+uZ9YH86t+xERuTMGB2gPG/8kNfKskED5Hz07I=;
        b=YcH25fuPMQA2/7Wadqsn45YeF5WZtOLIcY3i5+FILZD+dT2dhfRhHO5/vNQcykhasr
         CnPy7JrJtGNQY/+4IVy14TJRHtlsA2GC4enEHiwKbz+6MU4AIEvuOP4gwEQHfpdayd+0
         eo5AL+ITcWYDcLowm62ZwKv1GEGQSLiTgk70dyiIlMFaOMSj6ftR6ri/HZ+H/K4ckJTP
         s/eSG1AMxaMvpGsO1DDR+C9aQhX7UN0Iq93VxtFDw4S6hwNwwKoVY1xeAFjik/pjgGEk
         j6ZamWA7NnJk+l68cjJU6TrXYaqxoYfMDx2k8PBDyK9TIMkHthJA/calLHueFvuvufBN
         Y/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708798824; x=1709403624;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u8CYf+uZ9YH86t+xERuTMGB2gPG/8kNfKskED5Hz07I=;
        b=AZ/u+EayoeIp/FzXM5SR09YSIZ/+uLQ6ipZkBFTtWC86z0wvuD83906SSGtNIC4nZE
         hulfNOLEz5FEtqVXoyOadKUWmA2fEYIC003jlNsj8cbrMj81CfSMBAQ9WCI3KdwDsLpK
         89z6ZLywhKQPJJjP/M3o9dRO6UCb+WCAonAyKVexSTZko4WJAF6jMahe/HCz0jgzKjy8
         B7hS93DSasOrlysoFPEU5Z7tN8l+zvVYSCFzuy1l0dGGUeOwZj6uGZDpNEkKtCoPRt1v
         +5iZpx1AKmCSq7EOyiD3B/+ecFA27Y509609GqCkoyvlw9rqDdhz4eNOxyET9FslDsCm
         PWzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwhT+xKVyb3cjqD8hiQsxcXdKzyK7IBVj5buo8p5MpyFKm0R+f9J4c64qtAXzEOkWW1XaSoOqLCr8E6I4pOJ13yjskltMt6OozEihV6dOLHReqAAiTWE3vjHw6f4c95Y2cRGOjt4thJSMY67lCz77y/0VJwhfmH6cnZrmpFYrqgmFz5cdCg37xrkNyPt2GxPBjBf8oK1ILGYyAqmLX85q20PSm92am+MLvgs9d1zMazcbwZcN2Xr7HgnWsWbjn
X-Gm-Message-State: AOJu0Yx6tz1ZqYWLQr1+IBc3Sw4bw+MFgmvQPsbMCh6zlsNmN+HAko1H
	6f44o7HpAPeXuM9fzcLb7QOhHH11ydF2rtuAiJyHRH1pfum/fiNr
X-Google-Smtp-Source: AGHT+IEWtpD6myPgKLDzuAWT+he2KacsEUL8k60CFxfg0quwBYfzNP4UtrxXc/p0r7aXaWfevFWhPQ==
X-Received: by 2002:a17:903:2281:b0:1d9:ce46:6ebd with SMTP id b1-20020a170903228100b001d9ce466ebdmr3808331plh.16.1708798824035;
        Sat, 24 Feb 2024 10:20:24 -0800 (PST)
Received: from dw-tp ([171.76.80.106])
        by smtp.gmail.com with ESMTPSA id g2-20020a170902740200b001d9537cf238sm1264709pll.295.2024.02.24.10.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 10:20:23 -0800 (PST)
Date: Sat, 24 Feb 2024 23:50:15 +0530
Message-Id: <87r0h12080.fsf@doe.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, nilay@linux.ibm.com, Prasad Singamsetty <prasad.singamsetty@oracle.com>, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v4 03/11] fs: Initial atomic write support
In-Reply-To: <87v86d20ek.fsf@doe.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

Ritesh Harjani (IBM) <ritesh.list@gmail.com> writes:

> John Garry <john.g.garry@oracle.com> writes:
>
>> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
>>
>> An atomic write is a write issued with torn-write protection, meaning
>> that for a power failure or any other hardware failure, all or none of the
>> data from the write will be stored, but never a mix of old and new data.
>>
>> Userspace may add flag RWF_ATOMIC to pwritev2() to indicate that the
>> write is to be issued with torn-write prevention, according to special
>> alignment and length rules.
>>
>> For any syscall interface utilizing struct iocb, add IOCB_ATOMIC for
>> iocb->ki_flags field to indicate the same.
>>
>> A call to statx will give the relevant atomic write info for a file:
>> - atomic_write_unit_min
>> - atomic_write_unit_max
>> - atomic_write_segments_max
>>
>> Both min and max values must be a power-of-2.
>>
>> Applications can avail of atomic write feature by ensuring that the total
>> length of a write is a power-of-2 in size and also sized between
>> atomic_write_unit_min and atomic_write_unit_max, inclusive. Applications
>> must ensure that the write is at a naturally-aligned offset in the file
>> wrt the total write length. The value in atomic_write_segments_max
>> indicates the upper limit for IOV_ITER iovcnt.
>>
>> Add file mode flag FMODE_CAN_ATOMIC_WRITE, so files which do not have the
>> flag set will have RWF_ATOMIC rejected and not just ignored.
>>
>> Add a type argument to kiocb_set_rw_flags() to allows reads which have
>> RWF_ATOMIC set to be rejected.
>>
>> Helper function atomic_write_valid() can be used by FSes to verify
>> compliant writes.

Minor nit. 
maybe generic_atomic_write_valid()? 

