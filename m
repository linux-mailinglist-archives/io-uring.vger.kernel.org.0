Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63DD5638FC
	for <lists+io-uring@lfdr.de>; Fri,  1 Jul 2022 20:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiGASOq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jul 2022 14:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiGASOp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Jul 2022 14:14:45 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9FF140B0
        for <io-uring@vger.kernel.org>; Fri,  1 Jul 2022 11:14:43 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d17so3123836pfq.9
        for <io-uring@vger.kernel.org>; Fri, 01 Jul 2022 11:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+2cjOm2iV0K6Fh37ckIuAiSPC7PAkAib0BkzJQTS0+s=;
        b=37Z/LMNRq6UGadaXxmJOSRipY4rroGzOo3QgmZRy2ucWwXpMiTrzuNd7EEp6pNoJax
         HTUCYoauubMAVWuf0R7SarFV5P4ZeO6qr8rm6ZPPt7kXiv0Hc4gW6JPonc6R2CUXKDW3
         hia5chKFOpdKMVjQ4lt/qFB8M+n0QeL5Fd2+/U+gLUZS5HKYBcVwkdM+A9swXyCWtD8P
         WQYLl3mtwqddkRd2iTE5dmwr07p3swYcSVXbbnRgv8fhtwiVdJYUgQRJ5zfW1uHMtr7D
         hgtuffkm4EVCOvEV1wUjpqBpUZxmxHoFjlagIe2taAsHlfCPaj6Z/Yr6V24EwTXdr2e1
         phPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+2cjOm2iV0K6Fh37ckIuAiSPC7PAkAib0BkzJQTS0+s=;
        b=xB0hHWxy7oDXs6FMrxFOgS3rQgeAM4fWGOBw76BJS5ZrLBWLSDNxRYHrjmct7EX39c
         WhtEKFp4grC4U/YFyfsOviGSVu7E24KWHaKsvLM5ktysXLRuFcgaWlrlXkxcJpPzX8lq
         erbuiQpV0GsuQD/ti0GjimzsmZbrmYGxTaWWLeSWaTNeYqpUQQ2OkXhSUk/CCohc0EMF
         nv64VqKk3Pvufu6rpOiY+bWDT1XE411FFbj4hx8Yu20X+/gV+rs/CdHUFo7VBqRRjjaO
         C9rcMWr4ykRf5xHn0Z7JrH3GuxzF7kVoGULyXHauFm4eam1oT6g+s2cjm5szWJ572yAi
         v5hA==
X-Gm-Message-State: AJIora+YKaKYXyPxST7f1tpBLqBCjAedaxEAA3c+fp8OTyGgSHK8l2tn
        iG6CBYoD6RkGCVNho43Ik3FdLg==
X-Google-Smtp-Source: AGRyM1tgpHo+10wcI7TOf9FXHzT5lkC3dyL+mkSzScOZoo+gMDXmGOW87BcbBjT7laY527aiFmqxcQ==
X-Received: by 2002:a05:6a00:26cf:b0:4f6:fc52:7b6a with SMTP id p15-20020a056a0026cf00b004f6fc527b6amr21371577pfw.39.1656699283240;
        Fri, 01 Jul 2022 11:14:43 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902680500b0015e8d4eb20dsm16065865plk.87.2022.07.01.11.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 11:14:42 -0700 (PDT)
Message-ID: <47dd9e6a-4e08-e562-12ff-5450fc42da77@kernel.dk>
Date:   Fri, 1 Jul 2022 12:14:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v7 15/15] xfs: Add async buffered write support
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-16-shr@fb.com> <Yr56ci/IZmN0S9J6@ZenIV>
 <0a75a0c4-e2e5-b403-27bc-e43872fecdc1@kernel.dk>
 <ef7c1154-b5ba-4017-f9fd-dea936a837fc@kernel.dk>
 <ca60a7dc-b16d-d8ce-f56c-547b449da8c9@kernel.dk> <Yr83aD0yuEwvJ7tL@magnolia>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Yr83aD0yuEwvJ7tL@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/1/22 12:05 PM, Darrick J. Wong wrote:
> On Fri, Jul 01, 2022 at 08:38:07AM -0600, Jens Axboe wrote:
>> On 7/1/22 8:30 AM, Jens Axboe wrote:
>>> On 7/1/22 8:19 AM, Jens Axboe wrote:
>>>> On 6/30/22 10:39 PM, Al Viro wrote:
>>>>> On Wed, Jun 01, 2022 at 02:01:41PM -0700, Stefan Roesch wrote:
>>>>>> This adds the async buffered write support to XFS. For async buffered
>>>>>> write requests, the request will return -EAGAIN if the ilock cannot be
>>>>>> obtained immediately.
>>>>>
>>>>> breaks generic/471...
>>>>
>>>> That test case is odd, because it makes some weird assumptions about
>>>> what RWF_NOWAIT means. Most notably that it makes it mean if we should
>>>> instantiate blocks or not. Where did those assumed semantics come from?
>>>> On the read side, we have clearly documented that it should "not wait
>>>> for data which is not immediately available".
>>>>
>>>> Now it is possible that we're returning a spurious -EAGAIN here when we
>>>> should not be. And that would be a bug imho. I'll dig in and see what's
>>>> going on.
>>>
>>> This is the timestamp update that needs doing which will now return
>>> -EAGAIN if IOCB_NOWAIT is set as it may block.
>>>
>>> I do wonder if we should just allow inode time updates with IOCB_NOWAIT,
>>> even on the io_uring side. Either that, or passed in RWF_NOWAIT
>>> semantics don't map completely to internal IOCB_NOWAIT semantics. At
>>> least in terms of what generic/471 is doing, but I'm not sure who came
>>> up with that and if it's established semantics or just some made up ones
>>> from whomever wrote that test. I don't think they make any sense, to be
>>> honest.
>>
>> Further support that generic/471 is just randomly made up semantics,
>> it needs to special case btrfs with nocow or you'd get -EAGAIN anyway
>> for that test.
>>
>> And it's relying on some random timing to see if this works. I really
>> think that test case is just hot garbage, and doesn't test anything
>> meaningful.
> 
> <shrug> I had thought that NOWAIT means "don't wait for *any*thing",
> which would include timestamp updates... but then I've never been all
> that clear on what specifically NOWAIT will and won't wait for. :/

Agree, at least the read semantics (kind of) make sense, but the ones
seemingly made up by generic/471 don't seem to make any sense at all.

-- 
Jens Axboe

