Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58A57CC5D9
	for <lists+io-uring@lfdr.de>; Tue, 17 Oct 2023 16:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343637AbjJQOYW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Oct 2023 10:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343820AbjJQOYU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Oct 2023 10:24:20 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD77AB0
        for <io-uring@vger.kernel.org>; Tue, 17 Oct 2023 07:24:18 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-79fc0068cb5so12551139f.1
        for <io-uring@vger.kernel.org>; Tue, 17 Oct 2023 07:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697552658; x=1698157458; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ifsEnrEhLRsBYJTMzOjrmglnTHGPXtrt774ROqlamds=;
        b=ncPjfrFbCnijk1FR9RyjTaoRIy81fcvqe93VitcKD92CA0rbpf73N9wG+x7ftyu+zG
         UdR3LWDiVd/nVNxG73DnTfvHPnVJySDzQdmMDUm0ZErK5OjQnuYN5Zr969q3eToxrN4O
         eOsN8PdyVBrxjN5sFmXM3Dx2FNlPO1Te3BFVh1mNsvnduhl58Jyi3FtmELHLli2uaTkh
         Lv1BKHLeudCZ1ym0EjD3h2NIBOwUDOhlc5A5xeeE3sqmlDuTGjfpCzB96nsPKRylfGc0
         d8/V5jfPnvQ6SVa5NFJ8bwj6TVYMZGEbnIyprD6F1tCVbh3OUEcWec97sY5ews/MAPCG
         GA5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697552658; x=1698157458;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ifsEnrEhLRsBYJTMzOjrmglnTHGPXtrt774ROqlamds=;
        b=odCBo3zFwjWiaevHMtIASv8IdfLgqq38Yxy7J1hkZFr3y7u4BAyuayZIQbNMx883/n
         Uknho03cuYFhmZT7HAKRD/wgOTE5KP4+ntDBYQVb2WkDsi+qctPeY8Asj+QVXmfjokrU
         8rNePk4t1fXAnfjyiJjROhG17XrLEhiqxdaSbm+rbnIR4dGD70DIHsuLzXRTVSbBmpRq
         rk//3DcIMBkkP7bLjYhd+u4vLaAQAPWiW0cxiMKb2lJHF0RheIOa4WlqK5n5ssO6zLJn
         Gs+tZNRK+EzB/IcYc8nAnNCh09HRwdKVGQMuNNeKdwgC/LYMteq+ty4DUEUnM7mhak/l
         baNw==
X-Gm-Message-State: AOJu0YyV5pCaIDE2gpQukV0+YilHyfUbo5IIhh4Ixu5v2e6Fh0MzRxrm
        jfwdnDPbDIz1sCej3bkLZSBvNCexgMCmFkD/8x0PNA==
X-Google-Smtp-Source: AGHT+IEanVaXvI1ngVj+eMwlWqWYPuy0DEM0I8/w3/V4vnsmC0QIhNbHqM+3AMfKrkloNBnNtiH3FQ==
X-Received: by 2002:a5e:9404:0:b0:792:8011:22f with SMTP id q4-20020a5e9404000000b007928011022fmr2503349ioj.0.1697552658139;
        Tue, 17 Oct 2023 07:24:18 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id s15-20020a02c50f000000b0045b4a059a57sm536368jam.44.2023.10.17.07.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 07:24:17 -0700 (PDT)
Message-ID: <8f01c45c-fd13-4f0e-9369-e0fb86739574@kernel.dk>
Date:   Tue, 17 Oct 2023 08:24:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-6.7/io_uring 0/7] ublk: simplify abort with cancelable
 uring_cmd
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20231009093324.957829-1-ming.lei@redhat.com>
 <169750523303.2166768.9866448914806482249.b4-ty@kernel.dk>
 <ZS4U7N0kbH3BLOGA@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZS4U7N0kbH3BLOGA@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/23 11:00 PM, Ming Lei wrote:
> On Mon, Oct 16, 2023 at 07:13:53PM -0600, Jens Axboe wrote:
>>
>> On Mon, 09 Oct 2023 17:33:15 +0800, Ming Lei wrote:
>>> Simplify ublk request & io command aborting handling with the new added
>>> cancelable uring_cmd. With this change, the aborting logic becomes
>>> simpler and more reliable, and it becomes easy to add new feature, such
>>> as relaxing queue/ublk daemon association.
>>>
>>> Pass `blktests ublk` test, and pass lockdep when running `./check ublk`
>>> of blktests.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/7] ublk: don't get ublk device reference in ublk_abort_queue()
>>       commit: a5365f65ea2244fef4d6b5076210b0fc4fe5c104
>> [2/7] ublk: make sure io cmd handled in submitter task context
>>       commit: fad0f2b5c6d8f4622ed09ebfd6c08817abbfa20d
>> [3/7] ublk: move ublk_cancel_dev() out of ub->mutex
>>       commit: 95290eef462aaec33fb6f5f9da541042f9c9a97c
>> [4/7] ublk: rename mm_lock as lock
>>       commit: 9b8ce170c0bc82c50bf0db6187e00d3a601df334
>> [5/7] ublk: quiesce request queue when aborting queue
>>       commit: e4a81fcd73422bdee366c3a076826d92ee8f2669
>> [6/7] ublk: replace monitor with cancelable uring_cmd
>>       commit: 3aa8ac4a0c293fcc1b83c4f1a515b66f1f0123a0
>> [7/7] ublk: simplify aborting request
>>       commit: ac7eb8f9b49c786aace696bcca13a60953ea9b11
> 
> Hi Jens,
> 
> Thanks for pulling this patchset it.
> 
> However, it depends on recent cancelable uring_cmd in for-6.7/io_uring,
> but you pull it in for-6.7/block, which is broken now.

Ah indeed, and this is probably why it didn't get added initially. I'll
sort it out.

-- 
Jens Axboe

