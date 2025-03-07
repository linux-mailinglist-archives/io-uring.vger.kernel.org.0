Return-Path: <io-uring+bounces-7021-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84024A5700E
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 19:06:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01F77188E9D9
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 18:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B231D217670;
	Fri,  7 Mar 2025 18:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gnoedEDU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A801607A4
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 18:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370769; cv=none; b=sU+gsrs7Bu5jRzrjhLAjHwcsIz8pwK10pLzKG7gjB+TEEFpN2s/GRGjiewoyD9SI3d07biwET861USwbkOMhu6VEjKXHyB9AHS+VSPGIDYdyBEIap1DZwfDxr4Lf9mq/GlP0Ek36UsJ1eTwdspKQZi2FsrwuGWMAwpbHkwjtSYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370769; c=relaxed/simple;
	bh=55Bxa5e+uYLKtAEwyFVa4DeVicBOJE3a0dDuUW7S52s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mStnzp78SuzxGEuaBDPSYyh0EdUwEpal2vxjw22qbSTnixe0lw1lZZZr2a2puzFJccx9mucqvWnAkWcspQWGM/gP1DWC1CzBHd2mV+KdM/NautEQbpZM6Dmg38ZsK/h79OcLQEVpnZnjBPD2VrumpbhDZnx9nP1qnSVFDMxlonc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gnoedEDU; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d2af701446so19220865ab.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 10:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741370765; x=1741975565; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/D0MORNrVvAv3CKZ2lKyVwqJEGZ1KVumwUcLv6GwkKQ=;
        b=gnoedEDUj18O3q/8NbCjVZRZMCoThkQxGr+EQN+Kvrs7OSO9Yb+fyFhnxmt5IJgNf3
         RC53eyu1Mn+NS4qqFLFvaqRQ7iWJWiSF5mf9zkRGZo19z+u9/r70mGNuglMsFt+me4Di
         YI8k/7nfMuREOL76H4eLzgHFmCp6fUylTDStHlme6oEhCSCiK+Wh6sQvt3s32ycNQ0X/
         2hyW/dADYJ/epnCluTPSYXaKizAjN8UJIgEMKnvTQkmReWIn6ZtzhstSN7EXHpOOwRPS
         olyk2UIFsyhTPxZ94ADyYBQChneMd62Icxs2Qz1xWlqiGJFAbLDFFTqEhG4zLl3APJcM
         paCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741370765; x=1741975565;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/D0MORNrVvAv3CKZ2lKyVwqJEGZ1KVumwUcLv6GwkKQ=;
        b=VImRA74Lq+qvLhmYzIYAjalhG4MJSBTrB94gA+HHcBqE/m8wSjKWr7CfLUGOCg/8+s
         BYbYd4W7OIQ7W0IRtxCRUXOye6BWJL09q9EFWHdLa/AVMhl/i8j67sngwiXRyQ2dVyxK
         5aor01YJyOJAMViDWAewGD/pqtqyi8xCMpRjO/NppgougetND3plV0xWhjHK1r1yKIX1
         WG2pLN545w/HiU/gBS/gnebVwcNfMpV0xikC045GjdHw2aEyG6138xsRJ5Ipnlp/TINN
         3t9+2vzP+OT+yTRTeu+Z+6e0mneIkMbJ0hx2nexGSTO4dKnk6zyg7+O5hYqHc0BVLYqk
         7CcQ==
X-Gm-Message-State: AOJu0YwjkiDJ8/UBVtBzXM64lJ7Y1IXHOhfXDB++9okQPZiFcjCHiB1p
	ovuXK4vFCx6bFC0gfuKmh4L1gBAhMZQiJ5YXC6GydYx4Cl/306Xk8PNtgkSH2Io=
X-Gm-Gg: ASbGncsiNJ7OA/M3Mvbr/wBw2ya4XfVfpeQcJG5S3WazupSWNC2Xkg7p0lza3mCLt43
	Po7JPKqfmAz8WDPyC/JQaI3qw71JONuIgm4oeQzGlAc7BViyXGvKHGbobrZL2dlScbMFWvet412
	jVX6zPfr+/MeRqsNnRN6X98FlVHsNrbac2Fql5aYoIKmwxR5IP64XKN1pZTksbUedtb+ER760Oj
	C87Ay0q5SxZVzLFBQK4/NCx77SH5cHLJ4LqHWkbT6Pp30trKcvjydtq8YOzFuydZeAbZPVBxhjX
	j4DOyF0yjjMUrPdNKfszD4XY/hItDlD/m7cTyTEI
X-Google-Smtp-Source: AGHT+IF+aipRpt9OZaWYeYmDywK8Jqs2j8vfCs7oHJB2xFwcBPe3xksmTwzbvZai+DT7KfIxwpN2GA==
X-Received: by 2002:a05:6e02:3f88:b0:3d1:7835:1031 with SMTP id e9e14a558f8ab-3d4418a5d8fmr62864775ab.7.1741370765504;
        Fri, 07 Mar 2025 10:06:05 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d43b5869absm9322155ab.51.2025.03.07.10.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 10:06:04 -0800 (PST)
Message-ID: <2018ed5c-2be8-4237-b09d-4d9cdbae8c33@kernel.dk>
Date: Fri, 7 Mar 2025 11:06:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/4] Add vectored registered buffer req init
 helpers
To: Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <cover.1741364284.git.asml.silence@gmail.com>
 <60182eae68ff13f31d158e08abc351205d59c929.1741364284.git.asml.silence@gmail.com>
 <CADUfDZpzxCDR8g7iP=3wSRMJW6q3fACEgLFvYYHHG_yDd=ht=A@mail.gmail.com>
 <ae241647-3d95-4989-a733-c9271b45dd50@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ae241647-3d95-4989-a733-c9271b45dd50@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/7/25 10:26 AM, Pavel Begunkov wrote:
> On 3/7/25 17:10, Caleb Sander Mateos wrote:
>> On Fri, Mar 7, 2025 at 8:22 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> ...
>>> +IOURINGINLINE void io_uring_prep_writev2_fixed(struct io_uring_sqe *sqe, int fd,
>>> +                                      const struct iovec *iovecs,
>>> +                                      unsigned nr_vecs, __u64 offset,
>>> +                                      int flags, int buf_index)
>>> +{
>>> +       io_uring_prep_writev2(sqe, fd, iovecs, nr_vecs, offset, flags);
>>> +       sqe->opcode = IORING_OP_WRITE_FIXED;
>>
>> IORING_OP_WRITEV_FIXED?
> 
> Good catch, that came from a prototype where it was based on
> that opcode, I should just use the helper in the test.

Both also need an ffi addition in the map.

-- 
Jens Axboe


