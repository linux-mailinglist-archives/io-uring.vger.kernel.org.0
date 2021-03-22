Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF460343687
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 03:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCVCFB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Mar 2021 22:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhCVCEf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Mar 2021 22:04:35 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA68C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:04:34 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b9so15005160wrt.8
        for <io-uring@vger.kernel.org>; Sun, 21 Mar 2021 19:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9pBR6H9vxt40eu+G/1MtwBQNDgptHFPnsxWtqcvCKO0=;
        b=WCnubOYygAcrxRU/Bbp79iFiQEgyZedjCJ2II14amkZqFHkZ0GrjnHu1rWXJ1jFlPC
         4lzskMaDi3tjRIJZirhDc9yMTY2tbVcjaXsaf/d0O8ccd5bGCUtguZp/QWvkmahvvZ8i
         SztVHzpou+Qph76D/aQDMt0vYGRaNIWiACtKoVMJeWAeGOc83RNOYg2d9LfzblCjTGs0
         NdGHCwRlodaWx/bQNVBQoX1XSahCSuol20ztpeQM1exw09dlzGyVaFm7YYOfTOmG7gh3
         sLEn6ZGSQXAVO+s0+uUXU3q9UlH4AMfIvNaCUia+e3E18Q0R0PymncJ/t/AVExTP8tnM
         e3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9pBR6H9vxt40eu+G/1MtwBQNDgptHFPnsxWtqcvCKO0=;
        b=bJgXHSYbxGjLMUg8Zu39Y7BrxLcehL+GgAtNsG76zv9ELGvzmXQFSFCxSqFVKhiQEG
         mxdHXLP0FxnNwiZbR+rrX3X4uK328Pu0fZeOhtpqJIre2hmBL9rE/1to6NA+w0m1nt+O
         +PZsoJ2gCGpzyDN7UgJoUc3sewTIbRW0mXsDW0E98oywQBwd6QnUPUUwNlE8gft5k6Zl
         1nNyug++tl9vAz92TdMcLLoWGzjswS44gTFi26nQKgF5ZP4Nwdi38yxAHiUj2xndegt3
         voPl1R7Yus5yx2nsJJz2YP9acIVrhpg4ukCg72FqKiyjgK9Kb6mjyAZLQS5UEs5fW7uC
         IfDw==
X-Gm-Message-State: AOAM530VR0Z0U8MMhB+B7yaWHsDmHOn+ccZegGYdya+NBxD6uFmOV9ys
        LezB2O51TePlyK87TmZ13v7Bg3/mVNax8w==
X-Google-Smtp-Source: ABdhPJwb/EJ2D/HxnEA1xbEop+j605+uMZXNSv8N3irW2ChfIpcMMnA6yQsyIhzDNaxLvrLPL7rz9A==
X-Received: by 2002:adf:de91:: with SMTP id w17mr16069207wrl.268.1616378673352;
        Sun, 21 Mar 2021 19:04:33 -0700 (PDT)
Received: from [192.168.8.179] ([85.255.234.202])
        by smtp.gmail.com with ESMTPSA id p27sm15579368wmi.12.2021.03.21.19.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 19:04:33 -0700 (PDT)
Subject: Re: [PATCH 5.13 00/11] yet another series of random 5.13 patches
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1616378197.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <63da2c83-9237-7e03-7354-29ea94518deb@gmail.com>
Date:   Mon, 22 Mar 2021 02:00:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22/03/2021 01:58, Pavel Begunkov wrote:
> Random improvements for the most part, 8-11 are about optimising rw and
> rw reissue.

note: depends on just sent "io_uring: don't skip file_end_write() on
reissue" for-5.12 patch

> 
> Pavel Begunkov (11):
>   io_uring: don't clear REQ_F_LINK_TIMEOUT
>   io_uring: don't do extra EXITING cancellations
>   io_uring: optimise out task_work checks on enter
>   io_uring: remove tctx->sqpoll
>   io-wq: refactor *_get_acct()
>   io_uring: don't init req->work fully in advance
>   io_uring: kill unused REQ_F_NO_FILE_TABLE
>   io_uring: optimise kiocb_end_write for !ISREG
>   io_uring: don't alter iopoll reissue fail ret code
>   io_uring: hide iter revert in resubmit_prep
>   io_uring: optimise rw complete error handling
> 
>  fs/io-wq.c    |  17 +++----
>  fs/io_uring.c | 128 +++++++++++++++++++++++++-------------------------
>  2 files changed, 72 insertions(+), 73 deletions(-)
> 

-- 
Pavel Begunkov
