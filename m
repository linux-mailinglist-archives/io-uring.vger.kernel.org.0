Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038A9550C81
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 20:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiFSSS5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 14:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbiFSSSz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 14:18:55 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9BE5594
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 11:18:53 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g186so8381513pgc.1
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 11:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=eHv58w9xKkzjcrXhXl6pXa4M8O9B53uhLcRxJq6SAxI=;
        b=iX2VQa79GXwR1f9qq5m/y1YnDC7dk7S8KKsrQdip4xSqSDoVlaEdzFNBZfBdiaxEcE
         mX8BumKUWulkcaDmFHnui0XSxA/2Q18FlSfnnY4IEhssjTfDfVWPQcNGBpD2TRy04ja2
         4Mev6AQIMZqkTODxTvDhy7DbisWM/EvbHaC2JbN934kxqMgYhguZ3jg67WxGwFJvRr/P
         6d6NtLpx7ovs2Bri8muXEFsAjJFJgh3+N7bKyUBSsrylml57w2yt1s7qxxeA88a7a7Bn
         OSYZM/kgOABqW1cLiFuUIDeXEnSbQD/oVwo2tK+rJA630KgksctxPzelP0ZBmNI2qJCX
         DR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=eHv58w9xKkzjcrXhXl6pXa4M8O9B53uhLcRxJq6SAxI=;
        b=coDrrNdQ6ixaHDYNfxJt/jv1mr3MiUq31IOFh55ICmAiEOqKtwFVxJxpWRr9XUdPGx
         TUsYMKSdQoJqMzx8Nte1Y7WTPFl+l07GdatZMmaZUoeIYZFEVE9AfIkzC0LbBvF3MRsz
         XCXer1T3aX2xmWIv97dVclLnnxnkAHBiB4NXd1SN7g3OAargJO4h9KUJZPYCoFuBwZww
         iHoQQYMhZI7PJsbBa2ht05XbkYO28QbMkaDMFdSNGmGYtQjlyMffpwZkK+q0ut8diFlT
         A69eLObRDiBxL9tXpL9zkI3XUCxmqz9byLaa6MF/0I2RtHHsaKRKxXN6JtwLXztB8egW
         px8Q==
X-Gm-Message-State: AJIora+dNMRv97kCQRNet9qN0yA2+IloHeSFjWygeXrqzJa/0nFSQzYa
        wHBkVxqi4zX4+xN34RjmX4YspZgN79J9eg==
X-Google-Smtp-Source: AGRyM1sKjf/Tqxy5Nv6oMMxo6PKGBTfLDqUiJd/UMWRYwhVRx3tVf9uT0xrp308+r1637m2Pn5m4XQ==
X-Received: by 2002:a63:cd52:0:b0:3fe:30ec:825d with SMTP id a18-20020a63cd52000000b003fe30ec825dmr18423271pgj.82.1655662732764;
        Sun, 19 Jun 2022 11:18:52 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c10-20020aa7952a000000b0050dc762819esm2208756pfp.120.2022.06.19.11.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 11:18:52 -0700 (PDT)
Message-ID: <93f51361-c198-0286-b0ea-3b30f684f633@kernel.dk>
Date:   Sun, 19 Jun 2022 12:18:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH for-next 4/7] io_uring: hide eventfd assumptions in evenfd
 paths
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "Pavel Begunkov (Silence)" <asml.silence@gmail.com>
References: <cover.1655637157.git.asml.silence@gmail.com>
 <8ac7fbe5ad880990ef498fa09f8de70390836f97.1655637157.git.asml.silence@gmail.com>
Content-Language: en-US
In-Reply-To: <8ac7fbe5ad880990ef498fa09f8de70390836f97.1655637157.git.asml.silence@gmail.com>
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

On Sun, Jun 19, 2022 at 5:26 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> Some io_uring-eventfd users assume that there won't be spurious wakeups.
> That assumption has to be honoured by all io_cqring_ev_posted() callers,
> which is inconvenient and from time to time leads to problems but should
> be maintained to not break the userspace.
>
> Instead of making the callers to track whether a CQE was posted or not,
> hide it inside io_eventfd_signal(). It saves ->cached_cq_tail it saw
> last time and triggers the eventfd only when ->cached_cq_tail changed
> since then.

This one is causing frequent errors with poll-cancel.t:

axboe@m1pro-kvm ~/g/liburing (master)> test/poll-cancel.t
axboe@m1pro-kvm ~/g/liburing (master)> test/poll-cancel.t
Timed out!
axboe@m1pro-kvm ~/g/liburing (master) [1]> test/poll-cancel.t
Timed out!
axboe@m1pro-kvm ~/g/liburing (master) [1]> test/poll-cancel.t
Timed out!

I've dropped this one, and 6-7/7 as they then also throw a bunch of
rejects.

-- 
Jens Axboe

