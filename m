Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B068389337
	for <lists+io-uring@lfdr.de>; Wed, 19 May 2021 18:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241976AbhESQGh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 May 2021 12:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241402AbhESQGh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 May 2021 12:06:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328A8C06175F;
        Wed, 19 May 2021 09:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xrYJbsm8XBvxi2yJ2qA9P43iIK0MPL7ZBIPpUfmicR0=; b=UFiocZpEd3n0qwbyeyoV48fzYM
        ZFY9/8N316MM8Ud/2P+STmeC0wK7OTD6v6uAhET6jaNjDWMfkYUdgXHsJiiXNE11Pkz5AdmMI+Nnw
        ZE25efNjaV+QXKBiyY2q40cvtNPTtOub9gCPwbn2OkVCdy64hM4Sce6UNpRGS2e9DCTE7/n6siwLM
        ASudhgIGnA9gSqB75xsnb4Lpxy0FVcEgnDL3WuVawFbb8MMXWm1NSr5y80xCKM/cY06qmiGvnfDFd
        qa24+rJkiM6OdbVbxZFz+8X90INBFbsTS7BQHmsAqClSrfLD9sZrv80eq0a1wwTarWWS9dE7rBIWp
        HEUAwZLg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljOgr-00F6Rg-0g; Wed, 19 May 2021 16:05:02 +0000
Date:   Wed, 19 May 2021 17:04:57 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     io-uring@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Daniel Colascione <dancol@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH  1/2] fs: anon_inodes: export anon_inode_getfile_secure
 helper
Message-ID: <YKU3KWn4ZnRSyyFY@infradead.org>
References: <20210519113058.1979817-1-memxor@gmail.com>
 <20210519113058.1979817-2-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519113058.1979817-2-memxor@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 19, 2021 at 05:00:56PM +0530, Kumar Kartikeya Dwivedi wrote:
> This is the non-fd installing analogue of anon_inode_getfd_secure. In
> addition to allowing LSMs to attach policy to the distinct inode, this
> is also needed for checkpoint restore of an io_uring instance where a
> mapped region needs to mapped back to the io_uring fd by CRIU. This is
> currently not possible as all anon_inodes share a single inode.

No need to export it, as io_uring can't be built modular.

> +struct file *anon_inode_getfile_secure(const char *name,
> +				       const struct file_operations *fops,
> +				       void *priv, int flags,
> +				       const struct inode *context_inode)
> +{
> +	return __anon_inode_getfile(name, fops, priv, flags, context_inode, true);
> +}
> +EXPORT_SYMBOL_GPL(anon_inode_getfile_secure);

Please avoid the overly long line here.

