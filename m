Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BD25FA9C5
	for <lists+io-uring@lfdr.de>; Tue, 11 Oct 2022 03:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiJKBQL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 21:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJKBQK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 21:16:10 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66032247;
        Mon, 10 Oct 2022 18:16:09 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id r8-20020a1c4408000000b003c47d5fd475so4232273wma.3;
        Mon, 10 Oct 2022 18:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3AwZXEQc1HX1QAkeMcHJ1HjHFofr6EUJRz1nuHhC/Gc=;
        b=NQd0huQeA1j1GF5IOWNY+F0IjjNmOCtS7a6GGpJRt2ufQP9GYgFZwMltt8f8RXfCmY
         LKMjuf+Qjo6KV+l49y+XI8nVsS32bRWQvjZ7iOR2EbA/fG+Z5xYmvLhHH8iHPza/GGq/
         5AXvVLyKAcLn7DCZkbCtDXr9JrMQ1EcDOyJmqmlHLa2F81GSUHrae1x5C1p/dBkuGHrb
         8H8YD722dvPsS2VgtbAbLmNMOwMcquL1uSkguCxEf0S2o2rO1pkguWEXA7sXcorasW4V
         p7dzqkAsteN4Fqs+q0v71M5O0QThY+Im5y1CV+oYHklTqB3/Pg3pojfkzegBCxgYWt5K
         cUnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3AwZXEQc1HX1QAkeMcHJ1HjHFofr6EUJRz1nuHhC/Gc=;
        b=b/piTThkK8C4V2rsUyMm6EWwcWkDSj9uiR7vGO7ByjZpLQZffuECCamx1h8Ha7Orde
         rESA2Gz4FvxV8N0t0n46YCR20b0fE7aWjvlkdC4iYPW4B5HmD16f8dwy2itSNGDV3Bdm
         X/bBppVcvLMsc7wPklierEKk4msCc8oiMLoQqKaqurqJif4OPL6kOKAJpROkSd9c4o1a
         /Q2qOIRyYwYYysa7PY3tuPSdO2MENfRoGGp2IC1ppCmaeIfelQNTCATMTDyEzzx7mht5
         np4k99sgCngO+Lu2fs08Ek8Zt9Zur+N+f0Y7RvJhFVIebYSQ60KJ4g39tRv5UlNThxc2
         1e9w==
X-Gm-Message-State: ACrzQf0i+QEuOw8iihUyBizqIm1+2VPCzGUz3luS+L9y2AHrNq5JQNFO
        AoTOkHOgEHDgJrK7xFDca3aPtULQfpg=
X-Google-Smtp-Source: AMsMyM6QTd3IIXGajJQvWH3DY10HYMC7Rml3EMzL3CxFQscEKXzLs4Z4Wyw0ICOhGeG1jd5v27THUQ==
X-Received: by 2002:a7b:c4d9:0:b0:3c4:e77f:b991 with SMTP id g25-20020a7bc4d9000000b003c4e77fb991mr9749771wmk.104.1665450967859;
        Mon, 10 Oct 2022 18:16:07 -0700 (PDT)
Received: from [192.168.8.100] (94.196.221.180.threembb.co.uk. [94.196.221.180])
        by smtp.gmail.com with ESMTPSA id ca1-20020a056000088100b0022e344a63c7sm10234966wrb.92.2022.10.10.18.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 18:16:07 -0700 (PDT)
Message-ID: <8e45c8ee-fe38-75a9-04f4-cfa2d54baf88@gmail.com>
Date:   Tue, 11 Oct 2022 02:10:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [regression, v6.0-rc0, io-uring?] filesystem freeze hangs on
 sb_wait_write()
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>, viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <20221010050319.GC2703033@dread.disaster.area>
 <20221011004025.GE2703033@dread.disaster.area>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221011004025.GE2703033@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/11/22 01:40, Dave Chinner wrote:
[...]
> I note that there are changes to the the io_uring IO path and write
> IO end accounting in the io_uring stack that was merged, and there
> was no doubt about the success/failure of the reproducer at each
> step. Hence I think the bisect is good, and the problem is someone
> in the io-uring changes.
> 
> Jens, over to you.
> 
> The reproducer - generic/068 - is 100% reliable here, io_uring is
> being exercised by fsstress in the background whilst the filesystem
> is being frozen and thawed repeatedly. Some path in the io-uring
> code has an unbalanced sb_start_write()/sb_end_write() pair by the
> look of it....

A quick guess, it's probably

b000145e99078 ("io_uring/rw: defer fsnotify calls to task context")

 From a quick look, it removes  kiocb_end_write() -> sb_end_write()
from kiocb_done(), which is a kind of buffered rw completion path.

-- 
Pavel Begunkov
