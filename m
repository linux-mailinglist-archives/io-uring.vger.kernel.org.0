Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9ABC2D63A0
	for <lists+io-uring@lfdr.de>; Thu, 10 Dec 2020 18:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392743AbgLJRc6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Dec 2020 12:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392727AbgLJRcx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Dec 2020 12:32:53 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FF3C061793
        for <io-uring@vger.kernel.org>; Thu, 10 Dec 2020 09:32:12 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id t8so6354155iov.8
        for <io-uring@vger.kernel.org>; Thu, 10 Dec 2020 09:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=25q6zpipedQCVIYwyHkHiyB2heybX2dq15I5qG0YlVU=;
        b=HTOqOxtZZ/tfgWCCGjsa+q0Ok+1fCKGLfjH/9H1uyvhIXJ3/4WTqbFR1ShfwhwFxZM
         fAW1cAfVCA2/FtvGvGFl1m4PbmZXPsZOXLKxnd2ClD6frDTAZo6wjQNIm4BtDC1eLCqS
         mEWWjERdMDhLzW6L0t0ZuphjO0T2mh2Yb2+4v9lMy5w6MV9HjyPM/dkQ4Uki1vDFDvcu
         myOwk1EzCOmwj8gCC3H4H3wSNknc+sjFUVYL/CxbErbXun3qaTdPQJ2uVBRXl8//7kZv
         JsUgMpx2xQXyv43ZFKIbfLiV4HiTwfUza4fDHRlxcfh7aNL6aEnC9lvftRV6jP1mGiUr
         NpCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=25q6zpipedQCVIYwyHkHiyB2heybX2dq15I5qG0YlVU=;
        b=Fxi+3iufjPWPn+ESaoOdoXQ33OIQQwxsNA/rgzcvwOW3yUKWLPlKeHRAi6P+P+EKGF
         Pxbc7Z8acWjJfMy7kUbUBr05UNbSGox3/EMt2aGg1EjRMIPsqbXAzbKEzJedY3IH3zR1
         pUEI6m5qcQ3ipU3kqwf+CAg99rBlNc/6pv55WSDKFYoo/CqFCQEjbNyzPfUsuE3ND7uh
         gKeH6kKbx+Gsj7zwWutRHoj/L+bD+LbPbnkFqaZV+XA6I+xFgdOq6wJmB+/wPPsSQwuX
         EZnSTKkmjoYhfYx4vAVJWDq6nafuo/Chmsv4nNBUuZumm3WV7I5l+PkxBvRzqxOmEPWt
         Ki/w==
X-Gm-Message-State: AOAM5301VLpDSkdKEmZ2rmUbFwJ4f3g0xZB24iG3xgtNwDYl1ISImayA
        aFmMWi1pFIw37v9jMdbr3ZzY6ZJo9CrIlA==
X-Google-Smtp-Source: ABdhPJxEyLEleHR+eaE3z5uxVwNKUGCka8AWtL/B6y2Hkfjc7NiIr6EzhJjl4e5a6ZqB7RzXd3FKvA==
X-Received: by 2002:a05:6638:f89:: with SMTP id h9mr9881310jal.89.1607621531866;
        Thu, 10 Dec 2020 09:32:11 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t2sm3694477ili.31.2020.12.10.09.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 09:32:11 -0800 (PST)
