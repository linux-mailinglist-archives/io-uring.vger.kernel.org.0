Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A150774497
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 20:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbjHHSYE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 14:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbjHHSXk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 14:23:40 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470AE7EE4
        for <io-uring@vger.kernel.org>; Tue,  8 Aug 2023 10:35:11 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-55c7bb27977so6011867a12.0
        for <io-uring@vger.kernel.org>; Tue, 08 Aug 2023 10:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691516111; x=1692120911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CbNixERlHqS43p9WnetIfE1bwp3ZFaI202y6cxjDISk=;
        b=BtYnibgAq7g0L/okVpcz1sm6OulXBZOLXW68YAi0kE94x5HCN7bWDWiYRWfi91svGo
         Xc79qQ233j8gXgGltAV/J8/uXgNtnFjybeQZD1f/61BdCanNXGvF03sIBuo0PLfw2n8V
         M74JpyhSFxtW15aRUBl8P3VcNB0wjFg/9n39VGQsWXzGFLdytSDGhhjl7u1Z6CtvJuZN
         /eAqJk8ulH9QCYWJViD5t8z1c0a8y4LlJj9wtw/p4CWVORUdKTqp/wxHXBJvv2h+a/vL
         8rWrgpPqCe+14Q5CE8cj3cirPO2rMueXgtfqCD0+VzHSYfmiNnwNXQhCV4TlIpQyV+Ie
         Hl0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691516111; x=1692120911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CbNixERlHqS43p9WnetIfE1bwp3ZFaI202y6cxjDISk=;
        b=ADeuJBwQdgosH/rewzZPAwP17hjNDYtlG2MEzF9iO354otF4/4WGyztkKU1Ct6URMl
         h+XD2nFd8R1P4O7zG0Z8P0fdnVnm771+RTk9IgyTf0M8CxxvtOTutNC9x27rRAFTMIVo
         84LQGBps588AvH2KBV7JAnvtxhGs4eRXlyf1GnG5Bo96ZfM56R3NBQd1M4X8sMebyEZQ
         hC1ej2XttIz+fX5+WNt4KudAtCtV5n2jTCPYp9DOcTxpMSMcv1+s5qy9wTzZxTwTh670
         pwO9SV7+CY4yg/6dRLq8ztB8bajjJbdNVSAhvluZoVKc0Z0TWkYX7u9Ph6q6NfoSX6qz
         YhmQ==
X-Gm-Message-State: AOJu0Yys3yy8fCYycQeLUIZEmBOi6Ucbd5eAhIcz7+eH6GIKeTU3w2Yt
        gTaC59Gx26JTNDnR8+Wk5On4NHw=
X-Google-Smtp-Source: AGHT+IHneZnuNzdmec4p8IMznIadt3gvRYK8ETNwHwQuhWBeUw0E2l7zTwuivbDYUrt8/txQeEEsw9g=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a63:3443:0:b0:564:41a2:8d5a with SMTP id
 b64-20020a633443000000b0056441a28d5amr732pga.11.1691516110738; Tue, 08 Aug
 2023 10:35:10 -0700 (PDT)
Date:   Tue, 8 Aug 2023 10:35:08 -0700
In-Reply-To: <20230808134049.1407498-1-leitao@debian.org>
Mime-Version: 1.0
References: <20230808134049.1407498-1-leitao@debian.org>
Message-ID: <ZNJ8zGcYClv/VCwG@google.com>
Subject: Re: [PATCH v2 0/8] io_uring: Initial support for {s,g}etsockopt commands
From:   Stanislav Fomichev <sdf@google.com>
To:     Breno Leitao <leitao@debian.org>
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/08, Breno Leitao wrote:
> This patchset adds support for getsockopt (SOCKET_URING_OP_GETSOCKOPT)
> and setsockopt (SOCKET_URING_OP_SETSOCKOPT) in io_uring commands.
> SOCKET_URING_OP_SETSOCKOPT implements generic case, covering all levels
> nad optnames. On the other hand, SOCKET_URING_OP_GETSOCKOPT just
> implements level SOL_SOCKET case, which seems to be the
> most common level parameter for get/setsockopt(2).
> 
> struct proto_ops->setsockopt() uses sockptr instead of userspace
> pointers, which makes it easy to bind to io_uring. Unfortunately
> proto_ops->getsockopt() callback uses userspace pointers, except for
> SOL_SOCKET, which is handled by sk_getsockopt(). Thus, this patchset
> leverages sk_getsockopt() to imlpement the SOCKET_URING_OP_GETSOCKOPT
> case.
> 
> In order to support BPF hooks, I modified the hooks to use  sockptr, so,
> it is flexible enough to accept user or kernel pointers for
> optval/optlen.
> 
> PS1: For getsockopt command, the optlen field is not a userspace
> pointers, but an absolute value, so this is slightly different from
> getsockopt(2) behaviour. The new optlen value is returned in cqe->res.
> 
> PS2: The userspace pointers need to be alive until the operation is
> completed.
> 
> These changes were tested with a new test[1] in liburing. On the BPF
> side, I tested that no regression was introduced by running "test_progs"
> self test using "sockopt" test case.
> 
> [1] Link: https://github.com/leitao/liburing/blob/getsock/test/socket-getsetsock-cmd.c
> 
> RFC -> V1:
> 	* Copy user memory at io_uring subsystem, and call proto_ops
> 	  callbacks using kernel memory
> 	* Implement all the cases for SOCKET_URING_OP_SETSOCKOPT

I did a quick pass, will take a close look later today. So far everything makes
sense to me.

Should we properly test it as well?
We have tools/testing/selftests/bpf/prog_tests/sockopt.c which does
most of the sanity checks, but it uses regular socket/{g,s}etsockopt
syscalls. Seems like it should be pretty easy to extend this with
io_uring path? tools/testing/selftests/net/io_uring_zerocopy_tx.c
already implements minimal wrappers which we can most likely borrow.
