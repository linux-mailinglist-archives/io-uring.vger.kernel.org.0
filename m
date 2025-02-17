Return-Path: <io-uring+bounces-6492-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D27A387C0
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 16:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8E1A173D20
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 15:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E314B222570;
	Mon, 17 Feb 2025 15:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pUEKoV3o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E262148FE6
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739806678; cv=none; b=gw0g3+T5hhDZHfNaZ2IM9DE7HXGSE1xLZAeiDxnLMYsPOb4ZYfPfpBvkLSCBgGkrddjGMdt7RfSVQm7jUlfsoQpoXlSH8OijDoEv7kg4oOAxNQIRDJDIJoILz862ZwMNj2fI1MNjq3UNpx7cIQJsLuFSy54T3EiELRU/gCoe29Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739806678; c=relaxed/simple;
	bh=RFhpQxBz8bxIm6J5Hi3yqnE4kQp5E78G1UMoDeUyzic=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VwBGizKttGVaKkVsnQblza+k9STDbDNVeIqwXWD4qsgjOgBCBN3gkPNPTHnpsUoVnYOingbPgi8rVNwhUheadjFmMxPot/ldPtYeH3aAFway2kBGE4OV8UQrDsf9bCDBSnNgeZUDGjOD7Xszrf9GhwHKigsVD/mRlZ/ZU/Iluck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pUEKoV3o; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3ce76b8d5bcso42064915ab.0
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 07:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739806675; x=1740411475; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pWIXxDU5Xt86urlK0gXGbjVxKZ/smK9AUvvph54dmnQ=;
        b=pUEKoV3ocFk9MWdg3XofI231fu5/azxSAr9jy7d+S2Cj/UwnpB7ktktVSGxhDhAgOR
         +TBAX+Gok/gJGG9gqBVizzvCscPwevMDMAD6QiPaz8+A8Bc5YNw7/yEiZKbdcYNO+JNp
         yJjCkuxezpv7WX7rw1ZUm4AuGcMOR6I73lw4bGxfR8WqUFSLqqETWQ4fw0ULu8uR9FRd
         yYri6U1m0jX/eAjcsW+Nb/pxRExdKq3v0PVRiNmxFDyxA551e5xR1htzACGAi5z0wsO7
         I04cABsztFHA/tFs81M8w8IMSWjVqrcKXP0kFWxy0UQ71PCYjHvuMW2qNChgNQQVkAyq
         eEwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739806675; x=1740411475;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pWIXxDU5Xt86urlK0gXGbjVxKZ/smK9AUvvph54dmnQ=;
        b=fH/aikJRI1Hb2CR9lWjHrFtdHl5QBwKN0SN1ySH9MzcuKYO8c5uj2CuPgqcLvUk886
         HerRpEorj8Gvntsi/ubUAamrdcx1Ql9WeLCN9GOg6i8HqY6mhEhc6ILajCHYjHo4Xov1
         jvXrps4HESksdXv1Rjtv8+67mtYBDFab5cFlmN+FerRGrRBQa5FNtkUaa7pVJVYp2oNY
         +KlJJFeghv1HoLpGM3ul0MUuHEesignIhEGun/y435DFs+PYQuykZvpJ6OLW/KoX88tv
         KIVsypXjkzirryaehMtanj6rn0E4I5mX/2+F86a80d9ssLXobyHDIhgaU1AxNwI/awxO
         OqGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOvCkVFXXxukgT9mgUXgu1DSz8ocnpLvoGz1AgwO6biAY/mliogx4F/WxzT2RChaW3mNyhychThw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZD8oDPl4dvwruJ5y8c68lNlBZ21ZLxuODjBx3/sZmelTYVP/Q
	Aah3V61uKM+fq0VnWOSp4jEtRwgLxSx6eeNqAchJjTccMXCNwlzg5HR6o/MBhutdyWxDN5ip2Nc
	j
X-Gm-Gg: ASbGncsuiWdgDm6MX7KmTHnP0qT6vGziT2/kZeWxOc1UQ/Ntrcq1KShkvFv2lZADY4M
	8HknDICK79o1z++XIHxkijvtW4LND+Z8umXVGYw+lbEOGeQnyclIpgvuIrsUDxoC4tD6cBycB2y
	LcOSVVtTdIgf7QJnEzBf2arTtwXKgi6Uz6yTV4e4ZUP3lZunZRe1pKw/3Ugsf1ESoJ3H6is/DvE
	DPc88L8bj8uamNyhlJ/3onlYAEKLIjRnlKNhmHAvGdMC3rzGnBU8wYWFRwH0sOAzvIs0RTjgtg3
	RhpGhkmpm4ak
