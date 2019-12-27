Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981A312B5B1
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2019 16:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfL0PqA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Dec 2019 10:46:00 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35789 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfL0PqA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Dec 2019 10:46:00 -0500
Received: by mail-pf1-f196.google.com with SMTP id i23so9481946pfo.2
        for <io-uring@vger.kernel.org>; Fri, 27 Dec 2019 07:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IKKrQ/vjXnebip5AhX0hhEKW/mA6sdOEgqmJWf+TxdQ=;
        b=BY9Ucb5Doa+7rQ4RDreO6AhPtEYdpqQ6Hfen8+DKzMAFKpbaGGRspXmXZAB5SoNoRo
         seI5fgi7gHRAq0IzhrkW2C9QxfMEKQ6gEqmtVTFBrWOGpRihnicKKNhukK323OznfWQB
         pR8riRZ3uMIVbC84any6jBv0nU9gn7WauurEBKowcGZo5VM0YopASMJSlf3aUNRNwcWA
         kFE5cXxi19lNtS9X5uFBQz4cK+hicXmlIp36VlHxlvG2B/9+REmO62TiINQFPYL4isOU
         PhgbOQD4OwYzJyqEL3ykBqalSaSCPA6vpgNA/98VCupTm12+865kEVmGdsp8X8tOSEXo
         0fPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IKKrQ/vjXnebip5AhX0hhEKW/mA6sdOEgqmJWf+TxdQ=;
        b=Kzo87jATsYAjRgC5zmzn30KmBQM2ZRSGPvK+zZGKCFzzpLkWrDcHOnibUdv4gZbWmd
         gz5mW9GYDQRHg+KxaQDf87UkG2aGKkxmGKMl1cLpheXyVhvQtle47gkuY8+lRYtSR/3Z
         +YcvGoDwqdFWbLh40zHLeUmFkl61q04xUZowhXKtb0AIjuNMM6sZbA9Z0gEyvEE9EE6P
         c7AifLWqAlkF+spJGUMqqdVhSce7buPJBmdnFfQoXzJwrtba5mmeIMjRi64qBIIv+qhL
         +rjNDDXfGrQDp16Nzf3GBAwCIuKiTSv1NBSkUyhr8ycTyxBQFHutbh/p//iHayvG5sDa
         pgpA==
X-Gm-Message-State: APjAAAUzEfhriyg0LUwNn+I/B2HoUHgXxoyedKPb/mhaOpas3hjo+nR0
        sePlufTiA3YBykCLJHntOJ6PPw==
X-Google-Smtp-Source: APXvYqx6DXo7mamf0R3ldMKFS9wLvdmZuIJWOpCCPMemvrwLBf0DOhoefAyz7pniugmrhPi4ZN2zZQ==
X-Received: by 2002:a63:d543:: with SMTP id v3mr53830011pgi.285.1577461559803;
        Fri, 27 Dec 2019 07:45:59 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id b8sm42063068pfr.64.2019.12.27.07.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Dec 2019 07:45:59 -0800 (PST)
Subject: Re: [PATCH 03/10] fs: add namei support for doing a non-blocking path
 lookup
From:   Jens Axboe <axboe@kernel.dk>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20191213183632.19441-1-axboe@kernel.dk>
 <20191213183632.19441-4-axboe@kernel.dk>
 <20191227004206.GT4203@ZenIV.linux.org.uk>
 <480c6bfb-a951-0f51-53ca-5ac63a38b1fc@kernel.dk>
 <a8d6bf32-bcdd-62e2-25b3-50351a3a5b14@kernel.dk>
