Return-Path: <io-uring+bounces-6333-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95069A2D9F7
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2025 01:25:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 473C03A5DD8
	for <lists+io-uring@lfdr.de>; Sun,  9 Feb 2025 00:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E17E136A;
	Sun,  9 Feb 2025 00:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VLP++kfr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F504A07;
	Sun,  9 Feb 2025 00:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739060696; cv=none; b=l3KuX2Lq3u/pvS+uR/OCRZi1EInKskf/tqXCJInlmvv4hxTFLRFRgWnl4A2NqQXP3Wxu6z9rTfUq0Fv+j7KSJ+JomWfj1P2Q1RGiprKW1rHG5JtjvFYpzfwKFBxw4nqwGPce8zNIOsAnndyD7UkCP0l0Da7FlnclKC+aIx3qny4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739060696; c=relaxed/simple;
	bh=IKAZr58hJDs55FKhXrVcspQXGdjb9CZ3/BtCspirtEk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=cVmgW2CAAUQ1ZI0rgzYdrGaMRYKqpI+CUj3pMUG+fXT3wkrdii4J99MKnp7mVt0EtnqjPPGGEu0kTo0M4yEUGS4gNFCy3TiUGfPu4iZtvz4mOtbhkUkgfRvSDA6jzIvNKLE3kow+lWzpUo69zDqiTXRB/KDzRT2C+yEgvQLicXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VLP++kfr; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab78e6edb48so254306366b.2;
        Sat, 08 Feb 2025 16:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739060692; x=1739665492; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nYwygqXnb4gNyw2jgf9JcqDPcOy4m3T+ft06GIYSp9A=;
        b=VLP++kfrbQH+kBmvAoBwdoPPwVd4nODEi/WPOefxUzt8/1Zu308KvODvyKJTZjjnIv
         U9ynd0PB7G9WWPykKyQUY9gr6aL3KxdCba/uae1t952Ao+/3HMbuc7xC7LKQZfvoWK3c
         k0EPHrZThd0lb0TUyMqxtAREXdtDwKQKmW9g21JHBKhS6cc4kaNL2Sao10U8elMFrpml
         kh49ttTRKYbLftUfZqZVouoFBAp5KKvTywCvtaLjUDbo5vr1uqlfiHe6kNVS40QHRRza
         K4AkJhuV9J2tr0g2TqSkWDyNHORGR/lIPHDX78XNnvwE7b68ZWjtQ02WI85EAHZThGTe
         VllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739060692; x=1739665492;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYwygqXnb4gNyw2jgf9JcqDPcOy4m3T+ft06GIYSp9A=;
        b=Dh0NYzsnObhBZ34oju7egDuyETfljgJ8w167h1ufZyxBWabjTgiYM88ZI4UveU1zfH
         ODofGOcs99SwczCsqAsCjyMdtU41mU2wibiivRyPa5fLNKAXnexnWt5ds3FQMqluzrCG
         bqDThstgnWeg8JQ51QNRVY2PnGk0sDfMBz0CFtK/DKzxMJ5aHZF+9NeqF/XftIlbrPrb
         7SD0TQmBriQXiX1ttkbMaorG6OYpBWeuN1MD3727PmmYm1kZi1UUZ8misbgo/RcOGhBU
         jIrnloQRLYjHgO/kvZxARMM/isXN1ApdDpbRuEZhaUx5MpH7W6MuqZVDAb8/LfJr9fyH
         KT2A==
X-Forwarded-Encrypted: i=1; AJvYcCUK3x6aBcZrkB94+PYy9Qn92TMnGnvUG4qG6sVOYnLsgAcQnAAhLP6vVhkda9CBV5C3+mWSXLHteA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLht1iSnhJPo8vnlddDZJlTA0psRF/Uc5vUBvWp7oS17fDeYFy
	6Jf/yRCGtRSgwsZ1eOSFUy1vuUsvP7P6cFmen6JHYEVQCuRSbfc/BGEaDg==
