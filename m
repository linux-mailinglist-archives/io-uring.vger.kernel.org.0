Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901D17892C4
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 02:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjHZAq0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 20:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbjHZAqK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 20:46:10 -0400
Received: from out-249.mta1.migadu.com (out-249.mta1.migadu.com [95.215.58.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDA826B8
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 17:46:02 -0700 (PDT)
Message-ID: <65665aaa-f3c1-123a-c61d-7b128835a1c5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1693010760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nuWctfqYYotL0SbuEIUtNLS1sxkPyQ7nPENsxxNa6iI=;
        b=PmQF2XqfZruoMX7oq1wyyhx2LeS29heyMgGH53kPSk8p8BtMwRy9CSeAd6bLuh4F2h6TAR
        WGe6x7/BXHs/VkqEmkfxNNvHX8zt+CTgme75rsFXFERUBCPRqNvfdH7b7cJtmZvQm8eiKM
        8Q5c6Rkeef4UOT2XsFxG9bxZd89qK3E=
Date:   Fri, 25 Aug 2023 17:45:54 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3 8/9] io_uring/cmd: BPF hook for getsockopt cmd
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>, sdf@google.com,
        axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
References: <20230817145554.892543-1-leitao@debian.org>
 <20230817145554.892543-9-leitao@debian.org> <87pm3l32rk.fsf@suse.de>
 <6ae89b3a-b53d-dd2c-ecc6-1094f9b95586@linux.dev> <ZOjcpmlukOuEmuZ9@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <ZOjcpmlukOuEmuZ9@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/23 9:53 AM, Breno Leitao wrote:
> On Mon, Aug 21, 2023 at 01:25:25PM -0700, Martin KaFai Lau wrote:
>> On 8/17/23 12:08 PM, Gabriel Krisman Bertazi wrote:
>>> Shouldn't you call sock->ops->getsockopt for level!=SOL_SOCKET prior to
>>> running the hook?  Before this patch, it would bail out with EOPNOTSUPP,
>>> but now the bpf hook gets called even for level!=SOL_SOCKET, which
>>> doesn't fit __sys_getsockopt. Am I misreading the code?
>> I agree it should not call into bpf if the io_uring cannot support non
>> SOL_SOCKET optnames. Otherwise, the bpf prog will get different optval and
>> optlen when running in _sys_getsockopt vs io_uring getsockopt (e.g. in
>> regular _sys_getsockopt(SOL_TCP), bpf expects the optval returned from
>> tcp_getsockopt).
>>
>> I think __sys_getsockopt can also be refactored similar to __sys_setsockopt
>> in patch 3. Yes, for non SOL_SOCKET it only supports __user *optval and
>> __user *optlen but may be a WARN_ON_ONCE/BUG_ON(sockpt_is_kernel(optval))
>> can be added before calling ops->getsockopt()? Then this details can be
>> hidden away from the io_uring.
> 
> 
> Right, I've spent some time thinking about it, and this could be done.
> This is a draft I have. Is it what you had in mind?

Yes. lgtm. Thanks.

