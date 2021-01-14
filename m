Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F262F6D28
	for <lists+io-uring@lfdr.de>; Thu, 14 Jan 2021 22:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbhANVY6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 16:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbhANVY6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 16:24:58 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0AFC0613C1
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 13:24:17 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d26so7245238wrb.12
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 13:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6sze08ZHhUNsh3nD9JZwK6TKwJ0W1cTPzYaIZSK4ix0=;
        b=pZ67woARk1svEY9Shnf7vKHf5xwbvG42UtZ48bWxTd/MxI2/vsCVqw9VvEfV6C/iPM
         bfgivIZhburaCU2Fr2Xm0fy2ozaF52VCNczisKKV+HeOo+gTGbZ3fh1JXtsG6TdfSOyr
         oQuf/dwq47OVzmzQgg6DpKmSIKHcwWowKqB1XlOt40eDK4cRAQI5CwZ12vZBzhY7xdeq
         gDnRuG83AssaWpGbYsrfZh/9AZURngtF05UdnHzHJKYsTotJ+uJFQ41qz60bfkSuvCqP
         oi9rulTnsdYaNedEKMJEy8xD7PedKy8ETURnCMWxp56BrXDfHojLX5LFZ/rnsztUmuRy
         CSkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6sze08ZHhUNsh3nD9JZwK6TKwJ0W1cTPzYaIZSK4ix0=;
        b=J7D5raVP3PvB9cXP/udCqoA+0i4lVm2UV1Oic0B1o8fvwVM9iu2rM6d+wqg2yxjzCt
         ExlM+gHB6s3KFz0HNv2xAStnvABHnauW/0U2tlvAoFQSPAKszu19NUhlawg7rsxD3cIi
         9wO9qaAp9tm7zgDpMy+ro5wDohZsSgwH5wSS5d0FilCByj7Hr419JUsXYB5GjlMyx8zV
         ldJjLc432V+OHnS9EBTdI+k6hI2sodhtIeX/cOTQsdrCcNv4HGsaOe+M/lvvBn8vwcEf
         8QTAwfqCg3dpEywuEx7FieMsHR9gC+Nm7Vm7yThxCVRCRA06shNki3VVhdnmJI7zOgr/
         VWOA==
X-Gm-Message-State: AOAM532KdOK851yUAx4tJzR+dRDE+LPU1RJ8lUMvLRYbA07chfOfxv79
        oeIwsNLnumJOFlnAjx3AuCHuOKRBSgr96A==
X-Google-Smtp-Source: ABdhPJwQikeqw7u65EZXY/klHT9FDYhMuhmnZoTQDPuu54bOQZ+9p0KMH+D3lJJiz7QP33Iirw7QVQ==
X-Received: by 2002:a5d:55c6:: with SMTP id i6mr9853060wrw.137.1610659456087;
        Thu, 14 Jan 2021 13:24:16 -0800 (PST)
Received: from [192.168.8.122] ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id v1sm10093571wmj.31.2021.01.14.13.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 13:24:15 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v5 00/13] io_uring: buffer registration enhancements
Message-ID: <86a8ae2e-78b4-6d8c-1aea-5f169de5aabc@gmail.com>
Date:   Thu, 14 Jan 2021 21:20:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/01/2021 21:33, Bijan Mottahedeh wrote:
> v5:
> 
> - call io_get_fixed_rsrc_ref for buffers
> - make percpu_ref_release names consistent
> - rebase on for-5.12/io_uring

To reduce the burden I'll take the generalisation patches from that,
review and resend to Jens with small changes leaving your "from:".
I hope you don't mind, that should be faster.

I'll remove your signed-off and will need it back by you replying
on this coming resend.

> 
> v4:
> 
> - address v3 comments (TBD REGISTER_BUFFERS)
> - rebase
> 
> v3:
> 
> - batch file->rsrc renames into a signle patch when possible
> - fix other review changes from v2
> - fix checkpatch warnings
> 
> v2:
> 
> - drop readv/writev with fixed buffers patch
> - handle ref_nodes both both files/buffers with a single ref_list
> - make file/buffer handling more unified
> 
> This patchset implements a set of enhancements to buffer registration
> consistent with existing file registration functionality:
> 
> - buffer registration updates		IORING_REGISTER_BUFFERS_UPDATE
> 					IORING_OP_BUFFERS_UPDATE
> 
> - buffer registration sharing		IORING_SETUP_SHARE_BUF
> 					IORING_SETUP_ATTACH_BUF
> 
> Patch 1-5 generalize fixed_file functionality to fixed_rsrc.
> 
> Patch 6 applies fixed_rsrc functionality for fixed buffers support.
> 
> Patch 7-8 generalize files_update functionality to rsrc_update.
> 
> Patch 9 implements buffer registration update, and introduces
> IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE, consistent
> with file registration update.
> 
> Patch 10 generalizes fixed resource allocation 
> 
> Patch 11 renames percpu release routines for consistency
> 
> Patch 12 calls io_get_fixed_rsrc_ref() for buffers as well as files
> 
> Patch 13 implements buffer sharing among multiple rings; it works as follows:
> 
> - A new ring, A,  is setup. Since no buffers have been registered, the
>   registered buffer state is an empty set, Z. That's different from the
>   NULL state in current implementation.
> 
> - Ring B is setup, attaching to Ring A. It's also attaching to it's
>   buffer registrations, now we have two references to the same empty
>   set, Z.
> 
> - Ring A registers buffers into set Z, which is no longer empty.
> 
> - Ring B sees this immediately, since it's already sharing that set.
> 
> Testing
> 
> I have used liburing file-{register,update} tests as models for
> buffer-{register,update,share}, tests and they run ok.
> 
> TBD
> 
> - Need a patch from Pavel to address a race between fixed IO from async
> context and buffer unregister, or force buffer registration ops to do
> full quiesce.
> 
> - Need to still address Pavel's comments about unkillable deadlocks. It
> seems that we should no long hange unkillably in io_rsrc_ref_quiesce()
> because of Pavel's changes.
> 
> - I tried to use a single opcode for files/buffers but ran into an
> issue since work_flags is different for files/buffers.  This should
> be ok for the most part since req->work.flags is ultimately examined;
> however, there are place where io_op_defs[opcode].work_flags is examined
> directly, and I wasn't sure what would the best way to handle that.
> 
> Bijan Mottahedeh (13):
>   io_uring: rename file related variables to rsrc
>   io_uring: generalize io_queue_rsrc_removal
>   io_uring: separate ref_list from fixed_rsrc_data
>   io_uring: split alloc_fixed_file_ref_node
>   io_uring: add rsrc_ref locking routines
>   io_uring: implement fixed buffers registration similar to fixed files
>   io_uring: create common fixed_rsrc_ref_node handling routines
>   io_uring: generalize files_update functionlity to rsrc_update
>   io_uring: support buffer registration updates
>   io_uring: create common fixed_rsrc_data allocation routines
>   io_uring: make percpu_ref_release names consistent
>   io_uring: call io_get_fixed_rsrc_ref for buffers
>   io_uring: support buffer registration sharing
> 
>  fs/io_uring.c                 | 803 ++++++++++++++++++++++++++++++++----------
>  include/uapi/linux/io_uring.h |  13 +-
>  2 files changed, 626 insertions(+), 190 deletions(-)
> 

-- 
Pavel Begunkov