X-Gm-Gg: ASbGncsbiBliIEOr9AwRxlQgSbDQVFZYGJAPQRVw77zOfdmAbSw4dTGrHSao10rV93B
	0HlmW1LrmvJFddLtALajju5cRxTxg0b40rg/TComDGFPXKyR/29VeYCbTx7nHjgmI/zD3y46aYk
	CDz+AM45tpyY11Xd0GgzTlLBhjWH0Vf6MkYCpnoe/UGThfHUHwblxdUJ0UEvkVwyzdWJRWsp4gv
	+aw/BVFB4KAGvlLp845K7zMobsayo/6Y+m3C7G+ErlZJ8IXHg90TrocmKtg7IyyrTMYwCt5gv31
	UpDANsOkzQUtcnSXTlbOg3tlXQ==
X-Google-Smtp-Source: AGHT+IG+R9UynwfM5TACkigkesV/SDmTx04Ipf9sR0RpVYpmE9z49qH1oUmIT/XoB6zfhnHo+qPo3w==
X-Received: by 2002:a05:6402:4497:b0:5de:3d2d:46ce with SMTP id 4fb4d7f45d1cf-5de45070ec5mr22719884a12.25.1739060692152;
        Sat, 08 Feb 2025 16:24:52 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.220])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7922efbb7sm349492866b.2.2025.02.08.16.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2025 16:24:51 -0800 (PST)
Message-ID: <e1ccb512-fce6-4ea9-bcc5-f521d088605e@gmail.com>
Date: Sun, 9 Feb 2025 00:24:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] io_uring/epoll: add support for IORING_OP_EPOLL_WAIT
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org
References: <20250207173639.884745-1-axboe@kernel.dk>
 <20250207173639.884745-8-axboe@kernel.dk>
 <48bb1b42-b196-4f17-aeee-7b7112fbb30c@gmail.com>
Content-Language: en-US
In-Reply-To: <48bb1b42-b196-4f17-aeee-7b7112fbb30c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/8/25 23:27, Pavel Begunkov wrote:
...
> But it might be better to just poll the epoll fd, reuse all the
> io_uring polling machinery, and implement IO_URING_F_MULTISHOT for
> the epoll opcode.
> 
> epoll_issue(issue_flags) {
>      if (!(flags & IO_URING_F_MULTISHOT))
>          return -EAGAIN;
> 
>      res = epoll_check_events();
>      post_cqe(res);
>      etc.
> }
> 
> I think that would make this patch quite trivial, including
> the multishot mode.

Something like this instead of the last patch. Completely untested,
the eventpoll.c hunk is dirty might be incorrect, need to pass the
right mask for polling, and all that. At least it looks simpler,
and probably doesn't need half of the prep patches.


diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index b96cc9193517..99dd8c1a2f2c 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1996,33 +1996,6 @@ static int ep_try_send_events(struct eventpoll *ep,
  	return res;
  }
  