Subject: namei.c LOOKUP_NONBLOCK (was "Re: [GIT PULL] io_uring fixes for
 5.10-rc")
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <6535286b-2532-dc86-3c6e-1b1e9bce358f@kernel.dk>
 <CAHk-=wjrayP=rOB+v+2eTP8micykkM76t=6vp-hyy+vWYkL8=A@mail.gmail.com>
 <4bcf3012-a4ad-ac2d-e70b-17f17441eea9@kernel.dk>
 <CAHk-=wimYoUtY4ygMNknkKZHqgYBZbkU4Koo5cE6ar8XjHkzGg@mail.gmail.com>
 <ad8db5d0-2fac-90b6-b9e4-746a52b8ac57@kernel.dk>
 <d7095e1d-0363-0aad-5c13-6d9bb189b2c8@kernel.dk>
 <CAHk-=wgyRpBW_NOCKpJ1rZGD9jVOX80EWqKwwZxFeief2Khotg@mail.gmail.com>
 <87f88614-3045-89bb-8051-b545f5b1180a@kernel.dk>
Message-ID: <a522a422-92e3-6171-8a2e-76a5c7e21cfc@kernel.dk>
Date:   Thu, 10 Dec 2020 10:32:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87f88614-3045-89bb-8051-b545f5b1180a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/21/20 3:58 PM, Jens Axboe wrote:
> On 11/21/20 11:07 AM, Linus Torvalds wrote:
>> On Fri, Nov 20, 2020 at 7:00 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> Actually, I think we can do even better. How about just having
>>> do_filp_open() exit after LOOKUP_RCU fails, if LOOKUP_RCU was already
>>> set in the lookup flags? Then we don't need to change much else, and
>>> most of it falls out naturally.
>>
>> So I was thinking doing the RCU lookup unconditionally, and then doing
>> the nn-RCU lookup if that fails afterwards.
>>
>> But your patch looks good to me.
>>
>> Except for the issue you noticed.
> 
> After having taken a closer look, I think the saner approach is
> LOOKUP_NONBLOCK instead of using LOOKUP_RCU which is used more as
> a state than lookup flag. I'll try and hack something up that looks
> passable.
> 
>>> Except it seems that should work, except LOOKUP_RCU does not guarantee
>>> that we're not going to do IO:
>>
>> Well, almost nothing guarantees lack of IO, since allocations etc can
>> still block, but..
> 
> Sure, and we can't always avoid that - but blatant block on waiting
> for IO should be avoided.
> 
>>> [   20.463195]  schedule+0x5f/0xd0
>>> [   20.463444]  io_schedule+0x45/0x70
>>> [   20.463712]  bit_wait_io+0x11/0x50
>>> [   20.463981]  __wait_on_bit+0x2c/0x90
>>> [   20.464264]  out_of_line_wait_on_bit+0x86/0x90
>>> [   20.464611]  ? var_wake_function+0x30/0x30
>>> [   20.464932]  __ext4_find_entry+0x2b5/0x410
>>> [   20.465254]  ? d_alloc_parallel+0x241/0x4e0
>>> [   20.465581]  ext4_lookup+0x51/0x1b0
>>> [   20.465855]  ? __d_lookup+0x77/0x120
>>> [   20.466136]  path_openat+0x4e8/0xe40
>>> [   20.466417]  do_filp_open+0x79/0x100
>>
>> Hmm. Is this perhaps an O_CREAT case? I think we only do the dcache
>> lookups under RCU, not the final path component creation.
> 
> It's just a basic test that opens all files under a directory. So
> no O_CREAT, it's all existing files. I think this is just a case of not
> aborting early enough for LOOKUP_NONBLOCK, and we've obviously already
> dropped LOOKUP_RCU (and done rcu_read_unlock() again) at this point.
> 
>> And there are probably lots of other situations where we finish with
>> LOOKUP_RCU (with unlazy_walk()), and then continue.> 
>> Example: look at "may_lookup()" - if inode_permission() says "I can't
>> do this without blocking" the logic actually just tries to validate
>> the current state (that "unlazy_walk()" thing), and then continue
>> without RCU.
>>
>> It obviously hasn't been about lockless semantics, it's been about
>> really being lockless. So LOOKUP_RCU has been a "try to do this
>> locklessly" rather than "you cannot take any locks".
>>
>> I guess we would have to add a LOOKUP_NOBLOCK thing to actually then
>> say "if the RCU lookup fails, return -EAGAIN".
>>
>> That's probably not a huge undertaking, but yeah, I didn't think of
>> it. I think this is a "we need to have Al tell us if it's reasonable".
> 
> Definitely. I did have a weak attempt at LOOKUP_NONBLOCK earlier, I'll
> try and resurrect it and see what that leads to. Outside of just pure
> lookup, the d_revalidate() was a bit interesting as it may block for
> certain cases, but those should be (hopefully) detectable upfront.

Here's a potentially better attempt - basically we allow LOOKUP_NONBLOCK
with LOOKUP_RCU, and if we end up dropping LOOKUP_RCU, then we generally
return -EAGAIN if LOOKUP_NONBLOCK is set as we can no longer guarantee
that we won't block.

Al, what do you think? I didn't include the io_uring part here, as
that's just dropping the existing hack and setting LOOKUP_NONBLOCK if
we're in task context. I can send it out as a separate patch, of course.

diff --git a/fs/namei.c b/fs/namei.c
index 03d0e11e4f36..303874f1b9f1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -679,7 +679,7 @@ static bool legitimize_root(struct nameidata *nd)
  * Nothing should touch nameidata between unlazy_walk() failure and
  * terminate_walk().
  */
-static int unlazy_walk(struct nameidata *nd)
+static int __unlazy_walk(struct nameidata *nd)
 {
 	struct dentry *parent = nd->path.dentry;
 
@@ -704,6 +704,18 @@ static int unlazy_walk(struct nameidata *nd)
 	return -ECHILD;
 }
 
+static int unlazy_walk(struct nameidata *nd)
+{
+	int ret;
+
+	ret = __unlazy_walk(nd);
+	/* If caller is asking for NONBLOCK lookup, assume we can't satisfy it */
+	if (!ret && (nd->flags & LOOKUP_NONBLOCK))
+		ret = -EAGAIN;
+
+	return ret;
+}
+
 /**
  * unlazy_child - try to switch to ref-walk mode.
  * @nd: nameidata pathwalk data
@@ -764,10 +776,13 @@ static int unlazy_child(struct nameidata *nd, struct dentry *dentry, unsigned se
 
 static inline int d_revalidate(struct dentry *dentry, unsigned int flags)
 {
-	if (unlikely(dentry->d_flags & DCACHE_OP_REVALIDATE))
+	if (unlikely(dentry->d_flags & DCACHE_OP_REVALIDATE)) {
+		if ((flags & (LOOKUP_RCU | LOOKUP_NONBLOCK)) == LOOKUP_NONBLOCK)
+			return -EAGAIN;
 		return dentry->d_op->d_revalidate(dentry, flags);
-	else
-		return 1;
+	}
+
+	return 1;
 }
 
 /**
@@ -792,7 +807,7 @@ static int complete_walk(struct nameidata *nd)
 		 */
 		if (!(nd->flags & (LOOKUP_ROOT | LOOKUP_IS_SCOPED)))
 			nd->root.mnt = NULL;
-		if (unlikely(unlazy_walk(nd)))
+		if (unlikely(__unlazy_walk(nd)))
 			return -ECHILD;
 	}
 
