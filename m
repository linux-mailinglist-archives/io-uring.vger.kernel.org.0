Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4804B23E803
	for <lists+io-uring@lfdr.de>; Fri,  7 Aug 2020 09:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgHGHby (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Aug 2020 03:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgHGHbv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Aug 2020 03:31:51 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1B0C061574
        for <io-uring@vger.kernel.org>; Fri,  7 Aug 2020 00:31:51 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r4so723275wrx.9
        for <io-uring@vger.kernel.org>; Fri, 07 Aug 2020 00:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=431Z8UePt/GZDfaYOVu20D0W6QP6Mj5ig4sTm6YIMbE=;
        b=X/M0nZkBSp38rJuvlZFW5Rlh/aeaabGB4UtmK05ipi5By453ztg6GGe0tzVN/HhZI3
         Oybhjocf6oQCsK5OzoBKq9U1yq6CzVLREC0JRZkyGmvPa5njLxmk1j5pg6njQgPJKBN+
         HNIX+l/tuffaAAWlCI+Zw3noq+2NxF7q1aaC8Z5gqUc0zUrUfodWj5hXNeg7jo/QVX7U
         ZhirIUCgYrnhDCC91DgHo6mlT833ZNqV/NdGjotAfLF3Wbf6gIUNIdM2PwCCPm7qSz6l
         DTu63U1+Ir0ovM1/iequzG3NJ96nADgy1v/Kt/G3qmFDTAKX3zJag6mt1yMApKa/5WQP
         HNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=431Z8UePt/GZDfaYOVu20D0W6QP6Mj5ig4sTm6YIMbE=;
        b=GR5uyEwGKB5N8Kdv4mOiFD+SMBMe8aQsgQYfsvE6G9SwKC5MLjqDb3fYd5q2K2fBqb
         ahCRAnQHswVy9BwQ9OIB7702wJ12KOVmkPAsl6gj97G/uqTghmhTQZvzGTlDZ59bxwOu
         2whu9RWu+kzfil/G61aN0v8w/sC4zVC0WMiqCE5hz0lBsIZDZFhuudqxjHuoDbFfoMi/
         ZFyCJS8w5H6v6cAm0fO3nLzKBy8oCugfrfhjhcoJJlz9MSpev5tw4ZRJcm5azfaS699t
         DPZutbYyLgNndpTsGKmohDBwF2Jqsp2PV3tVPTsqvZKN/JGUsTag4bV52khVvBiHvIof
         aW7A==
X-Gm-Message-State: AOAM533ieN2eOyBs5UMsfKeuRwBTu4/oQIsqsPxnCMlaHirdx7iUbFol
        3vJT1QU0OKKNFFM18lyUv7lFgNVFJjc=
X-Google-Smtp-Source: ABdhPJxlZmDpeWvMjDRddlF4clBK8xVualC+Km6kP87S4Xo/9cOBotLhHLq5yJdixXTtyF8uZfs47w==
X-Received: by 2002:a5d:4dc3:: with SMTP id f3mr10459448wru.161.1596785509755;
        Fri, 07 Aug 2020 00:31:49 -0700 (PDT)
Received: from [192.168.43.215] ([5.100.192.0])
        by smtp.gmail.com with ESMTPSA id z6sm10101595wml.41.2020.08.07.00.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 00:31:49 -0700 (PDT)
To:     Josef <josef.grieb@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAAss7+rhVS669Q=PCHrmHXbr067HpdC7Dtu0ogm4u-uj6-qK3Q@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: wake up io_uring_enter(...IORING_ENTER_GETEVENTS..) via eventfd
Message-ID: <2cc90695-3705-b602-beac-db2252d13b86@gmail.com>
Date:   Fri, 7 Aug 2020 10:29:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+rhVS669Q=PCHrmHXbr067HpdC7Dtu0ogm4u-uj6-qK3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I'd love to help but don't have time at the moment. I'll take a look but
in a week, either send it to io-uring@vger.kernel.org. Jens deals with
such stuff lightning fast!

> io_uring application should be a single thread in my application which
> means a different thread wakes up io_uring_enter via eventfd. The issue is
> that io_uring_enter(fd, 0, min_complete, IORING_ENTER_GETEVENTS, 0) which
> is blocking doesn't get any poling event from eventfd_write when both
> functions are executed in different threads

Yeah, sounds strange. Did you try to do the same but without io_uring?
e.g. with write(2), select(2).

> 
> 
> here small example
> 
> https://gist.github.com/1Jo1/6496d1b8b6b363c301271340e2eab95b
> 
> 
> io_uring_enter will get a polling event if you move eventfd_write(efd,
> (eventfd_t) 1L) to the main thread,
> 
> I don't get it..probably I missed something, why can't I run both functions
> on different threads, any ideas what the cause might be?
> 
> 
> (Linux Kernel 5.7.10-201) liburing 0.6 & 0.7
> 
> ---
> Josef
> 

-- 
Pavel Begunkov
