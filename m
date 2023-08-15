Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7287077D558
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 23:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbjHOVpY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 17:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240397AbjHOVpI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 17:45:08 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887F31FC3
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 14:45:07 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bdb3ecd20dso7465425ad.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 14:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692135907; x=1692740707;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=es2Q+G7yN/d3O8VlPzekGvPoaVmjZxuf6WsQpCWyVFY=;
        b=gSJTHxRCYXNTQFTft7D5EX+GSdHMArigXTGCRUwdEzQUlOpOVG02gg1H0fk1jkcvIw
         QlFYVEoHEA8rAdim7R7lEOdPjisc2uwzD1xW2pYnGo4BDXnwE5c/YJ8+51LfmY2NSWK+
         NZ2LDYyMEWVi3avNQM2JI9zyO7MtrGJNTDBK54MUG7CBmPa+8vd5UkfSYEK97krn31Na
         z6x8daasS4LmFFXP2MhSpDR0FbPAX7xE4aFOutO+TSjRyOG4aLb/dxHKF5gGjbiF70UO
         W0R07E+SbHyMGbPZhqF9jZ+9b5EIlr/FH5Zup3wfYQUcXUhERD9UFC7Cpzj1u8rdivJh
         IB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692135907; x=1692740707;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=es2Q+G7yN/d3O8VlPzekGvPoaVmjZxuf6WsQpCWyVFY=;
        b=M5H5SganSn3QQR7VFv9O36waYG28fEM0HPfHmM5e9p0k78Cu3vO5yhmtBqIBgPQ+yp
         8EJlMBowESCZVJ3qQoTG07w6Te8+ARPOE9JfK6ZAR4x+v59Zrz1j2apq9L8TsVEVW0hb
         1Qa3g9vN2uF8zhIeZ2MQt7FBbpwwb/CKZdrfIHp1SvAnEj+iERAxBsuXqGHXTnssDn86
         /KzZTCeHCYQupHGqtAEvzlrReaPMU3qgHKOm48z2ZyJnJTN8glG3TGedv6ele7kA3s88
         FCbdp5/NyEA2Sa87ELjsWg0Jp2PqK2SzZrgCfuR41YKaC/HhGiQq4eSWFTkcgQuwdRbA
         k4Yg==
X-Gm-Message-State: AOJu0YwQIPkd0TSKK9t7Z5cwvi7+6aEjUnPcOCMpOr0nD2QA3ch83xfN
        mmr1lwzQcGplntTV/bg/yt6Tdg==
X-Google-Smtp-Source: AGHT+IGi5A/esSisN7jtJ0WzOEmCTosKLnOIo0DqxOjeUyB4CrgBRwfROEQvxIk7+QBOgVrbMgn7eg==
X-Received: by 2002:a17:902:e84f:b0:1bb:c2b1:9c19 with SMTP id t15-20020a170902e84f00b001bbc2b19c19mr85118plg.6.1692135906930;
        Tue, 15 Aug 2023 14:45:06 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n12-20020a170903110c00b001bb97e51ad5sm11505549plh.99.2023.08.15.14.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 14:45:06 -0700 (PDT)
Message-ID: <8077359c-cb59-4964-8bde-f673e882dc12@kernel.dk>
Date:   Tue, 15 Aug 2023 15:45:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: move to using private ring references
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20230811171242.222550-1-axboe@kernel.dk>
 <20230811171242.222550-2-axboe@kernel.dk>
 <1b948d2e-c34f-6c12-cd9c-de9d42cb0fae@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1b948d2e-c34f-6c12-cd9c-de9d42cb0fae@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/23 11:45 AM, Pavel Begunkov wrote:
> On 8/11/23 18:12, Jens Axboe wrote:
>> io_uring currently uses percpu refcounts for the ring reference. This
>> works fine, but exiting a ring requires an RCU grace period to lapse
>> and this slows down ring exit quite a lot.
>>
>> Add a basic per-cpu counter for our references instead, and use that.
>> This is in preparation for doing a sync wait on on any request (notably
>> file) references on ring exit. As we're going to be waiting on ctx refs
>> going away as well with that, the RCU grace period wait becomes a
>> noticeable slowdown.
> 
> How does it work?
> 
> - What prevents io_ring_ref_maybe_done() from miscalculating and either
> 1) firing while there are refs or
> 2) not triggering when we put down all refs?
> E.g. percpu_ref relies on atomic counting after switching from
> percpu mode.

I'm open to critique of it, do you have any specific worries? The
counters are per-cpu, and whenever the REF_DEAD_BIT is set, we sum on
that drop. We should not be grabbing references post that, and any drop
will just sum the counters. 

> - What contexts it can be used from? Task context only? I'll argue we
> want to use it in [soft]irq for likes of *task_work_add().

We don't manipulate ctx refs from non-task context right now, or from
hard/soft IRQ. On the task_work side, the request already has a
reference to the ctx. Not sure why you'd want to add more. In any case,
I prefer not to deal with hypotheticals, just the code we have now.

-- 
Jens Axboe

