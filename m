Return-Path: <io-uring+bounces-3263-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2931E97E5FE
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 08:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CD351F2124E
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 06:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD5071FBA;
	Mon, 23 Sep 2024 06:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ycYwNRr4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B12DDF78
	for <io-uring@vger.kernel.org>; Mon, 23 Sep 2024 06:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727073056; cv=none; b=Lrxd3cAS+0Hil4U8o8BxIazrA2QaeWedn7aaCOGY5P2X130diCmOigSUudelxAyz9y9smONi4Ge1iRqS/WdcvVRQxGNtPDGm6bdEFyndtwdhP51m6Mp2FbL2lJErpMyk05ZbxEREqlnZdKloJSqZpn0EjDI7o1RhG5CGGUE0zic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727073056; c=relaxed/simple;
	bh=Y2Rp6Mh3oPRvtUu+mbUcpny+kHYSHTc8zKFDBW+xjFw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWlHLQm7l02QGzilTOT8Lm/V4gucMt06WCJdkyIC1z23MBUfmkWOrzx9lFE7mRjLp8M/gzrjomta7oE5JCe/AlHZXi+oOHMm3UEzzQY/SupEwY+gm29vgYqFNmhI+lllo6Yd8/75LOMB9Ypf9XSZSjxWxuqQgH8+aYZhXkFlN4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ycYwNRr4; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-42e748f78d6so30814815e9.0
        for <io-uring@vger.kernel.org>; Sun, 22 Sep 2024 23:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727073051; x=1727677851; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VWlE4/jwrvzyvaDVc7QjPWywTucisKenm+tAHehwRbc=;
        b=ycYwNRr4SODDqbZMAhBdARtTdz43vEka58swUadnUWvoKKqvVLAqDomZhhFkm1rO/S
         LmVgL+Sx8Sh+gn22mCHfOGK7+vnflKpb6JeQ1HXUOATLhuB3B56bzGPV+cl3ryG05n+4
         U7s59wzs1AsqmR0i2YRQDEjg/f9M/9PYSzJaxeRwvDDAQHBaZ0Kn3cLZ+fYMxDNV5bnJ
         GopdA/pAszoF1nUL04SoEELegromc8kpYRmZvAf6mZRlULmy8wN5VUCp7eRbPhzPq6iq
         PEVLRZVZndukA0fvIItlD8c1NNpr6SmsC8m5Rl03BUl4ib2n3fJXTYSLeDMljg2IC9fl
         ocuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727073051; x=1727677851;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VWlE4/jwrvzyvaDVc7QjPWywTucisKenm+tAHehwRbc=;
        b=p1A5+1wpDBZdemR8YtKF1ygOsGv8x1JJPHi4KgztfhUQafSRWDVvZalj4Fzl5orbBQ
         2hWBVmkUOAMBJerhABUv+jpUK4hHNtwcT95dMqs8SnJxwMDZJtQAbaYKSlCwfKlRLGGL
         opPDMB0ZY6h+pXQVpbE621aoAHCjmDKoXTSgX3x7g1IsXHjzTYe5lZCmuK5JfC7qMR0O
         2NvY3ch7mgarxA+R7XAynrJu+sw+BWTkLQy3uEzJtIU5LFJ8yBL6jgJ8Wtk0/zSyyXKX
         Eb0+tpHrG+qFySaFcWUmgRPYEDZRC/YwCwQRFyx7PAckn6KxkBQpiuvf6NI/iS0rD7AC
         cBAg==
X-Forwarded-Encrypted: i=1; AJvYcCVwxZ3adkCz+HqR//J466vnPTc8aFQOk0himtiW+SKFWDcX8kmRrwfIiiBTxTy/9wxm3ZZiJPVZgQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0G39bH/msynlkPGdc1U7f/JL8ntESY6By0G/Wa3voIVCjgqSl
	mzCRHa6ZELkjgYaFlx6sYgKrwsTaXUWDhVNUkljF5yxYzL1UFNDqWx1vh6DmXJrDh2Gk+M0fvw+
	xB6ZIvN/R
X-Google-Smtp-Source: AGHT+IHANHbriFpVTAnwbXMbE0PKCk1TVwu9FPuVTurP+Z+NrUQCJFCWnlQyTrmM+geMokzP4Ihz4Q==
X-Received: by 2002:a5d:4f0e:0:b0:374:bf97:ba10 with SMTP id ffacd0b85a97d-37a43154b16mr5330447f8f.25.1727073050940;
        Sun, 22 Sep 2024 23:30:50 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e7800299sm23599632f8f.73.2024.09.22.23.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Sep 2024 23:30:49 -0700 (PDT)
