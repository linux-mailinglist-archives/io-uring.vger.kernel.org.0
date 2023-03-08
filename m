Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDAA6AFB25
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 01:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCHAcD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 19:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjCHAcD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 19:32:03 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C669B0482
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 16:32:01 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id n6so16102834plf.5
        for <io-uring@vger.kernel.org>; Tue, 07 Mar 2023 16:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678235520;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AEsMgalcatpSKQO/pDZVaHweQJaXK1mWCaEr5mhyepU=;
        b=rsB/B7Cfuk4rjsdAczPw02m2FmRN7MTInKl6zemXOO/ZVFzkZxDPS5d5xhOyIDQ/Hd
         ZK2q2GnZTtIV6Nk7c0t/DDi8KxzCRxez1BYexvIg83Ej3aP3uajkmYgLOGUpIbr7EkCM
         GNKbLv2KS5YHDn+6upoHFKB8kkpH5KlEjZRoRHpgjZuvo6mR6kA6BtVadtffi7J2tIWo
         Drx7NBxkEpA4O5i7Pg2en9NpzoYA7EiDQ91bUB42eFTZeP5aW5UQQNZ68EoL2Ob/aCGy
         Y6WSyavGa1xw7S13urK+pb47RIMgZze8a/w56PdQ+itvU1g4xhO/SxHCmDLdCtGq0jbl
         1kXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678235520;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AEsMgalcatpSKQO/pDZVaHweQJaXK1mWCaEr5mhyepU=;
        b=t6ZZ3O45btQ+o07MRIDJ/BPEtDs8Cq/39sKZRk1dM3msVrqoybE6Yy+uZms8qzHl8h
         R/s6OjMbcLT+Cic4O1PbMbpUHyNx75rHOopIztPmepXVhVCE2f0zOxHXnBWsiSKx4o3P
         L/KbuUeYykfFfwx5C0K7/BB4yVMROtqAhUFOaNCp0keG/hnsXKsducCwpc+UbUMkNV+v
         YEpYch57yb6/Ztx/YkXq6JGiF1+iqMOCZYoJb1O6ou6KqjeP6ORMVi4FWHpL2jkyYO2d
         /aFgVqsKGI/WCVkKqRhJ5gIrE4QoEgekwhPf6QzZEkBghJ9RT1bUXPPSJZhErmYsdjIo
         bLTA==
X-Gm-Message-State: AO0yUKWsDhexcrBaNfm2+MTMYQ3THgekKD1d+0p9fRK1ZbCq4DADd5WE
        bicKVBJLkW1R+aVm1iFkn5qlAuE7JJSwlY1C0mw=
X-Google-Smtp-Source: AK7set8N6zVADkbhO5WhiG2LAuOBDL7zqJZxE8JWVESIY4R+IXttseHYc/os4nAEUMpP6zFtvSz2Aw==
X-Received: by 2002:a17:902:e5d0:b0:196:3f5a:b4f9 with SMTP id u16-20020a170902e5d000b001963f5ab4f9mr18941514plf.1.1678235520461;
        Tue, 07 Mar 2023 16:32:00 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id a16-20020a170902b59000b00195f242d0a0sm8872788pls.194.2023.03.07.16.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 16:32:00 -0800 (PST)
Message-ID: <2cd7c118-5a6a-0a21-5e08-58ece4fe56c2@kernel.dk>
Date:   Tue, 7 Mar 2023 17:31:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET for-next 0/2] Make pipe honor IOCB_NOWAIT
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        brauner@kernel.org
References: <20230307154533.11164-1-axboe@kernel.dk>
 <20230308001929.GS2825702@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230308001929.GS2825702@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/7/23 5:19 PM, Dave Chinner wrote:
> On Tue, Mar 07, 2023 at 08:45:31AM -0700, Jens Axboe wrote:
>> Hi,
>>
>> File types that implement read_iter/write_iter should check for
>> IOCB_NOWAIT
> 
> Since when? If so, what's the point of setting FMODE_NOWAIT when the
> struct file is opened to indicate the file has comprehensive
> IOCB_NOWAIT support in the underlying IO path?

Guess I missed that FMODE_NOWAIT is supposed to be added for that,
my naive assumption was that the iter based one should check. Which
is a bad sad, but at least there's a flag for it.

But the good news is that I can drop the io_uring patch, just need
to revise the pipe patch. I'll send a v2.

-- 
Jens Axboe


