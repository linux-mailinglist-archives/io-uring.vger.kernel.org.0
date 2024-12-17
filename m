Return-Path: <io-uring+bounces-5519-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AEF19F4EC7
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 16:05:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F5AE162F7E
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 15:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856091F63CB;
	Tue, 17 Dec 2024 15:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bDzQ/g/S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B921F37B4
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 15:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734447937; cv=none; b=Md9KCXH+i4KfOqnkLUrIf1cOV/nTHmVJnGLRrifW+DIYrqUsMAJYvey4tXgwHjUvo1wXhhuNI7yr1ObnZj4hwmQ9dZFPMkg7I0OJNvaRrubZDnGTYgoPgVCwmYbsAIacX0hzhr8eQ++/3n5XwzbDbs4DPmNCvxA85jv4Ty/V0zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734447937; c=relaxed/simple;
	bh=/7udhVCPJ2b+7aWt7icALLnjQwn4vYEXhbHO12REd9s=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=qgNAbz645NOKgKI3YX4fo8w99D+BDW/Abudr2wnkoZ8SI/g9AOLtBmaJFr2RGxcGF8zu4DODxkG3tmE6Z5KUoPaIkU+BV5JzGnHMmns7hwhMAb6pqkToae7pjacibu/O2snsUCbbOod/4mKpvV/7zzOqDD3hTrHqD2QIgWTBk+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bDzQ/g/S; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a8160382d4so15859235ab.0
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 07:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734447931; x=1735052731; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6HcpSxVWYhoIqNOfeuHYR37arrFastwy4VWYmcm5FY=;
        b=bDzQ/g/SllIBhpB7I8Lkowz7ukTtqHAjpoAQOFSBR8MA8TaX9T8kZXlOiZWo7BOHip
         qLTXfRiKLw3E6tgk7uMNG2za6R5b9BYjVH0BrSYqg6kvgw24ZFicBNfHfHQIWAU8e1bb
         Tm/LYL6p+yn9iFa19B9wCLeCTsrTvLRjy/xKpFDEDzWL/0L30ctBXN68eX61nbf8PYW7
         C1nJEGFtzq5xhp+13sL3lS/CvzuyikZqOIhaj4S6PtMcIjaDyzMJxugGKSpEnJu4kEZI
         18v2vzgnFMJj6F/J7jWcZQdE8jrBdH35q/IUIa5bDnUtVa/RBCCS+L4RPWul57wHjKIK
         dFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734447931; x=1735052731;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I6HcpSxVWYhoIqNOfeuHYR37arrFastwy4VWYmcm5FY=;
        b=XIUx6VAvv1A2MYURGI4YtoKjVe+UKyvggot7bEHXqGrQgO+2Np0ocfl3/TmQFLI2aJ
         sNoGzdxZ1WwxcueBPxfstigN1P5xGrJS5iGxCFEfhsWsRt4VAzFYIrJm30xjkog0b7nK
         Ovsky1Ys0YPMyOIm2/U9mRswATybX5oa987Q6dC0ZMgDsZNWCSvteFb+3Dn5goBpHya4
         06NT+zxHbJs5lfsBID6FY0Y8Pkseppmax5iCH4K0PhdObfFHStA/eW8r+TxP+9WdvTXb
         lpa14278nF3lnOPzmjM0TTGx74AMeMCD9zm6oVLb3ca8MhCcLr2xwIufMoPUvymT/N0S
         FHDw==
X-Gm-Message-State: AOJu0YwNZISsGlR/VsQ+w7dogk6rY02u3+l5SEwaR89TlaSD6XE+Holb
	twW8t+zKAdYannUQZv6tIDAk1LV50JGIrawNdRY0KwzMYAqJVBweVDd+8tVdSe4OKCJQpdwN2WA
	U
X-Gm-Gg: ASbGncsz/6gwDZhBBkadpAeLnyR3fHwBRRBhM2/O9uNkkPhvWwDfDVh1C1rGkY7LNFO
	jobP/aY3VrT9uhkgxEsyVy+7KI08IyOjO/Ejo+aiiGzAEyJZ9Sup59R9UAU3+YesLojOKBYYyii
	ceg0YtKcp90UR1m7jQMGOuSHa2PBG+iHHpczPMtEsXQwx1IlbgsrB2Ezn6P+iTsCuf+4kSGJHuX
	ZlO5bhGyxz+tG52D8IeRc8B+cef/UTsNkm20YQPuYTSw4Mfp8uh
