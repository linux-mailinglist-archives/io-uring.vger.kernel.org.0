Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD6A546706
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 15:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245029AbiFJNE3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 09:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244252AbiFJNE2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 09:04:28 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5302CDC6
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 06:04:26 -0700 (PDT)
Message-ID: <cd9f17eb-263f-0b42-418b-83df97795966@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654866264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VmLpr6ZL2vt1PEvYNHkI0HhvMBZXYVA2BeXaFYx2MwU=;
        b=DDnkHMDlxmFciSmo8lskI3KZH1Oa/dGS8T2rJitlL0LtwjSSuruSMvPo5vOlmZjgpi0PuL
        IWcrmbUCTAfe0C8/WwPXvuhwX53aouZhPenI9L4n3WZsAgszGdz9TXhPoD8AEJWxd1PHnw
        w0y5a8xxxlJK1Dnht+7CdCiWxxJWGoo=
Date:   Fri, 10 Jun 2022 21:04:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCHSET v2 0/6] Allow allocated direct descriptors
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        =?UTF-8?Q?Ralph_B=c3=b6hme?= <slow@samba.org>, vl <vl@samba.org>
References: <20220509155055.72735-1-axboe@kernel.dk>
 <c57c4231-f481-8fdf-5b97-625ada83f83a@samba.org>
 <bdd8d2b8-6ac0-5a38-6905-0b2a874c035d@linux.dev>
 <68c7a7cb-63b3-3207-4ba3-e870cc5b6fd9@samba.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <68c7a7cb-63b3-3207-4ba3-e870cc5b6fd9@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/10/22 19:28, Stefan Metzmacher wrote:
> 
> Am 10.06.22 um 13:06 schrieb Hao Xu:
>> Hi Stefan,
>> On 6/9/22 16:57, Stefan Metzmacher wrote:
>>>
>>> Hi Jens,
>>>
>>> this looks very useful, thanks!
>>>
>>> I have an additional feature request to make this even more useful...
>>>
>>> IO_OP_ACCEPT allows a fixed descriptor for the listen socket
>>> and then can generate a fixed descriptor for the accepted connection,
>>> correct?
>>
>> Yes.
>>
>>>
>>> It would be extremely useful to also allow that pattern
>>> for IO_OP_OPENAT[2], which currently is not able to get
>>> a fixed descriptor for the dirfd argument (this also applies to
>>> IO_OP_STATX, IO_OP_UNLINK and all others taking a dirfd).
>>>
>>> Being able use such a sequence:
>>>
>>> OPENTAT2(AT_FDCWD, "directory") => 1 (fixed)
>>> STATX(1 (fixed))
>>> FGETXATTR(1 (fixed)
>>> OPENAT2(1 (fixed), "file") => 2 (fixed)
>>> STATX(2 (fixed))
>>> FGETXATTR(2 (fixed))
>>> CLOSE(1 (fixed)
>>> DUP( 2 (fixed)) => per-process fd for ("file")
>>>
>>> I looked briefly how to implement that.
>>> But set_nameidata() takes 'int dfd' to store the value
>>> and it's used later somewhere deep down the stack.
>>> And makes it too complex for me to create patches :-(
>>>
>>
>> Indeed.. dirfd is used in path_init() etc. For me, no idea how to tackle
>> it for now.We surely can register a fixed descriptor to the process
>> fdtable but that is against the purpose of fixed file..
> 
> I looked at it a bit more and the good thing is that
> 'struct nameidata' is private to namei.c, which simplifies
> getting an overview.
> 
> path_init() is the actual only user of nd.dfd

                               ^[1]

> and it's used to fill nd.path, either from get_fs_pwd()
> for AT_FDCWD and f.file->f_path otherwise.
> 
> So might be able to have a function that translated
> the fd to struct path early and let the callers pass 'struct path'
> instead of 'int dfd'...

Yea, if [1] is true. I wrote something for your reference:
(totally unpolished and untested, just to show an idea)

diff --git a/fs/namei.c b/fs/namei.c
index 1f28d3f463c3..18e11717005c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2423,21 +2423,30 @@ static const char *path_init(struct nameidata 
*nd, unsigned flags)
                         nd->inode = nd->path.dentry->d_inode;
                 }
         } else {
-               /* Caller must check execute permissions on the starting 
path component */
-               struct fd f = fdget_raw(nd->dfd);
                 struct dentry *dentry;

-               if (!f.file)
-                       return ERR_PTR(-EBADF);
+               if (nd->dfd != -1) {
+                       /* Caller must check execute permissions on the 
starting path component */
+                       struct fd f = fdget_raw(nd->dfd);

-               dentry = f.file->f_path.dentry;
+                       if (!f.file)
+                               return ERR_PTR(-EBADF);

-               if (*s && unlikely(!d_can_lookup(dentry))) {
-                       fdput(f);
-                       return ERR_PTR(-ENOTDIR);
+                       dentry = f.file->f_path.dentry;
+
+                       if (*s && unlikely(!d_can_lookup(dentry))) {
+                               fdput(f);
+                               return ERR_PTR(-ENOTDIR);
+                       }
+
+                       nd->path = f.file->f_path;
+               } else {
+                       dentry = nd->path.dentry;
+
+                       if (*s && unlikely(!d_can_lookup(dentry)))
+                               return ERR_PTR(-ENOTDIR);
                 }

-               nd->path = f.file->f_path;
                 if (flags & LOOKUP_RCU) {
                         nd->inode = nd->path.dentry->d_inode;
                         nd->seq = 
read_seqcount_begin(&nd->path.dentry->d_seq);
@@ -2445,7 +2454,9 @@ static const char *path_init(struct nameidata *nd, 
unsigned flags)
                         path_get(&nd->path);
                         nd->inode = nd->path.dentry->d_inode;
                 }
-               fdput(f);
+               if (dfd != -1)
+                       fdput(f);
+
         }

         /* For scoped-lookups we need to set the root to the dirfd as 
well. */
@@ -3686,6 +3697,48 @@ struct file *do_filp_open(int dfd, struct 
filename *pathname,
         return filp;
  }

+static void __set_nameidata2(struct nameidata *p, struct path *path,
+                            struct filename *name)
+{
+       struct nameidata *old = current->nameidata;
+       p->stack = p->internal;
+       p->depth = 0;
+       p->dfd = -1;
+       p->name = name;
+       p->path = *path;
+       p->total_link_count = old ? old->total_link_count : 0;
+       p->saved = old;
+       current->nameidata = p;
+}
+
+static inline void set_nameidata2(struct nameidata *p, struct path *path,
+                                 struct filename *name, const struct 
path *root)
+{
+       __set_nameidata2(p, path, name);
+       p->state = 0;
+       if (unlikely(root)) {
+               p->state = ND_ROOT_PRESET;
+               p->root = *root;
+       }
+}
+
+struct file *do_filp_open_path(struct *path, struct filename *pathname,
+               const struct open_flags *op)
+{
+       struct nameidata nd;
+       int flags = op->lookup_flags;
+       struct file *filp;
+
+       set_nameidata2(&nd, path, pathname, NULL);
+       filp = path_openat(&nd, op, flags | LOOKUP_RCU);
+       if (unlikely(filp == ERR_PTR(-ECHILD)))
+               filp = path_openat(&nd, op, flags);
+       if (unlikely(filp == ERR_PTR(-ESTALE)))
+               filp = path_openat(&nd, op, flags | LOOKUP_REVAL);
+       restore_nameidata();
+       return filp;
+}
+
  struct file *do_file_open_root(const struct path *root,
                 const char *name, const struct open_flags *op)
  {


