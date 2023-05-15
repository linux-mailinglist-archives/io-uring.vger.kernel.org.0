Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611CA703848
	for <lists+io-uring@lfdr.de>; Mon, 15 May 2023 19:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244221AbjEORbR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 May 2023 13:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244230AbjEORag (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 May 2023 13:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9173D132A1
        for <io-uring@vger.kernel.org>; Mon, 15 May 2023 10:27:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B60762D2B
        for <io-uring@vger.kernel.org>; Mon, 15 May 2023 17:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB03C4339B;
        Mon, 15 May 2023 17:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684171670;
        bh=UuSgjjBV4WZVwkj2ylCc5QJeOtjGCuWcDfyxvfN6Jyc=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=A66t/1SjKSKR+Ge/HG8ONJzulN76GKl90Res+/U5i+EdS1N/IUyG3av7qut0Ud3PO
         Yo+KvKKKNOzlWRmpjveLtjDUImbMnOWOxHC0I1wHiNLoIkcftgqmZf+ofKPxGok5vq
         MzR2KVOFSr3Aw59wCOptViQm2oypATYacBdprEqoYHpV4OdX6APldw+0VCELOOlM1d
         ZWo5ej6hhHvNPFfVb9rij8psTHrDqC/M2ClTtK14CpUCaKKGCkk3NU/oVU5WUv/mW1
         YxJdPQbO60BfjVQFGcb+M4s2wV85cXrFzat8p9lYiftoOppulEQ7wl+yKr/Rm5W/5S
         ZK79tMDq6nf/w==
Message-ID: <1d9f84b1-debb-d92a-9f91-4ff9650ef6e0@kernel.org>
Date:   Mon, 15 May 2023 11:27:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/2] net/tcp: don't peek at tail for io_uring zc
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
References: <cover.1684166247.git.asml.silence@gmail.com>
 <d49262a8a39c995cd55f89d1f6fd39cd4346f528.1684166247.git.asml.silence@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <d49262a8a39c995cd55f89d1f6fd39cd4346f528.1684166247.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/15/23 10:06 AM, Pavel Begunkov wrote:
> Move tcp_write_queue_tail() to SOCK_ZEROCOPY specific flag as zerocopy
> setup for msghdr->ubuf_info doesn't need to peek into the last request.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  net/ipv4/tcp.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

