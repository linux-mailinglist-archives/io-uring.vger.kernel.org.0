Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7467D7D04E3
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 00:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235549AbjJSWcv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 18:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbjJSWcu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 18:32:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBA3112
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 15:32:48 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-2739c8862d2so52157a91.1
        for <io-uring@vger.kernel.org>; Thu, 19 Oct 2023 15:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697754768; x=1698359568; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C9wnji3YaS9irlPkF3wDSQFwZd05C0l2XjGrw5lrmIw=;
        b=a/fzUhvRMEn3G+ozbo4OcCgGpc0yzqUyyXD/i8zQLAEDLdIk9PnFBx85bz+gvz4jhc
         +6bir8D1nnBJpgAtry27GVh+dCtxL4NRUksvYe7DcRp4IPD/8SaKxpPrSKJMR79SuVhu
         EZo7nQbwYPy81O4KN/sMf5GoHauELhTOCkTvnWni4qAU0r7S6p6DOHdpVFBsfqWC+sJ2
         ITMGNJrO4CvDEE850VLL0dMZaARU1glZ26BU24COd8zfHKPLOb5+AAFfNfNQE4BEWukd
         0FUNr/RfYsEKTMgq+6UinY2KvlxjIfkkBNSkoWwus/yDlF7dKfhNdmBNJExhybFZq/WP
         dAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697754768; x=1698359568;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C9wnji3YaS9irlPkF3wDSQFwZd05C0l2XjGrw5lrmIw=;
        b=GDmQAwimlk9ch9AcBA8mF59AheOV+JMSPtlF5NlnndjQzM2qZKAtINpDxUMLrxTAIF
         Tbi7EJ2wA2rTO1h+wE2OEdvmhYq8/7tfyMIwdpR6ykGKZ0LgQCYzKHhWmOE2rhaMfMvR
         qaiET+j7CqKZWFL2ic0fWvEx6MHontCqmWwcdxAFgv1BEZVOUgKhfSY3YlccflzEeb+J
         6Y5LDznM9ZFKkSAYR/6mTwauyQOsJc4QviFWgU75qC6x2wbevA2jTo+Qh+bzBR5bbKb5
         zRXdAIGgXDFHoGWe8yWIEr25vgcT1tqszAfynD86AWnVqncgh8V6kRKqtDu7lmnb+Po6
         tAnw==
X-Gm-Message-State: AOJu0Yz9cQFAnzCi1p6Tc8NpFOwfLf/RUwebVMu2kZ5W6Ne2dVrUoM/H
        uvotRAfdR15EBaYEXRfhM3Govg==
X-Google-Smtp-Source: AGHT+IEiTkcCO/C73rqUdmAkWSaVaHwjlJ20CRmaKdlpvFzLk9ujQBxNeUSPoU2RLhgX50XC1bpFmA==
X-Received: by 2002:a05:6a20:8f03:b0:13f:65ca:52a2 with SMTP id b3-20020a056a208f0300b0013f65ca52a2mr136316pzk.5.1697754768007;
        Thu, 19 Oct 2023 15:32:48 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id r19-20020a632053000000b005b18c53d73csm251027pgm.16.2023.10.19.15.32.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Oct 2023 15:32:47 -0700 (PDT)
Message-ID: <6fb87516-c833-4af2-8cab-60c9accbcd1f@kernel.dk>
Date:   Thu, 19 Oct 2023 16:32:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/11] net/socket: Break down __sys_getsockopt
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Breno Leitao <leitao@debian.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        David Howells <dhowells@redhat.com>, sdf@google.com,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com,
        kuba@kernel.org, pabeni@redhat.com, krisman@suse.de,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20231016134750.1381153-1-leitao@debian.org>
 <20231016134750.1381153-5-leitao@debian.org>
 <1074c1f1-e676-fbe6-04bc-783821d746a1@linux.dev>
 <e1920ac4-18ad-4b97-a3a3-9604724937d6@kernel.dk>
 <21dc6507-e1f5-a261-7a9c-7e0cb22e1fc7@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <21dc6507-e1f5-a261-7a9c-7e0cb22e1fc7@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/23 2:37 PM, Martin KaFai Lau wrote:
> On 10/19/23 1:04?PM, Jens Axboe wrote:
>> On 10/19/23 1:12 PM, Martin KaFai Lau wrote:
>>> On 10/16/23 6:47?AM, Breno Leitao wrote:
>>>> diff --git a/net/socket.c b/net/socket.c
>>>> index 0087f8c071e7..f4c156a1987e 100644
>>>> --- a/net/socket.c
>>>> +++ b/net/socket.c
>>>> @@ -2350,6 +2350,42 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
>>>>    INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
>>>>                                 int optname));
>>>>    +int do_sock_getsockopt(struct socket *sock, bool compat, int level,
>>>> +               int optname, sockptr_t optval, sockptr_t optlen)
>>>> +{
>>>> +    int max_optlen __maybe_unused;
>>>> +    const struct proto_ops *ops;
>>>> +    int err;
>>>> +
>>>> +    err = security_socket_getsockopt(sock, level, optname);
>>>> +    if (err)
>>>> +        return err;
>>>> +
>>>> +    ops = READ_ONCE(sock->ops);
>>>> +    if (level == SOL_SOCKET) {
>>>> +        err = sk_getsockopt(sock->sk, level, optname, optval, optlen);
>>>> +    } else if (unlikely(!ops->getsockopt)) {
>>>> +        err = -EOPNOTSUPP;
>>>> +    } else {
>>>> +        if (WARN_ONCE(optval.is_kernel || optlen.is_kernel,
>>>> +                  "Invalid argument type"))
>>>> +            return -EOPNOTSUPP;
>>>> +
>>>> +        err = ops->getsockopt(sock, level, optname, optval.user,
>>>> +                      optlen.user);
>>>> +    }
>>>> +
>>>> +    if (!compat) {
>>>> +        max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
>>>
>>> The max_optlen was done before the above sk_getsockopt. The bpf CI cannot catch it because it cannot apply patch 5 cleanly. I ran the following out of the linux-block tree:
>>>
>>> $> ./test_progs -t sockopt_sk
>>> test_sockopt_sk:PASS:join_cgroup /sockopt_sk 0 nsec
>>> run_test:PASS:skel_load 0 nsec
>>> run_test:PASS:setsockopt_link 0 nsec
>>> run_test:PASS:getsockopt_link 0 nsec
>>> (/data/users/kafai/fb-kernel/linux/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c:111: errno: Operation not permitted) Failed to call getsockopt, ret=-1
>>> run_test:FAIL:getsetsockopt unexpected error: -1 (errno 1)
>>> #217     sockopt_sk:FAIL
>>
>> Does it work with this incremental? I can fold that in, will rebase
>> anyway to collect acks.
> 
> Yes, that should work.
> 
> Acked-by: Martin KaFai Lau <martin.lau@kernel.org>

Thanks Martin, I'll add that too.

-- 
Jens Axboe

