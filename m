Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046BF4DDC3E
	for <lists+io-uring@lfdr.de>; Fri, 18 Mar 2022 15:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237598AbiCROz0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Mar 2022 10:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237623AbiCROzY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Mar 2022 10:55:24 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC48DE93A
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 07:54:04 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id r2so6004612ilh.0
        for <io-uring@vger.kernel.org>; Fri, 18 Mar 2022 07:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=lINmNqs9wbmd41ptGIgKzVWYpq/vQRszGJtDOZ+F6h4=;
        b=BST9kOTtnBJFld40ylgHviiSyRMCCblL7/IDa3jzk04zqRwyE9K/MR6qtl5OZaK+Of
         rbmXQmL9p5UlL/PRo6w+lT9Br/ez9hj/I3yPbJm68TPfvlhPgA/PGAPyMxIrMq7ObrJt
         8qD7CfNn4TagprmL/kiRts2zkgm8UHrICSNrmcmKqiGbjQtqP9M7PLQe1A0Yy3mV72/Y
         I3b4X04Xou6TAGv+1X1EwJsCwqmBcolssP5+HbDaaca9kUXWqqDbvxIRKB5eThJL8Wm5
         KcTtjHJey+LXkVoKdhj5BXy1rgN3Es7fGrXTScVYFUJ5w6XxX8Z4Rc80BJ0uv1t97Zjy
         FNrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lINmNqs9wbmd41ptGIgKzVWYpq/vQRszGJtDOZ+F6h4=;
        b=C3gAkCg2I74MS4AHD59YuRCxHkqxRs+M7Z96M1hWo9hqMqtONVoYfKlcaTKm/jb610
         NkcBrCRS78jJD3WujZvHvuPEmXataaol84Nui3Sk1vGTg7hty7Q+P+ScHXc8+BQi03gk
         2LghY+nHov300MbqjCD4piPxKrMfr4q6CPDU3+9vNwGHsJbNqdjPR7o9JUEvYsvHzaA4
         +jXi+E9BgmQ2EHjEiFlGhI3gNNJdoncvoZY0G7NbhqttAMzp8/cKTungYRKeWohotL31
         ejeKRRBmMtMd365bJ7pFOBrSLREuu6emtOkUlgGzFZWnHFj4+1CK7cYdNAJ+Yp4mHjcu
         Xtkw==
X-Gm-Message-State: AOAM533+hx9BesLKEx6TSUrVEFxnZe8dyUU1TM9QrOSJsY8VDzhJQx8G
        gRgyo9lU4zGpU0aSl+LmIEeZKqxu6W6vWqpc
X-Google-Smtp-Source: ABdhPJw03hlPMOh32e2AfNiQAb7ZhqPsMszfBK591pAjrhD9d8syVyOH6+9Ys6LKNjaajWzz4hUFww==
X-Received: by 2002:a05:6e02:20c5:b0:2c6:14c9:35dd with SMTP id 5-20020a056e0220c500b002c614c935ddmr4470594ilq.129.1647615244010;
        Fri, 18 Mar 2022 07:54:04 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d7-20020a5d9bc7000000b0064920e7b430sm4579835ion.32.2022.03.18.07.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 07:54:03 -0700 (PDT)
Message-ID: <3530662a-0ae0-996c-79ee-cc4db39b965a@kernel.dk>
Date:   Fri, 18 Mar 2022 08:54:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 4/4] io_uring: optimise compl locking for non-shared rings
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1647610155.git.asml.silence@gmail.com>
 <9c91a7dc445420230f7936d7f913eb212c1c07a3.1647610155.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9c91a7dc445420230f7936d7f913eb212c1c07a3.1647610155.git.asml.silence@gmail.com>
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

On 3/18/22 7:52 AM, Pavel Begunkov wrote:
> When only one task submits requests, most of CQEs are expected to be
> filled from that task context so we have natural serialisation. That
> would mean that in those cases we don't need spinlocking around CQE
> posting. One downside is that it also mean that io-wq workers can't emit
> CQEs directly but should do it through the original task context using
> task_works. That may hurt latency and performance and might matter much
> to some workloads, but it's not a huge deal in general as io-wq is a
> slow path and there is some additional merit from tw completion
> batching.

Not too worried about io-wq task_work for cq filling, it is the slower
path after all. And I think we can get away with doing notifications as
it's just for CQ filling. If the task is currently waiting in
cqring_wait, then it'll get woken anyway and it will process task work.
If it's in userspace, it doesn't need a notification. That should make
it somewhat lighter than requiring using TIF_NOTIFY_SIGNAL for that.

> The feature should be opted-in by the userspace by setting a new
> IORING_SETUP_PRIVATE_CQ flag. It doesn't work with IOPOLL, and also for
> now only the task that created a ring can submit requests to it.

I know this is a WIP, but why do we need CQ_PRIVATE? And this needs to
work with registered files (and ring fd) as that is probably a bigger
win than skipping the completion_lock if you're not shared anyway.


-- 
Jens Axboe