@@ -1466,8 +1481,9 @@ static struct dentry *lookup_fast(struct nameidata *nd,
 		unsigned seq;
 		dentry = __d_lookup_rcu(parent, &nd->last, &seq);
 		if (unlikely(!dentry)) {
-			if (unlazy_walk(nd))
-				return ERR_PTR(-ECHILD);
+			int ret = unlazy_walk(nd);
+			if (ret)
+				return ERR_PTR(ret);
 			return NULL;
 		}
 
@@ -1569,8 +1585,9 @@ static inline int may_lookup(struct nameidata *nd)
 		int err = inode_permission(nd->inode, MAY_EXEC|MAY_NOT_BLOCK);
 		if (err != -ECHILD)
 			return err;
-		if (unlazy_walk(nd))
-			return -ECHILD;
+		err = unlazy_walk(nd);
+		if (err)
+			return err;
 	}
 	return inode_permission(nd->inode, MAY_EXEC);
 }
@@ -1591,9 +1608,11 @@ static int reserve_stack(struct nameidata *nd, struct path *link, unsigned seq)
 		// we need to grab link before we do unlazy.  And we can't skip
 		// unlazy even if we fail to grab the link - cleanup needs it
 		bool grabbed_link = legitimize_path(nd, link, seq);
+		int ret;
 
-		if (unlazy_walk(nd) != 0 || !grabbed_link)
-			return -ECHILD;
+		ret = unlazy_walk(nd);
+		if (ret && !grabbed_link)
+			return ret;
 
 		if (nd_alloc_stack(nd))
 			return 0;
@@ -1634,8 +1653,9 @@ static const char *pick_link(struct nameidata *nd, struct path *link,
 		touch_atime(&last->link);
 		cond_resched();
 	} else if (atime_needs_update(&last->link, inode)) {
-		if (unlikely(unlazy_walk(nd)))
-			return ERR_PTR(-ECHILD);
+		error = unlazy_walk(nd);
+		if (unlikely(error))
+			return ERR_PTR(error);
 		touch_atime(&last->link);
 	}
 
@@ -1652,8 +1672,9 @@ static const char *pick_link(struct nameidata *nd, struct path *link,
 		if (nd->flags & LOOKUP_RCU) {
 			res = get(NULL, inode, &last->done);
 			if (res == ERR_PTR(-ECHILD)) {
-				if (unlikely(unlazy_walk(nd)))
-					return ERR_PTR(-ECHILD);
+				error = unlazy_walk(nd);
+				if (unlikely(error))
+					return ERR_PTR(error);
 				res = get(link->dentry, inode, &last->done);
 			}
 		} else {
@@ -2193,8 +2214,9 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		}
 		if (unlikely(!d_can_lookup(nd->path.dentry))) {
 			if (nd->flags & LOOKUP_RCU) {
-				if (unlazy_walk(nd))
-					return -ECHILD;
+				err = unlazy_walk(nd);
+				if (err)
+					return err;
 			}
 			return -ENOTDIR;
 		}
@@ -3394,10 +3416,14 @@ struct file *do_filp_open(int dfd, struct filename *pathname,
 
 	set_nameidata(&nd, dfd, pathname);
 	filp = path_openat(&nd, op, flags | LOOKUP_RCU);
+	/* If we fail RCU lookup, assume NONBLOCK cannot be honored */
+	if (flags & LOOKUP_NONBLOCK)
+		goto out;
 	if (unlikely(filp == ERR_PTR(-ECHILD)))
 		filp = path_openat(&nd, op, flags);
 	if (unlikely(filp == ERR_PTR(-ESTALE)))
 		filp = path_openat(&nd, op, flags | LOOKUP_REVAL);
+out:
 	restore_nameidata();
 	return filp;
 }
diff --git a/include/linux/namei.h b/include/linux/namei.h
index a4bb992623c4..c36c4e0805fc 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -46,6 +46,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
 #define LOOKUP_NO_XDEV		0x040000 /* No mountpoint crossing. */
 #define LOOKUP_BENEATH		0x080000 /* No escaping from starting point. */
 #define LOOKUP_IN_ROOT		0x100000 /* Treat dirfd as fs root. */
+#define LOOKUP_NONBLOCK		0x200000 /* don't block for lookup */
 /* LOOKUP_* flags which do scope-related checks based on the dirfd. */
 #define LOOKUP_IS_SCOPED (LOOKUP_BENEATH | LOOKUP_IN_ROOT)
 

-- 
Jens Axboe

