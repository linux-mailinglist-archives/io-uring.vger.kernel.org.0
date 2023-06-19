Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C11735BF6
	for <lists+io-uring@lfdr.de>; Mon, 19 Jun 2023 18:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjFSQNB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jun 2023 12:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjFSQNA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jun 2023 12:13:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E975A2;
        Mon, 19 Jun 2023 09:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE5DD60D30;
        Mon, 19 Jun 2023 16:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC27CC433C0;
        Mon, 19 Jun 2023 16:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687191178;
        bh=/H6FT3FrmV0NJ8VWtFxL0MtU2bSU6n73mHMPI4XRQBE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=AMT5ndmgubCl23aIo/nslz/83VJoyve6t1E7pDI6/gvbGLCGEeffTuifbdDruLHnw
         /ZavuMYavxaQvsrl4Z7lJ3hIVyzoV/Yija9MfeosJqe2JJb5Fpk7jUW+jheAw193/f
         a+zX4Q8als5VJohEMnSGRu96dNhsX47Ow+96ej/XH6EAgw/Jom+Wnhf4j6e3eDHh43
         kyomnYLtcLz4LCgssPyWNZe0DELwCVJ6iKrbUTGu7BD4hCybUfag8OcQSWN50eczp7
         qq7lFI+Absa8n68blhi7JegCSxKbT9bBkVMdXbTvXqtH/zp7BtzAMlojViKcSVYZz0
         9vD/P0wNcndWw==
Message-ID: <f9a85fcc-33e3-b47b-9c32-1d680edadcf8@kernel.org>
Date:   Mon, 19 Jun 2023 09:12:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [RFC PATCH v2 1/4] net: wire up support for
 file_operations->uring_cmd()
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, axboe@kernel.dk,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <martineau@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>, leit@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-sctp@vger.kernel.org, ast@kernel.org, kuniyu@amazon.com,
        martin.lau@kernel.org, Jason Xing <kernelxing@tencent.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Willem de Bruijn <willemb@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        Andrea Righi <andrea.righi@canonical.com>
References: <20230614110757.3689731-1-leitao@debian.org>
 <20230614110757.3689731-2-leitao@debian.org>
 <6b5e5988-3dc7-f5d6-e447-397696c0d533@kernel.org>
 <ZJA6AwbRWtSiJ5pL@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <ZJA6AwbRWtSiJ5pL@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/23 4:20 AM, Breno Leitao wrote:
> On Wed, Jun 14, 2023 at 08:15:10AM -0700, David Ahern wrote:
>> On 6/14/23 5:07 AM, Breno Leitao wrote:
>> io_uring is just another in-kernel user of sockets. There is no reason
>> for io_uring references to be in core net code. It should be using
>> exposed in-kernel APIs and doing any translation of its op codes in
>> io_uring/  code.
> Thanks for the feedback. If we want to keep the network subsystem
> untouched, then I we can do it using an approach similar to the
> following. Is this a better approach moving forward?

yes. It keeps the translation from io_uring commands to networking APIs
in one place and does not need to propagate that translation through the
networking code.
