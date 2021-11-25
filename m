Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C264345DE21
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 16:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356331AbhKYQAp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 11:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349907AbhKYP6o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 10:58:44 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEB2C06139A;
        Thu, 25 Nov 2021 07:47:39 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id i5so12589658wrb.2;
        Thu, 25 Nov 2021 07:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=u5QGYTZaW6otr58vpcY6F1zEs33QOYjGdC7XYu2Xigo=;
        b=hhJ8mScRKxPwlThEkX5XE2xi44ovRKLaXeih3g+B2pLe7fafwY6l3/NNb9Ky+vFKTo
         tJvZNQtj3k/+T6pKy3UBe2PP4GVORE3ToUinGmTTarcnmIahIzutug53hClyBwYZTSrm
         DtIJgBCT8VE1S5grM6qX4wnFPJPRWnkq1n7DIyNu4VxtON1Khk++GYKd6ptIUWOD1Kgc
         AzCvDONK4u2TYFqsxouU9nGNYp7c+0/h0xAIfmdG63ZdWB3gc5bvSPyehJda/9tgIVnx
         CGydMx6Gqxny7n0jLOAErOPSKijCcIosXJKP+FqtVtSQhjvXZ/pWhSZ8BtzDa+OdzOA8
         PXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u5QGYTZaW6otr58vpcY6F1zEs33QOYjGdC7XYu2Xigo=;
        b=gbU+HUQrwilSPM0BowMe+W94czgN/4uAX5Jz9Pyjb2q9OlcLllPbkWbPTQCs4Lakzt
         3qd/UzxObGP0A0hooohvL7YQzoy7BA9ztOwIa0awRZ0tbTVkBLFK7hk1xUIa27MfqsNe
         fathrUz1H/TapyIidk2yEJrPzIyQO61VNAZMJhIjrjcAgu9LVv7bPdinSCiv/1L5De0D
         F0JARGp4BURT19UdLssv5m6pJsUFCGhXpfjEuFZux+jAyMRisTHVaA7YEK9+fbu6oC1e
         7XSl7uC9VwUEBGmF/pC6jzGOHM60JNbe0HVgteCas2+OUUaO+hoegO1OxNFKb9NfZzR5
         CtOA==
X-Gm-Message-State: AOAM531o1apaPu12S/6u7YihkhOcw54LsQncQ7nrFBtJle17MlF1y7R+
        955QMjcrlgol6a2BrWP1zELiyukb1QQ=
X-Google-Smtp-Source: ABdhPJztnwPkxw4cRlcr4Hxxtb686rc6DJzxgC35A26miPk/Jb4VJjRxLxi61YGvYq+c4pxMHqJxSw==
X-Received: by 2002:adf:f00a:: with SMTP id j10mr7785811wro.339.1637855258535;
        Thu, 25 Nov 2021 07:47:38 -0800 (PST)
Received: from [192.168.43.77] (82-132-229-54.dab.02.net. [82.132.229.54])
        by smtp.gmail.com with ESMTPSA id p2sm9408835wmq.23.2021.11.25.07.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 07:47:38 -0800 (PST)
Message-ID: <58998990-ab49-3a9b-522f-27980276f8c3@gmail.com>
Date:   Thu, 25 Nov 2021 15:47:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v1 1/3] fs: add parameter use_fpos to iterate_dir function
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20211123181010.1607630-1-shr@fb.com>
 <20211123181010.1607630-2-shr@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211123181010.1607630-2-shr@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/23/21 18:10, Stefan Roesch wrote:
> This adds the use_fpos parameter to the iterate_dir function.
> If use_fpos is true it uses the file position in the file
> structure (existing behavior). If use_fpos is false, it uses
> the pos in the context structure.

Looks sane, one question below

> 
> This change is required to support getdents in io_uring.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>   fs/exportfs/expfs.c    |  2 +-
>   fs/nfsd/nfs4recover.c  |  2 +-
>   fs/nfsd/vfs.c          |  2 +-
>   fs/overlayfs/readdir.c |  6 +++---
>   fs/readdir.c           | 28 ++++++++++++++++++++--------
>   include/linux/fs.h     |  2 +-
>   6 files changed, 27 insertions(+), 15 deletions(-)
> 
[...]
> diff --git a/fs/readdir.c b/fs/readdir.c
> index 09e8ed7d4161..8ea5b5f45a78 100644
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -21,6 +21,7 @@
>   #include <linux/unistd.h>
>   #include <linux/compat.h>
>   #include <linux/uaccess.h>
> +#include "internal.h"

Don't see this header is used in this patch. Just to be clear,
it is here only for 2/3, right?

[...]

-- 
Pavel Begunkov
