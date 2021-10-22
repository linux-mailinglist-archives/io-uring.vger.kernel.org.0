Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5ACF437465
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 11:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhJVJNB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 05:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbhJVJNA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Oct 2021 05:13:00 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6330BC061764;
        Fri, 22 Oct 2021 02:10:43 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id u13so1034185edy.10;
        Fri, 22 Oct 2021 02:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:cc:from:in-reply-to:content-transfer-encoding;
        bh=P6jDog9aGxRaFIsyIUOXH5bsPwrCpSO2aM+bugPoS5U=;
        b=BgmeNdGonvO83jDYphBBuB7X24UY15U4zDGDDcjVz/6x30II/biCBrYw08YkZPMji/
         kxParE3DOhd9Yi3NNAU/CSTqJ6ltPyJsqvgNZGVnDHxPBjg/3XufvkpOuECAHcf9tp9C
         IMsqqFPTwPsHgaOsU5ghPKSdvRuEOvWbUEyzMtcQV8IyE5fkkz5s+aI33h6XTCIQjJXn
         9MPTOLKb48LJwRmfryjaypGgRhvoSyRaQRk2AWC1OSJoxY0xT03TQj3AiMJbIgnpb522
         ACYnPtUB3o9kqPNTcvL0v+A4hSmsU/uHaDB6iWoKp2GU0la3L8T6YUkAmhocyTk+iMUB
         4B+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=P6jDog9aGxRaFIsyIUOXH5bsPwrCpSO2aM+bugPoS5U=;
        b=l5KjeZjmZnuN1RyaVaDgMDM7euH+0SFn2uNG9Etuq1FchMEUlwjZzlKHoCWDQUNi2D
         lhssCFDso5bI0UESxHNZB+m6OnI9bB5VE/Tn28pKWuaPUY1PhMHZdGGP21nltK6YIJY1
         rHz9sOdgD9HgCTk+tIxqYsJHEq0APFge+hBUKjEWVNxbd75E3HY3f9DWSoYQUqWK58fT
         JlA7sQ97oQ1yirp2UPNnEfdtMOTJPLh7QOHFtffd4GOJ9v8riJc2hUAMPa6ZGL6XQoB5
         i2nPiUAYvwdwAEib6SSIx1zaLQeVOOr5E3waHqef4g/ciHONx1Nm3YjBQoD9H6z8TR5R
         I5JQ==
X-Gm-Message-State: AOAM533Tzee/eadTpk/Z1bmIvvw1vb174E0SC2W5dlSZu8phqRfJpion
        Gj07H1JDO9lv88i8W9iYOT8=
X-Google-Smtp-Source: ABdhPJy//JuJ99iNpcHrHxfk0EphY5E8T+oO0hQwIzzQeAbl2rkJlQ9NbfsX00ig6PF++uOugjtLEg==
X-Received: by 2002:a50:f09c:: with SMTP id v28mr13927010edl.360.1634893841999;
        Fri, 22 Oct 2021 02:10:41 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id u18sm4046521eds.86.2021.10.22.02.10.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 02:10:41 -0700 (PDT)
Message-ID: <77f9feaa-2d65-c0f5-8e55-5f8210d6a4c6@gmail.com>
Date:   Fri, 22 Oct 2021 10:10:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: uring regression - lost write request
Content-Language: en-US
To:     Daniel Black <daniel@mariadb.org>, linux-block@vger.kernel.org
References: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
Cc:     io-uring@vger.kernel.org
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CABVffENnJ8JkP7EtuUTqi+VkJDBFU37w1UXe4Q3cB7-ixxh0VA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/22/21 04:12, Daniel Black wrote:
> Sometime after 5.11 and is fixed in 5.15-rcX (rc6 extensively tested
> over last few days) is a kernel regression we are tracing in
> https://jira.mariadb.org/browse/MDEV-26674 and
> https://jira.mariadb.org/browse/MDEV-26555
> 5.10 and early across many distros and hardware appear not to have a problem.
> 
> I'd appreciate some help identifying a 5.14 linux stable patch
> suitable as I observe the fault in mainline 5.14.14 (built

Cc: io-uring@vger.kernel.org

Let me try to remember anything relevant from 5.15,
Thanks for letting know

-- 
Pavel Begunkov
