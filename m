Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619A7703CDC
	for <lists+io-uring@lfdr.de>; Mon, 15 May 2023 20:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241904AbjEOSkM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 May 2023 14:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243079AbjEOSkM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 May 2023 14:40:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB58E2709
        for <io-uring@vger.kernel.org>; Mon, 15 May 2023 11:40:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8068C6210F
        for <io-uring@vger.kernel.org>; Mon, 15 May 2023 18:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BA4C433D2;
        Mon, 15 May 2023 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684176009;
        bh=tRuNZav3ZYxTJeh1Boxnqx8CWxDg5z5hL4ZyPET6xT8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mHTaJYZElNX4F2JSQWPlz4++4VHJvlcgFSEGuHDmgMglCQwMXPGKJXgwx9y9TCnSU
         m0gj4EJF3Tbr4UjkqYg08UO5YG9k/9uGrll7cGpjUzwgkpppFKLmkhgs7oV3aAQ+SU
         U1mxOuhXZW4meyshhRZ6m6I2GyW5Ls2LECp6q4K4uU9uiDvrueNU9O+ZIBMPbkKoK+
         J7rfT486SuuHjiY2dqGWfR8OQD1V2IaygwNYeVGt6CZde4JvqoUPnlHSv4WdsiLs9X
         9KTxv19OqLjOMrT+I3evDzwoIzJAvkKK4QAJ69LVQEi/qAh+fbv3TucRp4OtFntSTO
         FTpNZzwz37Urw==
Message-ID: <d7edb614-3758-1df6-91b8-a0cb601137a4@kernel.org>
Date:   Mon, 15 May 2023 12:40:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/2] net/tcp: optimise io_uring zc ubuf
 refcounting
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
References: <cover.1684166247.git.asml.silence@gmail.com>
 <bdbbff06f20c100c00e59932ffecbd18ad699f57.1684166247.git.asml.silence@gmail.com>
 <99faed2d-8ea6-fc85-7f21-e15b24d041f1@kernel.org>
 <CANn89i+Bb7g9uDPVmomNDJivK7CZBYD1UXryxq2VEU77sajqEg@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CANn89i+Bb7g9uDPVmomNDJivK7CZBYD1UXryxq2VEU77sajqEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/15/23 12:14 PM, Eric Dumazet wrote:
> On Mon, May 15, 2023 at 7:29 PM David Ahern <dsahern@kernel.org> wrote:
>>
>> On 5/15/23 10:06 AM, Pavel Begunkov wrote:
>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>> index 40f591f7fce1..3d18e295bb2f 100644
>>> --- a/net/ipv4/tcp.c
>>> +++ b/net/ipv4/tcp.c
>>> @@ -1231,7 +1231,6 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>>       if ((flags & MSG_ZEROCOPY) && size) {
>>>               if (msg->msg_ubuf) {
>>>                       uarg = msg->msg_ubuf;
>>> -                     net_zcopy_get(uarg);
>>>                       zc = sk->sk_route_caps & NETIF_F_SG;
>>>               } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>>>                       skb = tcp_write_queue_tail(sk);
>>> @@ -1458,7 +1457,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>>               tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
>>>       }
>>>  out_nopush:
>>> -     net_zcopy_put(uarg);
>>> +     /* msg->msg_ubuf is pinned by the caller so we don't take extra refs */
>>> +     if (uarg && !msg->msg_ubuf)
>>> +             net_zcopy_put(uarg);
>>>       return copied + copied_syn;
>>>
>>>  do_error:
>>> @@ -1467,7 +1468,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>>       if (copied + copied_syn)
>>>               goto out;
>>>  out_err:
>>> -     net_zcopy_put_abort(uarg, true);
>>> +     /* msg->msg_ubuf is pinned by the caller so we don't take extra refs */
>>> +     if (uarg && !msg->msg_ubuf)
>>> +             net_zcopy_put_abort(uarg, true);
>>>       err = sk_stream_error(sk, flags, err);
>>>       /* make sure we wake any epoll edge trigger waiter */
>>>       if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
>>
>> Both net_zcopy_put_abort and net_zcopy_put have an `if (uarg)` check.
> 
> Right, but here this might avoid a read of msg->msg_ubuf, which might
> be more expensive to fetch.

agreed.

> 
> Compiler will probably remove the second test (uarg) from net_zcopy_put()
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

The one in net_zcopy_put can be removed with the above change. It's
other caller is net_zcopy_put_abort which has already checked uarg is set.
