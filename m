Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F79F707233
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 21:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjEQTbR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 15:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjEQTbK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 15:31:10 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A81C2D4C
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:31:02 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-76c6ba5fafaso7459939f.1
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684351862; x=1686943862;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3OHLR70ERErcVWVOIXcQUQzyAztkWXEGKP3uB9D4eFw=;
        b=0QRWMWCG0ozeMGf/GOHaYaYARviZj/cR3DDQVK+yx0cxaiVOauI+uj/hBJh6OtP+W0
         Dx4eh+mq0r/gVuMINr3TU/4rPVjT5qT7njOKjdEVYTPOzhh0+x82N9D3vshpbrtafkfE
         Xu4aXL9+C6MwsavD35QKtGH0TcfuuTMKgS7HYR7sGJJVWUl3K6188LDp6rsDYjzSZz3W
         Kj/ogAToFXcAskZrtMyPGgKcrdw81VFU6auNyqJMFtjl0soO4jUP6HpfcqI140NpYcVm
         xYMnv/RUQ8tvBM1kThkcg9SHQyi+L4M4vb2M9ya2+PfScUiuWZKt39R2iT8IpB9CK/Sd
         UYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684351862; x=1686943862;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3OHLR70ERErcVWVOIXcQUQzyAztkWXEGKP3uB9D4eFw=;
        b=kHGy8+/bO+1sQqbXEGqzhTWU6qRu/zCF7NJ6UPx1juzq0GKklZaglUzOeoVSbzONys
         Q5oRiB3cwHV8kqEcklnhmSR2es5btao0ztVniInorN8cIc2EuIyuWmbya5Ei7BAYRIuC
         OT+NF+psRf/65mYj+60WnrhCgdpPZXJoiQsZS5rGEFLcIowJp8v+xCdrpXd8M5azJMG+
         jq4Cf9LSqd6dogiUG9IBb/1p1jI2Hu0yKmOVPF9T35cuNv/ApHxlImTb9REibO0bwsWy
         +hBGM/bOnquDfDqjNeIWU4Tih5zRjuL8usNU5bXgbRzzd+qobNVwO3qIZi3BNOawtasy
         oaSw==
X-Gm-Message-State: AC+VfDwhD/eGZmhYnV/fRmKI5JvuzCjbTQsCBGLbV3/SyDqNNCrn4SCw
        kQa1u9PgjZgbZOv9ZfJnc7LfCw==
X-Google-Smtp-Source: ACHHUZ78FLRicfxazm65ydU45P11Uw42OT1d6h8VwqAthGiaYjb/pWt8nd4BCq6WD7gnoyRJ6NNHVg==
X-Received: by 2002:a6b:144f:0:b0:770:4bd:34b9 with SMTP id 76-20020a6b144f000000b0077004bd34b9mr1887014iou.2.1684351861763;
        Wed, 17 May 2023 12:31:01 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q3-20020a027b03000000b0041672c963b3sm7422559jac.50.2023.05.17.12.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 12:31:01 -0700 (PDT)
Message-ID: <84e1ce69-d6d5-5509-4665-2d153e294fc8@kernel.dk>
Date:   Wed, 17 May 2023 13:31:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH for-next 2/2] nvme: optimise io_uring passthrough
 completion
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, kbusch@kernel.org, sagi@grimberg.me,
        joshi.k@samsung.com
References: <cover.1684154817.git.asml.silence@gmail.com>
 <ecdfacd0967a22d88b7779e2efd09e040825d0f8.1684154817.git.asml.silence@gmail.com>
 <20230517072314.GC27026@lst.de>
 <9367cc09-c8b4-a56c-a61a-d2c776c05a1c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9367cc09-c8b4-a56c-a61a-d2c776c05a1c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/23 6:32 AM, Pavel Begunkov wrote:
> On 5/17/23 08:23, Christoph Hellwig wrote:
>> On Mon, May 15, 2023 at 01:54:43PM +0100, Pavel Begunkov wrote:
>>> Use IOU_F_TWQ_LAZY_WAKE via iou_cmd_exec_in_task_lazy() for passthrough
>>> commands completion. It further delays the execution of task_work for
>>> DEFER_TASKRUN until there are enough of task_work items queued to meet
>>> the waiting criteria, which reduces the number of wake ups we issue.
>>
>> Why wouldn't you just do that unconditionally for
>> io_uring_cmd_complete_in_task?
> 
> 1) ublk does secondary batching and so may produce multiple cqes,
> that's not supported. I believe Ming sent patches removing it,
> but I'd rather not deal with conflicts for now.

Ming, what's the status of those patches? Looks like we'll end up
with a dependency regardless of the ordering of these. Since these
patches are here now, sanest approach seems to move forward with
this series and defer the conflict resolving to the ublk side.

-- 
Jens Axboe


