Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41062EA31F
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 03:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbhAEB6F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 20:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbhAEB6F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 20:58:05 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B357C061793
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 17:57:24 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 190so931422wmz.0
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 17:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gOUN9nwL4fdSmAQbsvIuerTBMyqMjRcQYcrWPqJmW5E=;
        b=HI7HeC8yjUJzd1ovbDnrlSu7Pe9iNXQjf7CkbOFZETrObHB5lbSo1vo8UyiK7gtB0i
         C/l2T7C3m+BL4GOxZiFIb51nedTlOfAvbRelgv79stjOWdmV/vnQsc9Mun9ACJ3BDA00
         QyKvU8S9YnJQqifMHtWWg6fAw1QhEFwdo2VieGQF2bd1t2Om48XcJ4Wn8MFFAA0Zzbfp
         Uz9I9SL5reSrQ0fXS2geuYiLrCemRuKxBSJ6fghLdL0Grl2GkgahbeWE14iK9pwfBdFU
         +j4ZuDw5f/Dj71WW54N9ihWeTzDbr1cWBYpvfY/jwRLZAXoIc545oXp9DFF9C+ZmNsao
         sdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gOUN9nwL4fdSmAQbsvIuerTBMyqMjRcQYcrWPqJmW5E=;
        b=BW/o55fATsC/lX2QH6j34ajjK5AxOWiQd50rF4qUq1OI7XGFk+ty8HeU7WoVWVxcs8
         nm0ZTCL+BDhu/Q0dNJiKFLm4ErJyMxWvKKGZNRRSNuzysh2Rp2zkNJQaD6SVjx66CdIx
         NLtgfIyezv0X3Kj4wnt8rpgawGJYmWVRPnTRT2stEUtpXlxVIlnWqE10ZD2uW1YVkvtv
         +0GMbn4+AaAwbdOfTsTkxopTA1V7rdJtshb0jDGXRqGi4t+bkyGMzOsxPUx+uX1JeFyo
         MVQqK/TP1X9587jk7/8fV/AwuPT4CsRbbYa/szXlY3gDueW6cPTUxTzz3oATZpz6DbyL
         R1QQ==
X-Gm-Message-State: AOAM532XQ3O2Wsa2d53ERQHurkInCx+zwz3Yfzr+EpQbkxX3h8v4w7Fs
        lweTlB3ejA6E0keKHckp3UqFZFBYYVcOcw==
X-Google-Smtp-Source: ABdhPJwInRSBcoXsH2L1O+XMN66e6ZoLeL/tdU07xZmBwOH9aY961kYT150I9785NanW7TrFOJ7/qQ==
X-Received: by 2002:a7b:cb93:: with SMTP id m19mr1358476wmi.45.1609811843133;
        Mon, 04 Jan 2021 17:57:23 -0800 (PST)
Received: from [192.168.8.195] ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id e16sm104728572wra.94.2021.01.04.17.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 17:57:22 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-4-git-send-email-bijan.mottahedeh@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 03/13] io_uring: rename file related variables to rsrc
Message-ID: <4299b6c0-5ab8-ba8c-c763-7bdf8b569347@gmail.com>
Date:   Tue, 5 Jan 2021 01:53:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1608314848-67329-4-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/12/2020 18:07, Bijan Mottahedeh wrote:
> This is a prep rename patch for subsequent patches to generalize file
> registration.
[...]
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index d31a2a1..d421f70 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -285,7 +285,7 @@ enum {
>  	IORING_REGISTER_LAST
>  };
>  
> -struct io_uring_files_update {
> +struct io_uring_rsrc_update {

It's a user API, i.e. the header used by userspace programs, so can't
be changed or would break them.

>  	__u32 offset;
>  	__u32 resv;
>  	__aligned_u64 /* __s32 * */ fds;
> 

-- 
Pavel Begunkov