Message-ID: <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
Date: Mon, 23 Sep 2024 00:30:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] struct filename, io_uring and audit troubles
To: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: audit@vger.kernel.org, io-uring@vger.kernel.org
References: <20240922004901.GA3413968@ZenIV> <20240923015044.GE3413968@ZenIV>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240923015044.GE3413968@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/22/24 7:50 PM, Al Viro wrote:
> On Sun, Sep 22, 2024 at 01:49:01AM +0100, Al Viro wrote:
> 
>> 	Another fun bit is that both audit_inode() and audit_inode_child()
>> may bump the refcount on struct filename.  Which can get really fishy
>> if they get called by helper thread while the originator is exiting the
>> syscall - putname() from audit_free_names() in originator vs. refcount
>> increment in helper is Not Nice(tm), what with the refcount not being
>> atomic.
> 
> *blink*
> 
> OK, I really wonder which version had I been reading at the time; refcount
> is, indeed, atomic these days.
> 
> Other problems (->aname pointing to other thread's struct audit_names
> and outliving reuse of those, as well as insane behaviour of audit predicates
> on symlink(2)) are, unfortunately, quite real - on the current mainline.

Traveling but took a quick look. As far as I can tell, for the "reuse
someone elses aname", we could do either:

1) Just don't reuse the entry. Then we can drop the struct
   filename->aname completely as well. Yes that might incur an extra
   alloc for the odd case of audit_enabled and being deep enough that
   the preallocated names have been used, but doesn't anyone really
   care? It'll be noise in the overhead anyway. Side note - that would
   unalign struct filename again. Would be nice to drop audit_names from
   a core fs struct...

2) Add a ref to struct audit_names, RCU kfree it when it drops to zero.
   This would mean dropping struct audit_context->preallocated_names, as
   otherwise we'd run into trouble there if a context gets blown away
   while someone else has a ref to that audit_names struct. We could do
   this without a ref as well, as long as we can store an audit_context
   pointer in struct audit_names and be able to validate it under RCU.
   If ctx doesn't match, don't use it.

And probably other ways too, those were just the two immediate ones I
thought it. Seems like option 1 is simpler and just fine? Quick hack:

diff --git a/fs/namei.c b/fs/namei.c
index 891b169e38c9..11263f779b96 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -206,7 +206,6 @@ getname_flags(const char __user *filename, int flags)
 
 	atomic_set(&result->refcnt, 1);
 	result->uptr = filename;
-	result->aname = NULL;
 	audit_getname(result);
 	return result;
 }
@@ -254,7 +253,6 @@ getname_kernel(const char * filename)
 	}
 	memcpy((char *)result->name, filename, len);
 	result->uptr = NULL;
-	result->aname = NULL;
 	atomic_set(&result->refcnt, 1);
 	audit_getname(result);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0df3e5f0dd2b..859244c877b4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2685,10 +2685,8 @@ struct filename {
 	const char		*name;	/* pointer to actual string */
 	const __user char	*uptr;	/* original userland pointer */
 	atomic_t		refcnt;
-	struct audit_names	*aname;
 	const char		iname[];
 };
-static_assert(offsetof(struct filename, iname) % sizeof(long) == 0);
 
 static inline struct mnt_idmap *file_mnt_idmap(const struct file *file)
 {
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index cd57053b4a69..09caf8408225 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2240,7 +2240,6 @@ void __audit_getname(struct filename *name)
 
 	n->name = name;
 	n->name_len = AUDIT_NAME_FULL;
-	name->aname = n;
 	atomic_inc(&name->refcnt);
 }
 
@@ -2325,22 +2324,6 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
 	if (!name)
 		goto out_alloc;
 
-	/*
-	 * If we have a pointer to an audit_names entry already, then we can
-	 * just use it directly if the type is correct.
-	 */
-	n = name->aname;
-	if (n) {
-		if (parent) {
-			if (n->type == AUDIT_TYPE_PARENT ||
-			    n->type == AUDIT_TYPE_UNKNOWN)
-				goto out;
-		} else {
-			if (n->type != AUDIT_TYPE_PARENT)
-				goto out;
-		}
-	}
-
 	list_for_each_entry_reverse(n, &context->names_list, list) {
 		if (n->ino) {
 			/* valid inode number, use that for the comparison */

-- 
Jens Axboe

