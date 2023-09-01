Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC3D78FF73
	for <lists+io-uring@lfdr.de>; Fri,  1 Sep 2023 16:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242378AbjIAOrd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Sep 2023 10:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbjIAOrd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Sep 2023 10:47:33 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E3910CF
        for <io-uring@vger.kernel.org>; Fri,  1 Sep 2023 07:47:30 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-34df35f90d3so1793125ab.0
        for <io-uring@vger.kernel.org>; Fri, 01 Sep 2023 07:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1693579649; x=1694184449; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dx0yV8zW+/BlU9KB3+aKirU26GMdiOGCQTQ3ofD2wVc=;
        b=2iG94+M5s/gk9GeaTcC/rAogc0vTQZvyJkwECgqg1b5x1eAcV1hKHTByq4qNvPSk/s
         jTn9A5BOeqn7zH88cJyDJufCFQD9xD+CjeVfLMDqxED4AOXOchjYB3BGBMT/2GbRnyfF
         Jfy4RUtDcQV5fToG1tK8XZPleWgD6Hjsmn5i7pUV8UqIu3PVQCrfMDyXpUQBHR9C2Inl
         aup+o3W0pY316cI4pJfUeUM81XmP1MgB9Dh7Zkf2y+ARSak0yRc7T3yOMYOE35Rs/OLo
         r0jIkdpWFwQVpv2cQLj9bvuDTiEkUt0BjR7ZM47fxQSTe1238AlUfSD9gd2f9G1+dBOG
         L+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693579649; x=1694184449;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dx0yV8zW+/BlU9KB3+aKirU26GMdiOGCQTQ3ofD2wVc=;
        b=hGx6vbzl9eH3qrWS1fN4Zr/y3m3ckvdRYWtKgaSotL8Uvu0Gck5lotfdCuVFcwlqXz
         icppx8BV+sSKMMRsDIcZfsHu4/IikUS5CqtIl3vLe+zLevbzF8SyJ7oCi2cE/0VoAAGl
         z2KRTjk/QgBlE59fmdh1wqmyUXCo4h/ue01zMCnyE0bG8hvxbuCnb/s+P7kD8KBf7PXH
         UNg2wPVNWebJV/wxT/Ppl9Hu7J6qQFwa9LRfzCU8tp0bv+wKdBZgLwLbsDSOlCbfNM3c
         whi4hm72efZn6i2Xs+dyfGcajQLJhqDPjRXTozsRcfZ7AVR19tuTo/LORzBp22ST3br0
         0Nhg==
X-Gm-Message-State: AOJu0Yynn2i+/Bj7QdnGWYhnhyXFh2YGd+bKGT2QZH/+y+FtlcqWi66R
        deQtuwWX7vaPo4SqBBONInT6gQ==
X-Google-Smtp-Source: AGHT+IFWG/0avtx2qKq67xiMt0buM2aBJcunio6lJ0GPdqpo+Xcy/uUmEHxcuJAZDkZ7wTqYo2kErw==
X-Received: by 2002:a92:c809:0:b0:34c:d535:9f9d with SMTP id v9-20020a92c809000000b0034cd5359f9dmr2613189iln.1.1693579649710;
        Fri, 01 Sep 2023 07:47:29 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id fq3-20020a056638650300b0042b6ae47f0esm1083414jab.108.2023.09.01.07.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Sep 2023 07:47:29 -0700 (PDT)
Message-ID: <78ae000c-5704-4f59-bd2a-79e8cbeb9aaa@kernel.dk>
Date:   Fri, 1 Sep 2023 08:47:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20230901134916.2415386-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230901134916.2415386-1-ming.lei@redhat.com>
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

On 9/1/23 7:49 AM, Ming Lei wrote:
> io_wq_put_and_exit() is called from do_exit(), but all FIXED_FILE requests
> in io_wq aren't canceled in io_uring_cancel_generic() called from do_exit().
> Meantime io_wq IO code path may share resource with normal iopoll code
> path.
> 
> So if any HIPRI request is submittd via io_wq, this request may not get resouce
> for moving on, given iopoll isn't possible in io_wq_put_and_exit().
> 
> The issue can be triggered when terminating 't/io_uring -n4 /dev/nullb0'
> with default null_blk parameters.
> 
> Fix it by always cancelling all requests in io_wq by adding helper of
> io_uring_cancel_wq(), and this way is reasonable because io_wq destroying
> follows canceling requests immediately.

This does look much cleaner, but the unconditional cancel_all == true
makes me a bit nervous in case the ring is being shared.

Do we really need to cancel these bits? Can't we get by with something
trivial like just stopping retrying if the original task is exiting?

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c6d9e4677073..95316c0c3830 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1939,7 +1939,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 		 * If REQ_F_NOWAIT is set, then don't wait or retry with
 		 * poll. -EAGAIN is final for that case.
 		 */
-		if (req->flags & REQ_F_NOWAIT)
+		if (req->flags & REQ_F_NOWAIT || req->task->flags & PF_EXITING)
 			break;
 
 		/*


-- 
Jens Axboe

