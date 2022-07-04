Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2E2565AB5
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbiGDQNY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 12:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiGDQNX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 12:13:23 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1E2D60;
        Mon,  4 Jul 2022 09:13:22 -0700 (PDT)
Received: from localhost (mtl.collabora.ca [66.171.169.34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: krisman)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 59238660199B;
        Mon,  4 Jul 2022 17:13:21 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656951201;
        bh=t+uFzHKroKd7LCZDAgNyIlWl/re5f8zYmmIAEqz5xvw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HKaTDP/q3ljh3H7aVf/4VoeSNFwt3rkDg5LVOMov53TCEsI6CvynwkZlXbv9Qnqju
         ESv+Pmk8jP1FZcTd+U79D+Yx70rrELtRpTZmUlSIcthai00BK8Iou7CMbUvicd4T37
         Mf2YZtL5xt7vhkpc4Hu4azATRE+Dt8TnXJkp3IjC+6ZYuUfL+kzrGTxDxjFzGB+chD
         /cjuYER5Jv+L4OyRU547fhnYqkr8BY1UzgYjYmtqDrPuzNDlpi2P4VkXPfRaN+xMPw
         GIi920v8xtXfQcnB3fGdLhtQwbuKkwqnPDt3w+4vEOy0mpdO6bMVNzFN3ihbYAw+gY
         VbrK5KM7cok/A==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Organization: Collabora
References: <20220628160807.148853-1-ming.lei@redhat.com>
        <20220628160807.148853-2-ming.lei@redhat.com>
        <da861bbb-1506-7598-fa06-32201456967d@grimberg.me>
        <YsLeR1QWPmqfNAQY@T590>
        <8cf1aef0-ea5b-a3df-266d-ae67674c96ae@grimberg.me>
Date:   Mon, 04 Jul 2022 12:13:18 -0400
In-Reply-To: <8cf1aef0-ea5b-a3df-266d-ae67674c96ae@grimberg.me> (Sagi
        Grimberg's message of "Mon, 4 Jul 2022 17:00:10 +0300")
Message-ID: <87a69oamap.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sagi Grimberg <sagi@grimberg.me> writes:

>>>> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
>>>> index fdb81f2794cd..d218089cdbec 100644
>>>> --- a/drivers/block/Kconfig
>>>> +++ b/drivers/block/Kconfig
>>>> @@ -408,6 +408,12 @@ config BLK_DEV_RBD
>>>>    	  If unsure, say N.
>>>> +config BLK_DEV_UBLK
>>>> +	bool "Userspace block driver"
>>>
>>> Really? why compile this to the kernel and not tristate as loadable
>>> module?
>> So far, this is only one reason: task_work_add() is required, which
>> isn't exported for modules.
>
> So why not exporting it?
> Doesn't seem like a good justification to build it into the kernel.

Sagi,

If I understand correctly, the task_work_add function is quite a core
API that we probably want to avoid exposing directly to (out-of-tree)
modules?  I agree, though, it would be great to have this buildable as a
module for general use cases.  Would it make sense to have it exposed
through a thin built-in wrapper, specific to UBD, which is exported, and
therefore able to invoke that function?  Is it a reasonable approach?

-- 
Gabriel Krisman Bertazi