X-Google-Smtp-Source: AGHT+IH4R1fIy2S3oQPTNG7eDJhwRrhONKp+gnvbL92C4n9ew78H2FxvNgnof97igEIFfoj0iOz/Vg==
X-Received: by 2002:a05:6e02:1d1a:b0:3d1:78c6:208e with SMTP id e9e14a558f8ab-3d28092d233mr89458875ab.15.1739806675073;
        Mon, 17 Feb 2025 07:37:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d18f9c58c8sm19966455ab.23.2025.02.17.07.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 07:37:54 -0800 (PST)
Message-ID: <205ed24e-238f-497e-9990-6bcb08acaf61@kernel.dk>
Date: Mon, 17 Feb 2025 08:37:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
 <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
 <c5daca6a-dedd-4d6a-a30c-00b7b942d1eb@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c5daca6a-dedd-4d6a-a30c-00b7b942d1eb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/17/25 7:08 AM, Pavel Begunkov wrote:
> On 2/17/25 13:58, Jens Axboe wrote:
>> On 2/17/25 6:37 AM, Pavel Begunkov wrote:
>>
>> The kiocb semantics of ki_complete == NULL -> sync kiocb is also odd,
> 
> That's what is_sync_kiocb() does. Would be cleaner to use
> init_sync_kiocb(), but there is a larger chance to do sth
> wrong as it's reinitialises it entirely.

Sorry if that wasn't clear, yeah I do realize this is what
is_sync_kiocb() checks. I do agree that manually clearing is saner.

>> but probably fine for this case as read mshot strictly deals with
>> pollable files. Otherwise you'd just be blocking off this issue,
>> regardless of whether or not IOCB_NOWAIT is set.
>>
>> In any case, it'd be much nicer to container this in io_read_mshot()
>> where it arguably belongs, rather than sprinkle it in __io_read().
>> Possible?
> 
> That's what I tried first, but __io_read() -> io_rw_init_file()
> reinitialises it, so I don't see any good way without some
> broader refactoring.

Would it be bad? The only reason the kiocb init part is in there is
because of the ->iopoll() check, that could still be there with the rest
of the init going into normal prep (as it arguably should).

Something like the below, totally untested...

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 16f12f94943f..f8dd9a9fe9ca 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -264,6 +264,9 @@ static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
 	return ret;
 }
 
+static void io_complete_rw(struct kiocb *kiocb, long res);
+static void io_complete_rw_iopoll(struct kiocb *kiocb, long res);
+
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		      int ddir, bool do_import)
 {
@@ -288,6 +291,18 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	}
 	rw->kiocb.dio_complete = NULL;
 	rw->kiocb.ki_flags = 0;
+	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
+		if (!(rw->kiocb.ki_flags & IOCB_DIRECT))
+			return -EOPNOTSUPP;
+
+		rw->kiocb.private = NULL;
+		rw->kiocb.ki_flags |= IOCB_HIPRI;
+		rw->kiocb.ki_complete = io_complete_rw_iopoll;
+	} else {
+		if (rw->kiocb.ki_flags & IOCB_HIPRI)
+			return -EINVAL;
+		rw->kiocb.ki_complete = io_complete_rw;
+	}
 
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
@@ -810,23 +825,15 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	    ((file->f_flags & O_NONBLOCK && !(req->flags & REQ_F_SUPPORT_NOWAIT))))
 		req->flags |= REQ_F_NOWAIT;
 
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		if (!(kiocb->ki_flags & IOCB_DIRECT) || !file->f_op->iopoll)
+	if (kiocb->ki_flags & IOCB_HIPRI) {
+		if (!file->f_op->iopoll)
 			return -EOPNOTSUPP;
-
-		kiocb->private = NULL;
-		kiocb->ki_flags |= IOCB_HIPRI;
-		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
 		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
 			/* make sure every req only blocks once*/
 			req->flags &= ~REQ_F_IOPOLL_STATE;
 			req->iopoll_start = ktime_get_ns();
 		}
-	} else {
-		if (kiocb->ki_flags & IOCB_HIPRI)
-			return -EINVAL;
-		kiocb->ki_complete = io_complete_rw;
 	}
 
 	if (req->flags & REQ_F_HAS_METADATA) {

-- 
Jens Axboe