Message-ID: <fad1cc3c-b805-38a7-4a25-94b2abf24528@kernel.dk>
Date:   Fri, 27 Dec 2019 08:45:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a8d6bf32-bcdd-62e2-25b3-50351a3a5b14@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/26/19 10:25 PM, Jens Axboe wrote:
> On 12/26/19 10:05 PM, Jens Axboe wrote:
>> On 12/26/19 5:42 PM, Al Viro wrote:
>>> On Fri, Dec 13, 2019 at 11:36:25AM -0700, Jens Axboe wrote:
>>>> If the fast lookup fails, then return -EAGAIN to have the caller retry
>>>> the path lookup. This is in preparation for supporting non-blocking
>>>> open.
>>>
>>> NAK.  We are not littering fs/namei.c with incremental broken bits
>>> and pieces with uncertain eventual use.
>>
>> To be fair, the "eventual use" is just the next patch or two...
>>
>>> And it's broken - lookup_slow() is *NOT* the only place that can and
>>> does block.  For starters, ->d_revalidate() can very well block and
>>> it is called outside of lookup_slow().  So does ->d_automount().
>>> So does ->d_manage().
>>
>> Fair enough, so it's not complete. I'd love to get it there, though!
>>
>>> I'm rather sceptical about the usefulness of non-blocking open, to be
>>> honest, but in any case, one thing that is absolutely not going to
>>> happen is piecewise introduction of such stuff without a discussion
>>> of the entire design.
>>
>> It's a necessity for io_uring, otherwise _any_ open needs to happen
>> out-of-line. But I get your objection, I'd like to get this moving in a
>> productive way though.
>>
>> What do you want it to look like? I'd be totally fine with knowing if
>> the fs has ->d_revalidate(), and always doing those out-of-line.  If I
>> know the open will be slow, that's preferable. Ditto for ->d_automount()
>> and ->d_manage(), all of that looks like cases that would be fine to
>> punt. I honestly care mostly about the cached local case _not_ needing
>> out-of-line handling, that needs to happen inline.
>>
>> Still seems to me like the LOOKUP_NONBLOCK is the way to go, and just
>> have lookup_fast() -EAGAIN if we need to call any of the potentially
>> problematic dentry ops. Yes, they _may_ not block, but they could. I
>> don't think we need to propagate this information further.
> 
> Incremental here - just check for potentially problematic dentry ops,
> and have the open redone from a path where it doesn't matter.

Here's the (updated) full patch, with the bits cleaned up a bit. Would
this be more agreeable to you?


commit ac605d1d6ca445ba7e2990e0afe0e28ad831a663
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Dec 13 11:09:26 2019 -0700

    fs: add namei support for doing a non-blocking path lookup
    
    If the fast lookup fails, then return -EAGAIN to have the caller retry
    the path lookup. Assume that a dentry having any of:
    
    ->d_revalidate()
    ->d_automount()
    ->d_manage()
    
    could block in those callbacks. Preemptively return -EAGAIN if any of
    these are present.
    
    This is in preparation for supporting non-blocking open.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/namei.c b/fs/namei.c
index d6c91d1e88cb..2bfdb932f2f2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1549,6 +1549,17 @@ static struct dentry *__lookup_hash(const struct qstr *name,
 	return dentry;
 }
 
+static inline bool lookup_could_block(struct dentry *dentry, unsigned int flags)
+{
+	const struct dentry_operations *ops = dentry->d_op;
+
+	if (!(flags & LOOKUP_NONBLOCK))
+		return 0;
+
+	/* assume these dentry ops may block */
+	return ops->d_revalidate || ops->d_automount || ops->d_manage;
+}
+
 static int lookup_fast(struct nameidata *nd,
 		       struct path *path, struct inode **inode,
 		       unsigned *seqp)
@@ -1573,6 +1584,9 @@ static int lookup_fast(struct nameidata *nd,
 			return 0;
 		}
 
+		if (unlikely(lookup_could_block(dentry, nd->flags)))
+			return -EAGAIN;
+
 		/*
 		 * This sequence count validates that the inode matches
 		 * the dentry name information from lookup.
@@ -1615,7 +1629,10 @@ static int lookup_fast(struct nameidata *nd,
 		dentry = __d_lookup(parent, &nd->last);
 		if (unlikely(!dentry))
 			return 0;
-		status = d_revalidate(dentry, nd->flags);
+		if (unlikely(lookup_could_block(dentry, nd->flags)))
+			status = -EAGAIN;
+		else
+			status = d_revalidate(dentry, nd->flags);
 	}
 	if (unlikely(status <= 0)) {
 		if (!status)
@@ -1799,6 +1816,8 @@ static int walk_component(struct nameidata *nd, int flags)
 	if (unlikely(err <= 0)) {
 		if (err < 0)
 			return err;
+		if (nd->flags & LOOKUP_NONBLOCK)
+			return -EAGAIN;
 		path.dentry = lookup_slow(&nd->last, nd->path.dentry,
 					  nd->flags);
 		if (IS_ERR(path.dentry))
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 7fe7b87a3ded..935a1bf0caca 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -38,6 +38,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_JUMPED		0x1000
 #define LOOKUP_ROOT		0x2000
 #define LOOKUP_ROOT_GRABBED	0x0008
+#define LOOKUP_NONBLOCK		0x10000	/* don't block for lookup */
 
 extern int path_pts(struct path *path);

-- 
Jens Axboe

