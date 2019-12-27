Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D62112B150
	for <lists+io-uring@lfdr.de>; Fri, 27 Dec 2019 06:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbfL0FZe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Dec 2019 00:25:34 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44571 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfL0FZe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Dec 2019 00:25:34 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so13901486pgl.11
        for <io-uring@vger.kernel.org>; Thu, 26 Dec 2019 21:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UtErnjaCkoWQcoPj04o6myunOpDU6sxW+omRnWRw1yg=;
        b=Qix6A3v/QkhCf+RHmBSvXkTPOy98W0I48loslHTf6xZeL/mLmybAvHxGlxdBl5tFZM
         bGMuFeWRUed4dsgbzbp9wyedFNzoM9ujwqiLxJhdfLQHFKCFyT343zr6dyqGXi2A2UVV
         Wsv3Ur/C9nNbyYd0yaQ0dhbKa/j77i7/MFn+DVz3kfsCqsLYH8ZoslaxMrJPMzBWNyr2
         rzn3SqNMtd8zfBXBDc8nfIoCTgHuY+KwrC/3Q4oa6Pubb4NVfyZdr2btVeRtoLFW6Qd4
         g1UmEoOj8/metxxcLq9U6Vxml8h1FxKk+kQ4Po380cJ/2CyQca4mlPGw1O5lVjzQiFii
         vSdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UtErnjaCkoWQcoPj04o6myunOpDU6sxW+omRnWRw1yg=;
        b=HtV7XtIBqFZTW/mKXjj+NJpotIyDqy33//84PcFTAfFctafSRIPZoZop9lKpisBWQJ
         2t7t7yRM1FO9WUYzJryUcmPLm+gTj19Ut6E5UTAYdKzbe2QkVbZBa0/BSUmdGUQKOGoF
         gx8fARDSMc+gy9giPyz/+10Daz69MugZDYKpx0OuocIxW6bmAcX8CTCumr2CKJt17Ye9
         TL82bjIkSEIlPhJejjlHkNCCCJDnv8eI0LmTqsIvla6xJGiLULjul1hpIEdyldo/2G3T
         FLtaGW4OL0RMZ7Nf9R7G5iQXQPbWO4ZqhGgePFz2NOSV/6ksf4HsTAnjqRhGz0pANjUD
         HG4w==
X-Gm-Message-State: APjAAAXxvRs6SXvm3Fv6zGwtPMzyXvCEzi4sL87yXdf7BTU/LU2S3Pla
        83HX07s80IrJxwwWbxMURhB0XA==
X-Google-Smtp-Source: APXvYqyLDDMdnuqG70VLUZvAutBFQNyRFOC0TWh2zE8SPaQ7u4DYNvAJT+8a0UezLuh4dpiqt0q3Xg==
X-Received: by 2002:a63:6e0e:: with SMTP id j14mr51645176pgc.361.1577424332940;
        Thu, 26 Dec 2019 21:25:32 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id k1sm12362314pjl.21.2019.12.26.21.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 21:25:32 -0800 (PST)
Subject: Re: [PATCH 03/10] fs: add namei support for doing a non-blocking path
 lookup
From:   Jens Axboe <axboe@kernel.dk>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20191213183632.19441-1-axboe@kernel.dk>
 <20191213183632.19441-4-axboe@kernel.dk>
 <20191227004206.GT4203@ZenIV.linux.org.uk>
 <480c6bfb-a951-0f51-53ca-5ac63a38b1fc@kernel.dk>
Message-ID: <a8d6bf32-bcdd-62e2-25b3-50351a3a5b14@kernel.dk>
Date:   Thu, 26 Dec 2019 22:25:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <480c6bfb-a951-0f51-53ca-5ac63a38b1fc@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/26/19 10:05 PM, Jens Axboe wrote:
> On 12/26/19 5:42 PM, Al Viro wrote:
>> On Fri, Dec 13, 2019 at 11:36:25AM -0700, Jens Axboe wrote:
>>> If the fast lookup fails, then return -EAGAIN to have the caller retry
>>> the path lookup. This is in preparation for supporting non-blocking
>>> open.
>>
>> NAK.  We are not littering fs/namei.c with incremental broken bits
>> and pieces with uncertain eventual use.
> 
> To be fair, the "eventual use" is just the next patch or two...
> 
>> And it's broken - lookup_slow() is *NOT* the only place that can and
>> does block.  For starters, ->d_revalidate() can very well block and
>> it is called outside of lookup_slow().  So does ->d_automount().
>> So does ->d_manage().
> 
> Fair enough, so it's not complete. I'd love to get it there, though!
> 
>> I'm rather sceptical about the usefulness of non-blocking open, to be
>> honest, but in any case, one thing that is absolutely not going to
>> happen is piecewise introduction of such stuff without a discussion
>> of the entire design.
> 
> It's a necessity for io_uring, otherwise _any_ open needs to happen
> out-of-line. But I get your objection, I'd like to get this moving in a
> productive way though.
> 
> What do you want it to look like? I'd be totally fine with knowing if
> the fs has ->d_revalidate(), and always doing those out-of-line.  If I
> know the open will be slow, that's preferable. Ditto for ->d_automount()
> and ->d_manage(), all of that looks like cases that would be fine to
> punt. I honestly care mostly about the cached local case _not_ needing
> out-of-line handling, that needs to happen inline.
> 
> Still seems to me like the LOOKUP_NONBLOCK is the way to go, and just
> have lookup_fast() -EAGAIN if we need to call any of the potentially
> problematic dentry ops. Yes, they _may_ not block, but they could. I
> don't think we need to propagate this information further.

Incremental here - just check for potentially problematic dentry ops,
and have the open redone from a path where it doesn't matter.


diff --git a/fs/namei.c b/fs/namei.c
index ebd05ed14b0a..9c46b1e04fac 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1549,6 +1549,14 @@ static struct dentry *__lookup_hash(const struct qstr *name,
 	return dentry;
 }
 
+static inline bool lookup_may_block(struct dentry *dentry)
+{
+	const struct dentry_operations *ops = dentry->d_op;
+
+	/* assume these dentry ops may block */
+	return ops->d_revalidate || ops->d_automount || ops->d_manage;
+}
+
 static int lookup_fast(struct nameidata *nd,
 		       struct path *path, struct inode **inode,
 		       unsigned *seqp)
@@ -1573,6 +1581,9 @@ static int lookup_fast(struct nameidata *nd,
 			return 0;
 		}
 
+		if ((nd->flags & LOOKUP_NONBLOCK) && lookup_may_block(dentry))
+			return -EAGAIN;
+
 		/*
 		 * This sequence count validates that the inode matches
 		 * the dentry name information from lookup.
@@ -1615,7 +1626,10 @@ static int lookup_fast(struct nameidata *nd,
 		dentry = __d_lookup(parent, &nd->last);
 		if (unlikely(!dentry))
 			return 0;
-		status = d_revalidate(dentry, nd->flags);
+		if ((nd->flags & LOOKUP_NONBLOCK) && lookup_may_block(dentry))
+			status = -EAGAIN;
+		else
+			status = d_revalidate(dentry, nd->flags);
 	}
 	if (unlikely(status <= 0)) {
 		if (!status)

-- 
Jens Axboe

