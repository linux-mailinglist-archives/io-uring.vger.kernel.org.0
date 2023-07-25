Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F247620B3
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 19:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjGYR6C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Jul 2023 13:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjGYR5z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Jul 2023 13:57:55 -0400
X-Greylist: delayed 81 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Jul 2023 10:57:54 PDT
Received: from out-41.mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792571BE
        for <io-uring@vger.kernel.org>; Tue, 25 Jul 2023 10:57:54 -0700 (PDT)
Message-ID: <87fa06c9-d8a9-fda4-d069-6812605aa10b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690307790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EHcSrzVLuqg7vsezDCAcR+Ts57qI809p7b33W2KdD0w=;
        b=whGT7e5egGQVoPWhvX97cwbVVw3dUoUz9IAVmNp7vYZqlB+Qk/L3M6BbtJSM+iNCmYDXgK
        jKslWJg5b1CpTf7FDTiy7k4Hy4bYDt2Re8klOcz0zUt9+2NcBzW8FJE+zR7yw7KCaf2/tn
        hhr3zdTjr6IvqR+0PIGG8BC9rKzDqEY=
Date:   Tue, 25 Jul 2023 10:56:23 -0700
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Breno Leitao <leitao@debian.org>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, leit@meta.com, bpf@vger.kernel.org,
        ast@kernel.org
References: <20230724142237.358769-1-leitao@debian.org>
 <20230724142237.358769-3-leitao@debian.org> <ZL61cIrQuo92Xzbu@google.com>
 <ZL+VfRiJQqrrLe/9@gmail.com> <ZMAAMKTaKSIKi1RW@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <ZMAAMKTaKSIKi1RW@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/23 10:02 AM, Stanislav Fomichev wrote:
> On 07/25, Breno Leitao wrote:
>> On Mon, Jul 24, 2023 at 10:31:28AM -0700, Stanislav Fomichev wrote:
>>> On 07/24, Breno Leitao wrote:
>>>> Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
>>>> level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
>>>> where a sockptr_t is either userspace or kernel space, and handled as
>>>> such.
>>>>
>>>> Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().
>>>
>>> We probably need to also have bpf bits in the new
>>> io_uring_cmd_getsockopt?

I also think this inconsistency behavior should be avoided.

>>
>> It might be interesting to have the BPF hook for this function as
>> well, but I would like to do it in a following patch, so, I can
>> experiment with it better, if that is OK.
> 
> We are not using io_uring, so fine with me. However, having a way to bypass
> get/setsockopt bpf might be problematic for some other heavy io_uring
> users.
> 
> Lemme CC a bunch of Meta folks explicitly. I'm not sure what that state
> of bpf support in io_uring.

We have use cases on the "cgroup/{g,s}etsockopt". It will be a surprise when the 
user moves from the syscall {g,s}etsockopt to SOCKET_URING_OP_*SOCKOPT and 
figured that the bpf handling is skipped.

