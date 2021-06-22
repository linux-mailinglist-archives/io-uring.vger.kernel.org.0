Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778863B036C
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 13:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhFVL6z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 07:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhFVL6y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 07:58:54 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA5FC06175F;
        Tue, 22 Jun 2021 04:56:37 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id i24so12558784edx.4;
        Tue, 22 Jun 2021 04:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T3PfNNJJcxPWydMzLgZkOIEQksb69trjaw03tCoGz3o=;
        b=sVi4Hh8m5uCrv4ow6Pmey21aCYYOWogWvQw/oHJb3BGhHdgbiFNbM3VpL0fXsre2X0
         ElEnY+3lwG5MC62endYvtYjKd9+lSV2SvJdNcJnfrAoRXJfCTXUb73Gz8h1I8LzuyR3V
         +MULrk8cX+EDt9GvjJPyF0WA4B1zjLuKjNhkjl6+SyC7O6T/YGOJMDUuOapGyxr0szzL
         rN8pAeeeZCIWPjiHBGG1nsaf2uSID0hrQaS+uQeEoqy9AxrNLcciQiWAyyUXit88RT+6
         ONlao1CpwNctShXp8qQLLpHIPsUhW/+pW1w6gJ3FmUuxoNmiJr6K08uR5wRCW9J0CPV5
         1hIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T3PfNNJJcxPWydMzLgZkOIEQksb69trjaw03tCoGz3o=;
        b=Kqiw5BIrsLlMndcDu/1SHZhRv1wmxTp86saz0Ei3PiyOmqMugmxiJOS1a44icTzodD
         6qYAGMbgBta0098X8v4BRJsfjVYT0AHGitmsXmnO5+ZNmS7XjBN1yRdbWr3K3ubmi7Qn
         YE0Mqbk0zeDVyFV0nqIvBLquLJGpAXm9pZ7hQD37wizZnONXg5Q0Cw/OpF4DnhSL95Kg
         +U5ZNL3bET6l6dtUfk8TpSNg1UQoR9zHn3pYhfcb42nU97DgahF+ADek2vdvsZsLlnvI
         ecMQ4/yP+4KQIyRIBtpCiIu8sDU6f8lWX/6oYW3HDOU21hOVde39MA9++1iIkgginXMH
         XLaA==
X-Gm-Message-State: AOAM533UqMLeX/dGZ3WGPM5F+XNRQp6N9e9aQ/qTnd1+Po4BeN6/wZtK
        wqMvEqZ2j85JFDDlElvBKmubDPp0SHEoJ7kB
X-Google-Smtp-Source: ABdhPJyVX+TksQK0JYxD9ipGvaD0kSrT7yed/r6+6VUcYpfWv0NdvZPFkEkUrZgIA8mHDV9FBCi9IQ==
X-Received: by 2002:a05:6402:40c3:: with SMTP id z3mr4359696edb.187.1624362996282;
        Tue, 22 Jun 2021 04:56:36 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:c503])
        by smtp.gmail.com with ESMTPSA id g12sm8967558edb.80.2021.06.22.04.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 04:56:35 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat
 support
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210603051836.2614535-1-dkadashev@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
Date:   Tue, 22 Jun 2021 12:56:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210603051836.2614535-1-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> This started out as an attempt to add mkdirat support to io_uring which
> is heavily based on renameat() / unlinkat() support.
> 
> During the review process more operations were added (linkat, symlinkat,
> mknodat) mainly to keep things uniform internally (in namei.c), and
> with things changed in namei.c adding support for these operations to
> io_uring is trivial, so that was done too. See
> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/

io_uring part looks good in general, just small comments. However, I
believe we should respin it, because there should be build problems
in the middle.


> The first patch is preparation with no functional changes, makes
> do_mkdirat accept struct filename pointer rather than the user string.
> 
> The second one leverages that to implement mkdirat in io_uring.
> 
> 3-6 just convert other similar do_* functions in namei.c to accept
> struct filename, for uniformity with do_mkdirat, do_renameat and
> do_unlinkat. No functional changes there.
> 
> 7 changes do_* helpers in namei.c to return ints rather than some of
> them returning ints and some longs.
> 
> 8-10 add symlinkat, linkat and mknodat support to io_uring
> (correspondingly).
> 
> Based on for-5.14/io_uring.
> 
> v5:
> - rebase
> - add symlinkat, linkat and mknodat support to io_uring
> 
> v4:
> - update do_mknodat, do_symlinkat and do_linkat to accept struct
>   filename for uniformity with do_mkdirat, do_renameat and do_unlinkat;
> 
> v3:
> - rebase;
> 
> v2:
> - do not mess with struct filename's refcount in do_mkdirat, instead add
>   and use __filename_create() that does not drop the name on success;
> 
> 
> Dmitry Kadashev (10):
>   fs: make do_mkdirat() take struct filename
>   io_uring: add support for IORING_OP_MKDIRAT
>   fs: make do_mknodat() take struct filename
>   fs: make do_symlinkat() take struct filename
>   namei: add getname_uflags()
>   fs: make do_linkat() take struct filename
>   fs: update do_*() helpers to return ints
>   io_uring: add support for IORING_OP_SYMLINKAT
>   io_uring: add support for IORING_OP_LINKAT
>   io_uring: add support for IORING_OP_MKNODAT
> 
>  fs/exec.c                     |   8 +-
>  fs/internal.h                 |  10 +-
>  fs/io_uring.c                 | 240 ++++++++++++++++++++++++++++++++++
>  fs/namei.c                    | 137 ++++++++++++-------
>  include/linux/fs.h            |   1 +
>  include/uapi/linux/io_uring.h |   6 +
>  6 files changed, 349 insertions(+), 53 deletions(-)
> 

-- 
Pavel Begunkov
