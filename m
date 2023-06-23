Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D9473BEAD
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 21:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjFWTHS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 15:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjFWTHS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 15:07:18 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B222118
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 12:07:15 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b5466bc5f8so1511525ad.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 12:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687547234; x=1690139234;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kSRg3J1cqrZTpzcAkm63rvLXKNrw6D5izoIw4Cd3kSs=;
        b=3AGrsZoQ0oFdsKRtVJrn82H6AXooaiDBU93PV9ls59tReYrRXG+5NopmZy/GqOpKzX
         0GkiZWmeuA2Mhd44OY3diT77K28cSwTTBOCsBlK1o7AhLlZ1I0p4fDCkaX2Evq+YfcKy
         i7+kiW5OJWYyg7mxwFi01Jw+l5jeCURVNWguv/kJsoMGBMjeaRAAGfsh+JLMJ2PYUqUQ
         sF8WjkqYgmXC1TOo/qVChWWJT84/vkEFXKtk/F9l7x0sW7d6cwoevpgB8V2Uhv3uSOu3
         lbt7gmN9RSfhZbGzDHil6yh0hySoSdpSyPctOhXBnLPJ3j4dOEAQCpIvot2b40oTrlbC
         8B1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687547234; x=1690139234;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kSRg3J1cqrZTpzcAkm63rvLXKNrw6D5izoIw4Cd3kSs=;
        b=Xk4MFWn4f15reHtUBmKhv9GoG0jRgl8Dgurnme1MoVPV5KoYwEt4Yh/zp2cGWdemdK
         +oQztN3SxupEYYE54nwwu76SMiFnLmmw+rm13caYwsMbDGr7FwW814ec1aKEZ4+cGUYn
         nxg+BHCQESHHNYq8YAwO6NWV9wid+dJ5x/524LEiK+ecGSq7Zhu4WvRsX4ARvoUua6fI
         69EH1xZaefntL8pB7HrYT/GSBeDAS9c9HoyCMX7mXNkMyGdIsVSfgHUC0uCTdjgvLXeQ
         wzfATj8DShNly2raxNOcCvz4mW7WHExk8njL6jDfBTBupMbb5bJEgXlUlC0gjjVfGQ8T
         hxAQ==
X-Gm-Message-State: AC+VfDzIxZcIOvvCXCA+42EB/bgf/iILIUAYVxBlqvOHCor6ZmC7UILi
        46sfHYMPzlVu0JFscoWO9EJPwy9shi4VxpmIgz4=
X-Google-Smtp-Source: ACHHUZ7T5+JSHTPWM8bgYAOARHDVnKsh2BSpATuzuPVx1zmGybq+NrYHH06Tz1iC6wJmp/L5glLBuQ==
X-Received: by 2002:a17:902:d489:b0:1ae:4567:2737 with SMTP id c9-20020a170902d48900b001ae45672737mr27320104plg.2.1687547234511;
        Fri, 23 Jun 2023 12:07:14 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i11-20020a17090332cb00b001b03b7f8adfsm7555177plr.246.2023.06.23.12.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 12:07:13 -0700 (PDT)
Message-ID: <93ab1214-2415-1059-633e-b95b299287a3@kernel.dk>
Date:   Fri, 23 Jun 2023 13:07:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 5/6] io_uring: add support for futex wake and wait
Content-Language: en-US
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20230609183125.673140-1-axboe@kernel.dk>
 <20230609183125.673140-6-axboe@kernel.dk>
 <20230623190418.zx2x536uy7q5mtag@awork3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230623190418.zx2x536uy7q5mtag@awork3.anarazel.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/23 1:04?PM, Andres Freund wrote:
> Hi,
> 
> I'd been chatting with Jens about this, so obviously I'm interested in the
> feature...
> 
> On 2023-06-09 12:31:24 -0600, Jens Axboe wrote:
>> Add support for FUTEX_WAKE/WAIT primitives.
>>
>> IORING_OP_FUTEX_WAKE is mix of FUTEX_WAKE and FUTEX_WAKE_BITSET, as
>> it does support passing in a bitset.
>>
>> Similary, IORING_OP_FUTEX_WAIT is a mix of FUTEX_WAIT and
>> FUTEX_WAIT_BITSET.
> 
> One thing I was wondering about is what happens when there are multiple
> OP_FUTEX_WAITs queued for the same futex, and that futex gets woken up. I
> don't really have an opinion about what would be best, just that it'd be
> helpful to specify the behaviour.

Not sure I follow the question, can you elaborate?

If you have N futex waits on the same futex and someone does a wait
(with wakenum >= N), then they'd all wake and post a CQE. If less are
woken because the caller asked for less than N, than that number should
be woken.

IOW, should have the same semantics as "normal" futex waits.

Or maybe I'm totally missing what is being asked here...

-- 
Jens Axboe

