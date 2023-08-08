Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281B1774D2B
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 23:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjHHVlJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 17:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjHHVlJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 17:41:09 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48AD10C
        for <io-uring@vger.kernel.org>; Tue,  8 Aug 2023 14:41:07 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1bba9539a23so12595965ad.1
        for <io-uring@vger.kernel.org>; Tue, 08 Aug 2023 14:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691530867; x=1692135667;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mmMquhVxfqQkr8FeSl+UScb8me8odKvzqPydznJKbHA=;
        b=hSwJfFFQarpgCbUOJ8QP4kWkSz2TMZ8+bcSDjw5pL7eKOY8XZd297ECoAjV5ahEs5v
         XSib/SP1pktC+M/PKGlUFlLzvlnxEjxQi/cll/QdtWbeoSFTVc4b51e7skzkRevpg9PA
         Dk1TLj0Od2U9TH6tFmQzBA1YJ4U+WV8KVrHOI+OpWeGmfg0EezQLAaB3u5dJVjLsWl2s
         JF3Ku8tIsDG0TYiLiCzHMiq7Bk0uPgaFHYZXT/J6snPmotNoYjXSmeTDBqAMEvMGtrTE
         gPQVTZQtWUMrRuC2LVMrOvQsjDFf6vEvEfTudu0NCemIg8fkgCtvevysfYY20Bd0w/Ij
         M73g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691530867; x=1692135667;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mmMquhVxfqQkr8FeSl+UScb8me8odKvzqPydznJKbHA=;
        b=LTOqKplGFZ0rTegS87xEBh7O4bd4cxOCC2526awxZ3Eu3wSWKemOLVO6g0U8uUMSEO
         2uIfT61fYhIum7SR66V0E5ZzZC0/MMsLUK0TmsR9zKo/4NtJI880U8cEdqOoWmJSa0EC
         fzflVJHGTK0SSi4HRLxdC7j/2iyx0WlVAZ+eTOofMRVfD91t3hakUXYLxB4Dr4APVJMv
         NYCmxVtAdCuZ+puo9lUkRkG6DHlZmxa82SBuzJlEBcKnSmC8OGeShHo1Q3Zb3bavyjqe
         /4Q/wtGwd1IhYeuDXDsK2/ObnG7MrRZtmYzchhsIpqkMi/oSFGvDCy/8S0JWWXSLLMz9
         unOg==
X-Gm-Message-State: AOJu0YzYMHv8IsJcy8g6/0LAXyxF+thexFumhS6LfKjzSIi+EIHqzVHS
        CQSObg1KKo1AtwoKtNPedn0XzQ==
X-Google-Smtp-Source: AGHT+IHGq8TQrQg8Nfhn9A+oBWGtt5BlIB/JcFN8y/DVUn7XRh/zPzIP3r5uek0AhBfIV2cv9vnJ0w==
X-Received: by 2002:a17:902:e884:b0:1bc:496c:8edb with SMTP id w4-20020a170902e88400b001bc496c8edbmr1085461plg.0.1691530867301;
        Tue, 08 Aug 2023 14:41:07 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p21-20020a1709028a9500b001bb0b1a93dfsm9452461plo.126.2023.08.08.14.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 14:41:06 -0700 (PDT)
Message-ID: <65911cc1-5b3f-ff5f-fe07-2f5c7a9c3533@kernel.dk>
Date:   Tue, 8 Aug 2023 15:41:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: FYI, fsnotify contention with aio and io_uring.
Content-Language: en-US
To:     Jeff Moyer <jmoyer@redhat.com>, Pierre Labat <plabat@micron.com>
Cc:     "'io-uring@vger.kernel.org'" <io-uring@vger.kernel.org>
References: <SJ0PR08MB6494F5A32B7C60A5AD8B33C2AB09A@SJ0PR08MB6494.namprd08.prod.outlook.com>
 <x49pm3y4nq5.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <x49pm3y4nq5.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/7/23 2:11?PM, Jeff Moyer wrote:
> Hi, Pierre,
> 
> Pierre Labat <plabat@micron.com> writes:
> 
>> Hi,
>>
>> This is FYI, may be you already knows about that, but in case you don't....
>>
>> I was pushing the limit of the number of nvme read IOPS, the FIO + the
>> Linux OS can handle. For that, I have something special under the
>> Linux nvme driver. As a consequence I am not limited by whatever the
>> NVME SSD max IOPS or IO latency would be.
>>
>> As I cranked the number of system cores and FIO jobs doing direct 4k
>> random read on /dev/nvme0n1, I hit a wall. The IOPS scaling slows
>> (less than linear) and around 15 FIO jobs on 15 core threads, the
>> overall IOPS, in fact, goes down as I add more FIO jobs. For example
>> on a system with 24 cores/48 threads, when I goes beyond 15 FIO jobs,
>> the overall IOPS starts to go down.
>>
>> This happens the same for io_uring and aio. Was using kernel version 6.3.9. Using one namespace (/dev/nvme0n1).
> 
> [snip]
> 
>> As you can see 76% of the cpu on the box is sucked up by
>> lockref_get_not_zero() and lockref_put_return().  Looking at the code,
>> there is contention when IO_uring call fsnotify_access().
> 
> Is there a FAN_MODIFY fsnotify watch set on /dev?  If so, it might be a
> good idea to find out what set it and why.

This would be my guess too, some distros do seem to do that. The
notification bits scale horribly, nobody should use it for anything high
performance...

-- 
Jens Axboe

