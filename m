Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B157CECB3
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 02:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjJSAUs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Oct 2023 20:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSAUr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Oct 2023 20:20:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29356FE;
        Wed, 18 Oct 2023 17:20:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7E5C433C7;
        Thu, 19 Oct 2023 00:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697674845;
        bh=6mkAdLVLxxj7Xv3eDlTxWghk2v1vUqjiipEg5azs62c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oi1nzjBsLq/buGnHUgogCnUHbtfYpxvg1o0LSse9LWwgv13hdLFVVu9aGGox2h4XW
         YNly5QO5nO3SivjfcEJ/VTeY/Ma/dodZxNG7w7knPmc0rdSUSCCmRrLKLxRnFiTVtD
         UIhe0o4KuM+2GtuNE5vtZX7/O0V35JLAEuYXyit0N2byQIDWYiCwH+9jOTv9Oluddr
         8OpbNuvxLYXVx3Fiq+DHt6IEehmRu7sjZqX3o46MWrGbjvoGkssKp68P+cgo0VY8Q5
         KwE8LFj0hXTRMkWDxO82S7abZbu4PS7hdxoZ+QcjVTByhhobpMY9B+PomZKoc9Qzgp
         2VWb41EQeOC8w==
Date:   Wed, 18 Oct 2023 17:20:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, pabeni@redhat.com,
        martin.lau@linux.dev, krisman@suse.de,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v7 04/11] net/socket: Break down __sys_getsockopt
Message-ID: <20231018172044.008dab81@kernel.org>
In-Reply-To: <20231016134750.1381153-5-leitao@debian.org>
References: <20231016134750.1381153-1-leitao@debian.org>
        <20231016134750.1381153-5-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 16 Oct 2023 06:47:42 -0700 Breno Leitao wrote:
> Split __sys_getsockopt() into two functions by removing the core
> logic into a sub-function (do_sock_getsockopt()). This will avoid
> code duplication when doing the same operation in other callers, for
> instance.
> 
> do_sock_getsockopt() will be called by io_uring getsockopt() command
> operation in the following patch.
> 
> The same was done for the setsockopt pair.

Acked-by: Jakub Kicinski <kuba@kernel.org>
