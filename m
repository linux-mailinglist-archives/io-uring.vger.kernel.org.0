Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C146354634E
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 12:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344892AbiFJKOu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 06:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344761AbiFJKOt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 06:14:49 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D84311D
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 03:14:48 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v14so9608599wra.5
        for <io-uring@vger.kernel.org>; Fri, 10 Jun 2022 03:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9uT13hECjWgtnByYYpQ2b4SWBzhlOqq4qJFvV7tLm3w=;
        b=MYyzGwqJRK2wrkr22ciJyF2YrYOPOw0Bc9GNTDZLztswtQyXsbAScsRkyWYOIl9nMO
         6uKLqLUYkEv4tq5dNYtZOSZ9fAGeubxU0bjLuYWW9dKXln2MP5mATi6diPwcQtfaojPm
         Waix2BmYqBc61XEP32O/OPq3Dk9zncgIfMQkUeyYhpI/Ehmdq/MU++Bk5yv1I+sVD0uS
         QkhjYmbOT1rxP2HifO82PBmjyzAttiiN9IMYuWsxnbnk9YfH5FZRJ4dnX4rG3JNoQgY3
         a55//NCTYoj67D7BgcWkkWtDqSQpsF0ZTyNLIcqLx1gtYTcCd4kMKIdOE8Wovk8nEjoA
         p5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9uT13hECjWgtnByYYpQ2b4SWBzhlOqq4qJFvV7tLm3w=;
        b=3Nmoq2oLqlyJ5uawMHJlg13O8VYQ/hFuPJjDReCyC3aCOlkFyJgwY5GIZwrMKOZaEk
         Rbnp3BnlF6zOnUgzNCxrSXDBgqqCp5vZwiNZTKfnfKQThTGm/wuhovtXXdTTgnMtsP82
         DpHT4xBTHnNCwyH67nnD85f2nUH7IyudtLan61NENMzBqKZ33KxJ8VLN4z9Rt/ogtKEa
         jKu422kv2bNSNueD/JqDWLgz21a9AWgPUqt7mhOXaDFCxH3C9SxuzNub2O8vkgZ2WUQH
         WsscEAUNdwTdjL7USdlzYqLDssoAKXQaVV4N+ldJ6OEh3/m1T7kbPeIvFR5eoTMAnm7H
         JOJg==
X-Gm-Message-State: AOAM532UAJgTwYK21N2vczGDKIlaTCOoPSV5EgjxzgKrlLATbw1OyeJv
        hYblMyn+W45KX8wMoQyC0uieI+GqhjoJFw==
X-Google-Smtp-Source: ABdhPJxtHpO8nGSJkJkjwiGTMVeRvsz28Ia3LP+teG8om8Ff39REGIk9iVgz8ICK/JhrpwV/M45wfA==
X-Received: by 2002:adf:d4c7:0:b0:213:ba6b:b017 with SMTP id w7-20020adfd4c7000000b00213ba6bb017mr39492535wrk.652.1654856086794;
        Fri, 10 Jun 2022 03:14:46 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c028400b0039c45fc58c4sm2398177wmk.21.2022.06.10.03.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 03:14:46 -0700 (PDT)
Message-ID: <695b0207-2a93-6bbc-bb5c-b771283967c2@gmail.com>
Date:   Fri, 10 Jun 2022 11:13:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 0/5] misc update for openclose and provided buffer
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220610090734.857067-1-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220610090734.857067-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/10/22 10:07, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Patch 1 and 2 are bug fixes for openclose
> Patch 3 is to support better close logic
> Patch 4 is code clean
> Patch 5 is a bug fix for ring-mapped provided buffer

Looks that at least the problem from 1/5 also exists in 5.19,
can you split out 5.19 fixes and send them separately?


> Hao Xu (5):
>    io_uring: openclose: fix bug of closing wrong fixed file
>    io_uring: openclose: fix bug of unexpected return value in
>      IORING_CLOSE_FD_AND_FILE_SLOT mode
>    io_uring: openclose: support separate return value for
>      IORING_CLOSE_FD_AND_FILE_SLOT
>    io_uring: remove duplicate kbuf release
>    io_uring: kbuf: consume ring buffer in partial io case
> 
>   io_uring/io_uring.c  |  6 ------
>   io_uring/kbuf.c      |  9 +++++++--
>   io_uring/kbuf.h      | 10 ++++++++--
>   io_uring/openclose.c | 10 +++++++---
>   io_uring/rsrc.c      |  2 +-
>   5 files changed, 23 insertions(+), 14 deletions(-)
> 

-- 
Pavel Begunkov
