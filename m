Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B26074B590
	for <lists+io-uring@lfdr.de>; Fri,  7 Jul 2023 19:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjGGRL6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Jul 2023 13:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjGGRL4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Jul 2023 13:11:56 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EE22696
        for <io-uring@vger.kernel.org>; Fri,  7 Jul 2023 10:11:44 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so25434039f.0
        for <io-uring@vger.kernel.org>; Fri, 07 Jul 2023 10:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1688749904; x=1691341904;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8XwB6FRaSvRVVWlB+iPBaDfSHgTIJ2rhFuwDkZZcuAc=;
        b=y+Rbar6UyJ3sB2i3EiQDFvPEZlD1XwwM5qGJIYmAebRX8uW17ML4xn/N5HnQWt+FAu
         ISMMcTmMYwQYOpjx+Jkq3tKob3NqTQCGC4+XZnR3m70DKUp/6EHt3BK2BzhmCKi1aVOB
         Yeeq+Lx582WcqYKvKth4egDVFkTTKkLDsyjYQuMyePXiUayjZ7GjjxnVceDFC2+LUqT8
         tn6o3iW+b99cLFJBcPaRU0SQp3ynj7srFT13mqPWa5ehk3MfDMbAMbkExjXSfVAKRNox
         Sop+OykcQOeWb9SRVc3YmQv5FtqkZTz6fHpxCPCnZ0zLnpSROjcMHU2XYWxZxuG6x4fQ
         VrMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688749904; x=1691341904;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8XwB6FRaSvRVVWlB+iPBaDfSHgTIJ2rhFuwDkZZcuAc=;
        b=i6yWBdZKGd+tPqx/3rsSVxUL+mAHFG/4TBwg0/h9W6fdhcVtBtHOBLK1/eZoBWQV52
         PKmoELn/L87NaFbQIVbGysKM2k2qwsTKc0zEeDaFE98YpEeRKRxK4ZU9q46HLpVZwJsE
         k4/yW9nsJ5UewH9cTGTkIQjJ1gOxl8jTV1XE5vHGsU9vCQbq6NTuzs7KbjtpFln0jFTd
         yJytg7RxgrUwUoNj9XPdkt6nSRzAdwAo7mJbkAyRlTjgJrBCeXhZbdzxGeGMCcg+IRWD
         FsDwUp0IBeEJIRqkekIFJH0FwCnp8df6gimbLEDd5Q7dwHr94pCUWdeujRK09mfxASUN
         iJRw==
X-Gm-Message-State: ABy/qLZWDPFSBzuNVULIaN5rx0wCIjCjQeXfS5P2k1gj2/zZz5nutltS
        AxIRTIGMm+PmWot5Y02BNvRMrg==
X-Google-Smtp-Source: APBJJlECUNSI/mC1/FFJOdkTSyrb9fFsYRyAPjKS5E/ERQJwe8dWC/ZAF4N/QNTZgPmd/TaDi2S5cA==
X-Received: by 2002:a05:6602:1493:b0:783:6e76:6bc7 with SMTP id a19-20020a056602149300b007836e766bc7mr10257902iow.2.1688749903918;
        Fri, 07 Jul 2023 10:11:43 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e1-20020a05660222c100b00783634b9eafsm1433746ioe.50.2023.07.07.10.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jul 2023 10:11:42 -0700 (PDT)
Message-ID: <968801df-0973-4411-9092-95f272142a81@kernel.dk>
Date:   Fri, 7 Jul 2023 11:11:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v1] io_uring: Use io_schedule* in cqring wait
Content-Language: en-US
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20230707162007.194068-1-andres@anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230707162007.194068-1-andres@anarazel.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/7/23 10:20?AM, Andres Freund wrote:
> I observed poor performance of io_uring compared to synchronous IO. That
> turns out to be caused by deeper CPU idle states entered with io_uring,
> due to io_uring using plain schedule(), whereas synchronous IO uses
> io_schedule().
> 
> The losses due to this are substantial. On my cascade lake workstation,
> t/io_uring from the fio repository e.g. yields regressions between 20%
> and 40% with the following command:
> ./t/io_uring -r 5 -X0 -d 1 -s 1 -c 1 -p 0 -S$use_sync -R 0 /mnt/t2/fio/write.0.0
> 
> This is repeatable with different filesystems, using raw block devices
> and using different block devices.
> 
> Use io_schedule_prepare() / io_schedule_finish() in
> io_cqring_wait_schedule() to address the difference.
> 
> After that using io_uring is on par or surpassing synchronous IO (using
> registered files etc makes it reliably win, but arguably is a less fair
> comparison).
> 
> There are other calls to schedule() in io_uring/, but none immediately
> jump out to be similarly situated, so I did not touch them. Similarly,
> it's possible that mutex_lock_io() should be used, but it's not clear if
> there are cases where that matters.

This looks good to me, and I also separately tested a similar patch and
it showed good results for me even with a heavily performance oriented
setup:

	pread2		io_uring	io_uring w/io_sched
QD1	185K		170K		186K
QD2	NA		304K		327K
QD4	NA		630K		640K
QD8	NA		891K		892K

I'll add this, with just one small minor cosmetic edit:

> @@ -2575,6 +2575,9 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
>  static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  					  struct io_wait_queue *iowq)
>  {
> +	int ret;
> +	int token;

Should just be a single line.

And I'll mark this for stable as well. Thanks!

-- 
Jens Axboe