X-Google-Smtp-Source: AGHT+IHBEbjEkjxldZkABbkQ8a6tk2v49qcxNFybdDM3a2ba9W5aL/Rlq1d51UG4FsVN7hV6gkVdPw==
X-Received: by 2002:a05:6e02:1aaf:b0:3a7:764c:42fc with SMTP id e9e14a558f8ab-3aff8b9ce4cmr177954345ab.21.1734447931126;
        Tue, 17 Dec 2024 07:05:31 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b2475afaffsm21148325ab.10.2024.12.17.07.05.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 07:05:30 -0800 (PST)
Message-ID: <1c89cb7e-ddd0-4e22-a04a-4579855b52f2@kernel.dk>
Date: Tue, 17 Dec 2024 08:05:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: don't mask in f_iocb_flags
Cc: Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit changed overwriting kiocb->ki_flags with
->f_iocb_flags with masking it in. This breaks for retry situations,
where we don't necessarily want to retain previously set flags, like
IOCB_NOWAIT.

The use case needs IOCB_HAS_METADATA to be persistent, but the change
makes all flags persistent, which is an issue. Add a request flag to
track whether the request has metadata or not, as that is persistent
across issues.

Fixes: 4dde0cc4459c ("io_uring: introduce attributes for read/write and PI support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

The identitied commit breaks test cases which end up reporting -EAGAIN
rather than just blocking/retrying. I have not tested this with the
metadata path, so please do that...

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c141ffec81fe..493a8f7fa8e4 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -480,6 +480,7 @@ enum {
 	REQ_F_BL_NO_RECYCLE_BIT,
 	REQ_F_BUFFERS_COMMIT_BIT,
 	REQ_F_BUF_NODE_BIT,
+	REQ_F_HAS_METADATA_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -560,6 +561,8 @@ enum {
 	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 	/* buf node is valid */
 	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
+	/* request has read/write metadata assigned */
+	REQ_F_HAS_METADATA	= IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index bdfc3faef85d..d0ac4a51420e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -283,7 +283,7 @@ static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
 			  pi_attr.len, &io->meta.iter);
 	if (unlikely(ret < 0))
 		return ret;
-	rw->kiocb.ki_flags |= IOCB_HAS_METADATA;
+	req->flags |= REQ_F_HAS_METADATA;
 	io_meta_save_state(io);
 	return ret;
 }
@@ -787,18 +787,17 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct kiocb *kiocb = &rw->kiocb;
 
-	/* never retry for NOWAIT, we just complete with -EAGAIN */
-	if (req->flags & REQ_F_NOWAIT)
+	/*
+	 * Never retry for NOWAIT or a request with metadata, we just complete
+	 * with -EAGAIN.
+	 */
+	if (req->flags & (REQ_F_NOWAIT | REQ_F_HAS_METADATA))
 		return false;
 
 	/* Only for buffered IO */
 	if (kiocb->ki_flags & (IOCB_DIRECT | IOCB_HIPRI))
 		return false;
 
-	/* never retry for meta io */
-	if (kiocb->ki_flags & IOCB_HAS_METADATA)
-		return false;
-
 	/*
 	 * just use poll if we can, and don't attempt if the fs doesn't
 	 * support callback based unlocks
@@ -849,7 +848,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags |= file->f_iocb_flags;
+	kiocb->ki_flags = file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -883,7 +882,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 		kiocb->ki_complete = io_complete_rw;
 	}
 
-	if (kiocb->ki_flags & IOCB_HAS_METADATA) {
+	if (req->flags & REQ_F_HAS_METADATA) {
 		struct io_async_rw *io = req->async_data;
 
 		/*
@@ -892,6 +891,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 		 */
 		if (!(req->file->f_flags & O_DIRECT))
 			return -EOPNOTSUPP;
+		kiocb->ki_flags |= IOCB_HAS_METADATA;
 		kiocb->private = &io->meta;
 	}
 
-- 
Jens Axboe


