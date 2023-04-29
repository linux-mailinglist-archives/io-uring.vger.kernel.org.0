Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2B06F23AC
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 10:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjD2IIE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 04:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjD2IID (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 04:08:03 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A749D;
        Sat, 29 Apr 2023 01:08:00 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id A622AC020; Sat, 29 Apr 2023 10:07:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682755675; bh=DmRpe2Il38TnK4sApoIi7xcpmjSwMJq7MXIke/ZT6ac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OwfifKgW3lPCsCcBzi0Cfnz7NR9y7XYtFvHbIjiIA4D1w71mtKg9/JCYL33SJ1xKT
         Ig3Xx37tqDsF55AgzYgjg9eLrhwrgr5Qba7Fv7q9P7gcWeSQRh0D3jIxD6Cp4KJgwX
         lyLixZvm3FMOSAgr52mNXP5aSGsYpWc6OCiKzRvPXKLfwuYGoPzH5xZMlUATH2uap0
         CRDperPfVMvDYIoPA1elcZ7UYsHNsYWNHwtkP68MkIth0Hdk9QAEyspiwlYjbSHdwk
         9seuSStKy9JhMmGB+/SVufJHg2GEOC1EOE0P6I2/E40vnnBowMxExVx3R6MEeFhpqr
         LTJoxyBT1swCg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id A69E9C009;
        Sat, 29 Apr 2023 10:07:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682755674; bh=DmRpe2Il38TnK4sApoIi7xcpmjSwMJq7MXIke/ZT6ac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W+JXrOsOwX0OeC3hoq8L1edpV2APOkX/DyA3O+/MUBofJe+Aj4ZODZfLhe1B+XKU8
         JHMauX23dBpfYZZ0iW8jH6Pwg//wLHN2kvGRszE0S4fvc2munmY7Ovw4gWR5dlMUbf
         JhBBvalGPqC7cbMRv19kvZIANNqqhbt6JjKXWGlPSJfgSk/lskf9iIje53Y+fm8hdX
         k00dPKpx50OnesXNC8dzOaa8krMloOJ936nrvRP5g9tW86pKh8Qm7BbAsdbd6xjA4f
         NK95odKTnRYiG0HByAxWivIYPD7TTa6F3zSKLino5cQQ2FweaX83x0HkuSv9+9OiXF
         ymOs3KKDg2HUg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id adcfa885;
        Sat, 29 Apr 2023 08:07:47 +0000 (UTC)
Date:   Sat, 29 Apr 2023 17:07:32 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <ZEzQRLUnlix1GvbA@codewreck.org>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
 <ZEXChAJfCRPv9vbs@codewreck.org>
 <20230428050640.GA1969623@dread.disaster.area>
 <ZEtkXJ1vMsFR3tkN@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZEtkXJ1vMsFR3tkN@codewreck.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dominique Martinet wrote on Fri, Apr 28, 2023 at 03:14:52PM +0900:
> > AFAICT, the io_uring code wouldn't need to do much more other than
> > punt to the work queue if it receives a -EAGAIN result. Otherwise
> > the what the filesystem returns doesn't need to change, and I don't
> > see that we need to change how the filldir callbacks work, either.
> > We just keep filling the user buffer until we either run out of
> > cached directory data or the user buffer is full.
> 
> [...] I'd like to confirm what the uring
> side needs to do before proceeding -- looking at the read/write path
> there seems to be a polling mechanism in place to tell uring when to
> look again, and I haven't looked at this part of the code yet to see
> what happens if no such polling is in place (does uring just retry
> periodically?)

Ok so this part can work out as you said, I hadn't understood what you
meant by "punt to the work queue" but that should work from my new
understanding of the ring; we can just return EAGAIN if the non-blocking
variant doesn't have immediate results and call the blocking variant
when we're called again without IO_URING_F_NONBLOCK in flags.
(So there's no need to try to add a form of polling, although that is
possible if we ever become able to do that; I'll just forget about this
and be happy this part is easy)


That just leaves deciding if a filesystem handles the blocking variant
or not; ideally if we can know early (prep time) we can even mark
REQ_F_FORCE_ASYNC in flags to skip the non-blocking call for filesystems
that don't handle that and we get the best of both worlds.

I've had a second look and I still don't see anything obvious though;
I'd rather avoid adding a new variant of iterate()/iterate_shared() --
we could use that as a chance to add a flag to struct file_operation
instead? e.g., something like mmap_supported_flags:
-----
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c85916e9f7db..2ebbf48ee18b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1761,7 +1761,7 @@ struct file_operations {
 	int (*iopoll)(struct kiocb *kiocb, struct io_comp_batch *,
 			unsigned int flags);
 	int (*iterate) (struct file *, struct dir_context *);
-	int (*iterate_shared) (struct file *, struct dir_context *);
+	unsigned long iterate_supported_flags;
 	__poll_t (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
@@ -1797,6 +1797,10 @@ struct file_operations {
 				unsigned int poll_flags);
 } __randomize_layout;
 
+/** iterate_supported_flags */
+#define ITERATE_SHARED 0x1
+#define ITERATE_NOWAIT 0x2
+
 struct inode_operations {
 	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
 	const char * (*get_link) (struct dentry *, struct inode *, struct delayed_call *);
-----

and fix all usages of iterate_shared.

I guess at this rate it might make sense to rename mmap_supported_flags
to some more generic supported_flags instead?...

It's a bit more than I have signed up for, but I guess it's still
reasonable enough. I'll wait for feedback before doing it though; please
say if this sounds good to you and I'll send a v2 with such a flag, as
well as adding flags to dir_context as you had suggested.

Thanks,
-- 
Dominique Martinet | Asmadeus
