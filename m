Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FFE3A3400
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 21:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhFJT1T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 15:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhFJT1S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 15:27:18 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA38C061574
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 12:25:06 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso7120180wmj.2
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 12:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=orNU9VbKr28jvMylRDhVlI9D4L62yfV0ro8QwD2cGfY=;
        b=UiVwHGa3AUjVf7oIdJ17Yibv+0p3VXkpCpQfPpAulPUSCPL24bWFSxtfT5aDhSN+91
         EY6xcoXPUUeGUeum0eTjV0UWWN/QIzwuMG4v+021V2v6aUhA+Qw1IxjW/qizzvfDSWU2
         8aqXOdcYu4Qw8QLI5KEIjX5YhO5dOZSyfQFSeqA/Dqsy98cbKF81u4DGbapJ/Ev35oIr
         OmGWDxJH81pPa6gfVIRVGyC+FgfCtWH9Q5k2dp8FtxwKD8YRHHwXaKWkdjXfO3aRjCFP
         QWYDoo2cWFLoq4qqA/owykM1WHWqPQNzA+r7BWPAD/68R8ZFV0qPnYqkJzIjaVqwgRe+
         lDyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=orNU9VbKr28jvMylRDhVlI9D4L62yfV0ro8QwD2cGfY=;
        b=tDFlByJK/+GZHp2u8j9b//bWwnfInnwsmEbCstz5kXA2oi7jc+3BtE8Pk0XANqeOBF
         5cfZAYopbftHcCP/sC9jcUQFpv5suQ89VlhbCIdSZYBt28jifzwS33XDp1R1H4G73BuM
         k/pemAhHn3qf857BQMt0a8NTSt7AJ2u9KVj9STUufibWve8SJ/feVXDt5yPhG/CHTcd/
         ZptSgUU0nxvYMr080UBA9z6eBaqjr5ggWDLp9D8ONJUoYvIjWpw5/OIRxVQhBd87t/QF
         8+WcaIU5UI5mbgEnIup1jEnvMbotVptKuhtn4/0jnmhmeuHobeMnCyQJ/NLS2Irctb2i
         n+uw==
X-Gm-Message-State: AOAM532poU3inpUIWmQGMhs+7XnfsA5bNgRrV+x06gbVFY5ZFljKPdhX
        MEfjqyu7okNqPsG7y6GJUiUiMzeMk2wp0w==
X-Google-Smtp-Source: ABdhPJw306goa9/QORztqEM0d8hxZiuJfwLZ+tvmtOo0lpXnQ84JoYPRNXaYxkSNIRriGT3TB9KFKA==
X-Received: by 2002:a05:600c:228d:: with SMTP id 13mr415394wmf.96.1623353104943;
        Thu, 10 Jun 2021 12:25:04 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.95])
        by smtp.gmail.com with ESMTPSA id f18sm3960013wmj.13.2021.06.10.12.25.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 12:25:04 -0700 (PDT)
Subject: Re: [PATCH liburing 1/1] update rsrc register/update ABI and tests
To:     Daniele Salvatore Albano <d.albano@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <7542c3d9d0a5fb926c9d8d83ae02f553c6874b97.1623339582.git.asml.silence@gmail.com>
 <CAKq9yRiQ2P+iggjOPD7fDSXY6GDOX7M_Aw8dyw--QKBvOrwHFw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <af61981e-6c3b-bc1c-543d-14358f451917@gmail.com>
Date:   Thu, 10 Jun 2021 20:24:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAKq9yRiQ2P+iggjOPD7fDSXY6GDOX7M_Aw8dyw--QKBvOrwHFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/10/21 8:10 PM, Daniele Salvatore Albano wrote:
> On Thu, 10 Jun 2021 at 18:42, Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> There is an ABI change for not yet released buffer/files
>> registration/update tagging/etc. support. Update the bits.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  src/include/liburing/io_uring.h | 20 +++++++-------
>>  test/rsrc_tags.c                | 46 ++++++++++++++++++++-------------
>>  2 files changed, 38 insertions(+), 28 deletions(-)
>>
>> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
>> index 5a3cb90..4c5685d 100644
>> --- a/src/include/liburing/io_uring.h
>> +++ b/src/include/liburing/io_uring.h
>> @@ -141,7 +141,6 @@ enum {
>>         IORING_OP_SHUTDOWN,
>>         IORING_OP_RENAMEAT,
>>         IORING_OP_UNLINKAT,
>> -       IORING_OP_MKDIRAT,
> 
> Is dropping IORING_OP_MKDIRAT intentionally part of the patch?

Good catch, it is not. However, IORING_OP_MKDIRAT is not
supported yet anyway, so I don't actually care much

-- 
Pavel Begunkov
