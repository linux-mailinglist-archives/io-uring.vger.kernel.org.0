Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757537BE708
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 18:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376910AbjJIQzV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Oct 2023 12:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377245AbjJIQzV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Oct 2023 12:55:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DF8B6;
        Mon,  9 Oct 2023 09:55:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651FEC433C7;
        Mon,  9 Oct 2023 16:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696870519;
        bh=uCPuZaKEt3NJzh5PJgyPXMrlMFoyhf8vOk6Yz5Gt7cI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VL6H9Jke1U64QcENUxuMFocLMSPSbvq3zFxANnsxuh7IWW7VqmLz7vlxYct5KqmbP
         dwl94bXON6MWq/0t7sykpIyMr8Qj5yecUn0pn/u6l7nTYDh57oiYiYl6DUgI9mUhlr
         8cLb9VDcasJ5VnmCh7DRMEQT0W+u3il6CAmEgIt9ZuP5MYqWdYndS4Q79LAO8Fk8tW
         l8L84gkOYM5BzZKIJOA8XEYudBTFNG1MOgab3a/xyntxqOqEqtLt+LDhOuzOyirFat
         V5PLNx98FcjTM0EV/TXJPWpngv8j/5YNcOcnpmHNezBS52k+8udOprlpejUOxssSsS
         5kCzQQyC8zwyA==
Date:   Mon, 9 Oct 2023 09:55:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Breno Leitao <leitao@debian.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>, sdf@google.com,
        axboe@kernel.dk, asml.silence@gmail.com, martin.lau@linux.dev,
        krisman@suse.de, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v4 00/10] io_uring: Initial support for {s,g}etsockopt
 commands
Message-ID: <20231009095518.288a5573@kernel.org>
In-Reply-To: <ZSP/4GVaQiFuDizz@gmail.com>
References: <20230904162504.1356068-1-leitao@debian.org>
        <20230905154951.0d0d3962@kernel.org>
        <ZSArfLaaGcfd8LH8@gmail.com>
        <CAF=yD-Lr3238obe-_omnPBvgdv2NLvdK5be-5F7YyV3H7BkhSg@mail.gmail.com>
        <ZSP/4GVaQiFuDizz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 9 Oct 2023 06:28:00 -0700 Breno Leitao wrote:
> Correct. The current discussion is only related to optlen in the
> getsockopt() callbacks (invoked when level != SOL_SOCKET). Everything
> else (getsockopt(level=SOL_SOCKET..) and setsockopt) is using sockptr.
> 
> Is it bad if we review/merge this code as is (using sockptr), and start
> the iov_iter/getsockopt() refactor in a follow-up thread?

Sorry for the delay, I only looked at the code now :S
Agreed, that there's no need to worry about the sockptr spread
in this series. It looks good to go in.
