Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE2251DCCF
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 18:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443379AbiEFQHq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 12:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443368AbiEFQHp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 12:07:45 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07D06D973
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 09:04:00 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso7245790pjj.2
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 09:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0uUTR9z98utauBqj+KmjxPc4gxj1gteGLGPvj7webUo=;
        b=J4IvR3uUluzPVJPujF5iGP7CnGMFRxS4C+JdTXPQeYnSh3W80C91i9wOSOsN7J/kGv
         bkX4yeeMmFTGNs2RiGiQ7rLi5NpfOmOCdMNV59m1D1X568tUCbKlXVN6Fc7MsWjfQrHc
         vbCNlfjkVHr8WjXmvxtOwRxpyh6SKRcrhQy/BW+7bcTZ5Fw72tYvnAXXD4DeN8+qaeSj
         /iU3XP4qgOgPzLD31X97EYpS874M9TrJZR4vF8sNIGilZSCOmMYryQJ4IP1aabvQ+V7H
         J5E/pxWQRHLJp0OCqreWvFF7K0+tNgFlQpHpHM5D88RoTNN6ZL072kF2+f0Xrue43ues
         1hrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0uUTR9z98utauBqj+KmjxPc4gxj1gteGLGPvj7webUo=;
        b=nqUF5ozlE5P5XxEq6PNyqU2KNTFfSIBg5OT+wD21wt2gW5k5ZFO6BQ1Hzy0MmG4x5g
         rZDUEnP1Twms1fD6FiMixlRLzzPK2dng1UyMnRPyNt0g3Cziq6cUWiX4Vk7RZcYC/Qnn
         f491ixvPuJ+RUqo6H5cSu+t1lT5p8R6YMomXgyanQdDbFS0dE2ZkBkwS9lg6Xo//ctzp
         qOxfRM1huJYAJsc8aSpeB3Mu6S3SfzEudy1iRrrFSOWQ32fPYTStFtQh5ipBXhjtAjHr
         5tWwGfisu/NMgCJTnhGabKqwJR3m2yuvxrbLTViIX3CF7x5fNZyLDy05seY2hbk2W//A
         3ueQ==
X-Gm-Message-State: AOAM530Tgnz4fWpxRx0TneAWJIuc2t3Ur1f+sdmEwbUii0safHGvnZOL
        lOjQfstfwyHnagf1yg6ivGUdnA==
X-Google-Smtp-Source: ABdhPJzaRrmoWWC0zULoNyAQrgE1JZUQBrth1vEB2/dmiHbMGv30IIErYnu0FnK0crc6nCQ0X0BZdw==
X-Received: by 2002:a17:903:22c1:b0:15e:c3b2:d632 with SMTP id y1-20020a17090322c100b0015ec3b2d632mr4462885plg.0.1651853040377;
        Fri, 06 May 2022 09:04:00 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 6-20020a631546000000b003c14af50628sm3419968pgv.64.2022.05.06.09.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 09:03:59 -0700 (PDT)
Message-ID: <05e99d9e-4c66-6d7c-604c-1e52d8d0b5b2@kernel.dk>
Date:   Fri, 6 May 2022 10:03:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 0/5] fast poll multishot mode
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <b4d23f42-36f4-353a-1f44-c12178f0a2b3@gmail.com>
 <5ce3d6c7-42f9-28c3-0800-4da399adaaea@kernel.dk>
 <3f940dad-73ce-4ea6-dc76-f877c64dbb9a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3f940dad-73ce-4ea6-dc76-f877c64dbb9a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 10:01 AM, Pavel Begunkov wrote:
> On 5/6/22 15:18, Jens Axboe wrote:
>> On 5/6/22 1:36 AM, Hao Xu wrote:
>>> Hi All,
>>> I actually had a question about the current poll code, from the code it
>>> seems when we cancel a poll-like request, it will ignore the existing
>>> events and just raise a -ECANCELED cqe though I haven't tested it. Is
>>> this by design or am I missing something?
>>
>> That's by design, but honestly I don't think anyone considered the case
>> where it's being canceled but has events already. For that case, I think
>> we should follow the usual logic of only returning an error (canceled)
>> if we don't have events, if we have events just return them. For
>> multi-shot, obviously also terminate, but same logic there.
> 
> Why would we care? It's inherently racy in any case and any
> user not handling this is already screwed.

We don't really need to care, but the normal logic is "return error if
we have no result, return result otherwise". No reason this should be
any different imho, it's not really a correctness thing.

-- 
Jens Axboe

