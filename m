Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D3751C14E
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 15:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380076AbiEENy1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 09:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380199AbiEENyS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 09:54:18 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D311AF1D
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:50:33 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k190so1005834pgd.6
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 06:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JN+xXTcXNI1SyQdyI2kigTtC7Mc8qGqky6/c8LUyqPI=;
        b=sMX1x0FOSqCQ5fwTbC8sa8yqgSZw+NCBuTwq89nRJYLp5Ok8YnjnJGRR/0JLOFvlwF
         eROU8L2DNxS/AN9N+mqjG2KtLVSopEEutSsa103FBGKQyy47DiJlwQH+CbozkbGytSS4
         WGjQXhfzzIXV1JerUSQrfUBl8OpjVw/OVVNPd1XW4v9m1UY+Sq3kAVgEEm7cIUX09CVx
         ZStA14QfTkamZP46vRI2i25gze3aZON7pZio/gFAmYyTmEijfDxcVgYYclGusX2yEw15
         WKTG7UvFHuOMt+cBudo1CGI8X8gxmH4ebwgKqAnO5aulHWhZQblALx69RqWUDSfy0gHi
         7J9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JN+xXTcXNI1SyQdyI2kigTtC7Mc8qGqky6/c8LUyqPI=;
        b=JImjsFPbsPvNNM0/guAa8Gjkq5SOQQ4MqBVbI3Eb/wlWGrQU94cQqRnmpB5pjdSac5
         N4IEJHR8ySwfg5fRUwIuamzTfJUOj7QLwWW7k2ybAVjz1kMsIlojSTNNhR9u2nJAWv1D
         nhZIe9upT2ik0ROcqS6jxub2VlI3FQUwt0kyBWxQ/fafdimmQi2iZRiVSY8c0N9kEc4P
         RvHIZ4KHMMKUavJsYQuhwSLl5/QS3HqFgZ0zD9GfjwqCuj790L0Ll8rfHBCgUrQwXTdN
         SigutuoqciMirOcOyQHTteyEaHZf7RORWh/jW4X0qnKkgwoSbXhaVnge82UdBQDg8khZ
         Xjig==
X-Gm-Message-State: AOAM532LU6mvsPmrBNSg8YPpmNjwRrhQe/5hfktH/xs5n+C9e8gpfszh
        yKxb/qgJREWBOMQOt526q2qPAg==
X-Google-Smtp-Source: ABdhPJwZt576fLb0sJ0OdV9w4RTCCVR1xxIPiA25Xfu7jLkSBnypVvl97pddAxh4FVWV1jKdHpcXCw==
X-Received: by 2002:a05:6a00:1352:b0:510:4c0e:d230 with SMTP id k18-20020a056a00135200b005104c0ed230mr6545078pfu.79.1651758633359;
        Thu, 05 May 2022 06:50:33 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x17-20020a170902821100b0015eab1b097dsm1567880pln.22.2022.05.05.06.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 06:50:33 -0700 (PDT)
Message-ID: <f45c89db-0fed-2c88-e314-71dbda74b4a7@kernel.dk>
Date:   Thu, 5 May 2022 07:50:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru on
 char-device.
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b@epcas5p2.samsung.com>
 <20220505060616.803816-5-joshi.k@samsung.com>
 <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk>
 <20220505134256.GA13109@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220505134256.GA13109@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/22 7:42 AM, Christoph Hellwig wrote:
> On Thu, May 05, 2022 at 07:38:31AM -0600, Jens Axboe wrote:
>>> +	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(cmd->addr),
>>> +			cmd->data_len, nvme_to_user_ptr(cmd->metadata),
>>> +			cmd->metadata_len, 0, cmd->timeout_ms ?
>>> +			msecs_to_jiffies(cmd->timeout_ms) : 0, 0, rq_flags,
>>> +			blk_flags);
>>
>> You need to be careful with reading/re-reading the shared memory. For
>> example, you do:
> 
> Uh, yes.  With ioucmd->cmd pointing to the user space mapped SQ
> we need to be very careful here.  To the point where I'd almost prfer
> to memcpy it out first, altough there might be performance implications.

Most of it is just copied individually to the on-stack command, so that
part is fine just with READ_ONCE(). Things like timeout don't matter too
much I think, but addr/metadata/metadata_len definitely should be
ensured stable and read/verified just once.

IOW, I don't think we need the full on-stack copy, as it's just a few
items that are currently an issue. But let's see what the new iteration
looks like of that patch. Maybe we can just shove nvme_uring_cmd
metadata_len and data_len at the end of that struct and make it
identical to nvme_command_command and just make that the memcpy, then
use the copy going forward?

-- 
Jens Axboe

