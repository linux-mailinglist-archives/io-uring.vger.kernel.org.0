Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F4A12BE97
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfL1TDu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:03:50 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53124 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfL1TDu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:03:50 -0500
Received: by mail-pj1-f67.google.com with SMTP id a6so6153340pjh.2
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YnTE28nFPK/b6DrhenDuQTIFSd5TBc5YE3RljWoSLL0=;
        b=TqQuPuf9Mrwnh2n++O5TopI0C2Tt+bXQQt5UcCrfQjGcr6y7Itnqh2JIXoa8QbRRuJ
         nw3it9MKGC7TKIPg6A0gHUUKERuIWrvVcJq0rXvtcqVMjROR9zDcr0DAs3x0zbocRLkl
         fCRNA1siHT3cMYIY+Nah2c/hH905UTCA7Me03xgM9Fsg7r7on+nfRAZRq/ZxPreOkuNr
         lhHV6fGSdxk0T6OVUpcuoOyI3tfK/TWqE5/JRsKU1gwM55WpIe2H+JTcpwPC9JFk+cAz
         3z2lTUa3JFAUG0XLU8RpSRxmucPjrVueuHt8w6pVRq7RjwK1kqwLqnagaxwOtWfQTMw1
         KSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YnTE28nFPK/b6DrhenDuQTIFSd5TBc5YE3RljWoSLL0=;
        b=H+15yozYMPe0qpGfcyfDpoNVSwDTpZwZQ0B0SxQWDrbJ9JUyMg/A62EPaFAIn7reNz
         66XNshBZ06N2wWhWSkQ/h/4hS4yoKC7euGDd4Pk86Sh5HusNgt4KQcIUQ1XuDfUMnzno
         fDnm1ZUTvecZi1PkxVGHYeLzITMSxa4cJf84SO0/VXExS1aYXbM5byEssxoUV/Zv3sSG
         BjyAgB+Nkyujz17wvE6/skRyhd1yuLTe0ABnQouhvZpQQbkj1yadp+THG//6NlvBbl8k
         n0yTTr587dC10AZaLAd9AvepLDUgNIkTWZk/Yo53OKTo5HR0R/RYQaazzp91gGQHceBU
         OKMA==
X-Gm-Message-State: APjAAAWVlBje0txcvJWa9L2hiUsUpaWvPUM7znwtuyuX2syXnb7pBg3B
        aKPBgoouR0nazzhcQGlCY2Hc4mBIe/xuMg==
X-Google-Smtp-Source: APXvYqw2LsxaMmiSQyp+A+1NoNd8vSSHMg/24rGCCGAqOm4N0z7hb+ceBab8OZeM1kFbLSHYrTJWtw==
X-Received: by 2002:a17:902:d217:: with SMTP id t23mr46169752ply.197.1577559829039;
        Sat, 28 Dec 2019 11:03:49 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id c17sm39410105pfi.104.2019.12.28.11.03.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2019 11:03:48 -0800 (PST)
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
 <fad1cc3c-b805-38a7-4a25-94b2abf24528@kernel.dk>
Message-ID: <aebe6e0c-19b0-2945-2dee-ae06ee404310@kernel.dk>
Date:   Sat, 28 Dec 2019 12:03:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <fad1cc3c-b805-38a7-4a25-94b2abf24528@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/27/19 8:45 AM, Jens Axboe wrote:
> On 12/26/19 10:25 PM, Jens Axboe wrote:
>> On 12/26/19 10:05 PM, Jens Axboe wrote:
>>> On 12/26/19 5:42 PM, Al Viro wrote:
>>>> On Fri, Dec 13, 2019 at 11:36:25AM -0700, Jens Axboe wrote:
>>>>> If the fast lookup fails, then return -EAGAIN to have the caller retry
>>>>> the path lookup. This is in preparation for supporting non-blocking
>>>>> open.
>>>>
>>>> NAK.  We are not littering fs/namei.c with incremental broken bits
>>>> and pieces with uncertain eventual use.
>>>
>>> To be fair, the "eventual use" is just the next patch or two...
>>>
>>>> And it's broken - lookup_slow() is *NOT* the only place that can and
>>>> does block.  For starters, ->d_revalidate() can very well block and
>>>> it is called outside of lookup_slow().  So does ->d_automount().
>>>> So does ->d_manage().
>>>
>>> Fair enough, so it's not complete. I'd love to get it there, though!
>>>
>>>> I'm rather sceptical about the usefulness of non-blocking open, to be
>>>> honest, but in any case, one thing that is absolutely not going to
>>>> happen is piecewise introduction of such stuff without a discussion
>>>> of the entire design.
>>>
>>> It's a necessity for io_uring, otherwise _any_ open needs to happen
>>> out-of-line. But I get your objection, I'd like to get this moving in a
>>> productive way though.
>>>
>>> What do you want it to look like? I'd be totally fine with knowing if
>>> the fs has ->d_revalidate(), and always doing those out-of-line.  If I
>>> know the open will be slow, that's preferable. Ditto for ->d_automount()
>>> and ->d_manage(), all of that looks like cases that would be fine to
>>> punt. I honestly care mostly about the cached local case _not_ needing
>>> out-of-line handling, that needs to happen inline.
>>>
>>> Still seems to me like the LOOKUP_NONBLOCK is the way to go, and just
>>> have lookup_fast() -EAGAIN if we need to call any of the potentially
>>> problematic dentry ops. Yes, they _may_ not block, but they could. I
>>> don't think we need to propagate this information further.
>>
>> Incremental here - just check for potentially problematic dentry ops,
>> and have the open redone from a path where it doesn't matter.
> 
> Here's the (updated) full patch, with the bits cleaned up a bit. Would
> this be more agreeable to you?

Needs a !ops check as well, tmpfs hits that:


commit 8a4dbfbbcd675492cf9e8cbcb203386a1ce10916
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
index d6c91d1e88cb..42e71e5a69f1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1549,6 +1549,17 @@ static struct dentry *__lookup_hash(const struct qstr *name,
 	return dentry;
 }
 
+static inline bool lookup_could_block(struct dentry *dentry, unsigned int flags)
+{
+	const struct dentry_operations *ops = dentry->d_op;
+
+	if (!ops || !(flags & LOOKUP_NONBLOCK))
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