-static int ep_poll_queue(struct eventpoll *ep,
-			 struct epoll_event __user *events, int maxevents,
-			 struct wait_queue_entry *wait)
-{
-	int res = 0, eavail;
-
-	/* See ep_poll() for commentary */
-	eavail = ep_events_available(ep);
-	while (1) {
-		if (eavail) {
-			res = ep_try_send_events(ep, events, maxevents);
-			if (res)
-				return res;
-		}
-		if (!list_empty_careful(&wait->entry))
-			break;
-		write_lock_irq(&ep->lock);
-		eavail = ep_events_available(ep);
-		if (!eavail)
-			__add_wait_queue_exclusive(&ep->wq, wait);
-		write_unlock_irq(&ep->lock);
-		if (!eavail)
-			break;
-	}
-	return -EIOCBQUEUED;
-}
-
  static int __epoll_wait_remove(struct eventpoll *ep,
  			       struct wait_queue_entry *wait, int timed_out)
  {
@@ -2517,16 +2490,22 @@ static int ep_check_params(struct file *file, struct epoll_event __user *evs,
  	return 0;
  }
  
-int epoll_queue(struct file *file, struct epoll_event __user *events,
-		int maxevents, struct wait_queue_entry *wait)
+int epoll_sendevents(struct file *file, struct epoll_event __user *events,
+		     int maxevents)
  {
-	int ret;
+	int res = 0, eavail;
  
  	ret = ep_check_params(file, events, maxevents);
  	if (unlikely(ret))
  		return ret;
  
-	return ep_poll_queue(file->private_data, events, maxevents, wait);
+	eavail = ep_events_available(ep);
+	if (eavail) {
+		res = ep_try_send_events(ep, events, maxevents);
+		if (res)
+			return res;
+	}
+	return 0;
  }
  
  /*
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 6c088d5e945b..751e3f325927 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -25,9 +25,8 @@ struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd, unsigned long t
  /* Used to release the epoll bits inside the "struct file" */
  void eventpoll_release_file(struct file *file);
  
-/* Use to reap events, and/or queue for a callback on new events */
-int epoll_queue(struct file *file, struct epoll_event __user *events,
-		int maxevents, struct wait_queue_entry *wait);
+int epoll_sendevents(struct file *file, struct epoll_event __user *events,
+		int maxevents);
  
  /* Remove wait entry */
  int epoll_wait_remove(struct file *file, struct wait_queue_entry *wait);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e11c82638527..a559e1e1544a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -278,6 +278,7 @@ enum io_uring_op {
  	IORING_OP_FTRUNCATE,
  	IORING_OP_BIND,
  	IORING_OP_LISTEN,
+	IORING_OP_EPOLL_WAIT,
  
  	/* this goes last, obviously */
  	IORING_OP_LAST,
diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 7848d9cc073d..6d2c48ba1923 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -20,6 +20,12 @@ struct io_epoll {
  	struct epoll_event		event;
  };
  
+struct io_epoll_wait {
+	struct file			*file;
+	int				maxevents;
+	struct epoll_event __user	*events;
+};
+
  int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  {
  	struct io_epoll *epoll = io_kiocb_to_cmd(req, struct io_epoll);
@@ -57,3 +63,30 @@ int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
  	io_req_set_res(req, ret, 0);
  	return IOU_OK;
  }
+
+int io_epoll_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
+
+	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
+		return -EINVAL;
+
+	iew->maxevents = READ_ONCE(sqe->len);
+	iew->events = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	return 0;
+}
+
+int io_epoll_wait(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_epoll_wait *iew = io_kiocb_to_cmd(req, struct io_epoll_wait);
+	int ret;
+
+	ret = epoll_sendevents(req->file, iew->events, iew->maxevents);
+	if (ret == 0)
+		return -EAGAIN;
+	if (ret < 0)
+		req_set_fail(req);
+
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/epoll.h b/io_uring/epoll.h
index 870cce11ba98..4111997c360b 100644
--- a/io_uring/epoll.h
+++ b/io_uring/epoll.h
@@ -3,4 +3,6 @@
  #if defined(CONFIG_EPOLL)
  int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
  int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags);
+int io_epoll_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_epoll_wait(struct io_kiocb *req, unsigned int issue_flags);
  #endif
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index e8baef4e5146..bd62d6068b61 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -514,6 +514,18 @@ const struct io_issue_def io_issue_defs[] = {
  		.async_size		= sizeof(struct io_async_msghdr),
  #else
  		.prep			= io_eopnotsupp_prep,
+#endif
+	},
+	[IORING_OP_EPOLL_WAIT] = {
+		.needs_file		= 1,
+		.audit_skip		= 1,
+		.pollout		= 1,
+		.pollin			= 1,
+#if defined(CONFIG_EPOLL)
+		.prep			= io_epoll_wait_prep,
+		.issue			= io_epoll_wait,
+#else
+		.prep			= io_eopnotsupp_prep,
  #endif
  	},
  };
@@ -745,6 +757,9 @@ const struct io_cold_def io_cold_defs[] = {
  	[IORING_OP_LISTEN] = {
  		.name			= "LISTEN",
  	},
+	[IORING_OP_EPOLL_WAIT] = {
+		.name			= "EPOLL_WAIT",
+	},
  };
  
  const char *io_uring_get_opcode(u8 opcode)


