Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13716E23F9
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 15:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjDNNCD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 09:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjDNNCB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 09:02:01 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8B85B93
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 06:01:57 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gc14so274386ejc.5
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 06:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681477316; x=1684069316;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uXNjzbwtJPZLGNjMn1SV1AA4Fngym2mRkrDjWLDs2CI=;
        b=d4xqRH6/DoBuhoM5ThkxUgkEI80KMtLbQYPyjbDZfpfBrzsEVGOZXy1AdJ5NmhPFPQ
         AaSI7KuTUoNPLZ9ZjwS21NlKLcqCQAFbggI8Z2n/VA0FGzSsqzvIA+OFrqkUdA26onbd
         Jyq1po0cGPM0sX3AVYLs5Dlyn6oTWKkoYKOnWgTVyHQId8CfJD5pxs+kz/S1wh3fQoJR
         i+wwea2QBm8aUCUAa/iXu6KZFDcVwmMPQd7jTx9Co65qoVwj7vNJuWtWh/GSSNgAAbyo
         YxERNsAqJJPfhQS/jRjSwdzC7ZOQq2b5w55bWOxg+AYzW2UxH9NfYLZrREumUAeE3gVq
         GV+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681477316; x=1684069316;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uXNjzbwtJPZLGNjMn1SV1AA4Fngym2mRkrDjWLDs2CI=;
        b=SgpwvB8se11qKu42aRF4gT0Wk5mbwyjAB6V5F/sapVOn3wJjm7v8ymXNhQpH1bk93r
         rgWvTdz0MstUjTIrKXl+je4DaeYycPTgD4fOFi87FnMOEgxXB7hjKyY1pO32dtxwqNUF
         nPPklS2t2JmZPQU8Js6EYP7vGzYLmWkgnklic3LxEIuEPEmTJkSMP/BlkSQPmmyrGkm7
         zD64HgmQr0mzEqDC8Q0nfeVPt4/fbzMLxmAQuHd2fD2ZZnidaeMgAyQRfHnGVxjld6rp
         SoLDPj9sz1gCJurVSVka0CC4ogcyL0uilTvUyYxgqFvLUV4Ppv4kZy6Nj2KBMKCuad0U
         SykQ==
X-Gm-Message-State: AAQBX9dftAxOXLZQERIwIQ/rAW6OIyqPJXjxKMPoS/4h2Aw3RcdOpOH1
        ee3l0kUOo6mZPMGgDDc6uNs=
X-Google-Smtp-Source: AKy350ZdLtAAWagBc9zdTSGq4MoKksrjD3hDf1qHHP5JH7w1TTV2wm3Gl/YXQ6Xdzs7KSe8wycJ26Q==
X-Received: by 2002:a17:907:720c:b0:94a:4739:bed9 with SMTP id dr12-20020a170907720c00b0094a4739bed9mr5726951ejc.13.1681477316125;
        Fri, 14 Apr 2023 06:01:56 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:5dfa])
        by smtp.gmail.com with ESMTPSA id le9-20020a170907170900b0094ef10eceb3sm520567ejc.185.2023.04.14.06.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 06:01:55 -0700 (PDT)
Message-ID: <68ddddc0-fb0e-47b4-9318-9dd549d851a1@gmail.com>
Date:   Fri, 14 Apr 2023 14:01:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] io_uring: complete request via task work in case of
 DEFER_TASKRUN
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Kanchan Joshi <joshi.k@samsung.com>
References: <20230414075313.373263-1-ming.lei@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230414075313.373263-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/14/23 08:53, Ming Lei wrote:
> So far io_req_complete_post() only covers DEFER_TASKRUN by completing
> request via task work when the request is completed from IOWQ.
> 
> However, uring command could be completed from any context, and if io
> uring is setup with DEFER_TASKRUN, the command is required to be
> completed from current context, otherwise wait on IORING_ENTER_GETEVENTS
> can't be wakeup, and may hang forever.

fwiw, there is one legit exception, when the task is half dead
task_work will be executed by a kthread. It should be fine as it
locks the ctx down, but I can't help but wonder whether it's only
ublk_cancel_queue() affected or there are more places in ublk?

One more thing, cmds should not be setting issue_flags but only
forwarding what the core io_uring code passed, it'll get tons of
bugs in no time otherwise.

static void ublk_cancel_queue(struct ublk_queue *ubq)
{
     ...
     io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0,
                       IO_URING_F_UNLOCKED);
}

Can we replace it with task_work? It should be cold, and I
assume ublk_cancel_queue() doesn't assume that all requests will
put down by the end of the function as io_uring_cmd_done()
can offload it in any case.

-- 
Pavel Begunkov
