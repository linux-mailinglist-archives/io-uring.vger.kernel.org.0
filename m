Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336726F2BD4
	for <lists+io-uring@lfdr.de>; Mon,  1 May 2023 02:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjEAAt7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 20:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjEAAt7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 20:49:59 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26194E53;
        Sun, 30 Apr 2023 17:49:56 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id C1BC6C020; Mon,  1 May 2023 02:49:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682902193; bh=hm15N7vJax2mIWusbMRVcnUBbMzuLPS5BPsJqPiU/l0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LQrfuPvo+JHtj/a2D7YjTJcIuWGY2hznh1E95isCOIFcruF/ujhq7m+BRkVADh4Zm
         4A7bLtgj+vOXukiylg12o0cs4i6I4pgfxi9tJNjs7MFPXmo07DqF+cpRbTturmkb0K
         wVTFfduRC5XYHwwQxWKsfqeDxcO67d5hYemg2KzsbPQ1RuQrk7udZ8lhkmVFUdcA8C
         QuEHC3DiRAJ0MbgjbIJDiKCIkY6r6149q6QXOwSe3kP8ipG+FD+OArup59Pro43tJJ
         9LsyJ/Ox8QRjovtm7Rs9SWnMp4WyNFhfA50uxjenloxH/kUn5XvEjVWl1lTfg2uacG
         mNmYlCpVkbzCA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 33F82C009;
        Mon,  1 May 2023 02:49:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682902192; bh=hm15N7vJax2mIWusbMRVcnUBbMzuLPS5BPsJqPiU/l0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nCMEMOrgncu0lf+YKNq3elkcOl+mEF6t41Ctn+b71TitRkXfS6hSr+exbszGBMGPd
         rPVVgq+LvR/v85KTA7JekdRkKrR83em/pWmsvNYF0CnlnvBgs5gwW1tJqhSmXLGnjw
         70ZNfyOgC9g+dELL4M3Hmd5JTnlm0sldrEzXkaEcjKwOzDlKkQKx5rcneOzFaQI57H
         vtpDPY+fA3e4hOXhnMej21ht0dychC0O58slMdGPkuB+3vWmJm6fMflEwRTIYOKFTR
         e0h0QcYtf3qyi7+61Lj5mZHTXbHCMhlfezuEGYeuq5Q9DKzE14sXExfg88AE5HFCGn
         xJKaAwX++IUVg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 34ab558c;
        Mon, 1 May 2023 00:49:46 +0000 (UTC)
Date:   Mon, 1 May 2023 09:49:31 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <ZE8Mm-9PikpFSjLp@codewreck.org>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
 <ZEXChAJfCRPv9vbs@codewreck.org>
 <20230428050640.GA1969623@dread.disaster.area>
 <ZEtkXJ1vMsFR3tkN@codewreck.org>
 <ZEzQRLUnlix1GvbA@codewreck.org>
 <20230430233241.GC2155823@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230430233241.GC2155823@dread.disaster.area>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dave Chinner wrote on Mon, May 01, 2023 at 09:32:41AM +1000:
> > I've had a second look and I still don't see anything obvious though;
> > I'd rather avoid adding a new variant of iterate()/iterate_shared() --
> > we could use that as a chance to add a flag to struct file_operation
> > instead? e.g., something like mmap_supported_flags:
> 
> I don't think that makes sense - the eventual goal is to make
> ->iterate() go away entirely and all filesystems use
> ->iterate_shared(). Hence I think adding flags to select iterate vs
> iterate_shared and the locking that is needed is the wrong place to
> start from here.

(The flag could just go away when all filesystems not supporting it are
gone, and it could be made the other way around (e.g. explicit
NOT_SHARED to encourage migrations), so I don't really see the problem
with this but next point makes this moot anyway)

> Whether the filesystem supports non-blocking ->iterate_shared() or
> not is a filesystem implementation option and io_uring needs that
> information to be held on the struct file for efficient
> determination of whether it should use non-blocking operations or
> not.

Right, sorry. I was thinking that since it's fs/op dependant it made
more sense to keep next to the iterate operation, but that'd be a
layering violation to look directly at the file_operation vector
directly from the uring code... So having it in the struct file is
better from that point of view.

> We already set per-filesystem file modes via the ->open method,
> that's how we already tell io_uring that it can do NOWAIT IO, as
> well as async read/write IO for regular files. And now we also use
> it for FMODE_DIO_PARALLEL_WRITE, too.
> 
> See __io_file_supports_nowait()....
> 
> Essentially, io_uring already cwhas the mechanism available to it
> to determine if it should use NOWAIT semantics for getdents
> operations; we just need to set FMODE_NOWAIT correctly for directory
> files via ->open() on the filesystems that support it...

Great, I wasn't aware of FMODE_NOWAIT; things are starting to fall in
place.
I'll send a v2 around Wed or Thurs (yay national holidays)

> [ Hmmmm - we probably need to be more careful in XFS about what
> types of files we set those flags on.... ]

Yes, FMODE_NOWAIT will be set on directories as xfs_dir_open calls
xfs_file_open which sets it inconditionally... So I got to check other
filesystems don't do something similar as a bonus, but it looks like
none that set FMODE_NOWAIT on regular files share the file open path,
so at least that shouldn't be too bad.
Happy to also fold the xfs fix as a prerequisite patch of this series or
to let you do it, just tell me.


Thanks,
-- 
Dominique Martinet | Asmadeus
