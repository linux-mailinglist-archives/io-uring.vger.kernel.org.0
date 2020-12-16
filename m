Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2E92DC339
	for <lists+io-uring@lfdr.de>; Wed, 16 Dec 2020 16:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgLPPiT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 10:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgLPPiT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 10:38:19 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9675C061794
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 07:37:38 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id q75so2878936wme.2
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 07:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cZS1D0QMfT9kHjuOSa9WhzH3VIIKr9rJoHbg6y3U6xI=;
        b=o4Zier808e3R2tjusCzGDHWcawJi5FKKMAoovoM8hTZzGzP+df3vyKwbFQUWWqUEnj
         sGmIi7rTrEfYuDby8dhrFFYyXkSYuRVSlSeN1kWQ5LqNOig/1LXsuU92PZisvTI89mKs
         2kf9/Lz8kVu+u9iQUTJuiY0zwD+HgDl77eOkbLlkvkf5plJNnJCR5JXmA9f7oD6lazoQ
         R0MWERATk857kk8D536DCibSt2kqErI2d1xP9PyoDdpQ/o9Cp9S2+RlRt8QJ2+XajaXZ
         A8EwWNDnm3pLx6Hd8ZDxgHX0c/VayhTjDaCY/QrfXEmp4rt+IGJ6ljLwvqvKOiQy0NeA
         jYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cZS1D0QMfT9kHjuOSa9WhzH3VIIKr9rJoHbg6y3U6xI=;
        b=FWbv+hCAGkt92Xh6IurPY8uZyLgKtJSkCo71TGBxi0NtUVgkFQrIlfO4KtTTHiu/l8
         Tu8P8ibk+437TWEsq53yuYNHYui+wtKM0Pb7vEK7UDTRjzwaEDArBIVFIZ/TgpmVqCUW
         SR6xI5MPmeModMxwEBRyPv/WU7CeLShcgOphQ8om7gi141e/x8hED7zpdYmD8TQPO1nr
         VG9AyTQPEtzx8ODOlBQiifRm+Hy1uAVwxkhGt3Kkd1TbjEQf2o0WcLbB2+d8EV3qIk6v
         rJf+o+eei0NrqVd7/d+bjl/4bUFN91RDsHOjSEga9Jy5/0YZrqoi4A3oKbE9NV8H22nL
         ukAg==
X-Gm-Message-State: AOAM530YwT8NzuA1Me4ntiq7w9OOjGcXJCjWk7lX4WlkAQk2Mu8cTP21
        FDNVhZvIaD/mNn//JbiDbWj64kVW2besJw==
X-Google-Smtp-Source: ABdhPJzFZGxw06B/18BAfvTigsgwpaOMtB+4Tvgm8ZrDkXAHFTSH0Qs/X+YBmcUi6+aDzyuA9d2pxA==
X-Received: by 2002:a1c:b3c3:: with SMTP id c186mr4011309wmf.169.1608133057069;
        Wed, 16 Dec 2020 07:37:37 -0800 (PST)
Received: from [192.168.8.128] ([185.69.144.225])
        by smtp.gmail.com with ESMTPSA id h4sm3670158wrt.65.2020.12.16.07.37.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 07:37:36 -0800 (PST)
Subject: Re: [PATCH v2 00/13] io_uring: buffer registration enhancements
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <c1f6faa1-63a4-777c-fe46-2ee7952baa2f@gmail.com>
Date:   Wed, 16 Dec 2020 15:34:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/12/2020 22:15, Bijan Mottahedeh wrote:
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
> I have kept the original patchset unchanged for the most part to
> facilitate reviewing and so this set adds a number of additional patches
> mostly making file/buffer handling more unified.

Thanks for the patches! I'd _really_ prefer for all s/files/rsrc/
renaming being in a single prep patch instead of spilling it all around.
I found one bug, but to be honest it's hard to get through when functional
changes and other cleanups are buried under tons of such renaming.

> 
> Patch 1-2 modularize existing buffer registration code.
> 
> Patch 3-7 generalize fixed_file functionality to fixed_rsrc.
> 
> Patch 8 applies fixed_rsrc functionality for fixed buffers support.
> 
> Patch 9-10 generalize files_update functionality to rsrc_update.
> 
> Patch 11 implements buffer registration update, and introduces
> IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE, consistent
> with file registration update.
> 
> Patch 12 generalizes fixed resource allocation 
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
> - Haven't addressed Pavel's comment yet on using a single opcode for
> files/buffers update, pending Jen's opinion.  Could we encode the resource
> type into the sqe (e.g. rw_flags)?
> 
> Bijan Mottahedeh (13):
>   io_uring: modularize io_sqe_buffer_register
>   io_uring: modularize io_sqe_buffers_register
>   io_uring: generalize fixed file functionality
>   io_uring: rename fixed_file variables to fixed_rsrc
>   io_uring: separate ref_list from fixed_rsrc_data
>   io_uring: generalize fixed_file_ref_node functionality
>   io_uring: add rsrc_ref locking routines
>   io_uring: implement fixed buffers registration similar to fixed files
>   io_uring: create common fixed_rsrc_ref_node handling routines
>   io_uring: generalize files_update functionlity to rsrc_update
>   io_uring: support buffer registration updates
>   io_uring: create common fixed_rsrc_data allocation routines.
>   io_uring: support buffer registration sharing
> 
>  fs/io_uring.c                 | 1004 +++++++++++++++++++++++++++++------------
>  include/uapi/linux/io_uring.h |   12 +-
>  2 files changed, 732 insertions(+), 284 deletions(-)
> 

-- 
Pavel Begunkov
